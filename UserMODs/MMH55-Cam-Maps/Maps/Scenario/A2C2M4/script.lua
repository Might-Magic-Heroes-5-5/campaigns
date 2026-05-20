doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts( "A2C2M4", "Kujin");
	LoadHeroAllSetArtifacts( "Kujin", "A2C2M2");
	sleep(40);
	H55_CamFixTooManySkills(PLAYER_1, "Kujin");
end

MAIN_HERO = "Kujin"
ENEMY_HERO = "Efion"

function H55_TriggerDaily() -- Turn AI off on 2nd day to dont bore player
	print ("New day");
	if GetDate( DAY ) == 2 then 
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes (PLAYER_2, not nil);
		print ("AI disabled");
	end 
end

function A2C2M4_SetAlastorCombat(koef)
	AddHeroCreatures( ENEMY_HERO,				 CREATURE_IMP, 100 + koef * 100 );
	AddHeroCreatures( ENEMY_HERO, CREATURE_FIREBREATHER_HOUND,  50 + koef *  50 );
	AddHeroCreatures( ENEMY_HERO,  CREATURE_INFERNAL_SUCCUBUS,  10 + koef *  25 );
	AddHeroCreatures( ENEMY_HERO, 		   CREATURE_NIGHTMARE,  30 + koef *  15 );
	AddHeroCreatures( ENEMY_HERO, 		   CREATURE_PIT_SPAWN,  10 + koef *  10 );
	AddHeroCreatures( ENEMY_HERO, 			   CREATURE_DEVIL,   5 + koef *   8 );
	if koef == 4 then
		TeachHeroSpell( ENEMY_HERO, SPELL_IMPLOSION );					
		TeachHeroSpell( ENEMY_HERO,   SPELL_BERSERK );					
		TeachHeroSpell( ENEMY_HERO, SPELL_VAMPIRISM );		
	end
	GiveExp( ENEMY_HERO, 262000 + 20000 * math.pow(2, koef ) );
	EnableHeroAI( ENEMY_HERO, nil );
end

DIFFICULTY = {
	[0] = function()
		CreateMonster( "M1", CREATURE_GOBLIN, 60, 72, 73, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
		CreateMonster( "M2", CREATURE_CENTAUR, 40, 108, 43, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
		CreateMonster( "M3", CREATURE_ORC_WARRIOR, 50, 41, 45, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
		CreateMonster( "M4", CREATURE_SHAMAN, 40, 46, 83, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 90 );
		A2C2M4_SetAlastorCombat(1);
	end,
	
	[1] = function()
		CreateMonster( "M5", CREATURE_ORC_WARRIOR, 30, 41, 45, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
		A2C2M4_SetAlastorCombat(2);
	end,
	
	[2] = function()
		RemoveHeroCreatures(MAIN_HERO, CREATURE_CENTAUR, 8);	
		RemoveHeroCreatures(MAIN_HERO, CREATURE_ORC_WARRIOR, 10);
		A2C2M4_SetAlastorCombat(3);
	end,
	
	[3] = function()
		RemoveHeroCreatures(MAIN_HERO, CREATURE_CENTAUR, 10);	
		RemoveHeroCreatures(MAIN_HERO, CREATURE_ORC_WARRIOR, 15);
		RemoveObject( "1_1" );
		RemoveObject( "1_2" );
		RemoveObject( "1_3" );
		RemoveObject( "1_4" );
		RemoveObject( "1_5" );
		A2C2M4_SetAlastorCombat(4);
	end,
}

-------------------------------------------------Final_combat
function AIAction()
	BlockGame();
	sleep(15);
	EnableHeroAI(ENEMY_HERO, not nil);
	ChangeHeroStat( ENEMY_HERO, STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( ENEMY_HERO, GetObjectPosition( MAIN_HERO ) );
	sleep(25);
	UnblockGame();	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat",nil);
end

-------------------------------------------------Winners
function Pobeda()
	sleep(5);
	StartDialogScene("/DialogScenes/A2C2/M4/S2/DialogScene.xdb#xpointer(/DialogScene)"); ----///Noaia oeiaeuiay 
	sleep(20);
	SaveHeroAllSetArtifactsEquipped( "Kujin",  "A2C2M4" );
	Win();
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final",nil);
end
-------------------------------------------------Andrey
function Andrey()
	sleep(5);
	StartDialogScene("/DialogScenes/A2C2/M4/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----///Noaia iia?aaaiey Aia?ay
	sleep(10);
	OpenCircleFog( 82, 10, 0, 4, PLAYER_1 );
	MoveCamera(82, 10, GROUND, 50, 1);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Andr_zone",nil);
end

-------------------------------------------------Teleport1
function Spec_1( heroname )
	StartAdvMapDialog (0, "QuestionBox('Maps/Scenario/A2C2M4/mess1.txt', 'KnowledgeTest(1)')");
end

function Spec_2( heroname )
	StartAdvMapDialog (1, "QuestionBox('Maps/Scenario/A2C2M4/mess1.txt', 'KnowledgeTest(2)')");
end

function Spec_3( heroname )
	StartAdvMapDialog (2, "QuestionBox('Maps/Scenario/A2C2M4/mess1.txt', 'KnowledgeTest(3)')");
end

A2C2M4_HUTS = {
	[1] = {	coords = { 122,  12 }, army = { 		 CREATURE_SUCCUBUS, 3 }	},
	[2] = {	coords = {  14,  16 }, army = { CREATURE_INFERNAL_SUCCUBUS, 5 }	},
	[3] = {	coords = {  61, 102 }, army = { 			CREATURE_BALOR, 1 }	},
}

function KnowledgeTest( id )
	local value = (1 + GetDifficulty()) * (1 + id);
	local hut = A2C2M4_HUTS[id];
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) >= random(value) then
		SetObjectPos(MAIN_HERO, hut.coords[1], hut.coords[2], GROUND);
	else
		StartCombat(MAIN_HERO,nil,3,hut.army[1],hut.army[2],hut.army[1],hut.army[2],hut.army[1],hut.army[2],nil);
	end
end

----------------------------------------Sec_Objs1
function SecObj1()	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary1", nil);
	OBJECTIVES.state.findTarrot[2] = 1;
end

function SecObj2_faled()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary2", nil);
	if OBJECTIVES.state.findTarrot[2] > 0 and OBJECTIVES.state.findTarrot[2] < 10 then
		OBJECTIVES.state.findTarrot[2] = 9;
	end
end

----------------------------------------Sec_Objs2_SINK_TEMPLE
function SecObj2()	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1", nil);
	sleep(20);
	Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO11_Kujin_01sound.xdb#xpointer(/Sound)" );
end

function VO_12(hero)
	if hero == MAIN_HERO then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1",nil );
		Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO12_Kujin_01sound.xdb#xpointer(/Sound)" );
	end
end

-------------------------------------------Traps
function Combat1()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "trap1", nil);	
	CreateMonster( "ms1", CREATURE_SUCCUBUS, 65, 123, 45, 0, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 180 );
	sleep(20);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Bloodlust.xdb#xpointer(/Effect)", "ms1", "ms11", 0, 0, 0, 0, 0 );
	Play2DSound( "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" );	
end

-------------------------------------------DIALOGS--------------------------------
function dialog_1(hero)
	if hero == MAIN_HERO then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one",nil);
		sleep(5);
		StartAdvMapDialog (3);
	end
end

function Dialog_mage()
	while 1 do	
		sleep( 20 );
		if IsPlayerHeroesInRegion ( PLAYER_1, "bridge" ) == not nil then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one",nil);
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO2_Kujin_01sound.xdb#xpointer(/Sound)" );
			break
		end
	end
end

OBJECTIVES = {
	state = {
	   defeatHero = { "prim2", 1 }, -- Banish Inferno Hero
		  isAlive = { "prim3", 1 }, -- Kujin must survive
	   findTarrot = {  "sec1", 0 }, -- Find the Tarrot Deck
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		startThread(H55_InitSetArtifacts);
		startThread(Dialog_mage);
		H55_NewDayTrigger = 1;
		SetRegionBlocked("Andr_mobs", 1, PLAYER_1);
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 500);
		SetObjectEnabled("h1", nil);
		SetObjectEnabled("h2", nil);
		SetObjectEnabled("h3", nil);

		sleep( 5 );
		SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
		OpenCircleFog( 5, 112, 0, 4, PLAYER_1 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", MAIN_HERO, "Kujin1", 0, 0, 0, 0, 0 );
		sleep( 5 );
		MoveCamera(6, 112, GROUND, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 8 );
		MoveCamera(101, 129, GROUND, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 5 );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat", "AIAction", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	  "Final",   "Pobeda", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "Andr_zone",   "Andrey", nil );
		Trigger (OBJECT_TOUCH_TRIGGER, "h1", "Spec_1");
		Trigger (OBJECT_TOUCH_TRIGGER, "h2", "Spec_2");
		Trigger (OBJECT_TOUCH_TRIGGER, "h3", "Spec_3");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary1", 		"SecObj1", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary2", "SecObj2_faled", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "Temple_1", 		"SecObj2", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	 "trap1", 		"Combat1", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one", 	   "dialog_1");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "Temple_2", 		  "VO_12");
		startThread(DIFFICULTY[GetDifficulty()]);
    end,

    run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			if GetObjectiveState("prim3") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			-- Win is triggered by player hero entering a region called "Final"
		end
	end,
	
	defeatHero = function()
		if OBJECTIVES.state.defeatHero[2] == 1 and IsObjectExists("Monster") == nil then
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.defeatHero[2] = 2;
		elseif OBJECTIVES.state.defeatHero[2] == 2 and IsHeroAlive(ENEMY_HERO) == nil then
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			sleep(5);
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO3_Kujin_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.defeatHero[2] = 10;
		end
	end,
	
	isAlive = function()
		-- start of this task is handled by A2C2M4.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive(MAIN_HERO) == nil then
			SetObjectiveState('prim3', OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	findTarrot = function()
		if OBJECTIVES.state.findTarrot[2] == 1 then
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO4_Kujin_01sound.xdb#xpointer(/Sound)" );
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findTarrot[2] = 2;
		elseif OBJECTIVES.state.findTarrot[2] == 2 and HasArtefact("Kujin", ARTIFACT_TAROT_DECK ) then
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO6_Kujin_01sound.xdb#xpointer(/Sound)");
			SetObjectiveState("sec1", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findTarrot[2] = 10;			
		elseif OBJECTIVES.state.findTarrot[2] == 9 then
			SetObjectiveState('sec1', OBJECTIVE_FAILED);
			OBJECTIVES.state.findTarrot[2] = 11;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);

function A2C2M4_debug()
	pcall(H55_NoFog, 1);
	SetObjectPosition("Kujin", 31, 123);
end
