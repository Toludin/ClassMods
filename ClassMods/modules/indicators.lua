--
-- ClassMods - indicator module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local mod, strupper, select, pairs, unpack, tonumber, floor, GetSpellInfo, UnitAura, UnitCastingInfo = mod, strupper, select, pairs, unpack, tonumber, floor, GetSpellInfo, UnitAura, UnitCastingInfo
local FRAMEPOOL = {} -- For re-using frames
-- Numerics are quicker compares than strings.
local _Buff			= 0
local _Debuff		= 1

ClassMods.totalIndicatorIcons = 0

-- This function tests for the indicator on a specific target
--	returns: (name if found or nil), (texture if found or nil), (time remaining if found or nil), (targetGUID if found or nil), (stacks if found or nil)
local function checkTargetForIndicator(caller, target)
	if(caller.indicatorTrigger == _Debuff) then
		caller.___name, caller.___texture, caller.___stacks, caller.____, caller.___duration, caller.___expires = UnitAura(target, caller.checkID and GetSpellInfo(caller.checkID) or caller.checkName, nil, "PLAYER|HARMFUL")
	elseif(caller.indicatorTrigger == _Buff) then
		caller.___name, caller.___texture, caller.___stacks, caller.____, caller.___duration, caller.___expires = UnitAura(target, caller.checkID and GetSpellInfo(caller.checkID) or caller.checkName, nil, "PLAYER|HELPFUL")
	end
	return caller.___name, caller.___texture, caller.___stacks
end

local function checkForIndicator(caller)
	local name, texture, stacks
	local count = 0

	if(caller.target == "raid") or (caller.target == "raidpet") then
		if IsInRaid() then
			if IsInInstance() then
				caller.__maxPlayers = select(5, GetInstanceInfo())
			else
				caller.__maxPlayers = 40
			end
			for i=1,caller.__maxPlayers do
				caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, caller.target..i)
				if ( caller.__name ) then
					count = count + 1
					name = caller.__name
					texture = caller.__texture
					stacks = caller.__stacks
				end
			end
		end
		return name, texture, stacks, count
	elseif (caller.target == "party") or (caller.target == "partypet") then

		if (caller.target == "party") then
			caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, "player")
		else
			caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, "pet")
		end
		if ( caller.__name ) then
			count = count + 1
			name = caller.__name
			texture = caller.__texture
			stacks = caller.__stacks
		end
		if IsInGroup() then
			for i=1,GetNumGroupMembers() do
				caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, caller.target..i)
				if ( caller.__name ) then
					count = count + 1
					name = caller.__name
					texture = caller.__texture
					stacks = caller.__stacks
				end
			end
		end
		return name, texture, stacks, count
	elseif (caller.target == "arena") then
		caller.__inInstance, caller.__instanceType = IsInInstance()
		if caller.__inInstance and (caller.__instanceType == "arena") then
			for i=1,5 do
				caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, caller.target..i)
				if ( caller.__name ) then
					count = count + 1
					name = caller.__name
					texture = caller.__texture
					stacks = caller.__stacks
				end
			end
		end
		return name, texture, stacks, count
	elseif (caller.target == "boss") then
		for i=1,4 do
			caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, caller.target..i)
			if ( caller.__name ) then
				count = count + 1
				name = caller.__name
				texture = caller.__texture
				stacks = caller.__stacks
			end
		end
		return name, texture, stacks, count
	end
	-- Last check is the exact target name
	caller.__name, caller.__texture, caller.__stacks = checkTargetForIndicator(caller, caller.target)
	if ( caller.__name ) then
		name = caller.__name
		texture = caller.__texture
		stacks = caller.__stacks
	end
	return name, texture, stacks, count -- No match
end

local function repositionFrames(caller)
	caller.____index = 1
	for i=1,ClassMods.totalIndicatorIcons do
		if ClassMods.F.Indicators[i].active then
			ClassMods.F.Indicators[i]:ClearAllPoints()
			-- Flip expanding left to right or right to left depending on anchor point X
			caller.____xPos = ( (ClassMods.db.profile.indicators.icons.iconsize + (ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "RIGHT", 1) + 2) ) * mod(caller.____index - 1, 5) )
			caller.____yPos = (ClassMods.db.profile.indicators.icons.iconsize + (ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "BOTTOM", 1) + 2) ) * floor( (caller.____index - 1) / 5)
			if ClassMods.db.profile.indicators.anchor[4] >= 0 then
				ClassMods.F.Indicators[i]:SetPoint("TOPLEFT", ClassMods.F.IndicatorIconsHost, "TOPLEFT", caller.____xPos, -caller.____yPos)
			else
				ClassMods.F.Indicators[i]:SetPoint("TOPRIGHT", ClassMods.F.IndicatorIconsHost, "TOPRIGHT", -caller.____xPos, -caller.____yPos)
			end
			caller.____index = caller.____index + 1
		end
	end
end

function ClassMods.SetupIndicators()
	if(not ClassMods.F.Indicators) then
		ClassMods.F.Indicators = {}
	end
	-- Destruction
	local i = 1
	while ClassMods.F.Indicators[i] ~= nil do
		if (ClassMods.F.Indicators[i].shine) then
			AutoCastShine_AutoCastStop(ClassMods.F.Indicators[i].shine)
		end
		ClassMods.F.Indicators[i]:Hide()
		ClassMods.F.Indicators[i]:SetScript("OnUpdate", nil)
		ClassMods.F.Indicators[i]:ClearAllPoints()
		ClassMods.F.Indicators[i]:UnregisterAllEvents()
		ClassMods.F.Indicators[i]:SetParent(nil)
		tinsert(FRAMEPOOL, ClassMods.F.Indicators[i]) -- recycle
		ClassMods.F.Indicators[i] = nil
		i = i + 1
	end
	-- Clean up the mover frame
	if ClassMods.F.IndicatorIconsHost then
		ClassMods.F.IndicatorIconsHost:Hide()
		ClassMods.F.IndicatorIconsHost:ClearAllPoints()
		ClassMods.F.IndicatorIconsHost:UnregisterAllEvents()
		ClassMods.DeregisterMovableFrame("MOVER_INDICATOR_ICONS")
		ClassMods.F.IndicatorIconsHost:SetParent(nil)
		-- ClassMods.F.IndicatorIconsHost = nil
	end
	ClassMods.totalIndicatorIcons = 0
	-- Construction
	local INDICATOR_UPDATEINTERVAL = 0.08
	if (ClassMods.db.profile.overrideinterval) then
		INDICATOR_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
	else
		INDICATOR_UPDATEINTERVAL = ClassMods.db.profile.indicators.updateinterval
	end
	local key,val
	local index = 1
	for key,val in pairs(ClassMods.db.profile.indicators.indicators) do
		if ClassMods.db.profile.indicators.indicators[key] and ClassMods.db.profile.indicators.indicators[key].enabled then
			-- Create the host frame
			if (index == 1) then
				ClassMods.F.IndicatorIconsHost = ClassMods.MakeFrame(ClassMods.F.IndicatorIconsHost, "Frame", "CLASSMODS_INDICATOR_ICON_HOST", ClassMods.db.profile.indicators.anchor[2] or UIParent) -- recycle
				ClassMods.F.IndicatorIconsHost:SetParent(ClassMods.db.profile.indicators.anchor[2] or UIParent)
				ClassMods.F.IndicatorIconsHost:ClearAllPoints()
				ClassMods.F.IndicatorIconsHost:SetSize(ClassMods.db.profile.indicators.icons.iconsize, ClassMods.db.profile.indicators.icons.iconsize) -- Temporary size
				ClassMods.F.IndicatorIconsHost:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.indicators.anchor) )
				ClassMods.F.IndicatorIconsHost:SetAlpha(1)
				ClassMods.F.IndicatorIconsHost:Show()
			end
			-- Create this Indicator's Frame
			ClassMods.F.Indicators[index] = ClassMods.MakeFrame(ClassMods.F.Indicators[index] or tremove(FRAMEPOOL), "Frame", nil, ClassMods.F.IndicatorIconsHost)
			ClassMods.F.Indicators[index]:SetParent(ClassMods.F.IndicatorIconsHost)
			ClassMods.F.Indicators[index]:SetSize(ClassMods.db.profile.indicators.icons.iconsize, ClassMods.db.profile.indicators.icons.iconsize)
			ClassMods.F.Indicators[index]:SetPoint("CENTER", ClassMods.F.IndicatorIconsHost, "CENTER")
			ClassMods.F.Indicators[index]:SetAlpha(0)
			ClassMods.F.Indicators[index].Icon = ClassMods.F.Indicators[index].Icon or ClassMods.F.Indicators[index]:CreateTexture(nil, "BACKGROUND")
			ClassMods.F.Indicators[index].Icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark") -- Just a place-holder
			if ClassMods.db.profile.indicators.icons.enabletexcoords then
				ClassMods.F.Indicators[index].Icon:SetTexCoord(unpack(ClassMods.db.profile.indicators.icons.texcoords) )
			else
				ClassMods.F.Indicators[index].Icon:SetTexCoord(0, 1, 0, 1)
			end
			ClassMods.F.Indicators[index].Icon:ClearAllPoints()
			ClassMods.F.Indicators[index].Icon:SetAllPoints(ClassMods.F.Indicators[index])
			-- Create the Background and border if the user wants one
			ClassMods.F.Indicators[index].background = ClassMods.MakeBackground(ClassMods.F.Indicators[index], ClassMods.db.profile.indicators.icons, nil, ClassMods.F.Indicators[index].background)
			-- Now we can properly set the size of the host frame for the indicator icons because we now have offsets.
			if (index == 1) then
				ClassMods.F.IndicatorIconsHost:SetSize(
					( (ClassMods.db.profile.indicators.icons.iconsize + -- WIDTH
						(ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "RIGHT", 1) + 2) ) * 5)
						- ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "RIGHT", 1) - 2,

					( (ClassMods.db.profile.indicators.icons.iconsize + -- HEIGHT
						(ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "BOTTOM", 1) + 2) ) * 4)
						- ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.Indicators[1], "RIGHT", 1) - 2)

				ClassMods.RegisterMovableFrame(
					"MOVER_INDICATOR_ICONS",
					ClassMods.F.IndicatorIconsHost,
					ClassMods.F.IndicatorIconsHost,
					L["Indicators"],
					ClassMods.db.profile.indicators,
					index == 1 and ClassMods.SetupIndicators or nil,
					ClassMods.db.profile.indicators,
					nil) -- No background / Border ever on the mover frame
			end
			-- Setup Stacks
			ClassMods.F.Indicators[index].stacks = ClassMods.F.Indicators[index].stacks or ClassMods.F.Indicators[index]:CreateFontString(nil, "OVERLAY")
			ClassMods.F.Indicators[index].stacks:ClearAllPoints()
			ClassMods.F.Indicators[index].stacks:SetJustifyH("RIGHT")
			ClassMods.F.Indicators[index].stacks:SetJustifyV("BOTTOM")
			ClassMods.F.Indicators[index].stacks:SetPoint("BOTTOMRIGHT", ClassMods.F.Indicators[index], "BOTTOMRIGHT", 0, -3)
			ClassMods.F.Indicators[index].stacks:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.indicators.icons.stackfont) )
			ClassMods.F.Indicators[index].stacks:SetTextColor(unpack(ClassMods.db.profile.indicators.icons.stackfontcolor) )
			ClassMods.F.Indicators[index].stacks:SetText("")
			ClassMods.F.Indicators[index].stacks:SetAlpha(1)
			-- Setup Timer Value
			ClassMods.F.Indicators[index].value = ClassMods.F.Indicators[index].value or ClassMods.F.Indicators[index]:CreateFontString(nil, "OVERLAY")
			ClassMods.F.Indicators[index].value:ClearAllPoints()
			ClassMods.F.Indicators[index].value:SetJustifyH("CENTER")
			ClassMods.F.Indicators[index].value:SetJustifyV("CENTER")
			ClassMods.F.Indicators[index].value:SetPoint("CENTER", ClassMods.F.Indicators[index], "CENTER", 0, 0)
			ClassMods.F.Indicators[index].value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.cooldowns.font) )
			ClassMods.F.Indicators[index].value:SetTextColor(1, 1, 1, 1)
			if (not ClassMods.F.Indicators[index].value.oriShadowColor) then
				ClassMods.F.Indicators[index].value.oriShadowColor = { ClassMods.F.Indicators[index].value:GetShadowColor() }
				ClassMods.F.Indicators[index].value.oriShadowOffset = { ClassMods.F.Indicators[index].value:GetShadowOffset() }
			end
			if (ClassMods.db.profile.cooldowns.enableshadow) then
				ClassMods.F.Indicators[index].value:SetShadowColor(unpack(ClassMods.db.profile.cooldowns.shadowcolor) )
				ClassMods.F.Indicators[index].value:SetShadowOffset(unpack(ClassMods.db.profile.cooldowns.fontshadowoffset) )
			else
				ClassMods.F.Indicators[index].value:SetShadowColor(unpack(ClassMods.F.Indicators[index].value.oriShadowColor) )
				ClassMods.F.Indicators[index].value:SetShadowOffset(unpack(ClassMods.F.Indicators[index].value.oriShadowOffset) )
			end
			ClassMods.F.Indicators[index].value:SetText("")
			ClassMods.F.Indicators[index].value:SetAlpha(1)
			-- Setup the Sparkles if turned on for this Indicator
			if ClassMods.db.profile.indicators.indicators[key].sparkles then
				ClassMods.F.Indicators[index].shine = ClassMods.F.Indicators[index].shine or CreateFrame("Frame", "AutocastShine_IndicatorShine", UIParent, "AutoCastShineTemplate")
				ClassMods.F.Indicators[index].shine:ClearAllPoints()
				ClassMods.F.Indicators[index].shine:Show()
				ClassMods.F.Indicators[index].shine:SetSize(ClassMods.db.profile.indicators.icons.iconsize+2, ClassMods.db.profile.indicators.icons.iconsize+2)
				ClassMods.F.Indicators[index].shine:SetPoint("CENTER", ClassMods.F.Indicators[index], "CENTER", 1, -1)
				ClassMods.F.Indicators[index].shine:SetAlpha(1)
				AutoCastShine_AutoCastStop(ClassMods.F.Indicators[index].shine)
			elseif ClassMods.F.Indicators[index].shine then
				ClassMods.F.Indicators[index].shine:Hide()
				ClassMods.F.Indicators[index].shine:ClearAllPoints()
			end
			-- Setup the script for handling the Indicator
			ClassMods.F.Indicators[index].index = index
			ClassMods.F.Indicators[index].updateTimer = 0
			ClassMods.F.Indicators[index].active = false
			ClassMods.F.Indicators[index].checkID = tonumber(ClassMods.db.profile.indicators.indicators[key].aura) and tonumber(ClassMods.db.profile.indicators.indicators[key].aura) or nil
			ClassMods.F.Indicators[index].checkName = (not tonumber(ClassMods.db.profile.indicators.indicators[key].aura) ) and strupper(ClassMods.db.profile.indicators.indicators[key].aura) or nil
			ClassMods.F.Indicators[index].hasSparkles = ClassMods.db.profile.indicators.indicators[key].sparkles
			ClassMods.F.Indicators[index].target = ClassMods.db.profile.indicators.indicators[key].target
			ClassMods.F.Indicators[index].combat = ClassMods.db.profile.indicators.indicators[key].combat
			ClassMods.F.Indicators[index].missing = ClassMods.db.profile.indicators.indicators[key].missing
			if(ClassMods.db.profile.indicators.indicators[key].indicatortype == "BUFF") then
				ClassMods.F.Indicators[index].indicatorTrigger = _Buff
			elseif(ClassMods.db.profile.indicators.indicators[key].indicatortype == "DEBUFF") then
				ClassMods.F.Indicators[index].indicatorTrigger = _Debuff
			else
				print("INVALID INDICATOR FOUND! Index:", index, "Type:", ClassMods.db.profile.indicators.indicators[key].indicatortype)
				return
			end

			-- OnUpdate handler
			ClassMods.F.Indicators[index]:SetScript("OnUpdate",
				function(self, elapsed)
					self.updateTimer = self.updateTimer + elapsed

					if(self.updateTimer < INDICATOR_UPDATEINTERVAL) then
						return
					else
						self.updateTimer = 0
					end

					self._name, self._texture, self._stacks, self._count = checkForIndicator(self)

					if (self.active == true) then -- This alert is currently active, check if it's still valid
						if (((self._name) and (not self.missing)) or ((not self._name) and (self.missing))) then -- Alert is still active, so update it
							if ((InCombatLockdown()) and (self.combat)) or (not self.combat) then
								if self._stacks and (self._stacks > 1) then
									self.stacks:SetText(self._stacks)
									self.stacks:Show()
								else
									self.stacks:Hide()
								end
								if self._count and (self._count > 1) then
									self.value:SetText(self._count)
									self.value:Show()
								else
									self.value:Hide()
								end
							else
								if self.hasSparkles then
									AutoCastShine_AutoCastStop(self.shine)
								end
								self.Icon:Hide()
								self.stacks:Hide()
								self.value:Hide()
								self:SetAlpha(0)
								self.active = false
								self.activeGUID = -1
								repositionFrames(self)
							end
						else -- It's no longer active
							if self.hasSparkles then
								AutoCastShine_AutoCastStop(self.shine)
							end
							self.Icon:Hide()
							self.stacks:Hide()
							self.value:Hide()
							self:SetAlpha(0)
							self.active = false
							self.activeGUID = -1
							repositionFrames(self)
						end
					else -- Alert is not active, check if we need to activate it
						if ((self._name) and (not self.missing)) or ((not self._name) and (self.missing)) then -- Now it's active!
							if ((InCombatLockdown()) and (self.combat)) or (not self.combat) then
								self.active = true
								self.Icon:SetTexture(self._texture or select(3, GetSpellInfo(self.checkID)) or select(3, GetSpellInfo(ClassMods.NameToSpellID(self.checkName))))
								self.Icon:Show()
								if self._stacks and (self._stacks > 1) then
									self.stacks:SetText(self._stacks)
									self.stacks:Show()
								else
									self.stacks:Hide()
								end
								if self._count and (self._count > 1) then
									self.value:SetText(self._count)
									self.value:Show()
								else
									self.value:Hide()
								end
								if ClassMods.moversLocked then
									self:SetAlpha(1)
								else
									self:SetAlpha(0)
								end
								if self.hasSparkles then
									AutoCastShine_AutoCastStart(self.shine, 1, .5, .5)
								end
								repositionFrames(self)
							end
						end
					end
				end)
			ClassMods.F.Indicators[index]:Show()
			index = index + 1
		end
	end
	ClassMods.totalIndicatorIcons = index - 1
end