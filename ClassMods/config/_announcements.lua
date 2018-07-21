--
--	ClassMods Options - announcements panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:CreateAnnouncements()
	local DB = _G.ClassMods.Options.DB
	-- Have to be sure someone does not try to create an announcement by the same name as a hard-coded key.  Probably will never happen, but people do dumb shit.
	local blacklist = { "intro", "movers", "icons", "cooldowns", "resourcebar", "announcements" }
	local k,v
	for k,v in pairs(ClassMods.newAnnouncementDefaults) do
		blacklist[#blacklist + 1] = k
	end
	for k,v in pairs(DB.announcements) do
		blacklist[#blacklist + 1] = k
	end

	-- table.sort does not work for named keys, so we need to sort it another way
	ClassMods.sortedKeysTable = {}
	for key,value in pairs(DB.announcements.announcements) do table.insert(ClassMods.sortedKeysTable, key) end
	table.sort(ClassMods.sortedKeysTable, function(a,b) return (strupper(a) < strupper(b) ) end)

	local announcementtable = {
		maintab = {
			order = 1,
			type = "group",
			name = L["Announcements"],
			args = {
				reset = {
					type = "execute",
					width = "half",
					order = 4,
					name = L["Reset"],
					desc = L["RESETANNOUNCE_DESC"],
					func = function(info)
						ClassMods.ConfirmActionDialog(L["RESETANNOUNCE_CONFIRM"],
							function()
								ClassMods.db.profile.announcements.announcements = {}
								for key,val in pairs(ClassMods.announcementDefaults) do
									ClassMods.db.profile.announcements.announcements[key] = ClassMods.DeepCopy(ClassMods.announcementDefaults[key])
								end
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								ClassMods.Options:LockDown(ClassMods.SetupAnnouncements)
							end,
						nil)
					end,
				},
				newannouncement = {
					order = 10,
					type = "group",
					name = L["Create an Announcement"],
					guiInline = true,
					args = {
						newannouncement = {
							order = 10,
							type = 'input',
							name = L["What do you want to call this announcement?"],
							width = "full",
							confirm = function(info, value)
									return( ((strtrim(value) == "") or tContains(blacklist, value) or (DB.announcements.announcements[value] ~= nil) ) and false or format(L["CONFIRM_NEWANNOUNCEMENT"], value) )
								end,
							get = function(info) return("") end,
							set = function(info, value)
								value = strtrim(value)
								if (value == "") or tContains(blacklist, value) then
									print(L["CLASSMODS_PRE"]..format(L["Invalid announcement name!"], value) )
									return
								elseif DB.announcements.announcements[value] ~= nil then
									print(L["CLASSMODS_PRE"]..format(L["You already have an announcement with that name!"], value) )
									return
								end
								local announcement = {}
								-- Announcement defaults
								announcement = ClassMods.DeepCopy(ClassMods.newAnnouncementDefaults)
								-- Frame styling defaults
								DB.announcements.announcements[value] = announcement

								-- Re-Inject the new announcement
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")

								print(L["CLASSMODS_PRE"]..format(L["New announcement '%s' created."], value) )
							end,
						},
					},
				},
				spacer12 = { order = 12, type = "description", name = " ", desc = "", width = "full", hidden = function(info) return not ( (ClassMods.sortedKeysTable == nil) or (#ClassMods.sortedKeysTable > 0) ) end },
				interrupt = {
					order = 14,
					type = "group",
					name = L["Interrupt Announce"],
					guiInline = true,
					inline = true,
					args = {
						enabled = {
							type = "toggle",
							order = 1,
							name = L["Enable"],
							desc = L["ANNOUNCEMENTDESC_ENABLE"],
							width = "double",
							get = function(info) return DB.announcements.interrupt.enabled end,
							set = function(info, value) DB.announcements.interrupt.enabled = value;ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
						showsettings2 = {
							type = "execute",
							order = 2,
							name = L["Expand"],
							func = function(info) ClassMods.Options:CollapseAll(); DB.announcements.interrupt.showsettings2 = true end,
							hidden = function(info) return(DB.announcements.interrupt.showsettings2) end,
						},
						hidesettings2 = {
							type = "execute",
							order = 4,
							name = L["Collapse"],
							func = function(info) ClassMods.Options:CollapseAll()	end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
						},
						solochan = {
							order = 6,
							type = "select",
							name = L["Solo"],
							desc = L["SOLOCHANNEL_DESC"],
							disabled = function(info) return not DB.announcements.interrupt.enabled end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
							style = "dropdown",
							values = function() return(ClassMods.chatChannels) end,
							get = function(info) return(DB.announcements.interrupt[info[#info] ]) end,
							set = function(info, value) DB.announcements.interrupt[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
						partychan = {
							order = 8,
							type = "select",
							name = L["In a party"],
							desc = L["PARTYCHANNEL_DESC"],
							disabled = function(info) return not DB.announcements.interrupt.enabled end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
							style = "dropdown",
							values = function() return(ClassMods.chatChannels) end,
							get = function(info) return(DB.announcements.interrupt[info[#info] ]) end,
							set = function(info, value) DB.announcements.interrupt[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
						raidchan = {
							order = 10,
							type = "select",
							name = L["In a raid"],
							desc = L["RAIDCHANNEL_DESC"],
							disabled = function(info) return not DB.announcements.interrupt.enabled end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
							style = "dropdown",
							values = function() return(ClassMods.chatChannels) end,
							get = function(info) return(DB.announcements.interrupt[info[#info] ]) end,
							set = function(info, value) DB.announcements.interrupt[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
						arenachan = {
							order = 12,
							type = "select",
							name = L["In an arena"],
							desc = L["ARENACHANNEL_DESC"],
							disabled = function(info) return not DB.announcements.interrupt.enabled end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
							style = "dropdown",
							values = function() return(ClassMods.chatChannels) end,
							get = function(info) return(DB.announcements.interrupt[info[#info] ]) end,
							set = function(info, value) DB.announcements.interrupt[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
						pvpchan = {
							order = 14,
							type = "select",
							name = L["In a PvP zone"],
							desc = L["PVPCHANNEL_DESC"],
							disabled = function(info) return not DB.announcements.interrupt.enabled end,
							hidden = function(info) return(not DB.announcements.interrupt.showsettings2) end,
							style = "dropdown",
							values = function() return(ClassMods.chatChannels) end,
							get = function(info) return(DB.announcements.interrupt[info[#info] ]) end,
							set = function(info, value) DB.announcements.interrupt[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
						},
					},
				},
			},
		},
	}

	local ord = 50
	for key,value in ipairs(ClassMods.sortedKeysTable) do
		if (DB.announcements.announcements[value] ~= nil) then -- Technically, should never be nil!
			announcementtable.maintab.args[value] = {
				order = ord,
				type = "group",
				name = (ord-49).." - \""..value.."\"",
				guiInline = true,
				inline = true,
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["ANNOUNCEMENTDESC_ENABLE"],
						width = "double",
						get = function(info) return DB.announcements.announcements[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					showsettings2 = {
						type = "execute",
						order = 2,
						name = L["Expand"],
						func = function(info) ClassMods.Options:CollapseAll(); DB.announcements.announcements[info[#info-1] ].showsettings2 = true end,
						hidden = function(info) return(DB.announcements.announcements[info[#info-1] ].showsettings2) end,
					},
					hidesettings2 = {
						type = "execute",
						order = 4,
						name = L["Collapse"],
						func = function(info) ClassMods.Options:CollapseAll()	end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
					},
					announceend = {
						type = "toggle",
						order = 8,
						name = L["Announce End"],
						desc = L["ANNOUNCEEND_DESC"],
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						get = function(info) return DB.announcements.announcements[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					spellid = { -- Spell name or ID.
						order = 12,
						type = "input",
						name = L["Enter a Spell Name or ID..."],
						desc = L["SPELL_DESC"],
						width = "full",
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info)
							if (DB.announcements.announcements[info[#info-1] ].showsettings2) then
								return false
							end
							return true
						end,
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
						get = function(info) return(tonumber(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) and tostring(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) or DB.announcements.announcements[info[#info-1] ][info[#info] ] ) end,
						set = function(info, val)
							DB.announcements.announcements[info[#info-1] ][info[#info] ]  = (tonumber(val) and tonumber(val) or tonumber(val.match(val, "spell:(%d+)")) or val)
							LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
							collectgarbage("collect")
							ClassMods.Options:LockDown(ClassMods.SetupAnnouncements)
						end,
					},
					solochan = {
						order = 14,
						type = "select",
						name = L["Solo"],
						desc = L["SOLOCHANNEL_DESC"],
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						style = "dropdown",
						values = function() return(ClassMods.chatChannels) end,
						get = function(info) return(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					partychan = {
						order = 16,
						type = "select",
						name = L["In a party"],
						desc = L["PARTYCHANNEL_DESC"],
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						style = "dropdown",
						values = function() return(ClassMods.chatChannels) end,
						get = function(info) return(DB.announcements.announcements[info[#info-1] ][info[#info] ]) end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					raidchan = {
						order = 18,
						type = "select",
						name = L["In a raid"],
						desc = L["RAIDCHANNEL_DESC"],
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						style = "dropdown",
						values = function() return(ClassMods.chatChannels) end,
						get = function(info) return(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ]  = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					arenachan = {
						order = 20,
						type = "select",
						name = L["In an arena"],
						desc = L["ARENACHANNEL_DESC"],
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						style = "dropdown",
						values = function() return(ClassMods.chatChannels) end,
						get = function(info) return(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ]  = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					pvpchan = {
						order = 22,
						type = "select",
						name = L["In a PvP zone"],
						desc = L["PVPCHANNEL_DESC"],
						disabled = function(info) return not DB.announcements.announcements[info[#info-1] ].enabled end,
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						style = "dropdown",
						values = function() return(ClassMods.chatChannels) end,
						get = function(info) return(DB.announcements.announcements[info[#info-1] ][info[#info] ] ) end,
						set = function(info, value) DB.announcements.announcements[info[#info-1] ][info[#info] ]  = (value);ClassMods.Options:LockDown(ClassMods.SetupAnnouncements) end,
					},
					delete = {
						order = 38,
						type = "execute",
						name = L["Delete announcement"],
						hidden = function(info) return(not DB.announcements.announcements[info[#info-1] ].showsettings2) end,
						confirm = function(info) return(L["DELETEANNOUNCEMENT_CONFIRM"]) end,
						func = function(info)
							DB.announcements.announcements[info[#info-1] ] = nil
							LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
							ClassMods.Options:LockDown(ClassMods.SetupAnnouncements)
						end,
					},
				},
			}
			ord = ord + 1
		end
	end

	-- Show a message if there are no announcements in the set
	if (ord == 50) then
		announcementtable.maintab.args.noannouncements = {
			order = ord,
			type = "group",
			name = " ",
			guiInline = true,
			hidden = function(info) return ( (ClassMods.sortedKeysTable == nil) or (#ClassMods.sortedKeysTable > 0) ) end,
			args = {
				noannouncements = {
					order = 18,
					type = "description",
					name = "|cffff0000"..L["You do not have any announcements set."].."|r",
					fontSize = "large",
				},
			},
		}
	end

	return announcementtable
end