--
-- Class Mods - Death Knight settings
--

-- Check the player's class before creating the settings
if (select(2, UnitClass("player")) ~= "DEATHKNIGHT") then return end

--
-- ResourceBar Module
--

ClassMods.enableprediction = false
ClassMods.powerGenerationSpells = {nil, nil, nil}
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
	[1] = { -- Blood
	--	{ 1,      	2,          	3,      4,        5,            6, 											7		 }, -- index
		{ true,		49998,		true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Death Strike
		{ true,		206940,	true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Mark of Blood
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
	},
	[2] = { -- Frost
		{ true,		49143,		true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Frost Strike
		{ true,		49998,		true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Death Strike
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
	},
	[3] = { -- Unholy
		{ true,		47541,		true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Death Coil
		{ true,		49998,		true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false }, -- Death Strike
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_RUNIC_POWER, false },
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Blood
	--	{ 1,			2,		3,											 }, -- index
		{ 49998,	40,	SPELL_POWER_RUNIC_POWER }, -- Death Strike
		{ 206940,	30,	SPELL_POWER_RUNIC_POWER }, -- Mark of Blood
	},
	[2] = { -- Frost
		{ 49143,	25,	SPELL_POWER_RUNIC_POWER }, -- Frost Strike
		{ 49998,	40,	SPELL_POWER_RUNIC_POWER }, -- Death Strike
	},
	[3] = { -- Unholy
		{ 47541,	35,	SPELL_POWER_RUNIC_POWER }, -- Death Coil
		{ 49998,	40,	SPELL_POWER_RUNIC_POWER }, -- Death Strike
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
	[1] = { -- Blood
	--	{ 1,			2,				3,				4,	5, 			6			 }, -- index
		{ true,		50842,		"player",	2,	"AtMax",	"charge" }, -- Blood Boil
		{ false,	221699,	"player",	2,	"AtMax",	"charge" }, -- Blood Tap
		{ false,	194679,	"player",	2,	"AtMax",	"charge" }, -- Rune Tap
		{ false,	51714,		"target",	5,	"AtMax",	"aura"	 }, -- Razorice
	},
	[2] = { -- Frost
		{ true,		194879,	"player",	3, "AtMax",	"aura"	 }, -- Icy Talons
		{ false,	51714,		"target",	5,	"AtMax",	"aura"	 }, -- Razorice
	},
	[3] = { -- Unholy
		{ true,		207317,	"player",	3, "AtMax",	"charge" }, -- Epidemic
		{ false,	194918,	"player",	4,	"Always",	"aura"	 }, -- Blighted Rune Weapon
		{ false,	51714,		"target",	5,	"AtMax",	"aura"	 }, -- Razorice
		{ false, 	194310, 	"target", 	8, "AtMax", 	"aura" 	 }, -- Festering Wound
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
		{ 48707,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Anti-Magic Shell
		{ 42650,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Army of the Dead
		{ 221562,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Asphyxiate
		{ 194918,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Blighted Rune Weapon
		{ 207167,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Blinding Sleet
		{ 50842,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Blood Boil
		{ 206977,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Blood Mirror
		{ 221699,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Blood Tap
		{ 206931,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Blooddrinker
		{ 194844,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  10,	0.5 },	--	Bonestorm
		{ 152279,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  11,	0.5 },	--	Breath of Sindragosa
		{ 45524,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  12,	0.5 },	--	Chains of Ice
		{ 207311,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  13,	0.5 },	--	Clawing Shadows
		{ 49028,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  14,	0.5 },	--	Dancing Rune Weapon
		{ 56222,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  15,	0.5 },	--	Dark Command
		{ 63560,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  16,	0.5 },	--	Dark Transformation
		{ 43265,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  17,	0.5 },	--	Death and Decay
		{ 49576,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  18,	0.5 },	--	Death Grip
		{ 195292,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  19,	0.5 },	--	Death's Caress
		{ 47568,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  20,	0.5 },	--	Empower Rune Weapon
		{ 207317,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  21,	0.5 },	--	Epidemic
		{ 194913,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  22,	0.5 },	--	Glacial Advance
		{ 206930,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  23,	0.5 },	--	Heart Strike
		{ 57330,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  24,	0.5 },	--	Horn of Winter
		{ 48792,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  25,	0.5 },	--	Icebound Fortitude
		{ 47528,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  26,	0.5 },	--	Mind Freeze
		{ 207256,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  27,	0.5 },	--	Obliteration
		{ 51271,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  28,	0.5 },	--	Pillar of Frost
		{ 46584,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  29,	0.5 },	--	Raise Dead
		{ 196770,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  30,	0.5 },	--	Remorseless Winter
		{ 194679,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  31,	0.5 },	--	Rune Tap
		{ 130736,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  32,	0.5 },	--	Soul Reaper
		{ 212744,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  33,	0.5 },	--	Soulgorge
		{ 49206,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  34,	0.5 },	--	Summon Gargoyle
		{ 219809,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  35,	0.5 },	--	Tombstone
		{ 55233,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  36,	0.5 },	--	Vampiric Blood
		{ 207170,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  37,	0.5 },	--	Winter is Coming
		{ 212552,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,  38,	0.5 },	--	Wraith Walk
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 205727,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Anti-Magic Barrier
		{ 48707,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Anti-Magic Shell
		{ 194918,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Blighted Rune Weapon
		{ 77535,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Blood Shield
		{ 195181,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Bone Shield
		{ 194844,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Bonestorm
		{ 81141,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Crimson Scourge
		{ 81256,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Dancing Rune Weapon
		{ 101568,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Dark Succor
		{ 63560,	nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 10,	0.5 },	--	Dark Transformation
		{ 207203,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 11,	0.5 },	--	Frost Shielding
		{ 48792,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 12,	0.5 },	--	Icebound Fortitude
		{ 194879,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 13,	0.5 },	--	Icy Talons
		{ 51124,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 14,	0.5 },	--	Killing Machine
		{ 216974,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 15,	0.5 },	--	Necrosis
		{ 207256,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 16,	0.5 },	--	Obliteration
		{ 51271,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 17,	0.5 },	--	Pillar of Frost
		{ 194679,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 18,	0.5 },	--	Rune Tap
		{ 213003,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 19,	0.5 },	--	Soulgorge
		{ 81340,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 20,	0.5 },	--	Sudden Doom
		{ 219809,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 21,	0.5 },	--	Tombstone
		{ 55233,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 22,	0.5 },	--	Vampiric Blood
		{ 212552,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 23,	0.5 },	--	Wraith Walk
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 221562,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Asphyxiate
		{ 207167,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Blinding Sleet
		{ 206977,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Blood Mirror
		{ 55078,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Blood Plague
		{ 45524,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Chains of Ice
		{ 56222,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Dark Command
		{ 51399,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Death Grip
		{ 194310,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Festering Wound
		{ 55095,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Frost Feaver
		{ 206930,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 10,	0.5 },	--	Heart Strike
		{ 206940,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 11,	0.5 },	--	Mark of Blood
		{ 51714,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 12,	0.5 },	--	Razorice
		{ 211793,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 13,	0.5 },	--	Remorseless Winter
		{ 130736,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 14,	0.5 },	--	Soul Reaper
		{ 191587,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 15,	0.5 },	--	Virulent Plague
		{ 211794,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 16,	0.5 },	--	Winter is Coming
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
	["42650"] = { nil, 0, 40.5 },	-- Army of the Dead
}

--
-- Alerts
--

ClassMods.pethealthtexture = select(3, GetSpellInfo(63560)) -- Dark Transformation
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	["Pet Health Alert"] 		= { enabled = true, alerttype = "PETHEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "pet", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(101568))] = { -- Dark Succor
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 101568,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(51124))] = { -- Killing Machine
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 51124,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(216974))] = { -- Necrosis
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 216974,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(81340))] = { -- Sudden Doom
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 81340,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(195181))] = { -- Bone Shield
		enabled = true,
		alerttype = "BUFF",
		enablesound = false,
		sound = "",
		aura = 195181,
		target = "player",
		sparkles = false,
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
	[select(1, GetSpellInfo(196770))] = { -- Remorseless Winter
		enabled = true,
		spellid = 196770,
		announceend = false,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(48792))] = {  -- Icebound Fortitude
		enabled = true,
		spellid = 48792,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(55233))] = {  -- Vampiric Blood
		enabled = true,
		spellid = 55233,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(61999))] = {  -- Raise Ally
		enabled = true,
		spellid = 61999,
		announceend = true,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(61999)) -- Raise Ally

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
--	{ 1,			2,			3,			4,		5    }, -- index
	{ 45524,	true,	45524,	8,		8	  }, -- Chains of Ice
	{ 111673,	true,	111673, 300,	300 }, -- Control Undead
}

--
-- Dispel
--

ClassMods.enableDispel = false

--
-- Healthbar
--

ClassMods.pethealth = true
ClassMods.pethealthfont = { "Big Noodle", 14, "OUTLINE" }
ClassMods.pethealthfontoffset = -80

--
-- Totems
--

ClassMods.enableTotems = false
