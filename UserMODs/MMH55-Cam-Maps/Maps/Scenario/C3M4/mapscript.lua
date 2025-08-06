doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M4");
    LoadHeroAllSetArtifacts("Berein", "C3M3" );
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

Cyrus = "Cyrus";  --Cayrus!!!
Berein = "Berein";
EnableHeroAI("Cyrus",nil);

SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 1);

ChangeHeroStat("Cyrus", STAT_EXPERIENCE, 140000);

----------------------------------//Titans
function mob1()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "100", nil );
MessageBox ("/Maps/Scenario/C3M4/Message/C3M4_1.txt");
CreateMob(1,CREATURE_TITAN,4,66,90,1,2,1);
end;

function mob2()	
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "200", nil );
CreateMob(2,CREATURE_TITAN,6,117,92,1,2,1);
end;

function mob3()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "300", nil );
CreateMob(3,CREATURE_TITAN,10,38,20,1,2,1);
end;

function mob4()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "400", nil );
CreateMob(3,CREATURE_TITAN,12,63,71,1,2,1);
CreateMob(3,CREATURE_TITAN,55,63,64,1,2,1);
end;

--------------------------------//Start first dialog
function Dialog1()
StartDialogScene("/DialogScenes/C3/M4/R1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Start final dialog
end;

-------------------------------//Objectives

function PObjective1()
	while 1 do	
		sleep( 10 );	
		if IsHeroAlive("Cyrus") == nil then
			print("Cayrus dead.................................");
			SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
			break;
		end;
	end;
end;

function PObjective2()
	while 1 do
		sleep(10);
		if IsHeroAlive("Berein") == nil then
			print("Berein dead.................................");
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			break;
		end;
	end;
end;

-----------------------------//Winner
function WinLoose()
	while 1 do
		if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
			StartDialogScene("/DialogScenes/C3/M4/D1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Start final dialog
			--GiveExp( "Berein", 500 ); ---addexp!!!
			SaveHeroAllSetArtifactsEquipped("Berein", "C3M4");
			sleep(30);
			Win();
			return
		end;
		if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			Loose();
			return
		end;
		sleep();
	end;
end;
----------------------------------
function Post_Bone2()
	while 1 do
		sleep(4);
		if IsPlayerHeroesInRegion(1, "Bone") == not nil then
			SetObjectOwner("B1",1);
			SetObjectOwner("B2",1);
			break;
		end;
	end;
end;
--------------------------------//Main thread
H55_CamFixTooManySkills(PLAYER_1,"Berein");
startThread(Dialog1);

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "100","mob1", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "200","mob2", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "300","mob3", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "400","mob4", nil );

startThread(PObjective1);
startThread(PObjective2);
startThread(WinLoose);
--startThread(Post_Bone2);