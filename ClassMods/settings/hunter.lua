--
-- Class Mods - Hunter settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "HUNTER") then return end

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
	[1] = { -- Beast Mastery
	--	{ 1,      	2,          	3,      4,        5,            6, 								7		  },	-- index
		{ true,		34026,		true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },	-- Kill Command
		{ true,		193455,	true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },	-- Cobra Shot
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
	},
	[2] = { -- Marksmanship
		{ true,		185901,	true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false }, -- Marked Shot
		{ true,		19434,		true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false }, -- Aimed Shot
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
	},
	[3] = { -- Survival
		{ true,		202800,	true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false }, -- Flanking Strike
		{ true,		186270,	true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false }, -- Raptor Strike
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_FOCUS, false },
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Beast Mastery
	--	{ 1,			2,		3,								 }, -- index
		{ 131894,	30,	SPELL_POWER_FOCUS }, -- A Murder of Crows
		{ 120360,	60,	SPELL_POWER_FOCUS }, -- Barrage
		{ 193455,	40,	SPELL_POWER_FOCUS }, -- Cobra Shot
		{ 34026,	30,	SPELL_POWER_FOCUS }, -- Kill Command
		{ 2643, 	40,	SPELL_POWER_FOCUS }, -- Multi-Shot

	},
	[2] = { -- Marksmanship
		{ 131894,	30,	SPELL_POWER_FOCUS }, -- A Murder of Crows
		{ 19434,	50,	SPELL_POWER_FOCUS }, -- Aimed Shot
		{ 120360,	60,	SPELL_POWER_FOCUS }, -- Barrage
		{ 194599,	40,	SPELL_POWER_FOCUS }, -- Black Arrow
		{ 186387,	10,	SPELL_POWER_FOCUS }, -- Bursting Shot
		{ 185901,	30,	SPELL_POWER_FOCUS }, -- Marked Shot
	},
	[3] = { -- Survival
		{ 206505,	30,	SPELL_POWER_FOCUS }, -- A Murder of Crows
		{ 187708,	40,	SPELL_POWER_FOCUS }, -- Carve
		{ 202800,	50,	SPELL_POWER_FOCUS }, -- Flanking Strike
		{ 185855,	35,	SPELL_POWER_FOCUS }, -- Lacerate
		{ 186270,	25,	SPELL_POWER_FOCUS }, -- Raptor Strike
		{ 200163,	15,	SPELL_POWER_FOCUS }, -- Throwing Axes
		{ 195645,	30,	SPELL_POWER_FOCUS }, -- Wing Clip
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
	[1] = { -- Beast Mastery
	--	{ 1,			2,			3,				4,	5, 			6				}, -- index
		{ true,		217200, "pet",		5,	"NotMax",	"aura"		}, --  Dire Frenzy
	},
	[2] = { -- Marksmanship
		{ true,		194594, "player",	2, "Always",	"aura"		}, -- Lock and Load
		{ false,	206817, "player",	2, "AtMax",	"charge"	}, -- Sentinel
		{ false,	214579, "player",	2, "AtMax",	"charge"	}, -- Sidewinders
	},
	[3] = { -- Survival
		{ false,	212436, "player",	3, "AtMax",	"charge"	}, -- Butchery
		{ true,		190928, "player",	3, "AtMax",	"charge"	}, -- Mongoose Bite
		{ false,	200163, "player",	2, "AtMax",	"charge"	}, -- Throwing Axes
		{ false,	201081, "player",	4, "NotMax",	"aura"		}, -- Way of the Mok'Nathal
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
		{ 19574,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	-- Bestial Wrath
		{ 131894,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	-- A Murder of Crows
		{ 206505,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	-- A Murder of Crows
		{ 186257,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	-- Aspect of the Cheetah
		{ 186289,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	-- Aspect of the Eagle
		{ 186265,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	-- Aspect of the Turtle
		{ 193530,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	-- Aspect of the Wild
		{ 120360,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	-- Barrage
		{ 109248,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	-- Binding Shot
		{ 194599,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 10,	0.5 },	-- Black Arrow
		{ 186387,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 11,	0.5 },	-- Bursting Shot
		{ 212436,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	12,	0.5 },	-- Butchery
		{ 199483,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	13,	0.5 },	-- Camouflage
		{ 53209,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	14,	0.5 },	-- Chimaera Shot
		{ 5116,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	15,	0.5 },	-- Concussive Shot
		{ 147362,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	16,	0.5 },	-- Counter Shot
		{ 120679,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	17,	0.5 },	-- Dire Beast
		{ 781,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	18,	0.5 },	-- Disengage
		{ 194855,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	19,	0.5 },	-- Dragonsfire Grenage
		{ 109304,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	20,	0.5 },	-- Exhilaration
		{ 194291,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	21,	0.5 },	-- Exhilaration
		{ 212431,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	22,	0.5 },	-- Explosive Shot
		{ 191433,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	23,	0.5 },	-- Explosive Trap
		{ 5384,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	24,	0.5 },	-- Feign Death
		{ 202800,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	25,	0.5 },	-- Flanking Strike
		{ 1543,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	26,	0.5 },	-- Flare
		{ 187650,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	27,	0.5 },	-- Freezing Trap
		{ 190925,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	28,	0.5 },	-- Harpoon
		{ 19577,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	29,	0.5 },	-- Intimidation
		{ 34026,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	30,	0.5 },	-- Kill Command
		{ 185855,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	31,	0.5 },	-- Lacerate
		{ 34477,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	32,	0.5 },	-- Misdirection
		{ 190928,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	33,	0.5 },	-- Mongoose Bite
		{ 187707,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	34,	0.5 },	-- Muzzel
		{ 198670,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	35,	0.5 },	-- Piercing Shot
		{ 206817,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	36,	0.5 },	-- Sentinel
		{ 214579,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	37,	0.5 },	-- Sidewinders
		{ 201078,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	38,	0.5 },	-- Snake Hunter
		{ 194407,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	39,	0.5 },	-- Spitting Cobra
		{ 201430,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	40,	0.5 },	-- Stampede
		{ 191241,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	41,	0.5 },	-- Sticky Bomb
		{ 187698,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	42,	0.5 },	-- Tar Trap
		{ 200163,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	43,	0.5 },	-- Throwing Axes
		{ 193526,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	44,	0.5 },	-- True Shot
		{ 19386,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	45,	0.5 },	-- Wyvern Sting
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 136,		nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Mend Pet
		{ 186265,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Aspect of the Turtle
		{ 186257,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Aspect of the Cheetah
		{ 186258,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Aspect of the Cheetah
		{ 186289,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Aspect of the Eagle
		{ 19574,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Bestial Wrath
		{ 118455,	nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Beast Cleave
		{ 193530,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	-- Aspect of the Wild
		{ 201430,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	  9,	0.5 },	-- Stampede
		{ 82921,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	10,	0.5 },	-- Bombardment
		{ 199483,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,	11,	0.5 },	--	Camouflage
		{ 120694,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 12,	0.5 },	--	Dire Beast
		{ 217200,	nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 13,	0.5 },	--	Dire Frenzy
		{ 5384,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 14,	0.5 },	--	Feign Death
		{ 19577,	nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 15,	0.5 },	--	Intimidation
		{ 34477,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 16,	0.5 },	--	Misdirection
		{ 35079,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 17,	0.5 },	--	Misdirection
		{ 190931,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 18,	0.5 },	--	Mongoose Bite
		{ 194407,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 19,	0.5 },	--	Spitting Cobra
		{ 193526,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 20,	0.5 },	--	True Shot
		{ 201081,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 21,	0.5 },	--	Way of the Mok'Nathal
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 131894,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	A Murder of Crows
		{ 206505,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	A Murder of Crows
		{ 194599,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Black Arrow
		{ 194279,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Caltrops
		{ 5116,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Concussive Shot
		{ 194858,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Dragonsfire Grenage
		{ 13812,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Explosive Trap
		{ 3355,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Freezing Trap
		{ 185365,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Hunters Mark
		{ 24394,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 10,	0.5 },	--	Intimidation
		{ 185855,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 11,	0.5 },	--	Lacerate
		{ 200108,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 12,	0.5 },	--	Rangers Net
		{ 206755,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 13,	0.5 },	--	Rangers Net
		{ 118253,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 14,	0.5 },	--	Serpent Sting
		{ 162487,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 15,	0.5 },	--	Steel Trap
		{ 162480,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 16,	0.5 },	--	Steel Trap
		{ 191241,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 17,	0.5 },	--	Sticky Bomb
		{ 187131,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 18,	0.5 },	--	Vulnerable
		{ 195645,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 19,	0.5 },	--	Wing Clip
		{ 19386,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1, 20,	0.5 },	--	Wyvern Sting
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
	["201430"] = { nil, 0, 12.5 },	-- Stampede
}

--
-- Alerts
--

ClassMods.pethealthtexture = select(3, GetSpellInfo(136)) -- Mend Pet
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	["Pet Health Alert"] 		= { enabled = true, alerttype = "PETHEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "pet", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(194594))] = { -- Lock and Load
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 194594,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(223138))] = { -- Marking Targets
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 223138,
		target = "player",
		sparkles = true,
	},
	[select(1, GetSpellInfo(185791))] = { -- Wild Call
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 185791,
		target = "player",
		sparkles = true,
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
	[select(1, GetSpellInfo(34477))] = { -- Misdirection
		enabled = true,
		spellid = 34477,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(109248))] = {  -- Binding Shot
		enabled = true,
		spellid = 109248,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(34477)) -- Misdirection

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
	{ 187650,	true,	3355,	60,	30 },	-- Freezing Trap
	{ 162488,	true,	162480, 30,	30 }, -- Steel Trap
	{ 19386,	true,	19386,	30,	30 }, -- Wyvern Sting
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