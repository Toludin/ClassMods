--
-- ClassMods - announcements module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.SetupAnnouncements()
	-- Deconstruction
	if ClassMods.F.Announcements then
		ClassMods.F.Announcements:Hide()
		ClassMods.F.Announcements:SetScript("OnEvent", nil)
		ClassMods.F.Announcements:UnregisterAllEvents()
		ClassMods.F.Announcements:SetParent(nil)
	end
	-- Construction
	local loadModule = false
	if ClassMods.db.profile.announcements.interrupt.enabled then
		loadModule = true
	end
	for key,val in pairs(ClassMods.db.profile.announcements.announcements) do
		if ClassMods.db.profile.announcements.announcements[key] and ClassMods.db.profile.announcements.announcements[key].enabled then
			loadModule = true
		end
	end

	if not loadModule then return end

	ClassMods.F.Announcements = ClassMods.F.Announcements or CreateFrame("Frame", "CLASSMODS_ANNOUNCEMENTS", UIParent) -- Handler frame, nothing more.
	ClassMods.F.Announcements:SetParent(UIParent)
	ClassMods.F.Announcements:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	ClassMods.F.Announcements:SetScript("OnEvent",
		function(self, event, ...)
			self._, self._subEvent, self._, self._sourceGUID, self._, self._sourceFlags, self._, self._destGUID, self._destName, self._, self._, self._spellId, self._spellName, self._, self._extraSpellID, self._extraSpellName = ...
			if (self._subEvent == "SPELL_INTERRUPT") and (ClassMods.db.profile.announcements.interrupt.enabled) and ((self._sourceGUID == UnitGUID("player")) or (bit.band(self._sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 1)) then
				if (ClassMods.GetChatChan(ClassMods.db.profile.announcements.interrupt[strlower(ClassMods.GetGroupType() ).."chan"]) ~= "NONE") then
					SendChatMessage(L["Interrupted"] .. " " .. self._destName .. L["'s"] .. " " .. GetSpellLink(self._extraSpellID) .. " ", ClassMods.GetChatChan(ClassMods.db.profile.announcements.interrupt[strlower(ClassMods.GetGroupType() ).."chan"]), nil, GetUnitName("player") )
				end
			elseif (self._subEvent == "SPELL_CAST_SUCCESS") and ((self._sourceGUID == UnitGUID("player")) or (bit.band(self._sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 1)) then
				for key,val in pairs(ClassMods.db.profile.announcements.announcements) do
					if (ClassMods.db.profile.announcements.announcements[key].enabled) and ((self._spellId == ClassMods.db.profile.announcements.announcements[key].spellid) or (self._spellName == ClassMods.db.profile.announcements.announcements[key].spellid)) then
						if (ClassMods.GetChatChan(ClassMods.db.profile.announcements.announcements[key][strlower(ClassMods.GetGroupType() ).."chan"]) ~= "NONE") then
							if (self._destName) and (self._destGUID ~= UnitGUID("player")) then
								SendChatMessage(GetSpellLink(self._spellId) .. " " .. L["cast on"] .. " " .. self._destName .. ".", ClassMods.GetChatChan(ClassMods.db.profile.announcements.announcements[key][strlower(ClassMods.GetGroupType() ).."chan"]), nil, GetUnitName("player") )
							else
								SendChatMessage(GetSpellLink(self._spellId) .. " " .. L["activated."], ClassMods.GetChatChan(ClassMods.db.profile.announcements.announcements[key][strlower(ClassMods.GetGroupType() ).."chan"]), nil, GetUnitName("player") )
							end
						end
					end
				end
			elseif (self._subEvent == "SPELL_AURA_REMOVED") and (self._sourceGUID == UnitGUID("player") and (self._destGUID == UnitGUID("player"))) then
				for key,val in pairs(ClassMods.db.profile.announcements.announcements) do
					if (ClassMods.db.profile.announcements.announcements[key].enabled and ClassMods.db.profile.announcements.announcements[key].announceend) then
						if ((self._spellId == ClassMods.db.profile.announcements.announcements[key].spellid) or (self._spellName == select(1, GetSpellInfo(ClassMods.db.profile.announcements.announcements[key].spellid))) or (self._spellName == ClassMods.db.profile.announcements.announcements[key].spellid)) and (ClassMods.GetChatChan(ClassMods.db.profile.announcements.announcements[key][strlower(ClassMods.GetGroupType() ).."chan"]) ~= "NONE") then
							SendChatMessage(GetSpellLink(self._spellId) .. " " .. L["finished."], ClassMods.GetChatChan(ClassMods.db.profile.announcements.announcements[key][strlower(ClassMods.GetGroupType() ).."chan"]), nil, GetUnitName("player") )
						end
					end
				end
			end
		end
	)
	ClassMods.F.Announcements:Show()
end