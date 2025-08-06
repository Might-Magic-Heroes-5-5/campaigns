H55_PlayerStatus = {0,1,1,1,1,2,2,2};

function objective1()
	StartDialogScene("/DialogScenes/Single/SXL1/R1/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
	SetObjectiveState("st_obj", OBJECTIVE_ACTIVE);
end;

function disactivation()
	SetObjectEnabled("portal", nil);
	SetObjectEnabled("seer_hut", nil);
	SetObjectEnabled("dragon_guardian", nil);
	SetObjectEnabled("key_tent", nil);
	SetObjectEnabled("observer", nil);
	SetRegionBlocked("special_for_akimovs_cheat", not nil, PLAYER_1);
end;

function SXL1R4_SXL1R5()
	if GetObjectiveState("obj2")==OBJECTIVE_UNKNOWN then
		sleep(2);
		StartDialogScene("/DialogScenes/Single/SXL1/R4/DialogScene.xdb#xpointer(/DialogScene)");
	elseif GetObjectiveState("obj2")==OBJECTIVE_ACTIVE then
		sleep(2);
		StartDialogScene("/DialogScenes/Single/SXL1/R5/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	OpenCircleFog(142, 139, GROUND, 14, PLAYER_1);
	Trigger(OBJECT_TOUCH_TRIGGER, "observer", nil)
end;	

----------- Objective 2 ----------- 

function SXL1R2_objective2()
	local p_ore = GetPlayerResource(PLAYER_1, ORE);
	SetPlayerResource(PLAYER_1, ORE, p_ore + 5)
	SetObjectiveState("st_obj", OBJECTIVE_COMPLETED);
	sleep(3);
	SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
	sleep(5);
	StartDialogScene("/DialogScenes/Single/SXL1/R2/DialogScene.xdb#xpointer(/DialogScene)");
	sleep(3);
	Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "SXL1R2_objective2_complete");
end;

--SXL1R2_SXL1R3--

function SXL1R2_objective2_complete()
	local res = GetPlayerResource(PLAYER_1, GOLD) - 50000
	print("seerqest 1 started...");
	if GetPlayerResource(PLAYER_1, GOLD)>=50000 then
		SetPlayerResource(PLAYER_1, GOLD, res)
		SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
		LevelUpHero("Muscip");
		sleep(5);
		StartDialogScene("/DialogScenes/Single/SXL1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(3);
		SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "SXL1R12_objective3");
	end;
end;

----------- Objective 3 ----------- 

function SXL1R12_objective3(heroName)
	local res = GetPlayerResource(PLAYER_1, GOLD) + 10000
	if HasArtefact(heroName, ARTIFACT_DRAGON_TEETH_NECKLACE) then
		SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
		SetPlayerResource(PLAYER_1, GOLD, res)
		sleep(3);
		StartDialogScene("/DialogScenes/Single/SXL1/R12/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(3);
		SetObjectiveState("obj7", OBJECTIVE_ACTIVE);
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "SXL1R13_objective7");
	end;
end;


----------- Objective 4 ----------- 

function SXL1R6_objective4()
	StartDialogScene("/DialogScenes/Single/SXL1/R6/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
	sleep(5);
	Trigger(OBJECT_TOUCH_TRIGGER, "key_tent", "SXL1R7_key_master");
end;

function SXL1R7_key_master(heroName)	
	local p_gold = GetPlayerResource(PLAYER_1, GOLD) + 3000
	if GetHeroCreatures(heroName,CREATURE_FOOTMAN) > 99 then
		print("Hero ",heroName,"got 100 swardsman");
		sleep(3);
		RemoveHeroCreatures(heroName, CREATURE_FOOTMAN, 100);
		sleep(3);
		StartDialogScene("/DialogScenes/Single/SXL1/R7/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(3);
		SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
		SetPlayerResource(PLAYER_1, GOLD, p_gold)
		sleep(3);
		GiveBorderguardKey(PLAYER_1, RED_KEY);
		sleep(3);
		Trigger(OBJECT_TOUCH_TRIGGER, "key_tent", nil);
		startThread(SXL1R8_objective5);
	end;
end;	

----------- Objective 5 ----------- 

function SXL1R8_objective5()
while 1 do
	if IsObjectExists("bg")==nil then
		OpenCircleFog(142, 139, GROUND, 14, PLAYER_1);
		BlockGame();
		sleep(2);
		EnableHeroAI("Almegir", not nil);
		sleep(20);
		SetObjectPos("Almegir", 145, 146, GROUND);
		MoveCamera(142, 139, GROUND,50, 3.14/3, 0);
		ChangeHeroStat("Almegir", STAT_MOVE_POINTS, 3000);
		sleep(15);
		MoveHeroRealTime("Almegir", 142, 139, GROUND);
		local len = 100; 
		while len > 1 do
			x, y = GetObjectPos( "Almegir" );
			len = sqrt( (x - 142) * (x - 142) + (y - 139) * (y - 139) );
			print( "len = ", len);
			sleep( 1 );
		end;
		ChangeHeroStat("Almegir", STAT_MOVE_POINTS, 3000);
		RemoveObject("necklace");
		--sleep(15);
		MoveHeroRealTime("Almegir", 145, 146, GROUND);
		local len = 100;
		while len > 1 do
			x, y = GetObjectPos( "Almegir" );
			len = sqrt( (x - 145) * (x - 145) + (y - 146) * (y - 146) );
			print( "len = ", len);
			sleep( 1 );
		end;
		--sleep(15);
		SetObjectPos("Almegir", 62, 27, UNDERGROUND);
		EnableHeroAI("Almegir", not nil);
		UnblockGame();
		sleep(3);
		StartDialogScene("/DialogScenes/Single/SXL1/R8/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("obj5", OBJECTIVE_ACTIVE);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "wing_stealing", nil);
		startThread(SXL1R11_objective5_complete);
		break;
	end;
	sleep(3);
end;
end;

function SXL1R11_objective5_complete()
	while 1 do
		if IsHeroAlive("Almegir")==nil then
			SetObjectiveState("obj5", OBJECTIVE_COMPLETED);
			GiveArtefact("Muscip", ARTIFACT_DRAGON_TEETH_NECKLACE, 1);
			sleep(3);
			StartDialogScene("/DialogScenes/Single/SXL1/R11/DialogScene.xdb#xpointer(/DialogScene)");
			break
		end;
	sleep(5);
	end;
end;


----------- Objective 6 ----------- 

function SXL1R9_objective6()
	local he = GetPlayerHeroes(PLAYER_1)
	for i, hero in he do
		if IsObjectInRegion( hero, "underground" ) then
		--if GetObjectsInRegion("underground", OBJECT_HERO)==he then
		StartDialogScene("/DialogScenes/Single/SXL1/R9/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("obj6", OBJECTIVE_ACTIVE);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "underground", nil);
		startThread (objective6_completed);
		break;
		end;
	end;
end;

function objective6_completed()
	while 1 do
		if KnowHeroSpell("Muscip", SPELL_DIMENSION_DOOR)==not nil then
			StartDialogScene("/DialogScenes/Single/SXL1/R10/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("obj6", OBJECTIVE_COMPLETED);
			break;
		end;
	sleep(3)
	end;
end;


----------- Objective 7 ----------- 

function SXL1R13_objective7()
	local res = GetPlayerResource(PLAYER_1, GEM) - 100
	if GetPlayerResource(PLAYER_1, GEM)>=100 then
		SetPlayerResource(PLAYER_1, GEM, res)
		SetObjectiveState("obj7", OBJECTIVE_COMPLETED);
		LevelUpHero("Muscip");
		sleep(3);
		StartDialogScene("/DialogScenes/Single/SXL1/R13/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(3);
		SetObjectiveState("obj8", OBJECTIVE_ACTIVE);
	end;
end;

----------- Objective 8 ----------- 

function SXL1R14_dguard(heroName)
	if HasArtefact(heroName, ARTIFACT_DRAGON_TEETH_NECKLACE)==not nil and GetObjectiveState("obj7")==OBJECTIVE_COMPLETED then
		BlockGame();
		StartDialogScene("/DialogScenes/Single/SXL1/R14/DialogScene.xdb#xpointer(/DialogScene)");
		SetRegionBlocked("special_for_akimovs_cheat", nil, PLAYER_1);
		sleep(5);
		SetObjectPos("dragon_guardian",159, 2, GROUND);
		sleep(5)
		RemoveObject("dragon_guardian");
		UnblockGame();
		SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
		SetObjectiveState("obj8", OBJECTIVE_COMPLETED);
		sleep(3);
		SetObjectiveState("obj9", OBJECTIVE_ACTIVE);
		startThread(SXL1R15_objective9);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "dragon_guardian", nil);
	else
		MessageBox("/Maps/SingleMissions/SXL1/dragon_answer.txt");
	end;
end;

----------- Objective 9 ----------- 

function SXL1R15_objective9()
	while 1 do
		if IsObjectExists("guards") == nil then
			StartDialogScene("/DialogScenes/Single/SXL1/R15/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			SetObjectiveState("obj9", OBJECTIVE_COMPLETED);
			SetObjectiveState("n_obj", OBJECTIVE_COMPLETED);			
			sleep(3);
			Win();
			break
		end;
	sleep(3);
	end;
end;	

----------- Lose ----------- 

function Lose()
	while 1 do
		if IsHeroAlive("Muscip") == nil then
			SetObjectiveState("n_obj", OBJECTIVE_FAILED);
			sleep(3);
			Loose();
			break
		end;
	sleep(5);
	end;
end;

------Start Line-------

objective1();
disactivation();
startThread( Lose );
Trigger( OBJECT_TOUCH_TRIGGER, "observer", "SXL1R4_SXL1R5" );
Trigger( OBJECT_TOUCH_TRIGGER, "seer_hut", "SXL1R2_objective2" );
Trigger( OBJECT_TOUCH_TRIGGER, "key_tent", "SXL1R6_objective4" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "underground", "SXL1R9_objective6" );
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "dragon_guardian", "SXL1R14_dguard");