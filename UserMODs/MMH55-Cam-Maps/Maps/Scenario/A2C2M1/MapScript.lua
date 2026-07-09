doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

target  = "";
diff = 0;
head = 0
ai_head = 0;
isCastleDestroyed = 0;
SetGameVar( "A2C2M1_orcs_saved", 0 );
MONSTER_COUNT = 29;
HUT_COUNTS = 6;
GOBLINS_HELP_COST  = 5000;
GOBLINS_HEADS_STOLEN_COUNT = 150;
KUJIN_X, KUJIN_Y = GetObjectPosition( "Kujin" );
ClosestBuildingRadius = 7;
razedBuildingName = "hz";
PATH = "/Maps/Scenario/A2C2M1/";
HUTS = {"hut1","hut2","hut3","hut4","hut5","hut6","hut7","hut8"};
HUTSLength = table.length( HUTS );
targetsArrayLength = MONSTER_COUNT;
prev_ai_hero_x, prev_ai_hero_y = GetObjectPosition( "Hero1" );

targetsArray = {};
for index=1, MONSTER_COUNT do
	targetsArray[ index ] = {};
	targetsArray[ index ].name = "m"..index;
	targetsArray[ index ].count = GetObjectCreaturesCount("m"..index);
	print( targetsArray[ index ].count.." is in stack "..targetsArray[ index ].name );
end;

function startSetArtifactsInit()
    InitAllSetArtifacts( "A2C2M1", "Gottai" );
end;


function Distance( object1, object2, x, y )
	distance = -1;
	if IsObjectExists( object1 ) or IsHeroAlive( object1 ) then
		if IsObjectExists( object2 ) or IsHeroAlive( object2 ) then
			x_1, y_1 = GetObjectPosition( object1 );
			x_2, y_2 = GetObjectPosition( object2 );
			distance = sqrt((x_1-x_2)*(x_1-x_2) + (y_1-y_2)*(y_1-y_2));
		else
			if x ~= nil and y~= nil then
				distance = sqrt((x_1-x)*(x_1-x) + (y_1-y)*(y_1-y));
			else
				print("Distance: ERROR. You must specify coorinates!");
			end;
		end;
	else
		print("Distance: ERROR. Object doesn't exist!");
	end;
	return distance;
end;

function truncArray( targetIndex )
	print( "Initial table.length of array is ", targetsArrayLength );
	for i=targetIndex, targetsArrayLength-1 do 
		targetsArray[i].name = targetsArray[ i+1 ].name;
		targetsArray[i].count = targetsArray[ i+1 ].count;
	end;
	targetsArray[ targetsArrayLength  ] = nil;
	targetsArrayLength = targetsArrayLength-1;
	print( "Now table.length of array is ", targetsArrayLength );
	print( "last element is ", targetsArray[ targetsArrayLength ] );
end;

function RazeBuildingWithEffects( objectName )
	x, y, floor = GetObjectPosition( objectName );
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x, y, 0, floor ); -- Пыль
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag2", x, y, 0, floor ); -- Огонь
	RazeBuilding( objectName );
end;

DIFFICULTY = {
	[0] = function()
		ClosestBuildingRadius = 7; --Griffins 12, Crossbowmans 65, Vindicators 50
		diff = 1;
		print("Difficulty Level is NORMAL");
	end,
	
	[1] = function()
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 8); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 8); --Griffins
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 35); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 20); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 20); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 20); --Vindicators
		ClosestBuildingRadius = 9;
		diff = 1;

		print("Difficulty Level is HARD");
	end,
	
	[2] = function()
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 13); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 13); --Griffins
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 50); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 40); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 40); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 40); --Vindicators
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 18); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 18); --Griffins
		ClosestBuildingRadius = 11;
		diff = 2;
		print("Difficulty Level is HEROIC");
	end,
	
	[3] = function()
		ClosestBuildingRadius = 13;
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 65); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 60); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 60); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 60); --Vindicators
		diff = 3;
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

function InitHeadsMonster( monsterName )
	local n = table.length( headsMonsters )
	local count = GetObjectCreaturesCount( monsterName )
	targetsArray[n] = {}
	targetsArray[n].name = monsterName
	targetsArray[n].count = count
	for i=1, MONSTER_COUNT do
		targetsArray[i].name = "m"..i;
	end;
end

function H55_TriggerDaily()
	cur_ai_hero_x, cur_ai_hero_y = GetObjectPosition( "Hero1" );
	if cur_ai_hero_x == prev_ai_hero_x and cur_ai_hero_y == prev_ai_hero_y then
		print("AI is blocked!")
		AddHeroCreatures( "Hero1", CREATURE_ORC_WARRIOR, 50 );
	end;
	prev_ai_hero_x = cur_ai_hero_x; 
	prev_ai_hero_y = cur_ai_hero_y;
	for index=1, targetsArrayLength do
		if IsObjectExists( targetsArray[index].name ) == not nil then
			targetsArray[index].count = GetObjectCreaturesCount( targetsArray[index].name );
		else
			print("UpdateHeadsMonsters: object ", targetsArray[index].name  ," does not exist!");
			removeTargetFromArray( targetsArray[index].name );
		end;
	end;
	print("Count of monsters was updated");
end;

function TargetSearch()
	repeat
		local targetIndex = random( targetsArrayLength ) + 1;
		local targetName = targetsArray[targetIndex].name;
		SetAIHeroAttractor( targetName, "Hero1", 1 );
		print("Now AI target is ", targetName );
		while IsObjectExists( targetName ) == not nil do sleep(1); end;
		print("TargetSearch: Object ",targetName," does not exist!");
		print("TargetSearch: targetsArrayLength=",targetsArrayLength );	
		sleep(5);
		print("TargetSearch: (sleep)targetsArrayLength=",targetsArrayLength );	
	until targetsArrayLength == 0 or ai_head >= 1000;
	if ai_head >= 1000 then 
		return
	end
	print("TargetSearch: All monsters are destroyed or rival has collected more than 1000 heads");	
	if IsObjectExists("mpost") then
		SetAIHeroAttractor( "mpost", "Hero1", 1 );
		print("TargetSearch: Now rival target is castle");
		while isCastleDestroyed == 0 do sleep(5); end;
		print("TargetSearch: Castle is destroyed");
	end
	if HUTSLength ~= 0 then
		repeat
			HutIndex = random( HUTSLength ) + 1;
			HutName = HUTS[ HutIndex ];
			SetAIHeroAttractor( HutName , "Hero1", 1 );
			print("Now AI target is ", HutName  );
			currentHutLength = HUTSLength;
			while currentHutLength == HUTSLength do sleep(1); end;
			print("Hut ",HutName," does not exist!");
			sleep(1);
		until HUTSLength == 0 or ai_head >= 1000;	
	end;
	print("All targets found");
end;

function IsBuildingExists( buildingName )
	for i=1, HUTSLength do
		if buildingName == HUTS[i] then
			return not nil;
		end;
	end;
	return nil;
end;

function IsBuildingExist( buildingName )
	for i=1, HUTSLength do
		if HUTS[i]==buildingName then
			return not nil;
		end;
	end;
	return nil;
end;

function DestroyClosestBuildings()
	while IsHeroAlive( "Hero1" )==not nil and ai_head < 1000 do
		while GetBuildingClosestThanRadius( "Hero1", HUTS, HUTSLength, ClosestBuildingRadius ) == nil do sleep(5); end;
		closestBuilding = GetBuildingClosestThanRadius( "Hero1", HUTS, HUTSLength, ClosestBuildingRadius );
		print("DestroyClosestBuildings: AI senses the building ", closestBuilding ," near him");
		EnableHeroAI( "Hero1", nil );
		print("DestroyClosestBuildings: AI for enemy hero is blocked");
		local x,y,floor = GetObjectPosition( closestBuilding );
		
		while IsBuildingExist( closestBuilding ) == not nil do
			while GetCurrentPlayer() ~= PLAYER_2 do sleep(1); end;
			if IsBuildingExist( closestBuilding ) == not nil then
				EnableHeroAI( "Hero1", not nil );
				if CanMoveHero( "Hero1", x, y, floor ) then
					MoveHero( "Hero1", x, y, floor );
				else
					print("DestroyClosestBuildings: building ", closestBuilding, " is currently unavailable");
				end;
			else
				break;
			end;
			while GetCurrentPlayer() == PLAYER_2 do sleep(1); end;
			sleep(1);
		end;
		MoveHero( "Hero1", GetObjectPosition("Hero1") );-- Необходимо, чтобы АИ не тупил, пытаясь бежать в тайл разрушенного здания
		EnableHeroAI( "Hero1", not nil );
		print("DestroyClosestBuildings: Object ", closestBuilding ," has been destoyed. AI enabled");
		sleep(5);
	end;
	print("AI is dead or has more than 1000 heads");
end;

function GetBuildingClosestThanRadius( heroName, buildingsArray, arrayLength, radius )
	for i=1, arrayLength do
		if Distance( heroName, buildingsArray[i] ) <= radius then
			return buildingsArray[i];
		end;
	end;
	return nil;
end;

function removeTargetFromArray( targetName )
	print("Initial array table.length is ", targetsArrayLength );
	for j=1, targetsArrayLength do
		if targetsArray[j].name == targetName then
			local targetIndex = j;
			for i=targetIndex, targetsArrayLength-1 do 
				targetsArray[i].name = targetsArray[ i+1 ].name;
				targetsArray[i].count = targetsArray[ i+1 ].count;
			end;
			targetsArray[ targetsArrayLength ] = nil;
			targetsArrayLength = targetsArrayLength-1;
			break;
		end;
	end;
	print("Array is truncated. Current table.length is ", targetsArrayLength );
end;

function removeHutFromArray( targetName )
	print("Initial array table.length is ", HUTSLength );
	for j=1, HUTSLength  do
		if HUTS[j] == targetName  then
			HutIndex = j;
			for i=HutIndex, HUTSLength-1 do 
				HUTS[i] = HUTS[ i+1 ];
			end;
			HUTS[ HUTSLength  ] = nil;
			HUTSLength = HUTSLength-1;
			print("array HUTS is truncated");
			break;
		end;
	end;
end;


function GetHeadsFromArray( objectName )
	for i=1, targetsArrayLength do
		if targetsArray[i].name == objectName then
			return targetsArray[i].count;
		end;
	end;
	print("GetHeadsFromArray: WARNING!!! Object hasn't found in the targetsArray!");
end;
 
function ShowRivalHeadsMessageboxes()
	prev_head_collected = 0;
	while 1 do
		while ai_head < prev_head_collected+200 do sleep(5); end;
		while GetCurrentPlayer()~=PLAYER_1 do sleep(5); end;
		prev_head_collected = ai_head;
		sleep(5);
		MessageBox( {"/Maps/Scenario/A2C2M1/ai_heads_m.txt"; ai_heads_collected=ai_head, gotai_heads_collected=head } );
		while GetCurrentPlayer()==PLAYER_1 do sleep(5); end;
		sleep(5);
	end;
end;

function MoveRivalToStart()
	while ai_head < 1000 do sleep(20); end;
	print("Rival has collected more than 1000 heads");
	while GetCurrentPlayer()~=PLAYER_1 do sleep(20); end;
	MessageBox( PATH.."MsgBox_RivalHasCollectedHeads.txt" );	
	local KUJIN_X, KUJIN_Y = GetObjectPosition( "Kujin" );
	while 1 do
		while GetCurrentPlayer()~=PLAYER_2 do 
			sleep(20); 
		end
		EnableHeroAI( "Hero1", nil );
		if CanMoveHero( "Hero1", KUJIN_X, KUJIN_Y, GROUND ) == not nil then
			EnableHeroAI( "Hero1", not nil );
			print("MoveRivalToStart: AI has moved to Kujin");
			MoveHero( "Hero1", KUJIN_X, KUJIN_Y, GROUND );
		else
			print("MoveRivalToStart: Path is blocked!");
		end;
		while GetCurrentPlayer()==PLAYER_2 do 
			sleep(20);
			if ai_head < 1000 then
				EnableHeroAI( "Hero1", not nil );
				local x, y, f = GetObjectPosition( "Hero1" );
				MoveHero( "Hero1", x, y, f);
				startThread( MoveRivalToStart );
				return
			end;
		end;
		sleep(20);
	end;
	print("MoveRivalToStart: WARNING!!!");
end;

function IsGotaiCollectAllHeads()
	for i=1, 5 do
		while head < 200*i do sleep(5); end;
		print("collected more than ", 200*i, " heads");
		sleep(5);
		MessageBox( { "/Maps/Scenario/A2C2M1/heads_message.txt"; txt_head = head, ai_heads = ai_head } );
	end;
	MessageBox( PATH.."MsgBox_TimeToReturnToStart.txt" );	
end;

------------------------------------------ Sub Objective 2 ------------------------------------------
function RemoveIfExists( objectName )
	if IsObjectExists( objectName ) == not nil then
		RemoveObject( objectName  );
	else
		print("RemoveIfExists: object ", objectName, " does not exist and can not be removed");
	end
end

------------------------------------------ Sub Objective 2 ------------------------------------------
function speakWithGoblins( hero )
	if hero == "Gottai" then
		QuestionBox( { PATH.."MsgBox_WantPayForGoblinsHelp.txt"; helpCost=GOBLINS_HELP_COST, headsStolen=GOBLINS_HEADS_STOLEN_COUNT }, "WantPay", "DontPay" );
	end
end

function DontPay()
	print("empty");
end

function WantPay()
	if GetPlayerResource(PLAYER_1, GOLD) >= GOBLINS_HELP_COST then 
		OBJECTIVES.state.bribeGoblins[2] = 3;
	else
		MessageBox( {PATH.."MsgBox_NotEnoughMoney.txt"; money = GOBLINS_HELP_COST } );
	end
end

function IsTargetTouched( heroName, objectName )
	print("IsTargetTouched: Object ", objectName, " is touched");
	local collected_heads=GetHeadsFromArray( objectName );
	removeTargetFromArray( objectName );
	if heroName == "Gottai" then
		head = head  + collected_heads;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = collected_heads }, "Gottai", PLAYER_1, 4 );
	else
		ai_head = ai_head  + collected_heads;
		print("IsTargetTouched: AI has collected ", ai_head ," heads" );
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = collected_heads }, "Hero1", PLAYER_1, 4 );
	end;	
end;

function IsBuildingTouched( heroName, objectName )
	print("IsBuildingTouched started");
	RazeBuildingWithEffects( objectName );
	razedBuildingName = objectName;
	if objectName == "mpost" then
		isCastleDestroyed = 1;
		castleHeadsCount = random(30) + 70-GetDifficulty()*10;
		if heroName == "Gottai" then
			head = head + castleHeadsCount;
		else
			ai_head = ai_head + castleHeadsCount;
			print("IsBuildingTouched: AI has collected ", ai_head ," heads" );
		end;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = castleHeadsCount }, heroName, PLAYER_1, 4 );	
	else
		removeHutFromArray( objectName );
		hutHeadsCount = random(20) + 50-GetDifficulty()*10;
		if heroName == "Gottai" then
			head = head + hutHeadsCount;
		else
			ai_head = ai_head + hutHeadsCount ;
			print("IsBuildingTouched: AI has collected ", ai_head ," heads" );
		end;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = hutHeadsCount }, heroName, PLAYER_1, 4 );
	end;
end;

KUJIN_MEETUP = {
	["GateEntranceWest"] = { 50, 12, GROUND, 250, 90, 2 },
	["GateEntranceNorth"] = { 76, 16, GROUND, 160, -30, 0 },
}

function PlaySObjectiveScene( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceWest", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceNorth", nil );
		if IsObjectInRegion(hero, "GateEntranceWest") then
			CINEMATICS.kujinTalkAboutGoblins(KUJIN_MEETUP["GateEntranceWest"]);
		else
			CINEMATICS.kujinTalkAboutGoblins(KUJIN_MEETUP["GateEntranceNorth"]);
		end
		OBJECTIVES.state.bribeGoblins[2] = 1;
	end
end
 
function IsFirstCombatFinished( combatIndex )
    if GetSavedCombatResult( combatIndex ) ~= COMBAT_RESULT_NONE then
		if GetSavedCombatArmyPlayer( combatIndex, 1 ) == PLAYER_1 then
			Trigger( COMBAT_RESULTS_TRIGGER, nil );
			OBJECTIVES.state.saveOrcs[2] = 1;
		end
	end
end

function WinCheck( hero )
	if hero == "Gottai" then
		if head >=1000 then
			OBJECTIVES.state.getHeads[2] = 3;
		else
			MessageBox("/Maps/Scenario/A2C2M1/MsgBox_NotEnoghHeads.txt");
		end
	elseif ai_head >=1000 then
		OBJECTIVES.state.getHeads[2] = 4;
	end
end

CINEMATICS = {
	are_playing = nil,
	playAndWait = function( id )
		CINEMATICS.are_playing = not nil;
		StartAdvMapDialog( id, CINEMATICS.end_play() );
		repeat sleep(30); until CINEMATICS.are_playing == nil;
	end,
	
	end_play = function()
		CINEMATICS.are_playing = nil;
	end,
	
	intro = function()
		StartDialogScene( "/DialogScenes/A2C2/M1/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		BlockGame()
		Play2DSound( "/Maps/Scenario/A2C2M1/C2M1_VO2_Gotai_01sound.1.xdb#xpointer(/Sound)"  );
		sleep( GetSoundTimeInSleeps( "/Maps/Scenario/A2C2M1/C2M1_VO2_Gotai_01sound.1.xdb#xpointer(/Sound)" ) );
		UnblockGame();
	end,
	
	kujinTalkAboutGoblins = function(region)
		SetObjectPosition( "Kujin", region[1], region[2], region[3] );
		SetObjectRotation( "Kujin", region[4] );
		SetObjectRotation( "Gottai", region[5] );
		sleep(1);
		CINEMATICS.playAndWait( region[6] );
		SetObjectPosition( "Kujin", KUJIN_X, KUJIN_Y, GROUND );
		SetObjectRotation( "Kujin", 180 );
	end,
	
	bribeGoblins = function()
		CINEMATICS.playAndWait( 1 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A2C2/M1/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

OBJECTIVES = {
	state = {
	   getHeads		= {  "obj1", 1 },		-- collect 1000 heads
	   isAlive		= {  "obj2", 1 },		-- Gottai must survive
	   saveOrcs		= { "sobj1", 0 },		-- Keephalf of Orc Warriors alive till the end
	   killLich		= { "sobj2", 0 },		-- ??
	   bribeGoblins	= { "sobj3", 0 },		-- ??
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		SetRegionBlocked( "KujinGate1" , not nil, PLAYER_1 );
		SetRegionBlocked( "KujinGate2" , not nil, PLAYER_1 );
		SetRegionBlocked( "KujinGate1" , not nil, PLAYER_2 );
		SetRegionBlocked( "KujinGate2" , not nil, PLAYER_2 );
		startThread( startSetArtifactsInit );
		SetObjectEnabled("hut8", nil);
		SetObjectEnabled("hut1", nil);
		SetObjectEnabled("hut2", nil);
		SetObjectEnabled("hut3", nil);
		SetObjectEnabled("hut4", nil);
		SetObjectEnabled("hut5", nil);
		SetObjectEnabled("hut6", nil);
		SetObjectEnabled("hut7", nil);
		SetObjectEnabled("mpost", nil);
		SetObjectEnabled("bandit", nil);
		SetDisabledObjectMode( "bandit", DISABLED_INTERACT );
		EnableHeroAI("Kujin", nil);
		DIFFICULTY[GetDifficulty()]();
		-- Max Warrior = 110;  Centaur  = 180; Goblins = 224
		-- Base Warrior = 60; Centaur = 80; Goblins = 120
		local coeff = 0.5/diff; -- (Easy - 1, Normal - 0.5, Hard - 0.25, Easy - 0.13)
		AddHeroCreatures( "Gottai", CREATURE_GOBLIN, 100 * coeff);
		AddHeroCreatures( "Gottai", CREATURE_CENTAUR, 100 * coeff);
		AddHeroCreatures( "Gottai", CREATURE_ORC_WARRIOR, 50 * coeff);
		sleep(10);
		STARTING_WARRIORS = GetHeroCreatures("Gottai", CREATURE_ORC_WARRIOR);
		SetRegionBlocked( "sobj2_region", not nil, PLAYER_2 );
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0 );
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes(PLAYER_3, 1);
		Trigger( COMBAT_RESULTS_TRIGGER, "IsFirstCombatFinished" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceWest", "PlaySObjectiveScene" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceNorth", "PlaySObjectiveScene" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "finish", "WinCheck" );
		Trigger( OBJECT_TOUCH_TRIGGER, "bandit", "speakWithGoblins" );
		for i=1, MONSTER_COUNT do
			Trigger( OBJECT_TOUCH_TRIGGER, "m"..i, "IsTargetTouched");
		end
		for i=1, 8 do
			Trigger( OBJECT_TOUCH_TRIGGER, "hut"..i, "IsBuildingTouched");
		end
		Trigger( OBJECT_TOUCH_TRIGGER, "mpost", "IsBuildingTouched");
		startThread( MoveRivalToStart );
		startThread( TargetSearch );
		startThread( IsGotaiCollectAllHeads );
		startThread( DestroyClosestBuildings );
		startThread( ShowRivalHeadsMessageboxes );
		H55_NewDayTrigger = 1;
		--Trigger ( NEW_DAY_TRIGGER, "UpdateHeadsMonsters" );
	end,

	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_FAILED or GetObjectiveState("obj2") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("sobj1") ~= OBJECTIVE_ACTIVE then
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	getHeads = function()
		if OBJECTIVES.state.getHeads[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.getHeads[2] = 2;
		elseif OBJECTIVES.state.getHeads[2] == 3 then
			SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
			SaveHeroAllSetArtifactsEquipped( "Gottai", "A2C2M1" );
			OBJECTIVES.state.getHeads[2] = 10;
		elseif OBJECTIVES.state.getHeads[2] == 4 then
			SetObjectiveState( "obj1", OBJECTIVE_FAILED );
			MessageBox("/Maps/Scenario/A2C2M1/MsgBox_RivalWasFaster.txt");
			OBJECTIVES.state.getHeads[2] = 11;
		end
	end,

	isAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 then
			if IsHeroAlive("Gottai") == nil then
				SetObjectiveState( "obj2", OBJECTIVE_FAILED );
				OBJECTIVES.state.isAlive[2] = 11;
			elseif GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.isAlive[2] = 10;
			end
		end
	end,
	
	saveOrcs = function()
		if OBJECTIVES.state.saveOrcs[2] == 1 then
			SetObjectiveState( "sobj1", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.saveOrcs[2] = 2;
		elseif OBJECTIVES.state.saveOrcs[2] == 2 then
			if OBJECTIVES.state.getHeads[2] == 10 then
				SetObjectiveState( "sobj1", OBJECTIVE_COMPLETED );
				SetGameVar( "A2C2M1_orcs_saved", GetHeroCreatures( "Gottai", CREATURE_ORC_WARRIOR) );
				Play2DSound( "/Maps/Scenario/A2C2M1/C2M1_VO4_Gotai_01sound.xdb#xpointer(/Sound)" );
				BlockGame();
				sleep( GetSoundTimeInSleeps( "/Maps/Scenario/A2C2M1/C2M1_VO4_Gotai_01sound.xdb#xpointer(/Sound)" ) );
				UnblockGame();
				OBJECTIVES.state.saveOrcs[2] = 10;
			elseif 2*GetHeroCreatures("Gottai", CREATURE_ORC_WARRIOR) < STARTING_WARRIORS then
				SetObjectiveState("sobj1", OBJECTIVE_FAILED);
				SetGameVar("A2C2M1_orcs_saved", 0);
				OBJECTIVES.state.saveOrcs[2] = 11;
			end
		end
	end,
	
	bribeGoblins = function()
		if OBJECTIVES.state.bribeGoblins[2] == 1 then
			SetObjectiveState( "sobj3", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.bribeGoblins[2] = 2;
		elseif OBJECTIVES.state.bribeGoblins[2] == 3 then
			SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - GOBLINS_HELP_COST );
			SetObjectiveState( "sobj3", OBJECTIVE_COMPLETED ); 
			local delta = GOBLINS_HEADS_STOLEN_COUNT
			if ai_head < GOBLINS_HEADS_STOLEN_COUNT then
				delta = ai_head;
			end
			ai_head = ai_head - delta;
			head = head + delta;
			MessageBox( { PATH.."MsgBox_AIHeadsWasStolen.txt"; ai_heads_stolen = delta } );
			ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = delta }, "Gottai", PLAYER_1, 6 );
			CINEMATICS.bribeGoblins();
			RemoveObject("bandit");
			OBJECTIVES.state.bribeGoblins[2] = 10;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);

function printMonsters()
	for i=1, targetsArrayLength  do
		print( targetsArray[i].count, " monsters in stack ", targetsArray[i].name );
	end;
end;