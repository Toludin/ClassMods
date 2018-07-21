--
-- ClassMods by Kaelyth -- Based on JSHB by _JS_ (Soren)
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")
local media = LibStub("LibSharedMedia-3.0")
local AceConfigDialog3 = nil

function ClassMods:OnInitialize()
	-- Setup Saved Variables
	ClassMods.db = LibStub("AceDB-3.0"):New("CMDb", ClassMods.defaults)

	-- Register some shared media defaults
	-- Fonts
	media:Register("font", "Arial Narrow", [[Fonts\ARIALN.TTF]])
	media:Register("font", "Big Noodle", [[Interface\AddOns\ClassMods\media\fonts\BigNoodle.ttf]])
	media:Register("font", "Friz Quadrata TT", [[Fonts\FRIZQT__.TTF]])
	media:Register("font", "Morpheus", [[Fonts\MORPHEUS.ttf]])
	media:Register("font", "Skurri", [[Fonts\skurri.ttf]])
	-- Status Bars
	media:Register("statusbar", "Blank", [[Interface\AddOns\ClassMods\media\textures\blank.tga]])
	media:Register("statusbar", "Blizzard", [[Interface\TargetingFrame\UI-StatusBar]])
	media:Register("statusbar", "Solid", [[Interface\AddOns\ClassMods\media\textures\solid.tga]])
	media:Register("statusbar", "Glaze", [[Interface\AddOns\ClassMods\media\textures\glaze.tga]])
	media:Register("statusbar", "Otravi", [[Interface\AddOns\ClassMods\media\textures\otravi.tga]])
	media:Register("statusbar", "Smooth", [[Interface\AddOns\ClassMods\media\textures\smooth.tga]])
	-- Borders
	media:Register("border", "Blizzard Achievement Wood", [[Interface\AchievementFrame\UI-Achievement-WoodBorder]])
	media:Register("border", "Blizzard Chat Bubble", [[Interface\Tooltips\ChatBubble-Backdrop]])
	media:Register("border", "Blizzard Dialog", [[Interface\DialogFrame\UI-DialogBox-Border]])
	media:Register("border", "Blizzard Dialog Gold", [[Interface\DialogFrame\UI-DialogBox-Gold-Border]])
	media:Register("border", "Blizzard Party", [[Interface\CHARACTERFRAME\UI-Party-Border]])
	media:Register("border", "Blizzard Tooltip", [[Interface\Tooltips\\UI-Tooltip-Border]])
	media:Register("border", "Solid", [[Interface\AddOns\ClassMods\media\textures\solidborder.tga]])
	-- Backgrounds
	media:Register("background", "Blizzard Dialog Background", [[Interface\DialogFrame\UI-DialogBox-Background]])
	media:Register("background", "Blizzard Dialog Background Dark", [[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	media:Register("background", "Blizzard Dialog Background Gold", [[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
	media:Register("background", "Blizzard Low Health", [[Interface\FullScreenTextures\LowHealth]])
	media:Register("background", "Blizzard Marble", [[Interface\FrameGeneral\UI-Background-Marble]])
	media:Register("background", "Blizzard Out of Control", [[Interface\FullScreenTextures\OutOfControl]])
	media:Register("background", "Blizzard Parchment", [[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal]])
	media:Register("background", "Blizzard Parchment 2", [[Interface\AchievementFrame\UI-GuildAchievement-Parchment-Horizontal]])
	media:Register("background", "Blizzard Rock", [[Interface\FrameGeneral\UI-Background-Rock]])
	media:Register("background", "Blizzard Tabard Background", [[Interface\TabardFrame\TabardFrameBackground]])
	media:Register("background", "Blizzard Tooltip", [[Interface\Tooltips\UI-Tooltip-Background]])
	media:Register("background", "Solid", [[Interface\Buttons\WHITE8X8]])
	-- Sounds
	media:Register("sound", "Alliance Bell", [[Sound\Doodad\BellTollAlliance.ogg]])
	media:Register("sound", "Cannon Blast", [[Sound\Doodad\Cannon01_BlastA.ogg]])
	media:Register("sound", "Classic", [[Sound\Doodad\BellTollNightElf.ogg]])
	media:Register("sound", "Ding", [[Sound\interface\AlarmClockWarning3.ogg]])
	media:Register("sound", "Dynamite", [[Sound\Spells\DynamiteExplode.ogg]])
	media:Register("sound", "Gong", [[Sound\Doodad\G_GongTroll01.ogg]])
	media:Register("sound", "Horde Bell", [[Sound\Doodad\BellTollHorde.ogg]])
	media:Register("sound", "Raid Warning", [[Sound\interface\RaidWarning.ogg]])
	media:Register("sound", "Serpent", [[Sound\Creature\TotemAll\SerpentTotemAttackA.ogg]])
	media:Register("sound", "Tribal Bell", [[Sound\Doodad\BellTollTribal.ogg]])

	-- Register Slash commands
	SlashCmdList["ClassMods"] = ClassMods.SlashProcessor_ClassMods
	_G["SLASH_ClassMods1"] = '/classmods'

	-- ClassMods tries to wait for all variables to be loaded before configuring itself.
	ClassMods:RegisterEvent("VARIABLES_LOADED")

	-- Check for first run
	ClassMods.CheckForNewInstallSetup()

	-- Register a reconfigure call for when the user changes profiles.
	ClassMods.db.RegisterCallback(ClassMods, "OnProfileChanged", "PostChangeProfile")
	ClassMods.db.RegisterCallback(ClassMods, "OnProfileCopied", "PostChangeProfile")
	ClassMods.db.RegisterCallback(ClassMods, "OnProfileReset", "PostChangeProfile")

	-- Setup the initial options panels.
	ClassMods.Options.Initialize()
end

--
-- Start Registered Event Functions
--
function ClassMods:VARIABLES_LOADED()
	ClassMods:UnregisterEvent("VARIABLES_LOADED")
	-- enable modules
	do
		ClassMods.RegisterConfigFunction("MOD_ALERTS",					ClassMods.SetupAlerts)
		ClassMods.RegisterConfigFunction("MOD_ALTRESOURCEBAR",	ClassMods.SetupAltResourceBar)
		ClassMods.RegisterConfigFunction("MOD_ANNOUNCEMENTS",	ClassMods.SetupAnnouncements)
		ClassMods.RegisterConfigFunction("MOD_CLICKTOCAST", 		ClassMods.SetupClickToCast)
		ClassMods.RegisterConfigFunction("MOD_CROWDCONTROL",	ClassMods.SetupCrowdControl)
		ClassMods.RegisterConfigFunction("MOD_DISPELS",					ClassMods.SetupDispels)
		ClassMods.RegisterConfigFunction("MOD_HEALTHBAR",				ClassMods.SetupHealthBar)
		ClassMods.RegisterConfigFunction("MOD_INDICATORS",			ClassMods.SetupIndicators)
		ClassMods.RegisterConfigFunction("MOD_RESOURCEBAR",		ClassMods.SetupResourceBar)
		ClassMods.RegisterConfigFunction("MOD_TARGETBAR",			ClassMods.SetupTargetBar)
		ClassMods.RegisterConfigFunction("MOD_TIMERS",					ClassMods.SetupTimers)
		ClassMods.RegisterConfigFunction("MOD_TOTEMTIMERS",			ClassMods.SetupTotemTimers)
	end

	-- Globally configure all modules.
	ClassMods.ReconfigureClassMods()

	-- Register Events
	ClassMods:RegisterEvent("UI_SCALE_CHANGED")
	ClassMods:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ClassMods:RegisterEvent("PLAYER_LEVEL_UP")
	ClassMods:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function ClassMods:UI_SCALE_CHANGED()
	ClassMods.ReconfigureClassMods()
end

function ClassMods:PLAYER_SPECIALIZATION_CHANGED()
	local specName = select(2, GetSpecializationInfo(GetSpecialization())) or ""
	local className = select(1, UnitClass("player")) or ""
		if ((specName .. " " .. className) ~= ClassMods.db:GetCurrentProfile()) then
			local t = ClassMods.db:GetProfiles()
			local profileExists = false
			for k,v in ipairs(t) do
				if ((specName .. " " .. className) == v) then
					profileExists = true
					break
				end
			end
			if profileExists then
				ClassMods.db:SetProfile((specName .. " " .. className))				
			end
		end
	ClassMods.ReconfigureClassMods()
end

function ClassMods:PLAYER_ENTERING_WORLD()
	ClassMods.ReconfigureClassMods()
end

function ClassMods:PLAYER_LEVEL_UP()
	ClassMods.ReconfigureClassMods()
end

function ClassMods:PostChangeProfile()
	ClassMods.Options:PopulateDB()
	ClassMods.ReconfigureClassMods()
end
--
-- End Registered Event Functions
--

--
-- General Functions
--
local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local SECONDWITHTENTHS_ABBR = '%.1f'.. strsub(SECOND_ONELETTER_ABBR, 4)
local SECONDS_ABBR = '%d' .. strsub(SECOND_ONELETTER_ABBR, 4)
local MINS_ABBR = '%d' .. strsub(MINUTE_ONELETTER_ABBR, 4)
local HOURS_ABBR = '%d' .. strsub(HOUR_ONELETTER_ABBR, 4)
local DAYS_ABBR = '%d' .. strsub(DAY_ONELETTER_ABBR, 4)
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2.5 --the minimum duration to show cooldown text for
local EXPIRING_DURATION = 3 --the minimum number of seconds a cooldown must be to use to display in the expiring format
local min, max, abs = math.min, math.max, math.abs -- Upvalues

function ClassMods.SlashProcessor_ClassMods(input, editbox)
	local v1, v2 = input:match("^(%S*)%s*(.-)$")
	v1 = v1:lower()
	if (v1 == "options") or (v1 == "config") or (v1 == "opt") or (v1 == "o") or (v1 == "") then
		AceConfigDialog3 = AceConfigDialog3 or LibStub("AceConfigDialog-3.0")
		if AceConfigDialog3 and AceConfigDialog3.OpenFrames["ClassMods"] then
			ClassMods.CloseOptions()
		else
			ClassMods.OpenOptions()
		end
	elseif (v1 == "reset") then
		if (not InCombatLockdown() ) then
			print(L["CLASSMODS_PRE"]..L["MOVERSSETTODEFAULT"])
			ClassMods.SetDefaultMoversPositions()
		else
			print(L["CLASSMODS_PRE"]..L["INCOMBATLOCKDOWN"])
		end
	elseif (v1 == "lock") or (v1 == "unlock") or (v1 == "drag") or (v1 == "move") or (v1 == "l") then
		ClassMods.ToggleMoversLock()
	elseif (v1 == "tableid") or (v1 == "table") then
		if GetMouseFocus():GetName() then
			print("TABLE:", GetMouseFocus():GetName()..(v2 ~= nil and "."..v2 or "") )
			local key, val, frameTable
			frameTable = (v2 ~= nil) and _G[GetMouseFocus():GetName()][v2] or _G[GetMouseFocus():GetName()]
			for key,val in pairs(frameTable) do
				print("Key: ", key, " Val: ", val)
			end
		end
	elseif (v1 == "mem") or (v1 == "m") then
		UpdateAddOnMemoryUsage()
		print("Memory Used:", GetAddOnMemoryUsage("ClassMods") )
	elseif (v1 == "gc") then
		print("Garbage collected...")
		collectgarbage("collect")
	elseif (v1 == "setprofile") and (v2 ~= nil) then
		if (v2 == ClassMods.db:GetCurrentProfile()) then
			print(L["CLASSMODS_PRE"].."|cffff0000".. v2 .." is the current profile".."|r")
		else
			local t = ClassMods.db:GetProfiles()
			local profileExists = false
			for k,v in ipairs(t) do
				if (v2 == v) then
					profileExists = true
					break
				end
			end
			if profileExists then
				ClassMods.db:SetProfile(v2)
				print(L["CLASSMODS_PRE"].." ".. v2 .." profile activated.")
			else
				print(L["CLASSMODS_PRE"].."|cffff0000".. v2 .." is not a valid profile".."|r")
			end
		end
	else
		print(format(L["SLASHDESC1"], ClassMods.myVersion) )
		print("/classmods config - " .. L["SLASHDESC2"])
		print("/classmods lock - " .. L["SLASHDESC3"])
		print("/classmods reset - " .. L["SLASHDESC4"])
	end
end

function ClassMods.GetActiveAnchor(anchor, override1, override2, override3, override4, override5)
	return override1 or anchor[1], override2 or (anchor[2] == nil and UIParent or anchor[2]), override3 or anchor[3], override4 or anchor[4], override5 or anchor[5]
end

function ClassMods.GetActiveFont(key, index, returnKey)
	local f1, f2, f3
	f1, f2, f3 = unpack(key)
	return media:Fetch("font", f1 or "Big Noodle"), f2, f3
end

function ClassMods.GetActiveSoundFile(key, default, returnKey)
	return media:Fetch("sound", key or "Raid Warning")
end

function ClassMods.GetActiveTextureFile(key, default, returnKey)
	return media:Fetch("statusbar", key or "Blank")
end

function ClassMods.GetActiveBackgroundFile(key, default, returnKey)
	return media:Fetch("background", key or "None")
end

function ClassMods.GetActiveBorderFile(key, default, returnKey)
	return media:Fetch("border", key or "None")
end

function ClassMods.AbbreviateNumber(rawNumber)
	local newNumber
	if rawNumber > 1000000 then
		newNumber = ("%.01fM"):format(rawNumber/1000000)
	end
	if rawNumber <= 1000000 then
		newNumber = ("%.01fK"):format(rawNumber/1000)
	end
	if rawNumber <= 1000 then
		newNumber = rawNumber
	end
	return newNumber
end

function ClassMods.CheckIfKnown(spell, item)
	local spellID
	if spell then
		if (not tonumber(spell)) then
			spellID = ClassMods.NameToSpellID(spell)
		else
			spellID = tonumber(spell)
		end

		if (spellID) and (IsPlayerSpell(spellID)) then
			return true
		end
	elseif (item) and (GetItemInfo(item) ) then -- Items are easier to check, single call, no helpers
		return true
	end
	return nil
end

function ClassMods.GetMatchTableValSimple(wTable, toMatch, returnIndex)
	for i=1,#wTable do
		if (wTable[i] == toMatch) then return (returnIndex and i or wTable[i]) end
	end
	return nil
end

function ClassMods.GetMatchTableVal(wTable, colMatch, colReturn, toMatch)
	for i=1,#wTable do
		if (wTable[i][colMatch] == toMatch) then return wTable[i][colReturn] end
	end
	return nil
end

function ClassMods.GetMatchTablePosition(wTable, colMatch, toMatch)
	for i=1,#wTable do
		if (wTable[i][colMatch] == toMatch) then return(i) end
	end
	return nil
end

--Return rounded number
function ClassMods.Round(v, decimals)
    return ( ("%%.%df"):format(decimals or 0) ):format(v)
end

--Truncate a number off to n places
function ClassMods.Truncate(v, decimals)
    return v - (v % (0.1 ^ (decimals or 0) ) )
end

function ClassMods.ParseItemLink(itemLink, returnNil)
	if (not itemLink) then return(returnNil and nil or "") end
	return string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
end

--RGB to Hex
function ClassMods.RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("\124cff%02x%02x%02x", r*255, g*255, b*255)
end

--Hex to RGB
function ClassMods.HexToRGB(hex)
	local rhex, ghex, bhex
	rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16), tonumber(ghex, 16), tonumber(bhex, 16)
end

function ClassMods.UnpackColors(color)
	if color.a then
		return color.r and color.r or 0, color.g and color.g or 0, color.b and color.b or 0, color.a
	else
		return color.r and color.r or 0, color.g and color.g or 0, color.b and color.b or 0
	end
end

function ClassMods.FormatTimeText(val, tenths, autoColor, timeIndicator)
	local db = ClassMods.db.profile.cooldowns
	-- Expiring
	if (val <= EXPIRING_DURATION) then
		if tenths then
			return autoColor and format(ClassMods.RGBToHex(unpack(db["expiringcolor"]) )..(timeIndicator and (SECONDWITHTENTHS_ABBR .. '|r') or '%.1f|r'), val) or format(timeIndicator and SECONDWITHTENTHS_ABBR or '%.1f', val)
		else
			return autoColor and format(ClassMods.RGBToHex(unpack(db["expiringcolor"]) )..(timeIndicator and (SECONDS_ABBR .. '|r') or '%d|r'), val) or format(timeIndicator and SECONDS_ABBR or '%d', val)
		end
	-- Format seconds
	elseif (val <= MINUTEISH) then
		if tenths then
			return autoColor and format(ClassMods.RGBToHex(unpack(db["secondscolor"]) )..(timeIndicator and (SECONDWITHTENTHS_ABBR .. '|r') or '%.1f|r'), val) or format(timeIndicator and SECONDWITHTENTHS_ABBR or '%.1f', val)
		else
			return autoColor and format(ClassMods.RGBToHex(unpack(db["secondscolor"]) )..(timeIndicator and (SECONDS_ABBR .. '|r') or '%d|r'), tonumber(ClassMods.Round(val) ) ) or format(timeIndicator and SECONDS_ABBR or '%d', tonumber(ClassMods.Round(val) ) )
		end
	-- Format Minutes
	elseif (val <= HOURISH ) then
		return autoColor and format(ClassMods.RGBToHex(unpack(db["minutescolor"]) )..(timeIndicator and (MINS_ABBR .. '|r') or '%d|r'), tonumber(ClassMods.Round(val/MINUTE) ) ) or format(timeIndicator and MINS_ABBR or '%d', tonumber(ClassMods.Round(val/MINUTE) ) )
	-- Format Hours
	elseif (val <= DAYISH ) then
		return autoColor and format(ClassMods.RGBToHex(unpack(db["hourscolor"]) )..(timeIndicator and (HOURS_ABBR .. '|r') or '%d|r'), tonumber(ClassMods.Round(val/HOUR) ) ) or format(timeIndicator and HOURS_ABBR or '%d', tonumber(ClassMods.Round(val/HOUR) ) )
	-- Format Days
	else
		return autoColor and format(ClassMods.RGBToHex(unpack(db["dayscolor"]) )..(timeIndicator and (DAYS_ABBR .. '|r') or '%d|r'), tonumber(ClassMods.Round(val/DAY) ) ) or format(timeIndicator and DAYS_ABBR or '%d', tonumber(ClassMods.Round(val/DAY) ) )
	end
end

--[[
	Returns the proper chat channel to display a chat message in.
	Returns the same channel passed, unless it's a "SELFWHISPER" or
	value of 1.  Whispers make sure to hide the outgoing whisper so you
	do not need to see double messages, especially for "SELFWHISPER".
--]]

function ClassMods.GetChatChan(chan)
	local function HideOutgoing(self, event, msg, author, ...)
		if ( string.sub(author,1,string.len(GetUnitName("player")))==GetUnitName("player") ) then
			ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutgoing)
    		return true
		end
	end

	if (chan ~= "AUTO") then
		if (chan == "SELFWHISPER") then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutgoing)
			return("WHISPER")
		end
		return(chan)
	end
	-- Auto roll-down
	local zoneType = select(2, IsInInstance() )
	if (zoneType == "pvp") or (zoneType == "arena") then
		return "INSTANCE_CHAT" -- "BATTLEGROUND"
	elseif IsInRaid() then
		return(IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
	elseif IsInGroup() then
		return(IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
	else
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutgoing)
		return "WHISPER" -- default to whisper as last resort unless directly specified
	end
end

function ClassMods.GetGroupType()
	local zoneType = select(2, IsInInstance() )
	if (zoneType == "arena") then
		return "ARENA"
	elseif (zoneType == "pvp") then
		return "PVP" -- was "BATTLEGROUND"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	else
		return "SOLO"
	end
end

-- EXAMPLE SPELL LINK "\124cffffd000\124Hspell:34026\124h[Kill Command]\124h\124r"
function ClassMods.NameToSpellID(spellName)
	local spellLink
	spellLink = GetSpellLink(spellName)
	if spellLink then
		return(spellLink.match(spellLink, "spell:(%d+)") )
	end
	return nil
end

function ClassMods.NameToItemID(itemName)
	local itemName
	itemLink = GetSpellLink(itemName)
	if itemLink then
		return(itemLink.match(itemLink, "item:(%d+)") )
	end
	return nil
end

function ClassMods.GetSpellCost(id, spec)
	local spellCost, returnCost
	for i=1,#ClassMods.classSpells[spec] do
		if (ClassMods.classSpells[spec][i][1] == id) then
			spellCost = ClassMods.classSpells[spec][i][2]
			break
		end
	end
	
	returnCost = spellCost
	
	if (select(2, UnitClass("player")) == "DEATHKNIGHT") then
		if (id == 49998) and AuraUtil.FindAuraByName("Ossuary", "player") then -- Death Strike and Ossuary buff
			returnCost = spellCost - 5
		end
	end
	
	if (select(2, UnitClass("player")) == "DRUID") then
		if AuraUtil.FindAuraByName("Berserk", "player") then -- Berserk
			returnCost = spellCost - ceil(spellCost * .6)
		elseif IsPlayerSpell(114107) and (id == 191034) then -- Soul of the Forest talent and Starfall
			returnCost = spellCost - 10
		end
	end
	
	if (select(2, UnitClass("player")) == "WARRIOR") then
		if AuraUtil.FindAuraByName("player", "Deadly Calm") then -- Player cast Deadly Calm
			returnCost = 0	
		elseif IsPlayerSpell(202922) and (id == 184367) then -- Carnage Talent and spell is Rampage
			returnCost = spellCost - 10
		--elseif IsPlayerSpell(202297) then -- Dauntless Talent
		--	returnCost = spellCost - ceil(spellCost * .2)
		elseif (id == 204488) and AuraUtil.FindAuraByName(GetSpellInfo(202573), "player") then -- Vengence: Focused Rage buff
			returnCost = spellCost - ceil(spellCost * .67)
		elseif (id == 190456) and AuraUtil.FindAuraByName(GetSpellInfo(202574), "player") then -- Vengence: Ignore Pain buff
			returnCost = spellCost - ceil(spellCost * .67)
		end
	end
	
	return returnCost
end

function ClassMods.Timer_OnSizeChanged(self, width, height)
	self.text:SetFont(ClassMods.GetActiveFont(ClassMods.db.profile.cooldowns.font) )
	if ClassMods.db.profile.cooldowns.enableshadow then
		self.text:SetShadowColor(unpack(ClassMods.db.profile.cooldowns.shadowcolor) )
		self.text:SetShadowOffset(unpack(ClassMods.db.profile.cooldowns.fontshadowoffset) )
	end
	if self.enabled then
		self.nextUpdate = 0
		self:Show()
	end
end

function ClassMods.Timer_OnUpdate(self, elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if floor(remain + 0.1) > 0 then
			self.text:SetText(ClassMods.FormatTimeText(remain, (remain <= ClassMods.db.profile.minfortenths), true, false) )
			self.nextUpdate = 0.1
		else
			self.enabled = nil
			self:Hide()
		end
	end
end

function ClassMods.Timer_Create(self)
	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)
	local timer = CreateFrame('Frame', nil, scaler)
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript("OnUpdate", ClassMods.Timer_OnUpdate)
	local text = timer:CreateFontString(nil, 'OVERLAY')
	--text:SetPoint("TOPRIGHT", (floor(self:GetWidth() + 0.5) / 30) * 2, 0) -- 2px offset based on 18px font and 30px standard icon width
	text:SetPoint("CENTER", 0, 0)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("CENTER")
	timer.text = text
	ClassMods.Timer_OnSizeChanged(timer, scaler:GetSize() )
	scaler:SetScript("OnSizeChanged", function(self, ...) ClassMods.Timer_OnSizeChanged(timer, ...) end)
	self.timer = timer
	return timer
end

function ClassMods.CheckForDebuff(spell, target, owner)
	local buffIndex = ClassMods.getAuraIndex(target, tonumber(spell) and GetSpellInfo(tonumber(spell) ), (owner == "PLAYERS") and "PLAYER|HARMFUL" or "HARMFUL")
	if not buffIndex then return end
	local name, icon, count, _, duration, expirationTime, _, _, _, spellId = UnitAura(target, buffIndex,  (owner == "PLAYERS") and "PLAYER|HARMFUL" or "HARMFUL")

	-- Fix for missing durations of some spells
	local strSpellId = spellId and tostring(spellId) or ( (type(spell) == "number") and tostring(spell) or ClassMods.NameToSpellID(spell) )
	if (target == "target") and strSpellId and ClassMods.spellTracker.spells[strSpellId] then
		if (UnitGUID("target") and (UnitGUID("target") == ClassMods.spellTracker.spells[strSpellId][1]) ) or (ClassMods.spellTracker.spells[strSpellId][1] == UnitGUID("player") ) then
			if (ClassMods.spellTracker.spells[strSpellId][2] > GetTime() ) then
				if (not name) then
					name, rank, icon = GetSpellInfo(spell)
					count = 1
				end
				duration = ClassMods.spellTracker.spells[strSpellId][3] -- 3 is known duration
				expirationTime = ClassMods.spellTracker.spells[strSpellId][2]
			end
		end
	end

	return (name and icon or nil), (name and duration or 0), ( (name and (expirationTime - GetTime() ) > 0) and math.max(expirationTime - GetTime(), 0) or 0), (count)
end

function ClassMods.CheckForBuff(spell, target, owner)
	local buffIndex = ClassMods.getAuraIndex(target, tonumber(spell) and GetSpellInfo(tonumber(spell) ) or spell, (owner == "PLAYERS") and "PLAYER|HELPFUL" or "HELPFUL")
	if not buffIndex then return end
	local name, icon, count, debuffType, duration, expirationTime = UnitAura(target, buffIndex, (owner == "PLAYERS") and "PLAYER|HELPFUL" or "HELPFUL")

	return (name and icon or nil), (name and duration or 0), ( (name and (expirationTime - GetTime() ) > 0) and math.max(expirationTime - GetTime(), 0) or 0), (count)
end

--[[
	Wrapper to check for a timer's presence.

	returns:
	1 - spell's or item's texture if found or nil,
	2 - full duration time of the spell or item
	3 - remaining time on the cooldown or duration
	4 - stacks of the aura or 0 for none or n/a
--]]

function ClassMods.GetTimerInfo(spell, item, target, timerType, owner, internalcd, lastTime)
	local _, i, icon, icon2, duration, remaining, stacks, itemName, itemLink, itemTexture, startTime, enable, name, rank, maxPlayers, inInstance, instanceType, timeremaining
	-- ITEM COOLDOWN
	if item then
		itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(tonumber(item) or item)
		if (not itemLink) then
			return (nil), (0), (0), (0)
		end
		startTime, duration, enable = GetItemCooldown(select(5, ClassMods.ParseItemLink(itemLink) ) ) -- Why the hell doesn't GetItemInfo return the ID
		if (timerType == "ICOOLDOWN") then
			duration = internalcd
		end
		return ( (itemName and (duration ~= 0) ) and itemTexture or nil), (itemName and duration or 0), (itemName and math.max(startTime + duration - GetTime(), 0) or 0), (0) -- no stacks needed for an item
	end
	-- SPELL COOLDOWN (this is only for player spells - including pet spells)
	if (timerType == "COOLDOWN") then
		name, rank, icon = GetSpellInfo(tonumber(spell) or spell)
		if (not name) then return (nil), (0), (0), (0) end
		startTime, duration, enable = GetSpellCooldown(name)
		stacks = select(1, GetSpellCharges(name)) or 0
		-- Need to hack this code a bit, because if we are on GCD it will trigger this to have a duration.
		-- Assuming the duration cannot be less than 1.51, we can override the issues with a simple hack.
		if duration and (duration > 1.5) then
			return (duration == 0 and nil or icon), (duration == 0 and 0 or duration), (duration == 0 and 0 or math.max(startTime + duration - GetTime(), 0) ), (stacks)
		else
			return (nil), (0), (0), (stacks) -- easy!
		end
	end
	-- SPELL INTERNAL COOLDOWN (this is only for player spells - including pet spells)
	if (timerType == "ICOOLDOWN") then
		-- Check if it's active on target (player)
		icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target, "ANY") -- owner should be field 3, but this breaks ICDs
		if icon then
			-- Active, so return times for updating the icd
			return (nil), (tonumber(internalcd) ), (remaining + tonumber(internalcd) ), (0)
		else
			-- Not active! We need the icon... Something wrong... Exit...
			name, rank, icon2 = GetSpellInfo(tonumber(spell) or spell)
			if (not name) or (not lastTime) or (type(lastTime) ~= "number") then
				return (nil), (0), (0), (0)
			end
			-- All ok... We need to check the remaining time
			timeremaining = math.max(lastTime + tonumber(internalcd) - GetTime(), 0)
			-- If no remaining time, return nil texture to hide the icon
			if (timeremaining > 0) then
				return (icon2), (tonumber(internalcd) ), (timeremaining), (0)
			else
				return (nil), (0), (0), (0)
			end
		end
	end
	-- SPELL DURATION (This is the tricky one dealing with hostile vs. friendly and full checks like all of raid/party, etc.)
	if ( (target == "raid") or (target == "raidpet") ) and IsInGroup() then
		if (GetNumGroupMembers() ~= 0) then
			if IsInInstance() then
				maxPlayers = select(5, GetInstanceInfo() )
			else
				maxPlayers = 40
			end
			for i=1,maxPlayers do
				if UnitExists(target..i) then
					if (owner ~= "PLAYERS") then -- Player can not debuff a friendly unit, unless mind controlled or such!
						icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target..i, owner)
						if icon then return (icon), (duration), (remaining), (stacks) end
					end
					icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target..i, owner)
					if icon then return (icon), (duration), (remaining), (stacks) end
				end
			end
		end
		return (nil), (0), (0), (0)
	elseif ( (target == "party") or (target == "partypet") ) and IsInGroup() then
		if (owner ~= "PLAYERS") then
			icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target == "party" and "player" or "pet", owner)
			if icon then return (icon), (duration), (remaining), (stacks) end
		end
		icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target == "party" and "player" or "pet", owner)
		if icon then return (icon), (duration), (remaining), (stacks) end
		for i=1,GetNumGroupMembers() do
			if (owner ~= "PLAYERS") then
				icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target..i, owner)
				if icon then return (icon), (duration), (remaining), (stacks) end
			end
			icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target..i, owner)
			if icon then return (icon), (duration), (remaining), (stacks) end
		end
		return (nil), (0), (0), (0)
	elseif (target == "arena") and IsInGroup() then
		inInstance, instanceType = IsInInstance()
		if inInstance and (instanceType == "arena") then
			for i=1,5 do
				if UnitExists(target..i) then
					icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target..i, owner)
					if icon then return (icon), (duration), (remaining), (stacks) end
					icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target..i, owner)
					if icon then return (icon), (duration), (remaining), (stacks) end
				end
			end
		end
		return (nil), (0), (0), (0)
	elseif (target == "boss") then
		for i=1,4 do
			if UnitExists(target..i) then
				icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target..i, owner)
				if icon then return (icon), (duration), (remaining), (stacks) end
				icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target..i, owner)
				if icon then return (icon), (duration), (remaining), (stacks) end
			end
		end
		return (nil), (0), (0), (0)
	end
	-- Lastly we check the exact target for a debuff first then buff
	icon, duration, remaining, stacks = ClassMods.CheckForDebuff(spell, target, owner)
	if icon then return (icon), (duration), (remaining), (stacks) end
	
	icon, duration, remaining, stacks = ClassMods.CheckForBuff(spell, target, owner)
	if icon then return (icon), (duration), (remaining), (stacks) end
	
	-- Nothing found for the spell given
	return (nil), (0), (0), (0)
end

function ClassMods.GetTimerIconTexture(spell, item)
	if item then -- ITEM
		local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(tonumber(item) or item)
		if itemName and itemTexture then
			return itemTexture
		end
	else -- SPELL
		local name, rank, icon = GetSpellInfo(tonumber(spell) or spell)
		if name and icon then
			return icon
		end
	end
	return nil
end

function ClassMods.ConfirmActionDialog(strText, onAcceptFunc, onCancelFunc, yesText, noText)
	StaticPopupDialogs["CLASSMODS_CONFIRMACTIONDIALOG"] = {
		text = strText,
		button1 = yesText or YES,
		button2 = noText or NO,
		showAlert = true,
		OnAccept = onAcceptFunc,
		OnCancel = onCancelFunc,
		timeout = 0,
		hideOnEscape = true,
		whileDead  = true,
	}
	StaticPopup_Show ("CLASSMODS_CONFIRMACTIONDIALOG")
end

--[[
	This function returns a deep copy of a given table.
	The function below also copies the metatable to the new table if there is one,
	so the behaviour of the copied table is the same as the original.
	*** But the 2 tables share the same metatable, you can avoid this by setting the
	"deepcopymeta" option to true to make a copy of the metatable, as well.
--]]

function ClassMods.DeepCopy(object, deepcopymeta)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, deepcopymeta and _copy(getmetatable(object) ) or getmetatable(object) )
    end
    return _copy(object)
end

--[[
	Defaults need to be setup after the options table is defined in Ace (defaults that may be totally removed).
	If not, when you remove an object (as in timers), it will create a 'nil' table entry and totally fuck things up.
--]]

function ClassMods.CheckForNewInstallSetup(forceIt)
	if (ClassMods.db.profile.newinstall == false) and (not forceit) then return end
	
	-- Timer sets, merge defaluts into the profile for new installs
	for key,val in pairs(ClassMods.timerbarDefaults) do
		for i=1,#ClassMods.timerbarDefaults[key] do
			if not ClassMods.db.profile.timers[key].timers then ClassMods.db.profile.timers[key].timers = {} end
			ClassMods.db.profile.timers[key].timers[i] = ClassMods.DeepCopy(ClassMods.timerbarDefaults[key][i])
		end
	end
	
	-- Announcements
	for key,val in pairs(ClassMods.announcementDefaults) do
		if not ClassMods.db.profile.announcements.announcements then ClassMods.db.profile.announcements.announcements = {} end
		ClassMods.db.profile.announcements.announcements[key] = ClassMods.DeepCopy(ClassMods.announcementDefaults[key])
	end
	
	-- Alerts
	for key,val in pairs(ClassMods.alertDefaults) do
		if not ClassMods.db.profile.alerts.alerts then ClassMods.db.profile.alerts.alerts = {} end
		ClassMods.db.profile.alerts.alerts[key] = ClassMods.DeepCopy(ClassMods.alertDefaults[key])
	end
	
	ClassMods.db.profile.newinstall = false
end

function ClassMods.ClearTimersForSet(barNum)
	wipe(ClassMods.db.profile.timers["timerbar"..barNum].timers)
end

function ClassMods.ImportDefaultTimersForSet(barNum)
	if not ClassMods.db.profile.timers["timerbar"..barNum].timers then
		ClassMods.db.profile.timers["timerbar"..barNum].timers = {}
	end
	ClassMods.ClearTimersForSet(barNum) -- Clear the current timers
	for i=1,#ClassMods.timerbarDefaults["timerbar"..barNum] do
		ClassMods.db.profile.timers["timerbar"..barNum].timers[i] = ClassMods.DeepCopy(ClassMods.timerbarDefaults["timerbar"..barNum][i])
	end
end

--
-- CooldownTimers for showing time remaining for timers.
--

--returns both what text to display, and how long until the next update
function ClassMods.getTimeText(s)
	local db = ClassMods.profiles.cooldowns
	--format text as seconds when below a minute
	if s < MINUTEISH then
		local seconds = tonumber(ClassMods.Round(s) )
		if seconds > EXPIRING_DURATION then
			return ClassMods.RGBToHex(ClassMods.GetActiveColor(db["secondscolor"]) )..'%d|r', seconds, s - (seconds - 0.51)
		else
			return ClassMods.RGBToHex(ClassMods.GetActiveColor(db["expiringcolor"]) )..'%.1f|r', s, 0.051
		end
	--format text as minutes when below an hour
	elseif s < HOURISH then
		local minutes = tonumber(ClassMods.Round(s/MINUTE) )
		return ClassMods.RGBToHex(ClassMods.GetActiveColor(db["minutescolor"]) )..'%dm|r', minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH) ) or (s - MINUTEISH)
	--format text as hours when below a day
	elseif s < DAYISH then
		local hours = tonumber(ClassMods.Round(s/HOUR) )
		return ClassMods.RGBToHex(ClassMods.GetActiveColor(db["hourscolor"]) )..'%dh|r', hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH) ) or (s - HOURISH)
	--format text as days
	else
		local days = tonumber(ClassMods.Round(s/DAY) )
		return ClassMods.RGBToHex(ClassMods.GetActiveColor(db["dayscolor"]) )..'%dd|r', days,  days > 1 and (s - (days*DAY - HALFDAYISH) ) or (s - DAYISH)
	end
end

function Timer_Stop(self)
	self.enabled = nil
	self:Hide()
end

function Timer_ForceUpdate(self)
	self.nextUpdate = 0
	self:Show()
end

function Timer_OnSizeChanged(self, width, height)
	local fontScale = E.Round(width) / ICON_SIZE
	if (fontScale == self.fontScale) then
		return
	end
	self.fontScale = fontScale
	if (fontScale < MIN_SCALE) then
		self:Hide()
	else
		local db = ClassMods.profiles.cooldowns
		self.text:SetFont(ClassMods.GetActiveFont(db["font"], 1), fontScale * ClassMods.GetActiveFont(db["font"], 2), ClassMods.GetActiveFont(db["font"], 3) )
		self.text:SetShadowColor(ClassMods.GetActiveColor(db["shadowcolor"]) )
		self.text:SetShadowOffset(ClassMods.GetActiveOffset(db["fontshadowoffset"]) )
		if self.enabled then
			Timer_ForceUpdate(self)
		end
	end
end

function Timer_OnUpdate(self, elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0.01 then
			if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale() ) < MIN_SCALE then
				self.text:SetText("")
				self.nextUpdate  = 1
			else
				local formatStr, time, nextUpdate = ClassMods.getTimeText(remain)
				self.text:SetFormattedText(formatStr, time)
				self.nextUpdate = nextUpdate
			end
		else
			Timer_Stop(self)
		end
	end
end

function Timer_Create(self)
	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)
	local timer = CreateFrame('Frame', nil, scaler)
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript("OnUpdate", Timer_OnUpdate)
	local text = timer:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", 1, 1)
	text:SetJustifyH("CENTER")
	timer.text = text
	Timer_OnSizeChanged(timer, scaler:GetSize() )
	scaler:SetScript("OnSizeChanged", function(self, ...) Timer_OnSizeChanged(timer, ...) end)
	self.timer = timer
	return timer
end

--
-- Smoother for bars
--
function Smooth(self, value)
	if (value ~= self:GetValue() ) or (value == 0) then
		self.smoothing = value
	else
		self.smoothing = nil
	end
end

function ClassMods.MakeSmooth(powerFrame)
	if powerFrame.SetValue_ORI then return end

	powerFrame.SetValue_ORI = powerFrame.SetValue
	powerFrame.SetValue = Smooth
	powerFrame.smoother = powerFrame.smoother or CreateFrame("Frame", nil, powerFrame)
	powerFrame.smoother:SetParent(powerFrame)
	powerFrame.smoother:SetScript("OnUpdate", function(self)
		local rate = GetFramerate()
		local limit = 30 / rate
		if self:GetParent().smoothing then
			local cur = self:GetParent():GetValue()
			local new = cur + min( (self:GetParent().smoothing - cur) / 3, max(self:GetParent().smoothing - cur, limit) )
			self:GetParent():SetValue_ORI(new)
			if (cur == self:GetParent().smoothing) or (abs(new - self:GetParent().smoothing) < 2) then
				self:GetParent():SetValue_ORI(self:GetParent().smoothing)
				self:GetParent().smoothing = nil
			end
		end
	end)
	powerFrame.smoother:Show()
end

function ClassMods.RemoveSmooth(powerFrame)
	if not powerFrame.SetValue_ORI then return end
	powerFrame.smoother:Hide()
	powerFrame.smoother:SetScript("OnUpdate", nil)
	powerFrame.smoother:SetParent(nil)
	powerFrame.SetValue = powerFrame.SetValue_ORI
	powerFrame.SetValue_ORI = nil
end

--
-- Frame functions
--
function ClassMods.GetFrameOffset(frame, side, absolute)
	if (not frame) or (not frame.gapOffsets) then return(0) end
	if (side == "TOP") then
		return frame.gapOffsets[3]
	elseif (side == "BOTTOM") then
		return absolute and frame.gapOffsets[4] or (-frame.gapOffsets[4])
	elseif (side == "LEFT") then
		return absolute and frame.gapOffsets[1] or (-frame.gapOffsets[1])
	elseif (side == "RIGHT") then
		return frame.gapOffsets[2]
	end
	return(0)
end

-- Basicly a wrapper for CreateFrame() that sets gapOffsets and allows a frame to be recycled.
function ClassMods.MakeFrame(recycle, ...)
	local frame = recycle or CreateFrame(...)
	if (frame.gapOffsets) then
		frame.gapOffsets[1] = 0; frame.gapOffsets[2] = 0; frame.gapOffsets[3] = 0; frame.gapOffsets[4] = 0 -- recycle
	else
		frame.gapOffsets = { 0, 0, 0, 0 } -- L, R, T, B
	end
	return frame
end

function ClassMods.MakeBackground(parent, d, pre, sizeOverrides, recycle)
	-- Allow for duplicate entries for multiple frame options by just adding in a preface to the options and specifying it upon creation
	local data
	if pre then
		data = {}
		local key,val
		for key,val in pairs(d) do
			-- Only copy items with the "pre" preface.
			if strsub(key, 1, #pre) == pre then
				data[strsub(key, #pre + 1)] = ClassMods.DeepCopy(d[key])				
			end
		end
	else
		data = d
	end

	-- Allow MakeBackdrop to always be called and set itself up only if needed
	if (parent == nil) or (data == nil) or ( (not data.enablebackdrop) and (not data.enableborder) ) then
		if (recycle) then
			recycle:Hide()
		end
		return recycle or nil
	end

	local background = recycle or CreateFrame("Frame", nil, parent)
	background:ClearAllPoints()
	background:SetFrameStrata("MEDIUM")
	background:SetFrameLevel( ( (parent:GetFrameLevel() - 1) >= 0) and (parent:GetFrameLevel() - 1) or 0)

	if data.enablebackdrop and data.enableborder then -- Backdrop and border
		background:SetBackdrop({
			bgFile = ClassMods.GetActiveBackgroundFile(data.backdroptexture),
			tile = data.tile,
			tileSize = data.tile and data.tilesize or 0,
			edgeFile = ClassMods.GetActiveBorderFile(data.bordertexture),
			edgeSize = data.edgesize,
			insets = { left = data.backdropinsets[1], right = data.backdropinsets[2], top = data.backdropinsets[3], bottom = data.backdropinsets[4] }
		})
		background:SetPoint("TOPLEFT", -(data.edgesize) + data.backdropinsets[1] + (sizeOverrides and sizeOverrides[1] or 0), data.edgesize + data.backdropinsets[3] + (sizeOverrides and sizeOverrides[3] or 0) )
		background:SetPoint("BOTTOMRIGHT", data.edgesize + data.backdropinsets[2] + (sizeOverrides and sizeOverrides[2] or 0), -(data.edgesize) + data.backdropinsets[4] + (sizeOverrides and sizeOverrides[4] or 0) )
		parent.gapOffsets[1] = max(abs( (-(data.edgesize) ) + data.backdropinsets[1] + (sizeOverrides and sizeOverrides[1] or 0) ), ( (data.backdropoffsets[1] < 0) and abs(data.backdropoffsets[1] + (sizeOverrides and sizeOverrides[1] or 0)) or 0) ) -- LEFT
		parent.gapOffsets[2] = max(abs( ( (data.edgesize) ) + data.backdropinsets[2] + (sizeOverrides and sizeOverrides[2] or 0) ), ( (data.backdropoffsets[3] > 0) and abs(data.backdropoffsets[3] + (sizeOverrides and sizeOverrides[2] or 0)) or 0) ) -- RIGHT
		parent.gapOffsets[3] = max(abs( ( (data.edgesize) ) + data.backdropinsets[3] + (sizeOverrides and sizeOverrides[3] or 0) ), ( (data.backdropoffsets[2] > 0) and abs(data.backdropoffsets[2] + (sizeOverrides and sizeOverrides[3] or 0)) or 0) ) -- TOP
		parent.gapOffsets[4] = max(abs( (-(data.edgesize) ) + data.backdropinsets[4] + (sizeOverrides and sizeOverrides[4] or 0) ), ( (data.backdropoffsets[4] < 0) and abs(data.backdropoffsets[4] + (sizeOverrides and sizeOverrides[4] or 0) ) or 0) ) -- BOTTOM		
	elseif data.enablebackdrop then -- Backdrop only
		background:SetBackdrop({
			bgFile = ClassMods.GetActiveBackgroundFile(data.backdroptexture),
			tile = data.tile,
			tileSize = data.tile and data.tilesize or 0,
		})
		background:SetPoint("TOPLEFT", data.backdropoffsets[1] + (sizeOverrides and sizeOverrides[1] or 0), data.backdropoffsets[2] + (sizeOverrides and sizeOverrides[3] or 0) )
		background:SetPoint("BOTTOMRIGHT", data.backdropoffsets[3] + (sizeOverrides and sizeOverrides[2] or 0), data.backdropoffsets[4] + (sizeOverrides and sizeOverrides[4] or 0) )
		parent.gapOffsets[1] = ( (data.backdropoffsets[1] + (sizeOverrides and sizeOverrides[1] or 0) ) < 0) and abs(data.backdropoffsets[1] + (sizeOverrides and sizeOverrides[1] or 0) ) or 0 -- LEFT
		parent.gapOffsets[2] = ( (data.backdropoffsets[3] + (sizeOverrides and sizeOverrides[2] or 0) ) > 0) and abs(data.backdropoffsets[3] + (sizeOverrides and sizeOverrides[2] or 0) ) or 0 -- RIGHT
		parent.gapOffsets[3] = ( (data.backdropoffsets[2] + (sizeOverrides and sizeOverrides[3] or 0) ) > 0) and abs(data.backdropoffsets[2] + (sizeOverrides and sizeOverrides[3] or 0) ) or 0 -- TOP
		parent.gapOffsets[4] = ( (data.backdropoffsets[4] + (sizeOverrides and sizeOverrides[4] or 0) ) < 0) and abs(data.backdropoffsets[4] + (sizeOverrides and sizeOverrides[4] or 0) ) or 0 -- BOTTOM		
	else -- Border only
		background:SetBackdrop({
			edgeFile = ClassMods.GetActiveBorderFile(data.bordertexture),
			edgeSize = tonumber(data.edgesize),
			insets = { left = data.backdropinsets[1], right = data.backdropinsets[2], top = data.backdropinsets[3], bottom = data.backdropinsets[4] }
		})
		background:SetPoint("TOPLEFT", -(data.edgesize) + data.backdropinsets[1] + (sizeOverrides and sizeOverrides[1] or 0), data.edgesize + data.backdropinsets[3] + (sizeOverrides and sizeOverrides[3] or 0) )
		background:SetPoint("BOTTOMRIGHT", data.edgesize + data.backdropinsets[2] + (sizeOverrides and sizeOverrides[2] or 0), -(data.edgesize) + data.backdropinsets[4] + (sizeOverrides and sizeOverrides[4] or 0) )
		parent.gapOffsets[1] = abs( (-(data.edgesize) ) + data.backdropinsets[1] + (sizeOverrides and sizeOverrides[1] or 0) ) -- LEFT
		parent.gapOffsets[2] = abs( ( (data.edgesize) ) + data.backdropinsets[2] + (sizeOverrides and sizeOverrides[2] or 0) ) -- RIGHT
		parent.gapOffsets[3] = abs( ( (data.edgesize) ) + data.backdropinsets[3] + (sizeOverrides and sizeOverrides[3] or 0) ) -- TOP
		parent.gapOffsets[4] = abs( (-(data.edgesize) ) + data.backdropinsets[4] + (sizeOverrides and sizeOverrides[4] or 0) ) -- BOTTOM
	end

	if data.enablebackdrop and data.colorbackdrop then 
		if background.backdrop then
			background.backdrop:SetBackdropColor(unpack(data.backdropcolor) )
		else
			background:SetBackdropColor(unpack(data.backdropcolor) )
		end
	end
	
	if data.enableborder then background:SetBackdropBorderColor(unpack(data.bordercolor) ) end
	
	background:Show()
	return background
end

--
-- Configuration
--

-- This is the reconfiguration function that gets called when ClassMods needs to be globally reconfigured.
function ClassMods.ReconfigureClassMods()
	local playerSpec = GetSpecialization()
	if (playerSpec) then
		if(not ClassMods.globalConfigs) then
			ClassMods.globalConfigs = {}
			return
		end
		local key,val
		for key,val in pairs(ClassMods.globalConfigs) do
			val()
		end
	end
	--collectgarbage("collect")
end

--	Registers a function that will be called when the addon needs to be globally reconfigured because settings may have changed.
function ClassMods.RegisterConfigFunction(name, func)
	if(not ClassMods.globalConfigs) then
		ClassMods.globalConfigs = {}
	end
	ClassMods.globalConfigs[name] = func -- example: <ClassMods.globalConfigs["MOD_RESOURCEBAR"] = ClassMods.SetupResourceBar> : SetupResourceBar is found in resourcebar.lua
end

--	Removes a registered configuration function from the chain.
function ClassMods.UnregisterConfigFunction(name)
	if(not ClassMods.globalConfigs) then
		ClassMods.globalConfigs = {}
		return
	end
	if(not tContains(ClassMods.globalConfigs, name)) then
		return
	end
	tremove(ClassMods.globalConfigs, name)
end

function ClassMods.getAuraIndex(unitName, spellName, filter)
	for i = 1, 40 do
		if UnitAura(unitName, i, filter) == spellName then
 			return i
 		end
 	end
	return false
end