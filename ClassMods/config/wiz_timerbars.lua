--
-- ClassMods - timers wizard
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

-- constants
local panelWidth = 500 -- not resizable
local panelHeight = 500 -- resizable by user
local elementWidth = 464

local AceGUI = nil
local wizFrame = nil
local wizPanel = 0
local TimerBars_CreateFrame = {}
local DoPanel0 = {}

--[[ ACEGUI prototype for priority re-ordering ]]--
local function ClassMods_PriorityLine_ButtonUp_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	frame:GetParent().obj:Fire("OnClick", ..., "UP", tonumber(frame:GetParent().obj.index:GetText() ) )
end

local function ClassMods_PriorityLine_ButtonDn_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	frame:GetParent().obj:Fire("OnClick", ..., "DN", tonumber(frame:GetParent().obj.index:GetText() ) )
end

local function ClassMods_PriorityLine_Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function ClassMods_PriorityLine_Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function ClassMods_PriorityLineConstructor()
	local frame = CreateFrame("Frame", "ClassMods_PriorityLine" .. AceGUI:GetNextWidgetNum("ClassMods_PriorityLine"), UIParent)
	frame:Hide()

	local btnup = CreateFrame("Button", nil, frame)
	btnup:SetWidth(24)
	btnup:SetHeight(24)
	btnup:SetPoint("LEFT", frame, "LEFT", 6, 0)
	btnup:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Up")
	btnup:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Down")
	
	local btndn = CreateFrame("Button", nil, frame)
	btndn:SetWidth(24)
	btndn:SetHeight(24)
	btndn:SetPoint("LEFT", btnup, "RIGHT")
	btndn:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Up")
	btndn:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Down")
	
	local index = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	index:SetWidth(36)
	index:SetFontObject("GameFontNormal")
	local f1, f2, f3 = index:GetFont()
	index:SetFont(f1, f2+1, "THICKOUTLINE")
	index:SetPoint("LEFT", btndn, "RIGHT", 6, 0)
	index:SetJustifyH("RIGHT")
	index:SetJustifyV("MIDDLE")
	index:SetVertexColor(1, 1, 1)
	
	local dash = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	dash:SetFontObject("GameFontNormal")
	dash:SetFont(f1, f2+1, "THICKOUTLINE")
	dash:SetPoint("LEFT", btndn, "RIGHT", 40, 0)
	dash:SetJustifyH("LEFT")
	dash:SetJustifyV("MIDDLE")
	dash:SetText("-")
	
	local frameicon = CreateFrame("Frame", nil, frame)
	frameicon:SetWidth(24)
	frameicon:SetHeight(24)
	frameicon:SetPoint("LEFT", dash, "RIGHT", 2, 0)
	local icon = frameicon:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints(frameicon)
	icon:SetTexture("Inter face\\CHATFRAME\\UI-ChatIcon-ScrollDown-Up")
	
	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	label:SetFontObject("GameFontNormal")
	label:SetFont(f1, f2+1, "THICKOUTLINE")
	label:SetPoint("LEFT", dash, "RIGHT", 28, 0)
	label:SetJustifyH("LEFT")
	label:SetJustifyV("MIDDLE")
	
	frame:EnableMouse(true)
	btnup:SetScript("OnClick", ClassMods_PriorityLine_ButtonUp_OnClick)
	btndn:SetScript("OnClick", ClassMods_PriorityLine_ButtonDn_OnClick)
	frame:SetScript("OnEnter", ClassMods_PriorityLine_Control_OnEnter)
	frame:SetScript("OnLeave", ClassMods_PriorityLine_Control_OnLeave)

	local widget = {
		index	= index,
		label 	= label,
		icon		= icon,
		btnup	= btnup,
		btndn	= btndn,
		frame 	= frame,
		type  	= "ClassMods_PriorityLine"
	}
	widget["OnAcquire"] = function(self) self:SetHeight(24); self:SetWidth(elementWidth); self:SetText() end
	widget["SetText"] 	= function(self, text) self.label:SetText((text or "") ) end
	widget["SetIcon"]	= function(self, texture) self.icon:SetTexture(texture) end
	widget["SetIndex"] 	= function(self, value, last)
			if (value == 1) then self.btnup:Hide() else self.btnup:Show() end
			if (value == last) then self.btndn:Hide() else self.btndn:Show() end
			self.index:SetText(value or "")
		end
	widget["SetUp"]		= function(self) end
	widget["SetDown"]	= function(self) end

	return AceGUI:RegisterAsWidget(widget)
end

local function AddLabel(container, textStr, oF1, oF2, oF3)
	local w = AceGUI:Create("Label")
	w:SetWidth(elementWidth)
	w:SetText(textStr)
	local f1, f2, f3 = w.label:GetFont()
	if oF1 or oF2 or oF3 then
		w:SetFont(oF1 or f1, oF2 or f2, oF3 or f3)
	end
	container:AddChild(w)
	return w
end

local function AddButton(container, textStr, callBackFunc, widthOverride)
	local w = AceGUI:Create("Button")
	w:SetWidth(widthOverride or elementWidth)
	w:SetText(textStr)
	w:SetCallback("OnClick", callBackFunc)
	container:AddChild(w)
	return w
end

local function SortImportList(listTable)
	table.sort(listTable, function(a,b)
		local aComp = (a[1] ~= nil) and (tonumber(a[1]) and (select(1, GetSpellInfo(a[1]) ) ) or a[1]) or (tonumber(a[2]) and (select(1, GetItemInfo(a[2]) ) ) or a[2])
		local bComp = (b[1] ~= nil) and (tonumber(b[1]) and (select(1, GetSpellInfo(b[1]) ) ) or b[1]) or (tonumber(b[2]) and (select(1, GetItemInfo(b[2]) ) ) or b[2])
		return(tostring(aComp) < tostring(bComp) )
	end)
end

local function DoPanel3(num)
	local DB = _G.ClassMods.Options.DB
	wizFrame = TimerBars_CreateFrame(num)
	wizPanel = 3
	
	-- Change priority help message
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, L["CHANGEPRIORITYMSG"], nil, 15)
	AddLabel(wizFrame, " ")
	
	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill") -- important!
	wizFrame:AddChild(scrollcontainer)
	
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)
	
	for i=1,#DB.timers["timerbar"..num].timers do
		local name, _, icon = nil, nil, nil
		if (DB.timers["timerbar"..num].timers[i][1]) then
			name, _, icon = GetSpellInfo(DB.timers["timerbar"..num].timers[i][1])
		else
			name, _, _, _, _, _, _, _, _, icon--[[texture]] = GetItemInfo(DB.timers["timerbar"..num].timers[i][2])
		end
		local w = AceGUI:Create("ClassMods_PriorityLine")
		w:SetText(name or L["Invalid Timer"])
		w:SetIndex(i, #DB.timers["timerbar"..num].timers)
		w:SetIcon(icon or "Interface\\ICONS\\INV_Misc_QuestionMark")
		w:SetCallback("OnClick",
			function(widget, ...)
				local oldPos = select(4, ...)
				local newPos = (select(3, ...) == "UP") and (oldPos - 1) or (oldPos + 1)
				DB.timers["timerbar"..num].timers[oldPos][19] = newPos
				DB.timers["timerbar"..num].timers[newPos][19] = oldPos
				ClassMods.Options:SortTimerList(num)	
				LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
				ClassMods.Options:LockDown(ClassMods.SetupTimers)
				DoPanel3(num)
			end)
		scroll:AddChild(w)
	end
end

local lastTab = nil
local function DoPanel2(num)
	local DB = _G.ClassMods.Options.DB
	local selectedImports = { timerbar1 = {}, timerbar2 = {}, timerbar3 = {} }
	
	local function ResetSelectedImports(whichTab)
		for i=1,#ClassMods.timerbarDefaults[whichTab] do
			selectedImports[whichTab][i] = false
		end
	end
	
	ResetSelectedImports("timerbar1")
	ResetSelectedImports("timerbar2")
	ResetSelectedImports("timerbar3")
	wizFrame = TimerBars_CreateFrame(num)
	wizPanel = 2
	
	-- What would you like to do? - label
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, L["Select timers from any tab then click the import button."], nil, 15)
	AddLabel(wizFrame, " ")
	
	-- Import button
	AddButton(wizFrame, L["Import all selected timers"], function()
			local count = 0
			local function ImportFromTab(whichTab, num)
				for i=1,#ClassMods.timerbarDefaults[whichTab] do
					if (selectedImports[whichTab][i] == true) then
						DB.timers["timerbar"..num].timers[#DB.timers["timerbar"..num].timers + 1] = ClassMods.DeepCopy(ClassMods.timerbarDefaults[whichTab][i])
						DB.timers["timerbar"..num].timers[#DB.timers["timerbar"..num].timers][19] = #DB.timers["timerbar"..num].timers
						count = count + 1
					end
				end
			end
			ImportFromTab("timerbar1", num)
			ImportFromTab("timerbar2", num)
			ImportFromTab("timerbar3", num)
			print(L["CLASSMODS_PRE"] .. ": " .. format(L["TIMERSIMPORTED"], tostring(count) ) )
			ClassMods.Options:LockDown(ClassMods.SetupTimers)
			DoPanel0(num) --return to prev panel!
		end, elementWidth / 2)
	
	-- Tab group
	local function DrawGroup(container, group)
		local scrollcontainer = AceGUI:Create("SimpleGroup")
		scrollcontainer:SetFullWidth(true)
		scrollcontainer:SetFullHeight(true)
		scrollcontainer:SetLayout("Fill") -- important!
		container:AddChild(scrollcontainer)
		
		local scroll = AceGUI:Create("ScrollFrame")
		scroll:SetLayout("Flow")
		scrollcontainer:AddChild(scroll)

		local drawTab = (group == "C") and "timerbar1" or (group == "P") and "timerbar2" or (group == "T") and "timerbar3"
		
		SortImportList(ClassMods.timerbarDefaults[drawTab])
		for i=1,#ClassMods.timerbarDefaults[drawTab] do
			local cb = AceGUI:Create("CheckBox")
			local name, rank, icon = GetSpellInfo(ClassMods.timerbarDefaults[drawTab][i][1] or ClassMods.timerbarDefaults[drawTab][i][2])
			cb:SetLabel(name)
			cb:SetValue(selectedImports[drawTab][i])
			cb:SetCallback("OnValueChanged", function(widget) selectedImports[drawTab][i] = widget:GetValue() end)
			scroll:AddChild(cb)	
		end		
	end
	
	local function SelectGroup(container, event, group)
		lastTab = group
		container:ReleaseChildren()
		DrawGroup(container, group)
		wizFrame:SetStatusText((group == "C") and L["Cooldowns"] or  (group == "P") and L["Player"] or (group == "T") and L["Target"])
	end
	
	local tg = AceGUI:Create("TabGroup")
    tg:SetFullWidth(true)
	tg:SetFullHeight(true)
    tg:SetLayout("Fill")
	tg:SetTabs({
	    { value = "C", text = L["Cooldowns"] },
		{ value = "P", text = L["Player"] },
		{ value = "T", text = L["Target"] }
    })
	tg:SetCallback("OnGroupSelected", SelectGroup)
	tg:SelectTab(lastTab or "C")
	wizFrame:AddChild(tg)
end

local function DoPanel1(num)
	wizFrame = TimerBars_CreateFrame(num)
	wizPanel = 1
	
	-- What would you like to do? - label
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, L["Select how this bar's timers function:"], nil, 15)
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, " ")
	
	-- Change bar configuration - button
	AddButton(wizFrame, L["MOVE FROM BAR END TO BAR END BASED ON TIME"], function()
		ClassMods.db.profile.timers["timerbar"..num].stationary = false
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		print(L["CLASSMODS_PRE"] .. ": " .. L["TIMERBAR_SET_TO_MOVING"])
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		DoPanel0(num) --return to prev panel!
	end)
	AddLabel(wizFrame, " ")
	
	-- Change bar configuration - button
	AddButton(wizFrame, L["STATIONARY ICONS IN A ROW (CAN OPTIONALLY HIDE)"], function()
		ClassMods.db.profile.timers["timerbar"..num].stationary = true
		ClassMods.db.profile.timers["timerbar"..num].prioritize = false
		for i = 1, #ClassMods.db.profile.timers["timerbar"..num].timers do
			ClassMods.db.profile.timers["timerbar"..num].timers[i][18] = 0
		end
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		print(L["CLASSMODS_PRE"] .. ": " .. L["TIMERBAR_SET_TO_STATIONARY"])
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		DoPanel0(num) --return to prev panel!
	end)
	AddLabel(wizFrame, " ")
	
	-- Change bar configuration - button
	AddButton(wizFrame, L["NON-STATIONARY ICONS ARRANGED BASED ON TIME & PRIORITY"], function()
		ClassMods.db.profile.timers["timerbar"..num].stationary = true
		ClassMods.db.profile.timers["timerbar"..num].prioritize = true
		for i = 1, #ClassMods.db.profile.timers["timerbar"..num].timers do
			ClassMods.db.profile.timers["timerbar"..num].timers[i][18] = 0
		end
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		print(L["CLASSMODS_PRE"] .. ": " .. L["TIMERBAR_SET_TO_PRIORITY"])
		ClassMods.Options:LockDown(ClassMods.SetupTimers)
		DoPanel0(num) --return to prev panel!
	end)
	AddLabel(wizFrame, " ")
	
	-- Testing notice
	AddLabel(wizFrame, L["TEST_IN_ACTION"])
end

DoPanel0 = function(num)
	wizFrame = TimerBars_CreateFrame(num)
	wizPanel = 0
	
	-- What would you like to do? - label
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, L["What would you like to do?"], nil, 15)
	AddLabel(wizFrame, " ")
	AddLabel(wizFrame, " ")
	
	-- Change bar configuration - button
	AddButton(wizFrame, L["CHANGE HOW THIS BAR FUNCTIONS"], function() DoPanel1(num) end)
	AddLabel(wizFrame, " ")
	
	-- Import individual timers
	AddButton(wizFrame, L["IMPORT INDIVIDUAL TIMERS"], function() DoPanel2(num) end)
	AddLabel(wizFrame, " ")
	
	-- Set order for priority bar timers
	if _G.ClassMods.Options.DB.timers["timerbar"..num].stationary then
		if _G.ClassMods.Options.DB.timers["timerbar"..num].prioritize then
			AddButton(wizFrame, L["CHANGE PRIORITY ORDER OF TIMERS"], function() DoPanel3(num) end)
		else
			AddButton(wizFrame, L["CHANGE ORDER OF TIMERS"], function() DoPanel3(num) end)
		end
		AddLabel(wizFrame, " ")
	end
	
	-- Delete all current timers
	AddButton(wizFrame, L["DELETE ALL CURRENT TIMERS FOR THIS BAR"], function()
		ClassMods.ConfirmActionDialog(L["DELETEALLTIMERS_CONFIRM"],
		function()
			ClassMods.ClearTimersForSet(num)
			
			LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
			ClassMods.Options:LockDown(ClassMods.SetupTimers)
		end,
		nil)
	end)
	AddLabel(wizFrame, " ")
	
	-- Reset to default timers
	AddButton(wizFrame, L["REPLACE ALL CURRENT TIMERS WITH THE DEFAULTS"], function()
		ClassMods.ConfirmActionDialog(L["REVERTTIMERS_CONFIRM"],
		function()
			ClassMods.ImportDefaultTimersForSet(num)
			LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
			ClassMods.Options:LockDown(ClassMods.SetupTimers)
		end,
		nil)
	end)
end

local onCloseHandler = nil
local savedPoints = nil
TimerBars_CreateFrame = function(num)
	if not AceGUI then
		AceGUI = LibStub("AceGUI-3.0")
		AceGUI:RegisterWidgetType("ClassMods_PriorityLine", ClassMods_PriorityLineConstructor, 1)
	end
	if wizFrame then
		wizFrame:Release()
		collectgarbage("collect")
	end
	
	local f = AceGUI:Create("Frame")
	f.frame:SetClampedToScreen(true)
	if savedPoints then
		f.frame:ClearAllPoints()
		f.frame:SetPoint(unpack(savedPoints) )
	end
	f:SetTitle(L["TIMER BAR"].." "..num.. " "..L["WIZARD"])
	f:SetStatusText("")
	f:SetLayout("Flow")
	f:SetWidth(panelWidth)
	f:SetHeight(panelHeight)
	f:SetAutoAdjustHeight(true)
	-- Disable sizing
	f.sizer_e:Hide()
	f.sizer_se:Hide()
	
	-- We need to free memory from garbage created by Ace after closing the options panel
	onCloseHandler = f.events["OnClose"] or nil -- Ace hack
	f:SetCallback("OnClose", function(...)
		savedPoints = { f.frame:GetPoint() }
		if (wizPanel ~= 0) then
			DoPanel0(num)
			return
		else
			if (not LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"]) then
				ClassMods.OpenOptions()
			end
		end
		if onCloseHandler then
			onCloseHandler(...)
		end
		collectgarbage("collect")
	end)
	return f
end

function ClassMods.Wizard_TimerBars(num)
	if wizFrame and wizFrame.frame and wizFrame.frame:IsShown() then
		return
	end
	if LibStub("AceConfigDialog-3.0").OpenFrames["ClassMods"] then
		ClassMods.CloseOptions()
		GameTooltip:Hide() -- Prevents lingering tip from Wizard button
	end
	DoPanel0(num)
end
