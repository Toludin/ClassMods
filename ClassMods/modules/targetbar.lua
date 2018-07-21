--
-- ClassMods - target bar module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local UnitHealthMax, UnitHealth = UnitHealthMax, UnitHealth

local function getTargetBarColor(incPrediction)
	local health = UnitHealth("target")
	local maxHealth = UnitHealthMax("target")
	local barColor = ClassMods.db.profile.targetbar.barcolor

	if (health > 0) then
		if (not incPrediction) then incPrediction = 0 end

		if ClassMods.db.profile.targetbar.reactioncolored then
			if UnitExists("target") then
				local r, g, b, a = UnitSelectionColor("target")
				barColor = { r, g, b, 1 }
			end
		end

		if (ClassMods.db.profile.targetbar.classcolored and ((ClassMods.db.profile.targetbar.playersonly and UnitPlayerControlled("target")) or (not ClassMods.db.profile.targetbar.playersonly))) then
			local targetClass = select(2, UnitClassBase("target"))
			if targetClass then
				barColor = { RAID_CLASS_COLORS[targetClass].r, RAID_CLASS_COLORS[targetClass].g, RAID_CLASS_COLORS[targetClass].b, 1 }
			end
		end

		if ClassMods.db.profile.targetbar.lowwarn and ( ((health + incPrediction) / maxHealth) <= ClassMods.db.profile.targetbar.lowwarnthreshold) then
			barColor = ClassMods.db.profile.targetbar.barcolorlow
		end
	end
	return barColor
end

function ClassMods.updateIncomingHealsTarget()
	local newPrediction1 = 0
	local health = UnitHealth("target")
	local maxHealth = UnitHealthMax("target")
	local barColor1 = getTargetBarColor(newPrediction1)

	if ClassMods.db.profile.targetbar.incomingheals then
		newPrediction1 = UnitGetIncomingHeals("target") or 0
		ClassMods.F.TargetBar.IncomingHeals:SetStatusBarColor(barColor1[1], barColor1[2], barColor1[3], 1)
		if (newPrediction1 ~= 0) and (not UnitIsDeadOrGhost("target") ) then
			if (health + newPrediction1) > maxHealth then
				ClassMods.F.TargetBar.IncomingHeals:SetSize( ((ClassMods.F.TargetBar:GetWidth() / maxHealth) * (maxHealth - health)), ClassMods.F.TargetBar:GetHeight() )
			else
				ClassMods.F.TargetBar.IncomingHeals:SetSize( ((ClassMods.F.TargetBar:GetWidth() / maxHealth) * newPrediction1), ClassMods.F.TargetBar:GetHeight() )
			end
			ClassMods.F.TargetBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.TargetBar.IncomingHeals:SetPoint("LEFT", ClassMods.F.TargetBar, "LEFT", ClassMods.F.TargetBar:GetWidth() / (select(2, ClassMods.F.TargetBar:GetMinMaxValues() ) / ClassMods.F.TargetBar:GetValue()), 0)
			ClassMods.F.TargetBar.IncomingHeals:SetAlpha(ClassMods.F.TargetBar:GetAlpha() * 0.6)
			ClassMods.F.TargetBar.IncomingHeals:Show()
		else
			ClassMods.F.TargetBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.TargetBar.IncomingHeals:SetPoint("LEFT", ClassMods.F.TargetBar, "LEFT", 0, 0)
			ClassMods.F.TargetBar.IncomingHeals:Hide()
		end
	end
end

function ClassMods.updateAbsorbsTarget()
	local newPrediction1 = 0
	local health = UnitHealth("target")
	local maxHealth = UnitHealthMax("target")

	if ClassMods.db.profile.targetbar.incomingheals then
		newPrediction1 = UnitGetTotalAbsorbs("target")
		ClassMods.F.TargetBar.Absorbs:SetStatusBarColor(1, 1, 1, 1)
		if (newPrediction1 ~= 0) and (not UnitIsDeadOrGhost("target") ) then
			ClassMods.F.TargetBar.Absorbs:SetSize( ((ClassMods.F.TargetBar:GetWidth() / maxHealth) * newPrediction1), ceil(ClassMods.F.TargetBar:GetHeight() / 2) )
			ClassMods.F.TargetBar.Absorbs:ClearAllPoints()
			if (health + newPrediction1) > maxHealth then
				ClassMods.F.TargetBar.Absorbs:SetPoint("TOPRIGHT", ClassMods.F.TargetBar, "TOPRIGHT", 0, 0 )
			else
				ClassMods.F.TargetBar.Absorbs:SetPoint("TOPLEFT", ClassMods.F.TargetBar, "TOPLEFT", ClassMods.F.TargetBar:GetWidth() / (select(2, ClassMods.F.TargetBar:GetMinMaxValues() ) / ClassMods.F.TargetBar:GetValue()), 0)
			end
			ClassMods.F.TargetBar.Absorbs:SetAlpha(1)
			ClassMods.F.TargetBar.Absorbs:Show()
		else
			ClassMods.F.TargetBar.Absorbs:ClearAllPoints()
			ClassMods.F.TargetBar.Absorbs:SetPoint("LEFT", ClassMods.F.TargetBar, "LEFT", 0, 0)
			ClassMods.F.TargetBar.Absorbs:Hide()
		end
	end
end

function ClassMods.SetupTargetBar()
	-- Destruction
	if ClassMods.F.TargetBar then
		ClassMods.F.TargetBar:Hide()
		ClassMods.F.TargetBar:SetScript("OnUpdate", nil)
		ClassMods.F.TargetBar:SetScript("OnEvent", nil)
		ClassMods.F.TargetBar:UnregisterAllEvents()

		if ClassMods.F.TargetBar.smoother then
			ClassMods.RemoveSmooth(ClassMods.F.TargetBar)
		end

		ClassMods.DeregisterMovableFrame("MOVER_TARGETBAR")
		ClassMods.F.TargetBar:SetParent(nil)
	end

	-- Construction
	if ClassMods.db.profile.targetbar.enabled then
		local TARGETBAR_UPDATEINTERVAL = 0.08
		if (ClassMods.db.profile.overrideinterval) then
			TARGETBAR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
		else
			TARGETBAR_UPDATEINTERVAL = ClassMods.db.profile.targetbar.updateinterval or 0.08
		end
		local targetClass = (select(2, UnitClass("target"))) or "HUNTER"
		local health = UnitHealth("target")
		local maxHealth = UnitHealthMax("target")

		-- Create the Frame
		ClassMods.F.TargetBar = ClassMods.MakeFrame(ClassMods.F.TargetBar, "StatusBar", "CLASSMODS_TARGETBAR", ClassMods.db.profile.targetbar.anchor[2] or UIParent)
		ClassMods.F.TargetBar:SetParent(ClassMods.db.profile.targetbar.anchor[2] or UIParent)
		ClassMods.F.TargetBar:ClearAllPoints()
		ClassMods.F.TargetBar:SetStatusBarTexture(ClassMods.GetActiveTextureFile(ClassMods.db.profile.targetbar.bartexture))
		ClassMods.F.TargetBar:SetMinMaxValues(0, (maxHealth > 0) and maxHealth or 100)
		ClassMods.F.TargetBar:SetStatusBarColor(ClassMods.db.profile.targetbar.classcolored and (unpack({ RAID_CLASS_COLORS[targetClass].r, RAID_CLASS_COLORS[targetClass].g, RAID_CLASS_COLORS[targetClass].b, 1}) ) or unpack(ClassMods.db.profile.targetbar.barcolor) )
		ClassMods.F.TargetBar:SetSize(ClassMods.db.profile.targetbar.width, ClassMods.db.profile.targetbar.height)
		ClassMods.F.TargetBar:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.targetbar.anchor) )
		ClassMods.F.TargetBar:SetAlpha(0)
		ClassMods.F.TargetBar:SetValue(health)

		-- Create the Background and border if the user wants one
		ClassMods.F.TargetBar.background = ClassMods.MakeBackground(ClassMods.F.TargetBar, ClassMods.db.profile.targetbar, nil, nil, ClassMods.F.TargetBar.background)

		ClassMods.RegisterMovableFrame(
			"MOVER_TARGETBAR",
			ClassMods.F.TargetBar,
			ClassMods.F.TargetBar,
			L["Target Bar"],
			ClassMods.db.profile.targetbar,
			ClassMods.SetupTargetBar,
			ClassMods.db.profile.targetbar,
			ClassMods.db.profile.targetbar
		)

		if ClassMods.db.profile.targetbar.smoothbar then
			ClassMods.MakeSmooth(ClassMods.F.TargetBar)
		end

		-- Setup Health Number
		if ClassMods.db.profile.targetbar.healthnumber then
			ClassMods.F.TargetBar.value = ClassMods.F.TargetBar.value or ClassMods.F.TargetBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.TargetBar.value:ClearAllPoints()
			ClassMods.F.TargetBar.value:SetJustifyH("CENTER")
			ClassMods.F.TargetBar.value:SetPoint("CENTER", ClassMods.F.TargetBar, "CENTER", ClassMods.db.profile.targetbar.healthfontoffset, (ClassMods.db.profile.targetbar.shotbar == true) and 2 or 0)
			ClassMods.F.TargetBar.value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.targetbar.healthfont) )
			ClassMods.F.TargetBar.value:SetTextColor(unpack(ClassMods.db.profile.targetbar.healthfontcolor) )
			ClassMods.F.TargetBar.value:SetText(health)
			ClassMods.F.TargetBar.value:Show()
		elseif ClassMods.F.TargetBar.value then
			ClassMods.F.TargetBar.value:Hide()
		end

		-- Setup target health text %
		if ClassMods.db.profile.targetbar.targethealth then
			ClassMods.F.TargetBar.targetHealthValue = ClassMods.F.TargetBar.targetHealthValue or ClassMods.F.TargetBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.TargetBar.targetHealthValue:ClearAllPoints()
			ClassMods.F.TargetBar.targetHealthValue:SetJustifyH("LEFT")
			ClassMods.F.TargetBar.targetHealthValue:SetPoint("CENTER", ClassMods.F.TargetBar, "CENTER", 1 + ClassMods.db.profile.targetbar.percentfontoffset, 0)
			ClassMods.F.TargetBar.targetHealthValue:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.targetbar.percentfont) )
			ClassMods.F.TargetBar.targetHealthValue:SetText("")
			ClassMods.F.TargetBar.targetHealthValue:Show()
		elseif ClassMods.F.TargetBar.targetHealthValue then
			ClassMods.F.TargetBar.targetHealthValue:Hide()
		end

		-- Setup target creature type
		if ClassMods.db.profile.targetbar.targettype then
			ClassMods.F.TargetBar.targetTypeValue = ClassMods.F.TargetBar.targetTypeValue or ClassMods.F.TargetBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.TargetBar.targetTypeValue:ClearAllPoints()
			ClassMods.F.TargetBar.targetTypeValue:SetJustifyH("LEFT")
			ClassMods.F.TargetBar.targetTypeValue:SetPoint("CENTER", ClassMods.F.TargetBar, "CENTER", 1 + ClassMods.db.profile.targetbar.typefontoffset, 0)
			ClassMods.F.TargetBar.targetTypeValue:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.targetbar.typefont) )
			ClassMods.F.TargetBar.targetTypeValue:SetText(UnitCreatureType("target"))
			ClassMods.F.TargetBar.targetTypeValue:Show()
		elseif ClassMods.F.TargetBar.targetTypeValue then
			ClassMods.F.TargetBar.targetTypeValue:Hide()
		end

			-- Setup incoming heal bar
		if ClassMods.db.profile.targetbar.incomingheals then
			ClassMods.F.TargetBar.IncomingHeals = ClassMods.F.TargetBar.IncomingHeals or CreateFrame("StatusBar", nil, ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.IncomingHeals:SetParent(ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.TargetBar.IncomingHeals:SetStatusBarTexture(ClassMods.F.TargetBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.TargetBar.IncomingHeals:SetMinMaxValues(0, 1)
			ClassMods.F.TargetBar.IncomingHeals:SetValue(1)
			ClassMods.F.TargetBar.IncomingHeals:SetFrameLevel(ClassMods.F.TargetBar:GetFrameLevel() )
			ClassMods.F.TargetBar.IncomingHeals:SetSize(0, ClassMods.F.TargetBar:GetHeight() ) -- temp
			ClassMods.F.TargetBar.IncomingHeals:Hide()
		elseif ClassMods.F.TargetBar.IncomingHeals then
			ClassMods.F.TargetBar.IncomingHeals:Hide()
		end

		-- Setup absorbs bar
		if ClassMods.db.profile.targetbar.incomingheals then
			ClassMods.F.TargetBar.Absorbs = ClassMods.F.TargetBar.Absorbs or CreateFrame("StatusBar", nil, ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.Absorbs:SetParent(ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.Absorbs:ClearAllPoints()
			ClassMods.F.TargetBar.Absorbs:SetStatusBarTexture(ClassMods.F.TargetBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.TargetBar.Absorbs:SetMinMaxValues(0, 1)
			ClassMods.F.TargetBar.Absorbs:SetValue(1)
			ClassMods.F.TargetBar.Absorbs:SetFrameLevel(ClassMods.F.TargetBar:GetFrameLevel())
			ClassMods.F.TargetBar.Absorbs:SetSize(0, ClassMods.F.TargetBar:GetHeight() ) -- temp
			ClassMods.F.TargetBar.Absorbs:Hide()
		elseif ClassMods.F.TargetBar.Absorbs then
			ClassMods.F.TargetBar.Absorbs:Hide()
		end

		-- Setup resource bar
		if ClassMods.db.profile.targetbar.resource then
			local powerType = UnitPowerType("target")
			local targetPower = UnitPower("target", powerType)
			local targetPowerMax = UnitPowerMax("target", powerType)
			local barColor = { PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1 }
			ClassMods.F.TargetBar.powerFrame = ClassMods.F.TargetBar.powerFrame or CreateFrame("StatusBar", nil, ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.powerFrame:SetParent(ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.powerFrame:ClearAllPoints()
			ClassMods.F.TargetBar.powerFrame:SetStatusBarTexture(ClassMods.F.TargetBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.TargetBar.powerFrame:SetMinMaxValues(0, (targetPowerMax > 0) and targetPowerMax or 100)
			ClassMods.F.TargetBar.powerFrame:SetStatusBarColor(unpack(barColor))
			ClassMods.F.TargetBar.powerFrame:SetSize(ClassMods.F.TargetBar:GetWidth(), (ceil(ClassMods.F.TargetBar:GetHeight() / 5)))
			ClassMods.F.TargetBar.powerFrame:SetPoint("BOTTOMLEFT", ClassMods.F.TargetBar, "BOTTOMLEFT", 0, 0)
			ClassMods.F.TargetBar.powerFrame:SetValue(petHealth or 0)
			ClassMods.F.TargetBar.powerFrame:SetFrameLevel(ClassMods.F.TargetBar:GetFrameLevel() + 1)
			ClassMods.F.TargetBar.powerFrame.updateTimer = 0
			ClassMods.F.TargetBar.powerFrame:Show()
			ClassMods.F.TargetBar.powerFrame:SetScript("OnUpdate",
				function(self, elapsed)
					local powerType = UnitPowerType("target")
					local targetPower = UnitPower("target", powerType)
					self.updateTimer = self.updateTimer + elapsed
					if self.updateTimer <= 0.015 then return else self.updateTimer = 0 end
					self.updateTimer = 0
					self:SetValue(targetPower)
				end
			)
		elseif ClassMods.F.TargetBar.powerFrame then
			ClassMods.F.TargetBar.powerFrame:Hide()
		end

		-- Setup target classification
		if ClassMods.db.profile.targetbar.classification then
			ClassMods.F.TargetBar.Icon = ClassMods.F.TargetBar.Icon or ClassMods.MakeFrame(ClassMods.F.TargetBar.Icon, "Frame", "Icon", ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.Icon:SetParent(ClassMods.F.TargetBar)
			ClassMods.F.TargetBar.Icon:SetSize(ClassMods.db.profile.targetbar.iconsize, ClassMods.db.profile.targetbar.iconsize)
			ClassMods.F.TargetBar.Icon:SetPoint("CENTER", ClassMods.F.TargetBar, "CENTER", ClassMods.db.profile.targetbar.xoffset, ClassMods.db.profile.targetbar.yoffset)
			ClassMods.F.TargetBar.Icon.Texture = ClassMods.F.TargetBar.Icon.Texture or ClassMods.F.TargetBar.Icon:CreateTexture("Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull", "OVERLAY")
			local targetClassification = UnitClassification("target")
			local classificationTexture = ClassMods.GetActiveTextureFile("None")
			if targetClassification then
				-- "worldboss", "rareelite", "elite", "rare", "normal", "trivial","minus"
				if (targetClassification == "worldboss") then
					ClassMods.F.TargetBar.Icon.Texture:SetTexture("Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull")
					ClassMods.F.TargetBar.Icon:Show()
				elseif (targetClassification == "elite") then
					ClassMods.F.TargetBar.Icon.Texture:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
					ClassMods.F.TargetBar.Icon.Texture:SetAtlas("nameplates-icon-elite-gold")
					ClassMods.F.TargetBar.Icon:Show()
				elseif (targetClassification == "rareelite") or (targetClassification == "rare") then
					ClassMods.F.TargetBar.Icon.Texture:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
					ClassMods.F.TargetBar.Icon.Texture:SetAtlas("nameplates-icon-elite-silver")
					ClassMods.F.TargetBar.Icon:Show()
				else
					ClassMods.F.TargetBar.Icon:Hide()
				end
			end			
			ClassMods.F.TargetBar.Icon.Texture:ClearAllPoints()
			ClassMods.F.TargetBar.Icon.Texture:SetAllPoints(ClassMods.F.TargetBar.Icon)
		elseif ClassMods.F.TargetBar.Icon then
			ClassMods.F.TargetBar.Icon:Hide()
		end

		-- Register Events to support the bar
		ClassMods.F.TargetBar:RegisterEvent("PLAYER_TARGET_CHANGED")
		ClassMods.F.TargetBar:RegisterUnitEvent("UNIT_MAXHEALTH", "target")
		ClassMods.F.TargetBar:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "target")
		ClassMods.F.TargetBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "target")
		ClassMods.F.TargetBar:SetScript("OnEvent",
			function(self, event, ...)
			    local timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

				if (event == "UNIT_MAXHEALTH") then
					self:SetMinMaxValues(0, UnitHealthMax("target"))
				elseif (event == "UNIT_HEALTH_FREQUENT") then
					ClassMods.updateIncomingHealsTarget()
					ClassMods.updateAbsorbsTarget()
				elseif (event == "UNIT_ABSORB_AMOUNT_CHANGED") and (ClassMods.db.profile.targetbar.incomingheals) then
					ClassMods.updateAbsorbsTarget()
				elseif (event == "PLAYER_TARGET_CHANGED") then
					ClassMods.SetupTargetBar()
				end
			end)

		-- Setup the script for handling the bar
		ClassMods.F.TargetBar.updateTimer = 0
		ClassMods.F.TargetBar:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < TARGETBAR_UPDATEINTERVAL then return else self.updateTimer = 0 end
				local health = UnitHealth("target")
				if health <  0 then health = 0 end
				local maxHealth = UnitHealthMax("target")

				-- Overrides take precidence over normal alpha
				if C_PetBattles.IsInBattle() then
					self:SetAlpha(0) -- Hide for pet battles
				elseif ClassMods.db.profile.targetbar.deadoverride and UnitIsDeadOrGhost("player") then
					self:SetAlpha(ClassMods.db.profile.targetbar.deadoverridealpha)
				elseif ClassMods.db.profile.targetbar.mountoverride and (IsMounted() or UnitHasVehicleUI("player") ) and (AuraUtil.FindAuraByName("Telaari Talbuk", "player") == nil) and (AuraUtil.FindAuraByName("Frostwolf War Wolf", "player") == nil) and (AuraUtil.FindAuraByName("Rune of Grasping Earth", "player") == nil) then
					self:SetAlpha(ClassMods.db.profile.targetbar.mountoverridealpha)
				elseif ClassMods.db.profile.targetbar.notargetoverride and (UnitExists("target") == false) then
					self:SetAlpha(ClassMods.db.profile.targetbar.notargetoverridealpha)
				elseif ClassMods.db.profile.targetbar.oocoverride and (not InCombatLockdown() ) then
					self:SetAlpha(ClassMods.db.profile.targetbar.oocoverridealpha)
				elseif (health ~= maxHealth) then
					self:SetAlpha(ClassMods.db.profile.targetbar.activealpha)
				else
					self:SetAlpha(ClassMods.db.profile.targetbar.inactivealpha)
				end

				-- Handle status bar updating
				self:SetValue(health)
				if (health > 0) then
					self:SetStatusBarColor(unpack(getTargetBarColor()))
				end

				if (ClassMods.db.profile.targetbar.healthnumber and self.value) then
					if ClassMods.db.profile.targetbar.abbreviatenumber then
						self.value:SetText(ClassMods.AbbreviateNumber(health))
					else
						self.value:SetText(health)
					end
				end

				-- Update the incoming heals bar, if enabled
				if ClassMods.db.profile.targetbar.incomingheals then
					ClassMods.updateIncomingHealsTarget()
					ClassMods.updateAbsorbsTarget()
				end

				-- Handle Target Health Percentage
				if ClassMods.db.profile.targetbar.targethealth then
					if (not UnitExists("target") ) or (UnitIsDeadOrGhost("target") ) then
						self.targetHealthValue:SetText("")
					else
						if ((health / maxHealth) >= .9) then
							self.targetHealthValue:SetFormattedText("|cffffff00%d %%|r", (health / maxHealth) * 100)
						elseif  ClassMods.db.profile.targetbar.lowwarn and ((health / maxHealth) <= ClassMods.db.profile.targetbar.lowwarnthreshold) then
							self.targetHealthValue:SetFormattedText("|cffffffff%d %%|r", (health / maxHealth) * 100)
						else
							self.targetHealthValue:SetFormattedText("|cffff0000%d %%|r", (health / maxHealth) * 100)
						end
					end
				end

			end)
		ClassMods.F.TargetBar:Show()
	end
end