--
-- ClassMods Options
--

ClassMods.Options = {}
ClassMods.Options.fontFlagTable = {}
local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:SetupFontFlags(db, keyname, state)
	local t = { strsplit(",", db[3]) }
	if tContains(t, keyname) and (state == false) then
		tremove(t, ClassMods.GetMatchTableValSimple(t, keyname, true) )
	elseif (not tContains(t, keyname) ) and (state == true) then
		t[#t+1] = keyname
	end
	db[3] = strtrim(strjoin(",", unpack(t) ),",")
end

function ClassMods.Options:LockDown(func)
	if (not ClassMods.moversLocked) then
		ClassMods.moversLocked = not ClassMods.moversLocked
		ClassMods.LockAllMovers()
	end
	func()
end

function ClassMods.Options:SetTimerSetCollapsed(which)
	for i=1,#which do
		which[i][21] = nil
	end
end

-- Collapse all expanded options areas
function ClassMods.Options:CollapseAll()
	local function recurseTree(tree)
		for k,v in pairs(tree) do
			if (type(v) == "table") then
				recurseTree(tree[k])
			elseif ( (k == "showsettings") or (k == "showsettings2") or (k == "showsettings3") ) then
				tree[k] = nil
			end
		end
	end
	-- This function sets all "showsettings" database entries to nil to collapse all expanded options areas
	recurseTree(_G.ClassMods.Options.DB)
	-- Also collapse the timer sets
	ClassMods.Options:SetTimerSetCollapsed(_G.ClassMods.Options.DB.timers.timerbar1.timers)
	ClassMods.Options:SetTimerSetCollapsed(_G.ClassMods.Options.DB.timers.timerbar2.timers)
	ClassMods.Options:SetTimerSetCollapsed(_G.ClassMods.Options.DB.timers.timerbar3.timers)
end

-- Timer table validation.  The table should be sorted properly already, if it is - this does nothing harmful
function ClassMods.Options:ReOrderTimerList(which)
	if not _G.ClassMods.Options.DB.timers["timerbar"..which].stationary then return end
	for i=1,#_G.ClassMods.Options.DB.timers["timerbar"..which].timers do
		_G.ClassMods.Options.DB.timers["timerbar"..which].timers[i][19] = i
	end
end

function ClassMods.Options:CheckTimerListOrder19(which)
	for i=1,#_G.ClassMods.Options.DB.timers["timerbar"..which].timers do
		if _G.ClassMods.Options.DB.timers["timerbar"..which].timers[i][19] == nil then
			ClassMods.Options:ReOrderTimerList(which)
			return
		end
	end
end

-- This is a sort function for timers in a set.  It only sorts, changes need to be notified and reconfigured separatly
function ClassMods.Options:SortTimerList(which)
	if _G.ClassMods.Options.DB.timers["timerbar"..which].stationary then
		ClassMods.Options:CheckTimerListOrder19(which)
		table.sort(_G.ClassMods.Options.DB.timers["timerbar"..which].timers, function(a,b) return(a[19] < b[19]) end)
		ClassMods.Options:ReOrderTimerList(which)
	else
		table.sort(_G.ClassMods.Options.DB.timers["timerbar"..which].timers, function(a,b)
			local aComp = (a[1] ~= nil) and (tonumber(a[1]) and (select(1, GetSpellInfo(a[1]) ) ) or a[1]) or (tonumber(a[2]) and (select(1, GetItemInfo(a[2]) ) ) or a[2])
			local bComp = (b[1] ~= nil) and (tonumber(b[1]) and (select(1, GetSpellInfo(b[1]) ) ) or b[1]) or (tonumber(b[2]) and (select(1, GetItemInfo(b[2]) ) ) or b[2])
			return(tostring(aComp) < tostring(bComp) )
		end)
	end
end

function ClassMods.Options:PopulateDB()
	ClassMods.Options.DB = _G.ClassMods.db.profile
	-- Sort timers
	ClassMods.Options:SortTimerList(1)
	ClassMods.Options:SortTimerList(2)
	ClassMods.Options:SortTimerList(3)
end

--
-- Setup Options
--
function ClassMods.Options:SetupOptions()
	local t = { handler = ClassMods, type = "group", name = "ClassMods " .. ClassMods.myVersion, guiInline = true, childGroups = "tree", args = {} }
	-- Core Option Modules
	t.args.main				= ClassMods.Options:Panel_Main(1)
	t.args.cooldown			= ClassMods.Options:Panel_Cooldown(2)
	t.args.resourcebar		= ClassMods.Options:Panel_ResourceBar(3)
	t.args.altresourcebar	= ClassMods.Options:Panel_AltResourceBar(4)
	t.args.healthbar			= ClassMods.Options:Panel_HealthBar(5)
	t.args.targetbar			= ClassMods.Options:Panel_TargetBar(6)
	t.args.dispel				= ClassMods.Options:Panel_Dispel(7)
	if ClassMods.enableCrowdControl then
		t.args.crowdcontrol	= { order = 7,	type = "group",	name = L["Crowd Control"], childGroups = "tab", args = ClassMods.Options:CreateCrowdControl() }
	end
	t.args.clicktocast		= ClassMods.Options:Panel_ClickToCast(8)
	if ClassMods.enableTotems then
		t.args.totemtimers	= { order=9, type="group", name=L["Totem Timers"], childGroups="tab", args=ClassMods.Options:CreateTotemTimers() }
	end
	t.args.timers1			= { order = 40,	type = "group",	name = L["Timer Bar 1"], childGroups = "tab", args = ClassMods.Options:CreateTimerSet(1) }
	t.args.timers2			= { order = 42,	type = "group",	name = L["Timer Bar 2"], childGroups = "tab", args = ClassMods.Options:CreateTimerSet(2) }
	t.args.timers3			= { order = 44,	type = "group",	name = L["Timer Bar 3"], childGroups = "tab", args = ClassMods.Options:CreateTimerSet(3) }
	t.args.alerts				= { order = 46,	type = "group",	name = L["Alerts"], childGroups = "tab", args = ClassMods.Options:CreateAlerts() }
	t.args.indicators			= { order = 47,	type = "group",	name = L["Indicators"], childGroups = "tab", args = ClassMods.Options:CreateIndicators() }
	t.args.announcement	= { order = 48,	type = "group",	name = L["Announcements"], childGroups = "tab", args = ClassMods.Options:CreateAnnouncements() }
	t.args.profile				= LibStub("AceDBOptions-3.0"):GetOptionsTable(ClassMods.db)
	t.args.profile.order		= 49
	return t
end

local optionsAreLoaded = nil

function ClassMods.Options.Initialize()

	if optionsAreLoaded then return end

	ClassMods.Options:PopulateDB() -- Populate the local DB upvalue variable
	ClassMods.Options:CollapseAll() -- Collapse all expanded option frames on load

	optionsAreLoaded = true -- Flag the options as being loaded

	-- Local tables for use in options
	ClassMods.Options.fontFlagTable = {}
	ClassMods.Options.fontFlagTable["OUTLINE"] = L["OUTLINE"]
	ClassMods.Options.fontFlagTable["THICKOUTLINE"] = L["THICKOUTLINE"]
	ClassMods.Options.fontFlagTable["MONOCHROME"] = L["MONOCHROME"]

	-- Setup the actual options panels
	local ACD3 = LibStub("AceConfigDialog-3.0")

	-- Register the options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ClassMods", ClassMods.Options.SetupOptions)

	local status = ACD3:GetStatusTable("ClassMods")
	status.width = 820
	status.height = 700

	ClassMods.SetMinimapButton((ClassMods.db.profile.minimapbutton == true) and true or nil)
end

-- Creates the mimimap button to open the options panel
-- Code primarily from DBM - credit's to them www.deadlybossmods.com
do
	local dragMode = nil
	local function moveButton(self)
		if dragMode == "free" then
			local centerX, centerY = Minimap:GetCenter()
			local x, y = GetCursorPosition()
			x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
			self:ClearAllPoints()
			self:SetPoint("CENTER", x, y)
		else
			local centerX, centerY = Minimap:GetCenter()
			local x, y = GetCursorPosition()
			x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
			centerX, centerY = math.abs(x), math.abs(y)
			centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2) ) * 80, (centerY / sqrt(centerX^2 + centerY^2) ) * 80
			centerX = (x < 0) and -centerX or centerX
			centerY = (y < 0) and -centerY or centerY
			self:ClearAllPoints()
			self:SetPoint("CENTER", centerX, centerY)
		end
	end

	local _, class = UnitClass("player")
	local button = CreateFrame("Button", "ClassModsMinimapButton", Minimap)
	button:SetSize(26, 26)
	button:SetFrameStrata("MEDIUM")
	button:SetPoint("CENTER", -25.0, -76.0)
	button:SetMovable(true)
	button:SetUserPlaced(true)
	button:SetNormalTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	button:GetNormalTexture():SetTexCoord(unpack(CLASS_ICON_TCOORDS[strupper(class)]))
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	
	button.border = button:CreateTexture(nil, "OVERLAY")
	button.border:SetTexture("Interface\\AddOns\\ClassMods\\media\\graphics\\ClassMods-MapButton-Border")
	button.border:SetTexCoord(0, 1, 0, 1)
	button.border:ClearAllPoints()
	button.border:SetAllPoints(button)	
	
	button:SetScript("OnMouseDown",
		function(self, button)
			if (button == "RightButton") then return end
			if IsShiftKeyDown() and IsAltKeyDown() then
				dragMode = "free"
				self:SetScript("OnUpdate", moveButton)
			elseif IsShiftKeyDown() then
				dragMode = nil
				self:SetScript("OnUpdate", moveButton)
			end
		end)

	button:SetScript("OnMouseUp",
		function(self, button)
			if (button == "RightButton") then
				if (GetMouseFocus():GetName() == "ClassModsMinimapButton") then
					ClassMods.ToggleMoversLock()
				end
			else
				self:SetScript("OnUpdate", nil)
			end
		end)

	button:SetScript("OnClick",
		function(self, button)
			if IsShiftKeyDown() then return end
			if LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"] then
				ClassMods.CloseOptions()
			else
				ClassMods.OpenOptions()
			end
		end)

	button:SetScript("OnEnter",
		function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
			GameTooltip:SetText("ClassMods " .. ClassMods.myVersion, RAID_CLASS_COLORS[select(2, UnitClass("player"))].r, RAID_CLASS_COLORS[select(2, UnitClass("player"))].g, RAID_CLASS_COLORS[select(2, UnitClass("player"))].b, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["MINIMAP_BUTTON_INFO"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:Show()
		end)

	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	function ClassMods.SetMinimapButton(state)
		if state then
			ClassMods.db.profile.minimapbutton = true
			button:Show()
		else
			ClassMods.db.profile.minimapbutton = false
			button:Hide()
		end
	end
end

local onCloseHandler = nil
local savedPoints = nil

function ClassMods.OpenOptions()
	if LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"] then return end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	LibStub("AceConfigDialog-3.0"):Open("ClassMods")
	local f = LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"]
	f.frame:SetClampedToScreen(true)
	f.frame:SetResizable(true)
	if savedPoints then
		f.frame:ClearAllPoints()
		f.frame:SetPoint(unpack(savedPoints) )
	end
	f.sizer_e:Hide()
	f.sizer_se:Hide()
	-- We need to free memory from garbage created by Ace after closing the options panel
	onCloseHandler = f.events["OnClose"] -- Ace hack
	f:SetCallback("OnClose",
		function(...)
			savedPoints = { f.frame:GetPoint() }
			collectgarbage("collect")
			onCloseHandler(...)
			collectgarbage("collect")
		end)
end

function ClassMods.CloseOptions()
	if LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"] then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		LibStub("AceConfigDialog-3.0"):Close("ClassMods")
		collectgarbage("collect")
	end
end