doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M1");
end;

startThread(H55_InitSetArtifacts);

--Save("Scene 10: Appearance of Realag")

Raelag = "Raelag"
Urunir = "Urunir"
Almegir = "Almegir"
Inagost = "Inagost"
Ohtarig = "Ohtarig"
Menel   = "Menel"
Ferigl = "Ferigl"
Eruina = "Eruina"

Heroes = {"Raelag", "Urunir", "Almegir", "Inagost", "Ohtarig", "Menel", "Ferigl", "Eruina"}

----------------------------------
timer=nil
heroname = "Raelag"

----------------------------------
ChangeHeroStat("Eruina", STAT_EXPERIENCE, 15000);
ChangeHeroStat("Urunir", STAT_EXPERIENCE, 16000);
ChangeHeroStat("Almegir", STAT_EXPERIENCE, 16000);
ChangeHeroStat("Inagost", STAT_EXPERIENCE, 15000);
ChangeHeroStat("Ohtarig", STAT_EXPERIENCE, 16000);
ChangeHeroStat("Menel", STAT_EXPERIENCE, 16000);
ChangeHeroStat("Ferigl", STAT_EXPERIENCE, 15000);
---------------------------------

function H55_TriggerDaily()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 2 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C2_1.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 3 ) and (GetDate(DAY_OF_WEEK) == 2 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C2_2.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 2 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C2_3.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 3 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_1.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 4 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_2.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 5 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_3.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 6 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_4.txt");
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 7 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_5.txt");
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) then
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C3_6.txt");
		Save("Save1") ---предохраняемся на всякий казуальный случай
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 2 ) then
		sleep(2);
		print ('Prepare');
		MessageBox ("/Maps/Scenario/C4M1/Message/C4M1_C4.txt");
		sleep(8);
		startThread(Moveheroes1);
		SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
		ChangeHeroStat("Raelag", STAT_LUCK, 1);  -------Повышаем мораль за комплит задания
		SetObjectiveState('prim2',OBJECTIVE_ACTIVE); ---Выдаём задание 2
	end;
end;

------------------------------------Герои телепортятся в подземку
function Moveheroes1()
sleep(3);
print ('Prepare');
SetObjectPosition("Raelag", 142, 163, 0);
print("Go!!!.................................");
sleep(3);
SetObjectOwner("first",PLAYER_NONE);
startThread(Goto);
end;

function Goto()
	while 1 do	
		sleep( 2 );	
		if IsPlayerHeroesInRegion(1, "Level") == not nil then
			OpenRegionFog (1, "Arena");
			OpenRegionFog (1, "Dragon");
			MoveCamera(91, 63, 1, 50, 1);
			startThread(Moveheroes2);
			startThread(Moveheroes3);
			startThread(Moveheroes4);
			startThread(Moveheroes5);
			startThread(Moveheroes6);
			startThread(Moveheroes7);
			startThread(Moveheroes8);
			break;
		end;
	end;
end;
------------------------------------
function Moveheroes2()
	while 1 do
		sleep(10);
		if IsHeroAlive("Eruina") == not nil then
			SetObjectPosition("Eruina", 98, 67, 1);
			AddHeroCreatures("Eruina", CREATURE_ASSASSIN, 30 );
			AddHeroCreatures("Eruina", CREATURE_CHAOS_HYDRA, 5 );
			AddHeroCreatures("Eruina", CREATURE_RAVAGER, 10 );
			AddHeroCreatures("Eruina", CREATURE_MINOTAUR_KING, 4);
			sleep(10);
			SetObjectOwner("second",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes3()
	while 1 do
		sleep(11);
		if IsHeroAlive("Urunir") == not nil then
			SetObjectPosition("Urunir", 98, 58, 1);
			AddHeroCreatures("Urunir", CREATURE_SCOUT, 5);
			AddHeroCreatures("Urunir", CREATURE_RAVAGER, 2);
			AddHeroCreatures("Urunir", CREATURE_MATRON, 3);
			sleep(10);
			SetObjectOwner("third",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes4()
	while 1 do
		sleep(13);
		if IsHeroAlive("Almegir") == not nil then
			SetObjectPosition("Almegir", 95, 54, 1);
			AddHeroCreatures("Almegir", CREATURE_ASSASSIN, 6);
			AddHeroCreatures("Almegir", CREATURE_MATRON, 2);
			AddHeroCreatures("Almegir", CREATURE_MINOTAUR_KING, 10);
			sleep(10);
			SetObjectOwner("fourth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes5()
	while 1 do
		sleep(14);
		if IsHeroAlive("Inagost") == not nil then
			SetObjectPosition("Inagost", 86, 54, 1);
			AddHeroCreatures("Inagost", CREATURE_ASSASSIN, 12);
			AddHeroCreatures("Inagost", CREATURE_MINOTAUR_KING, 2);
			AddHeroCreatures("Inagost", CREATURE_BLOOD_WITCH, 3);
			sleep(10);
			SetObjectOwner("fifth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes6()
	while 1 do
		sleep(15);
		if IsHeroAlive("Ohtarig") == not nil then
			SetObjectPosition("Ohtarig", 83, 59, 1);
			AddHeroCreatures("Ohtarig", CREATURE_BLOOD_WITCH, 20);
			AddHeroCreatures("Ohtarig", CREATURE_MATRIARCH, 1);
			AddHeroCreatures("Ohtarig", CREATURE_RAVAGER, 20);
			AddHeroCreatures("Ohtarig", CREATURE_ASSASSIN, 10);
			sleep(10);
			SetObjectOwner("sixth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes7()
	while 1 do
		sleep(16);
		if IsHeroAlive("Menel") == not nil then
			SetObjectPosition("Menel", 83, 68, 1);
			AddHeroCreatures("Menel", CREATURE_HYDRA, 2);
			AddHeroCreatures("Menel", CREATURE_MINOTAUR_KING, 2);
			AddHeroCreatures("Menel", CREATURE_BLOOD_WITCH, 3);
			sleep(10);
			SetObjectOwner("seventh",PLAYER_NONE);
			break;
		end;
	end;
end;

function Moveheroes8()
	while 1 do
		sleep(16);
		if IsHeroAlive("Ferigl") == not nil then
			SetObjectPosition("Ferigl", 86, 71, 1);
			AddHeroCreatures("Ferigl", CREATURE_HYDRA, 4);
			AddHeroCreatures("Ferigl", CREATURE_MINOTAUR_KING, 2);
			AddHeroCreatures("Ferigl", CREATURE_BLOOD_WITCH, 3);
			AddHeroCreatures("Ferigl", CREATURE_ASSASSIN, 3);
			sleep(10);
			SetObjectOwner("Eighth",PLAYER_NONE);
			sleep(10);
			timer=GetDate(ABSOLUTE_DAY)+10   ----таймер старта драки
			startThread(Finalcombat); ----------натравливаем двух последних героев
			startThread(fight);
			break;
		end;
	end;
end;
---------------------------------------------------Ломаем замки
function Castle2()
	while 1 do
		sleep(10);
		if IsHeroAlive("Eruina") == nil then
			SetObjectOwner("second",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle3()
	while 1 do
		sleep(10);
		if IsHeroAlive("Urunir") == nil then
			SetObjectOwner("third",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle4()
	while 1 do
		sleep(10);
		if IsHeroAlive("Almegir") == nil then
			SetObjectOwner("fourth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle5()
	while 1 do
		sleep(10);
		if IsHeroAlive("Inagost") == nil then
			SetObjectOwner("fifth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle6()
	while 1 do
		sleep(10);
		if IsHeroAlive("Ohtarig") == nil then
			SetObjectOwner("sixth",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle7()
	while 1 do
		sleep(10);
		if IsHeroAlive("Menel") == nil then
			SetObjectOwner("seventh",PLAYER_NONE);
			break;
		end;
	end;
end;

function Castle8()
	while 1 do
		sleep(10);
		if IsHeroAlive("Ferigl") == nil then
			SetObjectOwner("Eighth",PLAYER_NONE);
			break;
		end;
	end;
end;
----------------------------------------------


function Prim2_complit()
	while 1 do
		sleep(10);
		if HasArtefact("Raelag",ARTIFACT_RING_OF_THE_SHADOWBRAND) then
			StartDialogScene("/DialogScenes/C4/M1/R2/DialogScene.xdb#xpointer(/DialogScene)")  ---Сцена получения артефакта
			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
			break;
		end;
	end;
end;

-----------------------------------------Win_Lose
function Dead_hero()
	while 1 do
		sleep(10);
		if IsHeroAlive("Raelag") == nil then
			print("Heroes deads.................................");
			SetObjectiveState('prim3',OBJECTIVE_FAILED);
			break;
		end;
	end;
end;

function WinLoose()
	while 1 do
		if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Raelag","C4M1");
			--GiveExp( "Raelag", 500 ); ---addexp!!!
			sleep(10);
			Win();
			return
		end;
		if GetObjectiveState("prim3") == OBJECTIVE_FAILED then
			Loose();
			return
		end;
		sleep();
	end;
end;
------------------------------Драконы сваливают домой и открывют проход
function Dooropen()
	while 1 do
		sleep(10);
		if IsHeroAlive("Urunir") == nil and IsHeroAlive("Eruina") == nil and IsHeroAlive("Almegir") == nil and IsHeroAlive("Inagost") == nil and IsHeroAlive("Ohtarig") == nil and IsHeroAlive("Menel") == nil then
			OpenRegionFog (1, "Arena2");
			SetObjectPosition("Drag", 122, 97, 1);
			break;
		end;
	end;
end;
--------------------------------Последние герои

function Finalcombat()
	while 1 do
		sleep(4);
		if GetDate(ABSOLUTE_DAY)==timer then
			print ('Start_special_action....');
--			EnableDynamicBattleMode(1);  ---------------------Динамический бой включаем!
			startThread(EngageHero1);
			startThread(EngageHero2);
			sleep(1);
			break;
		end;
	end;
end;

function H55_SecTriggerDaily()
	if IsHeroAlive("Urunir") ~= nil or IsHeroAlive("Eruina") ~= nil or IsHeroAlive("Almegir") ~= nil or IsHeroAlive("Inagost") ~= nil or IsHeroAlive("Ohtarig") ~= nil or IsHeroAlive("Menel") ~= nil then
		fight1 = random (2)+1;
		startThread(fighter);
	end;
end;

function fighter()
	fighter1 = random (7)+2;
	if IsHeroAlive (Heroes[fighter1]) then
		startThread(target);
		print ("figter ", Heroes[fighter1]);
	else
		startThread(fighter);
	end;
end;

function target()
	target1 = random (7)+1;
	if IsHeroAlive (Heroes[target1]) and Heroes[target1] ~= Heroes[fighter1]then
		startThread(fightkill);
		print ("target ", Heroes[target1]);
	else
		startThread(target);
	end;
end;

function fightkill()
	if fight1 > 0 then
		print ("go-go-go");
		tar = Heroes[target1]
		fig = Heroes[fighter1]
		MoveHero(fig, GetObjectPosition(tar));
		fight1 = fight1 - 1;
		startThread(fighter);
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "fight" );
	end;
end;

function EngageHero1()
	while IsHeroAlive ("Eruina") do
		while GetCurrentPlayer() ~= PLAYER_2 do
			sleep( 1 );
		end;
		MoveHero( "Eruina", GetObjectPosition( heroname ) );
			while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 1 );
		end;
	end;
end;

function EngageHero2()
	while IsHeroAlive ("Ohtarig") do
		while GetCurrentPlayer() ~= PLAYER_6 do
			sleep( 1 );
		end;
		MoveHero( "Ohtarig", GetObjectPosition( heroname ) );
			while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 1 );
		end;
	end;
end;
--------------------------------Запускаем
StartDialogScene("/DialogScenes/C4/M1/D1/DialogScene.xdb#xpointer(/DialogScene)", "", "Save2")  ----Сцена стартовая
--Save("Save2")
DestroyTownBuildingToLevel("first",TOWN_BUILDING_SPECIAL_4,0,0);
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "messagesC2_C3",nil );


startThread(Prim2_complit);
startThread(Dead_hero);
startThread(WinLoose);

startThread(Castle2);
startThread(Castle3);
startThread(Castle4);
startThread(Castle5);
startThread(Castle6);
startThread(Castle7);
startThread(Castle8);

startThread(Dooropen);