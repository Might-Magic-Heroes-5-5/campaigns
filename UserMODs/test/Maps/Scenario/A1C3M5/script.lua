H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DRAGON_SCALE_ARMOR,
ARTIFACT_DRAGON_SCALE_SHIELD,
ARTIFACT_DRAGON_BONE_GRAVES,
ARTIFACT_DRAGON_WING_MANTLE,
ARTIFACT_DRAGON_TEETH_NECKLACE,
ARTIFACT_DRAGON_TALON_CROWN,
ARTIFACT_DRAGON_EYE_RING,
ARTIFACT_DRAGON_FLAME_TONGUE

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M5");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M4" );
end;

startThread(H55_InitSetArtifacts);

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--###################################### BEGIN #########################################################
--CONSTANTS
--Must be filled for each map

RH_RespawnPoints_XYZ_Town = { {121, 22, GROUND, "rtown"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
	

RH_heroes = { "RedHeavenHero01" }; -- Pool of Red Haven heroes
	
AI_PLAYER = PLAYER_3; -- AI player side
RH_heroes_must_alive_count = 1; -- Minimum of AI Red Haven heroes who might be at same time on the map

--=======================================================================

RH_RespawnPoints_XYZ_Town.n = table.length( RH_RespawnPoints_XYZ_Town );
RH_heroes.n = table.length( RH_heroes );

RH_TownsTotal = 0;
for i=1, RH_RespawnPoints_XYZ_Town.n do
	if RH_RespawnPoints_XYZ_Town[i][4] ~= nil then
		EnableAIHeroHiring(AI_PLAYER, RH_RespawnPoints_XYZ_Town[i][4], nil);
		RH_TownsTotal = RH_TownsTotal + 1;
		print("AI hero hiring was disabled at town ", RH_RespawnPoints_XYZ_Town[i][4]);
	end;
end;
print("AI has ",RH_TownsTotal," towns for respawn");

function RH_Respawn()
	print( "Function RH_respawn has started...");
	while 1 do
		sleep(5);
		while GetCurrentPlayer() ~= AI_PLAYER do
			sleep(10);
		end;
		print("RH_Respawn: AI player's turn");
		RH_dead_heroes = 0;
		for i=1, RH_heroes.n do
			if IsHeroAlive( RH_heroes[i] ) == nil then
				print("RH_Respawn: AI hero ", RH_heroes[i]," is dead.");
				RH_dead_heroes = RH_dead_heroes + 1;	
				if RH_heroes.n - RH_dead_heroes < RH_heroes_must_alive_count then
					print("Count of AI RH heroes less than needed (",RH_heroes_must_alive_count,"). Hero ",RH_heroes[i]," must be placed.");
					lostRespawmTowns = 0;
					for j=1, RH_RespawnPoints_XYZ_Town.n do
						if IsObjectExists ( RH_RespawnPoints_XYZ_Town[j][4] )==not nil then
							if GetObjectOwner( RH_RespawnPoints_XYZ_Town[j][4] )==AI_PLAYER then
								print("AI has Respawn point ", j," and town ", RH_RespawnPoints_XYZ_Town[j][4]);
								DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
								startThread( transformTroops, RH_heroes[i] );
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end;
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
							startThread( transformTroops, RH_heroes[i] );
						end;
					end;
					if lostRespawmTowns == RH_RespawnPoints_XYZ_Town.n then print("RH_Respawn: AI doen't have any towns for respawn"); end;
				else
					print("Hero can't be deployed");
				end;		
			end;
			if RH_dead_heroes == 0 then print("All AI heroes are alive."); end;
		end;
		while GetCurrentPlayer() == AI_PLAYER do
			sleep(10);
		end;
		print("RH_Respawn: AI player's turn has ended");
	end;
end;

function transformTroops( heroName )
	sleep(3);
	print("function transformTroops for hero ", heroName ," has started...");
	while IsHeroAlive ( heroName ) == not nil do
		for i=1,14 do
			creaturesCount = GetHeroCreatures( heroName, i );
			if creaturesCount  > 0 then
				RemoveHeroCreatures( heroName, i, 10000);
				n = i;
				if mod(i,2) ~= 0 then n = i + 1; end;
				AddHeroCreatures( heroName, 105 + (n/2), creaturesCount );
			end;
		end;
		sleep(2);
	end;
	print("Hero ", heroName, " is dead. Function transformTroops terminated");
end;


startThread(RH_Respawn);
--====================================================================================================
--###################################### END #########################################################


--===================================== MAIN SCRIPT BODY =============================================
IsAlaricTouchTeleport = 0;
siege_hero_defeated = 0;
ALARIC = 'RedHeavenHero03';
KINGTOLGHAR = 'KingTolghar';
DUNCAN = 'Duncan';
SIEGEHERO = 'RedHeavenHero02';
FREYDA = 'Freyda';
WULFSTAN = 'Wulfstan';
SHADWYN = 'Shadwyn';
ISABELL = 'Isabell_A1'; 
DoomDay = 0;
SetRegionBlocked("gate",1, PLAYER_3); 

--SetRegionBlocked("bl", not nil, PLAYER_1); ---DB
--print("REG_BLOCKED");  ---DB

-- установка настроек по уровню сложности
function SetupDifficulty()
	slozhnost = GetDifficulty();
	if slozhnost == DIFFICULTY_EASY then
		damage_town_prob = 0;
		redhaven_coeff = 1.0;
	elseif slozhnost == DIFFICULTY_NORMAL then
		damage_town_prob = 20;
		redhaven_coeff = 1.25;
	elseif slozhnost == DIFFICULTY_HARD then
		damage_town_prob = 40;
		redhaven_coeff = 1.5;
	elseif slozhnost == DIFFICULTY_HEROIC then
		damage_town_prob = 60;
		redhaven_coeff = 1.5;
	end;
	SetGameVar( "temp.difficulty", slozhnost );
	print( 'difficulty = ', slozhnost );
end;

-- управление эффектами и анимациями катапульты
function Catapult()
	sleep( 10 );
	while IsHeroAlive( SIEGEHERO ) do
		if ( IsObjectVisible( PLAYER_1, 'kotopult' ) ) then
			PlayObjectAnimation( 'kotopult', 'rangeattack', ONESHOT );
			sleep( 5 );
			local x, y = GetObjectPosition( 'SD' );
			local dx = random( 7 ) - 3;
			local dy = random( 7 ) - 3;
			local dz = 1;
			if ( dx == 0 ) and ( dy >= 1 ) and ( dy <= 2 ) then
				dz = 9;
			elseif ( math.abs( dx ) <= 1 ) and ( dy >= 1 ) and ( dy <= 2 ) then
				dz = 8;
                        elseif ( math.abs( dx ) <= 1 ) and ( dy >= -2 ) and ( dy <= 0 ) then
				dz = 7;
			end;
			dx = dx + 1;
			dy = dy - 1;
			x = x + dx;
			y = y + dy;
			if dz == 1 then
				PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", 'SD', 'boom', dx, dy, dz, 0, 0 );
			else
				PlayVisualEffect( "/Effects/_(Effect)/Characters/CatapultChargeExplosion.xdb#xpointer(/Effect)", 'SD', 'boom', dx, dy, dz, 0, 0 );
			end;
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0 );
		end;
		sleep( 30 + random( 10 ) );
	end;
end;

-- анимации существ для осады
function Siege( counter )
	sleep( 10 );
	while IsObjectExists( 'siege' .. counter ) do
		if ( IsObjectVisible( PLAYER_1, 'siege' .. counter ) ) then
			if counter <= 4 then
				PlayObjectAnimation( 'siege' .. counter, 'happy', ONESHOT );
			elseif counter <= 8 then
				PlayObjectAnimation( 'siege' .. counter, 'stir00', ONESHOT );
			elseif counter <= 12 then
				PlayObjectAnimation( 'siege' .. counter, 'rangeattack', ONESHOT );
			end;
		end;
		sleep( 20 + random( 20 ) );
	end;
end;

function RedHavenHeroLost( heroname )
	if ( heroname == SIEGEHERO ) and ( siege_hero_defeated == 0 ) then
		siege_hero_defeated = 1;
		sleep( 1 );
		RazeBuilding( 'kotopult' );
		sleep( 1 );
		PlayObjectAnimation( 'kotopult', 'death', ONESHOT_STILL );
		startThread( RemoveSiege ); -- отключить огонь в городе
	end;
end;

function HumanHeroLost( heroname )
	if ( heroname == ISABELL ) or ( heroname == SHADWYN ) or ( heroname == DUNCAN ) or
		( heroname == FREYDA ) or ( heroname == WULFSTAN ) then
		SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
	end;
end;

-- функция роллит рандом и повреждает случайное здание в Столице
function DamageCapital()
	prob = random( 100 );
	if prob < damage_town_prob then
		
	end;
end;

function H55_TriggerDaily()
	if ( GetDate() == 8 ) and ( GetObjectiveState( 'prim1' ) == OBJECTIVE_ACTIVE ) then
		SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
	end;
	RedHavenUpgrade();
	--DamageCapital();
end;

-- срабатывает при захождении в регион 'nearSD' - первое задание
function Prim1( heroname )
	if heroname == ISABELL or heroname == SHADWYN then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'nearSD', nil );
		SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
		SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
	end;
end;

-- пока Дункан принадлежит союзнику, он может каждый свой ход атаковать одну существующую осаждающую кричу
function EngageSiegers()
	while GetObjectOwner( DUNCAN ) == PLAYER_2 do
		while GetCurrentPlayer() ~= PLAYER_2 do
			sleep( 1 );
			if GetObjectOwner( DUNCAN ) ~= PLAYER_2 then -- завершить функцию, если Дункан не приадлежит союзнику
				return
			end;
		end;
		if GetObjectOwner( DUNCAN ) == PLAYER_2 then
			local creature_list = {};
			local k = 0;
			for i = 1, 12 do -- найти все существующие кричи
				creature = 'siege' .. i;
				if IsObjectExists( creature ) then
					k = k + 1;
					creature_list[k] = creature;
				end;
			end;		
			EnableHeroAI( DUNCAN, not nil ); --H55 fix
			MoveHero( DUNCAN, GetObjectPosition( creature_list[ random( k ) + 1 ] ) );
		end;
		while GetCurrentPlayer() == PLAYER_2 do
			sleep( 1 );
		end;
	end;
end;

-- проверка на второе задание
function Prim2()
	local cnt = 12;
	local once_duncan = 0;
	while cnt > 0 do -- цикл в котором считаются уничтоженные осаждающие кричи
		sleep( 5 );
		if siege_hero_defeated == 1 then -- если осаждающий герой уничтожен
			cnt = 0;
			for i = 1, 12 do
				if IsObjectExists( 'siege' .. i ) then
					cnt = cnt + 1;
				end;
			end;
			if ( cnt <= 6 ) and ( once_duncan == 0 ) then -- если половина кричей уничтожена, то Дункан вылезет из замка
				startThread( EngageSiegers ); -- Дункан делает вылазки
				once_duncan = 1;
			end;
		end;
	end;
	H55_NewDayTrigger = 0;
	--Trigger( NEW_DAY_TRIGGER, nil );
	while GetCurrentPlayer() ~= PLAYER_1 do
		sleep( 1 );
	end;
	StartDialogScene( "/DialogScenes/A1C3/M5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
	SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
	SetRegionBlocked("gate", nil, PLAYER_3);
	SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
	startThread( DM_fin );
	DoomDay = GetDate( DAY );
	startThread( dayOfTheDoom );
	startThread( Inferno_sec ); ----DB!!!
--	SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
	SetObjectOwner( DUNCAN, PLAYER_1 );
	SetObjectOwner( 'SD', 0 );
	SetObjectOwner( 'SD', 1 );
	DeployReserveHero( FREYDA, 13, 8, 0 );
	DeployReserveHero( WULFSTAN, 17, 8, 0 );
	sleep ( 5 );
	H55_CamFixTooManySkills(PLAYER_1,"Freyda");
	H55_CamFixTooManySkills(PLAYER_1,"Wulfstan");
	sleep ( 1 );
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M5" );
	LoadHeroAllSetArtifacts( "Wulfstan" , "A1C2M5" );
	SetRegionBlocked( 'deploy1', nil, PLAYER_1 );
	SetRegionBlocked( 'deploy2', nil, PLAYER_1 );
	sleep( 1 );
--	TeachHeroSpell( FREYDA, SPELL_DIVINE_VENGEANCE );   ---------////DB
	SetAIPlayerAttractor( 'SD', PLAYER_3, 1 );
	SetAIPlayerAttractor( 'SD', PLAYER_4, 1 );
end;

-- действие триггера на захват ТорХралла
-- function Prim3( oldowner, newowner )
	-- if newowner == PLAYER_1 and GetObjectiveState ('prim2') == OBJECTIVE_COMPLETED then -----DB!!!
		-- sleep( 20 );
		-- SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
		-- Save("autosave");
		-- StartDialogScene( "/DialogScenes/A1C3/OUTRO/O1/DialogScene.xdb#xpointer(/DialogScene)" );
		-- sleep( 5 );
		-- Win();
	-- end;
-- end;
------------------------////////DB1

function DM_fin() 
	while 1 do
		sleep(10);
		if GetObjectOwner("TorHrall") == PLAYER_1 and GetObjectiveState ('prim2') == OBJECTIVE_COMPLETED then -----DB!!!
			sleep( 20 );
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			Save("autosave");
			StartDialogScene( "/DialogScenes/A1C3/OUTRO/O1/DialogScene.xdb#xpointer(/DialogScene)" );
			sleep( 5 );
			Win();
			break;
		end;
	end;
end;
-------------------------//////////DB2
function Inferno_sec() 
	while 1 do
		sleep(10);
		if GetObjectOwner("inferno1") == PLAYER_4 or GetObjectOwner("inferno2") == PLAYER_4 or GetObjectOwner("inferno3") == PLAYER_4 then --DB!!!
			sleep( 10 );
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
			sleep( 5 );
			break;
		end;
	end;
end;


-------------------------
function dayOfTheDoom()
	while ( GetDate(DAY) ~= DoomDay+56 ) do sleep(10); end;
	print("function dayOfTheDoom: Time is wasted. You loose :(");
	SetObjectiveState( "prim3", OBJECTIVE_FAILED );
	Loose();
end;

-- при обнюхивании сокровищницы
function TouchTreasury( heroname )
	if ( GetObjectOwner( heroname ) == PLAYER_1 ) then-- and ( GetGameVar( "c1m4.treasury" ) ~= "" ) then
		MessageBox( "/Maps/Scenario/A1C3M5/treasury.txt" );
		MarkObjectAsVisited( "treasury", heroname );
	end;
end;

-- сребатывает после захвата второго гномского гарнизона
function AlaricEscape( oldowner, newowner, heroname )
	if newowner == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, 'portal', 'RemoveOrrin' );
		DisableCameraFollowHeroes( 0, 0, 1 ); -- не двигать камеру за Андреем
		OpenCircleFog( 82, 101, 0, 10, PLAYER_1 );
		sleep(1);
		MoveCamera( 82, 101, GROUND, 40, 1.3, 0, 1, 1 ,1); -- переместить камеру
		sleep(20);
		while IsAlaricTouchTeleport == 0 do
			EnableHeroAI( ALARIC, not nil );			
			MoveHeroRealTime( ALARIC, 75, 97, 0 );
			sleep(2);
			ChangeHeroStat( ALARIC, STAT_MOVE_POINTS, 2500 );
		end;
		print("AlaricEscape: Alaric is in teleport");
	end;
end;

-- удаление Аларика после телепорта
function RemoveOrrin( heroname )
	if heroname == ALARIC then
		IsAlaricTouchTeleport = 1;
		sleep( 7 );
		RemoveObject( ALARIC );
		sleep( 1 );
		SetRegionBlocked( 'block_end', 1, PLAYER_1 );
		DisableCameraFollowHeroes( 0, 0, 0 );
		sleep( 1 );
		StartDialogScene( "/DialogScenes/A1C3/M5/S2/DialogScene.xdb#xpointer(/DialogScene)" );
	end;
end;

-- прокачка героев врагов
function LevelupEnemyHeroes()
	GiveExp( 'Marder', 140000 );
	GiveExp( ALARIC, 140000 );
	GiveExp( SIEGEHERO, 120000 );
	GiveExp( KINGTOLGHAR, 201007 );	
end;

-- огонь в Столице
function FireWorks()
	places = { { 12.5, 14.5 }, { 17, 12 }, { 13.5, 12.5 }, { 16, 17 }, { 13.5, 16 }, { 17, 15.5 } };
	effectname = "/Effects/_(Effect)/Buildings/Campfire.xdb#xpointer(/Effect)"
	for i = 1, 6 do
		PlayVisualEffect( effectname, "", "townfire", places[i][1], places[i][2], 0, random( 360 ), 0 );
	end;
end;

-- выключает огонь в Столице через некоторое время
function RemoveSiege()
	sleep( 200 );
	StopVisualEffects( "townfire" );
end;

-- действие триггера на захват города инферно
function Sec1( oldowner, newowner, heroname )
	if newowner == PLAYER_1 then
		for i = 1, 3 do
			print( "Start_check_sec1!!!!");
			if GetObjectOwner( 'inferno' ..i ) ~= PLAYER_1 and GetObjectiveState ('sec1') == OBJECTIVE_ACTIVE then
				return
			end;
		end;
		SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
	end;
end;

function RedHavenUpgrade() ---- Кричи хавена (апгрейды) скриптом заменяются на Красный апгрейд
	object = "rtown";
	heroes = GetPlayerHeroes( PLAYER_3 );
	for j, hero in heroes do
		for i = 1, 7 do
			num = GetHeroCreatures( hero, 2 * i );
			if num > 0 then
				AddHeroCreatures( hero, 105 + i, num );
				RemoveHeroCreatures( hero, 2 * i, num );
			end;
		end;
	end;
	if GetObjectOwner( object ) == PLAYER_3 then
		for i = 1, 7 do
			num = GetObjectCreatures( object, 2 * i );
			if num > 0 then
				AddObjectCreatures( object, 105 + i, num );
				RemoveObjectCreatures( object, 2 * i, num );
			end;
		end;
		if GetDate( DAY_OF_WEEK ) == 1 then
			AddObjectCreatures( object, CREATURE_ZEALOT, 6 * redhaven_coeff );
			AddObjectCreatures( object, CREATURE_CHAMPION, 4 * redhaven_coeff );
			AddObjectCreatures( object, CREATURE_SERAPH, 2 * redhaven_coeff );
		end;
	end;
end;

function TouchPrison()
	MessageBox( "/Maps/Scenario/A1C3M5/prison.txt" );
end;

-- PLAYER_1 = HUMAN
-- PLAYER_2 = ALLY (SD CAPITAL)
-- PLAYER_3 = RED HAVEN
-- PLAYER_4 = INFERNO
-- PLAYER_5 = DWARF
H55_CamFixTooManySkills(PLAYER_1,"Shadwyn");
H55_CamFixTooManySkills(PLAYER_2,"Duncan");
StartAdvMapDialog( 0 );
SetupDifficulty();
SetRegionBlocked( 'deploy1', 1, PLAYER_1 );
SetRegionBlocked( 'deploy2', 1, PLAYER_1 );
EnableHeroAI( SIEGEHERO, nil ); -- перец у котопульты
EnableHeroAI( DUNCAN, nil ); -- сидит в замке
EnableHeroAI( KINGTOLGHAR, nil ); -- сидит в Tor Hrall
EnableHeroAI( ALARIC, nil ); -- Аларик, сидит около Tor Hrall
EnableAIHeroHiring( PLAYER_2, 'SD', nil );
LevelupEnemyHeroes();
FireWorks();

for i = PLAYER_3, PLAYER_5 do -- уменьшить приоритет нейтрального города и заблокировать гномскую сокровищницу для всех врагов
	SetAIPlayerAttractor( 'dungeon_town', i, -1 );
	SetRegionBlocked( 'treasury', 1, i );
end;

SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );

SetObjectEnabled( 'treasury', nil );
SetObjectEnabled( 'prison', nil );
Trigger( OBJECT_TOUCH_TRIGGER, "treasury", "TouchTreasury" ); -- сокровищница
Trigger( OBJECT_TOUCH_TRIGGER, "prison", "TouchPrison" ); -- тюрьма
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, 'NewDay' );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'nearSD', "Prim1" ); -- триггер на приближение к столице
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "HumanHeroLost" ); -- потеря героя игрока
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, "RedHavenHeroLost" ); -- потеря героя red haven
--Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_5, "DwarfHeroLost" ); -- потеря героя гномов-врагов
-- Trigger( OBJECT_CAPTURE_TRIGGER, "TorHrall", "Prim3" ); -- потеря героя гномов-врагов
Trigger( OBJECT_CAPTURE_TRIGGER, "garrison1", "AlaricEscape" ); -- потеря героя гномов-врагов
for i = 1, 3 do
	Trigger( OBJECT_CAPTURE_TRIGGER, "inferno" .. i, "Sec1" ); -- захват города-инферно
end;

--MoveHero( "Duncan", GetObjectPosition( "SD" ) ); -- посадить Дункана в столицу
startThread( Catapult ); -- катапульта и эффекты осады
for i = 1, 12 do
	startThread( Siege, i ); -- анимации осаждающих кричей
end;
startThread( Prim2 );
sleep(2);
--startThread(transformTroops, "RedHeavenHero03");