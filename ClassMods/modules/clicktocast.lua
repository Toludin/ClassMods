--
-- ClassMods - clickcast module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.CanUseClicktocast(spell)
	-- Check if they can use the spell, maybe they have not trained it...
	local usable, _ = IsUsableSpell(spell)
	if (not usable) then
		if (select(1, GetSpellCooldown(spell) ) == 0) then
			return false
		end
	end
	-- Conditions met, we're good to go!
	return true
end

function ClassMods.SetupClickToCast()

	if (not ClassMods.db.profile.clicktocast.spell) or (not ClassMods.clickToCastDefault) then return end

	local spellToCast
	if (tonumber(ClassMods.db.profile.clicktocast.spell)) then
		spellToCast = GetSpellInfo(tonumber(ClassMods.db.profile.clicktocast.spell))
	else
		spellToCast = ClassMods.db.profile.clicktocast.spell
	end
	ClassMods.macroStr = "/cast [@mouseover,exists,nounithasvehicleui,novehicleui] "..spellToCast


	if InCombatLockdown() then
		-- Be sure we don't register this event more than one time, ever!
		ClassMods:UnregisterEvent("PLAYER_REGEN_ENABLED")
		ClassMods:RegisterEvent("PLAYER_REGEN_ENABLED")
		ClassMods.delayedUpdate = true
		return
	else
		ClassMods.delayedUpdate = nil
	end

	-- Check they are proper level and have learned the spell, no point doing anything if they can't!
	if (not ClassMods.CanUseClicktocast(ClassMods.db.profile.clicktocast.spell)) then return end

	-- Deconstruction
	ClassMods:UnregisterEvent("PLAYER_REGEN_ENABLED")

	if ClassMods.clicktocastFrames then
		for key,val in pairs(ClassMods.clicktocastFrames) do
			if _G[key] and (_G[key]:GetAttribute("macrotext") == ClassMods.macroStr) then
				_G[key]:SetAttribute("type2", nil)
				_G[key]:SetAttribute("macrotext", nil)
			end
		end
	end

	ClassMods.clicktocastFrames = nil

	if ClassMods.F.ClickToCast then
		ClassMods.F.ClickToCast:Hide()
		ClassMods.F.ClickToCast:UnregisterAllEvents()
		ClassMods.F.ClickToCast:SetScript("OnUpdate", nil)
		ClassMods.F.ClickToCast:SetParent(nil)
	end

	if ClassMods.F.ClickToCast then -- This causes major stacking errors if we don't unregister first!
		ClassMods.F.ClickToCast:UnregisterAllEvents()
		ClassMods.F.ClickToCast:SetScript("OnUpdate", nil)
	end

	if not ClassMods.db.profile.clicktocast.enabled then return end

	-- Construction
	local ctcFrames = {}
	if ClassMods.db.profile.clicktocast.fTARGET then ctcFrames[#ctcFrames+1] = "target" end
	if ClassMods.db.profile.clicktocast.fPET then ctcFrames[#ctcFrames+1] = "pet" end
	if ClassMods.db.profile.clicktocast.fFOCUS then ctcFrames[#ctcFrames+1] = "focus" end
	if ClassMods.db.profile.clicktocast.fTOT then ctcFrames[#ctcFrames+1] = "targettarget" end

	for i=1,40 do
		if i <= 4 then
			if ClassMods.db.profile.clicktocast.fPARTY then ctcFrames[#ctcFrames+1] = "party"..i end
			if ClassMods.db.profile.clicktocast.fPARTYPETS then ctcFrames[#ctcFrames+1] = "partypet"..i end
		end
		if i <= 40 then
			if ClassMods.db.profile.clicktocast.fRAID then ctcFrames[#ctcFrames+1] = "raid"..i end
			if ClassMods.db.profile.clicktocast.fRAIDPET then ctcFrames[#ctcFrames+1] = "raidpet"..i end
		end
	end

	if (#ctcFrames == 0) then
		ctcFrames = {}
		return
	end

	-- This is a fix for Grid, add's a delay to when an update is triggered
	ClassMods.F.ClickToCast = ClassMods.F.ClickToCast or CreateFrame("Frame", "CLASSMODS_CLICKTOCAST", UIParent) -- Handler frame, nothing more.
	ClassMods.clicktocastFrames = {}
	local frame = EnumerateFrames()

--[[
-- AUTHOR NOTE TO OTHER AUTHORS: If you add "<frame>.cmctc_unit" variable to a frame that should be clickable for ClickToCast spells,
-- this will make ClassMods easily pickup your frames with no guess work...
--]]

	while frame do
		if (frame:GetName() ) then
			if (frame.cmctc_unit) and tContains(ctcFrames, frame.cmctc_unit) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)
			-- TukUI
			elseif (strsub(frame:GetName(),1,5) == "Tukui") and (frame.unit) and (tContains(ctcFrames, frame.unit) ) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)
			-- ElvUI
			elseif (strsub(frame:GetName(),1,5) == "ElvUF") and (frame.unit) and (tContains(ctcFrames, frame.unit) ) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)
			-- Perl Classic
			elseif (not (strsub(frame:GetName(),1,5) == "ElvUF") ) and (frame:GetAttribute("unit") and tContains(ctcFrames, frame:GetAttribute("unit") ) ) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)
			-- Normal frames
			elseif (frame.unit and (frame.menu or (strsub(frame:GetName(),1,4) == "Grid") ) and tContains(ctcFrames, frame.unit) ) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)
			-- XPerl - it does not use standard setup for frames so we have to do this the hard way
			elseif (frame.partyid and (frame.menu or (strsub(frame:GetName(),1,5) == "XPerl") ) and tContains(ctcFrames, frame.partyid) ) then
				ClassMods.clicktocastFrames[frame:GetName()] = frame:GetName()
				_G[frame:GetName()]:SetAttribute("type2", "macro")
				_G[frame:GetName()]:SetAttribute("macrotext", ClassMods.macroStr)

				if _G[frame:GetName().."nameFrame"] then -- Need to add ctc to the name frame too.  GG Non-standard frame stuff
					ClassMods.clicktocastFrames[frame:GetName().."nameFrame"] = frame:GetName().."nameFrame"
					_G[frame:GetName().."nameFrame"]:SetAttribute("type2", "macro")
					_G[frame:GetName().."nameFrame"]:SetAttribute("macrotext", ClassMods.macroStr)
				end
			end
		end
		frame = EnumerateFrames(frame)
	end

	ClassMods.F.ClickToCast:RegisterEvent("GROUP_ROSTER_UPDATE")
	ClassMods.F.ClickToCast:RegisterEvent("RAID_ROSTER_UPDATE")
	ClassMods.F.ClickToCast:RegisterUnitEvent("UNIT_PET", "player")
	ClassMods.F.ClickToCast:SetScript("OnEvent", function(self, event, ...) ClassMods.SetupClickToCast() end)
end

function ClassMods:PLAYER_REGEN_ENABLED()
	if ClassMods.delayedUpdate then
		ClassMods.SetupClickToCast()
		ClassMods:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end