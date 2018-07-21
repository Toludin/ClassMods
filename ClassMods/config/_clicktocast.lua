--
--	ClassMods Options - clickcast panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:Panel_ClickToCast(ord)
	local DB = _G.ClassMods.Options.DB
	return {
		order = ord,
		type = "group",
		name = L["Click to Cast"],
		args = {
			spacer1 = { order = 1, type = "description", name = "", desc = "", width = "full" },
			enabled = {
				type = "toggle",
				order = 2,
				name = L["Enable Right-Click to cast"],
				width = "double",
				get = function(info) return DB.clicktocast.enabled end,
				set = function(info, value) ClassMods.Options:CollapseAll(); DB.clicktocast.enabled = value;ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			spell = { -- Spell name or ID.
				order = 4,
				type = "input",
				name = L["Enter a Spell Name or ID..."],
				desc = L["SPELL_DESC"],
				width = "double",
				disabled = function(info) return not DB.clicktocast.enabled end,
				validate = function(info, val)
					if GetSpellInfo(tonumber(val) and tonumber(val) or tonumber(val.match(val, "spell:(%d+)")) or val) then return(true) end
					if tonumber(val) then -- If it's a Spell ID number we CAN verify it.
						print(L["CLASSMODS_PRE"].."|cffff0000"..L["TIMERSPELL_INVALID"].."|r")
						return(false)
					end
					-- If it's not a Spell ID number we can only verify it if the player HAS that spell in his book.
					if not (GetSpellInfo(val) ) then -- Try to verify, if it does then we don't need to show the unverified warning.
						print(L["CLASSMODS_PRE"].."|cffff0000"..L["TIMERSPELL_UNVERIFIED"].."|r")
					end
					return(true)
				end,
				get = function(info) return(tonumber(DB.clicktocast[info[#info] ] ) and tostring(DB.clicktocast[info[#info] ] ) or DB.clicktocast[info[#info] ] ) end,
				set = function(info, val)
					DB.clicktocast[info[#info] ] = GetSpellInfo(tonumber(val) and tonumber(val) or tonumber(val.match(val, "spell:(%d+)")) or val)
					LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
					ClassMods.Options:LockDown(ClassMods.SetupClickToCast)
					collectgarbage("collect")
				end,
			},
			fTARGET = {
				type = "toggle",
				order = 6,
				name = L["Target Frame"],
				width = "double",
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fTOT = {
				type = "toggle",
				order = 8,
				name = L["Target of Target Frame"],
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fFOCUS = {
				type = "toggle",
				order = 10,
				name = L["Focus Target Frame"],
				width = "double",
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fPET = {
				type = "toggle",
				order = 12,
				name = L["Pet Frame"],
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fPARTY = {
				type = "toggle",
				order = 14,
				name = L["Party Frames"],
				width = "double",
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fPARTYPETS = {
				type = "toggle",
				order = 16,
				name = L["Party Pet Frames"],
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fRAID = {
				type = "toggle",
				order = 18,
				name = L["Raid Frames"],
				width = "double",
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			fRAIDPET = {
				type = "toggle",
				order = 20,
				name = L["Raid Pet Frames"],
				disabled = function(info) return (not DB.clicktocast.enabled) end,
				get = function(info) return(DB.clicktocast[info[#info] ]) end,
				set = function(info, value) DB.clicktocast[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupClickToCast) end,
			},
			note = {
				type = "description",
				order = 22,
				name = L["CLICKTOCASTNOTE"],
				desc = "",
				width = "full",
				hidden = function(info) return (not DB.clicktocast.enabled) end,
			},
		},
	}
end