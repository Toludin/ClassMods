--
-- ClassMods - alternate resource bar module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

--
-- Setup Alternate Resource Bar
--

local function addRuneTimer(runeIndex, start, duration)
	ClassMods.F.AltResourceBar.Icon[runeIndex].Texture:ClearAllPoints()
	ClassMods.F.AltResourceBar.Icon[runeIndex].Texture:SetAllPoints(ClassMods.F.AltResourceBar.Icon[runeIndex])
	if ClassMods.moversLocked then
		ClassMods.F.AltResourceBar.Icon[runeIndex]:SetAlpha(1)
	end
	local timer = ClassMods.F.AltResourceBar.Icon[runeIndex].timer or ClassMods.Timer_Create(ClassMods.F.AltResourceBar.Icon[runeIndex])
	timer.start = start
	timer.duration = duration
	timer.enabled = true
	timer.nextUpdate = 0
	timer:Show()
end

local function destroyAltResourceBar()
	if ClassMods.F.AltResourceBar then
		ClassMods.F.AltResourceBar:Hide()
		ClassMods.F.AltResourceBar:UnregisterAllEvents()
		ClassMods.F.AltResourceBar:SetScript("OnEvent", nil)
		ClassMods.F.AltResourceBar:SetScript("OnUpdate", nil)
		if ClassMods.F.AltResourceBar.Stagger then ClassMods.F.AltResourceBar.Stagger:Hide() end
		if ClassMods.F.AltResourceBar.value then ClassMods.F.AltResourceBar.value:Hide() end
		if ClassMods.F.AltResourceBar.Icon then
			for i=1,#ClassMods.F.AltResourceBar.Icon do
				ClassMods.F.AltResourceBar.Icon[i]:Hide()
			end
		end
		ClassMods.DeregisterMovableFrame("MOVER_ALTRESOURCEBAR")
		ClassMods.F.AltResourceBar:SetParent(nil)
	end
end

function ClassMods.SetupAltResourceBar()
	local playerClass = select(2, UnitClass("player"))
	local playerSpec = GetSpecialization()
	
	if (playerClass == "MAGE") and (playerSpec ~= 1) then destroyAltResourceBar(); return end -- Not Arcane Mage
	if (playerClass == "MONK") and (playerSpec == 2) then destroyAltResourceBar(); return end -- Mistweaver Monk
	if (playerClass == "PALADIN") and (playerSpec ~= 3) then destroyAltResourceBar(); return end -- Not Retribution Paladin
	
	local iconTexture, atlasOn, atlasOff, numIcons

	--DEATHKNIGHT
	if (playerClass == "DEATHKNIGHT") then
		iconTexture = "Interface\\PlayerFrame\\ClassOverlayDeathKnight"
		atlasOn = "ClassOverlay-Rune"
		atlasOff = "ClassOverlay-Rune"
		numIcons = 6
	--DRUID & ROGUE
	elseif (playerClass == "DRUID") or (playerClass == "ROGUE") then
		iconTexture = "Interface\\PlayerFrame\\ClassOverlayComboPoints"
		atlasOn = "ClassOverlay-ComboPoint"
		atlasOff = "ClassOverlay-ComboPoint-Off"
		numIcons = UnitPowerMax("player", 4) -- Combo Points
	--MAGE
	elseif (playerClass == "MAGE") then
		iconTexture = "Interface\\PlayerFrame\\MageArcaneCharges"
		atlasOn = "Mage-ArcaneCharge"
		atlasOff = "Mage-ArcaneCharge"
		numIcons = 4
	--MONK
	elseif (playerClass == "MONK") then -- Windwalker Monk
		iconTexture = "Interface\\PlayerFrame\\MonkUI"
		atlasOn = "MonkUI-LightOrb"
		atlasOff = "MonkUI-OrbOff"
		numIcons = UnitPowerMax("player", 12) -- Chi
	--PALADIN
	elseif (playerClass == "PALADIN") and (playerSpec == 3) then -- Retribution Paladin
		iconTexture = "Interface\\PlayerFrame\\ClassOverlayHolyPower"
		atlasOn = { "nameplates-holypower1-on", "nameplates-holypower2-on", "nameplates-holypower3-on", "nameplates-holypower4-on", "nameplates-holypower4-on" }
		atlasOff = { "nameplates-holypower1-off", "nameplates-holypower2-off", "nameplates-holypower3-off", "nameplates-holypower4-off", "nameplates-holypower4-off" }
		numIcons = 5
	--WARLOCK
	elseif (playerClass == "WARLOCK") then
		iconTexture = "Interface\\PlayerFrame\\ClassOverlayWarlockShards"
		atlasOn = "nameplate-WarlockShard-On"
		atlasOff = "nameplate-WarlockShard-Off"
		numIcons = 5
	end

	-- Destruction
	destroyAltResourceBar()

	-- Construction
	if ClassMods.db.profile.altresourcebar.enabled then
		local ALTRESOURCEBAR_UPDATEINTERVAL = 0.08
		if (ClassMods.db.profile.overrideinterval) then
			ALTRESOURCEBAR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
		else
			ALTRESOURCEBAR_UPDATEINTERVAL = ClassMods.db.profile.altresourcebar.updateinterval
		end

		-- Create the Frame
		ClassMods.F.AltResourceBar = ClassMods.MakeFrame(ClassMods.F.AltResourceBar, "Frame", "CLASSMODS_ALTRESOURCEBAR", ClassMods.db.profile.altresourcebar.anchor[2] or UIParent)
		ClassMods.F.AltResourceBar:SetParent(ClassMods.db.profile.altresourcebar.anchor[2] or UIParent)
		ClassMods.F.AltResourceBar:ClearAllPoints()
		if (ClassMods.db.profile.altresourcebar.basicmode) or ((playerClass == "MONK") and (playerSpec == 1)) then
			ClassMods.F.AltResourceBar:SetSize(ClassMods.db.profile.altresourcebar.width, ClassMods.db.profile.altresourcebar.height)
		else
			ClassMods.F.AltResourceBar:SetSize((ClassMods.db.profile.altresourcebar.iconsize * numIcons), ClassMods.db.profile.altresourcebar.iconsize)
		end
		ClassMods.F.AltResourceBar:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.altresourcebar.anchor) )
		ClassMods.F.AltResourceBar.background = ClassMods.MakeBackground(ClassMods.F.AltResourceBar, ClassMods.db.profile.altresourcebar, nil, nil, ClassMods.F.AltResourceBar.background)

		if (playerClass == "MONK") and (playerSpec == 1) then -- Brewmaster Monk
			ClassMods.F.AltResourceBar:SetSize(ClassMods.db.profile.altresourcebar.width, ClassMods.db.profile.altresourcebar.height)
			ClassMods.F.AltResourceBar.Stagger = ClassMods.MakeFrame(ClassMods.F.AltResourceBar.Stagger, "StatusBar", "CLASSMODS_STAGGER", ClassMods.db.profile.altresourcebar.anchor[2] or UIParent)
			ClassMods.F.AltResourceBar.Stagger:SetParent(ClassMods.db.profile.altresourcebar.anchor[2] or UIParent)
			ClassMods.F.AltResourceBar.Stagger:ClearAllPoints()
			ClassMods.F.AltResourceBar.Stagger:SetStatusBarTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
			ClassMods.F.AltResourceBar.Stagger:SetMinMaxValues(0, UnitHealthMax("player"))
			ClassMods.F.AltResourceBar.Stagger:SetStatusBarColor("0", "0", "1")
			ClassMods.F.AltResourceBar.Stagger:SetSize(ClassMods.db.profile.altresourcebar.width, ClassMods.db.profile.altresourcebar.height)
			ClassMods.F.AltResourceBar.Stagger:SetAllPoints(ClassMods.F.AltResourceBar)
			ClassMods.F.AltResourceBar.Stagger:SetAlpha(1)
			ClassMods.F.AltResourceBar.Stagger:SetValue(UnitStagger("player") or 0)
			ClassMods.F.AltResourceBar.Stagger:Show()
			ClassMods.F.AltResourceBar.value = ClassMods.F.AltResourceBar.value or ClassMods.F.AltResourceBar:CreateFontString(nil, "OVERLAY")
			ClassMods.F.AltResourceBar.value:ClearAllPoints()
			ClassMods.F.AltResourceBar.value:SetJustifyH("CENTER")
			ClassMods.F.AltResourceBar.value:SetPoint("CENTER", ClassMods.F.AltResourceBar, "CENTER")
			ClassMods.F.AltResourceBar.value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.resourcebar.resourcefont))
			ClassMods.F.AltResourceBar.value:SetTextColor(unpack(ClassMods.db.profile.resourcebar.resourcefontcolor) )
			ClassMods.F.AltResourceBar.value:SetText(UnitStagger("player") or 0)
			ClassMods.F.AltResourceBar.value:Show()
		else
			ClassMods.F.AltResourceBar.Icon = {}
			for i=1,numIcons do
				local x
				ClassMods.F.AltResourceBar.Icon[i] = ClassMods.MakeFrame(ClassMods.F.AltResourceBar.Icon[i], "Frame", "Icon"..i, ClassMods.F.AltResourceBar)
				ClassMods.F.AltResourceBar.Icon[i]:SetParent(ClassMods.F.AltResourceBar)
				ClassMods.F.AltResourceBar.Icon[i].background = ClassMods.MakeBackground(ClassMods.F.AltResourceBar.Icon[i], ClassMods.db.profile.altresourcebar.icon, nil, ClassMods.F.AltResourceBar.Icon[i].background)
				if (ClassMods.db.profile.altresourcebar.basicmode) then
					ClassMods.F.AltResourceBar.Icon[i]:SetSize((ClassMods.db.profile.altresourcebar.width / numIcons) - numIcons, ClassMods.db.profile.altresourcebar.height)
					x = ( (i-1) * (ClassMods.GetFrameOffset(ClassMods.F.AltResourceBar.Icon[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.AltResourceBar.Icon[i], "RIGHT", 1) + (ClassMods.db.profile.altresourcebar.width / numIcons) + 1) )
				else
					ClassMods.F.AltResourceBar.Icon[i]:SetSize(ClassMods.db.profile.altresourcebar.iconsize, ClassMods.db.profile.altresourcebar.iconsize)
					x = ( (i-1) * (ClassMods.GetFrameOffset(ClassMods.F.AltResourceBar.Icon[i], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.AltResourceBar.Icon[i], "RIGHT", 1) + ClassMods.db.profile.altresourcebar.iconsize + 1) )
				end

				ClassMods.F.AltResourceBar.Icon[i]:SetPoint("TOPLEFT", ClassMods.F.AltResourceBar, "TOPLEFT", x, 0)

				if (ClassMods.db.profile.altresourcebar.basicmode) then
					ClassMods.F.AltResourceBar.Icon[i].Texture = ClassMods.F.AltResourceBar.Icon[i].Texture or ClassMods.F.AltResourceBar.Icon[i]:CreateTexture()
					ClassMods.F.AltResourceBar.Icon[i].Texture:SetColorTexture(unpack(ClassMods.db.profile.altresourcebar.barcoloroff))
					ClassMods.F.AltResourceBar.Icon[i].Texture:ClearAllPoints()
					ClassMods.F.AltResourceBar.Icon[i].Texture:SetAllPoints(ClassMods.F.AltResourceBar.Icon[i])
				else
					ClassMods.F.AltResourceBar.Icon[i].Texture = ClassMods.F.AltResourceBar.Icon[i].Texture or ClassMods.F.AltResourceBar.Icon[i]:CreateTexture(iconTexture, "ARTWORK")
					if (playerClass == "PALADIN") and (playerSpec == 3) then -- Retribution
						ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOff[i], false)
					else
						ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOff, false)
					end
					ClassMods.F.AltResourceBar.Icon[i].Texture:ClearAllPoints()
					ClassMods.F.AltResourceBar.Icon[i].Texture:SetAllPoints(ClassMods.F.AltResourceBar.Icon[i])
				end

				if (playerClass == "MAGE") and (playerSpec == 1) then -- Arcane Mage
					ClassMods.F.AltResourceBar.Icon[i]:SetAlpha(0.1)
				else
					ClassMods.F.AltResourceBar.Icon[i]:SetAlpha(1)
				end

				if (playerClass == "DRUID") then 
					if (UnitPowerType("player") == SPELL_POWER_ENERGY) then
						ClassMods.F.AltResourceBar.Icon[i]:Show()
					else
						ClassMods.F.AltResourceBar.Icon[i]:Hide()
					end
				else
					ClassMods.F.AltResourceBar.Icon[i]:Show()
				end
			end
		end

		-- Register a the mover frame
		ClassMods.RegisterMovableFrame(
			"MOVER_ALTRESOURCEBAR",
			ClassMods.F.AltResourceBar,
			ClassMods.F.AltResourceBar,
			L["Alternate Resource Bar"],
			ClassMods.db.profile.altresourcebar,
			ClassMods.SetupAltResourceBar,
			ClassMods.db.profile.altresourcebar,
			ClassMods.db.profile.altresourcebar
		)

		-- Register Events to support the bar
		ClassMods.F.AltResourceBar:RegisterEvent("RUNE_POWER_UPDATE", "player")
		ClassMods.F.AltResourceBar:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
		ClassMods.F.AltResourceBar:RegisterUnitEvent("UNIT_MAXPOWER", "player")
		ClassMods.F.AltResourceBar:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		ClassMods.F.AltResourceBar:SetScript("OnEvent",
			function(self, event, ...)
				arg1, arg2 = ...
				if (event == "RUNE_POWER_UPDATE") then
					if arg1 and arg1 >= 1 and arg1 <= 6 then
						local start, duration, runeReady = GetRuneCooldown(arg1)
						if not runeReady then
							if start then
								addRuneTimer(arg1, start, duration)
								if (ClassMods.db.profile.altresourcebar.basicmode) then
									ClassMods.F.AltResourceBar.Icon[arg1].Texture:SetColorTexture(unpack(ClassMods.db.profile.altresourcebar.barcoloroff))
								end
							end
						else
							if (ClassMods.db.profile.altresourcebar.basicmode) then
								ClassMods.F.AltResourceBar.Icon[arg1].Texture:SetColorTexture(unpack(ClassMods.db.profile.altresourcebar.barcoloron))
							end
						end
					end
				elseif (event == "UNIT_DISPLAYPOWER") then
					if (UnitPowerType("player") == SPELL_POWER_ENERGY) then
						for i=1,#ClassMods.F.AltResourceBar.Icon do
							ClassMods.F.AltResourceBar.Icon[i]:Show()
						end
					else
						for i=1,#ClassMods.F.AltResourceBar.Icon do
							ClassMods.F.AltResourceBar.Icon[i]:Hide()
						end
					end
				elseif (event == "UNIT_MAXPOWER") then
					ClassMods.SetupAltResourceBar()
				elseif (event == "UNIT_POWER_FREQUENT") then
					if (playerClass == "MONK") and (playerSpec ~= 3) then return end -- not a Windwalker Monk (CHI still fires for the other specs >.<)
					if ((arg2 == "COMBO_POINTS") or (arg2 == "ARCANE_CHARGES") or (arg2 == "CHI") or (arg2 == "HOLY_POWER") or (arg2 == "SOUL_SHARDS")) then
						local numPoints = UnitPower("player", _G["SPELL_POWER_"..arg2])
						for i=1,numPoints do
							if (not ClassMods.F.AltResourceBar.Icon[i].Active) then
								ClassMods.F.AltResourceBar.Icon[i].Active = true
								if (ClassMods.db.profile.altresourcebar.basicmode) then
									ClassMods.F.AltResourceBar.Icon[i].Texture:SetColorTexture(unpack(ClassMods.db.profile.altresourcebar.barcoloron))
								else
									if (playerClass == "PALADIN") and (playerSpec == 3) then -- Retribution
										ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOn[i], false)
									else
										ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOn, false)
									end
								end
								if (playerClass == "MAGE") and (playerSpec == 1) then -- Arcane Mage
									ClassMods.F.AltResourceBar.Icon[i]:SetAlpha(1)
								end
							end
						end
					
						for i=(numPoints + 1),#ClassMods.F.AltResourceBar.Icon do
							if (ClassMods.F.AltResourceBar.Icon[i].Active) then
								ClassMods.F.AltResourceBar.Icon[i].Active = false
								if (ClassMods.db.profile.altresourcebar.basicmode) then
									ClassMods.F.AltResourceBar.Icon[i].Texture:SetColorTexture(unpack(ClassMods.db.profile.altresourcebar.barcoloroff))
								else
									if (playerClass == "PALADIN") and (playerSpec == 3) then -- Retribution
										ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOff[i], false)
									else
										ClassMods.F.AltResourceBar.Icon[i].Texture:SetAtlas(atlasOff, false)
									end
								end

								if (playerClass == "MAGE") and (playerSpec == 1) then -- Arcane Mage
									ClassMods.F.AltResourceBar.Icon[i]:SetAlpha(0.1)
								end
							end
						end
					end
				elseif (event == "UNIT_MAXHEALTH") and ((playerClass == "MONK") and (playerClass == 1)) then -- Brewmaster Monk
					ClassMods.SetupAltResourceBar()
				end
			end)

		ClassMods.F.AltResourceBar.updateTimer = 0
		ClassMods.F.AltResourceBar:SetScript("OnUpdate",
			function(self, elapsed)
				self.updateTimer = self.updateTimer + elapsed
				if self.updateTimer < ALTRESOURCEBAR_UPDATEINTERVAL then return else self.updateTimer = 0 end

				if (select(2, UnitClass("player")) == "MONK") and ClassMods.F.AltResourceBar.Stagger then
					local stagger = UnitStagger("player")
					ClassMods.F.AltResourceBar.Stagger:SetValue(stagger)
					ClassMods.F.AltResourceBar.value:SetText(ClassMods.AbbreviateNumber(stagger))
					local maxStagger = UnitHealthMax("player")
					local percent = stagger/maxStagger
					local barColor
					if (percent > STAGGER_YELLOW_TRANSITION and percent < STAGGER_RED_TRANSITION) then
						barColor = PowerBarColor[BREWMASTER_POWER_BAR_NAME][STAGGER_YELLOW_INDEX]
					elseif (percent > STAGGER_RED_TRANSITION) then
						barColor = PowerBarColor[BREWMASTER_POWER_BAR_NAME][STAGGER_RED_INDEX]
					else
						barColor = PowerBarColor[BREWMASTER_POWER_BAR_NAME][STAGGER_GREEN_INDEX]
					end
					ClassMods.F.AltResourceBar.Stagger:SetStatusBarColor(barColor.r, barColor.g, barColor.b)
				end

				-- Overrides take precidence over normal alpha
				if C_PetBattles.IsInBattle() then
					self:SetAlpha(0) -- Hide for pet battles
				elseif ClassMods.db.profile.altresourcebar.deadoverride and UnitIsDeadOrGhost("player") then
					self:SetAlpha(ClassMods.db.profile.altresourcebar.deadoverridealpha)
				elseif ClassMods.db.profile.altresourcebar.mountoverride and (IsMounted() or UnitHasVehicleUI("player") ) and (AuraUtil.FindAuraByName("Telaari Talbuk", "player") == nil) and (AuraUtil.FindAuraByName("Frostwolf War Wolf", "player") == nil) and (AuraUtil.FindAuraByName("Rune of Grasping Earth", "player") == nil) then
					self:SetAlpha(ClassMods.db.profile.altresourcebar.mountoverridealpha)
				elseif ClassMods.db.profile.altresourcebar.oocoverride and (not InCombatLockdown() ) then
					self:SetAlpha(ClassMods.db.profile.altresourcebar.oocoverridealpha)
				elseif (UnitAffectingCombat("player")) then
					self:SetAlpha(ClassMods.db.profile.altresourcebar.activealpha)
				else
					self:SetAlpha(ClassMods.db.profile.altresourcebar.inactivealpha)
				end

			end)
		ClassMods.F.AltResourceBar:Show()
	end
end