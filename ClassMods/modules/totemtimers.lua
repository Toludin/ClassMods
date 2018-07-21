--
-- ClassMods - totem timers module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

if (not ClassMods.enableTotems) then return end

local function addTotemTimer(spellID, expireTime)
	for i=1,7 do
		--Totem Index overrides
		if (spellID == 205022) then i=4 end -- Arcane Familiar
		if (spellID == 114158) then i=2 end -- Light's Hammer

		if (ClassMods.F.Totems.timer[i].active == false) then
			ClassMods.F.Totems.timer[i].Icon:ClearAllPoints()
			ClassMods.F.Totems.timer[i].Icon:SetAllPoints(ClassMods.F.Totems.timer[i])
			ClassMods.F.Totems.timer[i].Icon:SetTexture(select(3, GetSpellInfo(spellID) ))

			if ClassMods.db.profile.crowdcontrol.enabletexcoords then
				ClassMods.F.Totems.timer[i].Icon:SetTexCoord(unpack(ClassMods.db.profile.crowdcontrol.texcoords) )
			end

			if ClassMods.moversLocked then
				ClassMods.F.Totems.timer[i]:SetAlpha(1)
			end

			ClassMods.F.Totems.timer[i].killtime = GetTime() + expireTime + .2
			ClassMods.F.Totems.timer[i].spellID = spellID
			ClassMods.F.Totems.timer[i].active = true
			local timer = ClassMods.F.Totems.timer[i].timer or ClassMods.Timer_Create(ClassMods.F.Totems.timer[i])
			timer.start = GetTime()
			timer.duration = expireTime
			timer.enabled = true
			timer.nextUpdate = 0
			timer:Show()
			break
		end
	end
end

local function refreshTotemTimer(spellID, expireTime)
	local createTimer = true
	for i=1,7 do
		if (ClassMods.F.Totems.timer[i].active == true) and (ClassMods.F.Totems.timer[i].spellID == spellID) then
			createTimer = false
			ClassMods.F.Totems.timer[i].killtime = GetTime() + expireTime + .2
			local timer = ClassMods.F.Totems.timer[i].timer or ClassMods.Timer_Create(ClassMods.F.Totems.timer[i])
			timer.start = GetTime()
			timer.duration = expireTime
			timer.enabled = true
			timer.nextUpdate = 0
			timer:Show()
			break
		end
	end

	if createTimer then
		addTotemTimer(spellID, expireTime)
	end
end

local function stopTotemTimer(spellID)
	for i=1,7 do
		if (ClassMods.F.Totems.timer[i].active == true) and (ClassMods.F.Totems.timer[i].spellID == spellID) then
			ClassMods.F.Totems.timer[i]:SetAlpha(0)
			ClassMods.F.Totems.timer[i].spellID = 0
			ClassMods.F.Totems.timer[i].active = false
			ClassMods.F.Totems.timer[i].killtime = 0

			if ClassMods.F.Totems.timer[i].timer then
				ClassMods.F.Totems.timer[i].timer.enabled = nil
				ClassMods.F.Totems.timer[i].timer:Hide()
			end

			break -- Found the right one, stop the loop
		end
	end
end

function ClassMods.SetupTotemTimers()

	-- Deconstruction
	if ClassMods.F.Totems then
		ClassMods.F.Totems:Hide()
		ClassMods.F.Totems:SetScript("OnUpdate", nil)
		ClassMods.F.Totems:UnregisterAllEvents()
		for i=1,7 do
			ClassMods.F.Totems.timer[i]:SetAlpha(0)
		end
		ClassMods.DeregisterMovableFrame("MOVER_TOTEMTIMERS")
		ClassMods.F.Totems:SetParent(nil)
	end

	if not ClassMods.db.profile.totemtimers.enabled then return end

	-- Construction
	local TOTEMINDICATOR_UPDATEINTERVAL = 0.08
	if (ClassMods.db.profile.overrideinterval) then
		TOTEMINDICATOR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
	else
		TOTEMINDICATOR_UPDATEINTERVAL = ClassMods.db.profile.totemtimers.updateinterval
	end

	-- Create the Frame
	ClassMods.F.Totems = ClassMods.MakeFrame(ClassMods.F.Totems, "Frame", "CLASSMODS_TOTEMTIMER", ClassMods.db.profile.totemtimers.anchor[2] or UIParent)
	ClassMods.F.Totems:SetParent(ClassMods.db.profile.totemtimers.anchor[2] or UIParent)
	ClassMods.F.Totems:ClearAllPoints()
	ClassMods.F.Totems:SetSize(50, 50) -- Temporary, will set it after we get offsets
	ClassMods.F.Totems:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.totemtimers.anchor) )
	ClassMods.F.Totems.timer = {}

	for i=1,7 do
		ClassMods.F.Totems.timer[i] = ClassMods.MakeFrame(ClassMods.F.Totems.timer[i], "Frame", nil, ClassMods.F.Totems)
		ClassMods.F.Totems.timer[i]:SetParent(ClassMods.F.Totems)
		ClassMods.F.Totems.timer[i]:ClearAllPoints()
		ClassMods.F.Totems.timer[i]:SetSize(ClassMods.db.profile.totemtimers.iconsize, ClassMods.db.profile.totemtimers.iconsize)
		ClassMods.F.Totems.timer[i]:SetPoint("CENTER", ClassMods.F.Totems, "CENTER") -- Temporary
		ClassMods.F.Totems.timer[i].background = ClassMods.MakeBackground(ClassMods.F.Totems.timer[i], ClassMods.db.profile.totemtimers, nil, ClassMods.F.Totems.timer[i].background)
		ClassMods.F.Totems.timer[i]:ClearAllPoints() -- Now that we made the backdrop/border we have offsets to use.

		local x = ( (i-1) * (ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[i], "RIGHT", 1) + ClassMods.db.profile.totemtimers.iconsize + 2) )

		if ClassMods.db.profile.totemtimers.anchor[4] >= 0 then -- Expand to Right
			ClassMods.F.Totems.timer[i]:SetPoint("TOPLEFT", ClassMods.F.Totems, "TOPLEFT", x, 0)
		else -- Expand to Left
			ClassMods.F.Totems.timer[i]:SetPoint("TOPRIGHT", ClassMods.F.Totems, "TOPRIGHT", -x, 0)
		end

		ClassMods.F.Totems.timer[i].Icon = ClassMods.F.Totems.timer[i].Icon or ClassMods.F.Totems.timer[i]:CreateTexture(nil, "BACKGROUND")
		ClassMods.F.Totems.timer[i].Icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up") -- Temporary Texture

		if ClassMods.db.profile.totemtimers.enabletexcoords then
			ClassMods.F.Totems.timer[i].Icon:SetTexCoord(unpack(ClassMods.db.profile.totemtimers.texcoords) )
		else
			ClassMods.F.Totems.timer[i].Icon:SetTexCoord(0, 1, 0, 1)
		end

		ClassMods.F.Totems.timer[i]:SetAlpha(0)
		ClassMods.F.Totems.timer[i]:Show()
		ClassMods.F.Totems.timer[i].spellID = ClassMods.F.Totems.timer[i].spellID or 0
		ClassMods.F.Totems.timer[i].active = ClassMods.F.Totems.timer[i].active or false
	end
	-- Properly set the host frame's size for the movers functionality
	ClassMods.F.Totems:SetSize(
		( (ClassMods.db.profile.totemtimers.iconsize +
				(ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[1], "RIGHT", 1) + 2) ) * 3) -
				ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[1], "RIGHT", 1) - 2,	ClassMods.db.profile.totemtimers.iconsize)

		-- Register the mover frame
	ClassMods.RegisterMovableFrame(
		"MOVER_TOTEMTIMERS",
		ClassMods.F.Totems,
		ClassMods.F.Totems,
		L["Totem Timers"],
		ClassMods.db.profile.totemtimers,
		ClassMods.SetupTotemTimers,
		ClassMods.db.profile.totemtimers,
		ClassMods.db.profile.totemtimers
	)

	-- First frame calls the update routine.
	ClassMods.F.Totems.updateTimer = 0
	ClassMods.F.Totems:SetScript("OnUpdate",
		function(s, elapsed)
			s.updateTimer = s.updateTimer + elapsed
			if s.updateTimer > TOTEMINDICATOR_UPDATEINTERVAL then
				s._j = 1
				for i=1,7 do
					if (ClassMods.F.Totems.timer[i].active == true) then
						if (ClassMods.F.Totems.timer[i].killtime < GetTime() ) then
							stopTotemTimer(ClassMods.F.Totems.timer[i].spellID)
						else
							s._x = ( (s._j-1) * (ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Totems.timer[i], "RIGHT", 1) + ClassMods.db.profile.totemtimers.iconsize + 2) )
							if ClassMods.db.profile.totemtimers.anchor[4] >= 0 then -- Expand to Right
								ClassMods.F.Totems.timer[i]:SetPoint("TOPLEFT", ClassMods.F.Totems, "TOPLEFT", s._x, 0)
							else -- Expand to Left
								ClassMods.F.Totems.timer[i]:SetPoint("TOPRIGHT", ClassMods.F.Totems, "TOPRIGHT", -s._x, 0) 
							end
							s._j = s._j + 1
						end
					end
				end
			end
		end)

	-- Event handler
	ClassMods.F.Totems:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	ClassMods.F.Totems:RegisterEvent("PLAYER_TOTEM_UPDATE")
	ClassMods.F.Totems:SetScript("OnEvent",
		function(s, event, ...)
			s._, s._subEvent, s._, s._sourceGUID, s._, s._sourceFlags, s._, s._destGUID, s._destName, s._destFlags, s._, s._spellId = ...
			if (s._subEvent == "SPELL_CAST_SUCCESS") and (s._sourceGUID == UnitGUID("player")) then
				for i=1,#ClassMods.db.profile.totemtimers.totems do
					-- 145205: Efflorescence
					-- 205022: Arcane Familiar
					-- 115313: Jade Serpent Statue
					-- 115315: Black Ox Statue
					if (s._spellId == 145205) or (s._spellId == 205022) or (s._spellId == 115313) or (s._spellId == 115315) then
						refreshTotemTimer(s._spellId, ClassMods.db.profile.totemtimers.totems[i][3])
					elseif (ClassMods.db.profile.totemtimers.totems[i][1] == true) and (s._spellId == ClassMods.db.profile.totemtimers.totems[i][2]) then
						addTotemTimer(s._spellId, ClassMods.db.profile.totemtimers.totems[i][3])
					end
				end
			elseif (event == "PLAYER_TOTEM_UPDATE") then
				local totemIndex = ...
				local haveTotem, name, startTime, duration, icon = GetTotemInfo(totemIndex)
				if (ClassMods.F.Totems.timer[totemIndex].active == true) and (not haveTotem) then
					stopTotemTimer(ClassMods.F.Totems.timer[totemIndex].spellID)
				end
			end
		end)
	ClassMods.F.Totems:Show()
end