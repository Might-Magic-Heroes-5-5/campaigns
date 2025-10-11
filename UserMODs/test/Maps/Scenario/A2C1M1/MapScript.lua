H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_STAFF_OF_VEXINGS,
ARTIFACT_CLOAK_OF_MOURNING,
ARTIFACT_RING_OF_DEATH,
ARTIFACT_SKULL_HELMET

};

StartDialogScene("/DialogScenes/A2C1/M1/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----///—цена_стартова€ 

PlayVisualEffect( "/Effects/_(Effect)/Buildings/Dwellings/Necropolis/Ruined_Tower.xdb#xpointer(/Effect)", "","keeper_fx", 16, 29, 0, 0, 0 );
PlayVisualEffect( "/Effects/_(Effect)/Towns/Necropolis/NecromancyAmplifier.xdb#xpointer(/Effect)", "","keeper_fx1", 16, 29, 0, 0, 0 );

PlayVisualEffect( "/Effects/_(Effect)/Buildings/Dwellings/Necropolis/Ruined_Tower.xdb#xpointer(/Effect)", "","keeper1_fx", 83, 19, 0, 0, 0 );
PlayVisualEffect( "/Effects/_(Effect)/Towns/Necropolis/NecromancyAmplifier.xdb#xpointer(/Effect)", "","keeper1_fx1", 83, 19, 0, 0, 0 );


SetRegionBlocked("stop_ai", 1, PLAYER_2); 
SetRegionBlocked("tutorial3", 1, PLAYER_2); 

SetRegionBlocked("ai1", 1, PLAYER_2); 
SetRegionBlocked("ai2", 1, PLAYER_2); 
SetRegionBlocked("aix", 1, PLAYER_2); 

SetRegionBlocked("bl1", 1, PLAYER_2); 
SetRegionBlocked("bl2", 1, PLAYER_2);
SetRegionBlocked( "regionToOrnellaTeleport_1", not nil );
SetRegionBlocked( "regionToOrnellaTeleport_2", not nil );

Artefact_1 = 0
Artefact_2 = 0
Artefact_3 = 0
Artefact_4 = 0
-----------------------
Portal_1_open = 0
-----------------------
SetDisabledObjectMode( "StrangeMine", DISABLED_INTERACT )
print ("Cursor_mine_changed");
----------------------------

OverrideObjectTooltipNameAndDescription ( "forge", "/Maps/Scenario/a2c1m1/tyltip1.txt", "/Maps/Scenario/a2c1m1/tyltip2.txt" );

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua"); ----!!! 

GiveExp( "Isher", 20000 ); ---addexp

PlayerHero = "Ornella"

EnemyHero = "Aberrar"
EnemyHero1 = "Straker"
--EnemyHero2 = "Gles"
EnemyHero2 = "Isher"
diff = 0
outp_stb = 0
outp1_stb = 0
mer = 0
sul = 0
amount = 0
lkp = 0
ukp = 0
timing = 0
StrangeOre = 0
isTownAlreadyCaptured=0;
isDialogAlreadyPlayed=0;

buildings = {"apelsin", "outpost1", "outpost2"}
AiHeroes = {EnemyHero, EnemyHero1}
-------------------------------------------------------------Tutorial////////////////////

function Tutopial_111()
	while 1 do
		if IsObjectInRegion(PlayerHero, "tutorial1" ) == not nil then
			TutorialMessageBox( "a2c1m1_2" );
			break;
		end;
	sleep( 2 );
	end;	
end;

function Tutopial_222()
	while 1 do
		if IsObjectExists("gr01") == nil then
			sleep( 10 );
			TutorialMessageBox( "a2c1m1_3" );
			break;
		end;
	sleep( 2 );
	end;	
end;

function Tutopial_333()
	while 1 do
		if IsObjectExists("gr02") == nil then
			sleep( 10 );
			TutorialMessageBox( "a2c1m1_4" );
			break;
		end;
	sleep( 2 );
	end;	
end;

function Tutopial_444()
	while 1 do
		if IsObjectExists("gr03") == nil then
			sleep( 10 );
			TutorialMessageBox( "a2c1m1_6" );
			break;
		end;
	sleep( 2 );
	end;	
end;

function Town_tut()
	if (GetObjectOwner("outpost1") == PLAYER_1) then
		BlockGame();
		sleep( 5 );
		x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( PlayerHero );
		CreateMonster( "mage", CREATURE_MAGI, 10, 19, 59, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
		sleep( 1 );
		SetObjectPosition( PlayerHero, 17, 58, GROUND );
		SetObjectRotation( PlayerHero, 90 );
		sleep( 2 );
		StartAdvMapDialog (0);  -------------------------0_adv_map_scene
		sleep( 5 );
		RemoveObject( "mage" ) 
		SetObjectPosition( PlayerHero, x_orn_scene, y_orn_scene, floor_orn_scene );
		sleep( 5 );
		UnblockGame();
		TutorialMessageBox( "a2c1m1_5" );
	elseif (GetObjectOwner("outpost2") == PLAYER_1) then
		BlockGame();
		sleep( 5 );
		x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( PlayerHero );
		CreateMonster( "mage", CREATURE_MAGI, 10, 70, 13, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
		sleep( 1 );
		SetObjectPosition( PlayerHero, 70, 15, GROUND );
		SetObjectRotation( PlayerHero, 0 );
		sleep( 2 );
		StartAdvMapDialog (7);  -------------------------0_adv_map_scene
		sleep( 5 );
		RemoveObject( "mage" ) 
		SetObjectPosition( PlayerHero, x_orn_scene, y_orn_scene, floor_orn_scene );
		sleep( 5 );
		UnblockGame();
		TutorialMessageBox( "a2c1m1_5" );
	end;
end;

----------------------------------------------------------------------///////////////////
	
function diff_setup()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 2;
		print ("easy");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 2;
		print ("normal");
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 3;
		print ("Hard");
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 4;
		print ("Impossible");
	end;
	TownsSetUp();
	-- outpost1_setup();
	-- outpost2_setup();
--	EnemyHeroesSetUp();
	-- enemyhero1_setup();
--	Trigger(NEW_DAY_TRIGGER, "ai_source");
	print("Difficulty =", diff);
end;
---------------------------------//
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY or slozhnost == DIFFICULTY_NORMAL then
		SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
		sleep( 5 );
		MessageBox("/Maps/Scenario/a2c1m1/warning.txt")
--	elseif slozhnost == DIFFICULTY_NORMAL then
--		sleep( 15 );
--		MessageBox("/Maps/Scenario/a2c1m1/warning2.txt")
elseif slozhnost == DIFFICULTY_HARD or slozhnost == DIFFICULTY_HEROIC  then
		SetObjectiveState("obj1_2", OBJECTIVE_ACTIVE);
		sleep( 5 );
		MessageBox("/Maps/Scenario/a2c1m1/warning2.txt")
	end;
--	print('difficulty = ',slozhnost);
end;

function H55_TriggerDaily()
	slozhnost = GetDifficulty();
	if ( GetDate(MONTH) == 3 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 1 ) then
		sleep(10); 
		MessageBox("/Maps/Scenario/a2c1m1/warning4.txt")
	end;
	if ( GetDate(MONTH) == 4 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		sleep(10); 
		Loose();  ---------------------
	end;
end;
------------------------------------//

function mission_setup()
	SetHeroesExpCoef( 0.3 );	
	MakeHeroNecromancer( PlayerHero, 1 ); 
	OpenCircleFog(47, 84, GROUND, 10, PLAYER_1);
	sleep( 30 );
	TutorialMessageBox( "a2c1m1_1" );
	
	SetObjectEnabled("witch_hut", nil);
	SetObjectEnabled("forge", nil);
	SetObjectEnabled("portal", nil);
	SetObjectEnabled("StrangeMine", nil);
	
	SetRegionBlocked("ai1", not nil, PLAYER_2);
	SetRegionBlocked("ai2", not nil, PLAYER_2);
	
	EnableHeroAI("Isher", nil);
	
	BlockTownGarrisonForAI( "apelsin", not nil );
	BlockTownGarrisonForAI( "outpost1", not nil );
	BlockTownGarrisonForAI( "outpost2", not nil );
	
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_1, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_2, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_3, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_4, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_5, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_6, 1);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_7, 0);
	
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_1, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_2, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_3, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_4, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_5, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_6, 1);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_7, 0);
	
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_DUNGEON, 0);	
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_HEAVEN, 0);	
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_INFERNO, 0);	
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_STRONGHOLD, 0);
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_ACADEMY, 0);
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_FORTRESS, 0);
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_PRESERVE, 0);
	AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_NECROMANCY, 0);

	SetDisabledObjectMode( "StrangeMine", DISABLED_INTERACT );
	--	SetDisabledObjectMode( "crypt", DISABLED_INTERACT );
	sleep( 45 );
--	Play2DSound( "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" )	
end;	
	
-------> Creature Set Up <-------

function TownsSetUp()
	for i,building in buildings do
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetObjectCreatures(building, creatureID);
			if GetObjectCreatures(building, creatureID) > 2 then
				RemoveObjectCreatures(building, creatureID, CreatureSetUp);
				AddObjectCreatures(building, creatureID, CreatureSetUp * diff);
			end;
		end;
	end;
end;

-------> Objective 1 <-------

function objective1()
	while 1 do
		if GetObjectOwner("apelsin") == PLAYER_1 and GetObjectiveState("obj1") == OBJECTIVE_ACTIVE then
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
			break;
		end;
	sleep( 3 );
	end;	
end;

function objective1_2()
	while 1 do
		if GetObjectOwner("apelsin") == PLAYER_1 and GetObjectiveState("obj1_2") == OBJECTIVE_ACTIVE then
			SetObjectiveState("obj1_2", OBJECTIVE_COMPLETED);
			break;
		end;
	sleep( 3 );
	end;	
end;


-------> Objective 2 <------- \ -------> Objective 3 <-------

--function pmessage(hero)
--	if hero == PlayerHero then
--		MessageBox("/Maps/Scenario/A2C1M1/pmessage.txt");
--		SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
--		SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
--	end;
--end; 

--Trigger(OBJECT_TOUCH_TRIGGER, "portal", "pmessage");

function pmessage(hero)
	if hero == PlayerHero then
		SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
		SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bolt", nil );
		OpenCircleFog(41, 56, GROUND, 6, PLAYER_1);
		sleep( 5 )
		MoveCamera(41, 56, GROUND, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 10 );
		MessageBox("/Maps/Scenario/A2C1M1/pmessage.txt");
		MoveCamera(24, 56, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	end;
end; 

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bolt","pmessage", nil );
--------------------------------------------------------
function key_check()
	while 1 do
		if lkp == 1 and GetObjectiveState("obj2") == OBJECTIVE_ACTIVE then
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
		end;
		if ukp == 1 and GetObjectiveState("obj3") == OBJECTIVE_ACTIVE then
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
		end;
		if GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
			break;
		end;
	sleep( 2 );
	end;
end;

x_to_return, y_to_return, floor_to_return = GetObjectPosition ( PlayerHero );

function key_keeper()
	while 1 do	
		if IsObjectExists("keeper") == nil then
			StopVisualEffects("keeper_fx");
			StopVisualEffects("keeper_fx1");
			if GetObjectiveState("obj2") == OBJECTIVE_ACTIVE then
				SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
				if isDialogAlreadyPlayed==0 then
					isDialogAlreadyPlayed=1;
					BlockGame();
					DeployReserveHero("Giovanni", 15, 28, GROUND);  --------1
					sleep(5)
					SetObjectRotation( "Giovanni", 90 );
					x_to_return, y_to_return, floor_to_return = GetObjectPosition ( PlayerHero );
					local x, y = RegionToPoint( 'regionToOrnellaTeleport_1' );
					SetRegionBlocked( 'regionToOrnellaTeleport_1', nil );
					SetObjectRotation( PlayerHero, 0 );
					SetObjectPosition( PlayerHero, x, y, GROUND );
					sleep(3)
					UnblockGame();
					StartAdvMapDialog (1, "RemoveGiovanni2"); ---------------------------------1_adv_map_dialog
					--sleep( 3 );
					--RemoveObject( "Giovanni" )  ----------------------------1
					sleep( 3 );
				end;
				MessageBox("/Maps/Scenario/A2C1M1/key_lower.txt");
				lkp = 1
				break;
			elseif lkp == 0 and GetObjectiveState("obj2") == OBJECTIVE_UNKNOWN then
				print("lkp = 1");
				lkp = 1
				MessageBox("/Maps/Scenario/A2C1M1/key_lower.txt");
				break;
			end;
		end;
	sleep( 2 );
	end;
end;


function key_keeper1()
	while 1 do
		if IsObjectExists("keeper1") == nil then
			StopVisualEffects("keeper1_fx");
			StopVisualEffects("keeper1_fx1");		
			if GetObjectiveState("obj3") == OBJECTIVE_ACTIVE then
				SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
				if isDialogAlreadyPlayed==0 then
					isDialogAlreadyPlayed=1;
					BlockGame();
					DeployReserveHero("Giovanni", 84, 18, GROUND);  --------1
					x_to_return, y_to_return, floor_to_return = GetObjectPosition ( PlayerHero );
					local x, y = RegionToPoint( 'regionToOrnellaTeleport_2' );
					SetRegionBlocked( 'regionToOrnellaTeleport_2', nil );
					SetObjectRotation( PlayerHero, 0 );
					SetObjectPosition( PlayerHero, x, y, GROUND );
					sleep(3)
					UnblockGame();
					StartAdvMapDialog (6, "RemoveGiovanni2"); ---------------------------------1_adv_map_dialog
					--sleep( 3 );
					--RemoveObject( "Giovanni" )  ----------------------------1
					sleep( 3 );
				end;
				MessageBox("/Maps/Scenario/A2C1M1/key_upper.txt");
				ukp = 1
				break;
			elseif ukp == 0 and GetObjectiveState("obj3") == OBJECTIVE_UNKNOWN then
				print("ukp = 1");
				ukp = 1
				MessageBox("/Maps/Scenario/A2C1M1/key_upper.txt");
				break;
			end;
		end;
	sleep( 2 );
	end;
end;
----------------------------dialog_advmap

--function Key_keeper_dialog(hero)
--	print("Start_advmapscene00");
--	while 1 do
--		if hero == PlayerHero then
--		print("Start_advmapscene01");
--			if IsObjectExists("keeper") == nil then
--				print("Start_advmapscene2");
--				sleep( 5 );
--				DeployReserveHero("Giovanni", 15, 28, GROUND);  --------1
--				StartAdvMapDialog (1); ---------------------------------1_adv_map_dialog
--				sleep( 3 );
--				RemoveObject( "Giovanni" )  ----------------------------1
--				print("Stop_advmapscene");
--				break;
--			elseif IsObjectExists("keeper1") == nil then
--				print("Start_advmapscene4");
--				sleep( 5 );
--				DeployReserveHero("Giovanni", 84, 18, GROUND);  --------1
--				StartAdvMapDialog (4); ---------------------------------1_adv_map_dialog
--				sleep( 3 );
--				RemoveObject( "Giovanni" )  ----------------------------1
--				print("Stop_advmapscene");
--				break;
--			end;
--		end;
--	sleep( 2 );
--	end;
--end;

-------> Objective 4 <-------

function objective4()
	a,b,terrain = GetObjectPosition( PlayerHero )
	if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
		SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj2", nil);
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj3", nil);
		OpenCircleFog(7, 89, GROUND, 8, PLAYER_1);
		MoveCamera(7, 89, GROUND, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 7 );
		MessageBox("/Maps/Scenario/a2c1m1/forge_message.txt");
		sleep( 2 );
		MoveCamera(a, b, terrain, 25, 3.14/3, 0, 1, 1, 1);
	end;
end;

function objective4c()
	if GetObjectiveState("obj4") == OBJECTIVE_UNKNOWN then
		sleep( 3 );
		MessageBox("/Maps/Scenario/a2c1m1/Forge_last.txt");
		return
	end;

	p_ore = GetPlayerResource(PLAYER_1, ORE)
	if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and GetObjectiveState("obj4") ~= OBJECTIVE_COMPLETED then
		if GetPlayerResource(PLAYER_1, ORE) >= 15 then
			SetPlayerResource(PLAYER_1, ORE, p_ore - 15);
			SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
			Portal_open = 1
			--SetObjectEnabled("portal", not nil)
			SetRegionAutoObjectEnable( "blocker_not_ornella", REGION_AUTOACTION_ON_ENTER, -1, -1, PlayerHero, "portal", 1 );
			SetRegionAutoObjectEnable( "blocker_not_ornella", REGION_AUTOACTION_ON_EXIT, -1, -1, PlayerHero, "portal", 0 );
			Trigger( OBJECT_TOUCH_TRIGGER, "portal", "ShowPortalAlert" );
			ShowFlyingSign("/Maps/Scenario/A2C1M1/portal.txt", "forge", 1, 8);
			return
		end;
	end;

	if (GetObjectiveState("obj2") == OBJECTIVE_ACTIVE and GetObjectiveState("obj3") == OBJECTIVE_ACTIVE) or 
		(GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED) then
		local key_parts = lkp + ukp >= 2 
		local ore_p_resource = GetPlayerResource(PLAYER_1, ORE) >= 15
		if key_parts ~= nil and ore_p_resource == nil then
			MessageBox("/Maps/Scenario/a2c1m1/forge_message1.txt");
		end;
		if key_parts == nil and ore_p_resource ~= nil then
			MessageBox("/Maps/Scenario/a2c1m1/forge_message2.txt");
		end;
		if key_parts == nil and ore_p_resource == nil then
			MessageBox("/Maps/Scenario/a2c1m1/forge_message2.txt");
		end;
	end;

	if GetObjectiveState("obj2") == OBJECTIVE_UNKNOWN and GetObjectiveState("obj3") == OBJECTIVE_UNKNOWN then
		MessageBox("/Maps/Scenario/a2c1m1/forge_message3.txt");
	end;
end;

function ShowPortalAlert( heroName )
	if heroName~=PlayerHero then
		MessageBox( "/Maps/Scenario/A2C1M1/MsgBox_OnlyOrnellaCanPass.txt" );
	end;
--	if GetObjectiveState("obj4") ~= OBJECTIVE_COMPLETED then
--		sleep( 5 );
--		MessageBox("/Maps/Scenario/a2c1m1/portal_closed.txt");
--	end;
end;

Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj2", "objective4");
Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj3", "objective4");

Trigger(OBJECT_TOUCH_TRIGGER, "forge", "objective4c");


-------> Objective 5 <-------

function objective3()
	while 1 do
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED or GetObjectiveState("obj1_2") == OBJECTIVE_COMPLETED then
			break;
		end;
		if IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState("obj5", OBJECTIVE_FAILED);
			sleep( 2 );
			Loose();
			break;
		end;
	sleep( 2 );
	end;
end;	

-------> Sub Objective 1n <-------

function sub_objective1(hero)
	if hero == PlayerHero then
		x,y,level = GetObjectPosition(PlayerHero)
		DeployReserveHero("Giovanni", 28, 19, GROUND);  -------2
		StartAdvMapDialog (2, "RemoveGiovanni" );  -------------------------------2_advmap_dialog
		-- sleep( 3 );
		-- RemoveObject( "Giovanni" )  ---------------------------2
		sleep( 5 );
		SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
--		Trigger(OBJECT_TOUCH_TRIGGER, "outpost2", nil);
		OpenCircleFog(77, 5, GROUND, 8, PLAYER_1);
		MoveCamera(77, 5, GROUND, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 7 );
		MessageBox("/Maps/Scenario/a2c1m1/witch_message.txt");
		sleep( 2 );
		MoveCamera(x, y, level, 25, 3.14/3, 0, 1, 1, 1);
		sleep( 5 );
		Trigger(OBJECT_TOUCH_TRIGGER, "witch_hut", "sobj1_sobj2");
	end;
end;

Trigger(OBJECT_TOUCH_TRIGGER, "skeleton_warrior", "sub_objective1");
	
-------> Sub Objective 2n <-------

function sobj1_sobj2(hero)
	mer = GetPlayerResource(PLAYER_1, MERCURY)
	x,y = GetObjectPosition(PlayerHero)
	if hero == PlayerHero then
		print("hero check passed");
		if GetObjectiveState("sobj2") == OBJECTIVE_UNKNOWN then
			SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
			SetObjectiveState("sobj2", OBJECTIVE_ACTIVE);
			MarkObjectAsVisited("witch_hut", PlayerHero);
			OpenCircleFog(5, 65, GROUND, 6, PLAYER_1);
			MoveCamera(5, 65, GROUND, 25, 3.14/3, 0, 1, 1, 1);
			sleep( 7 );
			MessageBox("/Maps/Scenario/a2c1m1/message03.txt");
			sleep( 2 );
			MoveCamera(x, y, level, 25, 3.14/3, 0, 1, 1, 1);		
		end;
		if GetObjectiveState("sobj2") == OBJECTIVE_ACTIVE then	
			print("sub objective 2 active");
			if GetPlayerResource(PLAYER_1, MERCURY) >= 10 then
				print("Mercury ok");
				if StrangeOre >= 1 then
					print("Strange Ore ok");
					if GetHeroCreatures(PlayerHero, CREATURE_WALKING_DEAD) >= 50 then
						print("sobj2 requirements completed")
						SetPlayerResource(PLAYER_1, MERCURY, mer - 10);
						RemoveHeroCreatures(PlayerHero, CREATURE_WALKING_DEAD, 50);
						SetObjectiveState("sobj2", OBJECTIVE_COMPLETED);
						Trigger(OBJECT_TOUCH_TRIGGER, "witch_hut", nil);
						Trigger(OBJECT_TOUCH_TRIGGER, "witch_hut", "Wichh_empty");
						building_limit();
						if hero == PlayerHero then
							BlockGame();	
							SetObjectRotation( PlayerHero, 180 )
							DeployReserveHero("Giovanni", 75, 9, GROUND);
							sleep( 3 );
							StartAdvMapDialog( 5, "RemoveGiovanni" );
							sleep( 5 );
							UnblockGame();
						end;
					else
						MessageBox("/Maps/Scenario/a2c1m1/res_need.txt");
					end;
				else
					MessageBox("/Maps/Scenario/a2c1m1/res_need.txt");
				end;
			else
				MessageBox("/Maps/Scenario/a2c1m1/res_need.txt");
			end;
		end;
	else
		MessageBox("/Maps/Scenario/a2c1m1/orn_need.txt");
	end;
end;

function RemoveGiovanni()
	RemoveObject( "Giovanni" );
end;

function RemoveGiovanni2()
	RemoveObject( "Giovanni" );
	SetObjectPosition( PlayerHero, x_to_return, y_to_return, floor_to_return );
end;

function Wichh_empty()
	if GetObjectiveState("sobj2") == OBJECTIVE_COMPLETED then
		MessageBox("/Maps/Scenario/A2C1M1/wich_empty.txt");
	end;
end; 


function building_limit()
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_1, 2);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_2, 2);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_3, 2);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_4, 2);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_5, 2);
	SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_6, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_1, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_2, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_3, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_4, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_5, 2);
	SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_6, 2);
end;

-------> Win <-------

function st_win()
	while 1 do
		if (GetObjectiveState("obj1") == OBJECTIVE_COMPLETED or GetObjectiveState("obj1_2") == OBJECTIVE_COMPLETED) and GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
			SetObjectiveState("obj5", OBJECTIVE_COMPLETED);
			sleep( 2 );
--			StartDialogScene("/DialogScenes/A2Single/SM2/S1/DialogScene.xdb#xpointer(/DialogScene)", "ornella_ex", "autosave");
			StartDialogScene("/DialogScenes/A2C1/M1/S2/DialogScene.xdb#xpointer(/DialogScene)", "ornella_ex", "autosave"); ----///—цена_финальна€ 
			break;
		end;
	sleep( 2 );
	end;
end;	

-------> Time Pressing <-------

function timepressing()
	if GetTownHero("apelsin") ~= EnemyHero2 then	
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetObjectCreatures("apelsin", creatureID);
			if CreatureSetUp > 2 then
				print( "TimePressing: creatureID=", creatureID, ", CreatureSetUp=", CreatureSetUp, ", diff=", diff );
				RemoveObjectCreatures("apelsin", creatureID, CreatureSetUp);
				AddObjectCreatures("apelsin", creatureID, CreatureSetUp * diff);
				sleep( 1 );
			end;
		end;
	end;
end;

function TimePressing2()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetHeroCreatures(EnemyHero2, creatureID);
		if CreatureSetUp > 2 then
			print( "TimePressing2: creatureID=", creatureID, ", CreatureSetUp=", CreatureSetUp, ", diff=", diff );
			RemoveHeroCreatures(EnemyHero2, creatureID, CreatureSetUp);
			AddHeroCreatures(EnemyHero2, creatureID, CreatureSetUp * diff);
			sleep( 1 );
		end;
	end;
end;

-------> Ornella exchange <-------

function ornella_ex()
	-- if HasArtefact(PlayerHero, 37) == not nil then 
		-- Artefact_1 = 1
		-- sleep(2);   
	-- end;
	-- if HasArtefact(PlayerHero, 42) == not nil then
		-- Artefact_2 = 1
		-- sleep(2);  
	-- end;
	-- if HasArtefact(PlayerHero, 50) == not nil then
		-- Artefact_3 = 1
		-- sleep(2); 
	-- end;
	-- if HasArtefact(PlayerHero, 23) == not nil then
		-- Artefact_4 = 1;
		-- sleep(2);
	-- end;
	startThread( ornella_ex_1 );
end;

function ornella_ex_1()
	pexp = GetHeroStat(PlayerHero, STAT_EXPERIENCE);
	SetObjectPosition(PlayerHero, 54, 84, 0);
	sleep(15); 
	PlayVisualEffect("/Effects/_(Effect)/Spells/Phantom_Out.xdb#xpointer(/Effect)", PlayerHero, 0, 0, GROUND);
		-- if Artefact_1 == 1 then 
			-- GiveArtefact("OrnellaNecro", 37); 
			-- sleep(2);   
		-- end;
		-- if Artefact_2 == 1 then 
			-- GiveArtefact("OrnellaNecro", 42);
			-- sleep(2);  
		-- end;
		-- if Artefact_3 == 1  then
			-- GiveArtefact("OrnellaNecro", 50);
			-- sleep(2); 
		-- end;
		-- if Artefact_4 == 1  then
			-- GiveArtefact("OrnellaNecro", 23);
			-- sleep(2); 
		-- end;
	sleep( 8 );
	RemoveObject(PlayerHero);
	sleep( 5 );
	DeployReserveHero("OrnellaNecro", 53, 84, GROUND);
	print("Hero_deploy");
	sleep(5);
	GiveHeroSkill("OrnellaNecro",SKILL_NECROMANCY);
	--SaveHeroAllSetArtifactsEquipped("OrnellaNecro");
	sleep(5);
	ChangeHeroStat("OrnellaNecro", STAT_EXPERIENCE, pexp);
	print("Hero_stats_changed");
	--print("Hero_artefact_save");
	sleep(10);
	Win();
end;

function StrangeMineOre(hero)
--	if hero == PlayerHero then
		if GetObjectiveState("sobj2") == OBJECTIVE_ACTIVE then	
			ShowFlyingSign("/Maps/Scenario/a2c1m1/message04.txt", "StrangeMine", PLAYER_1, 10)
			sleep( 5 );
			StrangeOre = 1
			Trigger(OBJECT_TOUCH_TRIGGER, "StrangeMine", nil);
			MarkObjectAsVisited("StrangeMine", PlayerHero);
			Trigger(OBJECT_TOUCH_TRIGGER, "StrangeMine", "StrangeMine_final"); ------2
		else
			MessageBox("/Maps/Scenario/a2c1m1/message02.txt");
		end;
--	end;
end;	
	
Trigger(OBJECT_TOUCH_TRIGGER, "StrangeMine", "StrangeMineOre");
---------------------------------месадж_про_отключение _шахты
function StrangeMine_final(hero)
	if StrangeOre == 1 then	
		ShowFlyingSign("/Maps/Scenario/a2c1m1/message100.txt", "StrangeMine", PLAYER_1, 10)
	end;
end;

-----------------------------------сцена встречи с магом
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog","dialog_1", nil );

function dialog_1()
	BlockGame();
	sleep(5);
--	x_orn, y_orn, floor_orn = GetObjectPosition( PlayerHero );
	DeployReserveHero("Giovanni", 52, 52, GROUND);  ---------3
	DeployReserveHero("Gles", 55, 52, GROUND);  ---------3
	SetObjectRotation(PlayerHero, 90);
	SetObjectPosition( PlayerHero, 54, 49, GROUND );
	sleep(3);
	StartAdvMapDialog (3, "dialog_1a");   --------------------------------3_advmap_dialog
end;

function dialog_1a()
	sleep(2);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog",nil);
	--	startThread ( ornella_mage );
--	BlockGame();
	sleep(2);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", PlayerHero, "orn1", 0, 0, 0, 0, 0 );
	sleep(8);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckBad.xdb#xpointer(/Effect)", "Gles", "mage1", 0, 0, 0, 0, 0 );
	sleep(5);
	RemoveObject( "Giovanni" );
	RemoveObject( "Gles" );
	sleep(5);
--	SetObjectPosition( PlayerHero, x_orn, y_orn, GROUND );
	UnblockGame();
	Play2DSound( "/Maps/Scenario/A2C1M1/C1M1_AM4_Giovanni_03sound.xdb#xpointer(/Sound)" ); ----------------VO
end;

--function ornella_mage()
--	BlockGame();
--	sleep(3);
--	PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", PlayerHero, "orn1", 0, 0, 0, 0, 0 );
--	sleep(8);
--	PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckBad.xdb#xpointer(/Effect)", "Gles", "mage1", 0, 0, 0, 0, 0 );
--	sleep(5);
--	RemoveObject( "Giovanni" )  -----------------------------3
--	RemoveObject( "Gles" );
--	sleep(5);
---	SetObjectPosition( PlayerHero, x_orn, y_orn, GROUND );
--	UnblockGame();
--	Play2DSound( "/Maps/Scenario/A2C1M1/C1M1_AM4_Giovanni_03sound.xdb#xpointer(/Sound)" ); ----------------VO
--end;

-----------------------------------
function Init_Art()
	InitAllSetArtifacts( "A2C1M1", "Arantir",  "OrnellaNecro" );
end;

function PlaySceneIfTownCapured( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		Trigger( OBJECT_CAPTURE_TRIGGER, "outpost1", nil );
		Trigger( OBJECT_CAPTURE_TRIGGER, "outpost2", nil );
		Town_tut();
	end;
end;
------------------------------------////Message_Portal_last
--Portal_open = 0

function port_close_mess()
--	if GetObjectiveState("obj4") ~= OBJECTIVE_COMPLETED then
	if Portal_1_open == 0 then
		sleep( 5 );
		MessageBox("/Maps/Scenario/a2c1m1/portal_closed.txt");
		print ("Message_portal_closed");
	end;
end;

Trigger(OBJECT_TOUCH_TRIGGER, "portal", "port_close_mess");

--------------------------------------------------------------///////////////////
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "Time_events" );
Trigger( OBJECT_CAPTURE_TRIGGER, "outpost1", "PlaySceneIfTownCapured" );
Trigger( OBJECT_CAPTURE_TRIGGER, "outpost2", "PlaySceneIfTownCapured" );

diff_setup();
mission_setup();

startThread ( objective1 );
startThread ( objective1_2 );

startThread ( objective3 );
startThread ( key_check);
startThread ( st_win );
--startThread ( imba );
startThread( key_keeper );
startThread( key_keeper1 );
startThread( Diff_level );
-----------------------------
startThread( Tutopial_111 );
startThread( Tutopial_222 );
startThread( Tutopial_333 );
startThread( Tutopial_444 );

--startThread( Key_keeper_dialog );
--print("functions started");