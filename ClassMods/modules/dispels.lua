--
-- ClassMods - dispel module
--

-- Check the player's class can dispel
if (not ClassMods.enableDispel) then return end

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local LibDispellable = LibStub("LibDispellable-1.0")

function ClassMods.SetupDispels(lockName)
	-- Deconstruction
	if ClassMods.F.DispelAlert then
		if (not lockName) or (lockName == "MOVER_DISPELALERT") then
			ClassMods.F.DispelAlert:Hide()
			ClassMods.F.DispelAlert:SetScript("OnUpdate", nil)
			ClassMods.F.DispelAlert:SetScript("OnEvent", nil)
			ClassMods.F.DispelAlert:UnregisterAllEvents()
			ClassMods.DeregisterMovableFrame("MOVER_DISPELALERT")
			ClassMods.F.DispelAlert:SetParent(nil)
		end
	end

	if ClassMods.F.DispelAlertRemovables then
		if (not lockName) or (lockName == "MOVER_DISPELREMOVABLES") then
			ClassMods.F.DispelAlertRemovables:Hide()
			ClassMods.DeregisterMovableFrame("MOVER_DISPELREMOVABLES")
			ClassMods.F.DispelAlertRemovables:SetParent(nil)
		end
	end

	if not ClassMods.db.profile.dispel.enabled then return end
	local DISPEL_UPDATEINTERVAL = 0.08
	if (ClassMods.db.profile.overrideinterval) then
		DISPEL_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
	else
		DISPEL_UPDATEINTERVAL = ClassMods.db.profile.dispel.updateinterval
	end
	-- Construction
	if ( (not lockName) or (lockName == "MOVER_DISPELALERT") ) then
		-- Create the Frame
		ClassMods.F.DispelAlert = ClassMods.MakeFrame(ClassMods.F.DispelAlert, "Frame", "CLASSMODS_DISPELALERT", ClassMods.db.profile.dispel.anchor[2] or UIParent)
		ClassMods.F.DispelAlert:SetParent(ClassMods.db.profile.dispel.anchor[2] or UIParent)
		ClassMods.F.DispelAlert:ClearAllPoints()
		ClassMods.F.DispelAlert:SetSize(ClassMods.db.profile.dispel.iconsize, ClassMods.db.profile.dispel.iconsize)
		ClassMods.F.DispelAlert:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.dispel.anchor) )
		ClassMods.F.DispelAlert.Icon = ClassMods.F.DispelAlert.Icon or ClassMods.F.DispelAlert:CreateTexture(nil, "BACKGROUND")
		ClassMods.F.DispelAlert.Icon:ClearAllPoints()
		ClassMods.F.DispelAlert.Icon:SetTexture(ClassMods.dispelTexture)
		if ClassMods.db.profile.dispel.enabletexcoords then
			ClassMods.F.DispelAlert.Icon:SetTexCoord(unpack(ClassMods.db.profile.dispel.texcoords) )
		else
			ClassMods.F.DispelAlert.Icon:SetTexCoord(0, 1, 0, 1)
		end
		ClassMods.F.DispelAlert.Icon:SetAllPoints(ClassMods.F.DispelAlert)
		-- Add sparkle to make it more noticable
		ClassMods.F.DispelAlert.shine = ClassMods.F.DispelAlert.shine or CreateFrame("Frame", "AutocastShine_DISPELALERT", UIParent, "AutoCastShineTemplate")
		ClassMods.F.DispelAlert.shine:SetParent(UIParent)
		ClassMods.F.DispelAlert.shine:ClearAllPoints()
		ClassMods.F.DispelAlert.shine:Show()
		ClassMods.F.DispelAlert.shine:SetSize(ClassMods.db.profile.dispel.iconsize+2, ClassMods.db.profile.dispel.iconsize+2)
		ClassMods.F.DispelAlert.shine:SetPoint("CENTER", ClassMods.F.DispelAlert, "CENTER", 1, 0)
		ClassMods.F.DispelAlert.shine:SetAlpha(1)
		-- Create the Background and border if the user wants one
		ClassMods.F.DispelAlert.background = ClassMods.MakeBackground(ClassMods.F.DispelAlert, ClassMods.db.profile.dispel, nil, nil, ClassMods.F.DispelAlert.background)
		ClassMods.F.DispelAlert:SetAlpha(0)
		ClassMods.F.DispelAlert:Show()
		ClassMods.RegisterMovableFrame(
			"MOVER_DISPELALERT",
			ClassMods.F.DispelAlert,
			ClassMods.F.DispelAlert,
			L["Dispel Alert"],
			ClassMods.db.profile.dispel,
			ClassMods.SetupDispels,
			ClassMods.db.profile.dispel,
			ClassMods.db.profile.dispel
		)
		ClassMods.F.DispelAlert.updateTimer = 0
		ClassMods.F.DispelAlert:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer <= DISPEL_UPDATEINTERVAL then
					return
				else
					self.updateTimer = 0
				end
				
				if (not ClassMods.moversLocked) then
					return
				end
				
				if (not UnitExists("target") ) or UnitIsDeadOrGhost("player") then
					AutoCastShine_AutoCastStop(self.shine)
					self:SetAlpha(0)
					self.amShowing = nil
					return
				else
					isBuff = UnitCanAttack("player", "target")
					for index, spellID1, name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID2, canApplyAura, isBossDebuff in LibDispellable:IterateDispellableAuras("target", isBuff) do
						ClassMods.F.DispelAlert.Icon:SetTexture(select(3, GetSpellInfo(spellID1)))
						if not self.amShowing then
							AutoCastShine_AutoCastStart(ClassMods.F.DispelAlert.shine, 1, .5, .5)
							self:SetAlpha(1)
							if ClassMods.db.profile.enableaudio and ClassMods.db.profile.dispel.enablesound then
								PlaySoundFile(ClassMods.GetActiveSoundFile(ClassMods.db.profile.dispel.sound), ClassMods.db.profile.masteraudio and "Master" or nil)
							end
							self.amShowing = true
							return
						else
							return
						end
					end
				end
				AutoCastShine_AutoCastStop(self.shine)
				self:SetAlpha(0)
				self.amShowing = nil
			end)
	end

	if ( (not lockName) or (lockName == "MOVER_DISPELREMOVABLES") ) then
		-- Notification setup
		if (ClassMods.db.profile.dispel.removednotify == true) then
			ClassMods.F.DispelAlert:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			ClassMods.F.DispelAlert:SetScript("OnEvent",
				function(self, event, ...)
					self._, self._subEvent, self._, self._sourceGUID, self._, self._, self._, self._destGUID, self._destName, self._, self._, self._spellID, self._spellName, self._, self._extraSpellID, self._extraSpellName = ...
					if (self._subEvent == "SPELL_DISPEL") and (self._sourceGUID == UnitGUID("player") ) and (self._destGUID ~= UnitGUID("pet") ) then
						if (ClassMods.GetChatChan(ClassMods.db.profile.dispel[strlower(ClassMods.GetGroupType() ).."chan"]) ~= "NONE") then
							SendChatMessage(GetSpellLink(self._spellID) .. " " .. L["removed"] .. " " .. GetSpellLink(self._extraSpellID) .. " " .. L["from"] .. " " .. self._destName .. ".", ClassMods.GetChatChan(ClassMods.db.profile.dispel[strlower(ClassMods.GetGroupType() ).."chan"]), nil, GetUnitName("player") )
						end
					end
				end)
		end
		-- Removables setup
		if not ClassMods.db.profile.dispel.enableremovables then
			return
		end

		ClassMods.F.DispelAlertRemovables = ClassMods.MakeFrame(ClassMods.F.DispelAlertRemovables, "Frame", "CLASSMODS_DISPELALERT_REMOVABLES", ClassMods.db.profile.dispel.anchor_removables[2] or UIParent)
		ClassMods.F.DispelAlertRemovables:SetParent(ClassMods.db.profile.dispel.anchor_removables[2] or UIParent)
		ClassMods.F.DispelAlertRemovables:ClearAllPoints()
		ClassMods.F.DispelAlertRemovables:SetSize(50,50) -- Temp size, we'll re-set this after we create the buff frames to get proper offsets
		ClassMods.F.DispelAlertRemovables:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.dispel.anchor_removables) )
		ClassMods.F.DispelAlertRemovables.buffFrames = ClassMods.F.DispelAlertRemovables.buffFrames or {} -- recycle
		for i=1,40 do
			ClassMods.F.DispelAlertRemovables.buffFrames[i] = ClassMods.MakeFrame(ClassMods.F.DispelAlertRemovables.buffFrames[i], "Frame", nil, ClassMods.F.DispelAlertRemovables)
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetParent(ClassMods.F.DispelAlertRemovables)
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:ClearAllPoints()
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetSize(ClassMods.db.profile.dispel.iconsizeremovables, ClassMods.db.profile.dispel.iconsizeremovables)
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetPoint("CENTER", ClassMods.F.DispelAlertRemovables, "CENTER") -- Temporary
			ClassMods.F.DispelAlertRemovables.buffFrames[i].Icon = ClassMods.F.DispelAlertRemovables.buffFrames[i].Icon or ClassMods.F.DispelAlertRemovables.buffFrames[i]:CreateTexture(nil, "BACKGROUND")
			ClassMods.F.DispelAlertRemovables.buffFrames[i].Icon:ClearAllPoints()
			ClassMods.F.DispelAlertRemovables.buffFrames[i].Icon:SetAllPoints(ClassMods.F.DispelAlertRemovables.buffFrames[i])
			ClassMods.F.DispelAlertRemovables.buffFrames[i].Icon:SetTexture(ClassMods.dispelTexture) -- Temporary
			if ClassMods.db.profile.dispel.removablesenabletexcoords then
				ClassMods.F.DispelAlert.Icon:SetTexCoord(unpack(ClassMods.db.profile.dispel.removablestexcoords) )
			else
				ClassMods.F.DispelAlert.Icon:SetTexCoord(0, 1, 0, 1)
			end
			ClassMods.F.DispelAlertRemovables.buffFrames[i].background = ClassMods.MakeBackground(ClassMods.F.DispelAlertRemovables.buffFrames[i], ClassMods.db.profile.dispel, "removables", nil, nil, ClassMods.F.DispelAlertRemovables.buffFrames[i].background)
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:ClearAllPoints() -- Now that we made the backdrop/border we have offsets to use.
			-- Flip expanding left to right or right to left depending on anchor point X
			local xPos = ((ClassMods.db.profile.dispel.iconsizeremovables + (ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[i], "RIGHT", 1) + 2) ) * mod(i-1, 8) )
			local yPos = (ClassMods.db.profile.dispel.iconsizeremovables +  (ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[i], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[i], "BOTTOM", 1) + 2) ) * floor( (i-1) / 8)
			if ClassMods.db.profile.dispel.anchor_removables[4] >= 0 then
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetPoint("TOPLEFT", ClassMods.F.DispelAlertRemovables, "TOPLEFT", xPos, -yPos)
			else
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetPoint("TOPRIGHT", ClassMods.F.DispelAlertRemovables, "TOPRIGHT", -xPos, -yPos)
			end
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetAlpha(1)
			ClassMods.F.DispelAlertRemovables.buffFrames[i]:Hide()
			ClassMods.F.DispelAlertRemovables.buffFrames[i].spellID = 0
			if ClassMods.db.profile.dispel.removablestips then
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetScript("OnEnter",
					function(self)
						if (self.spellID == 0) then return end
							for index=1,40 do
								if (select(11, UnitBuff("target", index) ) == self.spellID) then
									GameTooltip:SetOwner(self)
									GameTooltip:SetUnitBuff("target", index)
									GameTooltip:Show()
								return
							end
						end
					end)
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetScript("OnLeave",
					function(self)
						if self.spellID == 0 then
							return
						end
						GameTooltip:Hide()
					end)
			else
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetScript("OnEnter", nil)
				ClassMods.F.DispelAlertRemovables.buffFrames[i]:SetScript("OnLeave", nil)
			end
		end

		-- Now we can properly set the size of the parent frame for the buff icons because we now have offsets.
		ClassMods.F.DispelAlertRemovables:SetSize(
			( (ClassMods.db.profile.dispel.iconsizeremovables + -- WIDTH
				(ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "RIGHT", 1) + 2) ) * 8)
				- ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "RIGHT", 1) - 2,
			( (ClassMods.db.profile.dispel.iconsizeremovables + -- HEIGHT
				(ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "BOTTOM", 1) + 2) ) * 5)
				- ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.DispelAlertRemovables.buffFrames[1], "RIGHT", 1) - 2)

		-- Register the mover frame
		ClassMods.RegisterMovableFrame(
			"MOVER_DISPELREMOVABLES",
			ClassMods.F.DispelAlertRemovables,
			ClassMods.F.DispelAlertRemovables,
			L["Dispel Alert Removable Buffs"],
			ClassMods.db.profile.dispel,
			ClassMods.SetupDispels,
			ClassMods.db.profile.dispel,
			ClassMods.db.profile.dispel,
			"_removables"
		)

		ClassMods.F.DispelAlertRemovables.updateTimer = 0
		ClassMods.F.DispelAlertRemovables:SetScript("OnUpdate",
			function(self, elapsed, ...)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < DISPEL_UPDATEINTERVAL then
					return
				else
					self.updateTimer = 0
				end

				if (ClassMods.db.profile.dispel.removablespvponly and (ClassMods.GetGroupType() ~= "ARENA") and (ClassMods.GetGroupType() ~= "BATTLEGROUND") ) then
					for i=1,40 do
						ClassMods.F.DispelAlertRemovables.buffFrames[i].spellID = 0
						ClassMods.F.DispelAlertRemovables.buffFrames[i]:Hide()
					end
				else
					self._j = 1
					isBuff = UnitCanAttack("player", "target")
					for index, spellID1, name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID2, canApplyAura, isBossDebuff in LibDispellable:IterateDispellableAuras("target", isBuff) do
						ClassMods.F.DispelAlertRemovables.buffFrames[self._j].spellID = spellID2
						ClassMods.F.DispelAlertRemovables.buffFrames[self._j].Icon:SetTexture(select(3, GetSpellInfo(spellID2) ) )
						if ClassMods.db.profile.dispel.removablesenabletexcoords then
							ClassMods.F.DispelAlert.Icon:SetTexCoord(unpack(ClassMods.db.profile.dispel.removablestexcoords) )
						end
						ClassMods.F.DispelAlertRemovables.buffFrames[self._j]:Show()
						self._j = self._j + 1
					end
					for i=self._j,40 do
						ClassMods.F.DispelAlertRemovables.buffFrames[i]:Hide()
						ClassMods.F.DispelAlertRemovables.buffFrames[i].spellID = 0
					end
				end
			end
		)
		ClassMods.F.DispelAlertRemovables:Show()
	end
end