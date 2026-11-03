doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_UNICORN_HORN_BOW,
	ARTIFACT_PLATE_MAIL_OF_STABILITY,
	ARTIFACT_PEDANT_OF_MASTERY,
	ARTIFACT_RING_OF_LIFE,
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M3");
    LoadHeroAllSetArtifacts( "Heam", "C5M2" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Heam" );
end

startThread(H55_InitSetArtifacts);

for a = 43,54 do
	SetObjectDwellingCreatures("Siris", a , 0);
end
print("9");
C5M3_ENEMY_ARMY = {
	n = 3,
	idx = 1,
	list = { "Nemor", "Gles", "Nimbus" }, -- added Nimbus to have a different class to deal since Deirdre is a nethermage and Kaspar a death knight

	alive = function()
		for i = 1,C5M3_ENEMY_ARMY.n do
			if IsHeroAlive(C5M3_ENEMY_ARMY.list[i]) ~= nil then
				return not nil;
			end
		end
		return nil;
	end,

	getCurrent = function()
		local i = C5M3_ENEMY_ARMY.idx;
		if i < C5M3_ENEMY_ARMY.n then
			C5M3_ENEMY_ARMY.idx = i + 1;
		else
			C5M3_ENEMY_ARMY.idx = 1;
		end
		return C5M3_ENEMY_ARMY.list[i];
	end,

	Nemor = function(week)
		AddObjectCreatures("Nemor", CREATURE_SKELETON, (1 + (dif + week) * 60) + 15 * dif);
		AddObjectCreatures("Nemor",	  CREATURE_ZOMBIE, (1 + (dif + week) * 45) + 10 * dif);
		AddObjectCreatures("Nemor",    CREATURE_MANES, (1 + (dif + week) * 23) + 7 * dif);
		AddObjectCreatures("Nemor",  CREATURE_VAMPIRE, (1 + (dif + week) *  9) + 5 * dif);
		AddObjectCreatures("Nemor",     CREATURE_LICH, (1 + (dif + week) *  7) + 2 * dif);
		if GetDifficulty() > 0 then
		    sleep(3); -- required to restore her mana
			ChangeHeroStat("Nemor", STAT_MANA_POINTS, 200);
			sleep(3);
			GiveHeroWarMachine("Nemor", WAR_MACHINE_AMMO_CART);
			GiveHeroWarMachine("Nemor", WAR_MACHINE_BALLISTA);
			GiveHeroWarMachine("Nemor", WAR_MACHINE_FIRST_AID_TENT);
		end
	end,

	Gles = function(week)
		AddObjectCreatures("Gles", 		  CREATURE_SKELETON, (1 + (dif + week) * 60) + 15 * dif);
		AddObjectCreatures("Gles", CREATURE_SKELETON_ARCHER, (1 + (dif + week) * 50) + 15 * dif);
		AddObjectCreatures("Gles", 			CREATURE_ZOMBIE, (1 + (dif + week) * 40) + 7 * dif);
		AddObjectCreatures("Gles", 			 CREATURE_GHOST, (1 + (dif + week) * 22) + 6 * dif);
		AddObjectCreatures("Gles", 			  CREATURE_LICH, (1 + (dif + week) *  7) + 2 * dif);
		if GetDifficulty() > 0 then
		    sleep(3); -- required to restore his mana
			ChangeHeroStat("Gles", STAT_MANA_POINTS, 200);
			sleep(3);
			GiveHeroWarMachine("Gles", WAR_MACHINE_AMMO_CART);
			GiveHeroWarMachine("Gles", WAR_MACHINE_BALLISTA);
			GiveHeroWarMachine("Gles", WAR_MACHINE_FIRST_AID_TENT);
		end
	end,

	Nimbus = function(week)
		AddObjectCreatures("Nimbus", CREATURE_SKELETON_WARRIOR, (1 + (dif + week) * 70) + 15 * dif);
		AddObjectCreatures("Nimbus",  CREATURE_SKELETON_ARCHER, (1 + (dif + week) * 65) + 15 * dif);
		AddObjectCreatures("Nimbus",		   CREATURE_ZOMBIE, (1 + (dif + week) * 35) + 7 * dif);
		AddObjectCreatures("Nimbus",		CREATURE_NOSFERATU, (1 + (dif + week) *  7) + 4 * dif);
		AddObjectCreatures("Nimbus",	  CREATURE_LICH_MASTER, (1 + (dif + week) *  5) + 2 * dif);
		if GetDifficulty() > 0 then
		    sleep(3); -- required to restore his mana
			ChangeHeroStat("Nimbus", STAT_MANA_POINTS, 200);
			sleep(3);
			GiveHeroWarMachine("Nimbus", WAR_MACHINE_AMMO_CART);
			GiveHeroWarMachine("Nimbus", WAR_MACHINE_BALLISTA);
			GiveHeroWarMachine("Nimbus", WAR_MACHINE_FIRST_AID_TENT);
		end
		if GetDifficulty() > 2 then
			TeachHeroSpell("Nimbus", SPELL_BERSERK);
		end
	end
}
print("8");
H55c_AI_CONTROLLED = {
	player1 = {
		state = 0,       -- 0 human
		heroes = {},
		enemies = {},
	},

	player2 = { 		     -- Teal Necropolis AI player unmanaged
		state = 1,
		heroes = {},
		enemies = {}
	},

	player3 = { 		     -- Purple Necropolis AI player - managed with specific purposes
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 0.1, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
		}
	}
}
print("7");
function attack(town)
	local hero = C5M3_ENEMY_ARMY.getCurrent();
	local week = GetDate(MONTH)*4 - 4 + GetDate(WEEK);
	if IsHeroAlive(hero) == nil then
		DeployReserveHero(hero, RegionToPoint("Start"));
		sleep ( 20 );
		local exp = GetHeroStat(hero, STAT_EXPERIENCE);
		if GetHeroStat(hero, STAT_EXPERIENCE) < GetHeroStat("Heam", STAT_EXPERIENCE) then
			ChangeHeroStat(hero, STAT_EXPERIENCE , exp + (1000*week) + (2500 * GetDifficulty() * week));
			AddObjectCreatures(hero, CREATURE_SHADOW_DRAGON, 1 + 1 * week * dif);
		end
		C5M3_ENEMY_ARMY[hero](week);
		SetAIHeroAttractor(town,hero,2);
		SetAIPlayerAttractor(town, GetObjectOwner(hero), 2);
		H55c_AIAddHero(hero);
	end
end
print("6");
DIFFICULTY = {
	[0] = function()
		dif = 0;
		print ("Normal");
		AddObjectCreatures("Heam", CREATURE_SPRITE, 70);
		AddObjectCreatures("Heam", CREATURE_WAR_DANCER, 55);
		AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 40);
		AddObjectCreatures("Heam", CREATURE_DRUID_ELDER, 30);
		AddObjectCreatures("Heam", CREATURE_WAR_UNICORN, 23);
		AddObjectCreatures("Heam", CREATURE_TREANT_GUARDIAN, 15);
	end,

	[1] = function()
		dif = 1;
		print ("Hard");
		AddObjectCreatures("Heam", CREATURE_SPRITE, 50);
		AddObjectCreatures("Heam", CREATURE_WAR_DANCER, 40);
		AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 30);
		AddObjectCreatures("Heam", CREATURE_DRUID_ELDER, 22);
		AddObjectCreatures("Heam", CREATURE_WAR_UNICORN, 16);
	end,

	[2] = function()
		dif = 2;
		print ("Heroic");
		AddObjectCreatures("Heam", CREATURE_SPRITE, 30);
		AddObjectCreatures("Heam", CREATURE_WAR_DANCER, 25);
		AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
		AddObjectCreatures("Heam", CREATURE_DRUID_ELDER, 15);
		AddObjectCreatures("Heam", CREATURE_WAR_UNICORN, 10);
	end,

	[3] = function()
		dif = 3;
		print ("Impossible");
	end,
}
print("5");
local extra = GetDifficulty() + 1
if extra > 1 then
    GiveExp("Aberrar", 19400); -- level 10 -> 15
	GiveExp("Straker", 19400); -- level 10 -> 15
	AddObjectCreatures("T-prisoner_guards", CREATURE_LICH_MASTER, 20 * GetDifficulty());
	AddObjectCreatures("T-prisoner_guards", CREATURE_WIGHT, 15 * GetDifficulty());
	AddObjectCreatures("T-prisoner_guards", CREATURE_BONE_DRAGON, 10 * GetDifficulty());
	AddObjectCreatures("D-prisoner_guards1", CREATURE_RAKSHASA, 35 * GetDifficulty());
	AddObjectCreatures("D-prisoner_guards1", CREATURE_MASTER_GENIE, 45 * GetDifficulty());
	AddObjectCreatures("D-prisoner_guards2", CREATURE_LICH, 35 * GetDifficulty());
	AddObjectCreatures("D-prisoner_guards2", CREATURE_WIGHT, 30 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_SKELETON_ARCHER, 150 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_ZOMBIE, 100 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_GHOST, 75 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_VAMPIRE_LORD, 35 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_DEMILICH, 25 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_WRAITH, 15 * GetDifficulty());
    AddObjectCreatures("T_garrison", CREATURE_SHADOW_DRAGON, 7 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_SKELETON_ARCHER, 110 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_ZOMBIE, 70 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_GHOST, 55 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_VAMPIRE_LORD, 25 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_DEMILICH, 18 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_WRAITH, 11 * GetDifficulty());
    AddObjectCreatures("V_garrison", CREATURE_SHADOW_DRAGON, 5 * GetDifficulty());
end
if extra > 2 then
    GiveExp("Aberrar", 47600); -- level 15 -> 20
	GiveExp("Straker", 47600); -- level 15 -> 20
end
if extra > 3 then
    GiveExp("Aberrar", 118300); -- level 20 -> 25
	GiveExp("Straker", 118300); -- level 20 -> 25
end
print("4");
CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C5/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	captureSiris = function()
		StartDialogScene("/DialogScenes/C5/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	garisonPrepared = function()
		StartDialogScene("/DialogScenes/C5/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	getHeroesStart = function()
		StartDialogScene("/DialogScenes/C5/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	getHeroesFinish = function()
		StartDialogScene("/DialogScenes/C5/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	outro = function()
		StartDialogScene("/DialogScenes/C5/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
}
print("3");
OBJECTIVES = {
	date = 0,
	state = {
		captureSiris	= { "CaptureImarium", 1 },	-- recapture Siris town
		defendSiris		= {  "DefendImarium", 0 },	-- defend Siris town from enemy attacks
		isAlive			= {    "HeamSurvive", 1 },	-- Findan must survive
		prepareGarison	= {       "harrison", 1 },	-- Reinforce the garrison with druids, unicorns and dragons
		getHeroes		= {       "twoheros", 1 }, 	-- Free the two commanders
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		EnableAIHeroHiring(PLAYER_3, "Siris", nil);
		SetRegionBlocked("prison2", 1, 2);
		SetRegionBlocked("prison1", 1, 2);
		SetRegionBlocked("block",   1, 1);
		print('here');
		startThread(DIFFICULTY[GetDifficulty()]);
		print('here2');
		SetPlayerResource(PLAYER_2, GOLD, 30000);
		SetPlayerHeroesCountNotForHire(PLAYER_2, 6);
	end,

	run = function()
		print('here3');
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end

			if GetObjectiveState("HeamSurvive") == OBJECTIVE_FAILED or GetObjectiveState("twoheros") == OBJECTIVE_FAILED or GetObjectiveState("CaptureImarium") == OBJECTIVE_FAILED or GetObjectiveState("DefendImarium") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("harrison") == OBJECTIVE_COMPLETED and GetObjectiveState("twoheros") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped( "Heam", "C5M3");
				--SaveHeroAllSetArtifactsEquipped( "Diraya", "C5M3");
				--SaveHeroAllSetArtifactsEquipped( "Nadaur", "C5M3");
				sleep(50);
				CINEMATICS.outro();
				Win();
				return
			end
		end
	end,

	captureSiris = function()
		if OBJECTIVES.state.captureSiris[2] == 1 then
			BlockGame();
			MoveCamera( 89, 129, 0, 40, 0.925, 0.150, 1, 0 );
			sleep(50);
			EnableHeroAI("Effig", nil);
			MoveHeroRealTime("Effig", 80, 125);
			SetObjectiveState("CaptureImarium", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureSiris[2] = 2;
		elseif OBJECTIVES.state.captureSiris[2] == 2 and GetObjectOwner("Siris") == 3 then
			UnblockGame();
			MoveHeroRealTime("Effig", 80, 125);
			CINEMATICS.intro();
			OBJECTIVES.state.captureSiris[2] = 3;
		elseif OBJECTIVES.state.captureSiris[2] == 3 then
			if OBJECTIVES.date > 7 then
				SetObjectiveState("CaptureImarium", OBJECTIVE_FAILED );
				OBJECTIVES.state.captureSiris[2] = 11;
			elseif GetObjectOwner("Siris") == 1 then
				Save("autosave");
				CINEMATICS.captureSiris();
				Reso = GetPlayerResource(PLAYER_1, GOLD) + 5000;
				SetPlayerResource(PLAYER_1, GOLD, Reso);
				SetObjectiveState("CaptureImarium", OBJECTIVE_COMPLETED );
				OBJECTIVES.state.defendSiris[2] = 1;
				OBJECTIVES.state.captureSiris[2] = 10;
				sleep(10)
			end
		end
	end,

	defendSiris_start = 10000,
	defendSiris_continuous_attack = 0,
	defendSiris = function()
		if OBJECTIVES.state.defendSiris[2] == 1 then
			SetObjectiveState("DefendImarium", OBJECTIVE_ACTIVE);
			startThread(attack, "Siris");
			DeployReserveHero("Jenova", 78, 120, GROUND);
			sleep(20);
			GiveHeroSkill("Jenova", SKILL_LEARNING);
			GiveHeroSkill("Jenova", PERK_SCHOLAR);
			GiveHeroSkill("Jenova", SKILL_LIGHT_MAGIC);
			local experienceByDifficulty = { 6200, 12200, 20600, 34100 }; -- Levels 6, 9, 12, 15
			GiveExp("Jenova", experienceByDifficulty[GetDifficulty() + 1]);
			OBJECTIVES.state.defendSiris[2] = 2;
		elseif OBJECTIVES.state.defendSiris[2] == 2 and IsHeroAlive("Nemor") == nil then
			startThread(attack, "Siris");
			OBJECTIVES.defendSiris_start = GetDate(DAY)+3;
			OBJECTIVES.state.defendSiris[2] = 3;
		elseif OBJECTIVES.state.defendSiris[2] == 3 and GetDate(DAY) >= OBJECTIVES.defendSiris_start and C5M3_ENEMY_ARMY.alive() == nil then
			startThread(attack, "Siris");
			OBJECTIVES.defendSiris_start = OBJECTIVES.defendSiris_start + random(4) + 8 - dif;
			print ("next attack on day ", OBJECTIVES.defendSiris_start);
		end

		if GetObjectOwner("Siris") ~= PLAYER_1 then
			SetObjectiveState("DefendImarium", OBJECTIVE_FAILED );
			OBJECTIVES.state.defendSiris[2] = 11;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState("HeamSurvive", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Heam") == nil then
			SetObjectiveState("HeamSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	prepareGarison_first_play = nil,
	prepareGarison = function()
		if OBJECTIVES.state.prepareGarison[2] == 1 and IsHeroAlive("Nemor") ~= nil then
			OBJECTIVES.state.prepareGarison[2] = 2;
		elseif OBJECTIVES.state.prepareGarison[2] == 2 and IsHeroAlive("Nemor") == nil then
			SetObjectiveState("harrison", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.prepareGarison[2] = 3;
		elseif OBJECTIVES.state.prepareGarison[2] == 3 then
			local hero_at_gate = C5M3_GetHeroAtTownGate("Siris");
			local druids, unicorns, dragons = C5M3_GetGarisonArmy("Siris", hero_at_gate);
			if druids >= 50 and unicorns >= 30 and dragons >= 10 then
				OBJECTIVES.state.prepareGarison[2] = 4;
			else
				OBJECTIVES.state.prepareGarison[2] = 5;
			end
		elseif OBJECTIVES.state.prepareGarison[2] == 4 then
			if GetObjectiveState("harrison") == OBJECTIVE_ACTIVE then
				SetObjectiveState("harrison", OBJECTIVE_COMPLETED);
				if OBJECTIVES.prepareGarison_first_play == nil then
					CINEMATICS.garisonPrepared();
					OBJECTIVES.prepareGarison_first_play = not nil;
					sleep(5);
					LevelUpHero("Heam");
				end
			end
			OBJECTIVES.state.prepareGarison[2] = 3;
		elseif OBJECTIVES.state.prepareGarison[2] == 5 then
			if GetObjectiveState("harrison") == OBJECTIVE_COMPLETED then
				SetObjectiveState("harrison", OBJECTIVE_ACTIVE);
			end
			OBJECTIVES.state.prepareGarison[2] = 3;
		end
	end,

	getHeroes_has_diraya = nil,
	getHeroes_has_nadaur = nil,
	getHeroes = function()
		if OBJECTIVES.state.getHeroes[2] == 1 and IsHeroAlive("Nemor") ~= nil then
			OBJECTIVES.state.getHeroes[2] = 2;
		elseif OBJECTIVES.state.getHeroes[2] == 2 and IsHeroAlive("Nemor") == nil then
			CINEMATICS.getHeroesStart()
			MessageBox("/Maps/Scenario/C5M3/C5M3_2.txt");
			SetObjectiveState("twoheros", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.getHeroes[2] = 3;
		elseif OBJECTIVES.state.getHeroes[2] == 3 then
			local heroes = GetPlayerHeroes(PLAYER_1);
			if table.length(heroes) ~= 0 then
				for i,hero in heroes do
					if hero == "Diraya" then OBJECTIVES.getHeroes_has_diraya = not nil; end
					if hero == "Nadaur" then OBJECTIVES.getHeroes_has_nadaur = not nil; end
				end
			end
			if OBJECTIVES.getHeroes_has_diraya ~= nil and OBJECTIVES.getHeroes_has_nadaur ~= nil then
				CINEMATICS.getHeroesFinish();
				SetObjectiveState("twoheros", OBJECTIVE_COMPLETED );
				sleep(5);
				LevelUpHero("Heam");
				OBJECTIVES.state.getHeroes[2] = 4;
			end
		end

		if OBJECTIVES.getHeroes_has_diraya ~= IsHeroAlive("Diraya") or OBJECTIVES.getHeroes_has_nadaur ~= IsHeroAlive("Nadaur") then
			SetObjectiveState("twoheros", OBJECTIVE_FAILED );
			OBJECTIVES.state.getHeroes[2] = 11;
		end
	end,
}
print("2");
function C5M3_GetHeroAtTownGate(town)
	local player = GetObjectOwner(town);
	local heroes = GetPlayerHeroes(player);
	local x,y,z=H55_GetTownActiveTile(town);
	if table.length(heroes) ~= 0 then
		for i,hero in heroes do
			local a,b,c = GetObjectPosition(hero)
			if a == x and b == y and c == z then
				return hero;
			end
		end
	end
	return nil
end

print("1");
function C5M3_GetGarisonArmy(town, hero)
	local herod = 0;
	local herou = 0;
	local herodr = 0;
	local townd = GetObjectCreatures(town, CREATURE_DRUID) + GetObjectCreatures(town, CREATURE_DRUID_ELDER) + GetObjectCreatures(town, CREATURE_HIGH_DRUID);
	local townu = GetObjectCreatures(town, CREATURE_UNICORN) + GetObjectCreatures(town, CREATURE_WAR_UNICORN) + GetObjectCreatures(town, CREATURE_WHITE_UNICORN);
	local towndr = GetObjectCreatures(town, CREATURE_GREEN_DRAGON) + GetObjectCreatures(town, CREATURE_GOLD_DRAGON) + GetObjectCreatures(town, CREATURE_RAINBOW_DRAGON);
	if hero ~= nil then
		herod  = GetHeroCreatures(hero, CREATURE_DRUID) + GetHeroCreatures(hero, CREATURE_DRUID_ELDER) + GetHeroCreatures(hero, CREATURE_HIGH_DRUID);
		herou  = GetHeroCreatures(hero, CREATURE_UNICORN) + GetHeroCreatures(hero, CREATURE_WAR_UNICORN) + GetHeroCreatures(hero, CREATURE_WHITE_UNICORN);
		herodr = GetHeroCreatures(hero, CREATURE_GREEN_DRAGON) + GetHeroCreatures(hero, CREATURE_GOLD_DRAGON) + GetHeroCreatures(hero, CREATURE_RAINBOW_DRAGON);
	end
	return townd+herod, townu+herou, towndr+herodr;
end

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

------------------ DEBUG ------------------------
function C5M3_garison()
	local hero_at_gate = C5M3_GetHeroAtTownGate("Siris");
	local druids, unicorns, dragons = C5M3_GetGarisonArmy("Siris", hero_at_gate);
	print("Druids: ",druids,"Unicorns: ",unicorns,"Dragons: ",dragons);
end
