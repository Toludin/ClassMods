--
-- Class Mods - Shaman settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "SHAMAN") then return end

--
-- ResourceBar Module
--

ClassMods.enableprediction = true
ClassMods.powerGenerationSpells = {
	[1] = { -- Elemental
		{ 51505,	12 }, -- Lava Burst
		{ 188196,	 8  }, -- Lightning Bolt
		{ 188443,	 4  }, -- Chain Lightning
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
	[1] = { -- Elemental
	--	{ 1,      	2,         	3,      4,        5,            6, 											7	 	 }, -- index
		{ true,		188389,	true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, -- Flame Shock
		{ false,	196840,	true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, -- Frost Shock
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
	},
	[2] = { -- Enhancement
		{ true,		17364,		true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, -- Stormstrike
		{ true,		60103,		true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, -- Lava Lash
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
	},
	[3] = { -- Restoration
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_MAELSTROM,	false }, --		
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Elemental
	--	{ 1,			2,	  3										}, -- index
		{ 188389,	20, SPELL_POWER_MAELSTROM	}, -- Flame Shock
		{ 196840,	20, SPELL_POWER_MAELSTROM	}, -- Frost Shock
		{ 8042,		10, SPELL_POWER_MAELSTROM	}, -- Earth Shock
	},
	[2] = { -- Enhancement
		{ 187874,	20, SPELL_POWER_MAELSTROM	}, -- Crash Lightning
		{ 196834,	20, SPELL_POWER_MAELSTROM	}, -- Frostbrand
		{ 60103,	30, SPELL_POWER_MAELSTROM	}, -- Lava Lash
		{ 17364,	40, SPELL_POWER_MAELSTROM	}, -- Stormstrike
	},
	[3] = {}, -- Restoration
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
	[1] = { -- Elemental
	--	{ 1,			2,				3,				4,	5, 			6				}, -- index
		{ true,		16164,		"player",	2, "AtMax",	"aura"		}, -- Elemental Focus
		{ false,	210714,	"player",	4, "Always",	"aura"		}, -- Icefury
		{ false,	51505,		"player",	2,	"AtMax",	"charge"	}, -- Lava Burst (Echo of Elements)
	},
	[2] = { -- Enhancement
		{ true,		201846,	"player",	2, "Always",	"aura"		}, -- Stormbringer (Tempest)
	},
	[3] = { -- Restoration
		{ true,		53390,		"player",	2, "AtMax",	"aura"		}, -- Tidal Waves
		{ false,	5394,		"player",	2, "AtMax",	"charge"	}, -- Healing Stream Totem
		{ false,	61295,		"player",	2, "AtMax",	"charge"	}, -- Riptide
		{ false,	51505,		"player",	2, "AtMax",	"charge"	}, -- Lava Burst
	},
}

--
-- Alternate Resource Bar
--

ClassMods.alternateResource = false

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
		{ 187837,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Lightning Bolt
		{ 187874,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Crash Lightning
		{ 17364,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Stormstrike
		{ 207399,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Ancestral Protection Totem
		{ 2008,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Ancestral Spirit
		{ 370,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Purge
		{ 51886,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Cleanse Spirit
		{ 77130,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Purify Spirit
		{ 57994,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Wind Shear
		{ 198103,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Earth Elemental
		{ 198067,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Fire Elemental
		{ 192249,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Storm Elemental
		{ 201897,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Boulderfist
		{ 114050,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Acendance (Elemental)
		{ 114051,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Acendance (Enhancement)
		{ 114052,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Acendance (Restoration)
		{ 108281,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Ancestral Guidence
		{ 108271,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Astral Shift
		{ 157153,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Cloudburst Totem
		{ 198838,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Earthen Shield Totem
		{ 188089,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Earthen Spike
		{ 51485,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Earthgrab Totem
		{ 61882,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Earthquake Totem
		{ 117014,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Elemental Blast
		{ 16166,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Elemental Mastery
		{ 196884,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Feral Lunge
		{ 51533,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Feral Spirits
		{ 188838,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Flame Shock (Restoration)
		{ 193796,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Flametongue
		{ 192063,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Gust of Wind
		{ 73920,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Healing Rain
		{ 5394,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   32,	0.5 },	--	Healing Stream Totem
		{ 108280,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   33,	0.5 },	--	Healing Tide Totem
		{ 32182,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   34,	0.5 },	--	Heroism
		{ 51514,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   35,	0.5 },	--	Hex
		{ 51505,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   36,	0.5 },	-- Lava Burst
		{ 192058,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   37,	0.5 },	--	Lightning Surge Totem
		{ 192222,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   38,	0.5 },	--	Liquid Magma Totem
		{ 215864,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   39,	0.5 },	--	Rainfall
		{ 61295,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   40,	0.5 },	--	Riptide
		{ 98008,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   41,	0.5 },	--	Spirit Link Totem
		{ 58875,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   42,	0.5 },	--	Spirit Walk
		{ 79206,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   43,	0.5 },	--	Spirit Walker's Grace
		{ 197214,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   44,	0.5 },	--	Sundering
		{ 51490,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   45,	0.5 },	--	Thunderstorm
		{ 73685,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   46,	0.5 },	--	Unleash Life
		{ 196932,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   47,	0.5 },	--	Voodoo Totem
		{ 197995,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   48,	0.5 },	--	Wellspring
		{ 192077,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   49,	0.5 },	--	Wind Rush Totem
		{ 201898,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   50,	0.5 },	--	Windsong
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 53390,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Tidal Waves
		{ 16164,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	-- Elemental Focus
		{ 198103,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	-- Earth Elemental
		{ 198067,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	-- Fire Elemental
		{ 210714,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Icefury
		{ 108281,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Ancestral Guidence
		{ 215785,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Hot Hand
		{ 77762,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Lava Surge
		{ 201846,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Stormbringer
		{ 216251,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Undulation
		{ 32182,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Heroism
		{ 114050,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Acendance (Elemental)
		{ 114051,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Acendance (Enhancement)
		{ 114052,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Acendance (Restoration)
		{ 108271,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Astral Shift
		{ 118522,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Elemental Blast: Critical Strike
		{ 173183,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Elemental Blast: Haste
		{ 173184,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Elemental Blast: Mastery
		{ 16166,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Elemental Mastery
		{ 171114,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Feral Spirits
		{ 194084,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Flametongue
		{ 196834,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Frostbrand
		{ 73920,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Healing Rain
		{ 202004,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Landslide
		{ 192106,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Lightning Shield
		{ 215864,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Rainfall
		{ 58875,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Spirit Walk
		{ 79206,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Spirit Walker's Grace
		{ 73685,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Unleash Life
		{ 192082,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Wind Rush
		{ 201898,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Windsong
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 197209,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Lightning Rod
		{ 51514,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Hex
		{ 207400,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Ancestral Vigor
		{ 116947,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Earthbind
		{ 188089,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Earthen Spike
		{ 64695,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Earthgrab
		{ 188389,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Flame Shock (Elemental)
		{ 188838,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Flame Shock (Restoration)
		{ 196840,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Frost Shock
		{ 147732,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Frostbrand
		{ 61295,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Riptide
		{ 118905,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Static Charge
		{ 51490,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Thunderstorm
	},
}

--[[
	ClassMods.spellTracker.spells:
	[spellID]
	1 = GUID applied to
	2 = expireTime
	3 = knownDuration in seconds
--]]

ClassMods.spellTrackerSpells = {}

--
-- Alerts
--

ClassMods.pethealthtexture = nil
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(108281))] = {	--	Ancestral Guidence
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 108281,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(16164))] = {	--	Elemental Focus
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 16164,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(215785))] = {	--	Hot Hand
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 215785,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(77762))] = {	--	Lava Surge
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 77762,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(197209))] = {	--	Lightning Rod
		enabled = true,
		alerttype = "DEBUFF",
		enablesound = true,
		sound = "Ding",
		aura = 197209,
		target = "target",
		sparkles = true
	},
	[select(1, GetSpellInfo(201846))] = {	--	Stormbringer
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 201846,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(216251))] = {	--	Undulation
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 216251,
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
	[select(1, GetSpellInfo(207399))] = {	--	Ancestral Protection Totem
		enabled = true,
		spellid = 207399,
		announceend = false,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(2008))] = {		--	Ancestral Spirit
		enabled = true,
		spellid = 2008,
		announceend = false,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(32182))] = {	--	Heroism
		enabled = true,
		spellid = 32182,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(212048))] = {	--	Ancestral Vision
		enabled = true,
		spellid = 212048,
		announceend = false,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(2008)) -- Ancestral Spirit

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
	{ 51514,	true,	51514,	60,	30 },	-- Hex
	{ 210873,	true,	210873,	60,	30 },	-- Hex: Compy
	{ 211004,	true,	211004,	60,	30 },	-- Hex: Spider
	{ 211010,	true,	211010,	60,	30 },	-- Hex: Snake
	{ 211015,	true,	211015,	60,	30 },	-- Hex: Cocroach
}

--
-- Dispel
--

ClassMods.enableDispel = true
ClassMods.dispelTexture = select(3, GetSpellInfo(370)) -- Purge

--
-- Healthbar
--

ClassMods.pethealth = true
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
	{ true, 51485,	20 }, 	-- Earthgrab Totem
	{ true, 61882,	10 },		-- Earthquake Totem
	{ true, 192222,	15 },		--	Liquid Magma Totem
	{ true, 196932,	10 },		--	Voodoo Totem
	{ true, 192077,	15 },		--	Wind Rush Totem
	{ true, 210643,	120},	--	Totem Mastery
	{ true, 207399,	30 }, 	--	Ancestral Protection Totem
	{ true, 157153,	15 }, 	--	Cloudburst Totem
	{ true, 198838,	15 }, 	--	Earthen Shield Totem
	{ true, 5394,	15 }, 	--	Healing Stream Totem
	{ true, 108280,	10 }, 	--	Healing Tide Totem
	{ true, 98008,	6	}, 	--	Spirit Link Totem
}
