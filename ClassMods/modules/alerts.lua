--
-- ClassMods - alerts module
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local mod, strupper, select, pairs, unpack, tonumber, floor, GetSpellInfo, UnitAura, UnitCastingInfo = mod, strupper, select, pairs, unpack, tonumber, floor, GetSpellInfo, UnitAura, UnitCastingInfo
local FRAMEPOOL = {} -- For re-using frames
-- Numerics are quicker compares than strings.
local _Buff			= 0
local _Debuff		= 1
local _Cast			= 2
local _Health		= 3
local _PetHealth	= 4
ClassMods.totalAlertIcons = 0

-- This function tests for the alert on a specific target
--	returns: (name if found or nil), (texture if found or nil), (time remaining if found or nil), (targetGUID if found or nil), (stacks if found or nil)
local function checkTargetForAlert(caller, target)
	if(caller.alertTrigger == _Debuff) then
		local buffIndex = ClassMods.getAuraIndex(target, caller.checkID and GetSpellInfo(caller.checkID) or caller.checkName, "HARMFUL")
		if not buffIndex then return end
		caller.___name, caller.___texture, caller.___stacks, caller.____, caller.___duration, caller.___expires = UnitAura(target, buffIndex, "HARMFUL")
		caller.___calculatedRemaining = caller.___expires and (caller.___expires - GetTime() ) or 0
	elseif(caller.alertTrigger == _Buff) then
		local buffIndex = ClassMods.getAuraIndex(target, caller.checkID and GetSpellInfo(caller.checkID) or caller.checkName, "HELPFUL")
		if not buffIndex then return end
		caller.___name, caller.___texture, caller.___stacks, caller.____, caller.___duration, caller.___expires = UnitAura(target, buffIndex, "HELPFUL")
		caller.___calculatedRemaining = caller.___expires and (caller.___expires - GetTime() ) or 0
	elseif(caller.alertTrigger == _Cast) then
		caller.___name, caller.____, caller.____, caller.___texture, caller.____, caller.___endTime = UnitCastingInfo(target)
		if(caller.___name) then
			caller.___name = strupper(caller.___name)
			if(caller.checkName) then
				caller.___name = (caller.___name == caller.checkName) and caller.___name or nil
			else
				caller.___name = (caller.___name == strupper(select(1, GetSpellInfo(caller.checkID)))) and caller.___name or nil
			end
			caller.___calculatedRemaining = caller.___endTime and (caller.___endTime / 1000 - GetTime()) or 0
		end
	elseif (caller.alertTrigger == _Health) then
		caller.___name = nil
		if((UnitHealth("player") / UnitHealthMax("player")) <= caller.healthpercent) and (not UnitIsDeadOrGhost("player")) then
			caller.___name = "HEALTH"
			caller.___texture = "Interface\\ICONS\\INV_Firstaid_Bandage2"
			caller.___calculatedRemaining = 0
		end
	elseif(caller.alertTrigger == _PetHealth) then
		caller.___name = nil
		if(UnitExists("pet")) and ((UnitHealth("pet") / UnitHealthMax("pet")) <= caller.healthpercent) and (not UnitIsDeadOrGhost("pet")) then
			caller.___name = "PETHEALTH"
			caller.___texture = ClassMods.pethealthtexture
			caller.___calculatedRemaining = 0
		end
	end
	return(caller.___name and caller.___name or nil),(caller.___name and caller.___texture or nil),(caller.___name and (caller.___calculatedRemaining > 0 and caller.___calculatedRemaining or 0) or nil),(caller.___name and UnitGUID(target) ),(caller.___name and caller.___stacks or nil)
end

--	returns (name), (texture), (remainingTime), (targetGUID), (stacks)
local function checkForAlert(caller)
	if(caller.target == "raid") or (caller.target == "raidpet") then
		if IsInRaid() then
			if IsInInstance() then
				caller.__maxPlayers = select(5, GetInstanceInfo())
			else
				caller.__maxPlayers = 40
			end
			for i=1,caller.__maxPlayers do
				caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, caller.target..i)
				if ( caller.__name ) then
					return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
				end
			end
		end
		return (nil), (nil), (nil), (nil), (nil)
	elseif (caller.target == "party") or (caller.target == "partypet") then
		if (caller.target == "party") then
			caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, "player")
		else
			caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, "pet")
		end
		if ( caller.__name ) then
			return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
		end
		if IsInGroup() then
			for i=1,GetNumGroupMembers() do
				caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, caller.target..i)
				if ( caller.__name ) then
					return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
				end
			end
		end
		return (nil), (nil), (nil), (nil), (nil)

	elseif (caller.target == "arena") then
		caller.__inInstance, caller.__instanceType = IsInInstance()
		if caller.__inInstance and (caller.__instanceType == "arena") then
			for i=1,5 do
				caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, caller.target..i)
				if ( caller.__name ) then
					return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
				end
			end
		end
		return (nil), (nil), (nil), (nil), (nil)
	elseif (caller.target == "boss") then
		for i=1,4 do
			caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, caller.target..i)
			if ( caller.__name ) then
				return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
			end
		end
		return (nil), (nil), (nil), (nil), (nil)
	end
	-- Last check is the exact target name
	caller.__name, caller.__texture, caller.__remainingTime, caller.__targetGUID, caller.__stacks = checkTargetForAlert(caller, caller.target)
	if ( caller.__name ) then
		return (caller.__name), (caller.__texture), (caller.__remainingTime), (caller.__targetGUID), (caller.__stacks)
	end
	return (nil), (nil), (nil), (nil), (nil) -- No match
end

local function repositionFrames(caller)
	caller.____index = 1
	for i=1,ClassMods.totalAlertIcons do
		if ClassMods.F.Alerts[i].active then
			ClassMods.F.Alerts[i]:ClearAllPoints()
			-- Flip expanding left to right or right to left depending on anchor point X
			caller.____xPos = ( (ClassMods.db.profile.alerts.icons.iconsize + (ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "RIGHT", 1) + 2) ) * mod(caller.____index - 1, 5) )
			caller.____yPos = (ClassMods.db.profile.alerts.icons.iconsize + (ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "BOTTOM", 1) + 2) ) * floor( (caller.____index - 1) / 5)
			if ClassMods.db.profile.alerts.anchor[4] >= 0 then
				ClassMods.F.Alerts[i]:SetPoint("TOPLEFT", ClassMods.F.AlertIconsHost, "TOPLEFT", caller.____xPos, -caller.____yPos)
			else
				ClassMods.F.Alerts[i]:SetPoint("TOPRIGHT", ClassMods.F.AlertIconsHost, "TOPRIGHT", -caller.____xPos, -caller.____yPos)
			end
			caller.____index = caller.____index + 1
		end
	end
end

function ClassMods.SetupAlerts()
	if(not ClassMods.F.Alerts) then
		ClassMods.F.Alerts = {}
	end
	-- Destruction
	local i = 1
	while ClassMods.F.Alerts[i] ~= nil do
		if (ClassMods.F.Alerts[i].shine) then
			AutoCastShine_AutoCastStop(ClassMods.F.Alerts[i].shine)
		end
		ClassMods.F.Alerts[i]:Hide()
		ClassMods.F.Alerts[i]:SetScript("OnUpdate", nil)
		ClassMods.F.Alerts[i]:ClearAllPoints()
		ClassMods.F.Alerts[i]:UnregisterAllEvents()
		ClassMods.F.Alerts[i]:SetParent(nil)
		tinsert(FRAMEPOOL, ClassMods.F.Alerts[i]) -- recycle
		ClassMods.F.Alerts[i] = nil
		i = i + 1
	end
	-- Clean up the mover frame
	if ClassMods.F.AlertIconsHost then
		ClassMods.F.AlertIconsHost:Hide()
		ClassMods.F.AlertIconsHost:ClearAllPoints()
		ClassMods.F.AlertIconsHost:UnregisterAllEvents()
		ClassMods.DeregisterMovableFrame("MOVER_ALERT_ICONS")
		ClassMods.F.AlertIconsHost:SetParent(nil)
		-- ClassMods.F.AlertIconsHost = nil
	end
	ClassMods.totalAlertIcons = 0
	-- Construction
	local ALERT_UPDATEINTERVAL = 0.08
	if (ClassMods.db.profile.overrideinterval) then
		ALERT_UPDATEINTERVAL = ClassMods.db.profile.updateinterval
	else
		ALERT_UPDATEINTERVAL = ClassMods.db.profile.alerts.updateinterval
	end

	local key,val
	local index = 1
	for key,val in pairs(ClassMods.db.profile.alerts.alerts) do
		if ClassMods.db.profile.alerts.alerts[key] and ClassMods.db.profile.alerts.alerts[key].enabled then
			-- Create the host frame
			if (index == 1) then
				ClassMods.F.AlertIconsHost = ClassMods.MakeFrame(ClassMods.F.AlertIconsHost, "Frame", "CLASSMODS_ALERT_ICON_HOST", ClassMods.db.profile.alerts.anchor[2] or UIParent) -- recycle
				ClassMods.F.AlertIconsHost:SetParent(ClassMods.db.profile.alerts.anchor[2] or UIParent)
				ClassMods.F.AlertIconsHost:ClearAllPoints()
				ClassMods.F.AlertIconsHost:SetSize(ClassMods.db.profile.alerts.icons.iconsize, ClassMods.db.profile.alerts.icons.iconsize) -- Temporary size
				ClassMods.F.AlertIconsHost:SetPoint(ClassMods.GetActiveAnchor(ClassMods.db.profile.alerts.anchor) )
				ClassMods.F.AlertIconsHost:SetAlpha(1)
				ClassMods.F.AlertIconsHost:Show()
			end
			-- Create this Alert's Frame
			ClassMods.F.Alerts[index] = ClassMods.MakeFrame(ClassMods.F.Alerts[index] or tremove(FRAMEPOOL), "Frame", nil, ClassMods.F.AlertIconsHost)
			ClassMods.F.Alerts[index]:SetParent(ClassMods.F.AlertIconsHost)
			ClassMods.F.Alerts[index]:SetSize(ClassMods.db.profile.alerts.icons.iconsize, ClassMods.db.profile.alerts.icons.iconsize)
			ClassMods.F.Alerts[index]:SetPoint("CENTER", ClassMods.F.AlertIconsHost, "CENTER")
			ClassMods.F.Alerts[index]:SetAlpha(0)
			ClassMods.F.Alerts[index].Icon = ClassMods.F.Alerts[index].Icon or ClassMods.F.Alerts[index]:CreateTexture(nil, "BACKGROUND")
			ClassMods.F.Alerts[index].Icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark") -- Just a place-holder
			if ClassMods.db.profile.alerts.icons.enabletexcoords then
				ClassMods.F.Alerts[index].Icon:SetTexCoord(unpack(ClassMods.db.profile.alerts.icons.texcoords) )
			else
				ClassMods.F.Alerts[index].Icon:SetTexCoord(0, 1, 0, 1)
			end
			ClassMods.F.Alerts[index].Icon:ClearAllPoints()
			ClassMods.F.Alerts[index].Icon:SetAllPoints(ClassMods.F.Alerts[index])
			-- Create the Background and border if the user wants one
			ClassMods.F.Alerts[index].background = ClassMods.MakeBackground(ClassMods.F.Alerts[index], ClassMods.db.profile.alerts.icons, nil, ClassMods.F.Alerts[index].background)
			-- Now we can properly set the size of the host frame for the alert icons because we now have offsets.
			if (index == 1) then
				ClassMods.F.AlertIconsHost:SetSize(
					( (ClassMods.db.profile.alerts.icons.iconsize + -- WIDTH
						(ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "LEFT", 1) + ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "RIGHT", 1) + 2) ) * 5)
						- ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "RIGHT", 1) - 2,

					( (ClassMods.db.profile.alerts.icons.iconsize + -- HEIGHT
						(ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "TOP", 1) + ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "BOTTOM", 1) + 2) ) * 4)
						- ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "LEFT", 1) - ClassMods.GetFrameOffset(ClassMods.F.Alerts[1], "RIGHT", 1) - 2)

				ClassMods.RegisterMovableFrame(
					"MOVER_ALERT_ICONS",
					ClassMods.F.AlertIconsHost,
					ClassMods.F.AlertIconsHost,
					L["Alerts"],
					ClassMods.db.profile.alerts,
					index == 1 and ClassMods.SetupAlerts or nil,
					ClassMods.db.profile.alerts,
					nil) -- No background / Border ever on the mover frame
			end
			-- Setup Stacks
			ClassMods.F.Alerts[index].stacks = ClassMods.F.Alerts[index].stacks or ClassMods.F.Alerts[index]:CreateFontString(nil, "OVERLAY")
			ClassMods.F.Alerts[index].stacks:ClearAllPoints()
			ClassMods.F.Alerts[index].stacks:SetJustifyH("RIGHT")
			ClassMods.F.Alerts[index].stacks:SetJustifyV("BOTTOM")
			ClassMods.F.Alerts[index].stacks:SetPoint("BOTTOMRIGHT", ClassMods.F.Alerts[index], "BOTTOMRIGHT", 0, -3)
			ClassMods.F.Alerts[index].stacks:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.alerts.icons.stackfont) )
			ClassMods.F.Alerts[index].stacks:SetTextColor(unpack(ClassMods.db.profile.alerts.icons.stackfontcolor) )
			ClassMods.F.Alerts[index].stacks:SetText("")
			ClassMods.F.Alerts[index].stacks:SetAlpha(1)
			-- Setup Timer Value
			ClassMods.F.Alerts[index].value = ClassMods.F.Alerts[index].value or ClassMods.F.Alerts[index]:CreateFontString(nil, "OVERLAY")
			ClassMods.F.Alerts[index].value:ClearAllPoints()
			ClassMods.F.Alerts[index].value:SetJustifyH("CENTER")
			ClassMods.F.Alerts[index].value:SetJustifyV("CENTER")
			ClassMods.F.Alerts[index].value:SetPoint("CENTER", ClassMods.F.Alerts[index], "CENTER", 0, 0)
			ClassMods.F.Alerts[index].value:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.cooldowns.font) )
			ClassMods.F.Alerts[index].value:SetTextColor(1, 1, 1, 1)
			if (not ClassMods.F.Alerts[index].value.oriShadowColor) then
				ClassMods.F.Alerts[index].value.oriShadowColor = { ClassMods.F.Alerts[index].value:GetShadowColor() }
				ClassMods.F.Alerts[index].value.oriShadowOffset = { ClassMods.F.Alerts[index].value:GetShadowOffset() }
			end
			if (ClassMods.db.profile.cooldowns.enableshadow) then
				ClassMods.F.Alerts[index].value:SetShadowColor(unpack(ClassMods.db.profile.cooldowns.shadowcolor) )
				ClassMods.F.Alerts[index].value:SetShadowOffset(unpack(ClassMods.db.profile.cooldowns.fontshadowoffset) )
			else
				ClassMods.F.Alerts[index].value:SetShadowColor(unpack(ClassMods.F.Alerts[index].value.oriShadowColor) )
				ClassMods.F.Alerts[index].value:SetShadowOffset(unpack(ClassMods.F.Alerts[index].value.oriShadowOffset) )
			end
			ClassMods.F.Alerts[index].value:SetText("")
			ClassMods.F.Alerts[index].value:SetAlpha(1)
			-- Setup the Sparkles if turned on for this Alert frame
			if ClassMods.db.profile.alerts.alerts[key].sparkles then
				ClassMods.F.Alerts[index].shine = ClassMods.F.Alerts[index].shine or CreateFrame("Frame", "AutocastShine_AlertShine", UIParent, "AutoCastShineTemplate")
				ClassMods.F.Alerts[index].shine:ClearAllPoints()
				ClassMods.F.Alerts[index].shine:Show()
				ClassMods.F.Alerts[index].shine:SetSize(ClassMods.db.profile.alerts.icons.iconsize+2, ClassMods.db.profile.alerts.icons.iconsize+2)
				ClassMods.F.Alerts[index].shine:SetPoint("CENTER", ClassMods.F.Alerts[index], "CENTER", 1, -1)
				ClassMods.F.Alerts[index].shine:SetAlpha(1)
				AutoCastShine_AutoCastStop(ClassMods.F.Alerts[index].shine)
			elseif ClassMods.F.Alerts[index].shine then
				ClassMods.F.Alerts[index].shine:Hide()
				ClassMods.F.Alerts[index].shine:ClearAllPoints()
			end
			-- Setup the script for handling the Alert
			ClassMods.F.Alerts[index].index = index
			ClassMods.F.Alerts[index].updateTimer = 0
			ClassMods.F.Alerts[index].active = false
			ClassMods.F.Alerts[index].activeGUID = -1
			ClassMods.F.Alerts[index].checkID = tonumber(ClassMods.db.profile.alerts.alerts[key].aura) and tonumber(ClassMods.db.profile.alerts.alerts[key].aura) or nil
			ClassMods.F.Alerts[index].checkName = (not tonumber(ClassMods.db.profile.alerts.alerts[key].aura) ) and strupper(ClassMods.db.profile.alerts.alerts[key].aura) or nil
			ClassMods.F.Alerts[index].hasSparkles = ClassMods.db.profile.alerts.alerts[key].sparkles
			ClassMods.F.Alerts[index].soundFile = ClassMods.db.profile.alerts.alerts[key].enablesound and ClassMods.db.profile.alerts.alerts[key].sound or nil
			ClassMods.F.Alerts[index].target = ClassMods.db.profile.alerts.alerts[key].target
			ClassMods.F.Alerts[index].healthpercent = ClassMods.db.profile.alerts.alerts[key].healthpercent or 0
			if(ClassMods.db.profile.alerts.alerts[key].alerttype == "BUFF") then
				ClassMods.F.Alerts[index].alertTrigger = _Buff
			elseif(ClassMods.db.profile.alerts.alerts[key].alerttype == "DEBUFF") then
				ClassMods.F.Alerts[index].alertTrigger = _Debuff
			elseif(ClassMods.db.profile.alerts.alerts[key].alerttype == "CAST") then
				ClassMods.F.Alerts[index].alertTrigger = _Cast
			elseif(ClassMods.db.profile.alerts.alerts[key].alerttype == "HEALTH") then
				ClassMods.F.Alerts[index].alertTrigger = _Health
			elseif(ClassMods.db.profile.alerts.alerts[key].alerttype == "PETHEALTH") then
				ClassMods.F.Alerts[index].alertTrigger = _PetHealth
			else
				print("INVALID ALERT FOUND! Index:", index, "Type:", ClassMods.db.profile.alerts.alerts[key].alerttype)
				return
			end
			-- OnUpdate handler
			ClassMods.F.Alerts[index]:SetScript("OnUpdate",
				function(self, elapsed)
					self.updateTimer = self.updateTimer + elapsed
					if(self.updateTimer < ALERT_UPDATEINTERVAL) then
						return
					else
						self.updateTimer = 0
					end
					self._name, self._texture, self._remainingTime, self._targetGUID, self._stacks = checkForAlert(self)
					if (self.active == true) then -- This alert is currently active, check if it's still valid
						if (self._name) and ( (self._targetGUID == self.activeGUID) or (self.alertTrigger == _Health) or (self.alertTrigger == _PetHealth) ) then -- Alert is still active, so update it
							if self._stacks and (self._stacks > 1) then
								self.stacks:SetText(self._stacks)
								self.stacks:Show()
							else
								self.stacks:Hide()
							end
							if self._remainingTime and (self._remainingTime > 0) then
								self.value:SetText(" "..ClassMods.FormatTimeText(self._remainingTime, (self._remainingTime < ClassMods.db.profile.minfortenths) and true or nil, true))
								if self._stacks and (self._stacks > 1) then
									self.value:ClearAllPoints()
									self.value:SetPoint("CENTER", self, "CENTER", -2, 4)
								else
									self.value:ClearAllPoints()
									self.value:SetPoint("CENTER", self, "CENTER", 0, 0)
								end
								self.value:Show()
							else
								self.value:SetText("")
								self.value:Hide()
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
						if (self._name) then -- Now it's active!
							self.active = true
							if self.soundFile and ClassMods.db.profile.enableaudio then
								PlaySoundFile(ClassMods.GetActiveSoundFile(self.soundFile), ClassMods.db.profile.masteraudio and "Master" or nil)
							end
							self.Icon:SetTexture(self._texture)
							self.Icon:Show()
							if self._stacks and (self._stacks > 1) then
								self.stacks:SetText(self._stacks)
								self.stacks:Show()
							else
								self.stacks:Hide()
							end
							if self._remainingTime and (self._remainingTime > 0) then
								self.value:SetText(" "..ClassMods.FormatTimeText(self._remainingTime, (self._remainingTime < ClassMods.db.profile.minfortenths) and true or nil, true) )
								if self._stacks and (self._stacks > 1) then
									self.value:ClearAllPoints()
									self.value:SetPoint("CENTER", self, "CENTER", -2, 4)
								else
									self.value:ClearAllPoints()
									self.value:SetPoint("CENTER", self, "CENTER", 0, 0)
								end
								self.value:Show()
							else
								self.value:SetText("")
								self.value:Hide()
							end
							if ClassMods.moversLocked then
								self:SetAlpha(1)
							else
								self:SetAlpha(0)
							end
							self.triggerGUID = self.resolvedTarget and UnitGUID(self.resolvedTarget) or -1
							if self.hasSparkles then
								AutoCastShine_AutoCastStart(self.shine, 1, .5, .5)
							end
							self.activeGUID = self._targetGUID
							repositionFrames(self)
						end
					end
				end)
			ClassMods.F.Alerts[index]:Show()
			index = index + 1
		end
	end
	ClassMods.totalAlertIcons = index - 1
end