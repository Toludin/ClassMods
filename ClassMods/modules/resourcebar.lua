--
-- ClassMods - resource bar module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local select, UnitAura = select, UnitAura
local _

local function getResourceBarColor(incPrediction)
	local playerSpec = GetSpecialization()
	local name1, cost1, tColor1, tCost1
	local powerType = UnitPowerType("player")
	local playerPower = UnitPower("player", powerType)
	local playerPowerMax = UnitPowerMax("player", powerType)
	local barColor = { PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1 }

	if (ClassMods.db.profile.resourcebar.barcolorenable) then
		barColor = ClassMods.db.profile.resourcebar.barcolor
	end

	if (ClassMods.enableticks == true) then
		local mainSpellCost = ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][1][2], playerSpec)
	end

	if (not incPrediction) then incPrediction = 0 end
	if (not mainSpellCost) then mainSpellCost = 0 end

	-- High resource warning enabled AND resource is over theshhold
	if ClassMods.db.profile.resourcebar.highwarn and ( ((playerPower + incPrediction)) >= ClassMods.db.profile.resourcebar.highwarnthreshold) then
		barColor = ClassMods.db.profile.resourcebar.barcolorhigh
	end

	-- Low resource warning enabled AND resrouce is under threshold
	if ClassMods.db.profile.resourcebar.lowwarn and ( (playerPower + incPrediction) < ClassMods.db.profile.resourcebar.lowwarnthreshold) then
		barColor = ClassMods.db.profile.resourcebar.barcolorlow
	end

	-- Class has active indicators
	if (ClassMods.enableticks == true) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][1][1] == true) then
		tColor1, tCost1 = false, 0
		for i=1,5 do
			if (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][1] == true) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][4] == true) then
				name1 = select(1, GetSpellInfo(ClassMods.db.profile.resourcebar.ticks[playerSpec][i][2]))
				cost1 = ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][i][2], playerSpec)
				if (name1 and cost1 and (cost1 > 0) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][6] == powerType)) then
					if (i == 1) then
						if (playerPower >= mainSpellCost) then
							tCost1 = mainSpellCost
							tColor1 = ClassMods.db.profile.resourcebar.ticks[playerSpec][i][5]
						end
					elseif (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][3] == true) and (playerPower >= (ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][1][2], playerSpec) + cost1) ) and ( (mainSpellCost + cost1) > tCost1) then
						tCost1 = mainSpellCost + cost1
						tColor1 = ClassMods.db.profile.resourcebar.ticks[playerSpec][i][5]
					elseif (playerPower >= cost1) and (cost1 > tCost1) and (cost1 > tCost1) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][3] ~= true) then
						tCost1 = cost1
						tColor1 = ClassMods.db.profile.resourcebar.ticks[playerSpec][i][5]
					end
				end
			end
		end
		if (tColor1 ~= false) then
			barColor = tColor1
		end
	end
	return barColor
end

local function updatePrediction()
	local powerType = UnitPowerType("player")
	local playerPower = UnitPower("player", powerType)
	local playerPowerMax = UnitPowerMax("player", powerType)
	local newPrediction1, barColor1

	if ClassMods.db.profile.resourcebar.enableprediction and ClassMods.F.ResourceBar.playerIsCasting then
		newPrediction1 = ClassMods.GetBaseGeneration()
		barColor1 = getResourceBarColor(newPrediction1)
		ClassMods.F.ResourceBar.PredictionFrame:SetSize( (ClassMods.F.ResourceBar:GetWidth() / playerPowerMax) * newPrediction1, ClassMods.F.ResourceBar:GetHeight() )
		ClassMods.F.ResourceBar.PredictionFrame:ClearAllPoints()

		if (ClassMods.F.ResourceBar:GetValue() ~= 0) then
			ClassMods.F.ResourceBar.PredictionFrame:SetPoint("LEFT", ClassMods.F.ResourceBar, "LEFT", ClassMods.F.ResourceBar:GetWidth() / (select(2, ClassMods.F.ResourceBar:GetMinMaxValues() ) / ClassMods.F.ResourceBar:GetValue()), 0)
		else
			ClassMods.F.ResourceBar.PredictionFrame:SetPoint("LEFT", ClassMods.F.ResourceBar, "LEFT", 0, 0)
		end

		if (playerPower + newPrediction1) > playerPowerMax then
			ClassMods.F.ResourceBar.PredictionFrame:SetSize( ((ClassMods.F.ResourceBar:GetWidth() / playerPowerMax) * (playerPowerMax - playerPower )), ClassMods.F.ResourceBar:GetHeight() )
		end

		ClassMods.F.ResourceBar.PredictionFrame:SetStatusBarColor(barColor1[1], barColor1[2], barColor1[3], 1)

		if ( (playerPowerMax - playerPower ) > 0) and (not UnitIsDeadOrGhost("player") ) then
			ClassMods.F.ResourceBar.PredictionFrame:SetAlpha(ClassMods.F.ResourceBar:GetAlpha() * 0.6)
			ClassMods.F.ResourceBar.PredictionFrame:Show()
		else
			ClassMods.F.ResourceBar.PredictionFrame:Hide()
		end
	end
end

function ClassMods.GetBaseGeneration()
	local playerSpec = GetSpecialization()
	local castingSpell = UnitCastingInfo("player")
	local baseGeneration = 0

	if ClassMods.powerGenerationSpells[playerSpec] then
		for i=1,#ClassMods.powerGenerationSpells[playerSpec] do
			if (GetSpellInfo(tonumber(ClassMods.powerGenerationSpells[playerSpec][i][1])) == castingSpell) then
				baseGeneration = ClassMods.powerGenerationSpells[playerSpec][i][2]
				break -- we found the spell we want
			end
		end
	end

	if (select(2, UnitClass("player")) == "DRUID") then
		--if UnitAura("player", "Celestial Alignment") or UnitAura("player", "Incarnation: Chosen of Elune") then -- increases Lunar Power by 50%
		--	baseGeneration = baseGeneration + ceil(baseGeneration * .5)
		--end

		--if UnitAura("player", "Blessing of Elune") then -- increases Lunar Power by 25%
		--	baseGeneration = baseGeneration + ceil(baseGeneration * .25)
		--end
	end

	if (select(2, UnitClass("player")) == "PRIEST") then
		if AuraUtil.FindAuraByName("Surrender to Madness", "player") then -- increases Insanity by 100%
			baseGeneration = baseGeneration + ceil(baseGeneration)
		end

		-- Check if player has the Talent: Fortress of the Mind
		if (IsPlayerSpell(193195)) and ( (castingSpell == "Mind Blast") or (castingSpell == "Mind Flay") ) then -- increases Insanity by 20%
			baseGeneration = baseGeneration + ceil(baseGeneration * .2)
		end
	end

	return baseGeneration
end

--
-- Setup ResourceBar
--
function ClassMods.SetupResourceBar()
	local playerSpec = GetSpecialization()
	local powerType = UnitPowerType("player")
	local playerPower = UnitPower("player", powerType)
	local playerPowerMax = UnitPowerMax("player", powerType)

	-- Destruction
	local ii = 1
	if ClassMods.F.StackBars then
		while (ClassMods.F.StackBars[ii] ~= nil) do
			ClassMods.F.StackBars[ii]:Hide()
			ClassMods.F.StackBars[ii]:UnregisterAllEvents()
			ClassMods.F.StackBars[ii]:SetScript("OnUpdate", nil)
			ClassMods.F.StackBars[ii]:SetParent(nil)
			ii = ii + 1
		end
	end

	if ClassMods.F.StackBarsHost then
		ClassMods.F.StackBarsHost:Hide()
		ClassMods.DeregisterMovableFrame("MOVER_STACKBARS")
		ClassMods.F.StackBarsHost:SetParent(nil)
	end

	if ClassMods.F.ResourceBar then
		ClassMods.F.ResourceBar:Hide()
		ClassMods.F.ResourceBar:SetScript("OnUpdate", nil)
		ClassMods.F.ResourceBar:SetScript("OnEvent", nil)
		ClassMods.F.ResourceBar:UnregisterAllEvents()
		if ClassMods.F.ResourceBar.autoAttackFrame then
			ClassMods.F.ResourceBar.autoAttackFrame:SetScript("OnUpdate", nil)
			if ClassMods.F.ResourceBar.autoAttackFrame.smoother then
				ClassMods.RemoveSmooth(ClassMods.F.ResourceBar.autoAttackFrame)
			end
		end
		if ClassMods.F.ResourceBar.smoother then
			ClassMods.RemoveSmooth(ClassMods.F.ResourceBar)
		end
		ClassMods.DeregisterMovableFrame("MOVER_RESOURCEBAR")
		ClassMods.F.ResourceBar:SetParent(nil)
	end

	-- Construction
	if ClassMods.db.profile.resourcebar.enabled then
		local RESOURCEBAR_UPDATEINTERVAL = 0.08
		if (ClassMods.db.profile.overrideinterval) then
			RESOURCEBAR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
		else
			RESOURCEBAR_UPDATEINTERVAL = ClassMods.db.profile.resourcebar.updateinterval
		end
		-- Create the Frame
		ClassMods.F.ResourceBar = ClassMods.MakeFrame(ClassMods.F.ResourceBar, "StatusBar", "CLASSMODS_RESOURCEBAR", ClassMods.db.profile.resourcebar.anchor[2] or UIParent)
		ClassMods.F.ResourceBar:SetParent(ClassMods.db.profile.resourcebar.anchor[2] or UIParent)
		ClassMods.F.ResourceBar:ClearAllPoints()
		ClassMods.F.ResourceBar:SetStatusBarTexture(ClassMods.GetActiveTextureFile(ClassMods.db.profile.resourcebar.bartexture) )
		ClassMods.F.ResourceBar:SetMinMaxValues(0, (playerPowerMax > 0) and playerPowerMax or 100)
		ClassMods.F.ResourceBar:SetStatusBarColor(unpack({ PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1}))
		ClassMods.F.ResourceBar:SetSize(ClassMods.db.profile.resourcebar.width, ClassMods.db.profile.resourcebar.height)
		ClassMods.F.ResourceBar:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.resourcebar.anchor) )
		ClassMods.F.ResourceBar:SetAlpha(0)
		ClassMods.F.ResourceBar:SetValue(playerPower)

		ClassMods.F.ResourceBar.background = ClassMods.MakeBackground(ClassMods.F.ResourceBar, ClassMods.db.profile.resourcebar, nil, nil, ClassMods.F.ResourceBar.background)

		ClassMods.RegisterMovableFrame(
			"MOVER_RESOURCEBAR",
			ClassMods.F.ResourceBar,
			ClassMods.F.ResourceBar,
			L["Resource Bar"],
			ClassMods.db.profile.resourcebar,
			ClassMods.SetupResourceBar,
			ClassMods.db.profile.resourcebar,
			ClassMods.db.profile.resourcebar
		)

		if ClassMods.db.profile.resourcebar.smoothbar then
			ClassMods.MakeSmooth(ClassMods.F.ResourceBar)
		end

		if ClassMods.db.profile.resourcebar.resourcenumber then
			ClassMods.F.ResourceBar.value = ClassMods.F.ResourceBar.value or ClassMods.F.ResourceBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.ResourceBar.value:ClearAllPoints()
			ClassMods.F.ResourceBar.value:SetJustifyH("CENTER")
			ClassMods.F.ResourceBar.value:SetPoint("CENTER", ClassMods.F.ResourceBar, "CENTER", ClassMods.db.profile.resourcebar.resourcefontoffset, (ClassMods.db.profile.resourcebar.autoattackbar == true) and 2 or 0)
			ClassMods.F.ResourceBar.value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.resourcebar.resourcefont) )
			ClassMods.F.ResourceBar.value:SetTextColor(unpack(ClassMods.db.profile.resourcebar.resourcefontcolor) )
			ClassMods.F.ResourceBar.value:SetText(playerPower )
			ClassMods.F.ResourceBar.value:Show()
		elseif ClassMods.F.ResourceBar.value then
			ClassMods.F.ResourceBar.value:Hide()
		end

		-- Setup target health text
		if ClassMods.db.profile.resourcebar.targethealth then
			ClassMods.F.ResourceBar.targetHealthValue = ClassMods.F.ResourceBar.targetHealthValue or ClassMods.F.ResourceBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.ResourceBar.targetHealthValue:ClearAllPoints()
			ClassMods.F.ResourceBar.targetHealthValue:SetJustifyH("LEFT")
			ClassMods.F.ResourceBar.targetHealthValue:SetPoint("CENTER", ClassMods.F.ResourceBar, "CENTER", 1 + ClassMods.db.profile.resourcebar.healthfontoffset, (ClassMods.db.profile.resourcebar.autoattackbar == true) and 2 or 0)
			ClassMods.F.ResourceBar.targetHealthValue:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.resourcebar.healthfont) )
			ClassMods.F.ResourceBar.targetHealthValue:SetText("")
			ClassMods.F.ResourceBar.targetHealthValue:Show()
		elseif ClassMods.F.ResourceBar.targetHealthValue then
			ClassMods.F.ResourceBar.targetHealthValue:Hide()
		end

		-- Setup prediction bar
		if ClassMods.db.profile.resourcebar.enableprediction then
			ClassMods.F.ResourceBar.PredictionFrame = ClassMods.F.ResourceBar.PredictionFrame or CreateFrame("StatusBar", nil, ClassMods.F.ResourceBar)
			ClassMods.F.ResourceBar.PredictionFrame:SetParent(ClassMods.F.ResourceBar)
			ClassMods.F.ResourceBar.PredictionFrame:ClearAllPoints()
			ClassMods.F.ResourceBar.PredictionFrame:SetStatusBarTexture(ClassMods.F.ResourceBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.ResourceBar.PredictionFrame:SetMinMaxValues(0, 1)
			ClassMods.F.ResourceBar.PredictionFrame:SetValue(1)
			ClassMods.F.ResourceBar.PredictionFrame:SetFrameLevel(ClassMods.F.ResourceBar:GetFrameLevel() )
			ClassMods.F.ResourceBar.PredictionFrame:SetSize( (ClassMods.F.ResourceBar:GetWidth() / 100) * (ClassMods.GetBaseGeneration() ), ClassMods.F.ResourceBar:GetHeight() )
			ClassMods.F.ResourceBar.PredictionFrame:Hide()
		elseif ClassMods.F.ResourceBar.PredictionFrame then
			ClassMods.F.ResourceBar.PredictionFrame:Hide()
		end

		-- Setup Auto autoattack bar
		if ClassMods.db.profile.resourcebar.autoattackbar then
			local attackSpeed = select(1, UnitAttackSpeed("player"))
			ClassMods.F.ResourceBar.autoAttackFrame = ClassMods.F.ResourceBar.autoAttackFrame or CreateFrame("StatusBar", nil, ClassMods.F.ResourceBar)
			ClassMods.F.ResourceBar.autoAttackFrame:SetParent(ClassMods.F.ResourceBar)
			ClassMods.F.ResourceBar.autoAttackFrame:ClearAllPoints()
			ClassMods.F.ResourceBar.autoAttackFrame:SetStatusBarTexture(ClassMods.F.ResourceBar:GetStatusBarTexture():GetTexture() ) -- Use the main bar's texture
			ClassMods.F.ResourceBar.autoAttackFrame:SetMinMaxValues(0, attackSpeed * 100)
			ClassMods.F.ResourceBar.autoAttackFrame:SetPoint("BOTTOMLEFT", ClassMods.F.ResourceBar, "BOTTOMLEFT", 0, 0)
			ClassMods.F.ResourceBar.autoAttackFrame:SetSize(ClassMods.F.ResourceBar:GetWidth(), 3)
			ClassMods.F.ResourceBar.autoAttackFrame:SetValue(attackSpeed)
			ClassMods.F.ResourceBar.autoAttackFrame:SetFrameLevel(ClassMods.F.ResourceBar:GetFrameLevel() + 1)
			ClassMods.F.ResourceBar.autoAttackFrame:SetStatusBarColor(unpack(ClassMods.db.profile.resourcebar.autoattackbarcolor) )

			if ClassMods.db.profile.resourcebar.smoothbarautoattackbar then
				ClassMods.MakeSmooth(ClassMods.F.ResourceBar.autoAttackFrame)
			end

			ClassMods.F.ResourceBar.autoAttackFrame.updateTimer = 0
			ClassMods.F.ResourceBar.autoAttackFrame:SetScript("OnUpdate",
				function(self, elapsed)
					local attackSpeed = select(1, UnitAttackSpeed("player"))
					self.updateTimer = self.updateTimer + elapsed
					if self.updateTimer <= 0.015 then return else self.updateTimer = 0 end
					self.updateTimer = 0
					if (GetTime() < self:GetParent().autoAttackEndTime) then
						self:SetValue( (attackSpeed * 100) - ( (self:GetParent().autoAttackEndTime * 100) - (GetTime() * 100) ) )
					else
						self:SetValue(0)
						self:Hide()
					end
				end
			)
		elseif ClassMods.F.ResourceBar.autoAttackFrame then
			ClassMods.F.ResourceBar.autoAttackFrame:Hide()
		end

		-- Setup Auto Attack time
		if ClassMods.db.profile.resourcebar.autoattacktimer then
			ClassMods.F.ResourceBar.autoAttackValue = ClassMods.F.ResourceBar.autoAttackValue or ClassMods.F.ResourceBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.ResourceBar.autoAttackValue:ClearAllPoints()
			ClassMods.F.ResourceBar.autoAttackValue:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.resourcebar.autoattacktimerfont) )
			ClassMods.F.ResourceBar.autoAttackValue:SetTextColor(unpack(ClassMods.db.profile.resourcebar.autoattacktimerfontcolor) )
			ClassMods.F.ResourceBar.autoAttackValue:SetPoint("BOTTOMRIGHT", ClassMods.F.ResourceBar, "BOTTOMRIGHT", 1  + ClassMods.db.profile.resourcebar.autoattacktimerfontoffset, 1)
			ClassMods.F.ResourceBar.autoAttackValue:SetJustifyH("BOTTOM")
			ClassMods.F.ResourceBar.autoAttackValue:Show()
		elseif ClassMods.F.ResourceBar.autoAttackValue then
			ClassMods.F.ResourceBar.autoAttackValue:Hide()
		end

		-- Setup tick marks
		if (ClassMods.enableticks == true) then
			local name, cost, icon
			for ii=1,5 do
				if (ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][1] == true) then
					name = select(1, GetSpellInfo(ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][2]))
					cost = ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][2], playerSpec)
					if (name and cost and (cost > 0) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][6] == powerType)) then
						ClassMods.F.ResourceBar["indicatorTick"..ii] = ClassMods.MakeFrame(ClassMods.F.ResourceBar["indicatorTick"..ii], "Frame", "CLASSMODS_RESOURCEBAR_TICK"..ii, ClassMods.F.ResourceBar)
						ClassMods.F.ResourceBar["indicatorTick"..ii]:SetParent(ClassMods.F.ResourceBar)
						ClassMods.F.ResourceBar["indicatorTick"..ii]:ClearAllPoints()

						if ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][7] == true then
							ClassMods.F.ResourceBar["indicatorTick"..ii]:SetSize(6, ClassMods.F.ResourceBar:GetHeight() * 1.1)
						else
							ClassMods.F.ResourceBar["indicatorTick"..ii]:SetSize(10, ClassMods.F.ResourceBar:GetHeight() * 1.6)
						end

						ClassMods.F.ResourceBar["indicatorTick"..ii].tex = ClassMods.F.ResourceBar["indicatorTick"..ii].tex or ClassMods.F.ResourceBar["indicatorTick"..ii]:CreateTexture(nil, "OVERLAY")
						ClassMods.F.ResourceBar["indicatorTick"..ii].tex:ClearAllPoints()
						ClassMods.F.ResourceBar["indicatorTick"..ii].tex:SetAllPoints(ClassMods.F.ResourceBar["indicatorTick"..ii])

						if (ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][7] == true) then
							icon = select(3, GetSpellInfo(ClassMods.db.profile.resourcebar.ticks[playerSpec][ii][2]))
						else
							icon = "Interface\\CastingBar\\UI-CastingBar-Spark"
						end

						ClassMods.F.ResourceBar["indicatorTick"..ii].tex:SetTexture(icon)
						ClassMods.F.ResourceBar["indicatorTick"..ii].tex:SetBlendMode("ADD")
						ClassMods.F.ResourceBar["indicatorTick"..ii]:SetAlpha(1)
						ClassMods.F.ResourceBar["indicatorTick"..ii]:Hide()

					elseif ClassMods.F.ResourceBar["indicatorTick"..ii] then
						ClassMods.F.ResourceBar["indicatorTick"..ii]:Hide()
					end
				elseif ClassMods.F.ResourceBar["indicatorTick"..ii] then
					ClassMods.F.ResourceBar["indicatorTick"..ii]:Hide()
				end
			end
		end

		-- Register Events to support the bar
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_SPELLCAST_START")
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_SPELLCAST_STOP")
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_SPELLCAST_FAILED")
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_MAXPOWER")
		ClassMods.F.ResourceBar:RegisterEvent("UNIT_DISPLAYPOWER")
		ClassMods.F.ResourceBar:RegisterEvent("PLAYER_ENTER_COMBAT")
		ClassMods.F.ResourceBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
		ClassMods.F.ResourceBar.autoAttackStartTime = 0
		ClassMods.F.ResourceBar.autoAttackEndTime = 0
		ClassMods.F.ResourceBar:SetScript("OnEvent",
			function(self, event, ...)
				self.sourceUnit1, self._, self._, self._, self.spellId1 = ...
				local timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
				local attackSpeed = select(1, UnitAttackSpeed("player"))
				local playerSpec = GetSpecialization()

				if (event == "UNIT_SPELLCAST_START") and ClassMods.db.profile.resourcebar.enableprediction then
					if (self.sourceUnit1 == "player") then
						if ClassMods.powerGenerationSpells[playerSpec] then
							for i=1,#ClassMods.powerGenerationSpells[playerSpec] do
								if ClassMods.powerGenerationSpells[playerSpec][i][1] == self.spellId1 then
									self.playerIsCasting = true
									updatePrediction()
								end
							end
						end
					end
				elseif (event == "UNIT_SPELLCAST_SUCCEEDED") and (self.spellId1 == 75) and (ClassMods.db.profile.resourcebar.autoattackbar or ClassMods.db.profile.resourcebar.autoattacktimer) then -- Auto autoattack
					self.autoAttackStartTime = GetTime()
					self.autoAttackEndTime = self.autoAttackStartTime + select(1, UnitAttackSpeed("player"))
					if ClassMods.db.profile.resourcebar.autoattackbar then
						self.autoAttackFrame:Show()
					end
					if ClassMods.db.profile.resourcebar.autoattacktimer then
						self.autoAttackValue:SetFormattedText("%.1f", self.autoAttackEndTime - GetTime() )
					end
				elseif ((event == "UNIT_SPELLCAST_STOP") or (event == "UNIT_SPELLCAST_FAILED")) and ClassMods.db.profile.resourcebar.enableprediction then
					if ClassMods.powerGenerationSpells[playerSpec] then
						for i=1,#ClassMods.powerGenerationSpells[playerSpec] do
							if ClassMods.powerGenerationSpells[playerSpec][i][1] == self.spellId1 then
								self.playerIsCasting = nil
								self.PredictionFrame:Hide()
							end
						end
					end
				elseif (event == "UNIT_MAXPOWER") then
					self:SetMinMaxValues(0, playerPowerMax )
				elseif (event == "UNIT_DISPLAYPOWER") then
					ClassMods.SetupResourceBar()
				elseif (event == "PLAYER_ENTER_COMBAT") and (ClassMods.db.profile.resourcebar.autoattackbar or ClassMods.db.profile.resourcebar.autoattacktimer) then -- Auto Attack
					self.autoAttackStartTime = GetTime()
					self.autoAttackEndTime = self.autoAttackStartTime + attackSpeed
					if ClassMods.db.profile.resourcebar.autoattackbar then
						self.autoAttackFrame:Show()
					end
					if ClassMods.db.profile.resourcebar.autoattacktimer then
						self.autoAttackValue:SetFormattedText("%.1f", self.autoAttackEndTime - GetTime() )
					end
				elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") and (ClassMods.db.profile.resourcebar.autoattackbar or ClassMods.db.profile.resourcebar.autoattacktimer) then
					if ((eventtype == "SWING_DAMAGE") or (eventtype == "SWING_MISSED")) and (sourceGUID == UnitGUID("player")) then
						self.autoAttackStartTime = GetTime()
						self.autoAttackEndTime = self.autoAttackStartTime + attackSpeed
						if ClassMods.db.profile.resourcebar.autoattackbar then
							self.autoAttackFrame:Show()
						end
						if ClassMods.db.profile.resourcebar.autoattacktimer then
							self.autoAttackValue:SetFormattedText("%.1f", self.autoAttackEndTime - GetTime() )
						end
					end
				end
			end
		)

		-- Setup the script for handling the bar
		ClassMods.F.ResourceBar.updateTimer = 0
		ClassMods.F.ResourceBar.doPrediction = ClassMods.db.profile.resourcebar.enableprediction
		ClassMods.F.ResourceBar:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < RESOURCEBAR_UPDATEINTERVAL then return else self.updateTimer = 0 end

				local powerType = UnitPowerType("player")
				local playerPower = UnitPower("player", powerType)
				local playerPowerMax = UnitPowerMax("player", powerType)

				-- Overrides take precidence over normal alpha
				if C_PetBattles.IsInBattle() then
					self:SetAlpha(0) -- Hide for pet battles
				elseif ClassMods.db.profile.resourcebar.deadoverride and UnitIsDeadOrGhost("player") then
					self:SetAlpha(ClassMods.db.profile.resourcebar.deadoverridealpha)
				elseif ClassMods.db.profile.resourcebar.mountoverride and (IsMounted() or UnitHasVehicleUI("player") ) and (AuraUtil.FindAuraByName("Telaari Talbuk", "player") == nil) and (AuraUtil.FindAuraByName("Frostwolf War Wolf", "player") == nil) and (AuraUtil.FindAuraByName("Rune of Grasping Earth", "player") == nil) then
					self:SetAlpha(ClassMods.db.profile.resourcebar.mountoverridealpha)
				elseif ClassMods.db.profile.resourcebar.oocoverride and (not InCombatLockdown() ) then
					self:SetAlpha(ClassMods.db.profile.resourcebar.oocoverridealpha)
				elseif (playerPower ~= playerPowerMax) then
					self:SetAlpha(ClassMods.db.profile.resourcebar.activealpha)
				else
					self:SetAlpha(ClassMods.db.profile.resourcebar.inactivealpha)
				end

				-- Handle status bar updating
				self:SetValue(playerPower)

				-- Set resource number if enabled
				if (ClassMods.db.profile.resourcebar.resourcenumber and self.value) then
					if ClassMods.db.profile.resourcebar.abbreviatenumber then
						playerPower = ClassMods.AbbreviateNumber(playerPower)
					end
					self.value:SetText(playerPower)
				end

				self:SetStatusBarColor(unpack(getResourceBarColor() ) )

				-- Update the prediction bar, if enabled
				if self.doPrediction then updatePrediction() end

				-- Update auto attack time
				if ClassMods.db.profile.resourcebar.autoattacktimer then
					if (not UnitIsDeadOrGhost("player") ) and (GetTime() < self.autoAttackEndTime) and InCombatLockdown() then
						self.autoAttackValue:SetFormattedText("%.1f", self.autoAttackEndTime - GetTime() )
					else
						self.autoAttackValue:SetText("")
					end
				end

				-- Handle Target Health Percentage
				if ClassMods.db.profile.resourcebar.targethealth then
					if (not UnitExists("target") ) or (UnitIsDeadOrGhost("target") ) then
						self.targetHealthValue:SetText("")
					else
						self.targetHealthValue:SetFormattedText("|cffff0000%d %%|r", (UnitHealth("target") / UnitHealthMax("target") ) * 100)
					end
				end

				-- Handle indicator tick marks
				if (ClassMods.db.profile.resourcebar.ticks[playerSpec][1][1] == true) then
					local mainSpellCost = ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][1][2], playerSpec)
					for i=1,5 do
						if (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][1] == true) and (self["indicatorTick"..i] ~= nil) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][1][1] == true) then
							self.name2 = select(1, GetSpellInfo(ClassMods.db.profile.resourcebar.ticks[playerSpec][i][2]))
							self.cost2 = ClassMods.GetSpellCost(ClassMods.db.profile.resourcebar.ticks[playerSpec][i][2], playerSpec)

							if (self.name2 and self.cost2 and (self.cost2 > 0)) and (ClassMods.CheckIfKnown(ClassMods.db.profile.resourcebar.ticks[playerSpec][i][2])) and (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][6] == powerType) then
								if (i == 1) then
									self["indicatorTick"..i]:ClearAllPoints()
									self["indicatorTick"..i]:SetPoint("LEFT", self, "LEFT", mainSpellCost * (self:GetWidth() / select(2, self:GetMinMaxValues() ) ) - 5, 0)
								else
									self["indicatorTick"..i]:ClearAllPoints()
									self["indicatorTick"..i]:SetPoint("LEFT", self, "LEFT", ( (ClassMods.db.profile.resourcebar.ticks[playerSpec][i][3] == true) and (mainSpellCost + self.cost2) or self.cost2) * (self:GetWidth() / select(2, self:GetMinMaxValues() ) ) - 5, 0)
								end
								self["indicatorTick"..i]:Show()
							else
								self["indicatorTick"..i]:Hide()
							end
						end
					end
				end
			end
		)
		ClassMods.F.ResourceBar:Show()
	end

	-- Construct the Stacks indicator
	if (not ClassMods.db.profile.resourcebar.enablestacks) then return end
	if (not ClassMods.db.profile.resourcebar.enabled) and (ClassMods.db.profile.resourcebar.embedstacks) then return end

	local STACKBARS_UPDATEINTERVAL = 0.1
	local numBars = 1
	local barSize = 0
	local checkFunction = function(self) return end
	local checkStacksFunction = function(self) return(0) end
	local checkProcFunction = function(self) return end
	local stackSize = 0

	-- Setup the host frame & mover if not embedded
	ClassMods.F.StackBarsHost = ClassMods.MakeFrame(ClassMods.F.StackBarsHost, "Frame", "CLASSMODS_STACKBARS_HOST", ClassMods.db.profile.resourcebar.embedstacks and ClassMods.F.ResourceBar or (ClassMods.db.profile.resourcebar.anchor_stacks[2] or UIParent) )
	ClassMods.F.StackBarsHost:SetParent(ClassMods.db.profile.resourcebar.embedstacks and ClassMods.F.ResourceBar or (ClassMods.db.profile.resourcebar.anchor_stacks[2] or UIParent) )
	ClassMods.F.StackBarsHost:ClearAllPoints()
	ClassMods.stackBarOn = false

	-- Setup the check functions for various specs
	ClassMods.F.StackBarsHost.stacks = nil
	ClassMods.F.StackBarsHost.proc = nil

	-- Create Stacks Flashing Options
	local Check_Flash = {}
	Check_Flash["AtMax"] = function(self)
		ClassMods.F.StackBarsHost.stacks = checkStacksFunction()

		if ClassMods.F.StackBarsHost.stacks >= self.barIndex then
			if (ClassMods.F.StackBarsHost.stacks >= self.totalBars) then
				self:SetAlpha(1)
				return true
			else
				self:SetAlpha(1)
			end
		else
			self:SetAlpha(0)
		end
	end

	Check_Flash["NotMax"] = function(self)
		ClassMods.F.StackBarsHost.stacks = checkStacksFunction()

		if ClassMods.F.StackBarsHost.stacks >= self.barIndex then
			if (ClassMods.F.StackBarsHost.stacks >= self.totalBars) then
				self:SetAlpha(1)
			else
				self:SetAlpha(1)
				return true
			end
		else
			self:SetAlpha(0)
		end
	end

	Check_Flash["Always"] = function(self)
		ClassMods.F.StackBarsHost.stacks = checkStacksFunction()

		if ClassMods.F.StackBarsHost.stacks >= self.barIndex then
			self:SetAlpha(1)
			return true
		else
			self:SetAlpha(0)
		end
	end

	Check_Flash["WithProc"] = function(self)
		ClassMods.F.StackBarsHost.stacks = checkStacksFunction()
		ClassMods.F.StackBarsHost.proc = checkProcFunction()

		if ClassMods.F.StackBarsHost.proc then
			self:SetAlpha(1)
			return true
		elseif (ClassMods.F.StackBarsHost.stacks >= self.barIndex) then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
		end
	end

	-- Configure stacks settings
	for i=1,#ClassMods.db.profile.resourcebar.stacks[playerSpec] do
		if ClassMods.db.profile.resourcebar.stacks[playerSpec][i][1] == true then
			checkFunction = Check_Flash[ClassMods.db.profile.resourcebar.stacks[playerSpec][i][5]]
			numBars = maxCharges or ClassMods.db.profile.resourcebar.stacks[playerSpec][i][4]
			if (ClassMods.db.profile.resourcebar.stacks[playerSpec][i][6] == "aura") then
				if (select(2, UnitClass("player")) == "ROGUE") and (playerSpec == 2) then
					checkStacksFunction = function(self)
						local numBuffs = 0
						for i=1,#ClassMods.rollTheBones do
							local buffIndex = ClassMods.getAuraIndex("player", GetSpellInfo(ClassMods.rollTheBones[i]), "HELPFUL")
							if buffIndex and (UnitAura("player", buffIndex, "HELPFUL")) then
								numBuffs = numBuffs + 1
							end
						end
						return numBuffs
					end
				else
					local buffIndex = ClassMods.getAuraIndex("player", GetSpellInfo(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][2]), "HELPFUL")
					if buffIndex then
						checkStacksFunction = function(self) return(select(4, UnitAura(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][3], buffIndex, "HELPFUL") ) or select(3, UnitAura(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][3], buffIndex, "PLAYER|HARMFUL") ) or 0) end
					end
				end
			elseif (ClassMods.db.profile.resourcebar.stacks[playerSpec][i][6] == "charge") and (GetSpellCharges(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][2]) > 1 ) then
				checkStacksFunction = function(self) return(select(1, GetSpellCharges(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][2]) ) or 0) end
				numBars = select(2, GetSpellCharges(ClassMods.db.profile.resourcebar.stacks[playerSpec][i][2]))
			end
		end
	end

	stackSize = ClassMods.db.profile.resourcebar.embedstacks and (ClassMods.db.profile.resourcebar.height * .85) or ClassMods.db.profile.resourcebar.stackssize

	local gap = 0
	local totalWidth = ( (stackSize + gap) * numBars) - gap
	ClassMods.F.StackBarsHost:SetSize( (stackSize + gap) * numBars - gap, stackSize)

	if ClassMods.db.profile.resourcebar.embedstacks then
		ClassMods.F.StackBarsHost:SetPoint("RIGHT", ClassMods.F.ResourceBar, "TOPRIGHT")
	else
		ClassMods.F.StackBarsHost:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.resourcebar.anchor_stacks) )
	end

	ClassMods.F.StackBarsHost:SetAlpha(1)
	ClassMods.F.StackBarsHost:Show()

	if (not ClassMods.db.profile.resourcebar.embedstacks) then
		ClassMods.RegisterMovableFrame(
			"MOVER_STACKBARS",
			ClassMods.F.StackBarsHost,
			ClassMods.F.StackBarsHost,
			L["Stacks"],
			ClassMods.db.profile.resourcebar,
			nil,
			ClassMods.db.profile.resourcebar,
			nil,
			"_stacks"
		)
	end

	ClassMods.F.StackBars = ClassMods.F.StackBars or {} -- recycle
	for i=1,numBars do
		ClassMods.F.StackBars[i] = ClassMods.F.StackBars[i] or CreateFrame("Frame", nil, ClassMods.F.StackBarsHost)
		ClassMods.F.StackBars[i]:SetParent(ClassMods.F.StackBarsHost)
		ClassMods.F.StackBars[i]:ClearAllPoints()
		ClassMods.F.StackBars[i]:SetSize(stackSize, stackSize)

		if (ClassMods.db.profile.resourcebar.stacksreverse) or ((select(2, UnitClass("player")) == "ROGUE") and (playerSpec == 2)) then
			ClassMods.F.StackBars[i]:SetPoint("RIGHT", ClassMods.F.StackBarsHost, "RIGHT", -( (stackSize + gap) * (i - 1) ), 0)
		else
			ClassMods.F.StackBars[i]:SetPoint("LEFT", ClassMods.F.StackBarsHost, "LEFT", ( (stackSize + gap) * (i - 1) ), 0)
		end

		ClassMods.F.StackBars[i].stack = ClassMods.F.StackBars[i].stack or ClassMods.F.StackBars[i]:CreateTexture(nil, "ARTWORK")
		ClassMods.F.StackBars[i].stack:ClearAllPoints()
		ClassMods.F.StackBars[i].stack:SetAllPoints(ClassMods.F.StackBars[i])
		ClassMods.F.StackBars[i].stack:SetTexture("Interface\\AddOns\\ClassMods\\media\\graphics\\stack1.tga")
		ClassMods.F.StackBars[i].stack:SetVertexColor(unpack(ClassMods.db.profile.resourcebar.stackscolor) )
		ClassMods.F.StackBars[i].stack:Show()

		if ClassMods.F.StackBars[i].border then
			ClassMods.F.StackBars[i].border:Hide()
		end
		if ClassMods.F.StackBars[i].backdrop then
			ClassMods.F.StackBars[i].backdrop:Hide()
		end

		ClassMods.F.StackBars[i].barIndex = i
		ClassMods.F.StackBars[i].totalBars = numBars
		ClassMods.F.StackBars[i].checkFunction = checkFunction
		ClassMods.F.StackBars[i].updateTimer = 0
		ClassMods.F.StackBars[i].updateFlash = 0

		ClassMods.F.StackBars[i]:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < STACKBARS_UPDATEINTERVAL then
					return
				else
					self.updateTimer = 0
				end
				if self.checkFunction(self) then
					self.updateFlash = (self.updateFlash >= .5) and 0 or self.updateFlash + .11 + elapsed
					self.stack:SetVertexColor(0, .3 + self.updateFlash, 0, 1)
				else
					self.updateFlash = 0
					self.stack:SetVertexColor(unpack(ClassMods.db.profile.resourcebar.stackscolor) )
				end
			end
		)
		ClassMods.F.StackBars[i]:SetAlpha(0)
		ClassMods.F.StackBars[i]:Show()
	end
end