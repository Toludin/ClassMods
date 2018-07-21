--
-- Class Mods - Rogue settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "ROGUE") then return end

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
	[1] = { -- Assasination
	--	{ 1,      	2,          	3,      4,        5,            6, 								7		   }, -- index
		{ true,		1329,		true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Mutilate
		{ true,		32645,		true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Envenom
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
	},
	[2] = { -- Outlaw
		{ true,		193315,	true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Saber Slash
		{ true,		193316,	true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Roll the Bones
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
	},
	[3] = { -- Subtlety
		{ true,		53,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Backstab
		{ true,		196819,	true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false }, -- Eviscerate
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
		{ false,	nil,			true, false, {1,1,1,1}, SPELL_POWER_ENERGY, false },
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Assasination
	--	{ 1,			2,		3,								   }, -- index
		{ 1329,		55,	SPELL_POWER_ENERGY }, -- Mutilate
		{ 1943,		25,	SPELL_POWER_ENERGY }, -- Rupture
		{ 16551,	30,	SPELL_POWER_ENERGY }, -- Hemorrhage
		{ 32645,	35,	SPELL_POWER_ENERGY }, -- Envenom
		{ 51723,	35,	SPELL_POWER_ENERGY }, -- Fan of Knives
		{ 185565,	40,	SPELL_POWER_ENERGY }, -- Poisoned Knife
		{ 703,		45,	SPELL_POWER_ENERGY }, -- Garrote
		{ 1966,		20,	SPELL_POWER_ENERGY }, -- Feint
		{ 152150,	25,	SPELL_POWER_ENERGY }, -- Death from Above
		{ 6770,		35,	SPELL_POWER_ENERGY }, -- Sap
		{ 408,		25,	SPELL_POWER_ENERGY }, -- Kidney Shot
	},
	[2] = { -- Outlaw
		{ 1776,		25,	SPELL_POWER_ENERGY }, -- Gouge
		{ 193316,	25,	SPELL_POWER_ENERGY }, -- Roll the Bones
		{ 5171,		25,	SPELL_POWER_ENERGY }, -- Slice and Dice
		{ 196937,	30,	SPELL_POWER_ENERGY }, -- Ghostly Strike
		{ 199804,	35,	SPELL_POWER_ENERGY }, -- Between the Eyes
		{ 2098,		35,	SPELL_POWER_ENERGY }, -- Run Through
		{ 185763,	40,	SPELL_POWER_ENERGY }, -- Pistol Shot
		{ 193315,	50,	SPELL_POWER_ENERGY }, -- Saber Slash
		{ 8676,		60,	SPELL_POWER_ENERGY }, -- Ambush
		{ 1966,		20,	SPELL_POWER_ENERGY }, -- Feint
		{ 152150,	25,	SPELL_POWER_ENERGY }, -- Death from Above
		{ 6770,		35,	SPELL_POWER_ENERGY }, -- Sap
	},
	[3] = { -- Subtlety
		{ 195452,	25,	SPELL_POWER_ENERGY }, -- Nightblade
		{ 206237,	30,	SPELL_POWER_ENERGY }, -- Enveloping Shadows
		{ 53,			35,	SPELL_POWER_ENERGY }, -- Backstab
		{ 196819,	35,	SPELL_POWER_ENERGY }, -- Eviscerate
		{ 197835,	35,	SPELL_POWER_ENERGY }, -- Shuriken Storm
		{ 200758,	35,	SPELL_POWER_ENERGY }, -- Gloomblade
		{ 185438,	40,	SPELL_POWER_ENERGY }, -- Shadowstrike
		{ 114014,	40,	SPELL_POWER_ENERGY }, -- Shuriken Toss
		{ 1966,		20,	SPELL_POWER_ENERGY }, -- Feint
		{ 152150,	25,	SPELL_POWER_ENERGY }, -- Death from Above
		{ 6770,		35,	SPELL_POWER_ENERGY }, -- Sap
		{ 408,		25,	SPELL_POWER_ENERGY }, -- Kidney Shot
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
	[1] = { -- Assasination
	--	{ 1,			2,			3,				4,	5, 			6				}, -- index
		{ true,		200803, "target",	5,	"AtMax",	"aura"		}, --  Agonizing Poison
	},
	[2] = { -- Outlaw
		{ true,		193316, "player",	6, "Always",	"aura"		}, -- Roll the Bones (number of buffs)
	},
	[3] = { -- Subtlety
		{ true,		185313, "player",	3, "AtMax",	"charge"	}, -- Shadow Dance
	},
}

ClassMods.rollTheBones = { 
	193357, -- Shark Infested Waters
	193358, -- Grand Melee
	193359, -- True Bearing
	193356, -- Broadsides
	199603, -- Jolly Roger
	199600, -- Buried Treasure
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
		{ 31224,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Cloak of Shadows
		{ 185311,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Crimson Vial
		{ 1725,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Distract
		{ 5277,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Evasion
		{ 703,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Garrote
		{ 1766,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Kick
		{ 408,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Kidney Shot
		{ 36554,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Shadowstep
		{ 2983,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Sprint
		{ 57934,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   0,	0.5 },	--	Tricks of the Trade
		{ 1856,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Vanish
		{ 79140,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Vendetta
		{ 200806,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Exsanguinate
		{ 137619,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Marked for Death
		{ 152150,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Death from Above
		{ 13750,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Adrenaline Rush
		{ 199804,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Between the Eyes
		{ 13877,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Blade Flurry
		{ 2094,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Blind
		{ 199740,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Bribe
		{ 1776,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Gouge
		{ 199754,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Riposte
		{ 195457,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Grappling Hook
		{ 199743,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Parley
		{ 185767,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Cannonball Barrage
		{ 51690,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Killing Spree
		{ 121471,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Shadow Blades
		{ 185313,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Shadow Dance
		{ 212283,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Symbols of Death
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 31224,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Cloak of Shadows
		{ 185311,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Crimson Vial
		{ 32645,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Envenom
		{ 5277,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Evasion
		{ 1966,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Feint
		{ 2823,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Deadly Poison
		{ 3408,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Crippling Poison
		{ 8679,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Wound Poison
		{ 2983,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Sprint
		{ 57934,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Tricks of the Trade
		{ 11327,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Vanish
		{ 193641,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Elaborate Planning
		{ 115192,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Subterfuge
		{ 108211,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Leeching Poison
		{ 45182,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Cheat Death
		{ 45181,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Cheat Death
		{ 200802,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Agonizing Poison
		{ 193538,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Alacrity
		{ 13750,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Adrenaline Rush
		{ 199754,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Riposte
		{ 193357,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Shark Infested Waters
		{ 193358,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Grand Melee
		{ 193359,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	True Bearing
		{ 193356,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Broadsides
		{ 199603,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Jolly Roger
		{ 199600,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Buried Treasure
		{ 51690,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Killing Spree
		{ 5171,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Slice and Dice
		{ 121471,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Shadow Blades
		{ 185422,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Shadow Dance
		{ 212283,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Symbols of Death
		{ 227151,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   32,	0.5 },	--	Death
		{ 195627,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   33,	0.5 },	-- Opportunity
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 1833,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Cheap Shot
		{ 703,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Garrote
		{ 408,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Kidney Shot
		{ 2818,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Deadly Poison
		{ 3409,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Crippling Poison
		{ 8680,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Wound Poison
		{ 1943,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Rupture
		{ 6770,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Sap
		{ 57934,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Tricks of the Trade
		{ 79140,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Vendetta
		{ 16511,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Hemorrhage
		{ 154953,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Internal Bleeding
		{ 200803,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Agonizing Poison
		{ 199804,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Between the Eyes
		{ 2094,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Blind
		{ 199740,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Bribe
		{ 1776,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Gouge
		{ 185763,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Pistol Shot
		{ 196937,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Ghostly Strike
		{ 199743,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Parley
		{ 195452,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Nightblade
		{ 206760,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Night Terrors
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

ClassMods.pethealthtexture = select(3, GetSpellInfo(199740)) -- Bribe
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	["Pet Health Alert"] 		= { enabled = true, alerttype = "PETHEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "pet", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(45182))] = { -- Cheat Death (Damage Reduction buff)
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 45182,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(193359))] = { -- True Bearing (Roll the Bones)
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 193359,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(13877))] = { -- Blade Flurry
		enabled = true,
		alerttype = "BUFF",
		enablesound = false,
		sound = "None",
		aura = 13877,
		target = "player",
		sparkles = false
	},
	[select(1, GetSpellInfo(195627))] = { -- Opportunity
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 195627,
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
	[select(1, GetSpellInfo(57934))] = { -- Tricks of the Trade
		enabled = true,
		spellid = 57934,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(45182))] = {  -- Cheat Death
		enabled = true,
		spellid = 45182,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(57934)) -- Tricks of the Trade

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
--	{ 1,			2,		 3,			4,		5   }, -- index
	{ 199743,	true, 199743,	300,	30 },	-- Parley
	{ 199740,	true, 199740,	300,	30 },	-- Bribe
	{ 6770,		true, 6770,		60,	30 },	-- Sap
	{ 2094,		true, 2094,		60,	30 },	-- Blind
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

ClassMods.enableTotems = false