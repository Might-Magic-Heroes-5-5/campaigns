doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M3");
	LoadHeroAllSetArtifacts( "Isabell" , "C1M2" );
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_BOOTS_OF_LEVITATION};

__threads = {};
function startThreadOnce( func, p1, p2, p3 )
	if __threads[ func ] then
		return
	end;
	newfunc = function()
		%func( %p1, %p2, %p3);
		__threads[ %func ] = nil;
	end;
	__threads[ func ] = newfunc;
	startThread( newfunc );
end;

SetGameVar("temp.C1M3_Tradeville",0);
hero_visiting = 0;
OUR_HERO_NAME = "Isabell";
ENEMY_HERO_NAME = "Calid";
townx, towny = 32, 28;
n = 0;
gold_region = 0;
gold2_region = 0;
stone_region = 0;
cristall_region = 0;
all_regions = 0;
upg = 0;
IsTutorial = 1;--IsTutorialEnabled();
_t7 = 0;
met = 0;
dialog3 = 0;

function vspomozhite()
	SetPlayerResource(PLAYER_1,WOOD,10000);
	SetPlayerResource(PLAYER_1,ORE,10000);
	SetPlayerResource(PLAYER_1,GEM,10000);
	SetPlayerResource(PLAYER_1,CRYSTAL,10000);
	SetPlayerResource(PLAYER_1,MERCURY,10000);
	SetPlayerResource(PLAYER_1,SULFUR,10000);
	SetPlayerResource(PLAYER_1,GOLD,10000);
end;

function delete_inferno()
	for i = 1, 11 do
		RemoveObject( 'inferno'..i );
	end;
end;

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function Objective1()
local n;
	while 1 do
		n = 1;
		sleep( 2 );
		for i = 1, 11 do
			if ( Exists( 'inferno'..i ) ) then
				n = 0;
				break;
			end;
		end;
		if ( n == 1 ) then
			break;
		end;
	end;
	
	StartDialogScene("/DialogScenes/C1/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
	sleep( 3 );
	SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
	GiveExp( 'Isabell', 6000 );
end;

creature_costs = { 15, 25, 50, 80, 85, 130, 250, 370, 600, 850, 1300, 1700, 2800, 3500, -- haven
	25, 45, 40, 60, 110, 160, 240, 350, 550, 780, 1400, 1666, 2666, 3666, -- inferno
	19, 30, 40, 60, 100, 140, 250, 380, 620, 850, 1400, 1700, 1600, 1900, -- undead
	35, 55, 70, 120, 120, 190, 320, 440, 630, 900, 1100, 1400, 2500, 3400, -- sylvan
	22, 35, 45, 70, 100, 150, 250, 340, 460, 630, 1400, 1700, 2700, 3300, -- academy
	60, 100, 125, 175, 140, 200, 300, 450, 550, 800, 1400, 1700, 3000, 3700, -- dungeon
	400, 400, 400, 400, 1200, 1200, 10000, -- neutrals
	24, 40, 45, 65, 130, 185, 160, 220, 470, 700, 1300, 1700, 2700, 3400, -- fortress
	25, 80, 130, 370, 850, 1700, 3500, -- haven alts
	150, 350, 1800, 900,-- a1 neutrals
	10, 20, 50, 70, 80, 120, 260, 360, 350, 500, 1250, 1600, 2900, 3450, -- stronghold
	45, 60, 160, 350, 780, 1666, 3666, -- inferno alts
	100, 175, 200, 450, 800, 1700, 3700, -- dungeon alts
	55, 120, 190, 440, 900, 1400, 3400, -- sylvan alts
	30, 60, 140, 380, 850, 1700, 1900, -- necro alts
	35, 70, 150, 340, 630, 1700, 3300, -- academy alts
	40, 65, 185, 220, 700, 1700, 3400, -- fortress alts
	20, 70, 120, 360, 500, 1600, 3450 }; -- stronghold alts

function CalcHavenArmy( heroname )
	total = 0;
	for i = 1, CREATURES_COUNT-1 do
		total = total + GetHeroCreatures( heroname, i ) * creature_costs[i];
	end;
	return total;
end;

function SetInfernoArmy( heroname, strength )
	local factor = {};
	factor[CREATURE_BALOR] = 0.6;
	factor[CREATURE_SUCCUBUS] = 3.5;
	factor[CREATURE_HELL_HOUND] = 6.2;
	factor[CREATURE_DEMON] = 8.5;
	factor[CREATURE_IMP] = 8.0;
	local total = 0;
	local coeff = 0;
	local crap = __difficulty - 1;
	if crap < 0 then
		crap = 0;
	end;
	local minfact = 8 + crap * 4;
	for i = 15, 28 do
		total = total + creature_costs[i] * (factor[i] or 0);
	end;
	if total * minfact >= strength then
		coeff = minfact;
	else
		coeff = strength / total;
	end;
	print('strength = ', strength, '; coeff = ', coeff);
	for i = 15, 28 do
		if factor[i] then
			AddHeroCreatures( heroname, i, factor[i] * coeff );
		end;
	end;
end;

strcoeff = { 0.25, 0.5, 1.0, 1.25 };
function Objective3()
	if GetObjectiveState("prim3") == OBJECTIVE_ACTIVE then
		SetObjectPos(ENEMY_HERO_NAME, 118, 92, 0);
		sleep( 1 );
		player_army_strength = CalcHavenArmy( 'Isabell' );
		print( "player str = ", player_army_strength );
		player_army_strength = player_army_strength * strcoeff[__difficulty + 1];
		SetInfernoArmy( ENEMY_HERO_NAME, player_army_strength );
		startThread( EngageHero, 'Isabell' );
		startThread( MeetEnemyHero );
	elseif GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
		StartDialogScene("/DialogScenes/C1/M3/D1/DialogScene.xdb#xpointer(/DialogScene)", "dialog3end");
		--sleep(5);
		--Win();
	end;
end;

function dialog3end()
	dialog3 = 1;
end;

function treasure_captured()
	TutorialMessageBox("c1_m3_t2");
	if Exists("gold") then
		Trigger(OBJECT_TOUCH_TRIGGER,"gold",nil);
	end;
	if Exists("gold2") then
		Trigger(OBJECT_TOUCH_TRIGGER,"gold2",nil);
	end;
	if Exists("cristall") then
		Trigger(OBJECT_TOUCH_TRIGGER,"cristall",nil);
	end;
end;

function treasure_found()
	TutorialMessageBox("c1_m3_t1");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold",nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold2",nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"cristall",nil);
end;

function HeroBuiltWarmashine()
	while 1 do
		sleep( 5 );
		if ( HasHeroWarMachine(OUR_HERO_NAME, 1) or HasHeroWarMachine(OUR_HERO_NAME, 3) or HasHeroWarMachine(OUR_HERO_NAME, 4) ) then
			print("Player has got war mashine");
			if IsTutorial == 1 then
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m3_t9_2");
			end;
			break;
		end;
	end;
end;

function MeetEnemyHero()
	while 1 do
		sleep(2);
		OUR_HERO_X,OUR_HERO_Y = GetObjectPos(OUR_HERO_NAME);
		ENEMY_HERO_X,ENEMY_HERO_Y = GetObjectPos(ENEMY_HERO_NAME);
		--	if IsObjectVisible( PLAYER_1 ,ENEMY_HERO_NAME ) == not nil then
		if len(OUR_HERO_X - ENEMY_HERO_X,OUR_HERO_Y - ENEMY_HERO_Y) < 7 then
			--print("Player prepares to wage enemy Hero!!!");
			if ( IsTutorial == 1 ) then
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m3_t10");
			end;
			--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enemy", nil );
			--Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "enemy", nil );
			--RemoveHeroCreatures(ENEMY_HERO_NAME,CREATURE_ARCHDEVIL,10000);
			--RemoveHeroCreatures(ENEMY_HERO_NAME,CREATURE_SUCCUBUS,10000);
			--RemoveHeroCreatures(ENEMY_HERO_NAME,CREATURE_HELL_HOUND,10000);
			--AddHeroCreatures(ENEMY_HERO_NAME,CREATURE_SUCCUBUS,5);
			--AddHeroCreatures(ENEMY_HERO_NAME,CREATURE_HELL_HOUND,18);
			break;
		end;
	end;
end;

function EngageHero( heroname )
	while IsHeroAlive( ENEMY_HERO_NAME ) do
		while GetCurrentPlayer() ~= PLAYER_2 do
			sleep( 1 );
		end;
		print('attack ', heroname);
		EnableHeroAI( ENEMY_HERO_NAME, not nil );
		local x,y,z = GetObjectPosition( heroname );
		if CanMoveHero(heroname,x,y,z) then
			MoveHero(ENEMY_HERO_NAME,x,y,z);
		end;
		while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 1 );
		end;
	end;
end;

function battle()
	StartCombat(OUR_HERO_NAME,nil,4,CREATURE_SKELETON,40,CREATURE_SKELETON_ARCHER,25,CREATURE_ZOMBIE,15,CREATURE_WALKING_DEAD,22,nil,'artefact');
end;

function artefact()
	GiveArtefact(OUR_HERO_NAME, ARTIFACT_RING_OF_CELERITY);
end;

function BuildingUpgraded()
	while 1 do
		sleep(10);
		if (GetTownBuildingLevel("Bobruisk",TOWN_BUILDING_DWELLING_1) > 1 or
			GetTownBuildingLevel("Bobruisk",TOWN_BUILDING_DWELLING_2) > 1 or
			GetTownBuildingLevel("Bobruisk",TOWN_BUILDING_DWELLING_3) > 1) then
			print("Player makes upgrade in his Town!!!");
			WaitForTutorialMessageBox();
			TutorialMessageBox("c1_m3_t6");
			upg = 1;
			break;
		end;
	end;
end;

function LostHero( heroname )
	if heroname == 'Isabell' then
		SetObjectiveState( "prim4", OBJECTIVE_FAILED );
	elseif ( IsTutorial == 1 ) then
		TutorialMessageBox( 'c1_m2_t7' );
	end;
end;

function Objective2Bonus()
	if GetObjectiveState( 'prim2' ) == OBJECTIVE_COMPLETED then
		GiveExp( 'Isabell', 6000 );
	end;
end;

function EnableTutorial()
	SetGameVar( "temp.tutorial", 1 );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold","treasure_found");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold2","treasure_found");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"cristall","treasure_found");
	--Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "enemy", nil );
	--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enemy", "MeetEnemyHero" );
	if Exists("gold") == not nil then
		Trigger(OBJECT_TOUCH_TRIGGER, "gold", "treasure_captured" );
	end;
	if Exists("gold2") == not nil then
		Trigger(OBJECT_TOUCH_TRIGGER, "gold2", "treasure_captured" );
	end;
	if Exists("cristall") == not nil then
		Trigger(OBJECT_TOUCH_TRIGGER, "cristall", "treasure_captured" );
	end;
end;

function DisableTutorial()
	SetGameVar( "temp.tutorial", 0 );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold", nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gold2", nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"cristall", nil );
	--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enemy", nil );
	--Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "enemy", "MeetEnemyHero" );
	if Exists("gold") then
		Trigger(OBJECT_TOUCH_TRIGGER, "gold", nil );
	end;
	if Exists("gold2") then
		Trigger(OBJECT_TOUCH_TRIGGER, "gold2", nil );
	end;
	if Exists("cristall") then
		Trigger(OBJECT_TOUCH_TRIGGER, "cristall", nil );
	end;
end;

COMBAT = 9999;
THREAD = 9998;

TutorialTriggers = {
	{ "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER, "gold", "treasure_found", 0 },
	{ "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER, "gold2", "treasure_found", 0 },
	{ "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER, "cristall", "treasure_found", 0 },
	{ "c1_m3_t2", OBJECT_TOUCH_TRIGGER, "gold", "treasure_captured", 0 },
	{ "c1_m3_t2", OBJECT_TOUCH_TRIGGER, "gold2", "treasure_captured", 0 },
	{ "c1_m3_t2", OBJECT_TOUCH_TRIGGER, "cristall", "treasure_captured", 0 },
	
	{ "c1_m3_t6", THREAD, 0, BuildingUpgraded, 0 },
	{ "c1_m3_t9_2", THREAD, 0, HeroBuiltWarmashine, 0 },
};

function CheckTutorialTriggers()
	while 1 do
		sleep( 5 );
		for i, TutorialItem in TutorialTriggers do
			if IsTutorialItemEnabled( TutorialItem[1]  ) then
				if (TutorialItem[5] == 0) then
					if TutorialItem[2] == COMBAT then
						SetGameVar( "temp." .. TutorialItem[1], 1 );
					elseif TutorialItem[2] == THREAD then
						startThreadOnce( TutorialItem[4] );
					else
						if ( ( TutorialItem[2] == OBJECT_TOUCH_TRIGGER ) and Exists( TutorialItem[3]) ) or ( TutorialItem[2] ~= OBJECT_TOUCH_TRIGGER ) then
							Trigger( TutorialItem[2], TutorialItem[3], TutorialItem[4] );
						end;
					end;
					TutorialItem[5] = 1;
				end;
			else
				if (TutorialItem[5] == 1) then
					if TutorialItem[2] == COMBAT then
						SetGameVar( "temp." .. TutorialItem[1], 0 );
					elseif TutorialItem[2] ~= THREAD then
						if ( ( TutorialItem[2] == OBJECT_TOUCH_TRIGGER ) and Exists( TutorialItem[3]) ) or ( TutorialItem[2] ~= OBJECT_TOUCH_TRIGGER ) then
							Trigger( TutorialItem[2], TutorialItem[3], nil );
						end;
					end;
					TutorialItem[5] = 0;
				end;
			end;
		end;
	end;
end;

function CheckTutorial()
	while 1 do
		sleep( 5 );
		if IsTutorialEnabled() then
			if (IsTutorial == 0) then
				EnableTutorial();
				IsTutorial = 1;
			end;
		else
			if (IsTutorial == 1) then
				DisableTutorial();
				IsTutorial = 0;
			end;
		end;
	end;
end;

function ToWin()
	while 1 do
		sleep( 3 );
		if ( GetObjectiveState( 'prim1' ) == OBJECTIVE_COMPLETED ) and ( GetObjectiveState( 'prim2' ) == OBJECTIVE_COMPLETED ) and 
		( GetObjectiveState( 'prim3' ) == OBJECTIVE_COMPLETED ) and (dialog3 == 1) then
			SaveHeroAllSetArtifactsEquipped("Isabell", "C1M3");
			sleep( 3 );
			Win();
		end;
	end;
end;

function CheckHeroInTown()
heroes = {};
	while 1 do
		sleep( 1 );
		heroes = GetPlayerHeroes( PLAYER_1 );
		for i, hero in heroes do
			if GetTownHero( 'Bobruisk') ~= hero then
				x, y = GetObjectPos( hero );
				--print( i, hero );

				if ( x ~= townx ) or ( y ~= towny ) then
					if hero_visiting == 1 then
						SetGameVar( 'temp.hero_visiting', 0 );
						hero_visiting = 0;
					end;
				else
					if hero_visiting == 0 then
						SetGameVar( 'temp.hero_visiting', 1 );
						hero_visiting = 1;
						break;
					end;
				end;
			end;
		end;
	end;
end;

function EasyMode()
	if ( __difficulty ~= DIFFICULTY_EASY ) and ( __difficulty ~= DIFFICULTY_NORMAL ) then
		return
	end;
	CreateMonster( "monster1", CREATURE_ARCHER, 35, 58, 46, 0, 0, 0 );
	CreateMonster( "monster2", CREATURE_ARCHER, 33, 77, 26, 0, 0, 0 );
	CreateMonster( "monster3", CREATURE_SWORDSMAN, 24, 29, 63, 0, 0, 0 );
	CreateMonster( "monster4", CREATURE_FOOTMAN, 27, 73, 36, 0, 0, 0 );
	
	CreateMonster( "monster5", CREATURE_GRIFFIN, 14, 74, 65, 0, 0, 0 );
	CreateMonster( "monster6", CREATURE_CAVALIER, 7, 85, 70, 0, 0, 0 );
	CreateMonster( "monster7", CREATURE_GRIFFIN, 15, 42, 82, 0, 0, 0 );
end;

------------------------------
SetPlayerStartResource(PLAYER_1,WOOD,6);
SetPlayerStartResource(PLAYER_1,ORE, 15 );
SetPlayerStartResource(PLAYER_1,GEM,3);
SetPlayerStartResource(PLAYER_1,CRYSTAL,3);
SetPlayerStartResource(PLAYER_1,MERCURY,3);
SetPlayerStartResource(PLAYER_1,SULFUR,60);
SetPlayerStartResource(PLAYER_1,GOLD,5000);
EasyMode();

EnableHeroAI( ENEMY_HERO_NAME, nil );
StartDialogScene("/DialogScenes/C1/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
sleep(1);
SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );

startThread(Objective1);
startThread(ToWin);
startThread( CheckHeroInTown );

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, 'LostHero' );
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "surprize", "battle" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim3', 'Objective3' );
--Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim1', 'Objective1' );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim2', 'Objective2Bonus' );

-- tutorial related --
TutorialActivateHint( "hero_meet" );
TutorialActivateHint( "c1_m3_levelup" );
startThread( CheckTutorialTriggers );
SetGameVar( "temp.tutorial", 1 );

if ( IsTutorial == 1 ) then
	--EnableTutorial();
	--startThreadOnce(BuildingUpgraded);
	--startThreadOnce(HeroBuiltWarmashine);
else
	--Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "enemy", "MeetEnemyHero" );
end;

H55_CamFixTooManySkills(PLAYER_1,"Isabell");

--startThread( CheckTutorial );