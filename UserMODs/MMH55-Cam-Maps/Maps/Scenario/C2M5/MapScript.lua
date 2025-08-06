doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M5");
    LoadHeroAllSetArtifacts("Agrael", "C2M4" );
end;

startThread(H55_InitSetArtifacts);

StartDialogScene("/DialogScenes/C2/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");

SetWarfogBehaviour(1,0);
SetPlayerStartResource(PLAYER_1,WOOD,5);
SetPlayerStartResource(PLAYER_1,ORE,5);
SetPlayerStartResource(PLAYER_1,SULFUR,0);
SetPlayerStartResource(PLAYER_1,GEM,0);
SetPlayerStartResource(PLAYER_1,MERCURY,0);
SetPlayerStartResource(PLAYER_1,CRYSTAL,0);
SetPlayerStartResource(PLAYER_1,GOLD,500);
OpenCircleFog(27,15,0,16,PLAYER_1);

function AgraelComeToTieru()
	print("Thread AgraelComeToTieru has been started...");
	Save("VisitToTieru");
	StartDialogScene("/DialogScenes/C2/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
	sleep(10);
	SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
	sleep(10);
	SetObjectiveState('prim2', OBJECTIVE_COMPLETED);
	sleep(20);
	Win(0);
end

function AgraelSurvive()
	print ("Thread AgraelSurvive has been started...");
	while 1 do
		sleep(10);
		if (IsHeroAlive("Agrael") == nil) then
			print("Our glorious hero is dead, but his dark soul will be with us forever...");
			sleep(20);
			SetObjectiveState("prim2",OBJECTIVE_FAILED);
			sleep(30);
			Loose(0);
			break;
		end;
	end;
end;


---script---
H55_CamFixTooManySkills(PLAYER_1,"Agrael");
startThread(AgraelSurvive);
Trigger(REGION_ENTER_AND_STOP_TRIGGER,'tieru', 'AgraelComeToTieru')