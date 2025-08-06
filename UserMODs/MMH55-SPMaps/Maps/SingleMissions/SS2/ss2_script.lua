----//SS2_script
--print("ss2start!!!!.................................");
StartDialogScene("/DialogScenes/Single/SS2/R1/DialogScene.xdb#xpointer(/DialogScene)")  ----Сцена стартовая

H55_PlayerStatus = {0,1,2,2,2,2,2,2};

DeployReserveHero("Maeve", 83, 73, 0);
sleep(10);
RemoveHeroCreatures("Maeve", CREATURE_ARCHANGEL, 9);

SetRegionBlocked("border", 1, PLAYER_2);
SetRegionBlocked("M1", 1, PLAYER_2);
SetRegionBlocked("M2", 1, PLAYER_2);
SetRegionBlocked("M3", 1, PLAYER_2);

Oddrema = "Oddrema";  
Maeve = "Maeve";  --Miraya

--------------
function PObjective1() 
	while 1 do	
		if (GetObjectOwner("Falconhill") == PLAYER_1) and IsHeroAlive("Maeve") == nil then
			print("Falcon dinasty pipez.................................");
			SetObjectiveState('Prim1',OBJECTIVE_COMPLETED);
			return
		end;
	sleep(10);
	end;
end;

function PObjective2()  --loose
	while 1 do
		sleep(10);
		if IsHeroAlive("Oddrema") == nil then
			print("Oddrema.................................");
			SetObjectiveState('Prim2',OBJECTIVE_FAILED);
			Loose();
			break;
		end;
	end;
end;

--function PObjective3()
--	while 1 do	
--		sleep( 10 );	
--		if IsHeroAlive("Maeve") == nil then
--			print("Miraua dead.................................");
--			SetObjectiveState('Prim3',OBJECTIVE_COMPLETED);
--			break;
--		end;
--	end;
--end;

--------------------------Maeve_ressurect
function H55_TriggerDaily()
	if (GetObjectOwner("Falconhill") ~= PLAYER_1) and GetObjectiveState('Prim1', PLAYER_1) ~= OBJECTIVE_COMPLETED and IsHeroAlive("Maeve") == nil then 
		DeployReserveHero("Maeve", 75, 70, 0);
		SetRegionBlocked("border", nil, PLAYER_2); -----------регион границы разблокан!
--		SetObjectiveState('Prim3',OBJECTIVE_ACTIVE);
		sleep(2);
		MoveHero( "Maeve", 83, 79, 0 );
		--		startThread(PObjective3);
	end;
end;

--------------------------------Winns

function CheckVictory ()
	while 1 do	
		if GetObjectiveState ('Prim1') == OBJECTIVE_COMPLETED then
			sleep(4);
			--SetObjectiveState('Prim2',OBJECTIVE_COMPLETED);
			StartDialogScene("/DialogScenes/Single/SS2/R3A2/DialogScene.xdb#xpointer(/DialogScene)")  ----Сцена финальная 
			sleep(30);
			Win ();
			H55_NewDayTrigger = 0;
			sleep(4);
			break;
		end;
		sleep(4);
	end;
end;
----------------------------------///Новые сцены

function CaptureFH()
	while 1 do
		sleep(6);
		if (GetObjectOwner("Falconhill") == PLAYER_1) and IsHeroAlive("Maeve") == not nil then 
			StartDialogScene("/DialogScenes/Single/SS2/R3A1/DialogScene.xdb#xpointer(/DialogScene)")  ----Замок взят но аигерой ещё жив 
			break;
		end;
	end;
end;

function Kill_AIfirst()
	while 1 do
		sleep(6);
		if (GetObjectOwner("Falconhill") ~= PLAYER_1) and IsHeroAlive("Maeve") == nil then 
			StartDialogScene("/DialogScenes/Single/SS2/R2/DialogScene.xdb#xpointer(/DialogScene)")  ----AI убит первый раз 
			break;
		end;
	end;
end;

function Won_scene ()
	if (GetObjectOwner("Falconhill") == PLAYER_1) and GetObjectiveState('Prim1', PLAYER_1) == OBJECTIVE_COMPLETED and IsHeroAlive("Maeve") == nil then 
		StartDialogScene("/DialogScenes/Single/SS2/R3A2/DialogScene.xdb#xpointer(/DialogScene)")  ----Сцена финальная 
		sleep(30);
		Win ();
	end;
end;
--------------------------------//Main
--startThread(Ress);

startThread(PObjective1);
startThread(PObjective2);
sleep(20);
--startThread(PObjective3);
startThread(CheckVictory);
H55_NewDayTrigger = 1;
-----------------------
startThread(CaptureFH);
startThread(Won_scene);
sleep(20);
startThread(Kill_AIfirst); ----------------------------!!!!