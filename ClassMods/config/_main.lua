--
--	ClassMods Options - main panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:Panel_Main(ord)
	local DB = _G.ClassMods.Options.DB
	return {
		order = ord,
		type = "group",
		name = L["General Settings"],
		args = {
			intro = {
				order = 2,
				type = "description",
				fontSize = "medium",
				name = L["CLASSMODS"] .. " " .. ClassMods.myVersionRaw .. ": " .. L["Official Support:"] .. " |cffabd473http://jshbclassmods.proboards.com/|r\n\n" .. L["OPTIONSINTRO"] .. "\n\n" .. L["MOVEFRAMES"],
			},
			spacer4 = { order=4, type="description", name=" ", desc=" ", width="full"},
			framelock = {
				type = "execute",
				order = 8,
				name = L["Move Frames"],
				func = function(info) ClassMods.ToggleMoversLock() end,
			},
			spacer10 = { order=10, type="description", name=" ", desc="", width="full"},
			enableaudio = {
				type = "toggle",
				order = 14,
				name = L["Enable audio"],
				get = function(info) return DB[info[#info] ] end,
				set = function(info, value) DB[info[#info] ] = value end,
			},
			masteraudio = {
				type = "toggle",
				order = 14,
				name = L["Master audio"],
				desc = L["MASTERAUDIO_DESC"],
				hidden = function(info) return not DB["enableaudio"] end,
				get = function(info) return DB[info[#info] ] end,
				set = function(info, value) DB[info[#info] ] = value end,
			},
			minimapbutton = {
				type = "toggle",
				order = 16,
				name = L["MINIMAP_BUTTON_SHOW"],
				width = "full",
				get = function(info) return DB[info[#info] ] end,
				set = function(info, value) DB[info[#info] ] = value;ClassMods.SetMinimapButton( (value == true) and true or false) end,
			},
			overrideinterval = {
				type = "toggle",
				order = 18,
				name = L["Override update interval"],
				get = function(info) return DB[info[#info] ] end,
				set = function(info, value) DB[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.ReconfigureClassMods) end,
			},
			updateinterval = {
				type = "range",
				order = 20,
				name = L["Set update interval"],
				desc = L["CLASSMODSUPDATEINTERVAL_DESC"],
				hidden = function(info) return(not DB.overrideinterval) end,
				isPercent = false,
				min = 0.01, max = 1, step = 0.01,
				get = function(info) return(DB[info[#info] ]) end,
				set = function(info, size) DB[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.ReconfigureClassMods) end,
			},
		},
	}
end