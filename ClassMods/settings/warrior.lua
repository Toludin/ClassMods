--
-- Class Mods - Warrior settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "WARRIOR") then return end

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
	[1] = { -- Arms
	--	{ 1,      	2,          	3,      	4,        5,            6, 							  7       },	-- index
		{ true,		12294,		true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },	-- Mortal Strike
		{ true,		163201,	true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },	-- Execute
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
	},
	[2] = { -- Fury
		{ true,		5308,		true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false }, -- Execute
		{ true,		184367,	false,	false, {1,1,1,1}, SPELL_POWER_RAGE, false }, -- Rampage
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
	},
	[3] = { -- Protection
		{ true,		204488,	true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false }, -- Focused Rage
		{ true,		190456,	true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false }, -- Ignore Pain
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
		{ false,	nil,			true,	false, {1,1,1,1}, SPELL_POWER_RAGE, false },
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {
	[1] = { -- Arms
	--	{ 1,			2,	 3,							 }, -- index
		{ 845,		10, SPELL_POWER_RAGE }, --	Cleave
		{ 1715,		10, SPELL_POWER_RAGE }, --	Hamstring
		{ 7384,		10, SPELL_POWER_RAGE }, --	Overpower
		{ 163201,	40, SPELL_POWER_RAGE }, --	Execute
		{ 207982,	15, SPELL_POWER_RAGE }, --	Focused Rage
		{ 772,		15, SPELL_POWER_RAGE }, --	Rend
		{ 1464,		15, SPELL_POWER_RAGE }, --	Slam
		{ 12294,	20, SPELL_POWER_RAGE }, --	Mortal Strike
		{ 1680,		25, SPELL_POWER_RAGE }, --	Whirlwind
	},
	[2] = { -- Fury
		{ 12323,	10, SPELL_POWER_RAGE }, -- Piercing Howl
		{ 5308,		25, SPELL_POWER_RAGE }, -- Execute
		{ 184367,	85, SPELL_POWER_RAGE }, -- Rampage
	},
	[3] = { -- Protection
		{ 202168,	10, SPELL_POWER_RAGE }, --	Impending Victory
		{ 2565,		10, SPELL_POWER_RAGE }, --	Shield Block
		{ 190456,	60, SPELL_POWER_RAGE }, --	Ignore Pain
		{ 204488,	30, SPELL_POWER_RAGE }, --	Focused Rage
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
	[1] = { -- Arms
	--	{ 1,			2,				3,			 4, 5, 			6				}, -- index
		{ true,		100,			"player", 2, "AtMax",	"charge"	}, -- Charge
		{ false,	12294,		"player", 2, "AtMax",	"charge"	}, -- Mortal Strike
		{ false,	207982,	"player", 3, "AtMax",	"aura"		}, -- Focused Rage

	},
	[2] = { -- Fury
		{ false,	100,			"player", 2, "AtMax",	"charge"	}, -- Charge
		{ true,		206333,	"player", 6, "AtMax",	"aura"		}, -- Taste for Blood
		{ false,	202539,	"player", 3, "AtMax",	"aura"		}, -- Frenzy
	},
	[3] = { -- Protection
		{ true,		204488,	"player", 3, "AtMax",	"aura"		}, --	Focused Rage
		{ false,	198304,	"player", 2, "AtMax",	"charge"	}, --	Intercept
		{ false,	202602,	"player", 5, "AtMax",	"aura"		}, --	Into the Fray
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
		{ 107574,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Avatar
		{ 1719,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Battle Cry
		{ 18499,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Berserker Rage
		{ 227847,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Bladestorm (Arms)
		{ 46924,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Bladestorm (Fury)
		{ 12292,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Bloodbath
		{ 23881,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Bloodthirst
		{ 100,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Charge
		{ 845,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Cleave
		{ 167105,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Colossus Smash
		{ 97462,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Commanding Shout
		{ 1160,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Demoralizing Shout
		{ 118038,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Die by the Sword
		{ 118000,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Dragon Roar
		{ 184364,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Enraged Regeneration
		{ 204488,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Focused Rage
		{ 6544,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Heroic Leap
		{ 57755,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Heroic Throw
		{ 202168,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Impending Victory
		{ 198304,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Intercept
		{ 5246,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Intimidating Shout
		{ 12975,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Last Stand
		{ 12294,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Mortal Strike
		{ 6552,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Pummel
		{ 85288,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Raging Blow
		{ 152277,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Ravager (Arms)
		{ 6572,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Revenge
		{ 2565,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Shield Block
		{ 23922,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Shield Slam
		{ 871,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Shield Wall
		{ 46968,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Shockwave
		{ 23920,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   32,	0.5 },	--	Spell Reflection
		{ 107570,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   33,	0.5 },	--	Storm Bolt
		{ 355,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   34,	0.5 },	--	Taunt
		{ 6343,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   35,	0.5 },	--	Thunder Clap
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 107574,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Avatar
		{ 1719,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Battle Cry
		{ 18499,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Berserker Rage
		{ 12292,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Bloodbath
		{ 202164,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Bounding Strides
		{ 97463,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Commanding Shout
		{ 125565,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Demoralizing Shout
		{ 118038,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Die by the Sword
		{ 118000,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Dragon Roar
		{ 184362,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Enrage
		{ 184364,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Enraged Regeneration
		{ 207982,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Focused Rage
		{ 202539,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Frenzy
		{ 215572,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Frothing Berserker
		{ 202225,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Furious Charge
		{ 190456,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Ignore Pain
		{ 12975,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Last Stand
		{ 206316,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Massacre
		{ 60503,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Overpower!
		{ 227876,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Ravager (Arms)
		{ 202289,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Renewed Fury
		{ 132404,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Shield Block
		{ 224324,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Shield Slam!
		{ 871,		nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Shield Wall
		{ 23920,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Spell Reflection
		{ 206333,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Taste for Blood
		{ 122510,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Ultimatum
		{ 202573,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Vengence: Focused Rage
		{ 202574,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   30,	0.5 },	--	Vengence: Ignore Pain
		{ 32216,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   31,	0.5 },	--	Victory Rush
		{ 215562,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   32,	0.5 },	--	War Machine
		{ 215570,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   33,	0.5 },	--	Wrecking Ball
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 113344,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Bloodbath
		{ 208086,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Colossus Smash
		{ 115767,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Deep Wounds
		{ 1160,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Demoralizing Shout
		{ 147833,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Intercept
		{ 5246,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Intimidating Shout
		{ 115804,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Mortal Wounds
		{ 12323,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Piercing Howl
		{ 772,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Rend
		{ 223658,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Safeguard
		{ 132168,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Shockwave
		{ 132169,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Storm Bolt
		{ 6343,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Thunder Clap
		{ 215537,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Trauma
		{ 1715,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Hamstring
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

ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(184362))] = { -- Enrage
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 184362,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(215572))] = { -- Frothing Berserker
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 215572,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(206316))] = { -- Massacre
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 206316,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(60503))] = { -- Overpower!
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 60503,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(122510))] = { -- Ultimatum 
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 122510,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(32216))] = { -- Victory Rush
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 32216,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(215562))] = { -- War Machine
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 215562,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(215570))] = { -- Wrecking Ball
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 215570,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(202573))] = { -- Vengence: Focused Rage
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 202573,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(202574))] = { -- Vengence: Ignore Pain
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 202574,
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
	[select(1, GetSpellInfo(97462))] = { -- Commanding Shout
		enabled = true,
		spellid = 97462,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(12975))] = { -- Last Stand
		enabled = true,
		spellid = 12975,
		announceend = true,
		solochan = "AUTO",
		partychan = "AUTO",
		raidchan = "AUTO",
		arenachan = "AUTO",
		pvpchan = "AUTO",
	},
	[select(1, GetSpellInfo(871))] = { -- Shield Wall
		enabled = true,
		spellid = 871,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(198304)) -- Intercept (Protection)

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
ClassMods.enableCrowdControl = false
ClassMods.crowdControlSpells = {}

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