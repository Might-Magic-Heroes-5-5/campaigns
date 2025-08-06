H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M2");
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M1" );
end;

startThread(H55_InitSetArtifacts);

-- Constants
dialog_c1m2s2 = 0;
dialog_c1m2s3 = 0;
SetHeroesExpCoef( 0.8 );
if GetDifficulty() ~= DIFFICULTY_HEROIC then
	SetRegionBlocked( "dwelling_archer", not nil, PLAYER_2 );
	SetRegionBlocked( "dwelling_archer2", not nil, PLAYER_2 );
	SetRegionBlocked( "dwelling_footman", not nil, PLAYER_2 );
	SetRegionBlocked( "dwelling_footman2", not nil, PLAYER_2 );
	SetRegionBlocked( "dwelling_military_post", not nil, PLAYER_2 );
end;

OUR_HERO_FREYDA = "Freyda";
OUR_HERO_LASZLO = "Laszlo";
FOLLOWING_RADIUS = 5.5;
GOOD_UNITS_QUANTITY = 5;
DELAY = 3;
PI = 3.14

TOWN_1 = "SouthWestTown";
TOWN_2 = "NorthWestTown";
TOWN_3 = "SouthEastTown";
TOWN_4 = "NorthEastTown";

SW_PEASANT_ARRAY = {{"SW_peasant_first_victim",0,0},
					{"SW_peasant_witchhunter01",0,0},
					{"SW_peasant_witchhunter02",0,0},
					{"SW_peasant_near_hut01",0,0},
					{"SW_peasant_near_hut02",0,0},
					{"SW_good_peasant",0,0}
				   };
for i=1,table.length(SW_PEASANT_ARRAY) do 
	x,y = GetObjectPosition(SW_PEASANT_ARRAY[i][1]);
	SW_PEASANT_ARRAY[i][2] = x; SW_PEASANT_ARRAY[i][3] = y;
	SetObjectEnabled(SW_PEASANT_ARRAY[i][1],nil);
end;

NW_PEASANT_ARRAY = {{"SW_peasant_first_victim",0,0},
					{"SW_peasant_witchhunter01",0,0},
					{"SW_good_peasant",0,0}
				   };

NE_PEASANT_ARRAY = {{"SW_peasant_first_victim",0,0},
					{"SW_peasant_witchhunter01",0,0},
					{"SW_good_peasant",0,0}
				   };

C_PEASANT_ARRAY = {{"C_peasant_first_victim",0,0},
				    {"C_peasant_witchhunter01",0,0},
				    {"C_peasant_witchhunter02",0,0},
					{"C_peasant_near_hut01",0,0},
					{"C_peasant_near_hut02",0,0},
					{"C_peasant_near_hut03",0,0},
					{"C_good_peasant",0,0}
					   };
for i=1,table.length(C_PEASANT_ARRAY) do 
	x,y = GetObjectPosition(C_PEASANT_ARRAY[i][1]);
	C_PEASANT_ARRAY[i][2] = x; C_PEASANT_ARRAY[i][3] = y;
	SetObjectEnabled(C_PEASANT_ARRAY[i][1],nil);
end;

SE_PEASANT_ARRAY = {{"SE_peasant_first_victim",0,0}, 
				    {"SE_peasant_nearhut02",0,0},
					{"SE_peasant_witchhuner01",0,0},
					{"SE_peasant_witchhuner02",0,0},
					{"SE_peasant_witchhuner03",0,0},
					{"SE_peasant_nearhut01",0,0},
					{"SE_peasant_nearhut03",0,0},
					{"SE_good_peasant",0,0}
					   };
for i=1,table.length(SE_PEASANT_ARRAY) do 
	x,y = GetObjectPosition(SE_PEASANT_ARRAY[i][1]);
	SE_PEASANT_ARRAY[i][2] = x; SE_PEASANT_ARRAY[i][3] = y;
	SetObjectEnabled(SE_PEASANT_ARRAY[i][1],nil);
end;

S_PEASANT_ARRAY = {{"S_good_peasant01",0,0},
				  {"S_good_peasant02",0,0},
				  {"S_good_squire",0,0}
			};
for i=1,table.length(S_PEASANT_ARRAY) do 
	x,y = GetObjectPosition(S_PEASANT_ARRAY[i][1]);
	S_PEASANT_ARRAY[i][2] = x; S_PEASANT_ARRAY[i][3] = y;
	SetObjectEnabled(S_PEASANT_ARRAY[i][1],nil);
end;
SetObjectEnabled("N_good_peasant",nil);
SetObjectEnabled("E_peasant",nil);

REGIONS = {
			{"south_west_village",SW_PEASANT_ARRAY},
			{"central_village", C_PEASANT_ARRAY},
			{"south_village",S_PEASANT_ARRAY},
			{"south_east_village",SE_PEASANT_ARRAY}
		  };
REGIONS.n = table.length(REGIONS);
for i=1,REGIONS.n do SetRegionBlocked(REGIONS[i][1],not nil,PLAYER_3); end;
SetRegionBlocked("north_west_village",not nil,PLAYER_3);
SetRegionBlocked("north_east_village",not nil,PLAYER_3);
SetRegionBlocked("SE_castle",not nil,PLAYER_2);
SetRegionBlocked("SW_castle",not nil,PLAYER_2);
SetRegionBlocked("NE_castle",not nil,PLAYER_2);
SetRegionBlocked("NW_castle",not nil,PLAYER_2);

GOOD_UNITS = {"SE_good_peasant","C_good_peasant","CW_good_peasant","S_good_peasant01","S_good_peasant02","S_good_squire","N_good_peasant"};

HUTS = {"south_west_house01",
		"south_west_house02",
		"central_house01",
		"central_house02",
		"central_house03",
		"north_house01",
		"east_house01",
		"south_east_house01",
		"south_east_house02",
		"south_east_house03",
		"south_east_house04",
		"south_east_house05",
		"south_house01",
		"south_house02"
		};
for i=1,table.length(HUTS) do SetObjectEnabled(HUTS[i],nil); end;


--EnableHeroAI(OUR_HERO_LASZLO,nil);
-- Global script Variables

MustFollow = 1;-- Должен или нет Ласзло следовать за Фрейдой в режиме реал-тайм. По умолчанию включен.
TownsRazed = 0;-- Счетчик числа разрушенных городов.
RazedPeasantHut = 0;-- Счетчик числа разрушенных домиков добрых поселян
SavedGoodUnits = 0; -- Счетчик числа спасенных "правильных" юнитов (в дополнительном обжективе)
GoodUnitsLost = 0; -- Логическая переменная. Если "правильный" юнит потерян = 1, пока нет = 0.(в дополнительном обжективе)

-- Логические переменные. Первый бой с любым монстром перевертышем не может быть в режиме QuickCombat. 
-- После первого боя с кричей заданного типа соответствующая переменная переключается в not nil. Все последующие комбаты с кричами этого типа могут быть QuickCombat.
infSuccubusFirstCombat = nil;
succubusFirstCombat = nil;
hornedDemonFirstCombat = nil;
demonFirstCombat = nil;
impFirstCombat = nil;
familiarFirstCombat = nil;



print("variables defined");

-- Difficulty dependencies
SetPlayerStartResource(PLAYER_1,ORE,0);
SetPlayerStartResource(PLAYER_1,WOOD,0);
SetPlayerStartResource(PLAYER_1,MERCURY,0);
SetPlayerStartResource(PLAYER_1,SULFUR,0);
SetPlayerStartResource(PLAYER_1,CRYSTAL,0);
SetPlayerStartResource(PLAYER_1,GEM,0);
SetPlayerStartResource(PLAYER_1,GOLD,0);


if GetDifficulty() == DIFFICULTY_EASY then
	print("Difficulty level is EASY");
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_CAVALIER, 2);
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_GRIFFIN, 8);
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_LONGBOWMAN, 15);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_ARCHER,50);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_CAVALIER,3);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_GRIFFIN, 10);
	DF = 0;
else
	if GetDifficulty() == DIFFICULTY_NORMAL then
		print("Difficulty level is NORMAL");
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_CAVALIER, 2);
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_GRIFFIN, 8);
		AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_LONGBOWMAN, 15);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_ARCHER,50);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_CAVALIER,3);
		AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_GRIFFIN, 10);
		DF = 1;
	else
		if GetDifficulty() == DIFFICULTY_HARD then
			print("Difficulty level is HARD");
			AddHeroCreatures(OUR_HERO_FREYDA,CREATURE_LONGBOWMAN, 10);
			AddHeroCreatures(OUR_HERO_LASZLO,CREATURE_ARCHER,50);
			DF = 2;
		else
			if GetDifficulty() == DIFFICULTY_HEROIC then
				print("Difficulty level is HEROIC");
				DF = 3;
			end;
		end;
	end;
end;

DisableCameraFollowHeroes(0,1,0);
--  #####################################  --  
--#########################################--
--## ============ FUNCTIONS ============ ##--

function LaszloTurn()
	while 1 do
		sleep(5);
		while GetCurrentPlayer() ~= PLAYER_2 do sleep(2); end;
			MustFollow = 0;
			if IsHeroAlive(OUR_HERO_LASZLO) == not nil then
				if mod(GetDate(DAY),3) == 0 then 
					ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,-1800);	
				else
					ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,-3000);	
					print("Laszlo stands ground. MP = ",GetHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS));
				end;
			else
				print("Thread LaszloTurn terminated. Laszlo is dead");
				return
			end;
			print("Laszlo turn...");
		while GetCurrentPlayer() == PLAYER_2 do sleep(2); end;
			MustFollow = 1;
			print("End Laszlo turn");
	end;
end;


-- Функция проверяет, существует ли объект, который хочется удалить, если да - удаляет.
function RemoveObjectIfExists(ObjectName) 
	if IsObjectExists(ObjectName)==not nil then 
		RemoveObject(ObjectName);
		print("RemoveObjectIfExits: Object ",ObjectName," successfully removed");
	else 
		print("RemoveObjectIfExits: Object ",ObjectName," already does not exist");
	end;
end;

-- Функция проверяет, существует ли объект для которого хотят запустить триггер, если да - запускает.
function TriggerIfObjectExists(TriggerType,ObjectName,Function)
	if IsObjectExists(ObjectName)==not nil then 
		Trigger(TriggerType,ObjectName,Function);
		print("TriggerIfObjectExists: For Object ",ObjectName," run Trigger for function ",Function );
	else 
		print("TriggerIfObjectExists: Object ",ObjectName," already does not exist");
	end;
end;



-- Функция вычисляющая расстояние от объекта Object1 до объекта Object2.
-- Если объекты находятся на разных уровнях функция возвращает -1.
function Distance(Object1,Object2)
	if IsObjectExists(Object1) == not nil then 
		Obj1_x,Obj1_y,Obj1_z = GetObjectPosition(Object1); 
	else
		print("Object1 ",Object1," doesn't exist");
		return -1;
	end;
	if IsObjectExists(Object2) == not nil then 
		Obj2_x,Obj2_y,Obj2_z = GetObjectPosition(Object2);
	else
		print("Object2 ",Object2," doesn't exist");
		return -1;
	end;
	if Obj1_z == Obj2_z then
		SQRT = sqrt((Obj1_x - Obj2_x)*(Obj1_x - Obj2_x) + (Obj1_y - Obj2_y)*(Obj1_y - Obj2_y));
		return SQRT;
		else
		print("Error. Objects are not at same ground level.");
		return -1;
	end;
end;

-- Функция сопровождения героя Master героем Slave на расстоянии Radius.
function FollowHeroRealTime(Master, Slave, Radius)
	while 1 do
		sleep(5);
		if IsHeroAlive(Master) == nil or IsHeroAlive(Slave) == nil then --or Distance(Master,Slave) == -1 then
			print("hero alive master = ",IsHeroAlive(Master) );
			print("hero alive slave = ",IsHeroAlive(Slave) );
			print("Distance value = ", Distance(Master,Slave) );
			print("One of heroes is dead. Thread FollowHeroRealTime terminated...");
			return 
		end;
		while Distance(Master,Slave) >= Radius and MustFollow == 1 and Distance(Master,Slave) ~=-1 do
			local slavemax = GetHeroStat(Slave,STAT_MOVE_POINTS);
			local x,y,z = GetObjectPosition(Master);
			MovePrice = CalcHeroMoveCost(Slave,x,y,z);
			--local walkmax = 300+slavemax;
			if CanMoveHero(Slave,x,y,z) == not nil then
				--if MovePrice > walkmax then MovePrice = walkmax end;
				ChangeHeroStat(Slave,STAT_MOVE_POINTS,-slavemax);
				ChangeHeroStat(Slave,STAT_MOVE_POINTS,MovePrice-300);
				MoveHeroRealTime(Slave,x,y,z);
			end;
			sleep(5);
		end;
	end;
end;

-- Функция разрушающая город после его захвата игроком. Разрушение не приосходит пока в гарнизоне города есть герой.
function RazeCapturedTown(TownName)
	while GetObjectOwner(TownName) ~= PLAYER_1 do
		sleep(10);
	end;
	print(TownName," Town is captured");
	while GetTownHero(TownName) ~= nil do
		sleep(10);
	end;
	RazeTown(TownName);
	TownsRazed = TownsRazed + 1;
	local x,y = GetObjectPosition( TownName );
	x = x+2;
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x-1,y,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x+1,y,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x,y-1,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x,y+1,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag1", x+2,y,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag2", x,y,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag3", x-2,y,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag4", x,y+2,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag5", x,y-2,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag2", x+1,y+1,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag3", x-1,y-1,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag4", x+1,y-1,0,GROUND);
	sleep(1);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag5", x-1,y+1,0,GROUND);
end;

function RazeHutEffects(ObjectName,sleep1,sleep2,sleep3,sleep4)
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", ObjectName);
	--sleep(sleep1);
	PlayVisualEffect("/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)",ObjectName,"flame");
	PlayVisualEffect("/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)",ObjectName,"flame2",1,0,0);
	PlayVisualEffect("/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)",ObjectName,"flame3",-1,0,0);
	sleep(sleep2);
	StopVisualEffects("flame");
	StopVisualEffects("flame2");
	StopVisualEffects("flame3");
	--sleep(sleep3);
	--PlayVisualEffect("/Effects/_(Effect)/Characters/WarMachines/Ballista_WildFire/death.(Effect).xdb#xpointer(/Effect)",ObjectName);
	sleep(sleep4);
	PlayVisualEffect( "/Effects/_(Effect)/Environment/Inferno/FireDots/FireDots_03.xdb#xpointer(/Effect)", ObjectName,"dust1");
	PlayVisualEffect( "/Effects/_(Effect)/Environment/Inferno/FireDots/FireDots_03.xdb#xpointer(/Effect)", ObjectName,"dust2",1,0,0);
	PlayVisualEffect( "/Effects/_(Effect)/Environment/Inferno/FireDots/FireDots_03.xdb#xpointer(/Effect)", ObjectName,"dust3",-1,0,0);
end;

-- Если Peasant Hut посетила Фрейда - ломать домик и увеличивать значение переменной RazedPeasantHut на 1.
function RazeHut(HeroName,ObjectName)
	print("Thread RazeHut started");
	if HeroName == OUR_HERO_FREYDA or HeroName == OUR_HERO_LASZLO then
		
		if dialog_c1m2s3 == 0 and HeroName == OUR_HERO_FREYDA then
			Save("autosave");
			StartDialogScene("/DialogScenes/A1C1/M2/S2/DialogScene.xdb#xpointer(/DialogScene)");
			dialog_c1m2s3 = 1;
		end;
		
		Trigger(OBJECT_TOUCH_TRIGGER,ObjectName,nil);
		RazedPeasantHut = RazedPeasantHut + 1;
		SetObjectiveProgress( "DestroyPeasantHuts", RazedPeasantHut );
		--RazeHutEffects(ObjectName,1,25,1,5);
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", ObjectName);
		sleep(3);
		PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", ObjectName);
		RazeBuilding(ObjectName);
		print("RazedPeasantHut = ",RazedPeasantHut);
		print("Peasant hut has been removed...");
	end;
end;

-- Функция возвращает ID кричи, которая охраняет объект ObjectName. Работает только если крича есть в массиве CREATURES.
function GetCreatureType(ObjectName)
	local CREATURES = {CREATURE_MILITIAMAN,CREATURE_FOOTMAN,CREATURE_GRIFFIN,CREATURE_PEASANT,CREATURE_SWORDSMAN,CREATURE_ROYAL_GRIFFIN, CREATURE_LANDLORD, CREATURE_VINDICATOR};
	for i=1,table.length(CREATURES) do 
		if GetObjectCreatures(ObjectName,CREATURES[i]) > 0 then return CREATURES[i];end;
	end;
	print("Creatures quantity = 0 or I don't know creatures of this type :(");return -1;
end;

-- Функция удаляет юнита, если его потрогал любой герой кроме Фрейды.
-- Если потрогала Фрейда, то запускает комбат с инфернальными кричами вместо кричей, которые, потрогали. Количество и уровень 
-- кричей инферно столько же, сколько было в стеке, на который напали.
function RemovePeasant(HeroName,ObjectName)
	print("RemovePeasant started");
	TriggerIfObjectExists(OBJECT_TOUCH_TRIGGER,ObjectName,nil);
	CrQuantity = GetObjectCreatures(ObjectName, GetCreatureType(ObjectName));
	--RemoveObjectIfExists(ObjectName);
	sleep(5);
	if HeroName == OUR_HERO_FREYDA then
		print("Creatures Quantity = ", CrQuantity);
		if CrQuantity > 0 then
			IntCount = (CrQuantity - mod(CrQuantity,4))/4;
			ModCount = mod(CrQuantity,4);
			if ModCount == 0 then ModCount = IntCount; end;
			if GetCreatureType(ObjectName) == CREATURE_ROYAL_GRIFFIN then				
				if infSuccubusFirstCombat == nil	then 
					PlayCreatureTransforming( ObjectName, CREATURE_INFERNAL_SUCCUBUS, CrQuantity );
				end;
				StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_SUCCUBUS,IntCount,CREATURE_INFERNAL_SUCCUBUS ,IntCount,CREATURE_INFERNAL_SUCCUBUS ,IntCount,CREATURE_SUCCUBUS,ModCount,nil,nil,nil,infSuccubusFirstCombat );
				infSuccubusFirstCombat = not nil;
			else
				if GetCreatureType(ObjectName) == CREATURE_GRIFFIN then					
					if succubusFirstCombat == nil	then 
						PlayCreatureTransforming( ObjectName, CREATURE_SUCCUBUS, CrQuantity );
					end;
					StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_SUCCUBUS,IntCount,CREATURE_SUCCUBUS,IntCount,CREATURE_INFERNAL_SUCCUBUS,IntCount,CREATURE_SUCCUBUS,ModCount,nil,nil,nil,succubusFirstCombat);
					succubusFirstCombat = not nil;
				else
					if GetCreatureType(ObjectName) == CREATURE_SWORDSMAN then	
						if hornedDemonFirstCombat == nil	then 
							PlayCreatureTransforming( ObjectName, CREATURE_HORNED_DEMON, CrQuantity );
						end;
						StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_HORNED_DEMON,IntCount,CREATURE_DEMON,IntCount,CREATURE_HORNED_DEMON,IntCount,CREATURE_DEMON,ModCount,nil,nil,nil,hornedDemonFirstCombat);
						hornedDemonFirstCombat  = not nil;
					else
						if GetCreatureType(ObjectName) == CREATURE_FOOTMAN then							
							if demonFirstCombat == nil	then 
								PlayCreatureTransforming( ObjectName, CREATURE_DEMON, CrQuantity );
							end;
							StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_DEMON,IntCount,CREATURE_DEMON,IntCount,CREATURE_DEMON,IntCount,CREATURE_DEMON,ModCount,nil,nil,nil,demonFirstCombat);
							demonFirstCombat  = not nil;
						else
							if GetCreatureType(ObjectName) == CREATURE_MILITIAMAN then								
								if impFirstCombat == nil	then 
									PlayCreatureTransforming( ObjectName, CREATURE_IMP, CrQuantity );
								end;
								StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_FAMILIAR ,IntCount,CREATURE_IMP,IntCount,CREATURE_IMP,IntCount,CREATURE_FAMILIAR ,ModCount,nil,nil,nil,impFirstCombat);
								impFirstCombat  = not nil;
							else
								if GetCreatureType(ObjectName) == CREATURE_PEASANT then								
									if familiarFirstCombat == nil	then 
										PlayCreatureTransforming( ObjectName, CREATURE_FAMILIAR, CrQuantity );
									end;
									StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_FAMILIAR ,IntCount,CREATURE_FAMILIAR,IntCount,CREATURE_FAMILIAR,IntCount,CREATURE_FAMILIAR ,ModCount,nil,nil,nil,familiarFirstCombat);								
									familiarFirstCombat  = not nil;
								end;
							end;
						end;
					end;
				end;
			end;
		else
			print("Unknown type of creatures. Standard combat starts...");
			StartCombat(OUR_HERO_FREYDA,nil,4,CREATURE_IMP,10,CREATURE_IMP,10,CREATURE_IMP,10,CREATURE_IMP,10);
		end;
	end;
	RemoveObjectIfExists(ObjectName);
	print("Hero ",HeroName," touch object ",ObjectName," and it was removed");
end;

function PlayCreatureTransforming( ObjectName, creatureType, creaturesQuantity )
	BlockGame();
	PlayObjectAnimation( ObjectName, "death", ONESHOT_STILL );
	PlayVisualEffect("/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", ObjectName);
	sleep(3);
	local x,y = GetObjectPosition( ObjectName );
	sleep(1);
	RemoveObjectIfExists(ObjectName);
	sleep(2);
	CreateMonster( "monster", creatureType, creaturesQuantity, x, y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT );
	sleep(6);
	RemoveObjectIfExists("monster");
	UnblockGame();
end;

-- Функция включает функциональность "хорошему" юниту, если его потрогала Фрейда. Впоследствии он должен присоединиться.
-- Если потрогала не Фроейда - обработчик снимается.
function RemoveGoodPeasant( HeroName, ObjectName )
	print("RemoveGoodPeasant(): Function for object ",ObjectName," and hero ",HeroName," started");
	TriggerIfObjectExists(OBJECT_TOUCH_TRIGGER,ObjectName,nil);
	if HeroName == OUR_HERO_FREYDA then
		--SetObjectEnabled(ObjectName,not nil);
		PlayObjectAnimation( ObjectName, "happy", ONESHOT);
		SavedGoodUnits = SavedGoodUnits + 1;
		if SavedGoodUnits == 1 and goodUnitsQuantity() >= 5 then 
			SetObjectiveState("SaveUncorruptedUnits",OBJECTIVE_ACTIVE);
			startThread(Objective_SaveUncorrupted);
		end;
		sleep(12);
		MessageBox( "Maps/Scenario/A1C1M2/MessaegBox_PeasantSaved.txt");
		GoodCrQuantity = GetObjectCreatures( ObjectName, GetCreatureType(ObjectName) );
		sleep(1);
		AddHeroCreatures( OUR_HERO_FREYDA, GetCreatureType( ObjectName ), GoodCrQuantity );
		if GetObjectiveState("SaveUncorruptedUnits") == OBJECTIVE_ACTIVE then
			if SavedGoodUnits <= 5 then 
				SetObjectiveProgress("SaveUncorruptedUnits",SavedGoodUnits);
			end;
		end;
	else
		print("Hero ",HeroName," touch good object ",ObjectName," and it was removed");
	end;
	RemoveObjectIfExists(ObjectName);
end;


-- Функция приказывает Ласзло атаковать объект ObjectName до тех пор, пока последний существует на карте. 
function MoveToThisObject(ObjectName, ObjectX, ObjectY)
	SetObjectEnabled(ObjectName, not nil);
	print("MoveToThisObject(): Thread MoveToThisObject for ",ObjectName," with x=",ObjectX,", y=",ObjectY," has been started...");
	Trigger( OBJECT_TOUCH_TRIGGER, ObjectName, nil );
	ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,2500);
	sleep(1);
	while IsObjectExists( ObjectName ) == not nil do
		MoveHeroRealTime( OUR_HERO_LASZLO, ObjectX, ObjectY );
		sleep(2);
	end;
	--print("Removing object...");
	--RemoveObjectIfExists( ObjectName );
	ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,-2500);
end;


-- Функция приказывает Ласзло атаковать объект ObjectName до тех пор, пока последний существует на карте. 
function MoveToThisObject2(ObjectName, ObjectX, ObjectY)
	--EnableHeroAI(OUR_HERO_LASZLO,nil); --H55 fix
	print("Thread MoveToThisObject for ",ObjectName," with x=",ObjectX,", y=",ObjectY,"has been started...");
	Trigger( OBJECT_TOUCH_TRIGGER, ObjectName, nil );
	--ChangeHeroStat(OUR_HERO_FREYDA,STAT_MOVE_POINTS,-2500);
	ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,2500);
	--MoveHeroRealTime(,ObjectX, ObjectY);
	print("Moving to object...");
	while 1 do
		if IsObjectExists(ObjectName) ~= not nil then print("Killed! Not exists!"); break end;
		MoveHeroRealTime( OUR_HERO_LASZLO, ObjectX, ObjectY );
		sleep(5);
		if Distance( OUR_HERO_LASZLO, ObjectName ) < 3.0 then print("Killed by distance!"); break end;
		print("Thinking...");
	end;
	print("Removing object...");
	RemoveObjectIfExists( ObjectName );
	print("MoveToThisObject OK");
	ChangeHeroStat(OUR_HERO_LASZLO,STAT_MOVE_POINTS,-2500);
	--EnableHeroAI(OUR_HERO_LASZLO,not nil); --H55 fix
end;

function GetObjectRegion( objectName )
	print("thread GetObjectRegion started...");
	if objectName == "SW_start_massacre" then return SW_PEASANT_ARRAY; end;
	if objectName == "C_start_massacre"  then return C_PEASANT_ARRAY; end;
	if objectName == "SE_start_massacre" then return SE_PEASANT_ARRAY; end;
	if objectName == "S_gold" 			 then return S_PEASANT_ARRAY; end;
end;

-- Функции для атаки юнитов на карте. По MoveHeroRealTime герой посылается к цели пока не будет уничтожен. Для каждого региона на карте
-- это своя функция. SW - south_west_village, S - south_village, N - notrh_village, SW - south_west_village, SE - south_east_village,
-- На время работы функции алгоритм преследования Фрейды героем Ласзло отключается.(MustFollow = 0) 
function StartMassacre( HeroName, ObjectName )
	print("Function StartMassacre started");
	TriggerIfObjectExists(OBJECT_TOUCH_TRIGGER, ObjectName, nil);
	print("trigger terminated...");
	if HeroName == OUR_HERO_FREYDA then
		MustFollow = 0;
		if HeroName == OUR_HERO_FREYDA or HeroName == OUR_HERO_LASZLO then
			region = GetObjectRegion( ObjectName );
			print("region is ", region);
			if region ~= nil then
				for j=1,table.length(region) do 
					if IsObjectExists( region[j][1] ) == not nil then
						MoveToThisObject( region[j][1], region[j][2], region[j][3] );
						sleep(2);
					end;
				end;
			end;
		end;
		MustFollow = 1;
	end;
end;

function N_StartMassacre( HeroName )
	MustFollow = 0;
	Trigger(OBJECT_TOUCH_TRIGGER, "N_gold", nil);
	if HeroName == OUR_HERO_FREYDA then
		if IsObjectExists("N_good_peasant") == not nil then 
			ObjX,ObjY = GetObjectPosition("N_good_peasant");
			MoveToThisObject("N_good_peasant",ObjX,ObjY);
		end;
	end;
	MustFollow = 1;
end;

-- Функция, срабатывает по триггеру REGION_ENTER, определяет в какой регион вошел герой и если это Фрейда, то 
-- атаковать героем Ласзло пизанта из этой деревни, издавая при этом ужасающие проклятья.

function LaszloMassacre( HeroName )
	if HeroName == OUR_HERO_FREYDA then
		local z = 0;
		for i = 1,REGIONS.n do
			if IsObjectInRegion(OUR_HERO_FREYDA,REGIONS[i][1])==not nil then 
				Peasants = REGIONS[i][2];
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, REGIONS[i][1],nil)
				z = i;
				break; 
			end;
		end;
		
		print("REGIONS[",z,"] = ",REGIONS[z][1]);
		
		MustFollow = 0;
		if REGIONS[z][1] ~= "south_village" then
			Play2DSound("/Sounds/_(Sound)/Creatures/Haven/Swordsman/happy.xdb#xpointer(/Sound)",GetObjectPosition(OUR_HERO_LASZLO));
			if IsObjectExists(Peasants[1][1]) == not nil then
				MoveToThisObject( Peasants[1][1], Peasants[1][2], Peasants[1][3] );--Laszlo kills first victim
			else
				print("Object ",Peasants[1][1]," does not exist");
			end;
		else
			print("It is the 'south village'. Laszlo doesn't kill anybody while Freyda doesn't take gold");
		end;
		MustFollow = 1;
	else
		print("Hero ",HeroName," has entered in region");
	end;
end;

function addGuardToGarrison( townName )
	while IsObjectExists( townName ) == not nil do
		while (GetCurrentPlayer() ~= PLAYER_1 and IsObjectExists( townName ) == not nil) do sleep(3); end;		
		if IsObjectGuarded( townName ) == 0 then 
			if IsObjectExists( townName ) == not nil then
				AddObjectCreatures( townName, CREATURE_PEASANT, 1 );
			end;
		end;
		sleep(6);
	end;
end;

function IsObjectGuarded( objectName )
	for i=1, 116 do
		if IsObjectExists( objectName ) == not nil and GetObjectCreatures( objectName, i ) > 0 then
			return 1;
		end;
	end;
	return 0;
end;

function manageGoodUnits()
	sleep(1);
	RemoveObjectCreatures("SW_good_peasant",CREATURE_LANDLORD,GetObjectCreatures("SW_good_peasant",CREATURE_LANDLORD)-1);
	AddObjectCreatures("SW_good_peasant",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("SE_good_peasant",CREATURE_LANDLORD,GetObjectCreatures("SE_good_peasant",CREATURE_LANDLORD)-1);
	AddObjectCreatures("SE_good_peasant",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("C_good_peasant",CREATURE_LANDLORD,GetObjectCreatures("C_good_peasant",CREATURE_LANDLORD)-1);
	AddObjectCreatures("C_good_peasant",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("S_good_peasant01",CREATURE_LANDLORD,GetObjectCreatures("S_good_peasant01",CREATURE_LANDLORD)-1);
	AddObjectCreatures("S_good_peasant01",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("S_good_peasant02",CREATURE_LANDLORD,GetObjectCreatures("S_good_peasant02",CREATURE_LANDLORD)-1);
	AddObjectCreatures("S_good_peasant02",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("N_good_peasant",CREATURE_LANDLORD,GetObjectCreatures("N_good_peasant",CREATURE_LANDLORD)-1);
	AddObjectCreatures("N_good_peasant",CREATURE_LANDLORD,80-10*GetDifficulty());
	
	RemoveObjectCreatures("S_good_squire",CREATURE_LANDLORD ,GetObjectCreatures("S_good_squire",CREATURE_LANDLORD )-1);
	AddObjectCreatures("S_good_squire",CREATURE_LANDLORD ,40-10*GetDifficulty());
end;

function goodUnitsQuantity()
	j = 0;
	for i=1,table.length(GOOD_UNITS) do
		if IsObjectExists(GOOD_UNITS[i]) == not nil then 
			j = j + 1;
		end;
	end;
	return j;
end;

function test_sound()
	Play3DSound("/Sounds/_(Sound)/Creatures/Haven/Swordsman/happy.xdb#xpointer(/Sound)",GetObjectPosition(OUR_HERO_LASZLO));
end;

function test_effect()
	PlayVisualEffect("\Effects\_(Effect)\Characters\Heroes\DemonLord\Path\Level_2b.xdb#xpointer(\Effect)",24,32,0,GROUND);
end;

function fatherFrost()
	PlayObjectAnimation( "father_frost", "stir00", ONESHOT );
	sleep(2);
	PlayObjectAnimation( "snegurka", "stir00", ONESHOT );
	sleep(7);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "el_tsarevna" );
	sleep(2);
	for i=1,10 do
		PlayObjectAnimation( "detvora"..i, "death", ONESHOT_STILL );
	end;
	sleep(4);
	PlayObjectAnimation( "father_frost", "happy", ONESHOT );
	PlayVisualEffect( "/Effects/_(Effect)/Towns/Inferno/DemonGate.xdb#xpointer(/Effect)", "el_tsarevna" );
end;

function domino( giantDelay, delay, animType, animAction )
	print("function domino started...");
	PlayObjectAnimation("giant1","attack00",ONESHOT);
	sleep(giantDelay);
	for i=1,23 do
		PlayObjectAnimation(""..i, animType, animAction);
		sleep(delay);
	end;
end;

function domino1()
	print("function domino1 started...");
	PlayObjectAnimation("giant1","attack00",ONESHOT);
	sleep(5);
	for i=1,41 do
		PlayObjectAnimation(""..i, "death", ONESHOT_STILL);
		sleep(1);
	end;
end;

function domino2()
	print("function domino2 started...");
	PlayObjectAnimation("giant2","attack00",ONESHOT);
	sleep(5);
	for i=41,1,-1 do
		PlayObjectAnimation(""..i, "death", ONESHOT_STILL);
		sleep(1);
	end;
end;

function preved()
	PlayObjectAnimation("scuko", "attack00", ONESHOT );
	sleep(4);
	PlayObjectAnimation("medved", "stir00", ONESHOT );
end;
-- =============== PRIMARY OBJECTIVES ============== --

-- Главный обжектив "Герои Фрейда и Ласзло должны выжить"
function ObjectiveHeroesMustSurvive(HeroName)
	if HeroName == OUR_HERO_FREYDA or HeroName == OUR_HERO_LASZLO then	
		print("One of our heroes is dead :(");
		SetObjectiveState("HeroesMustSurvive",OBJECTIVE_FAILED,PLAYER_1);
		sleep(15);
		Loose();
	end;
end;

-- Главный обжектив "Унитожить все города на карте"
-- При захвате любого города значение глобальной переменной TownsRazed увеличивается на 1. Всего на карте 4 города. При TownsRazed = 4 - комплит.
function ObjectiveDestroyTowns()
	while TownsRazed ~= 4 do
		sleep(10);
	end;
	SetObjectiveState("DestroyTowns",OBJECTIVE_COMPLETED);
	print("All Towns are razed...");
end;

-- Главный обжектив "Унитожить все домики крестьян"
-- Та же ботва, что и с ObjectiveDestroyTowns. Считается глобальная переменная RazedPeasantHut
function ObjectiveDestroyPeasantHuts()
	while RazedPeasantHut ~= 14 do
		sleep(10);
	end;
	SetObjectiveState("DestroyPeasantHuts",OBJECTIVE_COMPLETED);
	print("All Huts are razed...");
end;

-- Если главные обжективы выполены, миссия комплитится
function PlayerWin()
	while GetObjectiveState("DestroyTowns") ~= OBJECTIVE_COMPLETED or GetObjectiveState("DestroyPeasantHuts") ~= OBJECTIVE_COMPLETED do
		sleep(10);
	end;
	final();
end;

function final()
	BlockGame();
	SetAmbientLight(GROUND, "underground", not nil, 3);
	sleep(15);
	local x,y,z = GetObjectPosition(OUR_HERO_FREYDA);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x+2,y,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x+2,y+3,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x-2,y+2,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x-1,y+4,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x-2,y-2,0,GROUND);
	sleep(2);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", "","tag1", x+2,y,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", "","tag1", x+2,y+3,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", "","tag1", x-2,y+2,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", "","tag1", x-1,y+4,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", "","tag1", x-2,y-2,0,GROUND);
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "","tag1", x+2,y,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "","tag1", x+2,y+3,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "","tag1", x-2,y+2,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "","tag1", x-1,y+4,0,GROUND);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "","tag1", x-2,y-2,0,GROUND);
	sleep(2);
	if (x+2<95 and x+2>0) and (y<95 and y>0) then
		CreateMonster( "imp", CREATURE_IMP, 1, x+2, y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, -90 );
	else
		print("Monster imp is out of range");
	end;
	if (x+2<95 and x+2>0) and (y+3<95 and y+3>0) then
		CreateMonster( "demon", CREATURE_DEMON, 1, x+2, y+3, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, -45 );
	else
		print("Monster demon is out of range");
	end;
	if (x-2<95 and x-2>0) and (y+2<95 and y+2>0) then
		CreateMonster( "cerberi", CREATURE_CERBERI, 1, x-2, y+2, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 35 );
	else
		print("Monster cerberi is out of range");
	end;
	if (x-1<95 and x-1>0) and (y+4<95 and y+4>0) then
		CreateMonster( "succubus", CREATURE_INFERNAL_SUCCUBUS, 1, x-1, y+4, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 45 );
	else
		print("Monster succubus is out of range");
	end;
	if (x-2<95 and x-2>0) and (y-2<95 and y-2>0) then
		CreateMonster( "balor", CREATURE_BALOR, 1, x-2, y-2, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 135 );
	else
		print("Monster balor is out of range");
	end;
	sleep(3);
	SetObjectFlashlight("imp","fire");
	SetObjectFlashlight("demon","fire");
	SetObjectFlashlight("cerberi","fire");
	SetObjectFlashlight("succubus","fire");
	SetObjectFlashlight("balor","fire");
	SetObjectFlashlight(OUR_HERO_FREYDA,"good_light");
	print("lights enabled");
	sleep(10);
	PlayObjectAnimation("imp", "happy",ONESHOT);
	PlayObjectAnimation("demon", "happy",ONESHOT);
	PlayObjectAnimation("cerberi", "happy",ONESHOT);
	PlayObjectAnimation("succubus", "happy",ONESHOT);
	PlayObjectAnimation("balor", "happy",ONESHOT);
	print("animation happy played");
	--Play3DSound("/Sounds/_(Sound)/Creatures/Inferno/Cerberus/happy.xdb#xpointer(/Sound)",GetObjectPosition("cerberi"));
	--Play3DSound("/Sounds/_(Sound)/Creatures/Inferno/Balor/happy.xdb#xpointer(/Sound)",GetObjectPosition("balor"));
	--Play3DSound("/Sounds/_(Sound)/Creatures/Inferno/Demon/happy.xdb#xpointer(/Sound)",GetObjectPosition("demon"));
	--Play3DSound("/Sounds/_(Sound)/Creatures/Inferno/InfernalSuccubus/happy.xdb#xpointer(/Sound)",GetObjectPosition("succubus"));
	--Play3DSound("/Sounds/_(Sound)/Creatures/Inferno/Imp/happy.xdb#xpointer(/Sound)",GetObjectPosition("imp"));
	sleep(10);
	PlayObjectAnimation("imp", "move",ONESHOT_STILL);
	PlayObjectAnimation("demon", "move",ONESHOT_STILL);
	PlayObjectAnimation("cerberi", "move",ONESHOT_STILL);
	PlayObjectAnimation("succubus", "move",ONESHOT_STILL);
	sleep(1)
	PlayObjectAnimation("balor", "move",ONESHOT_STILL);
	print("animation move played");
	sleep(2);
	StartCombat(OUR_HERO_FREYDA, nil,5,CREATURE_BALOR,1+DF*1,CREATURE_INFERNAL_SUCCUBUS, 5+DF*2, CREATURE_CERBERI, 10+DF*3, CREATURE_DEMON, 25+DF*4, CREATURE_IMP, 70+DF*5,nil,"combatResult",nil,nil);
	print("combat started")
	RemoveObject("imp");
	RemoveObject("balor");
	RemoveObject("succubus");
	RemoveObject("demon");
	RemoveObject("cerberi");
	print("light is on");
	UnblockGame();
end;

function combatResult( heroName, result )
	if result ~= nil then
		print("you won!");
		SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M2");
		sleep(5);
		Win(PLAYER_1);
	end;
end;

function transform()
	RemoveObject( "devka" );
	SetObjectPosition( "tykva",37,31, GROUND );
end;
-- =============== SECONDARY OBJECTIVES ============== --

-- Если в первой деревне игрок спасет правильного крестьянина, то выдастся обжектив - "Спасти невинных крестьян"
-- При каждой встрече Изабелл с "хорошим" крестьянином к глобальной переменной SavedGoodUnits прибавляется 1. Как
-- только количество спасенных крестьян сравняется с общим количеством "правильных" юнитов на карте, обжектив комплитится.
-- Если хотя бы один пизант был убит Ласзло, глобальной переменной GoodUnitsLost присваивается 1 и обжектив фейлится.
function Objective_SaveUncorrupted()
	print("Thread Objective_SaveUncorrupted has been started...");
	while 1 do
		sleep(10);
		if (table.length(GOOD_UNITS) - SavedGoodUnits) - goodUnitsQuantity() > 2 then
			print("Good unit is lost :(");
			SetObjectiveState("SaveUncorruptedUnits",OBJECTIVE_FAILED);
			return
		end;
		if SavedGoodUnits == GOOD_UNITS_QUANTITY then
			print("All good units is saved!");
			SetObjectiveState("SaveUncorruptedUnits",OBJECTIVE_COMPLETED);
			sleep(6);
			MessageBox("Maps/Scenario/A1C1M2/MsgBox_HeroHasAttackDefense.txt","IncreaseStats");
			return
		end;
	end;
end;

function IncreaseStats()
	sleep(2);
	ShowFlyingSign( "Maps/Scenario/A1C1M2/FlyngMessage_IncrAttack.txt", OUR_HERO_FREYDA, PLAYER_1, 3 );
	ChangeHeroStat( OUR_HERO_FREYDA, STAT_ATTACK, 1 );
	sleep(4);
	ShowFlyingSign("Maps/Scenario/A1C1M2/FlyingMessage_IncrDefence.txt",OUR_HERO_FREYDA, PLAYER_1,3);
	ChangeHeroStat( OUR_HERO_FREYDA, STAT_DEFENCE, 1 );
	sleep(4);
	ShowFlyingSign("Maps/Scenario/A1C1M2/FlyingMessage_IncrSpell.txt",OUR_HERO_FREYDA, PLAYER_1,3);
	ChangeHeroStat( OUR_HERO_FREYDA, STAT_SPELL_POWER, 1 );
	sleep(4);
	ShowFlyingSign("Maps/Scenario/A1C1M2/FlyingMessage_IncrKnowledge.txt",OUR_HERO_FREYDA, PLAYER_1,3);
	ChangeHeroStat( OUR_HERO_FREYDA, STAT_KNOWLEDGE, 1 );
end;

-- ================ MAIN ============================= --
--MessageBox( "/Maps/Scenario/A1C1M2/dialogscene_c1m2s1.txt" ); -- instead of DIALOGSCENE
StartDialogScene("/DialogScenes/A1C1/M2/S1/DialogScene.xdb#xpointer(/DialogScene)");


-- запуск функции реал-тайм преследования Фрейды героем Ласзло
startThread(FollowHeroRealTime, OUR_HERO_FREYDA, OUR_HERO_LASZLO, FOLLOWING_RADIUS);
startThread(LaszloTurn);
--startThread(IsMoving,OUR_HERO_FREYDA,OUR_HERO_LASZLO);
-- запуск функций разрушающих города при их посещении Фрейдой.
startThread(RazeCapturedTown,TOWN_1);
startThread(RazeCapturedTown,TOWN_2);
startThread(RazeCapturedTown,TOWN_3);
startThread(RazeCapturedTown,TOWN_4);
startThread( addGuardToGarrison, TOWN_1 );
startThread( addGuardToGarrison, TOWN_2 );
startThread( addGuardToGarrison, TOWN_3 );
startThread( addGuardToGarrison, TOWN_4 );
startThread( manageGoodUnits );

-- запуск триггеров, чекающий посетил ли герой крестьянский дом. HUTS - массив с именами домиков на карте
for i=1,table.length(HUTS) do
	Trigger(OBJECT_TOUCH_TRIGGER,HUTS[i],"RazeHut");
end;

-- запуск триггеров, чекающих не потрогал ли герой юнитов из деревни в регионе south_west_village.
for i=1,table.length(SW_PEASANT_ARRAY)-1 do
	Trigger( OBJECT_TOUCH_TRIGGER, SW_PEASANT_ARRAY[i][1],"RemovePeasant" );
end;
Trigger(OBJECT_TOUCH_TRIGGER,SW_PEASANT_ARRAY[table.length(SW_PEASANT_ARRAY)][1],"RemoveGoodPeasant");

-- запуск триггеров, чекающих не потрогал ли герой юнитов из деревни в регионе central_village.
for i=1,table.length(C_PEASANT_ARRAY)-1 do
	Trigger(OBJECT_TOUCH_TRIGGER,C_PEASANT_ARRAY[i][1],"RemovePeasant");
end;
Trigger(OBJECT_TOUCH_TRIGGER,C_PEASANT_ARRAY[table.length(C_PEASANT_ARRAY)][1],"RemoveGoodPeasant");

-- запуск триггеров, чекающих не потрогал ли герой юнитов из деревни в регионе south_east_village.
for i=1,table.length(SE_PEASANT_ARRAY)-1 do
	Trigger(OBJECT_TOUCH_TRIGGER,SE_PEASANT_ARRAY[i][1],"RemovePeasant");
end;
Trigger(OBJECT_TOUCH_TRIGGER,SE_PEASANT_ARRAY[table.length(SE_PEASANT_ARRAY)][1],"RemoveGoodPeasant");

-- запуск триггеров, чекающих не потрогал ли герой юнитов из деревни в регионе south_village.
for i=1,table.length(S_PEASANT_ARRAY) do
	Trigger(OBJECT_TOUCH_TRIGGER,S_PEASANT_ARRAY[i][1],"RemoveGoodPeasant");
end;

-- запуск триггера, чекающего не потрогал ли герой единственного пизанта в деревне в регионе north_village
Trigger(OBJECT_TOUCH_TRIGGER,"N_good_peasant","RemoveGoodPeasant");
Trigger(OBJECT_TOUCH_TRIGGER,"E_peasant","RemovePeasant");

-- запуск триггеров, чекающих не вошел ли герой в один из регионов на карте. запускает только на уровнях сложности HARD и HEROIC
for i=1,REGIONS.n do
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, REGIONS[i][1], "LaszloMassacre" );
end;

if GetDifficulty() == DIFFICULTY_HARD or GetDifficulty() == DIFFICULTY_HEROIC then
	-- запуск триггеров, чекающих не потрогал ли герой объекты  в деревнях, после лапания которых начинается резня в исполнении Ласзло. 
	Trigger(OBJECT_TOUCH_TRIGGER, "SW_start_massacre", "StartMassacre");
	Trigger(OBJECT_TOUCH_TRIGGER, "C_start_massacre", "StartMassacre");
	Trigger(OBJECT_TOUCH_TRIGGER, "SE_start_massacre", "StartMassacre");
	Trigger(OBJECT_TOUCH_TRIGGER,"S_gold","StartMassacre");
	--
	Trigger(OBJECT_TOUCH_TRIGGER,"N_gold","N_StartMassacre");
end;

print("functions and triggers are started");

H55_CamFixTooManySkills(PLAYER_1,"Freyda");

-- OBJECTIVES
-- запуск основных обжективов
Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1,"ObjectiveHeroesMustSurvive");
Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2,"ObjectiveHeroesMustSurvive");
startThread(ObjectiveDestroyTowns);
startThread(ObjectiveDestroyPeasantHuts);
startThread(PlayerWin);
print("objectives started");
print("MAP SUCCESSFULLY STARTED");