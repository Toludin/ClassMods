--
-- ClassMods - crowd control module
--

if (select(2, UnitClass("player")) == "WARRIOR") then return end

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

local function stopCCTimer(spellID, targetGUID)
	for i=1,4 do
		if (ClassMods.F.CrowdControl.ccFrame[i].active == true) and (ClassMods.F.CrowdControl.ccFrame[i].spellID == spellID) and (ClassMods.F.CrowdControl.ccFrame[i].guid == targetGUID) then
			ClassMods.F.CrowdControl.ccFrame[i]:SetAlpha(0)
			ClassMods.F.CrowdControl.ccFrame[i].guid = 0
			ClassMods.F.CrowdControl.ccFrame[i].spellID = 0
			ClassMods.F.CrowdControl.ccFrame[i].active = false
			ClassMods.F.CrowdControl.ccFrame[i].killtime = 0

			if ClassMods.F.CrowdControl.ccFrame[i].timer then
				ClassMods.F.CrowdControl.ccFrame[i].timer.enabled = nil
				ClassMods.F.CrowdControl.ccFrame[i].timer:Hide()
			end

			break -- Found the right one, stop the loop
		end
	end
end

local function addCCTimer(spellID, targetGUID, expireTime)
	for i=1,4 do
		if (ClassMods.F.CrowdControl.ccFrame[i].active == false) then
			ClassMods.F.CrowdControl.ccFrame[i].Icon:ClearAllPoints()
			ClassMods.F.CrowdControl.ccFrame[i].Icon:SetAllPoints(ClassMods.F.CrowdControl.ccFrame[i])
			ClassMods.F.CrowdControl.ccFrame[i].Icon:SetTexture(select(3, GetSpellInfo(spellID) ))

			if ClassMods.db.profile.crowdcontrol.enabletexcoords then
				ClassMods.F.CrowdControl.ccFrame[i].Icon:SetTexCoord(unpack(ClassMods.db.profile.crowdcontrol.texcoords) )
			end

			if ClassMods.moversLocked then
				ClassMods.F.CrowdControl.ccFrame[i]:SetAlpha(1)
			end

			ClassMods.F.CrowdControl.ccFrame[i].killtime = GetTime() + expireTime + .2
			ClassMods.F.CrowdControl.ccFrame[i].guid = targetGUID -- Need to know the target id associated with this frame.
			ClassMods.F.CrowdControl.ccFrame[i].spellID = spellID
			ClassMods.F.CrowdControl.ccFrame[i].active = true
			local timer = ClassMods.F.CrowdControl.ccFrame[i].timer or ClassMods.Timer_Create(ClassMods.F.CrowdControl.ccFrame[i])
			timer.start = GetTime()
			timer.duration = expireTime
			timer.enabled = true
			timer.nextUpdate = 0
			timer:Show()
			break
		end
	end
end

local function refreshCCTimer(spellID, targetGUID, expireTime)
	for i=1,4 do
		if (ClassMods.F.CrowdControl.ccFrame[i].active == true) and (ClassMods.F.CrowdControl.ccFrame[i].spellID == spellID) and (ClassMods.F.CrowdControl.ccFrame[i].guid == targetGUID) then
			ClassMods.F.CrowdControl.ccFrame[i].killtime = GetTime() + expireTime + .2
			local timer = ClassMods.F.CrowdControl.ccFrame[i].timer or ClassMods.Timer_Create(ClassMods.F.CrowdControl.ccFrame[i])
			timer.start = GetTime()
			timer.duration = expireTime
			timer.enabled = true
			timer.nextUpdate = 0
			timer:Show()
			break
		end
	end
end

function ClassMods.SetupCrowdControl(lockName)

	-- Deconstruction
	if ClassMods.F.CrowdControl then
		ClassMods.F.CrowdControl:Hide()
		ClassMods.F.CrowdControl.ccFrame[1]:SetScript("OnUpdate", nil)
		ClassMods.F.CrowdControl.ccFrame[1]:UnregisterAllEvents()
		for i=1,4 do
			ClassMods.F.CrowdControl.ccFrame[i]:SetAlpha(0)
		end
		ClassMods.DeregisterMovableFrame("MOVER_CROWDCONTROL")
		ClassMods.F.CrowdControl:SetParent(nil)
	end

	-- Construction
	if not ClassMods.db.profile.crowdcontrol.enabled then return end
	local CROWDCONTROL_UPDATEINTERVAL = 0.08
	if (ClassMods.db.profile.overrideinterval) then
		CROWDCONTROL_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
	else
		CROWDCONTROL_UPDATEINTERVAL = ClassMods.db.profile.crowdcontrol.updateinterval
	end

	-- Create the Frame
	ClassMods.F.CrowdControl = ClassMods.MakeFrame(ClassMods.F.CrowdControl, "Frame", "CLASSMODS_CROWDCONTROL", ClassMods.db.profile.crowdcontrol.anchor[2] or UIParent)
	ClassMods.F.CrowdControl:SetParent(ClassMods.db.profile.crowdcontrol.anchor[2] or UIParent)
	ClassMods.F.CrowdControl:ClearAllPoints()
	ClassMods.F.CrowdControl:SetSize(50, 50) -- Temporary, will set it after we get offsets
	ClassMods.F.CrowdControl:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.crowdcontrol.anchor) )
	ClassMods.F.CrowdControl.ccFrame = {}
	for i=1,4 do -- Allocating 4 frames, more than enough, low overhead
		ClassMods.F.CrowdControl.ccFrame[i] = ClassMods.MakeFrame(ClassMods.F.CrowdControl.ccFrame[i], "Frame", nil, ClassMods.F.CrowdControl)
		ClassMods.F.CrowdControl.ccFrame[i]:SetParent(ClassMods.F.CrowdControl)
		ClassMods.F.CrowdControl.ccFrame[i]:ClearAllPoints()
		ClassMods.F.CrowdControl.ccFrame[i]:SetSize(ClassMods.db.profile.crowdcontrol.iconsize, ClassMods.db.profile.crowdcontrol.iconsize)
		ClassMods.F.CrowdControl.ccFrame[i]:SetPoint("CENTER", ClassMods.F.CrowdControl, "CENTER") -- Temporary
		ClassMods.F.CrowdControl.ccFrame[i].background = ClassMods.MakeBackground(ClassMods.F.CrowdControl.ccFrame[i], ClassMods.db.profile.crowdcontrol, nil, ClassMods.F.CrowdControl.ccFrame[i].background)
		ClassMods.F.CrowdControl.ccFrame[i]:ClearAllPoints() -- Now that we made the backdrop/border we have offsets to use.
		local x = ( (i-1) * (ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[i], "RIGHT", 1) + ClassMods.db.profile.crowdcontrol.iconsize + 2) )
		if ClassMods.db.profile.crowdcontrol.anchor[4] >= 0 then -- Expand to Right
			ClassMods.F.CrowdControl.ccFrame[i]:SetPoint("TOPLEFT", ClassMods.F.CrowdControl, "TOPLEFT", x, 0)
		else -- Expand to Left
			ClassMods.F.CrowdControl.ccFrame[i]:SetPoint("TOPRIGHT", ClassMods.F.CrowdControl, "TOPRIGHT", -x, 0)
		end
		ClassMods.F.CrowdControl.ccFrame[i].Icon = ClassMods.F.CrowdControl.ccFrame[i].Icon or ClassMods.F.CrowdControl.ccFrame[i]:CreateTexture(nil, "BACKGROUND")
		ClassMods.F.CrowdControl.ccFrame[i].Icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up") -- Temporary Texture
		if ClassMods.db.profile.crowdcontrol.enabletexcoords then
			ClassMods.F.CrowdControl.ccFrame[i].Icon:SetTexCoord(unpack(ClassMods.db.profile.crowdcontrol.texcoords) )
		else
			ClassMods.F.CrowdControl.ccFrame[i].Icon:SetTexCoord(0, 1, 0, 1)
		end
		ClassMods.F.CrowdControl.ccFrame[i]:SetAlpha(0)
		ClassMods.F.CrowdControl.ccFrame[i]:Show()
		ClassMods.F.CrowdControl.ccFrame[i].guid = 0
		ClassMods.F.CrowdControl.ccFrame[i].spellID = 0
		ClassMods.F.CrowdControl.ccFrame[i].active = false
	end
	-- Properly set the host frame's size for the movers functionality
	ClassMods.F.CrowdControl:SetSize(
		( (ClassMods.db.profile.crowdcontrol.iconsize +
			(ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[1], "RIGHT", 1) + 2) ) * 3) -
				ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[1], "RIGHT", 1) - 2,
					ClassMods.db.profile.crowdcontrol.iconsize)

	-- Register the mover frame
	ClassMods.RegisterMovableFrame(
		"MOVER_CROWDCONTROL",
		ClassMods.F.CrowdControl,
		ClassMods.F.CrowdControl,
		L["Crowd Control"],
		ClassMods.db.profile.crowdcontrol,
		ClassMods.SetupCrowdControl,
		ClassMods.db.profile.crowdcontrol,
		ClassMods.db.profile.crowdcontrol
	)

	-- First frame calls the update routine.
	ClassMods.F.CrowdControl.ccFrame[1].updateTimer = 0
	ClassMods.F.CrowdControl.ccFrame[1]:SetScript("OnUpdate",
		function(s, elapsed)
			s.updateTimer = s.updateTimer + elapsed
			if s.updateTimer > CROWDCONTROL_UPDATEINTERVAL then
				s._j = 1
				for i=1,4 do
					if (ClassMods.F.CrowdControl.ccFrame[i].active == true) then
						if (ClassMods.F.CrowdControl.ccFrame[i].killtime < GetTime() ) then
							stopCCTimer(ClassMods.F.CrowdControl.ccFrame[i].spellID, ClassMods.F.CrowdControl.ccFrame[i].guid)
						else
							s._x = ( (s._j-1) * (ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.CrowdControl.ccFrame[i], "RIGHT", 1) + ClassMods.db.profile.crowdcontrol.iconsize + 2) )
							if ClassMods.db.profile.crowdcontrol.anchor[4] >= 0 then -- Expand to Right
								ClassMods.F.CrowdControl.ccFrame[i]:SetPoint("TOPLEFT", ClassMods.F.CrowdControl, "TOPLEFT", s._x, 0)
							else -- Expand to Left
								ClassMods.F.CrowdControl.ccFrame[i]:SetPoint("TOPRIGHT", ClassMods.F.CrowdControl, "TOPRIGHT", -s._x, 0)
							end
							s._j = s._j + 1
						end
					end
				end
			end
		end
	)
	-- TODO: add a check for PvP combat and alter the duration variable from 4 to 5
	-- Event handler
	ClassMods.F.CrowdControl.ccFrame[1]:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	ClassMods.F.CrowdControl.ccFrame[1]:SetScript("OnEvent",
		function(s, event, ...)
			s._, s._subEvent, s._, s._sourceGUID, s._, s._sourceFlags, s._, s._destGUID, s._, s._destFlags, s._, s._spellId = ...
			if (s._subEvent == "SPELL_AURA_APPLIED") then
				for index,value in ipairs(ClassMods.db.profile.crowdcontrol.spells) do
					if ((ClassMods.db.profile.crowdcontrol.spells[index][2] == true) and (s._spellId == ClassMods.db.profile.crowdcontrol.spells[index][3])) and (((s._sourceGUID == UnitGUID("player")) or (bit.band(s._sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 1))) then
						addCCTimer(ClassMods.db.profile.crowdcontrol.spells[index][1], s._destGUID, ClassMods.db.profile.crowdcontrol.spells[index][4])
					end
				end
			elseif (s._subEvent == "SPELL_AURA_REFRESH") then
				for index,value in ipairs(ClassMods.db.profile.crowdcontrol.spells) do
					if ((ClassMods.db.profile.crowdcontrol.spells[index][2] == true) and (s._spellId == ClassMods.db.profile.crowdcontrol.spells[index][3])) and (((s._sourceGUID == UnitGUID("player")) or (bit.band(s._sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 1))) then
						refreshCCTimer(ClassMods.db.profile.crowdcontrol.spells[index][1], s._destGUID, ClassMods.db.profile.crowdcontrol.spells[index][4])
					end
				end
			elseif (s._subEvent == "SPELL_AURA_REMOVED") then
				for index,value in ipairs(ClassMods.db.profile.crowdcontrol.spells) do
					if ((ClassMods.db.profile.crowdcontrol.spells[index][2] == true) and (s._spellId == ClassMods.db.profile.crowdcontrol.spells[index][3])) and (((s._sourceGUID == UnitGUID("player")) or (bit.band(s._sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 1))) then
						stopCCTimer(ClassMods.db.profile.crowdcontrol.spells[index][1], s._destGUID, ClassMods.db.profile.crowdcontrol.spells[index][4])
					end
				end
			end
		end)
	ClassMods.F.CrowdControl:Show()
end