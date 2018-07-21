--
--	ClassMods Options - alerts panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:CreateAlerts()
	local DB = _G.ClassMods.Options.DB
	-- Have to be sure someone does not try to create an alert by the same name as a hard-coded key.  Probably will never happen, but people do dumb shit.
	local alertstableblacklist = { "intro", "movers", "icons", "cooldowns", "resourcebar", "alerts" }
	local k,v
	for k,v in pairs(ClassMods.newAlertDefaults) do
		alertstableblacklist[#alertstableblacklist + 1] = k
	end
	for k,v in pairs(DB.alerts) do
		alertstableblacklist[#alertstableblacklist + 1] = k
	end

	-- table.sort does not work for named keys, so we need to sort it another way
	ClassMods.sortedKeysTable = {}
	for key,value in pairs(DB.alerts.alerts) do table.insert(ClassMods.sortedKeysTable, key) end
	table.sort(ClassMods.sortedKeysTable, function(a,b) return (strupper(a) < strupper(b) ) end)

	local alertstable = {
		maintab = {
			order = 1,
			type = "group",
			name = L["Alerts"],
			args = {
				reset = {
					type = "execute",
					width = "half",
					order = 2,
					name = L["Reset"],
					desc = L["RESETALERTS_DESC"],
					func = function(info)
						ClassMods.ConfirmActionDialog(L["RESETALERTS_CONFIRM"],
							function()
								ClassMods.db.profile.alerts.alerts = {}
								for key,val in pairs(ClassMods.alertDefaults) do
									ClassMods.db.profile.alerts.alerts[key] = ClassMods.DeepCopy(ClassMods.alertDefaults[key])
								end
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								ClassMods.Options:LockDown(ClassMods.SetupAlerts)
							end,
						nil)
					end,
				},
				spacer3 = { order = 3, type = "description", name = " ", desc = "", width = "half"},
				updateinterval = {
					type = "range",
					order = 4,
					name = L["Set update interval"],
					isPercent = false,
					disabled = function(info) return (DB.overrideinterval) end,
					min = 0.01, max = 1, step = 0.01,
					get = function(info) return(DB.alerts[info[#info] ]) end,
					set = function(info, size) DB.alerts[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				newalert = {
					order = 10,
					type = "group",
					name = L["Create an Alert"],
					guiInline = true,
					args = {
						newalert = {
							order = 10,
							type = 'input',
							name = L["What do you want to call this alert?"],
							width = "full",
							confirm = function(info, value)
									return( ((strtrim(value) == "") or tContains(alertstableblacklist, value) or (DB.alerts.alerts[value] ~= nil) ) and false or format(L["CONFIRM_NEWALERT"], value) )
								end,
							get = function(info) return("") end,
							set = function(info, value)
								value = strtrim(value)
								if (value == "") or tContains(alertstableblacklist, value) then
									print(L["CLASSMODS_PRE"]..format(L["Invalid alert name!"], value) )
									return
								elseif DB.alerts.alerts[value] ~= nil then
									print(L["CLASSMODS_PRE"]..format(L["You already have an alert with that name!"], value) )
									return
								else
									if (value.match(value, "%[(%w+)%]")) then
										value = (value.match(value, "%[(%w+)%]"))
									end
								end
								local alert = {}
								-- Alert defaults
								alert = ClassMods.DeepCopy(ClassMods.newAlertDefaults)
								-- Frame styling defaults
								DB.alerts.alerts[value] = alert

								-- Re-Inject the new alert
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")

								print(L["CLASSMODS_PRE"]..format(L["New alert '%s' created."], value) )
							end,
						},
					},
				},
				spacer12 = { order = 12, type = "description", name = " ", desc = "", width = "full", hidden = function(info) return not ( (ClassMods.sortedKeysTable == nil) or (#ClassMods.sortedKeysTable > 0) ) end },
			},
		},
		sizes = {
			order = 4,
			type = "group",
			name = L["Size"],
			args = {
				spacer1 = { order = 1, type = "description", name = " ", desc = "", width = "full"},
				iconsize = {
					type = "range",
					order = 4,
					name = L["Icon size"],
					min = 10, max = 100, step = 1,
					get = function(info) return (DB.alerts.icons[info[#info] ]) end,
					set = function(info, size) DB.alerts.icons[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
			},
		},
		stackfont = {
			order = 6,
			type = "group",
			name = L["Stacks font"],
			args = {
				spacer1 = { order = 1, type = "description", name = " ", desc = "", width = "full"},
				font = {
					type = "select",
					width = "double",
					dialogControl = 'LSM30_Font',
					order = 2,
					name = L["Font face"],
					values = AceGUIWidgetLSMlists.font,
					get = function(info) return DB.alerts.icons[info[#info-1] ][1] end,
					set = function(info, font) DB.alerts.icons[info[#info-1] ][1] = font;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				stackfontcolor = {
					type = "color",
					order = 4,
					name = L["Stacks font color"],
					desc = L["Color used for the stacks font."],
					hasAlpha = false,
					get = function(info) return unpack(DB.alerts.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.alerts.icons[info[#info] ] = {r, g, b, 1};ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				size = {
					type = "range",
					order = 6,
					name = L["Font size"],
					min = 6, max = 40, step = 1,
					get = function(info) return (DB.alerts.icons[info[#info-1] ][2]) end,
					set = function(info, size) DB.alerts.icons[info[#info-1] ][2] = (size);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				flags = {
					type = "multiselect",
					order = 8,
					name = L["Font flags"],
					values = ClassMods.Options.fontFlagTable,
					get = function(info, key) return(tContains({strsplit(",", DB.alerts.icons[info[#info-1] ][3])}, key) and true or false) end,
					set = function(info, keyname, state) ClassMods.Options:SetupFontFlags(DB.alerts.icons[info[#info-1] ], keyname, state);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
			},
		},
		texcoords = {
			type = "group",
			order = 10,
			name = L["Texture coords"],
			args = {
				spacer1 = { order = 1, type = "description", name = " ", desc = "", width = "full"},
				enabletexcoords = {
					type = "toggle",
					order = 5,
					name = L["Enable"],
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "full"},
				left = {
					type = "range",
					order = 14,
					name = L["Left"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.alerts.icons["enabletexcoords"] end,
					get = function(info) return (DB.alerts.icons[info[#info-1] ][1]) end,
					set = function(info, offset) DB.alerts.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				right = {
					type = "range",
					order = 16,
					name = L["Right"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.alerts.icons["enabletexcoords"] end,
					get = function(info) return (DB.alerts.icons[info[#info-1] ][2]) end,
					set = function(info, offset) DB.alerts.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				spacer18 = { order = 18, type = "description", name = " ", desc = "", width = "half" },
				top = {
					type = "range",
					order = 20,
					name = L["Top"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.alerts.icons["enabletexcoords"] end,
					get = function(info) return (DB.alerts.icons[info[#info-1] ][3]) end,
					set = function(info, offset) DB.alerts.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				bottom = {
					type = "range",
					order = 24,
					name = L["Bottom"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.alerts.icons["enabletexcoords"] end,
					get = function(info) return (DB.alerts.icons[info[#info-1] ][4]) end,
					set = function(info, offset) DB.alerts.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
			},
		},
		backdrop = {
			type = "group",
			order = 14,
			name = L["Backdrop"],
			args = {
				spacer1 = { order = 1, type = "description", name = " ", desc = "", width = "full"},
				enablebackdrop = {
					type = "toggle",
					order = 4,
					name = L["Enable"],
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				backdroptexture = {
					type = "select",
					width = "double",
					dialogControl = 'LSM30_Background',
					order = 6,
					name = L["Backdrop texture"],
					values = AceGUIWidgetLSMlists.background,
					disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				colorbackdrop = {
					type = "toggle",
					order = 8,
					name = L["Color the backdrop"],
					disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				backdropcolor = {
					type = "color",
					order = 14,
					name = L["Backdrop color"],
					hasAlpha = true,
					disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
					hidden = function(info) return not DB.alerts.icons.colorbackdrop end,
					get = function(info) return unpack(DB.alerts.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.alerts.icons[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				spacer16 = { order = 16, type = "description", name = " ", desc = "", width = "half", hidden = function(info) return not DB.alerts.icons.colorbackdrop end },
				tile = {
					type = "toggle",
					order = 25,
					name = L["Tile the backdrop"],
					disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				tilesize = {
					type = "range",
					order = 28,
					name = L["Tile size"],
					min = -100, softMin = -30, softMax = 30, max = 100, step = 1,
					disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
					hidden = function(info) return not DB.alerts.icons.tile end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				spacer30 = { order = 30, type = "description", name = " ", desc = "", width = "full"},
				backdropoffsets = {
					type = "group",
					order = 34,
					name = L["Offsets"],
					guiInline = true,
					args = {
						offsetX1 = {
							type = "range",
							order = 1,
							name = L["Top-left X"],
							min = -50, softMin = -10, softMax = 0, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][1]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						offsetY1 = {
							type = "range",
							order = 2,
							name = L["Top-left Y"],
							min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][2]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "half" },
						offsetX2 = {
							type = "range",
							order = 13,
							name = L["Bottom-right X"],
							min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][3]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						offsetY2 = {
							type = "range",
							order = 14,
							name = L["Bottom-right Y"],
							min = -50, softMin = -10, softMax = 0, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enablebackdrop"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][4]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
					},
				},
			},
		},
		border = {
			type = "group",
			order = 18,
			name = L["Border"],
			args = {
				spacer1 = { order = 1, type = "description", name = " ", desc = "", width = "full"},
				enableborder = {
					type = "toggle",
					order = 4,
					name = L["Enable"],
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				bordertexture = {
					type = "select",
					width = "double",
					dialogControl = 'LSM30_Border',
					order = 6,
					name = L["Border texture"],
					values = AceGUIWidgetLSMlists.border,
					disabled = function(info) return not DB.alerts.icons["enableborder"] end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				bordercolor = {
					type = "color",
					order = 8,
					name = L["Border color"],
					hasAlpha = true,
					disabled = function(info) return not DB.alerts.icons["enableborder"] end,
					get = function(info) return unpack(DB.alerts.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.alerts.icons[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				edgesize = {
					type = "range",
					order = 10,
					name = L["Edge size"],
					min = -100, softMin = -16, softMax = 16, max = 100, step = 1,
					disabled = function(info) return not DB.alerts.icons["enableborder"] end,
					get = function(info) return DB.alerts.icons[info[#info] ] end,
					set = function(info, value) DB.alerts.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
				},
				spacer16 = { order = 16, type = "description", name = " ", desc = "", width = "full"},
				backdropinsets = {
					type = "group",
					order = 20,
					name = L["Insets"],
					guiInline = true,
					args = {
						left = {
							type = "range",
							order = 1,
							name = L["Left"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enableborder"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][1]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						right = {
							type = "range",
							order = 2,
							name = L["Right"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enableborder"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][2]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "half" },
						top = {
							type = "range",
							order = 13,
							name = L["Top"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enableborder"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][3]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
						bottom = {
							type = "range",
							order = 14,
							name = L["Bottom"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.alerts.icons["enableborder"] end,
							get = function(info) return (DB.alerts.icons[info[#info-1] ][4]) end,
							set = function(info, offset) DB.alerts.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
						},
					},
				},
			},
		},
	}

	local ord = 50
	for key,value in ipairs(ClassMods.sortedKeysTable) do
		if (DB.alerts.alerts[value] ~= nil) then -- Technically, should never be nil!
			alertstable.maintab.args[value] = {
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
						desc = L["ALERTDESC_ENABLE"],
						width = "double",
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					showsettings2 = {
						type = "execute",
						order = 2,
						name = L["Expand"],
						func = function(info) ClassMods.Options:CollapseAll(); DB.alerts.alerts[info[#info-1] ].showsettings2 = true end,
						hidden = function(info) return(DB.alerts.alerts[info[#info-1] ].showsettings2) end,
					},
					hidesettings2 = {
						type = "execute",
						order = 8,
						name = L["Collapse"],
						func = function(info) ClassMods.Options:CollapseAll()	end,
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
					},
					enablesound = {
						type = "toggle",
						order = 16,
						name = L["Sound"],
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.alerts.alerts[info[#info-1] ].enabled end,
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					sound = {
						type = "select",
						dialogControl = 'LSM30_Sound',
						order = 18,
						name = L["Sound"],
						values = AceGUIWidgetLSMlists.sound,
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
						disabled = function(info)
								if (not DB.alerts.alerts[info[#info-1] ].enabled) or (not DB.alerts.alerts[info[#info-1] ].enablesound) then
									return true
								end
								return false
							end,
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					sparkles = {
						type = "toggle",
						order = 20,
						name = L["Add sparkles"],
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.alerts.alerts[info[#info-1] ].enabled end,
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					alerttype = {
						order = 24,
						type = "select",
						style = "dropdown",
						name = L["Alert trigger"],
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
						values = function() return ClassMods.alertTypes end,
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					target = { -- Target to check for the spell.
						order = 26,
						type = "select",
						name = L["Check target"],
						desc = L["CHECKTARGET_DESC"],
						disabled = function(info) return not DB.alerts.alerts[info[#info-1] ].enabled end,
						hidden = function(info)
								if (tContains({ "BUFF", "DEBUFF", "CAST" }, DB.alerts.alerts[info[#info-1] ].alerttype) and (DB.alerts.alerts[info[#info-1] ].showsettings2) ) then
									return false
								end
								return true
							end,
						style = "dropdown",
						values = function() return ClassMods.targets end,
						get = function(info) return DB.alerts.alerts[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.alerts.alerts[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					aura = { -- Spell name or ID.
						order = 28,
						type = "input",
						name = L["Enter a Spell Name or ID..."],
						desc = L["SPELL_DESC"],
						width = "double",
						disabled = function(info) return not DB.alerts.alerts[info[#info-1] ].enabled end,
						hidden = function(info)
								if (tContains({ "BUFF", "DEBUFF", "CAST" }, DB.alerts.alerts[info[#info-1] ].alerttype) and (DB.alerts.alerts[info[#info-1] ].showsettings2) ) then
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
						get = function(info) return(tonumber(DB.alerts.alerts[info[#info-1] ][info[#info] ]) and tostring(DB.alerts.alerts[info[#info-1] ][info[#info] ]) or DB.alerts.alerts[info[#info-1] ][info[#info] ]) end,
						set = function(info, val)
								DB.alerts.alerts[info[#info-1] ][info[#info] ] = (tonumber(val) and tonumber(val) or tonumber(val.match(val, "spell:(%d+)")) or val)
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								collectgarbage("collect")
								ClassMods.Options:LockDown(ClassMods.SetupAlerts)
							end,
					},
					healthpercent = {
						type = "range",
						order = 30,
						name = L["Health %"],
						desc = L["ALERTHEALTHPERCENT_DESC"],
						disabled = function(info) return not DB.alerts.alerts[info[#info-1] ].enabled end,
						hidden = function(info)
								if (tContains({ "HEALTH", "PETHEALTH" }, DB.alerts.alerts[info[#info-1] ].alerttype) and (DB.alerts.alerts[info[#info-1] ].showsettings2) ) then
									return false
								end
								return true
							end,
						isPercent = true,
						min = .05, max = 1, step = .05,
						get = function(info) return(DB.alerts.alerts[info[#info-1] ][info[#info] ]) end,
						set = function(info, health) DB.alerts.alerts[info[#info-1] ][info[#info] ] = (health);ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					delete = {
						order = 34,
						type = "execute",
						name = L["Delete alert"],
						hidden = function(info) return(not DB.alerts.alerts[info[#info-1] ].showsettings2) end,
						confirm = function(info) return(L["DELETEALERT_CONFIRM"]) end,
						func = function(info)
								DB.alerts.alerts[info[#info-1] ] = nil
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								ClassMods.Options:LockDown(ClassMods.SetupAlerts)
							end,
					},
				},
			}
			ord = ord + 1
		end
	end

	-- Show a message if there are no alerts in the set
	if (ord == 50) then
		alertstable.maintab.args.noalerts = {
			order = ord,
			type = "group",
			name = " ",
			guiInline = true,
			hidden = function(info) return ( (ClassMods.sortedKeysTable == nil) or (#ClassMods.sortedKeysTable > 0) ) end,
			args = {
				noalerts = {
					order = 18,
					type = "description",
					name = "|cffff0000"..L["You do not have any alerts set."].."|r",
					fontSize = "large",
				},
			},
		}
	end

	return alertstable
end