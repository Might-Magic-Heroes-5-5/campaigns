doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M2");
	LoadHeroAllSetArtifacts( "Wulfstan" , "A1C2M1" );
end;

startThread(H55_InitSetArtifacts);

ENEMY_HERO = 'RedHeavenHero01';
ENEMY_IN_TOWN = 'RedHeavenHero02';
attack_date = 0;
-----##################################################DB

function Diff_Garr()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		AddObjectCreatures("G1", CREATURE_VINDICATOR, 5);
		RemoveObject("k1");
	elseif slozhnost == DIFFICULTY_NORMAL then
		AddObjectCreatures("G1", CREATURE_VINDICATOR, 5);
		RemoveObject("k1");
	elseif slozhnost == DIFFICULTY_HARD then
		AddObjectCreatures("G1", CREATURE_ZEALOT, 2);
		AddObjectCreatures("G1", CREATURE_VINDICATOR, 10);
		RemoveObject("k1");
	elseif slozhnost == DIFFICULTY_HEROIC then
		AddObjectCreatures("G1", CREATURE_ZEALOT, 5);
		AddObjectCreatures("G1", CREATURE_VINDICATOR, 15);
		RemoveObject("k1");	
	end;
	print('difficulty = ',slozhnost);
end;
------################################################end

-- установка настроек по уровню сложности
function SetupDifficulty()
	slozhnost = GetDifficulty();
	if slozhnost == DIFFICULTY_EASY then
		start_wood = 20;
		start_ore = 20;
		start_sec_resource = 10;
		start_gold = 20000;
		attacking_army_coeff = 0.5;
		attacker_expa = 25000;
		town_army_coeff = 0.4;
		attack_delay = 4;
	elseif slozhnost == DIFFICULTY_NORMAL then
		start_wood = 15;
		start_ore = 15;
		start_sec_resource = 10;
		start_gold = 15000;
		attacking_army_coeff = 1.0;
		attacker_expa = 30000;
		town_army_coeff = 0.8;
		attack_delay = 3;
	elseif slozhnost == DIFFICULTY_HARD then
		start_wood = 10;
		start_ore = 10;
		start_sec_resource = 5;
		start_gold = 10000;
		attacking_army_coeff = 1.4;
		attacker_expa = 50000;
		town_army_coeff = 1.0;
		attack_delay = 2;
	elseif slozhnost == DIFFICULTY_HEROIC then
		start_wood = 5;
		start_ore = 5;
		start_sec_resource = 5;
		start_gold = 10000;
		attacking_army_coeff = 1.7;
		attacker_expa = 70000;
		town_army_coeff = 1.2;
		attack_delay = 1;
	end;
	AddHeroCreatures( ENEMY_IN_TOWN, CREATURE_LONGBOWMAN, 52 * town_army_coeff );
	AddHeroCreatures( ENEMY_IN_TOWN, CREATURE_VINDICATOR, 33 * town_army_coeff );
	AddHeroCreatures( ENEMY_IN_TOWN, CREATURE_BATTLE_GRIFFIN, 20 * town_army_coeff );
	AddHeroCreatures( ENEMY_IN_TOWN, CREATURE_ZEALOT, 9 * town_army_coeff );
	print('difficulty = ',slozhnost);
end;

-- захвачен город
function TownCaptured( oldowner, newowner )
	if newowner == PLAYER_1 then
		SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
		SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
		SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
		--SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE );
		H55_NewDayTrigger = 0;
		H55_ThrNewDayTrigger = 0;
		H55_SecNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "CheckDwellings" );
	end;
	if newowner == PLAYER_2 then
		SetObjectiveState( 'prim3', OBJECTIVE_FAILED );
	end;
end;

function H55_SecTriggerDaily()
	if GetDate( MONTH ) == 3 then
		SetObjectiveState( 'prim2', OBJECTIVE_FAILED );
	end;
end;

-- захвачен двеллинг
function DwellingCaptured( oldowner, newowner )
	local cnt = 0;
	for i = 1, 6 do
		if GetObjectOwner( "dwelling".. i ) == PLAYER_1 then
			cnt = cnt + 1;
		end;
	end;
	SetObjectiveProgress( 'prim2', cnt );
	if cnt < 6 then
		return
	end;
	sleep( 1 );
	SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
	SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
	if attack_delay == 0 then
		attack_date = GetDate( DAY );
		DeployEnemy();
	else
		attack_date = GetDate( DAY ) + attack_delay;
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 0;
		H55_ThrNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "DeployEnemy" );
	end;
end;

function H55_ThrTriggerDaily()
	if GetDate( DAY ) == attack_date then
		--Trigger( NEW_DAY_TRIGGER, nil );
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 0;
		H55_ThrNewDayTrigger = 0;
		H55_FrtNewDayTrigger = 1;
		DeployReserveHero( ENEMY_HERO, 22, 3, 0 );
		sleep( 10 );
		--EnableHeroAI( ENEMY_HERO, nil ); --H55 fix
		GiveExp( ENEMY_HERO, attacker_expa );
		coeff = ( GetDate( WEEK ) + ( GetDate( MONTH ) - 1 ) * 4 ) * attacking_army_coeff;
		AddHeroCreatures( ENEMY_HERO, CREATURE_CHAMPION, 2 * coeff );
		AddHeroCreatures( ENEMY_HERO, CREATURE_VINDICATOR, 12 * coeff );
		AddHeroCreatures( ENEMY_HERO, CREATURE_LONGBOWMAN, 14 * coeff );
		AddHeroCreatures( ENEMY_HERO, CREATURE_ZEALOT, 3 * coeff );
		AddHeroCreatures( ENEMY_HERO, CREATURE_BATTLE_GRIFFIN, 6 * coeff );
		H55_AttackTown(ENEMY_HERO,'town');
		--MoveHero( ENEMY_HERO, GetObjectPosition( 'town' ) );
		--Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'EnemyHeroKilled' ); --H55 fix
	end;
end;

function H55_FrtTriggerDaily()
	if IsHeroAlive( ENEMY_HERO ) == nil then
		SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M2");
		StartDialogScene( "/DialogScenes/A1C2/M2/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 5 );
		SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
		sleep( 5 );
		Win();
	end;
end;

-- захвачена золотая шахта
function MinesCaptured( oldowner, newowner )
	for i = 1, 4 do
		if GetObjectOwner( "gold".. i ) ~= PLAYER_1 then
			return
		end;
	end;
	SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
end;

-- убит ататующий герой
function EnemyHeroKilled( heroname )
	if heroname == ENEMY_HERO then
		SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M2");
		StartDialogScene( "/DialogScenes/A1C2/M2/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(1);
		SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
		sleep(3);
		Win();
	end;
end;

-- понюхана тюрьма
function HeroFreed( heroname )
	SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED );
	Trigger( OBJECT_TOUCH_TRIGGER, "prison", nil );
end;

-- убирать кричей из двеллингов
function H55_TriggerDaily()
	--for i = 0, 15 do
	--	SetObjectDwellingCreatures( 'town', i, 0 );
	--end;
	SetPlayerResource( PLAYER_2, GOLD, 0 ); -- не давать АИ денег, чтобы не строил и не нанимал
	if GetDate(WEEK) == 3 then -- если началась 3 неделя, то задание провалено
		SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
	end;
end;

function PuppetMaster()
	local PlayObjectAnimation = 
	function( p1, p2, p3 )
		if IsObjectExists( p1 ) then
			PlayObjectAnimation( p1, p2, p3 );
		end;
	end;
	while IsObjectExists( 'puppet1' ) do
		if IsObjectVisible( PLAYER_1, 'puppet1' ) then
			PlayObjectAnimation( 'puppet1', 'attack00', ONESHOT );
			sleep( 5 );
			PlayObjectAnimation( 'puppet2', 'hit', ONESHOT );
			sleep( random( 15 ) + 15 );
			PlayObjectAnimation( 'puppet2', 'attack00', ONESHOT );
			sleep( 5 );
			PlayObjectAnimation( 'puppet1', 'hit', ONESHOT );
		end;
		sleep( random( 15 ) + 15 );
	end;
end;

 -- зажечь огни около tomb of the warrior
function Torchion()
	for i = 1, 9 do
		local lightpos = { { 63, 50 }, { 61, 52 }, { 60, 54 }, { 61, 57 }, { 68, 57 },
			{ 69, 54 }, { 68, 52 }, { 66, 50 }, { 64.5, 58.5 } };
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "", "light" .. i, lightpos[i][1], lightpos[i][2], 3, 0, 0 );
	end;
end;

 -- потушить огни около tomb of the warrior
function BreakTomb()
	for i = 1, 9 do
		StopVisualEffects( "light" .. i );
	end;
end;

-- запускается комбат на специальной арене
function RunCombat( heroname )
	Trigger( OBJECT_TOUCH_TRIGGER, "liches", nil );
	StartCombat( heroname, nil, 2, CREATURE_DEMILICH, 12, CREATURE_WIGHT, 6, nil, nil, '/Scenes/CombatArenas/Subterra_abyss.xdb#xpointer(/AdventureFlybyScene)' );
	RemoveObject( "liches" );
end;

-- грибы
function Gluki( heroname )
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Griby", nil );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Weakness.xdb#xpointer(/Effect)", heroname, "byaka", 0, 0, 0, 0, 0 );
	ChangeHeroStat( heroname, STAT_MORALE, 5 );
	ChangeHeroStat( heroname, STAT_LUCK, 5 );
end;
	
-------------------------------------------
H55_CamFixTooManySkills(PLAYER_1,"Wulfstan");
StartAdvMapDialog( 0 );
SetupDifficulty();

SetPlayerStartResource( PLAYER_1, WOOD, start_wood );
SetPlayerStartResource( PLAYER_1, ORE, start_ore );
SetPlayerStartResource( PLAYER_1, SULFUR, start_sec_resource );
SetPlayerStartResource( PLAYER_1, CRYSTAL, start_sec_resource );
SetPlayerStartResource( PLAYER_1, GEM, start_sec_resource );
SetPlayerStartResource( PLAYER_1, MERCURY, start_sec_resource );
SetPlayerStartResource( PLAYER_1, GOLD, start_gold );

Trigger( OBJECT_TOUCH_TRIGGER, "liches", "RunCombat" ); -- на личей в подземелье
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Griby", "Gluki" ); -- галлюциногенные грибы
SetObjectEnabled( "liches", nil );

EnableAIHeroHiring( PLAYER_2, 'town', nil ); -- запретить АИ нанимать героя в городе
EnableHeroAI( ENEMY_IN_TOWN, nil ); -- отключить героя-врага
GiveExp( ENEMY_IN_TOWN, 10000 ); -- прокачать врага в городе

SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );

x, y, f = GetObjectPosition( 'town' );
OpenCircleFog( x, y, f, 5, PLAYER_1 );

Trigger( OBJECT_CAPTURE_TRIGGER, "town", "TownCaptured" ); -- триггер на захват города
Trigger( OBJECT_TOUCH_TRIGGER, "tomb", "BreakTomb" ); -- триггер на опустошение tomb of the warrior
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "NewDay" );
H55_TriggerDaily();
for i = 1, 6 do
	Trigger( OBJECT_CAPTURE_TRIGGER, "dwelling".. i, "DwellingCaptured" ); -- триггер на захват любого двеллинга
end;
for i = 1, 4 do
	Trigger( OBJECT_CAPTURE_TRIGGER, "gold".. i, "MinesCaptured" ); -- триггер на захват любой золотой шахты
end;
startThread( PuppetMaster );
Torchion();
------------------------------------------

startThread( Diff_Garr ); ---##########DB