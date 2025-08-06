H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M1");
end;

startThread(H55_InitSetArtifacts);

AddHeroCreaturesOld = AddHeroCreatures;
AddHeroCreatures = function( hero, creature, num )
	if num >= 1 then
		AddHeroCreaturesOld( hero, creature, num );
	end;
end;
--Save("autosave");
StartDialogScene("/DialogScenes/A1C1/INTRO/I1/DialogScene.xdb#xpointer(/DialogScene)");
StartDialogScene("/DialogScenes/A1C1/M1/S1/DialogScene.xdb#xpointer(/DialogScene)");
for a = 0,6 do --- Устанавливаем стартовые ресурсы в 0
	SetPlayerResource(PLAYER_1, a, 0);
end;

SetHeroesExpCoef( 0.8 );
DisableCameraFollowHeroes( 0, 0, 1 );
MoveHeroRealTime( "Caldwell_DSU", 74, 18, 0 );
while GetObjectPosition( "Caldwell_DSU" ) > 74 do
	sleep( 1 );
end;
RemoveObject( "Caldwell_DSU" );
DisableCameraFollowHeroes( 0, 0, 0 );
---------------------------------------------------------------------
------------------ СТАРТОВЫЕ МАССИВЫ И ПЕРЕМЕННЫЕ -------------------
---------------------------------------------------------------------

EnemyHero1 = "Gillion" --- константа для имени первого героя эльфов
EnemyHero2 = "Itil" --- константа для имени второго героя эльфов
PlayerHero1 = "Freyda" --- константа для имени первого героя игрока Freida
PlayerHero2 = "Laszlo" --- константа для имени второго героя игрока Laszlo

removed_rebels = 0;

rebel_array = { "rebel1", "rebel2", "rebel3", "rebel4", "rebel5", "rebel6", "rebel7", "rebel8", "rebel9", "rebel10",
				"rebel11", "rebel12", "rebel13", "rebel14", "rebel15", "rebel16", "rebel17", "rebel18", "rebel19", "rebel20",
				"rebel21", "rebel22", "rebel23", "rebel24", "rebel25", "rebel26", "rebel27", "rebel28", "rebel29", "rebel30",
				"rebel31", "rebel32"}; --- Массив скриптовых имен мятежных кричей

farm_array = {"Farm1" , "Farm2" , "Farm3" , "Farm4" , "Farm5" , "Farm6" , "Farm7" , "Farm8"} --- Массив всех ферм

caldwellarmy_array  = {"caldwellarmy1" , "caldwellarmy2" ,"caldwellarmy3" ,"caldwellarmy4" , "caldwellarmy5" ,
					"caldwellarmy6", "caldwellarmy7", "caldwellarmy8", "caldwellarmy9", "caldwellarmy10",
					"caldwellarmy11", "caldwellarmy12", "caldwellarmy13", "caldwellarmy14", "caldwellarmy15",
					"caldwellarmy16", "caldwellarmy17", "caldwellarmy18", "caldwellarmy19"} --- Массив адвенчурной армии Калдвела

Randellarmy_array  = {"Randellarmy1" , "Randellarmy2" ,"Randellarmy3" ,"Randellarmy4" , "Randellarmy5" ,
					"Randellarmy6", "Randellarmy7", "Randellarmy8", "Randellarmy9", "Randellarmy10",
					"Randellarmy11", "Randellarmy12", "Randellarmy13", "Randellarmy14", "Randellarmy15",
					"Randellarmy16"} --- Массив адвенчурной армии Ронделла

elvenwar_array = {"elvenwar1" , "elvenwar2" , "elvenwar3" , "elvenwar4" , "elvenwar5" , "elvenwar6" , "elvenwar7"} --- Массив эльфийских войск в засаде на Красный апргрейд

elf_ambush_array= {"elf_ambush1" , "elf_ambush2" ,"elf_ambush3" ,"elf_ambush4" , "elf_ambush5" ,
				"elf_ambush6" ,"elf_ambush7" ,"elf_ambush8" ,"elf_ambush9"} --- Массив простых эльфийских засад

c_tier_array = {0 , 10 , 0 , 8 , 0 , 7 , 0 , 5 , 0 , 2 , 0 , 1 } --- Массив стартовой армии Калдвелла, порядковый номер числа в массиве совпадает с ID кричи

r_tier_array = {0 , 10 , 0 , 8 , 0 , 7 , 0 , 5 , 0 , 2 , 0 , 1 } --- Массив стартовой армии Ронделла, порядковый номер числа в массиве совпадает с ID кричи

h_tier_array = {107 , 106 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12} --- Массив ID кричей возможных в армиях героев игрока
l_tier_array = {10 , 20 , 20 , 20 , 10 , 10 , 5 , 5 , 3 , 3 , 2 , 2 , 1 , 1} --- Массив потерь при попадании в засаду и дезертирстве
t_tier_array = {"/Maps/Scenario/A1C1M1/messagebox_ambush1.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush2.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush3.txt" ,
				"/Maps/Scenario/A1C1M1/messagebox_ambush4.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush5.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush6.txt" ,
				"/Maps/Scenario/A1C1M1/messagebox_ambush7.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush8.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush9.txt" ,
				"/Maps/Scenario/A1C1M1/messagebox_ambush10.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush11.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush12.txt" ,
				"/Maps/Scenario/A1C1M1/messagebox_ambush13.txt" , "/Maps/Scenario/A1C1M1/messagebox_ambush14.txt"} --- Массив текстов

training_array = {"training1" , "training2" , "training3" , "training4" , "training5", "training6" , "training7",
					"training8" , "training9" , "training10" , "training11" , "training12" , "training13", "training14"} --- Массив анимационных кричей

effect_array = {"rangeattack" , "attack01" , "specability" , "death" , "hit" , "happy" , "idle00" , "stir00"} --- Массив анимаций

type_effect_array = {ONESHOT, ONESHOT, ONESHOT, ONESHOT_STILL , ONESHOT, ONESHOT, ONESHOT, ONESHOT}--- Массив типов пройгрышей анимаций

rebel_array_numbers = {}; --- Массив стартового количества кричей в каждом стеке мятежных кричей
rebel_array_final = {}; --- Массив финального количества (по достижении котороко крича телепортится) кричей в каждом стеке мятежных кричей
rebel_array_Names = {}; --- Массив ID кричей (крестьянин, лучник. и т.д.

-------------------------------- ID кричей -------------------------
CREATURE_PEASANT = 1
CREATURE_MILITIAMAN = 2
CREATURE_ARCHER = 3
CREATURE_MARKSMAN = 4
CREATURE_FOOTMAN = 5
CREATURE_SWORDSMAN = 6
CREATURE_GRIFFIN = 7
CREATURE_ROYAL_GRIFFIN = 8
CREATURE_PRIEST = 9
CREATURE_CLERIC = 10
CREATURE_CAVALIER = 11
CREATURE_PALADIN = 12

haven_obj = 0; --- Идентификатор - выдан ли обжектив про ред хевен трупс (т.к. в скрипте 2 условия выдачи обжектива)
multi_coeff = 10; --- Коэффицент потерь при попадании в засаду (чем больше число тем меньше потери)
obj_count = 0; --- Счетчик выполненных обжективов при достижении значения 3 миссия выигрываетс

---------------------------------------------------------------------
---------------- МОДИФИКАТОРЫ ОТ УРОВНЯ СЛОЖНОСТИ -------------------
---------------------------------------------------------------------

if GetDifficulty() == DIFFICULTY_EASY then
	diff = 0;
	print ("easy");
	AddHeroCreatures(PlayerHero1, 1, 70);
	AddHeroCreatures(PlayerHero1, 3, 44);
	AddHeroCreatures(PlayerHero1, 5, 37);
	AddHeroCreatures(PlayerHero1, 7, 29);
	AddHeroCreatures(PlayerHero1, 9, 14);
	AddHeroCreatures(PlayerHero1, 11, 7);
	sleep (1);
	RemoveObjectCreatures(PlayerHero1, 2, 10);
	AddHeroCreatures(PlayerHero2, 1, 70);
	AddHeroCreatures(PlayerHero2, 3, 44);
	AddHeroCreatures(PlayerHero2, 5, 37);
	AddHeroCreatures(PlayerHero2, 7, 29);
	AddHeroCreatures(PlayerHero2, 9, 14);
	AddHeroCreatures(PlayerHero2, 11, 7);
	sleep (1);
	RemoveObjectCreatures(PlayerHero2, 2, 10);
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	diff = 1;
    print ("normal");
	AddHeroCreatures(PlayerHero1, 1, 70);
	AddHeroCreatures(PlayerHero1, 3, 44);
	AddHeroCreatures(PlayerHero1, 5, 37);
	AddHeroCreatures(PlayerHero1, 7, 29);
	AddHeroCreatures(PlayerHero1, 9, 14);
	AddHeroCreatures(PlayerHero1, 11, 7);
	sleep (1);
	RemoveObjectCreatures(PlayerHero1, 2, 10);
	AddHeroCreatures(PlayerHero2, 1, 70);
	AddHeroCreatures(PlayerHero2, 3, 44);
	AddHeroCreatures(PlayerHero2, 5, 37);
	AddHeroCreatures(PlayerHero2, 7, 29);
	AddHeroCreatures(PlayerHero2, 9, 14);
	AddHeroCreatures(PlayerHero2, 11, 7);
	sleep (1);
	RemoveObjectCreatures(PlayerHero2, 2, 10);
end;

if GetDifficulty() == DIFFICULTY_HARD then
	diff = 2;
    print ("Hard");
	AddHeroCreatures(PlayerHero1, 2, 50);
	AddHeroCreatures(PlayerHero1, 4, 35);
	AddHeroCreatures(PlayerHero1, 6, 28);
	AddHeroCreatures(PlayerHero1, 8, 16);
	AddHeroCreatures(PlayerHero1, 10, 10);
	AddHeroCreatures(PlayerHero1, 12, 3);
	AddHeroCreatures(PlayerHero2, 2, 50);
	AddHeroCreatures(PlayerHero2, 4, 35);
	AddHeroCreatures(PlayerHero2, 6, 28);
	AddHeroCreatures(PlayerHero2, 8, 16);
	AddHeroCreatures(PlayerHero2, 10, 10);
	AddHeroCreatures(PlayerHero2, 12, 3);
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	diff = 3;
    print ("Impossible");
	AddHeroCreatures(PlayerHero1, 2, 30);
	AddHeroCreatures(PlayerHero1, 4, 20);
	AddHeroCreatures(PlayerHero1, 6, 15);
	AddHeroCreatures(PlayerHero1, 8, 10);
	AddHeroCreatures(PlayerHero1, 10, 5);
	AddHeroCreatures(PlayerHero1, 12, 1);
	AddHeroCreatures(PlayerHero2, 2, 30);
	AddHeroCreatures(PlayerHero2, 4, 20);
	AddHeroCreatures(PlayerHero2, 6, 15);
	AddHeroCreatures(PlayerHero2, 8, 10);
	AddHeroCreatures(PlayerHero2, 10, 5);
	AddHeroCreatures(PlayerHero2, 12, 1);
end;

AddObjectCreatures("rh1", 106, 99- 10*diff);
AddObjectCreatures("rh2", 106, 99- 10*diff);
AddObjectCreatures("rh3", 106, 99- 10*diff);
AddObjectCreatures("rh4", 107, 49- 5*diff);
AddObjectCreatures("rh5", 107, 49- 5*diff);

---------------------------------------------------------------------
----------------------- СТАРТОВЫЕ НАСТРОЙКИ КАРТЫ -------------------
---------------------------------------------------------------------


function Start_count() --Заполняем массивы мятежных кричей
	for num = 1, table.length(rebel_array) do
		for id = 1,12 do
			if GetObjectCreatures(rebel_array[num], id) > 0 then
				id_creature = id;
			end;
		end;
		rebel_array_numbers [num] = GetObjectCreatures(rebel_array[num], id_creature); -- стартовое значение
		rebel_array_final [num] = rebel_array_numbers [num]*(2 + diff*0.5); -- пороговое значение
		rebel_array_Names [num] = id_creature; -- ID кричи
	end;
end;

for f = 1,8 do -- вешаем триггеры на все фермы
	Trigger(OBJECT_CAPTURE_TRIGGER, farm_array[f] ,"secondary1");
end;

--- вешаем триггеры на эльфийские засады
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush4" ,"diff_ambush");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush30" ,"diff_ambush1");

for f = 1,9 do -- вешаем триггеры на простые эльфийские засады
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, elf_ambush_array[f] ,"ambush");
end;

H55_NewDayTrigger = 1;
-- Trigger(NEW_DAY_TRIGGER , "rebels_count"); --- Триггер на наступление нового дн

Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "haven_trigger", "red_haven_obj"); --- Альтернативное получение квеста на особождение РЕд Хавен ТРУпс

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "final_fight_Cadwell" ,"ffc"); --- Запуск скрипта сражения с Армией Кадвела

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "final_fight_Randall" ,"ffr"); --- Запуск скрипта сражения с Армией Рандалла

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Angels", "neitral"); --- Предупреждение от ангелов

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "cross", "crossroad"); --- Сообщение на перекрестке

function militia() --- В случае уничтожения первого отряда милиции открываются регионы с мятежными лидерами
	while 1 do
		sleep ( 5 );
		if IsObjectExists("rebel9") == nil then
			x,y,z = RegionToPoint("Caldwellzone");
			OpenCircleFog(x, y, z, 10 , PLAYER_1);
			sleep (5);
			x,y,z = RegionToPoint("Randallzone");
			OpenCircleFog(x, y, z, 10 , PLAYER_1);
			SetObjectiveState("sec2", OBJECTIVE_ACTIVE);
			break;
		end;
	end;
end;

function Treants() --- Месаджбокс про гвардов
	while 1 do
		sleep ( 10 );
		if IsObjectExists("treant") == nil then
			MessageBox ("/Maps/Scenario/A1C1M1/messagebox5.txt" );
			break;
		end;
	end;
end;

function elfdruids_kill() --- В случае уничтожения друидов снимаются все триггеры эльфийских засад
	while 1 do
		sleep ( 5 );
		if IsObjectExists("elfdruids") == nil then
			sleep ( 1 );
			if GetObjectiveState("elfdruids", PLAYER_1) == OBJECTIVE_UNKNOWN then
				SetObjectEnabled("questqiver", nil);
				Trigger(OBJECT_TOUCH_TRIGGER, "questqiver", "quest");
			--	SetObjectiveState( "elfdruids", OBJECTIVE_COMPLETED );
			end;

			for ef = 1,9 do -- снимаем триггеры с простых эльфийских засад
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, elf_ambush_array[ef] , nil);
			end;
			for fm = 1,8 do -- снимаем триггеры с ферм
				Trigger(OBJECT_CAPTURE_TRIGGER, farm_array[fm] ,nil);
			end;
			--if GetObjectiveState("sec1") ~= OBJECTIVE_COMPLETED then --- Если обжектив не закомпличен то делаем его не видимым
			--	SetObjectiveVisible("sec1", nil);
			--end;
			if IsHeroAlive(EnemyHero1) == not nil then --- Если 1ый эльфийский герой на карте то убираем его
				RemoveObject(EnemyHero1);
			end;
			if IsHeroAlive(EnemyHero2) == not nil then --- Если 2ой эльфийский герой на карте то убираем его
				RemoveObject(EnemyHero2);
			end;
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush30" ,nil);
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush4" ,nil);
			SetRegionBlocked("super_ambush20", nil, PLAYER_1);
			SetRegionBlocked("super_ambush3", nil, PLAYER_1);
			break;
		end;
	end;
end;

function quest()
	ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox11.txt", "questqiver", -1, 3.0);
end;

---------------------------------------------------------------------
----------------------- ГЛАВНЫЕ ФУНКЦИОНАЛЫ -------------------------
---------------------------------------------------------------------

function H55_TriggerDaily() --Очищаем массивы от убитых кричей
	startThread(dezert);
	if GetDate(ABSOLUTE_DAY) == 2 and haven_obj == 0 then --- Основной способ запуска обжектива Про РЕд Хавен Трупс на 1 день 2ой недели
		startThread(red_haven_obj);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "haven_trigger", nil);
	end;
	local j=1 --индекс временного массива
	local a={}
	local b={}
	local c={}
	local d={}
	for num = 1, table.length(rebel_array) do
		if IsObjectExists(rebel_array[num]) == nil then
--			print ("Creature ", rebel_array[num], " was killed");
		else
			a[j]=rebel_array[num];
			b[j]=rebel_array_numbers[num];
			c[j]=rebel_array_final[num];
			d[j]=rebel_array_Names[num];
			j=j+1;
		end;
	end;
--	print ("j = ",j);
	if j < 2 then
		if removed_rebels <= 16 then
			SetObjectiveState("sec2", OBJECTIVE_COMPLETED );
		else
			SetObjectiveState("sec2", OBJECTIVE_FAILED );
		end;
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 1;
		--Trigger(NEW_DAY_TRIGGER , "dezertiren"); --- Снимаем Триггер на наступление нового дня и перевешиваем его на другую функцию
		return
	else
--		print ("lenght massive = ",table.length(rebel_array));
	end;
	rebel_array = {}
	rebel_array_numbers = {}
	rebel_array_final = {}
	rebel_array_Names = {}
	rebel_array = a
	rebel_array_numbers = b
	rebel_array_final = c
	rebel_array_Names = d
	sleep (1);
	startThread(Training); -- Добавляем кричей в стеки на карте
end;

function H55_SecTriggerDaily()
	startThread(dezert);
end;

function Training() --- Функция рассчета прироста мятежных кричей
	for t = 1,7 do
		RND = random(table.length(rebel_array))+1;
		Creatures_Add = GetObjectCreatures(rebel_array[RND], rebel_array_Names[RND])/5;
		AddObjectCreatures(rebel_array[RND], rebel_array_Names[RND], Creatures_Add);
	end;
	sleep (1);
	startThread(Teleport); -- Телепортим кричи которые накопили максимум
end;

function Teleport() --- Функция телепорта накопившихся кричей и увеличени армий мятежных лордов
	rnd_lord = random(2);
	for num1 = 1, table.length(rebel_array) do
		if GetObjectCreatures(rebel_array[num1], rebel_array_Names[num1]) >  rebel_array_final[num1] then
--			print ("Creature ", rebel_array[num1], " have " , GetObjectCreatures(rebel_array[num1], rebel_array_Names[num1]) , " max = " , rebel_array_final[num1]);
			PlayVisualEffect( "/Effects/_(Effect)/Spells/DimesionDoorStart.xdb#xpointer(/Effect)", rebel_array[num1]);
			RemoveObject(rebel_array[num1]);
			removed_rebels = removed_rebels + 1;
			sleep (1);
			if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE and  GetObjectiveState("prim1") == OBJECTIVE_ACTIVE then --- Проверяем жив ли лорд и если нет то телепортив кричи к другому лорду
				rnd_lord = 1 - rnd_lord;
			else
				if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE then
					rnd_lord = 1;
				else
					if GetObjectiveState("prim1") == OBJECTIVE_ACTIVE then
						rnd_lord = 0;
					else
						return ---- Если оба лорда убиты просто выходим из функции
					end;
				end;
			end;
			if rnd_lord == 1 then
				x,y,z = RegionToPoint('NewRecrut1');
---				MoveCamera( x, y, z, 17, 0, 0, 0, 1 ); -- придвинуть камеру без поворотов
---				CreateMob("Fake", rebel_array_Names[num1], rebel_array_numbers[num1], x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
				cr_id = rebel_array_Names[num1] + 1;
				r_tier_array [cr_id] = r_tier_array [cr_id] + (rebel_array_numbers[num1]*(0.2 + diff*0.03));
			else
				x,y,z = RegionToPoint('NewRecrut2');
---				MoveCamera( x, y, z, 17, 0, 0, 0, 1 ); -- придвинуть камеру без поворотов
---				CreateMob("Fake", rebel_array_Names[num1], rebel_array_numbers[num1], x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
				cr_id = rebel_array_Names[num1] + 1;
				c_tier_array [cr_id] = c_tier_array [cr_id] + (rebel_array_numbers[num1]*(0.2 + diff*0.03));
			end;
			sleep (1);
		end;
	end;
	sleep (1);
end;

Trigger(REGION_ENTER_AND_STOP_TRIGGER , "archers1", "ambush1"); --- Реализация засады эльфийских стрелков на страте миссии
Trigger(REGION_ENTER_AND_STOP_TRIGGER , "archers2", "ambush1");
function ambush1( HeroName )
	startThread(ambush, HeroName);
	StartDialogScene("/DialogScenes/A1C1/M1/S2/DialogScene.xdb#xpointer(/DialogScene)");
	RazeBuilding("Destroy");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , "archers1", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , "archers2", nil);
	sleep (3);
	SetObjectiveState("sec1", OBJECTIVE_ACTIVE);
	sleep (5);
	BlockGame();
	for n_farm = 1,8 do
		x,y,z = GetObjectPosition( farm_array [n_farm] );
		OpenCircleFog(x, y, z, 5 , PLAYER_1);
		sleep (4);
		MoveCamera( x, y, z, 0, 0, 0, 1, 1, 1 );
	end;
	sleep( 4 );
	x, y, z = GetObjectPosition( PlayerHero1 );
	MoveCamera( x, y, z, 0, 0, 0, 1, 1, 1 );
	UnblockGame();
end;

function secondary1()-- Подсчет захваченых ферм
	_week = GetDate( WEEK ) + (GetDate( MONTH ) - 1) * 4 - 1;
	_coeff = diff * 0.2 + 0.5;
	farm_owner = 0;
	for f = 1,8 do
		if GetObjectOwner(farm_array[f]) == PLAYER_1 then
			Trigger(OBJECT_CAPTURE_TRIGGER, farm_array[f], nil);
		else
			farm_owner = 1;
			break;
		end;
	end;
	if farm_owner == 0 then --- Если все фермы захвачены игроком то ставим эльфийских героев и снимаем триггеры с регионов ловушек
		for ef = 1,9 do -- снимаем триггеры с простых эльфийских засад
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, elf_ambush_array[ef] , nil);
		end;
--		SetObjectiveState("sec1", OBJECTIVE_COMPLETED); ----------------------------##############DB############################
		DeployReserveHero(EnemyHero1, RegionToPoint('elven_hero_deploy2'));
		DeployReserveHero(EnemyHero2, RegionToPoint('elven_hero_deploy1'));
		sleep (1);
		EnableHeroAI(EnemyHero1, nil);
		EnableHeroAI(EnemyHero2, nil);
		sleep( 1 );
		exp = GetHeroStat(PlayerHero1, STAT_EXPERIENCE);
		ChangeHeroStat(EnemyHero1, STAT_EXPERIENCE , exp/(4-diff) + 1);
		AddHeroCreatures(EnemyHero1,44 , (20 + _week * 5) * _coeff);
		AddHeroCreatures(EnemyHero1,46 , (10 + _week * 3) * _coeff);
		AddHeroCreatures(EnemyHero1,48 , (6 + _week * 2) * _coeff);
		AddHeroCreatures(EnemyHero1,50 , (3 + _week * 2) * _coeff);
		AddHeroCreatures(EnemyHero1,52 , _week * _coeff );
		sleep (1);
		exp = GetHeroStat(PlayerHero2, STAT_EXPERIENCE);
		ChangeHeroStat(EnemyHero2, STAT_EXPERIENCE , exp/(4-diff) + 1);
		AddHeroCreatures(EnemyHero2,44 , (20 + _week * 5) * _coeff);
		AddHeroCreatures(EnemyHero2,46 , (10 + _week * 3) * _coeff);
		AddHeroCreatures(EnemyHero2,48 , (6 + _week * 2) * _coeff);
		AddHeroCreatures(EnemyHero2,50 , (3 + _week * 2) * _coeff);
		AddHeroCreatures(EnemyHero2,52 , _week * _coeff );
		MessageBox ("/Maps/Scenario/A1C1M1/messagebox4.txt" );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush30" ,nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush4" ,nil);
		SetRegionBlocked("super_ambush20", nil, PLAYER_1);
		SetRegionBlocked("super_ambush3", nil, PLAYER_1);
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" ); --- триггер на потерю героя игроком
function LostHero( HeroName )
	if HeroName == PlayerHero1 or HeroName == PlayerHero2 then
		SetObjectiveState("prim3", OBJECTIVE_FAILED);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		sleep (15);
		Loose();
	end;
end;

function dezert() --- Функция рассчета дезертиров
	if random (diff + 2) == 0 then
		return
	end;
	if random ( 2 ) == 0 then
		hero = PlayerHero1;
--		print (PlayerHero1);
	else
		hero = PlayerHero2;
--		print (PlayerHero2);
	end;
	massa = random (100);
	if massa > 97 then
		if GetHeroCreatures(hero, 12) > 0 then
			RemoveHeroCreatures(hero, 12, 1);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[14], hero, -1, 3.0 );
			return
		end;
		if GetHeroCreatures(hero, 11) > 0 then
			RemoveHeroCreatures(hero, 11, 1);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[13], hero, -1, 3.0 );
			return
		end;
	end;
	if massa > 94 then
		if GetHeroCreatures(hero, 10) > 1 then
			RemoveHeroCreatures(hero, 10, 2);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[12], hero, -1, 3.0 );
			return
		end;
		if GetHeroCreatures(hero, 9) > 1 then
			RemoveHeroCreatures(hero, 9, 2);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[11], hero, -1, 3.0 );
			return
		end;
	end;
	if massa > 89 then
		if GetHeroCreatures(hero, 8) > 2 then
			RemoveHeroCreatures(hero, 8, 3);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[10], hero, -1, 3.0 );
			return
		end;
		if GetHeroCreatures(hero, 7) > 2 then
			RemoveHeroCreatures(hero, 7, 3);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[9], hero, -1, 3.0 );
			return
		end;
	end;
	if massa > 79 then
		if GetHeroCreatures(hero, 6) > 4 then
			RemoveHeroCreatures(hero, 6, 5);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[8], hero, -1, 3.0 );
			return
		end;
		if GetHeroCreatures(hero, 5) > 4 then
			RemoveHeroCreatures(hero, 5, 5);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[7], hero, -1, 3.0 );
			return
		end;
	end;
	if massa > 49 then
		if GetHeroCreatures(hero, 4) > 9 then
			RemoveHeroCreatures(hero, 4, 10);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[6], hero, -1, 3.0 );
			return
		end;
		if GetHeroCreatures(hero, 3) > 9 then
			RemoveHeroCreatures(hero, 3, 10);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[5], hero, -1, 3.0 );
			return
		end;
	end;
	if GetHeroCreatures(hero, 2) > 19 then
		RemoveHeroCreatures(hero, 2, 20);
		ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
		sleep ( 4 );
		ShowFlyingSign (t_tier_array[4], hero, -1, 3.0 );
		return
	end;
	if GetHeroCreatures(hero, 1) > 19 then
		RemoveHeroCreatures(hero, 1, 20);
		ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox13.txt", hero, -1, 3.0);
		sleep ( 4 );
		ShowFlyingSign (t_tier_array[3], hero, -1, 3.0 );
		return
	end;
end;

function ambush( HeroName ) --- Функция рассчета потерь при попадании в засаду
	for a = 1,14 do
		if GetHeroCreatures(HeroName, h_tier_array[a]) > l_tier_array[a] then
			RemoveHeroCreatures(HeroName, h_tier_array[a], l_tier_array[a]);
			ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox12.txt", HeroName, -1, 3.0);
			sleep ( 4 );
			ShowFlyingSign (t_tier_array[a], HeroName, -1, 3.0 );
			return
		end;
	end;
end;

function diff_ambush (HeroName) ----- Блокирующие эльфийские засады
	MoveHeroRealTime( HeroName, 81, 74, 0 );
	StartCombat(HeroName ,  nil , 2 , 47 , 20 + 3*diff , 48 , 20 + 3*diff );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush4" ,"diff_ambush_mes");
	SetRegionBlocked("super_ambush3", not nil, PLAYER_1);
	sleep ( 5 );
	MessageBox ("/Maps/Scenario/A1C1M1/messagebox8.txt" );
end;

function diff_ambush_mes ()
	MessageBox ("/Maps/Scenario/A1C1M1/messagebox8.txt" );
end;

function diff_ambush1 (HeroName) ----- Блокирующие эльфийские засады
	MoveHeroRealTime( HeroName, 23, 72, 0 );
	StartCombat(HeroName ,  nil , 2 , 47 , 20 + 3*diff , 48 , 20 + 3*diff );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "super_ambush30" ,"diff_ambush_mes1");
	SetRegionBlocked("super_ambush20", not nil, PLAYER_1);
	sleep ( 5 );
	MessageBox ("/Maps/Scenario/A1C1M1/messagebox8.txt" );
end;

function diff_ambush_mes1 ()
	MessageBox ("/Maps/Scenario/A1C1M1/messagebox8.txt" );
end;

function red_haven_obj () ----- Старт обжектива про освобождение Ред Хавен Трупс
	if haven_obj == 1 then
		return
	end;
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "haven_trigger", nil);
	sleep (1);
	SetObjectiveState("prim4", OBJECTIVE_ACTIVE);
	startThread(Treants);
	x,y,z = RegionToPoint("openwarfog");
	OpenCircleFog(x, y, z, 10 , PLAYER_1);
	zoom = 35;
	BlockGame();
	MoveCamera( x, y, z, zoom, 0, 0, 0, 1 );
	sleep( 30 );
	x, y, z = GetObjectPosition( PlayerHero2 );
	MoveCamera( x, y, z, 30, 0, 0, 0, 1, 1 );
	UnblockGame();
	haven_obj = 1;
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "red_haven", "red_haven_obj_next");
end;

function red_haven_obj_next () ----- Окончание обжектива про освобождение Ред Хавен Трупс
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "red_haven", nil);
	for e_a = 1,7 do
		if IsObjectExists(elvenwar_array[e_a]) ~= nil then
			RemoveObject(elvenwar_array[e_a]);
		end;
	end;
	SetObjectiveState("prim4", OBJECTIVE_COMPLETED);
	obj_count = obj_count + 1;
	startThread(Winer);
end;

function ffc(HeroName ) ----- Скриптовый бой против Калдвела
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "final_fight_Cadwell" ,nil);
	StartCombat(  HeroName ,  nil , 6 , 2 , c_tier_array [2] , 4 , c_tier_array [4] ,6 , c_tier_array [6] ,8 , c_tier_array [8] ,10 , c_tier_array [10] ,12 , c_tier_array [12] ,nil , 'CadwellResult');
	sleep (10);
	for c_a = 1,15 do
		RemoveObject(caldwellarmy_array[c_a]);
	end;
	RemoveObject("training1");
	RemoveObject("training2");
	RemoveObject("training3");
	RemoveObject("training4");
	RemoveObject("training5");
	RemoveObject("training6");
	RemoveObject("training7");
	RemoveObject("training8");
	RemoveObject("training9");
	RemoveObject("training10");
end;

function CadwellResult (h_name, result) ---- Результаты боя против Калдвела
	sleep (2);
	if result == nil then
		return
	else
		StartDialogScene("/DialogScenes/A1C1/M1/S3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep (5);
		SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
		obj_count = obj_count + 1;
		startThread(Winer);
	end;
end;

function ffr(HeroName ) ----- Скриптовый бой против Рандала
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "final_fight_Randall" ,nil);
	StartCombat(  HeroName ,  nil , 6 , 2 , r_tier_array [2] , 4 , r_tier_array [4] ,6 , r_tier_array [6] ,8 , r_tier_array [8] ,10 , r_tier_array [10] ,12 , r_tier_array [12] ,nil , 'RandallResult');
	sleep (1);
	for r_a = 1,16 do
		RemoveObject(Randellarmy_array[r_a]);
	end;
	RemoveObject("training11");
	RemoveObject("training12");
	RemoveObject("training13");
	RemoveObject("training14");
end;

function RandallResult (h_name, result) ---- Результаты боя против Рандала
	sleep (2);
	if result == nil then
		return
	else
		MessageBox ("/Maps/Scenario/A1C1M1/messagebox6.txt" );
		sleep (5);
		SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
		obj_count = obj_count + 1;
		startThread(Winer);
	end;
end;

function Winer () ---- Обработчик победы
	if obj_count == 3 then
		SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M1");
		sleep (30);
		Win()
	end;
end;

function crossroad (hero) ---- сообщение на перекрестке
	ShowFlyingSign("/Maps/Scenario/A1C1M1/messagebox9.txt", hero, -1, 3.0);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "cross" ,nil);
end;

function neitral () ---- сообщение от ангелов
	MessageBox ("/Maps/Scenario/A1C1M1/messagebox10.txt" );
end;

---------------------------------------------------------------------
----------------------- АНИМАЦИИ и ЭФФЕКТЫ --------------------------
---------------------------------------------------------------------

function Films() --- Бой двух крестьян
	if random ( 2 ) == 0 then
		mover1 = training_array[1];
		mover2 = training_array[2];
	else
		mover1 = training_array[2];
		mover2 = training_array[1];
	end;
	type_hit = random ( 2 ) + 2;
	type_dam = random ( 2 ) + 4;
	type_idle = random ( 3 ) + 6;
	type_idle2 = random ( 2 ) + 7;
	PlayObjectAnimation(mover1 , effect_array [type_hit], type_effect_array [type_hit]);
	sleep  ( 8 );
	if IsObjectExists(mover2) ~= nil then
		PlayObjectAnimation(mover2 , effect_array [type_dam], type_effect_array [type_dam]);
	end;
	sleep  ( 15 );
	if IsObjectExists(mover2) ~= nil then
		PlayObjectAnimation(mover2 , effect_array [type_idle2], type_effect_array [type_idle2]);
	end;
	sleep  ( 1 );
	PlayObjectAnimation(mover1 , effect_array [type_idle], type_effect_array [type_idle]);
	sleep  ( random(5)+15 );
	if IsObjectExists(mover1) ~= nil then
		startThread(Films);
	end;
end;

function Films2() --- Бой двух крестьян
	sleep ( 1 );
	if random ( 2 ) == 0 then
		mover3 = training_array[3];
		mover4 = training_array[4];
	else
		mover3 = training_array[4];
		mover4 = training_array[3];
	end;
	type_hit2 = random ( 2 ) + 2;
	type_dam2 = random ( 2 ) + 4;
	type_idle2 = random ( 3 ) + 6;
	type_idle22 = random ( 2 ) + 7;
	PlayObjectAnimation(mover3 , effect_array [type_hit2], type_effect_array [type_hit2]);
	sleep  ( 8 );
	if IsObjectExists(mover4) ~= nil then
		PlayObjectAnimation(mover4 , effect_array [type_dam2], type_effect_array [type_dam2]);
	end;
	sleep  ( 15 );
	if IsObjectExists(mover4) ~= nil then
		PlayObjectAnimation(mover4 , effect_array [type_idle22], type_effect_array [type_idle22]);
	end;
	sleep  ( 1 );
	PlayObjectAnimation(mover3 , effect_array [type_idle2], type_effect_array [type_idle2]);
	sleep  ( random(5)+15 );
	if IsObjectExists(mover3) ~= nil then
		startThread(Films2);
	end;
end;

function Films3() --- Анимация Командира крестьян
	while IsObjectExists(training_array[5]) ~= nil do
		type_idle_c = random ( 3 ) + 6;
		PlayObjectAnimation(training_array[5] , effect_array [type_idle_c], type_effect_array [type_idle_c]);
		sleep (random (20) + 10);
	end;
end;

function Films4() --- Анимация Кавалеристов
	while IsObjectExists(training_array[6]) ~= nil do
		type_idle_cav = random ( 3 ) + 6;
		PlayObjectAnimation(training_array[random ( 2 ) + 6] , effect_array [type_idle_cav], type_effect_array [type_idle_cav]);
		sleep (random (10) + 10);
	end;
end;

function Films5() --- Анимация Стрелка
	while IsObjectExists(training_array[8]) ~= nil do
		type_idle_arc = random ( 3 )+1;
		if type_idle_arc == 1 or type_idle_arc == 3 then
			PlayObjectAnimation(training_array[8] , effect_array [type_idle_arc], type_effect_array [type_idle_arc]);
			sleep ( 6 );
			PlayVisualEffect("/Effects/_(Effect)/Characters/WarMachines/Ballista_WildFire/death01.(Effect).xdb#xpointer(/Effect)", "target1");
		else
			PlayObjectAnimation(training_array[8] , effect_array [type_idle_arc], type_effect_array [type_idle_arc]);
		end;
		sleep (random (10) + 10);
	end;
end;

function Films6() --- Анимация Стрелка
	while IsObjectExists(training_array[9]) ~= nil do
		type_idle_arc = random ( 3 )+1;
		if type_idle_arc == 1 or type_idle_arc == 3 then
			PlayObjectAnimation(training_array[9] , effect_array [type_idle_arc], type_effect_array [type_idle_arc]);
			sleep ( 6 );
			PlayVisualEffect("/Effects/_(Effect)/Characters/WarMachines/Ballista_WildFire/death01.(Effect).xdb#xpointer(/Effect)", "target2");
		else
			PlayObjectAnimation(training_array[9] , effect_array [type_idle_arc], type_effect_array [type_idle_arc]);
		end;
		sleep (random (10) + 10);
	end;
end;

function Films7() --- Анимация Командира Лучников
	while IsObjectExists(training_array[10]) ~= nil do
		type_idle_cc = random ( 3 ) + 6;
		PlayObjectAnimation(training_array[10] , effect_array [type_idle_cc], type_effect_array [type_idle_cc]);
		sleep (random (20) + 10);
	end;
end;

function Films8() --- Бой мечников
	sleep ( 1 );
	if random ( 2 ) == 0 then
		type_hit_sw = random ( 2 ) + 2;
		if type_hit_sw == 2 then
			PlayObjectAnimation(training_array[11] , effect_array [type_hit_sw], type_effect_array [type_hit_sw]);
			sleep  ( 8 );
			if IsObjectExists(training_array[13]) ~= nil then
				PlayObjectAnimation(training_array[13] , effect_array [4], type_effect_array [4]);
			end;
			sleep  ( 15 );
			if IsObjectExists(training_array[13]) ~= nil then
				PlayObjectAnimation(training_array[13] , effect_array [random ( 2 ) + 7], type_effect_array [random ( 2 ) + 7]);
			end;
		else
			PlayObjectAnimation(training_array[11] , effect_array [type_hit_sw], type_effect_array [type_hit_sw]);
			sleep  ( 8 );
			if random (100) < 75 then
				PlayObjectAnimation(training_array[12] , effect_array [5], type_effect_array [5]);
			end;
			if random (100) < 75 then
				sleep  ( 1 );
				PlayObjectAnimation(training_array[13] , effect_array [5], type_effect_array [5]);
			end;
			if random (100) < 75 then
				sleep  ( 2 );
				PlayObjectAnimation(training_array[14] , effect_array [5], type_effect_array [5]);
			end;
		end;
	end;
	if IsObjectExists(training_array[11]) ~= nil then
		startThread(Films8);
	end;
end;


function ZFarm()
	while 1 do
		if (GetObjectOwner("Farm1") == PLAYER_1) and (GetObjectOwner("Farm2") == PLAYER_1) and (GetObjectOwner("Farm3") == PLAYER_1) and (GetObjectOwner("Farm4") == PLAYER_1) and (GetObjectOwner("Farm5") == PLAYER_1) and (GetObjectOwner("Farm6") == PLAYER_1)and (GetObjectOwner("Farm7") == PLAYER_1) and (GetObjectOwner("Farm8") == PLAYER_1) then
			sleep(6);
			print ("Farms captured!!!");
			SetObjectiveState("sec1", OBJECTIVE_COMPLETED );
			return
		end;
		sleep();
	end;
end;
---------------------------------------------------------------------
---------------------------- СТАРТ МИССИИ ---------------------------
---------------------------------------------------------------------

startThread(ZFarm); 
startThread(Films);
startThread(Films2);
startThread(Films3);
startThread(Films4);
startThread(Films5);
startThread(Films6);
startThread(Films7);
startThread(Films8);
startThread(militia); --- В случае уничтожения первого отряда милиции открываются регионы с мятежными лидерами
startThread(elfdruids_kill); --- Проверка живы ли друиды
startThread(Start_count); --- Запуск настройки стртовых параметров карты