H55_PlayerStatus = {0,1,1,1,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M3");
	LoadHeroAllSetArtifacts( "Wulfstan" , "A1C2M2" );
end;

startThread(H55_InitSetArtifacts);

------------------ СТАРТОВЫЕ МАССИВЫ И ПЕРЕМЕННЫЕ -------------------
EnableHeroAI("RedHeavenHero03", nil);
EnableHeroAI("RedHeavenHero02", nil);--специальный герой в горе(хозяин Медной горы), надобный токмо ради того, чтобы player2 не мог быть уничтожен игроком и корован мог ходить
EnemyHero2 = "Caravan" --- константа для имени каравана
EnemyHero3 = "RedHeavenHero01" --- константа для имени третьего вражеского героя (подземлей)
isTownCaptured = 0;

FreidaHero = "Freyda" --- константа для имени героя Freida

PlayerHero1 = "Wulfstan" --- константа для имени героя игрока Wulfstan

AliHero1 = "Ottar" ---- герой сидящий в тюрьме союзный игроку

patrol_under_array = {"patrol_u_l_1" , "patrol_u_r_1" , "patrol_u_l_2" , "patrol_u_l_3" , "patrol_u_r_2" , "patrol_u_r_3" }

target_under_patrol = 0;
reinforcement = 1000000
freidaappears = 7 + random (5);
sleep (1);
--caravanappear = 38 + random (10);
------------------ Открытие регионов на пути фрейды -------------------
x, y, f = RegionToPoint( "vieuzone1");
OpenCircleFog(x, y, f, 12 , PLAYER_1);
sleep (1);
x, y, f = RegionToPoint( "vieuzone2");
OpenCircleFog(x, y, f, 12 , PLAYER_1);
sleep (1);
x, y, f = RegionToPoint( "vieuzone3");
OpenCircleFog(x, y, f, 12 , PLAYER_1);
sleep (1);
x, y, f = RegionToPoint( "vieuzone4");
OpenCircleFog(x, y, f, 12 , PLAYER_1);
sleep (1);
x, y, f = RegionToPoint( "vieuzone5");
OpenCircleFog(x, y, f, 12 , PLAYER_1);
sleep (1);
x, y, f = RegionToPoint( "vieuzone6");
OpenCircleFog(x, y, f, 12 , PLAYER_1);

---------------- МОДИФИКАТОРЫ ОТ УРОВНЯ СЛОЖНОСТИ -------------------

if GetDifficulty() == DIFFICULTY_EASY then
	diff = 1;
	caravanappear = 10 + random( 2 );
	print ("easy");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	diff = 1;
	caravanappear = 10 + random( 2 );
    print ("normal");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_HARD then
	diff = 2;
	caravanappear = 8 + random( 2 );
    print ("Hard");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	diff = 3;
	caravanappear = 6 + random( 2 );
    print ("Impossible");
---Тело функции
end;
AddHeroCreatures("RedHeavenHero01", CREATURE_LANDLORD, 1+10*diff);
AddHeroCreatures("RedHeavenHero01", CREATURE_LONGBOWMAN, 1+7*diff);
AddHeroCreatures("RedHeavenHero01", CREATURE_VINDICATOR, 1+5*diff);
AddHeroCreatures("RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 1+3*diff);

AddHeroCreatures("RedHeavenHero03", CREATURE_LANDLORD, 1+25*diff);
AddHeroCreatures("RedHeavenHero03", CREATURE_LONGBOWMAN, 1+10*diff);
AddHeroCreatures("RedHeavenHero03", CREATURE_CHAMPION, 1+3*diff);
AddHeroCreatures("RedHeavenHero03", CREATURE_ZEALOT, 1+4*diff);
AddHeroCreatures("RedHeavenHero03", CREATURE_BATTLE_GRIFFIN, 1+4*diff);
---------------------------------------------------------------------
----------------------- СТАРТОВЫЕ НАСТРОЙКИ КАРТЫ -------------------
---------------------------------------------------------------------

EnableHeroAI(EnemyHero3, nil); --- Вражеские патрули будут жестко управляться скриптом

--SetRegionBlocked("block", 1, PLAYER_1); --- Блокируем возможность для игрока атаковать караван при появлении

for a = 0,6 do --- Устанавливаем стартовые ресурсы в 0
	SetPlayerResource(PLAYER_1, a, 0);
end;


---------------------------------------------------------------------
----------------------- ГЛАВНЫЕ ФУНКЦИОНАЛЫ -------------------------
---------------------------------------------------------------------

-- Функция вычисляющая расстояние от объекта Object1 до объекта Object2.
-- Если объекты находятся на разных уровнях функция возвращает -1.
function Distance(Object1,Object2)
	Obj1_x,Obj1_y,Obj1_z = GetObjectPosition(Object1);
	Obj2_x,Obj2_y,Obj2_z = GetObjectPosition(Object2);
	if Obj1_z == Obj2_z then
		SQRT = sqrt((Obj1_x - Obj2_x)*(Obj1_x - Obj2_x) + (Obj1_y - Obj2_y)*(Obj1_y - Obj2_y));
		return SQRT;
		else
--		print("Error. Objects are not at same ground level.");
		return -1;
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" ); --- триггер на потерю героя игроком
function LostHero( HeroName )
	if HeroName == PlayerHero1 then
		SetObjectiveState("Prim4", OBJECTIVE_FAILED);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		sleep (15);
		Loose();
	end;
end;

function LostHero2( HeroName2 )
	if HeroName2 == EnemyHero2 then
		SetObjectiveState("prim3_intercept_caravan", OBJECTIVE_COMPLETED);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil );
		startThread(Winner);
	end;
end;

----------------------- Забег Фрейды-------------------------
function freydamoves()
	x, y, floor = RegionToPoint( "freydahere");
	DeployReserveHero(FreidaHero, x, y, floor);
	sleep ( 1 );
	Trigger(OBJECT_TOUCH_TRIGGER , "Mine2", "nextmove2");
	MoveHero(FreidaHero, GetObjectPosition( "Mine2" ));
end;

function nextmove2()
	Trigger(OBJECT_TOUCH_TRIGGER , "Mine2", nil);
	sleep (1);
	Trigger(OBJECT_TOUCH_TRIGGER , "dwarftown", "nextmove3");
	MoveHero(FreidaHero, GetObjectPosition( "dwarftown" ));
end;

function nextmove3()
	Trigger(OBJECT_TOUCH_TRIGGER , "dwarftown", nil);
	sleep (1);
	MoveHero(FreidaHero, RegionToPoint('freidagoout'));
end;

Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'freidagoout', "eriseFreyda");
function eriseFreyda()
	RemoveObject(FreidaHero);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'freidagoout', nil);
end;

----------------------- Патруль подземлей ---------------------------
function patrol_under()
	if random ( 2 ) == 0 then
		MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[1]));
	else
		MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[2]));
	end;
	target_under_patrol = 0;
end;

function patrol_under1(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 3 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[2]));
		else
			if random ( 2 ) == 0 then
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[3]));
			else
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[4]));
			end;
		end;
		target_under_patrol = 0;
	end;
end;

function patrol_under2(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 3 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[1]));
		else
			if random ( 2 ) == 0 then
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[5]));
			else
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[6]));
			end;
		end;
		target_under_patrol = 0;
	end;
end;

function patrol_under3(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 3 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[1]));
		else
			if random ( 2 ) == 0 then
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[4]));
			else
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[6]));
			end;
		end;
		target_under_patrol = 0;
	end;
end;

function patrol_under4(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 2 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[1]));
		else
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[3]));
		end;
		target_under_patrol = 0;
	end;
end;

function patrol_under5(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 2 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[2]));
		else
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[6]));
		end;
		target_under_patrol = 0;
	end;
end;

function patrol_under6(hero_in)
	if hero_in ~= EnemyHero3 then
		return
	end;
	if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
		MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
		target_under_patrol = 1;
	else
		if random ( 3 ) == 0 then
			MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[2]));
		else
			if random ( 2 ) == 0 then
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[3]));
			else
				MoveHero(EnemyHero3, RegionToPoint(patrol_under_array[5]));
			end;
		end;
		target_under_patrol = 0;
	end;
end;

for a = 1,6 do
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, patrol_under_array[a], "patrol_under"..a);
end;

function H55_TriggerDaily() ------ Функция счетчик дней
	if GetDate(DAY) >= reinforcement and reinforcement > 0 then
		AddObjectCreatures(PlayerHero1, 99 , 50);
		MessageBox ("/Maps/Scenario/A1C2M3/messagebox3.txt" );
		reinforcement = 0
	end;
	if GetDate(DAY) == freidaappears then
		startThread(freydamoves);
	end;
	if GetDate(WEEK) == 4 and GetObjectiveState("prim1") ~= OBJECTIVE_COMPLETED then
		SetObjectiveState("prim1", OBJECTIVE_FAILED);
		sleep ( 20 );
		Loose();
	end;
end;

function patrols1()
	while IsObjectExists(EnemyHero3) ~= nil do
		sleep ( 20 );
		if Distance ( PlayerHero1, EnemyHero3) < 15 and Distance ( PlayerHero1, EnemyHero3) ~= -1 then
			if IsObjectExists(EnemyHero3) then
				MoveHero(EnemyHero3, GetObjectPosition(PlayerHero1));
			end;
			target_under_patrol = 1;
			print ("here");
--			sleep ( 1 );
--			return
		end;
		if target_under_patrol == 1 and (Distance ( PlayerHero1, EnemyHero3) > 15 or Distance ( PlayerHero1, EnemyHero3) == -1) then
			startThread(patrol_under);
		end;
	end;
end;

---------------------------------------------------------------------
---------------- Гномики отвлекатели под землей ----------------------
---------------------------------------------------------------------
SetObjectEnabled("sacriface1", nil);
SetObjectEnabled("sacriface2", nil);
SetObjectEnabled("sacriface3", nil);

Trigger(OBJECT_TOUCH_TRIGGER , "sacriface1" , "firsrtouch1");
Trigger(OBJECT_TOUCH_TRIGGER , "sacriface2" , "firsrtouch2");
Trigger(OBJECT_TOUCH_TRIGGER , "sacriface3" , "firsrtouch3");

--Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'taunt1hero', "fight1");
--Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'taunt2hero', "fight2");
--Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'taunt3hero', "fight3");

function removeEnemyHeroDwarves()
	while IsHeroAlive( EnemyHero3 )==not nil do
		if GetHeroCreatures( EnemyHero3, CREATURE_DEFENDER ) > 0 then
			RemoveHeroCreatures( EnemyHero3, CREATURE_DEFENDER, 10000);
		end;
		sleep(5);
	end;
end;

---------------------- Левый Нижний Гномик --------------------------
function firsrtouch1()
	StopVisualEffects ("stop1");
	QuestionBox ("/Maps/Scenario/A1C2M3/messagebox1.txt" , "RIP1" , "nofirsrtouch1");
	Trigger(OBJECT_TOUCH_TRIGGER , "sacriface1" , nil);
end;
function nofirsrtouch1()
	--x, y, f = GetObjectPosition( PlayerHero1 );
	--MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
	RemoveObject("sacriface1");
	AddHeroCreatures(PlayerHero1, 92 , 20 - 3*diff);
end;
function RIP1()
	x, y, f = GetObjectPosition( "underway12" );
	OpenCircleFog(x, y, f, 7 , PLAYER_1);
	zoom = 25;
	MoveCamera( x, y - 5, f, zoom, 0, 5.24, 0, 1, 1 );
	sleep ( 5 );
	RemoveObject("sacriface1");
	x,y,z = RegionToPoint('taunt1');
	CreateMob("sacriface12", 92 , 20, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
	sleep ( 1 );
	--SetObjectEnabled("sacriface12", nil);
	MoveHero(EnemyHero3, RegionToPoint('taunt1hero'));
	target_under_patrol = 0;
	--MoveCamera( x, y, z, zoom, 0, 0, 0, 1 );
	--sleep (3);
	while not Exists( "sacriface12" ) do
		sleep( 1 );
	end;
	PlayObjectAnimation("sacriface12" , "attack00", IDLE);
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, z );
	sleep (20);
	x, y, f = GetObjectPosition( PlayerHero1 );
	MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
end;
------------------------ Правый Гномик ------------------------------
function firsrtouch2()
	StopVisualEffects ("stop2");
	QuestionBox ("/Maps/Scenario/A1C2M3/messagebox1.txt" , "RIP2" , "nofirsrtouch2");
	Trigger(OBJECT_TOUCH_TRIGGER , "sacriface2" , nil);
end;
function nofirsrtouch2()
	--x, y, f = GetObjectPosition( PlayerHero1 );
	--MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
	RemoveObject("sacriface2");
	AddHeroCreatures(PlayerHero1, 92 , 20 - 3*diff);
end;
function RIP2()
	x, y, f = GetObjectPosition( "underway22" );
	OpenCircleFog(x, y, f, 7 , PLAYER_1);
	zoom = 25;
	MoveCamera( x, y - 5, f, zoom, 0, 0, 0, 1, 1 );
	sleep ( 5 );
	RemoveObject("sacriface2");
	x,y,z = RegionToPoint('taunt2');
	CreateMob("sacriface22", 92 , 20, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
	sleep ( 1 );
	--SetObjectEnabled("sacriface22", nil);
	MoveHero(EnemyHero3, RegionToPoint('taunt2hero'));
	target_under_patrol = 0;
	--MoveCamera( x, y, z, zoom, 0, 0, 0, 1 );
	--sleep ( 3 );
	while not Exists( "sacriface22" ) do
		sleep( 1 );
	end;
	PlayObjectAnimation("sacriface22" , "attack00", IDLE);
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, z );
	sleep (20);
	x, y, f = GetObjectPosition( PlayerHero1 );
	MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
end;
-------------------------- Верхний Гномик ----------------------------
function firsrtouch3()
	StopVisualEffects ("stop3");
	QuestionBox ("/Maps/Scenario/A1C2M3/messagebox1.txt" , "RIP3" , "nofirsrtouch3");
	Trigger(OBJECT_TOUCH_TRIGGER , "sacriface3" , nil);
end;
function nofirsrtouch3()
	--x, y, f = GetObjectPosition( PlayerHero1 );
	--MoveCamera( x, y, f, 50, 0, 0, 0, 1, 1 );
	RemoveObject("sacriface3");
	AddHeroCreatures(PlayerHero1, 92 , 20 - 3*diff);
end;
function RIP3()
--	print ("opa");
	x, y, f = GetObjectPosition( "underway32" );
	zoom = 25;
	MoveCamera( x, y - 5, f, zoom, 0, 0, 0, 1, 1 );
	OpenCircleFog(x, y, f, 7 , PLAYER_1);
	sleep ( 5 );
	RemoveObject("sacriface3");
	x,y,z = RegionToPoint('taunt3');
	CreateMob("sacriface32", 92 , 20, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
	sleep ( 1 );
	--SetObjectEnabled("sacriface32", nil);
	MoveHero(EnemyHero3, RegionToPoint('taunt3hero'));
	target_under_patrol = 0;
	--MoveCamera( x, y, z, zoom, 0, 0, 0, 1 );
	--sleep ( 3 );
	while not Exists( "sacriface32" ) do
		sleep( 1 );
	end;
	PlayObjectAnimation("sacriface32" , "attack00", IDLE);
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, z );
	sleep (20);
	x, y, f = GetObjectPosition( PlayerHero1 );
	MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
end;

function fight1()
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)");
	sleep ( 10 );
	PlayVisualEffect("/Effects/_(Effect)/Spells/MagicFist.xdb#xpointer(/Effect)", "sacriface12");
	sleep ( 5 );
	PlayObjectAnimation("sacriface12" , "idle00", ONESHOT);
	sleep ( 10 );
	PlayObjectAnimation("sacriface12" , "death", ONESHOT_STILL);
	sleep ( 10 );
	RemoveObject("sacriface12");
	target_under_patrol = 1;
end;

function fight2()
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)");
	sleep ( 10 );
	PlayVisualEffect("/Effects/_(Effect)/Spells/MagicFist.xdb#xpointer(/Effect)", "sacriface22");
	sleep ( 5 );
	PlayObjectAnimation("sacriface22" , "idle00", ONESHOT);
	sleep ( 10 );
	PlayObjectAnimation("sacriface22" , "death", ONESHOT_STILL);
	sleep ( 10 );
	RemoveObject("sacriface22");
	target_under_patrol = 1;
end;

function fight3()
	Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)");
	sleep ( 10 );
	PlayVisualEffect("/Effects/_(Effect)/Spells/MagicFist.xdb#xpointer(/Effect)", "sacriface32");
	sleep ( 5 );
	PlayObjectAnimation("sacriface32" , "idle00", ONESHOT);
	sleep ( 10 );
	PlayObjectAnimation("sacriface32" , "death", ONESHOT_STILL);
	sleep ( 10 );
	RemoveObject("sacriface32");
	target_under_patrol = 1;
end;

H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER , "patrols"); --- Триггер на наступление нового дн
Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'dwarfs_cave', "hi"); --- Триггер для анимации гномиков в пещере
Trigger(OBJECT_TOUCH_TRIGGER , "Prion_under" , "freedom1"); --- Триггер на освобождения героя из тюрьмы

function hi()
	x, y, f = RegionToPoint( "openfog" );
	OpenCircleFog(x, y, f, 12 , PLAYER_1);
	for i = 1, 3 do
		x, y, f = GetObjectPosition( "sacriface" .. i );
		MoveCamera( x, y, f, 15, 0, 0, 0, 1, 1 );
		sleep( 1 );
		PlayObjectAnimation("sacriface" .. i, "attack00", ONESHOT);
		sleep( 10 );
	end;
	x, y, f = GetObjectPosition( PlayerHero1 );
	MoveCamera( x, y, f, 20, 0, 0, 0, 1, 1 );
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface1" , "stop1");
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface2" , "stop2");
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface3" , "stop3");
end;

function freedom1()
	Trigger(OBJECT_TOUCH_TRIGGER , "Prion_under" , nil );
	sleep ( 1 );
	SetObjectOwner(AliHero1, PLAYER_3);
	sleep ( 10 );
	--EnableHeroAI(AliHero1, nil); --H55 fix
	xe = 0
	if IsObjectExists(EnemyHero3) == not nil then
		xe, ye, fe = GetObjectPosition( EnemyHero3 );
	end;
	if xe > 73 then
		if IsObjectExists("under_left_guard")==not nil then
			MoveHero( AliHero1, RegionToPoint( 'under_escape_left' ) );
			Trigger( OBJECT_TOUCH_TRIGGER, "under_left_guard", "sec1_clearLeftGuards" );
		else
			MoveHero( AliHero1, RegionToPoint( 'escapeAH1_left' ) );
		end;
	else
		if IsObjectExists("under_right_guard")==not nil then
			MoveHero( AliHero1, RegionToPoint( 'under_escape_right') );
			Trigger( OBJECT_TOUCH_TRIGGER, "under_right_guard", "sec1_clearRightGuards" );
		else
			MoveHero( AliHero1, RegionToPoint( 'escapeAH1_right' ) );
		end;
	end;
	SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
	SetObjectiveState("sec1", OBJECTIVE_ACTIVE);
	Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, "alliesHeroLose" );
	if GetObjectiveState("prim2") ~= OBJECTIVE_COMPLETED then
		SetObjectiveState("prim2", OBJECTIVE_ACTIVE);
		x, y, f = GetObjectPosition( "Town" );
		zoom = 35;
		MoveCamera( x, y, f, zoom, 1.4, 0, 0, 0, 1 );
		OpenCircleFog(x, y, f, 12 , PLAYER_1);
		sleep(20);
		Pl_x, Pl_y, Pl_floor = GetObjectPosition( PlayerHero1 );
		MoveCamera( Pl_x, Pl_y, Pl_floor, zoom, 1.4, 0, 0, 0, 1 );
	else
		startThread(Caravan);
	end;
end;

function sec1_clearLeftGuards( heroName )
	print(" Hero ", heroName, " has touched left vindicators");
	if IsHeroAlive( heroName ) == not nil then
		if heroName == AliHero1 then
			RemoveObject( AliHero1 );
			sleep(5);
			CreateMonster("Vindicator", CREATURE_VINDICATOR, 12, 16,13,1, MONSTER_MOOD_WILD, MONSTER_COURAGE_ALWAYS_FIGHT);
			print("monster created");
		else
			MoveHero( AliHero1, RegionToPoint( 'escapeAH1_left' ) );
		end;
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "under_left_guard", nil );
	end;
end;

function sec1_clearRightGuards( heroName )
	if IsHeroAlive( heroName ) == not nil then
		if heroName == AliHero1 then
			RemoveObject( AliHero1 );
			sleep(5);
			CreateMonster("Vindicator2", CREATURE_VINDICATOR, 12, 125,79,1, MONSTER_MOOD_WILD, MONSTER_COURAGE_ALWAYS_FIGHT);
			print("monster created");
		else
			MoveHero( AliHero1, RegionToPoint( 'escapeAH1_right' ) );
		end;
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "under_right_guard", nil );
	end;
end;

function alliesHeroLose( heroName )
	if heroName == AliHero1 then SetObjectiveState( "sec1", OBJECTIVE_FAILED ); end;
	Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil );
end;

function ulg()
	if IsObjectExists("under_left_guard") == nil then
		MoveHero(AliHero1, RegionToPoint('escapeAH1_left'));
		sleep ( 10 );
		return
	end;
	sleep ( 10 );
	startThread(ulgrun);
end;

function ulgrun()
	sleep ( 10 );
	startThread(ulg);
end;

function urg()
	if IsObjectExists("under_right_guard") == nil then
		MoveHero(AliHero1, RegionToPoint('escapeAH1_right'));
		sleep ( 10 );
		return
	end;
	sleep ( 10 );
	startThread(urgrun);
end;

function urgrun()
	sleep ( 10 );
	startThread(urg);
end;

Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_right', "secondary");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_left', "secondary");

function secondary(hero_escape) --
	if hero_escape == AliHero1 then
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil );
		sleep ( 1 );
		RemoveObject(AliHero1);
		SetObjectiveState("sec1", OBJECTIVE_COMPLETED);
		reinforcement = GetDate(DAY) + 1;
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_right', nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_left', nil);
	end;
end;

function secondobj() ------- После выполнения второго обжектива делаем все здания в городе доступными для постройки
	Trigger( OBJECT_CAPTURE_TRIGGER, "Town", nil );
	if GetObjectiveState("prim2") ~= OBJECTIVE_ACTIVE then
		SetObjectiveState( "prim2", OBJECTIVE_ACTIVE );
	end;
	sleep(1);
	SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
	SetTownBuildingLimitLevel( 'Town', 13, 2 );
	SetTownBuildingLimitLevel( 'Town', 12, 2 );
	SetTownBuildingLimitLevel( 'Town', 11, 2 );
	SetTownBuildingLimitLevel( 'Town', 10, 2 );
	SetTownBuildingLimitLevel( 'Town', 9, 2 );
	SetTownBuildingLimitLevel( 'Town', 8, 2 );
	SetTownBuildingLimitLevel( 'Town', 7, 2 );
	SetTownBuildingLimitLevel( 'Town', 4, 1 );
	sleep(5);
	if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
		startThread( Caravan );
	end;
end;

startThread(patrol_under);
startThread(patrols1);
SetObjectiveState("prim1", OBJECTIVE_ACTIVE);
Trigger( OBJECT_CAPTURE_TRIGGER, "Town", "secondobj" );

function Caravan() ------- Ставим караван на карту
	SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_ACTIVE );
	caravanArrivingTime = GetDate(DAY) + 10 - diff*2
	while GetDate(DAY) < caravanArrivingTime do sleep(5); end;
	x, y, floor = RegionToPoint( "caravan_here");
	--DeployReserveHero(EnemyHero2, x, y, floor);
	CreateCaravan( "caravan", PLAYER_2, 0, 133, 114, 0, 2, 40 );
	sleep( 1 );
	AddObjectCreatures( "caravan", CREATURE_CHAMPION, 2 + diff * 1 );
	AddObjectCreatures( "caravan", CREATURE_VINDICATOR, 20 + diff * 5 );
	AddObjectCreatures( "caravan", CREATURE_ZEALOT, 4 + diff * 3 );
	AddObjectCreatures( "caravan", CREATURE_LONGBOWMAN, 17 +8*diff);
	sleep( 3 );
	zoom = 35;
	MoveCamera( x, y, floor, 45, 1.3, 0, 0, 0, 1);
	OpenCircleFog(x, y, floor, 12 , PLAYER_1);

	startThread( CheckCaravan );
	x, y, floor = RegionToPoint( "Caravan_Out");
	OpenCircleFog(x, y, floor, 12 , PLAYER_1);
	while GetCurrentPlayer() == PLAYER_1 do
		sleep(3);
	end;
	startThread( showMeCaravan );
end;

function CheckCaravan()
	while IsObjectExists( "caravan" ) do
		sleep( 3 );
		if IsObjectExists( "caravan" ) then
			x, y = GetObjectPosition( "caravan" );
			if x == 2 and y == 40 then
				SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_FAILED );
				return
			end;
		end;
	end;
	SetPlayerResource( PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD)+55000-diff*10000);
	SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_COMPLETED );
	startThread(Winner);
end;

function showMeCaravan()
	while IsObjectExists( "caravan" ) do
		while GetCurrentPlayer() ~= PLAYER_1 do
			sleep(3);
		end;
		x,y,fl = GetObjectPosition( "caravan" );
		OpenCircleFog( x, y, fl, 5, PLAYER_1 );
		MoveCamera( x, y, fl, 45, 1.3, 0, 0, 0, 1);
		while GetCurrentPlayer() == PLAYER_1 do
			sleep(3);
		end;
	end;
end;

function next_step()
	MoveHero(EnemyHero2, RegionToPoint( "Caravan_Move2" ));
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move1', nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move2', "next_step2");
end;

function next_step2()
	MoveHero(EnemyHero2, RegionToPoint( "Caravan_Move3" ));
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move2', nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move3', "next_step3");
end;

function next_step3()
	MoveHero(EnemyHero2, RegionToPoint( "Caravan_Move4" ));
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move3', nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move4', "next_step4");
end;

function next_step4()
	MoveHero(EnemyHero2, RegionToPoint( "Caravan_Out" ));
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Move4', nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'Caravan_Out', "finish");
end;

function finish()
	Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil );
	sleep ( 5 );
	RemoveObject(EnemyHero2);
	SetObjectiveState("prim3_intercept_caravan", OBJECTIVE_FAILED);
	sleep ( 10 );
	Loose ();
end;

function Winner()
	while 1 do
		sleep( 3 );
		if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3_intercept_caravan") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M3");
			StartDialogScene("/DialogScenes/A1C2/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
			sleep ( 10 );
			Win();
			break;
		end;
	end;
end;
---------------------------------##################
function Def()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Wulfstan") == nil then
			SetObjectiveState("Prim4", OBJECTIVE_FAILED);
			sleep(10);
			Loose();
			break;
		end;
	end;
end;

function Diff_leveladd()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		AddHeroCreatures("Wulfstan", CREATURE_DEFENDER, 30);
		--AddHeroCreatures("Wulfstan", CREATURE_BEAR_RIDER, 30);
		--AddHeroCreatures("Wulfstan", CREATURE_BROWLER, 10);
		sleep(5);
	end;
	print('difficulty = ',slozhnost);
end;

H55_CamFixTooManySkills(PLAYER_1,"Wulfstan");
startThread( Def );
startThread( Diff_leveladd );