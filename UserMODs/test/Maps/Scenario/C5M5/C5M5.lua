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

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M5");
    LoadHeroAllSetArtifacts("Heam", "C5M4" );
end;

startThread(H55_InitSetArtifacts);

---GLOBALS---
first_day=1
power=0
power1=1
great_night_progress=0
diff=1
first_time=1
light=0
m = 1

dang_array = {"Nemor","Pelt","Straker","Tamika","Effig"};

--SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c4m4_wastes.xdb#xpointer(/AmbientLight)");

---ARRAYS---
shadow_dragons = {"SD1", "SD2", "SD3", "SD4", "SD5", "SD6"};
regions={'sdregion1','sdregion2','sdregion3','sdregion4','sdregion5','sdregion6',"AI_block_1","AI_block_2","AI_block_3","AI_block_4","AI_blok","AI_block_5","AI_block_6","AI_blok","AI_blok1","AI_blok2","AI_blok3","AI_block_7","AI_block_8"}
--'portalregion'
towns={'town1','town2','town3','town4','town5','town6'}
respawns_x={37,84,41,160,95,26}
respawns_y={39,86,152,31,92,21}
respawns_z={GROUND,GROUND,GROUND,GROUND,UNDERGROUND,UNDERGROUND}
town_cratures_normal={70,50,25,20,12,10,3}
town_cratures_hard={100,80,40,30,20,15,5}
town_cratures_heroic={130,100,50,40,30,20,9}
kolyan_army_normal={30,25,20,15}
kolyan_army_hard={50,40,30,25}
kolyan_army_heroic={70,55,40,35}
dwellings={	TOWN_BUILDING_DWELLING_1,
			TOWN_BUILDING_DWELLING_2,
			TOWN_BUILDING_DWELLING_3,
			TOWN_BUILDING_DWELLING_4,
			TOWN_BUILDING_DWELLING_5,
			TOWN_BUILDING_DWELLING_6,
			TOWN_BUILDING_DWELLING_7}
creatures_types={	CREATURE_SKELETON_ARCHER,
					CREATURE_ZOMBIE,
					CREATURE_GHOST,
					CREATURE_VAMPIRE_LORD,
					CREATURE_DEMILICH,
					CREATURE_WRAITH,
					CREATURE_SHADOW_DRAGON}
---FUNCTIONS---
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == "Heam" ) then
		SetObjectiveState("Prim4", OBJECTIVE_FAILED);
		sleep (15);
		Loose();
	end;
end;

function blocking()  --блокает проходимость тайлов вокруг шадоу драконов для PLAYER_2, чтоб он сам их не поубивал как дурак
	for i,h in regions do
		SetRegionBlocked(regions[i], not nil, PLAYER_2)
		print (regions[i], "block");
	end
end

function dragon_messeges() --чекает в отдельном треде наличие шадоу драгонов на карте.
	local m=0;r7=0;r6=0
	while 1 do
		m=dragons_count()  
		if m==0 then
				StartDialogScene('/DialogScenes/C5/M5/R8/DialogScene.xdb#xpointer(/DialogScene)') --все драконы убиты
				--SetAmbientLight(GROUND,"/Lights/_(AmbientLight)/AdvMap/C5M5/Day.xdb#xpointer(/AmbientLight)",not nil , 5) --меняет освещение на карте на дневное
				SetAmbientLight(GROUND, 'c5m5_day',not nil , 5) --меняет освещение на карте на дневное
				SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/Day.xdb#xpointer(/AmbientLight)");
				light=1
				return --драконы убиты, можно из цикла выйти
		else
			if m==3 and r7==0 then
				StartDialogScene('/DialogScenes/C5/M5/R7/DialogScene.xdb#xpointer(/DialogScene)') --3 группы драконов убиты
				r7=1 --диалог С5М5R7 был показан игроку
				SetAmbientLight(GROUND, 'c5m5_twilight2',not nil , 5) --меняет освещение на карте на чуть более светлые сумерки
				--SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c4m4_wastes (2).xdb#xpointer(/AmbientLight)");
			else
				if m==5 and r6==0 then
					StartDialogScene('/DialogScenes/C5/M5/R6/DialogScene.xdb#xpointer(/DialogScene)') --1 группа драконов убита
					r6=1 --диалог С5М5R6 был показан игроку
				end;
			end;
		end
		sleep(5)
	end
end

function dragons_count() --возвращает количество оставшихся на карте шадоу драгонов
	local m=0
	for i,h in shadow_dragons do
		if not IsObjectExists(shadow_dragons[i])==nil then --"жив" ли данный стек шадоу драгонов?
			m=m+1
		else
			SetRegionBlocked(regions[i], nil,PLAYER_2) --разблочиваем проходимость региона для PLAYER_2 потому как дракона уже нет
		end
	end
	return m
end

function H55_TriggerDaily() --тригерная функция, чкает состояние дел в начале каждого дня
	great_night_progress=great_night_progress+dragons_count()*diff --сколько "зла" нагенерили драконы
	print ("zlo = ", great_night_progress);
	power=great_night_progress/1008 --насколько драконы закончили свою работу
	print('power= ',power)
	if power>1 then
		ownage()
		return
	end;
	if GetDate(MONTH) == 2 and GetDate(DAY) == 1 and GetDate(WEEK) == 1 then
		StartDialogScene('/DialogScenes/C5/M5/D1/DialogScene.xdb#xpointer(/DialogScene)');
	end;
end

function ownage() --вызывается когда параметр power становится больше 1, типа "Великая Ночь" достигла своего апогея и андедов уже не остановить
	for i,h in regions do
		SetRegionBlocked(regions[i], nil, PLAYER_2)
		print (regions[i], "unblock");
	end
	sleep ( 5 );
	EnableHeroAI('Nikolay' , not nil);
	AddHeroCreatures('Nikolay', CREATURE_SHADOW_DRAGON , 666);
	ChangeHeroStat('Nikolay', STAT_MOVE_POINTS, 6500000);
	MoveHero('Nikolay', GetObjectPosition("Heam"));
end

function ressurect(heroname,winner) --триггерная функция, запускается после смерти героя PLAYER_2, респавнит Коляна...или не респавнит
	if heroname=='Nikolay' then --убитого героя зовут Колян?
		if not winner==nil then --его убили или сам слажал?
			if GetHeroCreatures(winner, CREATURE_PHOENIX)>0 or light==1 then --были ли у убийцы фениксы в армии на конец битвы, или Коляна убили при солнечном свете?
				SaveHeroAllSetArtifactsEquipped("Heam", "C5M5");
				SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED); --вот и пришел злостному рецедевисту Коляну конец
				Save("autosave");
				sleep ( 1 );
				StartDialogScene('/DialogScenes/C5/M5/D2/DialogScene.xdb#xpointer(/DialogScene)');
				sleep(10);
				Win();
				return
			else --облом с фениксами или светом вышел?
				if first_time==1 then --который уже раз Коляна валим?
					first_time=0
					StartDialogScene('/DialogScenes/C5/M5/R2/DialogScene.xdb#xpointer(/DialogScene)');
				end
				DeployReserveHero('Nikolay',check_place()) --респавн Коляна
				sleep() --без этой паузы следующая функция не стаботает!!!!
				army() --добавление Коляну свежей армии
			end
		else
			DeployReserveHero('Nikolay',check_place()) --респавн Коляна
			sleep() --без этой паузы следующая функция не стаботает!!!!
			army() --добавление Коляну свежей армии
		end
	end
end

function army() --добавление армии Коляну после респавноа
	if GetDifficulty()==DIFFICULTY_NORMAL then
		give_creatures(kolyan_army_normal)
	else
		if GetDifficulty()==DIFFICULTY_HARD then
			give_creatures(kolyan_army_hard)
		else
			give_creatures(kolyan_army_heroic)
		end;
	end;
end;

function give_creatures(diff_mod) --подфункция для army()
	for i,h in diff_mod do
		AddHeroCreatures('Nikolay', creatures_types[i+3] , 1+diff_mod[i])
		print("Kolyan gain ",1+diff_mod[i], creatures_types[i+3])
	end;
end

function check_place() --выбирает место куда отреспавнить Коляна, респавнит рядом с одним из своих замков, если таких нет, то у любого из андедских
	local fake_array={};a=6
	for i,h in towns do
		if GetObjectOwner(towns[i])==PLAYER_2 then
			fake_array[i]=towns[i]
		end
	end
	if a==0 then
		a=table.length(fake_array[i])
	end	
	b=random(a)+1
	return respawns_x[b],respawns_y[b],respawns_z[b]
end

function get_difficulty() --чекает уровень сложности и изменяет параметр diff_mod
	if GetDifficulty()==DIFFICULTY_HEROIC then
		diff=1,5
	end
end;

Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest");

function quest(hero_n)
	if hero_n == "Heam" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE);
		sleep (15);
		StartDialogScene('/DialogScenes/C5/M5/R3/DialogScene.xdb#xpointer(/DialogScene)');
		startThread(quest_progress);
	else
		ShowFlyingSign("/Maps/Scenario/C5M5/C5M5.txt", "hut", -1, 3.0);
	end;
end;

function quest_progress()
	while 1 do
		sleep (15);
		if HasArtefact("Heam", 48) == not nil and HasArtefact("Heam", 49) == not nil and HasArtefact("Heam", 50) == not nil and HasArtefact("Heam", 51) == not nil then
			StartDialogScene('/DialogScenes/C5/M5/R4/DialogScene.xdb#xpointer(/DialogScene)');
			sleep ( 5 );
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED);
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest_final");
			break;
		end;
	end;
end;

function quest_final(hero_n)
	if hero_n == "Heam" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		StartDialogScene('/DialogScenes/C5/M5/R5/DialogScene.xdb#xpointer(/DialogScene)');
		AddHeroCreatures("Heam",CREATURE_PHOENIX,5);
		sleep ( 5 );
		SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED);
		SetObjectFlashlight("Heam" , "phoenix");
		RemoveArtefact("Heam", 48);
		RemoveArtefact("Heam", 49);
		RemoveArtefact("Heam", 50);
		RemoveArtefact("Heam", 51);
		ResetObjectFlashlight("hut");
	end;
end;

	
---script start---
H55_CamFixTooManySkills(PLAYER_1,"Heam");
StartDialogScene('/DialogScenes/C5/M5/R1/DialogScene.xdb#xpointer(/DialogScene)');
DeployReserveHero('Nikolay',84,86,GROUND);
ChangeHeroStat('Nikolay', STAT_EXPERIENCE, 400000);
startThread(dragon_messeges);
blocking();
H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER,'day_check');
Trigger(PLAYER_REMOVE_HERO_TRIGGER,PLAYER_2,'ressurect');
SetObjectEnabled('hut', nil);

if GetDifficulty() == DIFFICULTY_EASY then
	print ("easy");
	dif = 0;
	exp = GetHeroStat("Heam", STAT_EXPERIENCE)/4;
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
	end;
	for a = 0,6 do
		SetPlayerResource(PLAYER_2, a, 0);
	end;
	AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	print ("normal");
	dif = 0;
	exp = GetHeroStat("Heam", STAT_EXPERIENCE)/2;
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
	end;
	for a = 0,6 do
		SetPlayerResource(PLAYER_2, a, 0);
	end;
end;

if GetDifficulty() == DIFFICULTY_HARD then
	print ("Hard");
	dif = 1;
	exp = GetHeroStat("Heam", STAT_EXPERIENCE);
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		AddObjectCreatures(dang_array[i], CREATURE_SKELETON_ARCHER , 30);
		AddObjectCreatures(dang_array[i], CREATURE_ZOMBIE , 20);
	end;
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	print ("Impossible");
	dif = 2;
	exp = GetHeroStat("Heam", STAT_EXPERIENCE)*2;
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		AddObjectCreatures(dang_array[i], CREATURE_SKELETON_ARCHER , 45);
		AddObjectCreatures(dang_array[i], CREATURE_ZOMBIE , 30);
		AddObjectCreatures(dang_array[i], CREATURE_GHOST , 37);
	end;
end;