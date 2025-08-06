H55_PlayerStatus = {0,1,1,2,2,2,2,2};

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
	InitAllSetArtifacts("A1C3M4");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M3" );
end;

startThread(H55_InitSetArtifacts);

-- CONSTANTS
DUNGEON_TOWN = "iarvain";
DWARF_TOWN = "dwarven_town";
OUR_HERO_RAILAG = "Raelag_A1";
OUR_HERO_ISABELL = "Isabell_A1";
OUR_HERO_SHADWYN = "Shadwyn";
ENEMY_HERO_THRALSAI = "Thralsai";

ENEMY = {{"Eruina",0},
		 {"Menel",0},
		 {"Dalom",0},
		 {"Ohtar",0},
		 {"Segref",0},
		 {"Inagost",0},
		 {"Almegir",0},
		 {"Urunir",0}
		};
LEFT_DEPLOY_POINTS = {{5,105},{17,128},{48,126}};
RIGHT_DEPLOY_POINTS = {{97,126},{120,125},{129,96}};
LEFT_MEETING_POINT_X = 36;LEFT_MEETING_POINT_Y = 76;
RIGHT_MEETING_POINT_X = 93;RIGHT_MEETING_POINT_Y = 77;
print("Constants defined");

EnableAIHeroHiring(PLAYER_3,DWARF_TOWN,nil);
-- Variables
leftDeployedHeroes = 0;
rightDeployedHeroes = 0;
aliveLeftHeroes = {0,0,0};
aliveRightHeroes = {0,0,0};
difficultyFactor = GetDifficulty();
delay = 25;
isDragonsFound = 0;
ThralsaiDeployed = 0;

print("Variables defined");

function setBlackDragonsQuantity( quantity )
	RemoveObjectCreatures( "Dragons", CREATURE_BLACK_DRAGON, GetObjectCreatures("Dragons",CREATURE_BLACK_DRAGON)-1 );
	sleep(1);
	AddObjectCreatures( "Dragons", CREATURE_BLACK_DRAGON, quantity );
end;

	if GetDifficulty() == DIFFICULTY_EASY then
		SetPlayerStartResource(PLAYER_1,ORE,30);
		SetPlayerStartResource(PLAYER_1,WOOD,30);
		SetPlayerStartResource(PLAYER_1,MERCURY,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,10);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,10);
		SetPlayerStartResource(PLAYER_1,GEM,10);
		SetPlayerStartResource(PLAYER_1,GOLD,20000);
		setBlackDragonsQuantity(120);
		print("Difficulty level is EASY");
		else
		if GetDifficulty() == DIFFICULTY_NORMAL then
			SetPlayerStartResource(PLAYER_1,ORE,25);
			SetPlayerStartResource(PLAYER_1,WOOD,25);
			SetPlayerStartResource(PLAYER_1,MERCURY,7);
			SetPlayerStartResource(PLAYER_1,CRYSTAL,7);
			SetPlayerStartResource(PLAYER_1,SULFUR,7);
			SetPlayerStartResource(PLAYER_1,GEM,7);
			SetPlayerStartResource(PLAYER_1,GOLD,15000);
			setBlackDragonsQuantity(100);
			print("Difficulty level is NORMAL");
			else
			if GetDifficulty() == DIFFICULTY_HARD then
				SetPlayerStartResource(PLAYER_1,ORE,15);
				SetPlayerStartResource(PLAYER_1,WOOD,15);
				SetPlayerStartResource(PLAYER_1,MERCURY,5);
				SetPlayerStartResource(PLAYER_1,SULFUR,5);
				SetPlayerStartResource(PLAYER_1,CRYSTAL,5);
				SetPlayerStartResource(PLAYER_1,GEM,5);
				SetPlayerStartResource(PLAYER_1,GOLD,10000);
				setBlackDragonsQuantity(80);
				print("Difficulty level is HARD");
				else
				if GetDifficulty() == DIFFICULTY_HEROIC then
					SetPlayerStartResource(PLAYER_1,ORE,10);
					SetPlayerStartResource(PLAYER_1,WOOD,10);
					SetPlayerStartResource(PLAYER_1,MERCURY,3);
					SetPlayerStartResource(PLAYER_1,SULFUR,3);
					SetPlayerStartResource(PLAYER_1,CRYSTAL,3);
					SetPlayerStartResource(PLAYER_1,GEM,3);
					SetPlayerStartResource(PLAYER_1,GOLD,8000);
					setBlackDragonsQuantity(30);
					print("Difficulty level is HEROIC");
				end;
			end;
		end;
	end;
	SetObjectEnabled("HutOfMagi",nil);
	SetObjectEnabled("dragon_teleport",nil);

-- ================ FUNCTIONS ================================ --



-- Функция вычисляющая расстояние от объекта Object1 до объекта Object2.
-- Если объекты находятся на разных уровнях функция возвращает -1.
function Distance( Object1, Object2, X,Y)
	Obj1_x,Obj1_y,Obj1_z = GetObjectPosition(Object1);
	if Object2 ~= nil then
		Obj2_x,Obj2_y,Obj2_z = GetObjectPosition(Object2);
	else
		if X ~= nil then Obj2_x = X; else print("X coord doesn't specified."); return -1; end;
		if Y ~= nil then Obj2_y = Y; else print("Y coord doesn't specified.");return -1; end;
		Obj2_z = Obj1_z;
	end;
	if Obj1_z == Obj2_z then
		SQRT = sqrt((Obj1_x - Obj2_x)*(Obj1_x - Obj2_x) + (Obj1_y - Obj2_y)*(Obj1_y - Obj2_y));
		return SQRT;
		else
		print("Error. Objects are not at same ground level.");
		return -1;
	end;
end;

-- При загрузке карты Шадвин бежит к Hut of magi (координаты 83, 15), чтобы показать игроку, где находятся драконы
function startInitial()
	sleep(4);
	MoveHeroRealTime(OUR_HERO_SHADWYN,83,15);
end;

-- Запускается, когда Шадвин провзаимодействует с Hut of Magi. Показывает драконов.
function showDragons()
	BlockGame();
	OpenCircleFog(123,16,UNDERGROUND,12,PLAYER_1);
	MoveCamera(124,13,UNDERGROUND,30,0.6,3.14,0,0);
	sleep(delay);
	if GetObjectiveState("Find_Dragon") ~= OBJECTIVE_ACTIVE then
		SetObjectiveState("Find_Dragon",OBJECTIVE_ACTIVE);
	end;
	MoveCamera(83,15,UNDERGROUND,50,1.4,0,0,0);
	UnblockGame();
end;

-- Проверяет, есть ли на карте хотя бы один герой АИ
function IsAnyEnemyHeroAlive()
	for i=1,8 do 
		if IsHeroAlive(ENEMY[i][1]) == not nil then return 1;end;
	end;
	return 0;
end;

-- При постановке на карту героя heroName начинает проверять - жив ли он. Как только герой погибает, из глобальной 
-- переменной leftDeployedHeroes (сколько всего героев на данный момент в левой области карты) вычитается 1. 
function checkThisLeftHeroAlive( heroName )
	while (IsHeroAlive( heroName ) == not nil) do sleep(2); end;
	print("hero ",heroName," is dead. leftDeployedHeroes = ",leftDeployedHeroes);
	leftDeployedHeroes = leftDeployedHeroes - 1;
end;

-- При постановке на карту героя heroName начинает проверять - жив ли он. Как только герой погибает, из глобальной 
-- переменной rightDeployedHeroes (сколько всего героев на данный момент в правой области карты) вычитается 1. 
function checkThisRightHeroAlive( heroName )
	while (IsHeroAlive( heroName ) == not nil) do sleep(2); end;
	print("hero ",heroName," is dead. rightDeployedHeroes = ",leftDeployedHeroes);
	rightDeployedHeroes = rightDeployedHeroes - 1;
end;

-- каждый десятый день ставит на карту 6 героев АИ.
-- если на этот момент на карте уже есть хотя бы один герой АИ установка не происходит
function H55_TriggerDaily()
	print("Thread dungeonInvasion has been started...");
	if IsAnyEnemyHeroAlive() == 0 then
		if mod(GetDate(DAY),8) == 0 and GetDate(DAY)<=40 then
			MessageBox("Maps/Scenario/A1C3M4/MsgBox_EnemyApproach.txt");
			print("first day has begun");
			j=0;
			aliveHeroes = 0;
			for i=1,table.length(ENEMY) do
				if ENEMY[i][2] == 0 then aliveHeroes = aliveHeroes + 1; end;
			end;
			leftDeployedHeroes = 0;
			rightDeployedHeroes = 0;
			for i=1,table.length(ENEMY) do
				if  IsHeroAlive( ENEMY[i][1] ) == nil then 
					j = j+1;
					if mod(j,2) == 0 then
						deployLeftReservedHero( ENEMY[i][1], LEFT_DEPLOY_POINTS[leftDeployedHeroes+1][1], LEFT_DEPLOY_POINTS[leftDeployedHeroes+1][2] );
						leftDeployedHeroes = leftDeployedHeroes + 1;
						startThread(checkThisLeftHeroAlive, ENEMY[i][1]);
					else
						deployRightReservedHero( ENEMY[i][1],  RIGHT_DEPLOY_POINTS[rightDeployedHeroes+1][1], RIGHT_DEPLOY_POINTS[rightDeployedHeroes+1][2] );
						rightDeployedHeroes = rightDeployedHeroes + 1;
						startThread(checkThisRightHeroAlive, ENEMY[i][1]);
					end;
					EnableHeroAI( ENEMY[i][1], not nil ); --H55 fix
				end;
				if j == aliveHeroes or j == 6 then break; end;
			end;
			sleep(10);
			startThread( TimeToReturnLeft );
			startThread( TimeToReturnRight );
			print("heroes have deployed"); 	
		end;
	else
		print("Enemy heroes already exist on the map. Nobody has been deployed at this time.");
	end;
	if GetDate(DAY) == 45 and isDragonsFound == 0 and ThralsaiDeployed == 0 then
		deployThralsai();
		ThralsaiDeployed = 1;
	end;
end;

-- Поставить на карту сценарного героя Тралсаи
function deployThralsai()
	H55_NewDayTrigger = 0;
	--Trigger( NEW_DAY_TRIGGER, nil);
	MessageBox("Maps/Scenario/A1C3M4/MsgBox_ThralsaiApproaching.txt");
	print("Time to Tralsai invasion");
	DeployReserveHero( ENEMY_HERO_THRALSAI, 5, 105, UNDERGROUND);
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_ASSASSIN, 450+GetDifficulty()*130 );
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_BLOOD_WITCH, 200+GetDifficulty()*70 );
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_MINOTAUR_KING, 130+GetDifficulty()*50 );
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_RAVAGER, 50+GetDifficulty()*25 );
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_CHAOS_HYDRA, 35+GetDifficulty()*17 );
	AddHeroCreatures( ENEMY_HERO_THRALSAI, CREATURE_MATRIARCH, 52+GetDifficulty()*12 );
	ChangeHeroStat( ENEMY_HERO_THRALSAI, STAT_ATTACK, GetDifficulty()+1 );
	ChangeHeroStat( ENEMY_HERO_THRALSAI, STAT_DEFENCE, GetDifficulty()+1 );
	ChangeHeroStat( ENEMY_HERO_THRALSAI, STAT_SPELL_POWER, GetDifficulty()+1 );
	ChangeHeroStat( ENEMY_HERO_THRALSAI, STAT_KNOWLEDGE, GetDifficulty()+1 );
	if GetDifficulty() == DIFFICULTY_HEROIC then
		GiveArtefact( ENEMY_HERO_THRALSAI, ARTIFACT_ICEBERG_SHIELD );
		GiveArtefact( ENEMY_HERO_THRALSAI, ARTIFACT_CROWN_OF_COURAGE );
	end;
	startThread( moveToIarvain, ENEMY_HERO_THRALSAI );
	sleep(5);
	startThread(playerWin);
end;

-- Получить массив героев АИ в заданном регионе
function GetAIHeroesInRegion( regionName )
	local AIHeroesInRegion = {};
	heroesInRegionArray	= GetObjectsInRegion( regionName, OBJECT_HERO );		
	for i=0,table.length( heroesInRegionArray ) - 1 do
		print("heroesInRegionArray[",i,"] = ", heroesInRegionArray[i]);
		if GetObjectOwner( heroesInRegionArray[i] ) == PLAYER_2 then 
			AIHeroesInRegion[i] = heroesInRegionArray[i];
		end;
	end;
	return AIHeroesInRegion;
end;

function TimeToReturnLeft()
	print("Thread TimeToReturnLeft has been started...");
	repeat
		sleep(5);
	until table.length(GetAIHeroesInRegion("meeting_left")) == leftDeployedHeroes;
		
	heroesInLeftRegionArray = GetAIHeroesInRegion("meeting_left");
	if 	leftDeployedHeroes > 0 then
		print("All heroes are in left meeting region");
		sleep(15);
		local attackingHero = "snusmumrik";
		for i=0,table.length(heroesInLeftRegionArray)-1 do
			if GetHeroCreatures( heroesInLeftRegionArray[i], CREATURE_ASSASSIN ) > 1 then
				print("hero ", heroesInLeftRegionArray[i], " has strongest army.");
				attackingHero = heroesInLeftRegionArray[i];
				EnableHeroAI( attackingHero, not nil );
				startThread( moveToIarvain, attackingHero );
				break;
			end;
		end;
		print("strongest hero is ", attackingHero);
		print("table.length of heroesInLeftRegionArray is ", table.length(heroesInLeftRegionArray));
		for i=0,table.length(heroesInLeftRegionArray)-1 do
			if heroesInLeftRegionArray[i] ~= attackingHero then
				print("Condition success. Hero is ",heroesInLeftRegionArray[i],". i = ",i);
				startThread( moveHeroToPoint, heroesInLeftRegionArray[i], LEFT_DEPLOY_POINTS[i+1][1], LEFT_DEPLOY_POINTS[i+1][2], 0 );
				startThread( removeHeroNearDeployPoint, heroesInLeftRegionArray[i], LEFT_DEPLOY_POINTS[i+1][1], LEFT_DEPLOY_POINTS[i+1][2]);
			end;
		end;
	else
		print("All enemy heroes is dead before reaching left meeting point. leftDeployedHeroes = ",leftDeployedHeroes);
	end;
end;


function TimeToReturnRight( deployedHeroes )
	print("Thread TimeToReturnRight has been started...");
	repeat
		sleep(5);
	until table.length(GetAIHeroesInRegion("meeting_right")) == leftDeployedHeroes;
		
	heroesInRightRegionArray = GetAIHeroesInRegion("meeting_right");
	if rightDeployedHeroes > 0 then
		print("All heroes are in right meeting region");
		sleep(15);
		local attackingHero = "snusmumrik2";
		for i=0,table.length(heroesInRightRegionArray)-1 do
			if GetHeroCreatures( heroesInRightRegionArray[i], CREATURE_ASSASSIN ) > 1 then
				attackingHero = heroesInRightRegionArray[i];
				EnableHeroAI( attackingHero, not nil );
				startThread( moveToIarvain, attackingHero );
				break;
			end;
		end;
		print("strongest hero is ", attackingHero);
		print("table.length of heroesInLeftRegionArray is ", table.length(heroesInLeftRegionArray));
		for i=0,table.length(heroesInRightRegionArray)-1 do
			if heroesInRightRegionArray[i] ~= attackingHero then
				startThread( moveHeroToPoint, heroesInRightRegionArray[i], RIGHT_DEPLOY_POINTS[i+1][1], RIGHT_DEPLOY_POINTS[i+1][2], 0 );
				startThread( removeHeroNearDeployPoint, heroesInRightRegionArray[i], RIGHT_DEPLOY_POINTS[i+1][1], RIGHT_DEPLOY_POINTS[i+1][2]);
			end;
		end;
	else
		print("All enemy heroes is dead before reaching right meeting point. rightDeployedHeroes = ",rightDeployedHeroes);
	end;
end;


function addArmyToStrongestHero( heroesArray )
	print("Function addArmyToStrongestHero started...");
	if table.length( heroesArray ) > 1 then
		mainHero = heroesArray[0];
		print("Main Hero is ",mainHero);
		for i=1,table.length( heroesArray )-1 do
			for id = 82,71,-1 do --   71 - 81 диапазон ID кричей данжена, которые могут быть у героев клана soulcsar(нет драконов)
				NofIdHeroCreatures = GetHeroCreatures( heroesArray[i], id );
				if NofIdHeroCreatures > 0 then
					AddHeroCreatures( mainHero, id, NofIdHeroCreatures );
					RemoveHeroCreatures( heroesArray[i], id, NofIdHeroCreatures );
				end;
			end;
			print("Army for hero ",heroesArray[i]," has been moved to main hero");
		end;
		print("All units moved");	
	else
		print("We have less than two heroes...");
	end;
end;

function deployLeftReservedHero( heroName, deployX, deployY )
	DeployReserveHero( heroName, deployX, deployY, UNDERGROUND );
	sleep(1);
	addCreatures( heroName );
	startThread( moveHeroToPoint, heroName, LEFT_MEETING_POINT_X, LEFT_MEETING_POINT_Y, 1 );
	print("hero ",heroName," deployed on the map. LEFT");
end;

function deployRightReservedHero( heroName, deployX, deployY )
	DeployReserveHero( heroName, deployX, deployY ,UNDERGROUND);
	sleep(1);
	addCreatures( heroName );
	startThread( moveHeroToPoint, heroName, RIGHT_MEETING_POINT_X, RIGHT_MEETING_POINT_Y, 1 );
	print("hero ",heroName," deployed on the map. RIGHT");
end;



-- добавление к армиям героев, которые ставятся на карту раз в две недели, армий в зависимости от 
-- уровня сложности и прошедшего от начала игры времени
function addCreatures( heroName )
	timeFactor = (GetDate(MONTH)-1)*4 + GetDate(WEEK) - 1; -- множитель, зависящий от аболютной недели (текущая неделя - 1)
	if GetDifficulty() == DIFFICULTY_EASY then
		AddHeroCreatures( heroName, CREATURE_ASSASSIN, 3*timeFactor ); -- Воиска деплоящихся героев зависят от уровня сложности
		AddHeroCreatures( heroName, CREATURE_WITCH, 2*timeFactor );    -- и от количества прошедших недель. 
		AddHeroCreatures( heroName, CREATURE_MINOTAUR, 1*timeFactor );
		AddHeroCreatures( heroName, CREATURE_RIDER, 1 + 1*timeFactor );
		print("creatures for Hero ",heroName," have been added. EASY");
	else
		if GetDifficulty() == DIFFICULTY_NORMAL then
			AddHeroCreatures( heroName, CREATURE_ASSASSIN, 5*timeFactor );
			AddHeroCreatures( heroName, CREATURE_BLOOD_WITCH, 4*timeFactor );
			AddHeroCreatures( heroName, CREATURE_MINOTAUR_KING, 3*timeFactor );
			AddHeroCreatures( heroName, CREATURE_RIDER, 1*timeFactor);
			AddHeroCreatures( heroName, CREATURE_MATRIARCH, 1*timeFactor);
			print("creatures for Hero ",heroName," have been added. NORMAL");
		else
			if GetDifficulty() == DIFFICULTY_HARD then
				AddHeroCreatures( heroName, CREATURE_ASSASSIN, 7*timeFactor);
				AddHeroCreatures( heroName, CREATURE_BLOOD_WITCH, 6*timeFactor);
				AddHeroCreatures( heroName, CREATURE_MINOTAUR_KING, 5*timeFactor );
				AddHeroCreatures( heroName, CREATURE_RAVAGER, 2*timeFactor );
				AddHeroCreatures( heroName, CREATURE_MATRIARCH , 2*timeFactor);
				print("creatures for Hero ",heroName," have been added. HARD");
			else
				AddHeroCreatures( heroName, CREATURE_ASSASSIN, 11*timeFactor);
				AddHeroCreatures( heroName, CREATURE_BLOOD_WITCH, 8*timeFactor);
				AddHeroCreatures( heroName, CREATURE_MINOTAUR_KING, 7*timeFactor );
				AddHeroCreatures( heroName, CREATURE_RAVAGER, 5*timeFactor);
				AddHeroCreatures( heroName, CREATURE_MATRIARCH, 4*timeFactor);
				print("creatures for Hero ",heroName," have been added. HEROIC");
			end;
		end;
	end;
end;


-- посылает героя heroName в точку meetingX, meetingY. Команда отдается только в ход
-- игрока, которому принадлежит герой. Параметр ToMeetingPoint устанавливается, если 
-- необходимо, чтобы герой шел в регион meeting_left или meeting_right. 
function moveHeroToPoint( heroName, meetingX, meetingY, ToMeetingPoint )
	print("Thread moveHeroToPoint for hero ",heroName," has been started...");
	while 1 do
	--while IsHeroAlive( heroName ) == not nil do
		while GetCurrentPlayer() ~= PLAYER_2 do sleep(1); end;
		print("player 2 turn started");	
		if ToMeetingPoint == 1 and IsHeroAlive( heroName ) == not nil then	
			if IsObjectInRegion( heroName, "meeting_left" )==not nil or IsObjectInRegion( heroName, "meeting_right" )==not nil then break; end;
		end;
		if IsHeroAlive(heroName) == not nil then
			MoveHero( heroName, meetingX, meetingY);
		else
			print("Our hero ",heroName," is dead");break;
		end;
		while GetCurrentPlayer() == PLAYER_2 do sleep(3); end;
		print("player 2 turn finished");
		sleep(3);
	end;
end;

function removeHeroNearDeployPoint( heroName, pointX, pointY )
	while Distance( heroName, nil, pointX, pointY ) >= 2 do
		sleep(5);
	end;
	print("hero ", heroName, " has reached his deploy point. Removing...");
	RemoveObject( heroName );
	print("Hero ",heroName," was removed.");
end;

function moveToIarvain( heroName )
	print("Thread moveToIarvain for hero ",heroName," has been started");
	while 1 do
		sleep(2);
		while GetCurrentPlayer() ~= PLAYER_2 do sleep(1); end;
			sleep(5);
		--if mod(GetDate(DAY),2) == 0 then
			--print("Not odd day. AI for hero ",heroName," has been disabled");
			--EnableHeroAI( heroName, nil ); --H55 fix
			if IsHeroAlive(heroName) == not nil then
				MoveHero( heroName, 66,15,UNDERGROUND); --H55 fix
			else
				print("Our hero ",heroName," is dead");break;
			end;
		--else
			--print("Odd day. AI for hero ",heroName," has been enabled");
			--EnableHeroAI( heroName, not nil );
		--end;
		while GetCurrentPlayer() == PLAYER_2 do sleep(3); end;
	end;
end;

function SetHeroAttractorsSequence( heroName, side )
	if side == "left" then
		SetAIHeroAttractor( "leftGarrison", heroName, 2);
	else
		SetAIHeroAttractor( "rightGarrison", heroName, 2);
	end;
	while GetObjectOwner("leftGarrison") == PLAYER_1 do sleep(5); end;
	print("Enemy hero has captured garrison");
	SetAIHeroAttractor( DWARF_TOWN, heroName, 2);
end;

function dwarvenTownReward( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_CUIRASS );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_GREAVES );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_HELMET );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_SHIELD );
		print( "Dwarven town has been captured by player's hero ", heroName );
	end;
end;

function BTAreward( heroName )
	if HasHeroSkill( heroName, PERK_SCOUTING ) == not nil then
		Trigger( OBJECT_TOUCH_TRIGGER, "BTA" ,nil );
		ChangeHeroStat( heroName, STAT_KNOWLEDGE, 4);
		ChangeHeroStat( heroName, STAT_SPELL_POWER, 4);
		ShowFlyingSign("Maps/Scenario/A1C3M4/FlyingMessage_PlusStats.txt", heroName, -1, 5);
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "BTA", "BTAreward" );
	end;
end;

function dragonTeleportMessageBox()
	if isDragonsFound == 0 then
		QuestionBox("Maps/Scenario/A1C3M4/ShureEnterTeleport_MsgBox.txt","teleportRequest");
	end;
end;

function teleportRequest()
	SetObjectEnabled("dragon_teleport",not nil);
	Trigger(OBJECT_TOUCH_TRIGGER,"dragon_teleport",nil);
end;

-- ================ PRIMARY OBJECTIVES ======================= --
function heroesMustSurvive( heroName )
	if heroName == OUR_HERO_RAILAG or heroName == OUR_HERO_ISABELL or heroName == OUR_HERO_SHADWYN then
		print( "Our glorious hero is dead :(" );
		Loose();
	end;
end;

function looseIfOurTownCaptured( oldOwner, newOwner)
	if newOwner ~= PLAYER_1 then print("Our Town is captured"); Loose(); end;
end;

function playerWin()
	while IsHeroAlive( ENEMY_HERO_THRALSAI ) == not nil do
		sleep(5);
	end;
	SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M4");
	sleep(5);
	print("Enemy main hero ",ENEMY_HERO_THRALSAI," is dead. You won!");
	StartDialogScene("/DialogScenes/A1C3/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState( "DefeatThralsai", OBJECTIVE_COMPLETED );
	sleep(15);
	Win(PLAYER_1);
end;

function dragonsFound( heroName )
	print("You have found dragons!");
	SetObjectiveState("Find_Dragon", OBJECTIVE_COMPLETED);
	isDragonsFound = 1;
	SetObjectEnabled("dragon_teleport",not nil);
	Trigger(OBJECT_TOUCH_TRIGGER,"dragon_teleport",nil);
	sleep(15);
	LevelUpHero( heroName );
	StartDialogScene("/DialogScenes/A1C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
	if ThralsaiDeployed == 0 then 
		deployThralsai();
		ThralsaiDeployed = 1;
	end;
end;


-- MAIN
H55_CamFixTooManySkills(PLAYER_1,"Shadwyn");
--== GENERAL
Trigger(OBJECT_CAPTURE_TRIGGER,DWARF_TOWN,"dwarvenTownReward");
Trigger(OBJECT_TOUCH_TRIGGER,"BTA","BTAreward");
Trigger(OBJECT_TOUCH_TRIGGER,"dragon_teleport","dragonTeleportMessageBox");
Trigger(OBJECT_TOUCH_TRIGGER,"HutOfMagi","showDragons");

function AfterDialogScene0()
	startThread(startInitial);
end;

StartAdvMapDialog( 0, "AfterDialogScene0" );	


--== OBJECTIVES
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "heroesMustSurvive" );
Trigger( OBJECT_CAPTURE_TRIGGER, DUNGEON_TOWN,"looseIfOurTownCaptured" );
Trigger( OBJECT_TOUCH_TRIGGER, "Dragons", "dragonsFound");
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "dungeonInvasion" );