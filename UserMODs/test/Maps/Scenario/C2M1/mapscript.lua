StartDialogScene("/DialogScenes/C2/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
-----------------------------------------------------------
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M1");
end;

startThread(H55_InitSetArtifacts);
-----------------------------------------------------------
SetObjectEnabled("witch_hut",nil);
heroname = "Agrael"
ENEMY_HERO_NAME = "Godric";

-- If Difficulty Level is NORMAL or HARD enemy hero Godric loss part of his move points at the beginning of each turn.

message_C2M1_C1 = 0;
message_C2M1_C2 = 0;
message_C2M1_C3 = 0;
message_C2M1_C4 = 0;
-----------------------------------//DB--startAI
EnableHeroAI("Godric",nil);
EnableHeroAI("Brem",nil);
---------------------------------------
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "Godric_force",nil );


function H55_TriggerDaily()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 3 ) then
		sleep(2);
		print ('Fasss_Godric!!!');
		SetObjectPosition("Godric", 6, 90, 0);
		MoveCamera(6, 90, 0, 50, 1);
		sleep(6);
--		SetRegionBlocked("enter", 1, PLAYER_2);   --------//db
			EnableHeroAI("Godric",not nil);
			EnableHeroAI("Brem",not nil);
		sleep(2);
		startThread( EngageHero, heroname ); ---------///Test_Godric
		startThread(SetMPFactorForGodric);
	end;
end;
----------------------------------------------------///Test_Godric

function EngageHero( heroname )
	while IsHeroAlive( ENEMY_HERO_NAME ) do
		while GetCurrentPlayer() ~= PLAYER_2 or not ((GetDate(DAY_OF_WEEK) == 1) or (GetDate(DAY_OF_WEEK) == 3) or (GetDate(DAY_OF_WEEK) == 5) or (GetDate(DAY_OF_WEEK) == 7)) do
----			print ('Turn!!!!');
			sleep( 1 );
		end;
		MoveHero( ENEMY_HERO_NAME, GetObjectPosition( heroname ) );
		EnableHeroAI("Godric",not nil);  ------!!!
			while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 1 );
		end;
	end;
end;
-----------------------------------------------------///Garnizon_warning
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Typit","Warningmess" );

function Warningmess()
	if IsPlayerHeroesInRegion(1, "Typit") == not nil then
		sleep( );
		MessageBox ("/Maps/Scenario/C2M1/warn1.txt");
	end;
end;

-----------------------------------//DB--gogric_down
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "god2","Donj",nil  );

function Donj()
	if IsPlayerHeroesInRegion(1, "god2") == not nil and IsHeroAlive("Godric") == not nil then
		sleep(6);
		SetObjectPosition("Godric", 65, 12, 0);
	end;
end;

------------------------------------//DB--start_resource
SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 0);
-----------------------------------
function P_Objective1()
	while 1 do	
		sleep( 10 );	
		if IsHeroAlive("Marder") == nil then
			SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
			break;
		end;
	end;
end;

function P_Objective2()
	while 1 do
		sleep(10);
		if IsHeroAlive("Agrael") == nil then
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			break;
		end;
	end;
end;

-----------------------------------
-----------------------------------

function messages()
while 1 do
	if message_C2M1_C1 == 0 then
		message_C2M1_C1 = 1;
		sleep();
		print("message_C2M1_C1");
		sleep();
	end;
	if IsObjectVisible(PLAYER_1, "SubPassage") and message_C2M1_C2 == 0 then
		message_C2M1_C2 = 1;
		sleep(50);
		print("message_C2M1_C2");
		StartDialogScene("/DialogScenes/C2/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep();
	end;
	if IsPlayerHeroesInRegion( PLAYER_1, "ambush" ) and message_C2M1_C3 == 0 and IsObjectVisible( PLAYER_1, "Marder" ) then
		sleep(40);
		message_C2M1_C3 = 1;
		sleep();
		print("message_C2M1_C3");
		StartDialogScene("/DialogScenes/C2/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(1);
	end;
	sleep();
end;
end;

function WaitPlayerTurn( playerID )
	local current;
	while GetCurrentPlayer() ~= playerID do
		sleep();
	end;
end;

ErasialDeployed = 0;
--c2m1_trigger_active = 0;
--function AIActionTrigger()
--	c2m1_trigger_active = 1;
--end;

function GetHeroCoord()
	local cx,cy,cl;
	local heroes = {};
	local m = 0;
	local hero;
	heroes = GetObjectsInRegion( "ambush", OBJECT_HERO );
	for m, h in heroes do
		if GetObjectOwner( h ) == PLAYER_1 then
			cx,cy,cl = GetObjectPos(h);
			hero = h;
			return cx,cy,cl,hero;
		end;
	end;
end;

function AIAction()
	local cx,cy,cl,h;
	while IsPlayerHeroesInRegion( PLAYER_1, "ambush" ) == nil do
		sleep();
	end;
	print("Ambush!!!");	
	cx,cy,cl,h = GetHeroCoord("Agrael");
	ChangeHeroStat( "Agrael", STAT_MOVE_POINTS, -30000 );
	BlockGame();
	ChangeHeroStat( "Marder", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Marder", 12, 9, GROUND );
	while message_C2M1_C3 == 0 do
		sleep();
	end;
	sleep(20);
	ChangeHeroStat( "Marder", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Marder", cx, cy, GROUND );
	UnblockGame();
	EnableHeroAI("Marder", not nil);
--	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ambush", nil);
end;

function WinsLoose()
	while 1 do
		if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Agrael", "C2M1");
			sleep(4);
			Save("Save") ---сохраняем перед последней сценой!
			sleep(20);
			StartDialogScene("/DialogScenes/C2/M1/D2/DialogScene.xdb#xpointer(/DialogScene)","Win"); -----новая !!!
			print("Win()");
--			Win();
			return
		end;
		if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			sleep(40);
			print("Loose()");
			Loose();
			return
		end;
		sleep();
	end;
end;

-------------------------------------

function witch_hut_first_visit(HeroName)
	if HeroName == "Agrael" then
		print(HeroName, " has visited witch hut");
		MessageBox("/Maps/Scenario/C2M1/MessageBox_WitchHutFirstVisit.txt");
		MarkObjectAsVisited("witch_hut",HeroName);
		GiveHeroSkill(HeroName,SKILL_LOGISTICS);
		Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_already_visited");
	else
		print("Another hero touch witch hut. It is ", HeroName);
	end;
end;

function witch_hut_already_visited(HeroName)
	if HeroName == "Agrael" then
		print(HeroName, " has visited witch hut one more time");
		MessageBox("/Maps/Scenario/C2M1/MessageBox_WitchHutAlreadyVisited.txt");
		Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_already_visited");
	else
		print("Another hero touch witch hut. It is ", HeroName);
	end;
end;

function SetMPFactorForGodric()
	if GetDifficulty() == NORMAL then
		MPFactor = 3;
		startThread(TriggerPlayer);
		print("Difficulty level is NORMAL. MPFactor = ", MPFactor);
		else
		if GetDifficulty() == HARD then
			MPFactor = 6;
			startThread(TriggerPlayer);
			print("Difficulty level is HARD. MPFactor = ", MPFactor);
			else
				print("Difficulty level is HEROIC");
		end;
	end;
end;

function SetGodricMovePoints()
	print("Thread SetGodricMovePoints has been started...");
	if IsHeroAlive("Godric") == not nil then
		print("Godric is moving");
		GodricMP = GetHeroStat("Godric",STAT_MOVE_POINTS);
		print("Godric has ",GodricMP ," Move Points");
		delta = (GodricMP - mod(GodricMP,MPFactor)) / MPFactor;
		print("delta = ",delta);
		ChangeHeroStat("Godric",STAT_MOVE_POINTS,-delta);
		sleep(5);
		print("Stats changed. Now Godric has ",GetHeroStat("Godric",STAT_MOVE_POINTS)," Move Points");
	else
		print("Hero Godric does not exist or dead.");
	end;
end;

function TriggerPlayer()
	print("Thread TriggerPlayer has been started...");
	while 1 do
		CurrentPlayer = GetCurrentPlayer();
		while CurrentPlayer == GetCurrentPlayer() do
			CurrentPlayer = GetCurrentPlayer();
			sleep(2);
		end;
		print("Player triggered");
		if CurrentPlayer == PLAYER_1 then
			print("PLAYER'S 1 turn");
			startThread(SetGodricMovePoints);
			else
			if CurrentPlayer == PLAYER_3 then
				print("PLAYER'S 3 turn");
				else
				print("PLAYER'S 2 turn");
			end;
		end;
		sleep(10);
	end;
end;

H55_CamFixTooManySkills(PLAYER_2,"Godric");
SetRegionBlocked("keyreg", 1, PLAYER_2); ---------///db
SetRegionBlocked("block", 1, PLAYER_2);
SetRegionBlocked("block1", 1, PLAYER_2);
SetRegionBlocked("Art1", 1, PLAYER_2);   --------//db
SetRegionBlocked("Art2", 1, PLAYER_2);   --------//db
DeployReserveHero( "Marder", 27, 9, GROUND ); -- деплоим героя для комбата
sleep();
ErasialDeployed = 1;
EnableHeroAI( "Marder", nil );
MoveHero( "Marder", 26, 9, GROUND );

--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ambush", "AIActionTrigger");
startThread( AIAction );
startThread( P_Objective2 );
startThread( P_Objective1 );
startThread( messages );
startThread( WinsLoose );
Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_first_visit");