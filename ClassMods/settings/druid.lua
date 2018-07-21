--
-- Class Mods - Druid settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "DRUID") then return end

--
-- ResourceBar Module
--

ClassMods.enableprediction = true
ClassMods.powerGenerationSpells = {
	[1] = { -- Balance
		{ 194153,	12 	}, -- Lunar Strike
		{ 190984,	8		}, -- Solar Wrath
		{ 202767,	10	}, --	New Moon
		{ 202768,	20	}, --	Half Moon
		{ 202771,	40	}, --	Full Moon
	},
}

ClassMods.highwarn = true

--
-- ResourceBar: Tick Marks
--

ClassMods.enableticks = true

--[[
ClassMods.ticks
	1: Enabled
	2: SpellID
	3: Offset from main spell
	4: Change colour of the resource bar when focus is <= tick value
	5: Colour of the Tick Mark r,b,g,a
	6: UnitPowerType to display the tick (Special for PowerType changing classes Im looking at YOU DRUIDS!)
	7: Use spell icon for the tick mark
--]]

ClassMods.ticks = {
	[1] = { -- Balance
	--	{ 1,      2,          	3,      4,        5,            6, 												7		 },	-- index
		{ true,	78674,			false, false, {1,1,1,1}, SPELL_POWER_LUNAR_POWER,	false }, -- Starsurge
		{ true,	191034,		false, false, {1,1,1,1}, SPELL_POWER_LUNAR_POWER,	false }, -- Starfall
		{ true,	5221,			false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Shred
		{ true,	1079,			false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Rip
		{ true,	22842,			false, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Frenzied Regeneration
	},
	[2] = { -- Feral
		{ true,		5221,		true, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Shred
		{ true,		1079,		true, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Rip 
		{ true,		52610,		true, false, {1,1,1,1}, SPELL_POWER_ENERGY, 				false }, -- Savage Roar
		{ true,		22842,		false, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Frenzied Regeneration
		{ true,		192081,	false, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Ironfur
	},
	[3] = { -- Guardian
		{ true,		22842,		true, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Frenzied Regeneration
		{ true,		192081,	true, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Ironfur
		{ true,		6807,		true, false, {1,1,1,1}, SPELL_POWER_RAGE, 					false }, -- Maul
		{ true,		5221,		false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Shred
		{ true,		1079,		false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Rip 
	},
	[4] = { -- Restoration
		{ true,		5221,		false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Shred
		{ true,		1079,		false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Rip 
		{ true,		22568,		false, false, {1,1,1,1}, SPELL_POWER_ENERGY,				false }, -- Ferocious Bite
		{ true,		22842,		false, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Frenzied Regeneration
		{ true,		192081,	false, false, {1,1,1,1}, SPELL_POWER_RAGE,					false }, -- Ironfur
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Balance
	--	{ 1,			2,   3											}, -- index
		{ 191034,	60, SPELL_POWER_LUNAR_POWER	}, -- Starfall
		{ 78674,	40, SPELL_POWER_LUNAR_POWER	}, -- Starsurge
		{ 202347,	15, SPELL_POWER_LUNAR_POWER	}, -- Stellar Flare
		{ 106830,	50, SPELL_POWER_ENERGY			}, -- Thrash
		{ 5221,		40, SPELL_POWER_ENERGY			}, -- Shred
		{ 106785,	45, SPELL_POWER_ENERGY			}, -- Swipe
		{ 1079,		30, SPELL_POWER_ENERGY			}, -- Rip
		{ 22842,	10, SPELL_POWER_RAGE				}, -- Frenzied Regeneration
		{ 192081,	45, SPELL_POWER_RAGE				}, -- Ironfur
	},
	[2] = { -- Feral
		{ 202208,	20, SPELL_POWER_ENERGY			}, -- Brutal Slash
		{ 52610,	25, SPELL_POWER_ENERGY			}, -- Savage Roar
		{ 22568,	25, SPELL_POWER_ENERGY			}, -- Ferocious Bite
		{ 1079,		30, SPELL_POWER_ENERGY			}, -- Rip
		{ 155625,	30, SPELL_POWER_ENERGY			}, -- Moonfire
		{ 22570,	35, SPELL_POWER_ENERGY			}, -- Maim
		{ 1822,		35, SPELL_POWER_ENERGY			}, -- Rake
		{ 5221,		40, SPELL_POWER_ENERGY			}, -- Shred
		{ 106785,	45, SPELL_POWER_ENERGY			}, -- Swipe
		{ 106830,	50, SPELL_POWER_ENERGY			}, -- Thrash
		{ 22842,	10, SPELL_POWER_RAGE				}, -- Frenzied Regeneration
		{ 192081,	45, SPELL_POWER_RAGE				}, -- Ironfur
	},
	[3] = { -- Guardian
		{ 6807,		20, SPELL_POWER_RAGE				}, -- Maul
		{ 22842,	10, SPELL_POWER_RAGE				}, -- Frenzied Regeneration
		{ 192081,	45, SPELL_POWER_RAGE				}, -- Ironfur
		{ 5221,		40, SPELL_POWER_ENERGY			}, -- Shred
		{ 22568,	25, SPELL_POWER_ENERGY			}, -- Ferocious Bite
		{ 1079,		30, SPELL_POWER_ENERGY			}, -- Rip
	},
	[4] = { -- Restoration
		{ 5221,		40, SPELL_POWER_ENERGY			}, -- Shred
		{ 22568,	25, SPELL_POWER_ENERGY			}, -- Ferocious Bite
		{ 1079,		30, SPELL_POWER_ENERGY			}, -- Rip
		{ 22842,	10, SPELL_POWER_RAGE				}, -- Frenzied Regeneration
		{ 192081,	45, SPELL_POWER_RAGE				}, -- Ironfur
	},
}

--
-- ResourceBar: Stacks
--

--[[
ClassMods.stacks
	1: enabled
	2: spellID
	3: unitID to check
	4: numBars
	5: flashtype
	6: check type - "aura" for UnitAura() or "charge" for GetSpellCharges()
--]]

ClassMods.stacks = {
	[1] = { -- Balance
	--	{ 1,			2,				3,				4,	5, 			6				}, -- index
		{ true,		164547,	"player",	3, "AtMax",	"aura"		}, -- Lunar Empowerment
		{ false,	164545,	"player",	3, "AtMax",	"charge"	}, -- Solar Empowerment
		{ false,	202425,	"player",	2,	"Always",	"aura"		}, -- Warrior of Elune
		{ false,	22842,		"player",	2,	"AtMax",	"charge"	}, -- Frenzied Regeneration
	},
	[2] = { -- Feral
		{ true,		145152,	"player",	2, "Always",	"aura"		}, -- Bloodtalons
		{ false,	202208,	"player",	3, "AtMax",	"charge"	}, -- Brutal Slash
		{ false,	61336,		"player",	2, "AtMax",	"charge"	}, -- Survival Instincts
		{ false,	135700,	"player",	3, "Always",	"aura"		}, -- Clear Casting (Moment of Clarity talent)
		{ false,	22842,		"player",	2, "AtMax",	"charge"	}, -- Frenzied Regeneration
	},
	[3] = { -- Guardian
		{ true,		192090,	"target",	3, "AtMax",	"aura"		}, -- Thrash
		{ false,	203974,	"player",	3, "Always",	"aura"		}, -- Earthwarden
		{ false,	61336,		"player",	2, "AtMax",	"charge"	}, -- Survival Instincts
		{ false,	22842,		"player",	2, "AtMax",	"charge"	}, -- Frenzied Regeneration
	},
	[4] = { -- Restoration
		{ true,		18562,		"player",	2, "Always",	"charge"	}, -- Swiftmend (Prosperity talent)
		{ false,	16870,		"player",	3, "Always",	"aura"		}, -- Clear Casting (Moment of Clarity talent)
		{ false,	22842,		"player",	2, "AtMax",	"charge"	}, -- Frenzied Regeneration
	},
}

--
-- Alternate Resource Bar
--

ClassMods.alternateResource = true

--
-- Timers
--

--[[
ClassMods.timerbarDefaults
	1: Spell
	2: Item
	3: Check target
	4: Check type
	5: Owner
	6: What specilization (no longer used)
	7: Timer text position
	8: Flash when expiring?
	9: Only if known flag (mandatory true)
	10: <removed, was growth setting>
	11:  - <removed, Grow start>
	12:  - <removed, Grow size>
	13: Change alpha over time?
	14:  - Alpha Start
	15:  - Alpha End
	16: Internal Cooldown time
	17: Last time for Internal Cooldown
	18: Show the icon when? { 1 = Active / 0 or nil = Always }
	19: Position on bar (values: 1 - total timers)
	20: Inactive Alpha when "always" on bar for stationary timers.
	21: Collapse flag, for options. (used internally)
--]]

ClassMods.timerbarDefaults = {
	["timerbar1"] = {
	-- { 1,			2,		3,				4,						5,					6,	7,				8,		9,			10,	11,	12,	13,	14,  15,16, 17, 18, 19,	20  },	-- Index
		{ 202359,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Astral Communion
		{ 22812,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Barkskin
		{ 106951,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Berserk
		{ 202360,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Blessing of the Ancients
		{ 155835,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Bristling Fur
		{ 202208,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Brutal Slash
		{ 194223,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Celestial Alignment
		{ 102351,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Cenarion Ward
		{ 1850,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Dash
		{ 102280,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Displacer Beast
		{ 202060,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Elune's Guidance
		{ 339,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Entangling Roots
		{ 197721,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Flourish
		{ 205636,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Force of Nature
		{ 22842,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Frenzied Regeneration
		{ 202770,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Fury of Elune
		{ 6795,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Growl
		{ 99,			nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Incapacitating Roar
		{ 33891,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Incarnation: Tree of Life
		{ 29166,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Innervate
		{ 102342,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Ironbark
		{ 197081,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Ironfur
		{ 204066,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Lunar Beam
		{ 22570,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Maim
		{ 33917,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Mangle
		{ 102359,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Mass Entanglement
		{ 6807,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Maul
		{ 5211,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Mighty Bash
		{ 197625,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Moonkin Form
		{ 88423,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Nature's Cure
		{ 5215,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Prowl
		{ 20484,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   32,	0.5 },	--	Rebirth
		{ 2782,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   33,	0.5 },	--	Remove Corruption
		{ 108238,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   34,	0.5 },	--	Renewal
		{ 50769,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   35,	0.5 },	--	Revive
		{ 106839,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   36,	0.5 },	--	Skull Bash
		{ 78675,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   37,	0.5 },	--	Solar Beam
		{ 77761,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   38,	0.5 },	--	Stampeding Roar
		{ 77764,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   39,	0.5 },	--	Stampeding Roar
		{ 191034,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   40,	0.5 },	--	Starfall
		{ 197626,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   41,	0.5 },	--	Starsurge
		{ 61336,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   42,	0.5 },	--	Survival Instincts
		{ 18562,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   43,	0.5 },	--	Swiftmend
		{ 77758,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   44,	0.5 },	--	Thrash
		{ 5217,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   45,	0.5 },	--	Tiger's Fury
		{ 132469,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   46,	0.5 },	--	Typhoon
		{ 102793,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   47,	0.5 },	--	Ursol's Vortex
		{ 202425,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   48,	0.5 },	--	Warrior of Elune
		{ 102401,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   49,	0.5 },	--	Wild Charge
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 22812,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Barkskin
		{ 106951,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Berserk
		{ 145152,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Bloodtalons
		{ 155835,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Bristling Fur
		{ 194233,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Celestial Alignment
		{ 16870,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Clear Casting
		{ 135700,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Clear Casting
		{ 1850,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Dash
		{ 137452,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Displacer Beast
		{ 22842,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Frenzied Regeneration
		{ 213680,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Guardian of Elune
		{ 102560,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Incarnation: Chosen of Elune
		{ 102543,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Incarnation: King of the Jungle
		{ 117679,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Incarnation: Tree of Life
		{ 102342,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Ironbark
		{ 192081,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Ironfur
		{ 164547,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Lunar Empowerment
		{ 93622,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Mangle!
		{ 192083,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Mark of Ursol
		{ 158792,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Pulverise
		{ 52610,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Savage Roar
		{ 164545,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Solar Empowerment
		{ 114108,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Soul of the Forest
		{ 77764,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Stampeding Roar
		{ 61336,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Survival Instincts
		{ 5217,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Tiger's Fury
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 102352,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Cenarion Ward
		{ 200389,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Cultivation
		{ 50259,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Dazed
		{ 339,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Entangling Roots
		{ 155777,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Germination
		{ 6795,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Growl
		{ 45334,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Immobilized
		{ 99,			nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Incapacitating Roar
		{ 58180,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Infected Wounds
		{ 29166,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Innervate
		{ 33763,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Lifebloom
		{ 48504,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Living Seed
		{ 102359,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Mass Entanglement
		{ 5211,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Mighty Bash
		{ 155625,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Moonfire
		{ 164812,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Moonfire
		{ 155722,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Rake
		{ 163505,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Raked!
		{ 8936,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Regrowth
		{ 774,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Rejuvenation
		{ 1079,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Rip
		{ 81261,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Solar Beam
		{ 207386,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Spring Blossoms
		{ 77761,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Stampeding Roar
		{ 197637,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Stellar Empowerment
		{ 202347,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Stellar Flare
		{ 164815,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Sunfire
		{ 192090,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Thrash
		{ 132469,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Typhoon
		{ 48438,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Wild Growth
	},
}

--[[
	ClassMods.spellTracker.spells:
	1 = spellID
	2 = GUID applied to
	3 = expireTime
	4 = knownDuration in seconds
--]]

ClassMods.spellTrackerSpells = {
-- [ 1]                  2,   3,  4    }	-- index
	["205636"] = { nil, 0, 10.5 },	-- Force of Nature
	["204066"] = { nil, 0, 8.5 },	-- Luna Beam
}

--
-- Alerts
--

ClassMods.pethealthtexture = nil
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(135700))] = { -- Clear Casting (Feral)
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 135700,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(16870))] = { -- Clear Casting (Restoration)
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 16870,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(93622))] = { -- Mangle! (Guardian)
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 93622,
		target = "player",
		sparkles = true
	},
}

--
-- Announcements
--

--[[
ClassMods.announcementDefaults
	1: enabled
	2: spellID
	3: announce end
	4: solo channel
	5: party channel
	6: raid channel
	7: arena channel
	8: pvp channel
--]]

ClassMods.announcementDefaults = {
	[select(1, GetSpellInfo(29166))] = { -- Innervate
		enabled = true,
		spellid = 29166,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(20484))] = {  -- Rebirth
		enabled = true,
		spellid = 20484,
		announceend = nil,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(77764))] = {  -- Stampeding Roar (Feral)
		enabled = true,
		spellid = 77764,
		announceend = nil,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(77761))] = {  -- Stampeding Roar (Guardian)
		enabled = true,
		spellid = 77761,
		announceend = nil,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
}

--
-- Click to Cast
--

ClassMods.clickToCastDefault = select(1, GetSpellInfo(29166)) -- Innervate

--
-- Crowd Control
--

--[[
ClassMods.crowdcontrolDefaults
	1: spellID
	2: enabled
	3: aura
	4: pve duration
	5: pvp duration
	6: can the CC be refreshed
--]]
ClassMods.enableCrowdControl = true
-- TODO: UPDATE THE NON DR PVP DURATIONS
ClassMods.crowdControlSpells = {
--	{ 1,			2,			3,			4,		5   }, -- index
	{ 339,		true,	339,		30,	30 },	-- Entangling Roots
}

--
-- Dispel
--

ClassMods.enableDispel = false

--
-- Healthbar
--

ClassMods.pethealth = false
ClassMods.pethealthfont = { "Big Noodle", 14, "OUTLINE" }
ClassMods.pethealthfontoffset = -80

--
-- Totems
--

--[[
ClassMods.totems
	1: enabled
	2: spellID
	3: duration
--]]

ClassMods.enableTotems = true
ClassMods.totems = {
	{ true, 145205, 30, }, -- Efflorescence
}
