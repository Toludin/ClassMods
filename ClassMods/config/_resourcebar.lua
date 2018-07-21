--
--	ClassMods Options - resource bar panel
--

local L = LibStub("AceLocale-3.0"):GetLocale("ClassMods")

function ClassMods.Options:Panel_ResourceBar(ord)
	local DB = _G.ClassMods.Options.DB
	local playerSpec = GetSpecialization()
	return {
		order = ord,
		type = "group",
		name = L["Resource Bar"],
		childGroups = "tab",
		args = {
			maintab = {
				order = 1,
				type = "group",
				name = L["Resource Bar"],
				args = {
					enabled = {
						type = "toggle",
						order = 2,
						name = L["Enable"],
						width = "double",
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) ClassMods.Options:CollapseAll(); DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					smoothbar = {
						type = "toggle",
						order = 6,
						name = L["Bar smoothing"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					resourcenumber = {
						type = "toggle",
						order = 7,
						name = L["Current resource number"],
						desc = L["RESOURCEBARNUMBERDESC_ENABLE"],
						width = "double",
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					abbreviatenumber = {
						type = "toggle",
						order = 8,
						name = L["Abbreviate number"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						hidden = function()
							if (UnitPowerType("player") ~= 0) then -- Mana
								return true
							else
								return false
							end
						end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					enableprediction = {
						type = "toggle",
						order = 9,
						name = L["Resource prediction"],
						hidden = function(info) return not ClassMods.enableprediction end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					targethealth = {
						type = "toggle",
						order = 10,
						name = L["Target health percentage"],
						width = "full",
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					autoattacktimer = {
						type = "toggle",
						order = 11,
						name = L["Numeric auto attack timer"],
						width = "full",
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					autoattackbar = {
						type = "toggle",
						order = 12,
						name = L["Auto attack bar"],
						desc = L["RESOURCEBARAUTOATTACKBARDESC_ENABLE"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					smoothbarautoattackbar = {
						type = "toggle",
						order = 14,
						name = L["Bar smoothing"],
						hidden = function(info) return not DB.resourcebar["autoattackbar"] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					autoattackbarcolor = {
						type = "color",
						order = 16,
						name = L["Auto attack bar color"],
						desc = L["Color of the bar showing auto attack timer."],
						hasAlpha = true,
						hidden = function(info) return not DB.resourcebar["autoattackbar"] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer17 = { order = 17, type = "description", name = " ", desc = "", width = "full"},
					updateinterval = {
						type = "range",
						order = 18,
						name = L["Set update interval"],
						desc = L["CLASSMODSUPDATEINTERVAL_DESC"],
						disabled = function(info) return (not DB.resourcebar["enabled"] or DB.overrideinterval) end,
						isPercent = false,
						min = 0.01, max = 1, step = 0.01,
						get = function(info) return(DB.resourcebar[info[#info] ]) end,
						set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					width = {
						type = "range",
						order = 22,
						name = L["Width"],
						min = 6, softMax = 600, max = 1000, step = 1,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					height = {
						type = "range",
						order = 26,
						name = L["Height"],
						min = 6, softMax = 600, max = 1000, step = 1,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer27 = { order = 27, type = "description", name = " ", desc = "", width = "full" },
					bartexture = {
						type = "select",
						width = "double",
						dialogControl = 'LSM30_Statusbar',
						order = 28,
						name = L["Texture"],
						values = AceGUIWidgetLSMlists.statusbar,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer30 = { order = 30, type = "description", name = " ", desc = "", width = "full" },
					barcolorenable = {
						type = "toggle",
						order = 32,
						name = L["Bar color"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					barcolor = {
						type = "color",
						order = 34,
						name = L["Color"],
						hasAlpha = true,
						hidden = function(info) return(not DB.resourcebar.barcolorenable) end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer35 = { order = 35, type = "description", name = " ", desc = "", width = "full" },
					lowwarn = {
						type = "toggle",
						order = 36,
						name = L["Low resource change"],
						desc = L["RESOURCEBARLOWWARNDESC_ENABLE"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					lowwarnthreshold = {
						type = "range",
						order = 38,
						name = L["Low warning number"],
						desc = L["RESOURCEBARLOWWARNTHRESHOLD_DESC"],
						hidden = function(info) return(not DB.resourcebar.lowwarn) end,
						disabled = function(info) return (not DB.resourcebar["enabled"]) end,
						isPercent = false,
						min = 1, max = UnitPowerMax("player", UnitPowerType("player")), step = 1,
						get = function(info) return(DB.resourcebar[info[#info] ]) end,
						set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					barcolorlow = {
						type = "color",
						order = 40,
						name = L["Low color"],
						desc = L["RESOURCEBARCOLORNORM_DESC"],
						hasAlpha = true,
						hidden = function(info) return(not DB.resourcebar.lowwarn) end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer38 = { order = 42, type = "description", name = " ", desc = "", width = "full" },
					highwarn = {
						type = "toggle",
						order = 44,
						name = L["High resource change"],
						desc = L["RESOURCEBARHIGHWARNDESC_ENABLE"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					highwarnthreshold = {
						type = "range",
						order = 48,
						name = L["High warning number"],
						desc = L["RESOURCEBARHIGHWARNTHRESHOLD_DESC"],
						hidden = function(info) return(not DB.resourcebar.highwarn) end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						isPercent = false,
						min = 1, max = UnitPowerMax("player", UnitPowerType("player")), step = 1,
						get = function(info) return(DB.resourcebar[info[#info] ]) end,
						set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					barcolorhigh = {
						type = "color",
						order = 50,
						name = L["High color"],
						desc = L["RESOURCEBARCOLORNORM_DESC"],
						hasAlpha = true,
						hidden = function(info) return(not DB.resourcebar.highwarn) end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
				},
			},
			alphastuff = {
				order = 6,
				type = "group",
				name = L["Bar alpha"],
				disabled = function(info) return not DB.resourcebar["enabled"] end,
				args = {
					activealpha = {
						type = "range",
						order = 24,
						name = L["Active alpha"],
						desc = L["RESOURCEBARACTIVEALPHA_DESC"],
						min = 0, max = 1, step = .1,
						isPercent = true,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					inactivealpha = {
						type = "range",
						order = 26,
						name = L["Inactive alpha"],
						desc = L["RESOURCEBARINACTIVEALPHA_DESC"],
						min = 0, max = 1, step = .1,
						isPercent = true,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer27 = { order = 27, type = "description", name = " ", desc = "", width = "full"},
					oocoverride = {
						type = "toggle",
						order = 28,
						name = L["OOC override"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					mountoverride = {
						type = "toggle",
						order = 32,
						name = L["Mounted override"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					deadoverride = {
						type = "toggle",
						order = 34,
						name = L["Dead override"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer36 = { order = 36, type = "description", name = " ", desc = "", width = "full"},
					oocoverridealpha = {
						type = "range",
						order = 38,
						name = L["OOC alpha"],
						min = 0, max = 1, step = .1,
						isPercent = true,
						disabled = function(info)
							if not DB.resourcebar["oocoverride"] then return true end
							if not DB.resourcebar["enabled"] then return true end
							return false end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					mountoverridealpha = {
						type = "range",
						order = 40,
						name = L["Mounted alpha"],
						min = 0, max = 1, step = .1,
						isPercent = true,
						disabled = function(info)
							if not DB.resourcebar["mountoverride"] then return true end
							if not DB.resourcebar["enabled"] then return true end
							return false end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					deadoverridealpha = {
						type = "range",
						order = 42,
						name = L["Dead alpha"],
						desc = L["RESOURCEBARDEADALPHA_DESC"],
						min = 0, max = 1, step = .1,
						isPercent = true,
						disabled = function(info)
							if not DB.resourcebar["deadoverride"] then return true end
							if not DB.resourcebar["enabled"] then return true end
							return false end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
				},
			},
			stackstuff = {
				order = 10,
				type = "group",
				name = L["Stacks"],
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
									ClassMods.db.profile.resourcebar.stacks = {}
									ClassMods.db.profile.resourcebar.activestack = ""
									for key,val in pairs(ClassMods.stacks) do
										ClassMods.db.profile.resourcebar.stacks[key] = ClassMods.DeepCopy(ClassMods.stacks[key])
									end
									LibStub("AceConfigRegistry-3.0"):NotifyChange("ClassMods")
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							nil)
						end,
					},
					spacer3 = { order = 3, type = "description", name = " ", desc = " ", width = "full"},
					enablestacks = {
						type = "toggle",
						width = "double",
						order = 4,
						name = L["Enable"],
						get = function(info) return DB.resourcebar.enablestacks end,
						set = function(info, value) DB.resourcebar.enablestacks = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					activestack = {
						order = 6,
						type = "select",
						name = L["Select active stack"],
						desc = L["RESOURCEBARSTACKSSELECT_DESC"],
						disabled = function(info) return (not DB.resourcebar["enablestacks"]) end,
						style = "dropdown",
						values = function()
							local t = {}
							if (not DB.resourcebar.stacks) then DB.resourcebar.stacks = ClassMods.stacks end
							for i=1,#ClassMods.stacks[playerSpec] do
								t[i] = GetSpellInfo(ClassMods.stacks[playerSpec][i][2])
								if(DB.resourcebar.stacks[playerSpec][i] and (DB.resourcebar.stacks[playerSpec][i][1] == true)) then
									DB.resourcebar.activestack = i
								end
							end
							return(t)
						end,
						get = function(info) return DB.resourcebar[info[#info]] end,
						set = function(info, value)
							local t = {}
							for i=1,#ClassMods.stacks[playerSpec] do
								t[i] = GetSpellInfo(ClassMods.stacks[playerSpec][i][2])
							end
							for i=1,#DB.resourcebar.stacks[playerSpec] do
								if GetSpellInfo(DB.resourcebar.stacks[playerSpec][i][2]) == t[value] then
									DB.resourcebar.stacks[playerSpec][i][1] = true
								else
									DB.resourcebar.stacks[playerSpec][i][1] = false
								end
							end
							DB.resourcebar.activestack = value
							ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
						end,
					},
					embedstacks = {
						type = "toggle",
						order = 8,
						name = L["Embed on bar"],
						desc = L["RESOURCEBARSTACKSEMBEDDESC_ENABLE"],
						disabled = function(info) return (not DB.resourcebar["enablestacks"]) end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					stacksreverse = {
						type = "toggle",
						order = 10,
						name = L["Reverse stacks"],
						desc = L["RESOURCEBARSTACKSREVERSEDESC_ENABLE"],
						disabled = function(info) return ( (not DB.resourcebar["enablestacks"]) or ( (DB.resourcebar["embedstacks"]) and (not DB.resourcebar["enabled"]) ) ) end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					stackscolor = {
						type = "color",
						order = 12,
						name = L["Stacks color"],
						hasAlpha = false,
						disabled = function(info) return ( (not DB.resourcebar["enablestacks"]) or ( (DB.resourcebar["embedstacks"]) and (not DB.resourcebar["enabled"]) ) ) end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					stackssize = {
						type = "range",
						order = 14,
						name = L["Stack size"],
						desc = L["RESOURCEBARSTACKSIZE_DESC"],
						min = 10, softMax = 100, max = 600, step = 1,
						disabled = function(info) return (DB.resourcebar["embedstacks"] or (not DB.resourcebar["enablestacks"]) ) end,
						get = function(info) return (DB.resourcebar[info[#info] ]) end,
						set = function(info, value) DB.resourcebar[info[#info] ] = (value);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
				},
			},
			ticks = {
				order = 14,
				type = "group",
				name = L["Tick marks"],
				disabled = function(info) return not DB.resourcebar["enabled"] end,
				hidden = function(info) return not ClassMods.enableticks end, -- If ticks are disabled for the class  then hide this entire option
				args = {
					tickstuff1 = {
						order = 24,
						type = "group",
						name = L["Tick Mark 1 (Main Spell)"],
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						guiInline = true,
						args = {
							enabled = {
								type = "toggle",
								order = 4,
								name = L["Enable"],
								desc = L["RESOURCEBARTICKDESC_ENABLE"],
								width = "full",
								get = function(info) return DB.resourcebar.ticks[playerSpec][1][1] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][1][1] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spell1 = {
								order = 6,
								type = "select",
								name = L["Select a spell"],
								disabled = function(info) return not DB.resourcebar["enabled"] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
								style = "dropdown",
								values = function()
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
										if (t[i] == select(1, GetSpellInfo(DB.resourcebar.ticks[playerSpec][1][2]))) then
											DB.resourcebar.spell1 = i
										end
									end
									return(t)
								end,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, value)
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
									end
									DB.resourcebar.ticks[playerSpec][1][2] = tonumber(ClassMods.NameToSpellID(t[value]))
									DB.resourcebar.spell1 = value
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							},
							spacer12 = { order = 12, type = "description", name = " ", desc = " ", width = "full"},
							colorbar = {
								type = "toggle",
								order = 14,
								name = L["Change bar color"],
								desc = L["TICKCOLOR_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][1][4] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][1][4] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							color = {
								type = "color",
								order = 18,
								name = L["Color"],
								desc = L["Color to change to."],
								disabled = function(info) return not DB.resourcebar.ticks[playerSpec][1][4] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar.ticks[playerSpec][1][5]) end,
								set = function(info, r, g, b, a) DB.resourcebar.ticks[playerSpec][1][5] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							useicon = {
								type = "toggle",
								order = 20,
								name = L["Use spell icon"],
								desc = L["TICKICON_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][1][7] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][1][7] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					tickstuff2 = {
						order = 26,
						type = "group",
						name = L["Tick Mark 2"],
						hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						guiInline = true,
						args = {
							enabled = {
								type = "toggle",
								order = 4,
								name = L["Enable"],
								desc = L["RESOURCEBARTICKDESC_ENABLE"],
								width = "full",
								get = function(info) return DB.resourcebar.ticks[playerSpec][2][1] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][2][1] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spell2 = {
								order = 6,
								type = "select",
								name = L["Select a spell"],
								disabled = function(info) return not DB.resourcebar["enabled"] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][2][1] end,
								style = "dropdown",
								values = function()
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
										if (t[i] == select(1, GetSpellInfo(DB.resourcebar.ticks[playerSpec][2][2]))) then
											DB.resourcebar.spell2 = i
										end
									end
									return(t)
								end,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, value)
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
									end
									DB.resourcebar.ticks[playerSpec][2][2] = tonumber(ClassMods.NameToSpellID(t[value]))
									DB.resourcebar.spell2 = value
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							},
							offset = {
								type = "toggle",
								order = 10,
								name = L["Offset from main spell"],
								desc = L["TICKOFFSET_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][2][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][2][3] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][2][3] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer12 = { order = 12, type = "description", name = " ", desc = " ", width = "full"},
							colorbar = {
								type = "toggle",
								order = 14,
								name = L["Change bar color"],
								desc = L["TICKCOLOR_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][2][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][2][4] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][2][4] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							color = {
								type = "color",
								order = 18,
								name = L["Color"],
								desc = L["Color to change to."],
								disabled = function(info) return not DB.resourcebar.ticks[playerSpec][2][4] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][2][1] end,
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar.ticks[playerSpec][2][5]) end,
								set = function(info, r, g, b, a) DB.resourcebar.ticks[playerSpec][2][5] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							useicon = {
								type = "toggle",
								order = 20,
								name = L["Use spell icon"],
								desc = L["TICKICON_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][2][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][2][7] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][2][7] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					tickstuff3 = {
						order = 29,
						type = "group",
						name = L["Tick Mark 3"],
						hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						guiInline = true,
						args = {
							enabled = {
								type = "toggle",
								order = 4,
								name = L["Enable"],
								desc = L["RESOURCEBARTICKDESC_ENABLE"],
								width = "full",
								get = function(info) return DB.resourcebar.ticks[playerSpec][3][1] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][3][1] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spell3 = {
								order = 6,
								type = "select",
								name = L["Select a spell"],
								disabled = function(info) return not DB.resourcebar["enabled"] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][3][1] end,
								style = "dropdown",
								values = function()
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
										if (t[i] == select(1, GetSpellInfo(DB.resourcebar.ticks[playerSpec][3][2]))) then
											DB.resourcebar.spell3 = i
										end
									end
									return(t)
								end,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, value)
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
									end
									DB.resourcebar.ticks[playerSpec][3][2] = tonumber(ClassMods.NameToSpellID(t[value]))
									DB.resourcebar.spell3 = value
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							},
							offset = {
								type = "toggle",
								order = 10,
								name = L["Offset from main spell"],
								desc = L["TICKOFFSET_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][3][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][3][3] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][3][3] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer12 = { order = 12, type = "description", name = " ", desc = " ", width = "full"},
							colorbar = {
								type = "toggle",
								order = 14,
								name = L["Change bar color"],
								desc = L["TICKCOLOR_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][3][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][3][4] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][3][4] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							color = {
								type = "color",
								order = 18,
								name = L["Color"],
								desc = L["Color to change to."],
								disabled = function(info) return not DB.resourcebar.ticks[playerSpec][3][4] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][3][1] end,
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar.ticks[playerSpec][3][5]) end,
								set = function(info, r, g, b, a) DB.resourcebar.ticks[playerSpec][3][5] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							useicon = {
								type = "toggle",
								order = 20,
								name = L["Use spell icon"],
								desc = L["TICKICON_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][3][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][3][7] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][3][7] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					tickstuff4 = {
						order = 32,
						type = "group",
						name = L["Tick Mark 4"],
						hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						guiInline = true,
						args = {
							enabled = {
								type = "toggle",
								order = 4,
								name = L["Enable"],
								desc = L["RESOURCEBARTICKDESC_ENABLE"],
								width = "full",
								get = function(info) return DB.resourcebar.ticks[playerSpec][4][1] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][4][1] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spell4 = {
								order = 6,
								type = "select",
								name = L["Select a spell"],
								disabled = function(info) return not DB.resourcebar["enabled"] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][4][1] end,
								style = "dropdown",
								values = function()
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
										if (t[i] == select(1, GetSpellInfo(DB.resourcebar.ticks[playerSpec][4][2]))) then
											DB.resourcebar.spell4 = i
										end
									end
									return(t)
								end,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, value)
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
									end
									DB.resourcebar.ticks[playerSpec][4][2] = tonumber(ClassMods.NameToSpellID(t[value]))
									DB.resourcebar.spell4 = value
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							},
							offset = {
								type = "toggle",
								order = 10,
								name = L["Offset from main spell"],
								desc = L["TICKOFFSET_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][4][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][4][3] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][4][3] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer12 = { order = 12, type = "description", name = " ", desc = " ", width = "full"},
							colorbar = {
								type = "toggle",
								order = 14,
								name = L["Change bar color"],
								desc = L["TICKCOLOR_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][4][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][4][4] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][4][4] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							color = {
								type = "color",
								order = 18,
								name = L["Color"],
								desc = L["Color to change to."],
								disabled = function(info) return not DB.resourcebar.ticks[playerSpec][4][4] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][4][1] end,
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar.ticks[playerSpec][4][5]) end,
								set = function(info, r, g, b, a) DB.resourcebar.ticks[playerSpec][4][5] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							useicon = {
								type = "toggle",
								order = 20,
								name = L["Use spell icon"],
								desc = L["TICKICON_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][4][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][4][7] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][4][7] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					tickstuff5 = {
						order = 35,
						type = "group",
						name = L["Tick Mark 5"],
						hidden = function(info) return not DB.resourcebar.ticks[playerSpec][1][1] end,
						disabled = function(info) return not DB.resourcebar["enabled"] end,
						guiInline = true,
						args = {
							enabled = {
								type = "toggle",
								order = 4,
								name = L["Enable"],
								desc = L["RESOURCEBARTICKDESC_ENABLE"],
								width = "full",
								get = function(info) return DB.resourcebar.ticks[playerSpec][5][1] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][5][1] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spell5 = {
								order = 6,
								type = "select",
								name = L["Select a spell"],
								disabled = function(info) return not DB.resourcebar["enabled"] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][5][1] end,
								style = "dropdown",
								values = function()
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
										if (t[i] == select(1, GetSpellInfo(DB.resourcebar.ticks[playerSpec][5][2]))) then
											DB.resourcebar.spell5 = i
										end
									end
									return(t)
								end,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, value)
									local t = {}
									for i=1,#ClassMods.classSpells[playerSpec] do
										t[i] = select(1,GetSpellInfo(ClassMods.classSpells[playerSpec][i][1]))
									end
									DB.resourcebar.ticks[playerSpec][5][2] = tonumber(ClassMods.NameToSpellID(t[value]))
									DB.resourcebar.spell5 = value
									ClassMods.Options:LockDown(ClassMods.SetupResourceBar)
								end,
							},
							offset = {
								type = "toggle",
								order = 10,
								name = L["Offset from main spell"],
								desc = L["TICKOFFSET_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][5][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][5][3] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][5][3] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer12 = { order = 12, type = "description", name = " ", desc = " ", width = "full"},
							colorbar = {
								type = "toggle",
								order = 14,
								name = L["Change bar color"],
								desc = L["TICKCOLOR_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][5][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][5][4] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][5][4] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							color = {
								type = "color",
								order = 18,
								name = L["Color"],
								desc = L["Color to change to."],
								disabled = function(info) return not DB.resourcebar.ticks[playerSpec][5][4] end,
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][5][1] end,
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar.ticks[playerSpec][5][5]) end,
								set = function(info, r, g, b, a) DB.resourcebar.ticks[playerSpec][5][5] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							useicon = {
								type = "toggle",
								order = 20,
								name = L["Use spell icon"],
								desc = L["TICKICON_DESC"],
								hidden = function(info) return not DB.resourcebar.ticks[playerSpec][5][1] end,
								get = function(info) return DB.resourcebar.ticks[playerSpec][5][7] end,
								set = function(info, value) DB.resourcebar.ticks[playerSpec][5][7] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
				},
			},
			fonts = {
				type = "group",
				order = 18,
				name = L["Fonts"],
				disabled = function(info) return not DB.resourcebar["enabled"] end,
				args = {
					resourcefont = {
						type = "group",
						order = 26,
						name = L["Resource font"],
						guiInline = true,
						args = {
							font = {
								type = "select",
								dialogControl = "LSM30_Font",
								order = 2,
								name = L["Font face"],
								width = "double",
								values = AceGUIWidgetLSMlists.font,
								get = function(info) return DB.resourcebar[info[#info-1] ][1] end,
								set = function(info, font) DB.resourcebar[info[#info-1] ][1] = font;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							resourcefontcolor = {
								type = "color",
								order = 4,
								name = L["Color"],
								desc = L["Color of the text showing your current resource."],
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
								set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							size = {
								type = "range",
								order = 6,
								name = L["Font size"],
								min = 6, max = 40, step = 1,
								get = function(info) return (DB.resourcebar[info[#info-1] ][2]) end,
								set = function(info, size) DB.resourcebar[info[#info-1] ][2] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							resourcefontoffset = {
								type = "range",
								order = 8,
								name = L["Font offset"],
								desc = L["DESC_FONTOFFSET"],
								min = -900, softMin = -100, softMax = 100, max = 900, step = 1,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							flags = {
								type = "multiselect",
								order = 10,
								name = L["Font flags"],
								values = ClassMods.Options.fontFlagTable,
								get = function(info, key) return(tContains({strsplit(",", DB.resourcebar[info[#info-1] ][3])}, key) and true or false) end,
								set = function(info, keyname, state) ClassMods.Options:SetupFontFlags(DB.resourcebar[info[#info-1] ], keyname, state);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					healthfont = {
						type = "group",
						order = 32,
						name = L["Target's health font"],
						guiInline = true,
						args = {
							font = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 2,
								name = L["Font face"],
								width = "double",
								values = AceGUIWidgetLSMlists.font,
								get = function(info) return DB.resourcebar[info[#info-1] ][1] end,
								set = function(info, font) DB.resourcebar[info[#info-1] ][1] = font;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer3 = { order=3, type="description", name=" ", desc="", width="half" },
							size = {
								type = "range",
								order = 4,
								name = L["Font size"],
								min = 6, max = 40, step = 1,
								get = function(info) return (DB.resourcebar[info[#info-1] ][2]) end,
								set = function(info, size) DB.resourcebar[info[#info-1] ][2] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							healthfontoffset = {
								type = "range",
								order = 6,
								name = L["Font offset"],
								desc = L["DESC_FONTOFFSET"],
								min = -900, softMin = -200, softMax = 200, max = 900, step = 1,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							flags = {
								type = "multiselect",
								order = 8,
								name = L["Font flags"],
								values = ClassMods.Options.fontFlagTable,
								get = function(info, key) return(tContains({strsplit(",", DB.resourcebar[info[#info-1] ][3])}, key) and true or false) end,
								set = function(info, keyname, state) ClassMods.Options:SetupFontFlags(DB.resourcebar[info[#info-1] ], keyname, state);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					autoattacktimerfont = {
						type = "group",
						order = 36,
						name = L["Auto attack timer font"],
						guiInline = true,
						args = {
							font = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 2,
								name = L["Font face"],
								width = "double",
								values = AceGUIWidgetLSMlists.font,
								get = function(info) return DB.resourcebar[info[#info-1] ][1] end,
								set = function(info, font) DB.resourcebar[info[#info-1] ][1] = font;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							autoattacktimerfontcolor = {
								type = "color",
								order = 4,
								name = L["Color"],
								desc = L["Color of the text showing auto attack timer."],
								hasAlpha = true,
								get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
								set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							size = {
								type = "range",
								order = 6,
								name = L["Font size"],
								min = 6, max = 40, step = 1,
								get = function(info) return (DB.resourcebar[info[#info-1] ][2]) end,
								set = function(info, size) DB.resourcebar[info[#info-1] ][2] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							autoattacktimerfontoffset = {
								type = "range",
								order = 8,
								name = L["Font offset"],
								desc = L["DESC_FONTOFFSET"],
								min = -900, softMin = -100, softMax = 100, max = 900, step = 1,
								get = function(info) return (DB.resourcebar[info[#info] ]) end,
								set = function(info, size) DB.resourcebar[info[#info] ] = (size);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							flags = {
								type = "multiselect",
								order = 10,
								name = L["Font flags"],
								values = ClassMods.Options.fontFlagTable,
								get = function(info, key) return(tContains({strsplit(",", DB.resourcebar[info[#info-1] ][3])}, key) and true or false) end,
								set = function(info, keyname, state) ClassMods.Options:SetupFontFlags(DB.resourcebar[info[#info-1] ], keyname, state);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
				},
			},
			backdrop = {
				type = "group",
				order = 22,
				name = L["Backdrop"],
				disabled = function(info) return not DB.resourcebar["enabled"] end,
				args = {
					enablebackdrop = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					backdroptexture = {
						type = "select",
						width = "double",
						dialogControl = 'LSM30_Background',
						order = 2,
						name = L["Backdrop texture"],
						values = AceGUIWidgetLSMlists.background,
						disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					colorbackdrop = {
						type = "toggle",
						order = 3,
						name = L["Color the backdrop"],
						disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					backdropcolor = {
						type = "color",
						order = 5,
						name = L["Backdrop color"],
						hasAlpha = true,
						disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
						hidden = function(info) return not DB.resourcebar.colorbackdrop end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer6 = { order = 6, type = "description", name = " ", desc = "", width = "half", hidden = function(info) return not DB.resourcebar.colorbackdrop end },
					tile = {
						type = "toggle",
						order = 7,
						name = L["Tile the backdrop"],
						disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					tilesize = {
						type = "range",
						order = 8,
						name = L["Tile size"],
						min = -100, softMin = -30, softMax = 30, max = 100, step = 1,
						disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
						hidden = function(info) return not DB.resourcebar.tile end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer = { order = 11, type = "description", name = "", desc = "", width = "full"},
					backdropoffsets = {
						type = "group",
						order = 14,
						name = L["Offsets"],
						guiInline = true,
						args = {
							offsetX1 = {
								type = "range",
								order = 1,
								name = L["Top-left X"],
								min = -50, softMin = -10, softMax = 0, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][1]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							offsetY1 = {
								type = "range",
								order = 2,
								name = L["Top-left Y"],
								min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][2]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer6 = { order = 6, type = "description", name = "", desc = "", width = "half"},
							offsetX2 = {
								type = "range",
								order = 8,
								name = L["Bottom-right X"],
								min = -50, softMin = 0, softMax = 10, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][3]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							offsetY2 = {
								type = "range",
								order = 10,
								name = L["Bottom-right Y"],
								min = -50, softMin = -10, softMax = 0, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enablebackdrop"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][4]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
					spacer = { order = 16, type = "description", name = "", desc = "", width = "full"},
				},
			},
			border = {
				type = "group",
				order = 24,
				name = L["Border"],
				disabled = function(info) return not DB.resourcebar["enabled"] end,
				args = {
					enableborder = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					bordertexture = {
						type = "select",
						width = "double",
						dialogControl = 'LSM30_Border',
						order = 2,
						name = L["Border texture"],
						values = AceGUIWidgetLSMlists.border,
						disabled = function(info) return not DB.resourcebar["enableborder"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					bordercolor = {
						type = "color",
						order = 3,
						name = L["Border color"],
						hasAlpha = true,
						disabled = function(info) return not DB.resourcebar["enableborder"] end,
						get = function(info) return unpack(DB.resourcebar[info[#info] ]) end,
						set = function(info, r, g, b, a) DB.resourcebar[info[#info] ] = {r, g, b, a};ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					edgesize = {
						type = "range",
						order = 4,
						name = L["Edge size"],
						min = -100, softMin = -16, softMax = 16, max = 100, step = 1,
						disabled = function(info) return not DB.resourcebar["enableborder"] end,
						get = function(info) return DB.resourcebar[info[#info] ] end,
						set = function(info, value) DB.resourcebar[info[#info] ] = value;ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
					},
					spacer = { order = 7, type = "description", name = "", desc = "", width = "full"},
					backdropinsets = {
						type = "group",
						order = 10,
						name = L["Insets"],
						guiInline = true,
						args = {
							left = {
								type = "range",
								order = 1,
								name = L["Left"],
								min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enableborder"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][1]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][1] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							right = {
								type = "range",
								order = 2,
								name = L["Right"],
								min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enableborder"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][2]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][2] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							spacer3 = { order = 3, type = "description", name = "", desc = "", width = "half"},
							top = {
								type = "range",
								order = 4,
								name = L["Top"],
								min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enableborder"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][3]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][3] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
							bottom = {
								type = "range",
								order = 5,
								name = L["Bottom"],
								min = -50, softMin = -16, softMax = 16, max = 50, step = 1,
								disabled = function(info) return not DB.resourcebar["enableborder"] end,
								get = function(info) return (DB.resourcebar[info[#info-1] ][4]) end,
								set = function(info, offset) DB.resourcebar[info[#info-1] ][4] = (offset);ClassMods.Options:LockDown(ClassMods.SetupResourceBar) end,
							},
						},
					},
				},
			},
		},
	}
end
