--
-- ClassMods - health bar module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local UnitHealthMax, UnitHealth = UnitHealthMax, UnitHealth

local function getHealthBarColor(incPrediction)
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local barColor = ClassMods.db.profile.healthbar.barcolor

	if (not incPrediction) then incPrediction = 0 end

	if ClassMods.db.profile.healthbar.classcolored then
		barColor = { RAID_CLASS_COLORS[ClassMods.playerClass].r, RAID_CLASS_COLORS[ClassMods.playerClass].g, RAID_CLASS_COLORS[ClassMods.playerClass].b, 1 }
	end
	if ClassMods.db.profile.healthbar.lowwarn and ( ((health + incPrediction) / maxHealth) <= ClassMods.db.profile.healthbar.lowwarnthreshold) then
		barColor = ClassMods.db.profile.healthbar.barcolorlow
	end
	return barColor
end

function ClassMods.updateIncomingHeals()
	local newPrediction1 = 0
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local barColor1 = getHealthBarColor(newPrediction1)

	if ClassMods.db.profile.healthbar.incomingheals then
		newPrediction1 = UnitGetIncomingHeals("player")
		ClassMods.F.HealthBar.IncomingHeals:SetStatusBarColor(barColor1[1], barColor1[2], barColor1[3], 1)
		if (newPrediction1 ~= 0) and (not UnitIsDeadOrGhost("player") ) then
			if (health + newPrediction1) > maxHealth then
				ClassMods.F.HealthBar.IncomingHeals:SetSize( ((ClassMods.F.HealthBar:GetWidth() / maxHealth) * (maxHealth - health)), ClassMods.F.HealthBar:GetHeight() )
			else
				ClassMods.F.HealthBar.IncomingHeals:SetSize( ((ClassMods.F.HealthBar:GetWidth() / maxHealth) * newPrediction1), ClassMods.F.HealthBar:GetHeight() )
			end
			ClassMods.F.HealthBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.HealthBar.IncomingHeals:SetPoint("LEFT", ClassMods.F.HealthBar, "LEFT", ClassMods.F.HealthBar:GetWidth() / (select(2, ClassMods.F.HealthBar:GetMinMaxValues() ) / ClassMods.F.HealthBar:GetValue()), 0)
			ClassMods.F.HealthBar.IncomingHeals:SetAlpha(ClassMods.F.HealthBar:GetAlpha() * 0.6)
			ClassMods.F.HealthBar.IncomingHeals:Show()
		else
			ClassMods.F.HealthBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.HealthBar.IncomingHeals:SetPoint("LEFT", ClassMods.F.HealthBar, "LEFT", 0, 0)
			ClassMods.F.HealthBar.IncomingHeals:Hide()
		end
	end
end

function ClassMods.updateAbsorbs()
	local newPrediction1 = 0
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")

	if ClassMods.db.profile.healthbar.incomingheals then
		newPrediction1 = UnitGetTotalAbsorbs("player")
		ClassMods.F.HealthBar.Absorbs:SetStatusBarColor(1, 1, 1, 1)
		if (newPrediction1 ~= 0) and (not UnitIsDeadOrGhost("player") ) then
			ClassMods.F.HealthBar.Absorbs:SetSize( ((ClassMods.F.HealthBar:GetWidth() / maxHealth) * newPrediction1), ceil(ClassMods.F.HealthBar:GetHeight() / 2) )
			ClassMods.F.HealthBar.Absorbs:ClearAllPoints()
			if (health + newPrediction1) > maxHealth then
				ClassMods.F.HealthBar.Absorbs:SetPoint("TOPRIGHT", ClassMods.F.HealthBar, "TOPRIGHT", 0, 0 )
			else
				ClassMods.F.HealthBar.Absorbs:SetPoint("TOPLEFT", ClassMods.F.HealthBar, "TOPLEFT", ClassMods.F.HealthBar:GetWidth() / (select(2, ClassMods.F.HealthBar:GetMinMaxValues() ) / ClassMods.F.HealthBar:GetValue()), 0)
			end
			ClassMods.F.HealthBar.Absorbs:SetAlpha(1)
			ClassMods.F.HealthBar.Absorbs:Show()
		else
			ClassMods.F.HealthBar.Absorbs:ClearAllPoints()
			ClassMods.F.HealthBar.Absorbs:SetPoint("LEFT", ClassMods.F.HealthBar, "LEFT", 0, 0)
			ClassMods.F.HealthBar.Absorbs:Hide()
		end
	end
end

function ClassMods.SetupHealthBar()
	-- Destruction
	if ClassMods.F.HealthBar then
		ClassMods.F.HealthBar:Hide()
		ClassMods.F.HealthBar:SetScript("OnUpdate", nil)
		ClassMods.F.HealthBar:SetScript("OnEvent", nil)
		ClassMods.F.HealthBar:UnregisterAllEvents()

		if ClassMods.F.HealthBar.smoother then
			ClassMods.RemoveSmooth(ClassMods.F.HealthBar)
		end

		ClassMods.DeregisterMovableFrame("MOVER_HEALTHBAR")
		ClassMods.F.HealthBar:SetParent(nil)
	end

	-- Construction
	if ClassMods.db.profile.healthbar.enabled then
		local HEALTHBAR_UPDATEINTERVAL = 0.08
		if (ClassMods.db.profile.overrideinterval) then
			HEALTHBAR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
		else
			HEALTHBAR_UPDATEINTERVAL = ClassMods.db.profile.healthbar.updateinterval
		end
		local health = UnitHealth("player")
		if health <  0 then health = 0 end
		local maxHealth = UnitHealthMax("player")

		-- Create the Frame
		ClassMods.F.HealthBar = ClassMods.MakeFrame(ClassMods.F.HealthBar, "StatusBar", "CLASSMODS_HEALTHBAR", ClassMods.db.profile.healthbar.anchor[2] or UIParent)
		ClassMods.F.HealthBar:SetParent(ClassMods.db.profile.healthbar.anchor[2] or UIParent)
		ClassMods.F.HealthBar:ClearAllPoints()
		ClassMods.F.HealthBar:SetStatusBarTexture(ClassMods.GetActiveTextureFile(ClassMods.db.profile.healthbar.bartexture))
		ClassMods.F.HealthBar:SetMinMaxValues(0, (maxHealth > 0) and maxHealth or 100)
		ClassMods.F.HealthBar:SetStatusBarColor(ClassMods.db.profile.healthbar.classcolored and (unpack({ RAID_CLASS_COLORS[ClassMods.playerClass].r, RAID_CLASS_COLORS[ClassMods.playerClass].g, RAID_CLASS_COLORS[ClassMods.playerClass].b, 1}) ) or unpack(ClassMods.db.profile.healthbar.barcolor) )
		ClassMods.F.HealthBar:SetSize(ClassMods.db.profile.healthbar.width, ClassMods.db.profile.healthbar.height)
		ClassMods.F.HealthBar:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.healthbar.anchor) )
		ClassMods.F.HealthBar:SetAlpha(0)
		ClassMods.F.HealthBar:SetValue(health)

		-- Create the Background and border if the user wants one
		ClassMods.F.HealthBar.background = ClassMods.MakeBackground(ClassMods.F.HealthBar, ClassMods.db.profile.healthbar, nil, nil, ClassMods.F.HealthBar.background)

		ClassMods.RegisterMovableFrame(
			"MOVER_HEALTHBAR",
			ClassMods.F.HealthBar,
			ClassMods.F.HealthBar,
			L["Health Bar"],
			ClassMods.db.profile.healthbar,
			ClassMods.SetupHealthBar,
			ClassMods.db.profile.healthbar,
			ClassMods.db.profile.healthbar
		)

		if ClassMods.db.profile.healthbar.smoothbar then
			ClassMods.MakeSmooth(ClassMods.F.HealthBar)
		end

		-- Setup Health Number
		if ClassMods.db.profile.healthbar.healthnumber then
			ClassMods.F.HealthBar.value = ClassMods.F.HealthBar.value or ClassMods.F.HealthBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.HealthBar.value:ClearAllPoints()
			ClassMods.F.HealthBar.value:SetJustifyH("CENTER")
			ClassMods.F.HealthBar.value:SetPoint("CENTER", ClassMods.F.HealthBar, "CENTER", ClassMods.db.profile.healthbar.healthfontoffset, (ClassMods.db.profile.healthbar.shotbar == true) and 2 or 0)
			ClassMods.F.HealthBar.value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.healthbar.healthfont) )
			ClassMods.F.HealthBar.value:SetTextColor(unpack(ClassMods.db.profile.healthbar.healthfontcolor) )
			ClassMods.F.HealthBar.value:SetText(health)
			ClassMods.F.HealthBar.value:Show()
		elseif ClassMods.F.HealthBar.value then
			ClassMods.F.HealthBar.value:Hide()
		end

		-- Setup Pet health bar
		if ClassMods.db.profile.healthbar.pethealthbar then
			local petHealth = UnitHealth("pet")
			local petMaxHealth = UnitHealthMax("pet")
			ClassMods.F.HealthBar.petHealthFrame = ClassMods.F.HealthBar.petHealthFrame or CreateFrame("StatusBar", nil, ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.petHealthFrame:SetParent(ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.petHealthFrame:ClearAllPoints()
			ClassMods.F.HealthBar.petHealthFrame:SetStatusBarTexture(ClassMods.F.HealthBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.HealthBar.petHealthFrame:SetMinMaxValues(0, (petMaxHealth > 0) and petMaxHealth or 100)
			ClassMods.F.HealthBar.petHealthFrame:SetStatusBarColor(unpack(ClassMods.db.profile.healthbar.pethealthbarcolor) )
			ClassMods.F.HealthBar.petHealthFrame:SetSize(ClassMods.F.HealthBar:GetWidth(), (ceil(ClassMods.F.HealthBar:GetHeight() / 5)))
			ClassMods.F.HealthBar.petHealthFrame:SetPoint("BOTTOMLEFT", ClassMods.F.HealthBar, "BOTTOMLEFT", 0, 0)
			ClassMods.F.HealthBar.petHealthFrame:SetValue(petHealth or 0)
			ClassMods.F.HealthBar.petHealthFrame:SetFrameLevel(ClassMods.F.HealthBar:GetFrameLevel() + 1)						
			ClassMods.F.HealthBar.petHealthFrame.updateTimer = 0
			ClassMods.F.HealthBar.petHealthFrame:Show()
			ClassMods.F.HealthBar.petHealthFrame:SetScript("OnUpdate",
				function(self, elapsed)
					local petHealth = UnitHealth("pet")
					self.updateTimer = self.updateTimer + elapsed
					if self.updateTimer <= 0.015 then return else self.updateTimer = 0 end
					self.updateTimer = 0
					self:SetValue(petHealth)
				end
			)
		elseif ClassMods.F.HealthBar.petHealthFrame then
			ClassMods.F.HealthBar.petHealthFrame:Hide()
		end
		
		-- Setup Pet Health Percentage
		if ClassMods.db.profile.healthbar.pethealth then
			ClassMods.F.HealthBar.petHealthValue = ClassMods.F.HealthBar.petHealthValue or ClassMods.F.HealthBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.HealthBar.petHealthValue:ClearAllPoints()
			ClassMods.F.HealthBar.petHealthValue:SetJustifyH("LEFT")
			ClassMods.F.HealthBar.petHealthValue:SetPoint("CENTER", ClassMods.F.HealthBar, "CENTER", 1 + ClassMods.db.profile.healthbar.pethealthfontoffset, 0)
			ClassMods.F.HealthBar.petHealthValue:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.healthbar.pethealthfont) )
			ClassMods.F.HealthBar.petHealthValue:SetText("")
			ClassMods.F.HealthBar.petHealthValue:Show()
		elseif ClassMods.F.HealthBar.petHealthValue then
			ClassMods.F.HealthBar.petHealthValue:Hide()
		end

		-- Setup incoming heal bar
		if ClassMods.db.profile.healthbar.incomingheals then
			ClassMods.F.HealthBar.IncomingHeals = ClassMods.F.HealthBar.IncomingHeals or CreateFrame("StatusBar", nil, ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.IncomingHeals:SetParent(ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.IncomingHeals:ClearAllPoints()
			ClassMods.F.HealthBar.IncomingHeals:SetStatusBarTexture(ClassMods.F.HealthBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.HealthBar.IncomingHeals:SetMinMaxValues(0, 1)
			ClassMods.F.HealthBar.IncomingHeals:SetValue(1)
			ClassMods.F.HealthBar.IncomingHeals:SetFrameLevel(ClassMods.F.HealthBar:GetFrameLevel() )
			ClassMods.F.HealthBar.IncomingHeals:SetSize(0, ClassMods.F.HealthBar:GetHeight() ) -- temp
			ClassMods.F.HealthBar.IncomingHeals:Hide()
		elseif ClassMods.F.HealthBar.IncomingHeals then
			ClassMods.F.HealthBar.IncomingHeals:Hide()
		end

		-- Setup absorbs bar
		if ClassMods.db.profile.healthbar.incomingheals then
			ClassMods.F.HealthBar.Absorbs = ClassMods.F.HealthBar.Absorbs or CreateFrame("StatusBar", nil, ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.Absorbs:SetParent(ClassMods.F.HealthBar)
			ClassMods.F.HealthBar.Absorbs:ClearAllPoints()
			ClassMods.F.HealthBar.Absorbs:SetStatusBarTexture(ClassMods.F.HealthBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.HealthBar.Absorbs:SetMinMaxValues(0, 1)
			ClassMods.F.HealthBar.Absorbs:SetValue(1)
			ClassMods.F.HealthBar.Absorbs:SetFrameLevel(ClassMods.F.HealthBar:GetFrameLevel() + 1)
			ClassMods.F.HealthBar.Absorbs:SetSize(0, ClassMods.F.HealthBar:GetHeight() ) -- temp
			ClassMods.F.HealthBar.Absorbs:Hide()
		elseif ClassMods.F.HealthBar.Absorbs then
			ClassMods.F.HealthBar.Absorbs:Hide()
		end

		-- Register Events to support the bar
		ClassMods.F.HealthBar:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
		ClassMods.F.HealthBar:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
		ClassMods.F.HealthBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player")
		ClassMods.F.HealthBar:SetScript("OnEvent",
			function(self, event, ...)
			    local timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

				if (event == "UNIT_MAXHEALTH") then
					self:SetMinMaxValues(0, UnitHealthMax("player") )
				elseif (event == "UNIT_HEALTH_FREQUENT") then
					ClassMods.updateIncomingHeals()
					ClassMods.updateAbsorbs()
				elseif (event == "UNIT_ABSORB_AMOUNT_CHANGED") and (ClassMods.db.profile.healthbar.incomingheals) then
					ClassMods.updateAbsorbs()
				elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
					ClassMods.SetupHealthBar()
				end
			end)

		-- Setup the script for handling the bar
		ClassMods.F.HealthBar.updateTimer = 0
		ClassMods.F.HealthBar:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < HEALTHBAR_UPDATEINTERVAL then return else self.updateTimer = 0 end
				local health = UnitHealth("player")
				local maxHealth = UnitHealthMax("player")

				-- Overrides take precidence over normal alpha
				if C_PetBattles.IsInBattle() then
					self:SetAlpha(0) -- Hide for pet battles
				elseif ClassMods.db.profile.healthbar.deadoverride and UnitIsDeadOrGhost("player") then
					self:SetAlpha(ClassMods.db.profile.healthbar.deadoverridealpha)
				elseif ClassMods.db.profile.healthbar.mountoverride and (IsMounted() or UnitHasVehicleUI("player") ) and (AuraUtil.FindAuraByName("Telaari Talbuk", "player") == nil) and (AuraUtil.FindAuraByName("Frostwolf War Wolf", "player") == nil) and (AuraUtil.FindAuraByName("Rune of Grasping Earth", "player") == nil) then
					self:SetAlpha(ClassMods.db.profile.healthbar.mountoverridealpha)
				elseif ClassMods.db.profile.healthbar.oocoverride and (not InCombatLockdown() ) then
					self:SetAlpha(ClassMods.db.profile.healthbar.oocoverridealpha)
				elseif (health ~=  maxHealth) then
					self:SetAlpha(ClassMods.db.profile.healthbar.activealpha)
				else
					self:SetAlpha(ClassMods.db.profile.healthbar.inactivealpha)
				end

				-- Handle status bar updating
				self:SetValue(health)
				self:SetStatusBarColor(unpack(getHealthBarColor()) )

				if (ClassMods.db.profile.healthbar.healthnumber and self.value) then
					if ClassMods.db.profile.healthbar.abbreviatenumber then
						self.value:SetText(ClassMods.AbbreviateNumber(health))
					else
						self.value:SetText(health)
					end
				end

				-- Update the incoming heals bar, if enabled
				if ClassMods.db.profile.healthbar.incomingheals then
					ClassMods.updateIncomingHeals()
					ClassMods.updateAbsorbs()
				end

				-- Handle Pet Health Percentage
				if ClassMods.db.profile.healthbar.pethealth then
					local petHealth = UnitHealth("pet")
					local petHealthMax = UnitHealthMax("pet")
					if (not UnitExists("pet") ) or (UnitIsDeadOrGhost("pet") ) then
						self.petHealthValue:SetText("")
					else
						if ( (petHealth / UnitHealthMax("pet") ) >= .9) then
							self.petHealthValue:SetFormattedText("|cffffff00%d %%|r", (petHealth / petHealthMax ) * 100)
						elseif ( (petHealth / UnitHealthMax("pet") ) >= .35) then
							self.petHealthValue:SetFormattedText("|cffffffff%d %%|r", (petHealth / petHealthMax ) * 100)
						else
							self.petHealthValue:SetFormattedText("|cffff0000%d %%|r", (petHealth / petHealthMax ) * 100)
						end
					end
				end
			end)
		ClassMods.F.HealthBar:Show()
	end
end