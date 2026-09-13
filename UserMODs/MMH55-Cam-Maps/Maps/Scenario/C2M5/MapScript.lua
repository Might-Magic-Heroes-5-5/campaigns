doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M5");
    LoadHeroAllSetArtifacts("Agrael", "C2M4" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Agrael" );
end

startThread(H55_InitSetArtifacts);

StartDialogScene("/DialogScenes/C2/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");

SetWarfogBehaviour(1,0);
SetPlayerStartResources(PLAYER_1, 5, 5, 0, 0, 0, 0, 500);
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
		sleep(20);
		if (IsHeroAlive("Agrael") == nil) then
			print("Our glorious hero is dead, but his dark soul will be with us forever...");
			sleep(20);
			SetObjectiveState("prim2",OBJECTIVE_FAILED);
			sleep(30);
			Loose(0);
			break;
		end
	end
end

function stepIntoVoid(hero)
	print(hero.." triggered");
	StartDialogScene("/DialogScenes/C2/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
	sleep(20);
    Loose();
end

function AgraelHasDefeatedMapGuardians()
	while IsObjectExists("cartographer_guard") ~= nil do sleep(50); end
	print("Void disabled");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'fog_death1', nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'fog_death2', nil );
end

function SetFinalCombat()
	local diff = GetDifficulty();
	if diff == 0 then
		AddObjectCreatures("tieru_guards", CREATURE_GOLD_DRAGON, 14 );
        AddObjectCreatures("tieru_guards", CREATURE_RAINBOW_DRAGON, 14 );
        AddObjectCreatures("tieru_guards", CREATURE_GREEN_DRAGON, 14);
	end

	if diff == 1 then
		AddObjectCreatures("tieru_guards", CREATURE_GOLD_DRAGON, 59 );
        AddObjectCreatures("tieru_guards", CREATURE_RAINBOW_DRAGON, 59 );
        AddObjectCreatures("tieru_guards", CREATURE_GREEN_DRAGON, 59);
        AddObjectCreatures("cartographer_guard", CREATURE_RAINBOW_DRAGON, 3);	
        AddObjectCreatures("cartographer_guard", CREATURE_WAR_UNICORN, 15);		
        AddObjectCreatures("cartographer_guard", CREATURE_ANGER_TREANT, 15);			
	end

	if diff == 2 then
		AddObjectCreatures("tieru_guards", CREATURE_GOLD_DRAGON, 104 );
        AddObjectCreatures("tieru_guards", CREATURE_RAINBOW_DRAGON, 104);
        AddObjectCreatures("tieru_guards", CREATURE_GREEN_DRAGON, 104);
        AddObjectCreatures("cartographer_guard", CREATURE_RAINBOW_DRAGON, 6);	
        AddObjectCreatures("cartographer_guard", CREATURE_WAR_UNICORN, 30);		
        AddObjectCreatures("cartographer_guard", CREATURE_ANGER_TREANT, 30);		
		
	end

	if diff == 3 then
		AddObjectCreatures("tieru_guards", CREATURE_GOLD_DRAGON, 149 );
        AddObjectCreatures("tieru_guards", CREATURE_RAINBOW_DRAGON, 149 );
        AddObjectCreatures("tieru_guards", CREATURE_GREEN_DRAGON, 149 );
        AddObjectCreatures("cartographer_guard", CREATURE_RAINBOW_DRAGON, 9);	
        AddObjectCreatures("cartographer_guard", CREATURE_WAR_UNICORN, 45);		
        AddObjectCreatures("cartographer_guard", CREATURE_ANGER_TREANT, 45);		
	end
end

startThread(SetFinalCombat);
startThread(AgraelSurvive);
startThread(AgraelHasDefeatedMapGuardians);
Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'tieru', 'AgraelComeToTieru' );
Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'fog_death1', 'stepIntoVoid' );
Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'fog_death2', 'stepIntoVoid' );
