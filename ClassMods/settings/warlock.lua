--
-- Class Mods - Warlock settings
--

-- Check the player's class before creating these settings
if (select(2, UnitClass("player")) ~= "WARLOCK") then return end

--
-- ResourceBar Module
--

ClassMods.enableprediction = false
ClassMods.powerGenerationSpells = {nil, nil, nil}
ClassMods.highwarn = false

--
-- ResourceBar: Tick Marks
--

ClassMods.enableticks = false

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
	[1] = { -- Affliction
	--	{ 1,       2,    3,     4,        5,            6, 							  7       },	-- index
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
	},
	[2] = { -- Demonology
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
	},
	[3] = { -- Destruction
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
		{ false, nil, true, false, {1,1,1,1}, SPELL_POWER_MANA, false },
	},
}

--[[
ClassMods.classSpells
	1: spellID
	2: cost
	3: power type
--]]

ClassMods.classSpells = {}

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
	[1] = { -- Affliction
	--	{ 1,			2,				3,				4,	5, 			6				}, -- index
		{ false,	nil,			nil,			0,	nil,			nil			},
	},
	[2] = { -- Demonology
		{ true,		205181,	"player",	2, "AtMax",	"charge"	}, -- Shadowflame
	},
	[3] = { -- Destruction
		{ true,		17962,		"player",	2,	"AtMax",	"charge"	}, -- Conflagrate
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
		{ 119905,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Cauterize Master (pet)
		{ 170995,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Cripple (pet)
		{ 171017,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Meteor Strike (pet)
		{ 6358,		nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Seduction (pet)
		{ 171138,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Shadow Lock (pet)
		{ 89808,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Singe Magic (pet)
		{ 119898,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Spell Lock (pet)
		{ 119907,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Suffering (pet)
		{ 119909,	nil,	"pet",		"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Whiplash (pet)
		{ 17962,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Conflagrate
		{ 205181,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Shadowflame
		{ 20707,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Soulstone
		{ 18540,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Summon Doomguard
		{ 1122,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Summon Infernal
		{ 104316,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Call Dreadstalkers
		{ 152108,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Cataclysm
		{ 196447,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Channel Demonfire
		{ 108416,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Dark Pact
		{ 48020,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Demonic Circle
		{ 89751,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Felstorm
		{ 108503,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Grimoire of Sacrafice
		{ 48181,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Haunt
		{ 80240,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   23,	0.5 },	--	Havoc
		{ 5484,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   24,	0.5 },	--	Howl of Terror
		{ 6789,		nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   25,	0.5 },	--	Mortal Coil
		{ 205179,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   26,	0.5 },	--	Phantom Singularity
		{ 30283,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   27,	0.5 },	--	Shadowfury
		{ 196098,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   28,	0.5 },	--	Soul Harvest
		{ 104773,	nil,	"player",	"COOLDOWN",	"PLAYERS",	0,	"CENTER",	nil,	true,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   29,	0.5 },	--	Unending Resolve
	},
	["timerbar2"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 193396,	nil,	"pet",		"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Demonic Empowerment (pet)
		{ 205146,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Demonic Calling
		{ 171982,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Grimoire of Synergy
		{ 117828,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Backdraft
		{ 119899,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Cauterize Master
		{ 108416,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Dark Pact
		{ 48018,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Demonic Circle
		{ 196099,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Demonic Power
		{ 196104,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Mana Tap
		{ 196606,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Shadowy Inspiration
		{ 196098,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Soul Harvest
		{ 108366,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Soul Leech
		{ 104773,	nil,	"player",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Unending Resolve
	},
	["timerbar3"] = {
	--	{ 1,			2,		3,				4,					5,					6,	7,				8,		9,		10,	11,	12,	13,	14,  15,16, 17, 18,	19,	20  },	-- Index
		{ 205181,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   1,	0.5 },	--	Shadowflame
		{ 118699,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   2,	0.5 },	--	Fear
		{ 5484,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   3,	0.5 },	--	Howl of Terror
		{ 170995,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   4,	0.5 },	--	Cripple
		{ 710,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   5,	0.5 },	--	Banish
		{ 6358,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   6,	0.5 },	--	Seduction
		{ 1098,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   7,	0.5 },	--	Enslave Demon
		{ 17735,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   8,	0.5 },	--	Suffering
		{ 980,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   9,	0.5 },	--	Agony
		{ 146739,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   10,	0.5 },	--	Corruption
		{ 603,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   11,	0.5 },	--	Doom
		{ 196414,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   12,	0.5 },	--	Eradication
		{ 48181,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   13,	0.5 },	--	Haunt
		{ 80240,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   14,	0.5 },	--	Havoc
		{ 157736,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   15,	0.5 },	--	Immolate
		{ 6789,		nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   16,	0.5 },	--	Mortal Coil
		{ 205179,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   17,	0.5 },	--	Phantom Singularity
		{ 27243,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   18,	0.5 },	--	Seed of Corruption
		{ 30283,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   19,	0.5 },	--	Shadowfury
		{ 63106,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   20,	0.5 },	--	Siphon Life
		{ 20707,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   21,	0.5 },	--	Soulstone
		{ 30108,	nil,	"target",	"DURATION",	"PLAYERS",	0,	"CENTER",	nil,	nil,	nil,	nil,	nil,	nil,	0.4,	1,	0,	nil,	1,   22,	0.5 },	--	Unstable Affliction
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
-- [ 1]              2,   3,  4   }, -- index
	["5740"]	= { nil, 0, 7.5	}, -- Rain of Fire
	["18540"]	= { nil, 0, 25.5	}, --	Summon Doomguard
	["1122"]	= { nil, 0, 25.5	}, --	Summon Infernal
}

--
-- Alerts
--

ClassMods.pethealthtexture = select(3, GetSpellInfo(755)) -- Health Funnel
ClassMods.alertDefaults = {
	["Player Health Alert"]	= { enabled = true, alerttype = "HEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "player", sparkles = true, healthpercent = 0.3 },
	["Pet Health Alert"] 		= { enabled = true, alerttype = "PETHEALTH", enablesound = true, sound = "Raid Warning", aura = "", target = "pet", sparkles = true, healthpercent = 0.3 },
	[select(1, GetSpellInfo(205146))] = { -- Demonic Calling
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 205146,
		target = "player",
		sparkles = true
	},
	[select(1, GetSpellInfo(171982))] = { -- Grimoire of Synergy
		enabled = true,
		alerttype = "BUFF",
		enablesound = true,
		sound = "Ding",
		aura = 171982,
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
	[select(1, GetSpellInfo(20707))] = { -- Soulstone
		enabled = true,
		spellid = 20707,
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

ClassMods.clickToCastDefault = select(1, GetSpellInfo(20707)) -- Soulstone

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
--	{ 1,			2,		 3,	  		4,		5		}, -- index
	{ 5782,		true, 118699,	20,	20	}, --	Fear
	{ 5484,		true, 5484,		20, 	20	}, -- Howl of Terror
	{ 170995,	true, 170995,	30, 	4		}, -- Cripple
	{ 710,		true, 710,			30, 	30	}, -- Banish
	{ 6358,		true, 6358,		30, 	30	}, -- Seduction
	{ 1098,		true, 1098,		300, 	30	}, -- Enslave Demon
}

--
-- Dispel
--

ClassMods.enableDispel = true
ClassMods.dispelTexture = select(3, GetSpellInfo(19505)) -- Devour Magic

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
	{ true, 205178,	600	}, --	Soul Effigy
	{ true, 104316,	12	}, --	Call Dreadstalkers
	{ true, 105174,	12	}, --	Hand of Gul'dan
	{ true, 205180,	12	}, --	Summon Darkglare
}