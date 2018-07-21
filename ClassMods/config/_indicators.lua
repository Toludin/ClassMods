--
--	ClassMods Options - indicator panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:CreateIndicators()
	local DB = _G.ClassMods.Options.DB
	-- Have to be sure someone does not try to create an indicator by the same name as a hard-coded key.  Probably will never happen, but people do dumb shit.
	local indicatortableblacklist = { "intro", "movers", "icons", "cooldowns", "resourcebar", "indicators" }
	local k,v
	for k,v in pairs(ClassMods.newIndicatorDefaults) do
		indicatortableblacklist[#indicatortableblacklist + 1] = k
	end
	for k,v in pairs(DB.indicators) do
		indicatortableblacklist[#indicatortableblacklist + 1] = k
	end

	-- table.sort does not work for named keys, so we need to sort it another way
	ClassMods.sortedKeysTable = {}
	for key,value in pairs(DB.indicators.indicators) do table.insert(ClassMods.sortedKeysTable, key) end
	table.sort(ClassMods.sortedKeysTable, function(a,b) return (strupper(a) < strupper(b) ) end)

	local indicatorstable = {
		maintab = {
			order = 1,
			type = "group",
			name = L["Indicators"],
			args = {
				updateinterval = {
					type = "range",
					order = 2,
					name = L["Set update interval"],
					desc = L["CLASSMODSUPDATEINTERVAL_DESC"],
					isPercent = false,
					disabled = function(info) return (DB.overrideinterval) end,
					min = 0.01, max = 1, step = 0.01,
					get = function(info) return(DB.indicators[info[#info] ]) end,
					set = function(info, size) DB.indicators[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				newindicator = {
					order = 10,
					type = "group",
					name = L["Create an Indicator"],
					guiInline = true,
					args = {
						newindicator = {
							order = 10,
							type = 'input',
							name = L["What do you want to call this indicator?"],
							width = "full",
							confirm = function(info, value)
								return( ((strtrim(value) == "") or tContains(indicatortableblacklist, value) or (DB.indicators.indicators[value] ~= nil) ) and false or format(L["CONFIRM_NEWINDICATOR"], value) )
							end,
							get = function(info) return("") end,
							set = function(info, value)
								value = strtrim(value)
								if (value == "") or tContains(indicatortableblacklist, value) then
									print(L["CLASSMODS_PRE"]..format(L["Invalid indicator name!"], value) )
									return
								elseif DB.indicators.indicators[value] ~= nil then
									print(L["CLASSMODS_PRE"]..format(L["You already have an indicator with that name!"], value) )
									return
								else
									if (value.match(value, "%[(%w+)%]")) then
										value = (value.match(value, "%[(%w+)%]"))
									end
								end
								local indicator = {}
								-- Alert defaults
								indicator = ClassMods.DeepCopy(ClassMods.newIndicatorDefaults)
								-- Frame styling defaults
								DB.indicators.indicators[value] = indicator

								-- Re-Inject the new indicator
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")

								print(L["CLASSMODS_PRE"]..format(L["New indicator '%s' created."], value) )
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
					get = function(info) return (DB.indicators.icons[info[#info] ]) end,
					set = function(info, size) DB.indicators.icons[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
					get = function(info) return DB.indicators.icons[info[#info-1] ][1] end,
					set = function(info, font) DB.indicators.icons[info[#info-1] ][1] = font;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				stackfontcolor = {
					type = "color",
					order = 4,
					name = L["Stacks font color"],
					desc = L["Color used for the stacks font."],
					hasAlpha = false,
					get = function(info) return unpack(DB.indicators.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.indicators.icons[info[#info] ] = {r, g, b, 1};ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				size = {
					type = "range",
					order = 6,
					name = L["Font size"],
					min = 6, max = 40, step = 1,
					get = function(info) return (DB.indicators.icons[info[#info-1] ][2]) end,
					set = function(info, size) DB.indicators.icons[info[#info-1] ][2] = (size);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				flags = {
					type = "multiselect",
					order = 8,
					name = L["Font flags"],
					values = ClassMods.Options.fontFlagTable,
					get = function(info, key) return(tContains({strsplit(",", DB.indicators.icons[info[#info-1] ][3])}, key) and true or false) end,
					set = function(info, keyname, state) ClassMods.Options:SetupFontFlags(DB.indicators.icons[info[#info-1] ], keyname, state);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "full"},
				left = {
					type = "range",
					order = 14,
					name = L["Left"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.indicators.icons["enabletexcoords"] end,
					get = function(info) return (DB.indicators.icons[info[#info-1] ][1]) end,
					set = function(info, offset) DB.indicators.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				right = {
					type = "range",
					order = 16,
					name = L["Right"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.indicators.icons["enabletexcoords"] end,
					get = function(info) return (DB.indicators.icons[info[#info-1] ][2]) end,
					set = function(info, offset) DB.indicators.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				spacer18 = { order = 18, type = "description", name = " ", desc = "", width = "half" },
				top = {
					type = "range",
					order = 20,
					name = L["Top"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.indicators.icons["enabletexcoords"] end,
					get = function(info) return (DB.indicators.icons[info[#info-1] ][3]) end,
					set = function(info, offset) DB.indicators.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				bottom = {
					type = "range",
					order = 24,
					name = L["Bottom"],
					min = 0, max = 1, step = .01,
					disabled = function(info) return not DB.indicators.icons["enabletexcoords"] end,
					get = function(info) return (DB.indicators.icons[info[#info-1] ][4]) end,
					set = function(info, offset) DB.indicators.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				backdroptexture = {
					type = "select",
					width = "double",
					dialogControl = 'LSM30_Background',
					order = 6,
					name = L["Backdrop texture"],
					values = AceGUIWidgetLSMlists.background,
					disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				colorbackdrop = {
					type = "toggle",
					order = 8,
					name = L["Color the backdrop"],
					disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				backdropcolor = {
					type = "color",
					order = 14,
					name = L["Backdrop color"],
					hasAlpha = true,
					disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
					hidden = function(info) return not DB.indicators.icons.colorbackdrop end,
					get = function(info) return unpack(DB.indicators.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.indicators.icons[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				spacer16 = { order = 16, type = "description", name = " ", desc = "", width = "half", hidden = function(info) return not DB.indicators.icons.colorbackdrop end },
				tile = {
					type = "toggle",
					order = 25,
					name = L["Tile the backdrop"],
					disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				tilesize = {
					type = "range",
					order = 28,
					name = L["Tile size"],
					min = -100, softMin = -30, softMax = 30, max = 100, step = 1,
					disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
					hidden = function(info) return not DB.indicators.icons.tile end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
							disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][1]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						offsetY1 = {
							type = "range",
							order = 2,
							name = L["Top-left Y"],
							min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][2]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "half" },
						offsetX2 = {
							type = "range",
							order = 13,
							name = L["Bottom-right X"],
							min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][3]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						offsetY2 = {
							type = "range",
							order = 14,
							name = L["Bottom-right Y"],
							min = -50, softMin = -10, softMax = 0, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enablebackdrop"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][4]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				bordertexture = {
					type = "select",
					width = "double",
					dialogControl = 'LSM30_Border',
					order = 6,
					name = L["Border texture"],
					values = AceGUIWidgetLSMlists.border,
					disabled = function(info) return not DB.indicators.icons["enableborder"] end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				bordercolor = {
					type = "color",
					order = 8,
					name = L["Border color"],
					hasAlpha = true,
					disabled = function(info) return not DB.indicators.icons["enableborder"] end,
					get = function(info) return unpack(DB.indicators.icons[info[#info] ]) end,
					set = function(info, r, g, b, a) DB.indicators.icons[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
				},
				edgesize = {
					type = "range",
					order = 10,
					name = L["Edge size"],
					min = -100, softMin = -16, softMax = 16, max = 100, step = 1,
					disabled = function(info) return not DB.indicators.icons["enableborder"] end,
					get = function(info) return DB.indicators.icons[info[#info] ] end,
					set = function(info, value) DB.indicators.icons[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
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
							disabled = function(info) return not DB.indicators.icons["enableborder"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][1]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						right = {
							type = "range",
							order = 2,
							name = L["Right"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enableborder"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][2]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						spacer10 = { order = 10, type = "description", name = " ", desc = "", width = "half" },
						top = {
							type = "range",
							order = 13,
							name = L["Top"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enableborder"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][3]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
						bottom = {
							type = "range",
							order = 14,
							name = L["Bottom"],
							min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
							disabled = function(info) return not DB.indicators.icons["enableborder"] end,
							get = function(info) return (DB.indicators.icons[info[#info-1] ][4]) end,
							set = function(info, offset) DB.indicators.icons[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
						},
					},
				},
			},
		},
	}

	local ord = 50
	for key,value in ipairs(ClassMods.sortedKeysTable) do
		if (DB.indicators.indicators[value] ~= nil) then -- Technically, should never be nil!
			indicatorstable.maintab.args[value] = {
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
						desc = L["INDICATORDESC_ENABLE"],
						width = "double",
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
					},
					showsettings2 = {
						type = "execute",
						order = 2,
						name = L["Expand"],
						func = function(info) ClassMods.Options:CollapseAll(); DB.indicators.indicators[info[#info-1] ].showsettings2 = true end,
						hidden = function(info) return(DB.indicators.indicators[info[#info-1] ].showsettings2) end,
					},
					hidesettings2 = {
						type = "execute",
						order = 8,
						name = L["Collapse"],
						func = function(info) ClassMods.Options:CollapseAll()	end,
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
					},
					combat = {
						type = "toggle",
						order = 16,
						name = L["Only show in combat"],
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
					},
					missing = {
						type = "toggle",
						order = 16,
						name = L["Only show if missing"],
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
					},
					sparkles = {
						type = "toggle",
						order = 20,
						name = L["Add sparkles"],
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
					},
					indicatortype = {
						order = 24,
						type = "select",
						style = "dropdown",
						name = L["Indicator trigger"],
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						values = function() return ClassMods.indicatorTypes end,
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupAlerts) end,
					},
					target = { -- Target to check for the spell.
						order = 26,
						type = "select",
						name = L["Check target"],
						desc = L["CHECKTARGET_DESC"],
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						hidden = function(info)
							if (tContains({ "BUFF", "DEBUFF" }, DB.indicators.indicators[info[#info-1] ].indicatortype) and (DB.indicators.indicators[info[#info-1] ].showsettings2) ) then
								return false
							end
							return true
						end,
						style = "dropdown",
						values = function() return ClassMods.targets end,
						get = function(info) return DB.indicators.indicators[info[#info-1] ][info[#info] ] end,
						set = function(info, value) DB.indicators.indicators[info[#info-1] ][info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupIndicators) end,
					},
					aura = { -- Spell name or ID.
						order = 28,
						type = "input",
						name = L["Enter a Spell Name or ID..."],
						desc = L["SPELL_DESC"],
						width = "double",
						disabled = function(info) return not DB.indicators.indicators[info[#info-1] ].enabled end,
						hidden = function(info)
							if (tContains({ "BUFF", "DEBUFF" }, DB.indicators.indicators[info[#info-1] ].indicatortype) and (DB.indicators.indicators[info[#info-1] ].showsettings2) ) then
								return false
							end
							return true
						end,
						validate = function(info, val)
								-- return(spellLink.match(spellLink, "spell:(%d+)") )
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
						get = function(info) return(tonumber(DB.indicators.indicators[info[#info-1] ][info[#info] ]) and tostring(DB.indicators.indicators[info[#info-1] ][info[#info] ]) or DB.indicators.indicators[info[#info-1] ][info[#info] ]) end,
						set = function(info, val)
								DB.indicators.indicators[info[#info-1] ][info[#info] ] = (tonumber(val) and tonumber(val) or ClassMods.NameToSpellID(val) or tonumber(val.match(val, "spell:(%d+)")) or val)
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								collectgarbage("collect")
								ClassMods.Options:LockDown(ClassMods.SetupIndicators)
							end,
					},
					delete = {
						order = 34,
						type = "execute",
						name = L["Delete indicator"],
						hidden = function(info) return(not DB.indicators.indicators[info[#info-1] ].showsettings2) end,
						confirm = function(info) return(L["DELETEINDICATOR_CONFIRM"]) end,
						func = function(info)
								DB.indicators.indicators[info[#info-1] ] = nil
								LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
								ClassMods.Options:LockDown(ClassMods.SetupIndicators)
							end,
					},
				},
			}
			ord = ord + 1
		end
	end

	-- Show a message if there are no indicators in the set
	if (ord == 50) then
		indicatorstable.maintab.args.noindicators = {
			order = ord,
			type = "group",
			name = " ",
			guiInline = true,
			hidden = function(info) return ( (ClassMods.sortedKeysTable == nil) or (#ClassMods.sortedKeysTable > 0) ) end,
			args = {
				noindicators = {
					order = 18,
					type = "description",
					name = "|cffff0000"..L["You do not have any indicators set."].."|r",
					fontSize = "large",
				},
			},
		}
	end

	return indicatorstable
end