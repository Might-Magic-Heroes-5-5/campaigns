H55_PlayerStatus = {0,1,2,2,2,2,2,2};

MARKAL = "Berein";
ZEHIR = "Zehir";

-- установка настроек по уровню сложности
function SetupDifficulty()
	slozhnost = GetDifficulty();
	if slozhnost == DIFFICULTY_EASY then
		army_coeff = 0.2;
	elseif slozhnost == DIFFICULTY_NORMAL then
		army_coeff = 0.4;
	elseif slozhnost == DIFFICULTY_HARD then
		army_coeff = 0.6;
	elseif slozhnost == DIFFICULTY_HEROIC then
		army_coeff = 0.8;
	end;
	print('difficulty = ',slozhnost);
end;

-- действие триггера для телепортов: изменение освещения на карте
function ChangeLight( heroname, objectname )
	if objectname == "tele1" then
		light = 1;
	elseif objectname == "tele2" then
		light = 2;
	elseif objectname == "tele3" then
		light = 3;
	end;
	SetAmbientLight( 0, "a1sm5_"..light );
end;

-- Зехир спускается в подземелье
function MeetMarkal()
	sleep( 3 );
	StartDialogScene( "/DialogScenes/A1Single/SM5/S2/DialogScene.xdb#xpointer(/DialogScene)", "AttackZehir" );
end;

function AttackZehir()
	BlockGame();
	sleep( 5 );
	MoveCamera( 67, 69, 1, 40, 1.0, 0, 0, 0 );
	sleep( 5 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/AnimateDead.xdb#xpointer(/Effect)", "", "", 67.5, 75.5, 0, 0, 1 );
	sleep( 17 );
	DeployReserveHero( MARKAL, 67, 75, 1 );

	while IsHeroAlive( MARKAL ) == nil do
		sleep( 1 );
	end;
	
	local weeks = GetDate( WEEK ) + ( GetDate( MONTH ) - 1 ) * 4;
	--print( 'weeks passed = ', weeks );
	local archers = 23 + army_coeff * 35 * weeks;
	local zombies = 17 + army_coeff * 15 * weeks;
	local ghosts = 12 + army_coeff * 9 * weeks;
	local vampy = 8 + army_coeff * 6 * weeks;
	local lichs = 5 + army_coeff * 3 * weeks;
	local wraiths = 3 + army_coeff * 2 * weeks;
	local dragons = 1 + army_coeff * 1 * weeks;

	AddHeroCreatures( MARKAL, CREATURE_SKELETON_ARCHER, archers );
	AddHeroCreatures( MARKAL, CREATURE_ZOMBIE, zombies );
	AddHeroCreatures( MARKAL, CREATURE_GHOST, ghosts );
	AddHeroCreatures( MARKAL, CREATURE_VAMPIRE_LORD, vampy );
	AddHeroCreatures( MARKAL, CREATURE_DEMILICH, lichs );
	AddHeroCreatures( MARKAL, CREATURE_WRAITH, wraiths );
	AddHeroCreatures( MARKAL, CREATURE_SHADOW_DRAGON, dragons );
	sleep( 1 );
	MoveHeroRealTime( MARKAL, GetObjectPosition( ZEHIR ) );
	UnblockGame();
	Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'Win()' );
end;

-----------------
StartDialogScene( "/DialogScenes/A1Single/SM5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
SetupDifficulty();
for i = 0, 6 do
	SetPlayerResource( PLAYER_1, i, 0 );
end;
for i = 1, 3 do
	Trigger( OBJECT_TOUCH_TRIGGER, "tele" .. i, "ChangeLight" ); -- повесить на каждый телепорт триггер на нюханье
end;
Trigger( OBJECT_TOUCH_TRIGGER, "tele4", "MeetMarkal" );