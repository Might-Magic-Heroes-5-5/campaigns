H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_TAROT_DECK,
ARTIFACT_ENDLESS_BAG_OF_GOLD

};

PlayerHero = "Gottai"
AIHero = "Kujin"
AIHero1 = "Hero1"
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
KUJIN_NORTH_X = 76;
KUJIN_NORTH_Y = 16;
KUJIN_WEST_X = 50;
KUJIN_WEST_Y = 12;

SCENE_GOBLINS_OBJECTIVE_ACTIVE = 1;

ADVMAPSCENE_STEAL_HEADS_ACTIVE_WEST = 2;
ADVMAPSCENE_STEAL_HEADS_ACTIVE_NORTH = 0;
ADVMAPSCENE_STEAL_HEADS_COMPLETE = 1;

VOICEOVER_MISSION_START = "/Maps/Scenario/A2C2M1/C2M1_VO2_Gotai_01sound.1.xdb#xpointer(/Sound)";
VOICEOVER_OBJECTIVE_KEEP_ORKS_COMPLETED = "/Maps/Scenario/A2C2M1/C2M1_VO4_Gotai_01sound.xdb#xpointer(/Sound)";

ClosestBuildingRadius = 7;

razedBuildingName = "hz";
PATH = "/Maps/Scenario/A2C2M1/";
HUTS = {"hut1","hut2","hut3","hut4","hut5","hut6","hut7","hut8"};

HUTSLength = table.length( HUTS );

targetsArrayLength = MONSTER_COUNT;
prev_ai_hero_x, prev_ai_hero_y = GetObjectPosition( AIHero1 );

SetRegionBlocked( "KujinGate1" , not nil, PLAYER_1 );
SetRegionBlocked( "KujinGate2" , not nil, PLAYER_1 );
SetRegionBlocked( "KujinGate1" , not nil, PLAYER_2 );
SetRegionBlocked( "KujinGate2" , not nil, PLAYER_2 );

print("MAIN: All constants are defined");
------------------------------------------------- Setup --------------------------------------------------

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function PlayStartVoiceover()
	BlockGame()
		Play2DSound( VOICEOVER_MISSION_START  );
		sleep( GetSoundTimeInSleeps( VOICEOVER_MISSION_START ) );
	UnblockGame();
end;

StartDialogScene( "/DialogScenes/A2C2/M1/S1/DialogScene.xdb#xpointer(/DialogScene)", "PlayStartVoiceover" );


targetsArray = {};
for index=1, MONSTER_COUNT do
	targetsArray[ index ] = {};
	targetsArray[ index ].name = "m"..index;
	targetsArray[ index ].count = GetObjectCreaturesCount("m"..index);
	print( targetsArray[ index ].count.." is in stack "..targetsArray[ index ].name );
end;

function startSetArtifactsInit()
    InitAllSetArtifacts( "A2C2M1", PlayerHero );
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


function printMonsters()
	for i=1, targetsArrayLength  do
		print( targetsArray[i].count, " monsters in stack ", targetsArray[i].name );
	end;
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


function diff_setup()
	if GetDifficulty() == DIFFICULTY_EASY then
		ClosestBuildingRadius = 7; --Griffins 12, Crossbowmans 65, Vindicators 50
		diff = 1;
		print ("easy");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 8); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 8); --Griffins
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 35); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 20); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 20); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 20); --Vindicators
		ClosestBuildingRadius = 9;
		diff = 1;
		print ("normal");
	elseif GetDifficulty() == DIFFICULTY_HARD then
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 18); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 18); --Griffins
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 75); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 70); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 70); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 70); --Vindicators
		diff = 2;
		ClosestBuildingRadius = 11;
		print ("Hard");
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		AddObjectCreatures("m21", CREATURE_BATTLE_GRIFFIN, 28); --Griffins
		AddObjectCreatures("m24", CREATURE_BATTLE_GRIFFIN, 28); --Griffins
		AddObjectCreatures("m12", CREATURE_LONGBOWMAN, 135); --Crossbowmans
		AddObjectCreatures("m19", CREATURE_VINDICATOR, 100); --Vindicators
		AddObjectCreatures("m16", CREATURE_VINDICATOR, 100); --Vindicators
		AddObjectCreatures("m15", CREATURE_VINDICATOR, 100); --Vindicators
		diff = 3;
		ClosestBuildingRadius = 13;
		print ("Impossible");
	end;
	-- Max Warrior = 110;  Centaur  = 180; Goblins = 224
	-- Base Warrior = 60; Centaur = 80; Goblins = 120
	local coeff = 0.5/diff; -- (Easy - 1, Normal - 0.5, Hard - 0.25, Easy - 0.13)
	AddHeroCreatures( PlayerHero, CREATURE_GOBLIN, 100 * coeff);
	AddHeroCreatures( PlayerHero, CREATURE_CENTAUR, 100 * coeff);
	AddHeroCreatures( PlayerHero, CREATURE_ORC_WARRIOR, 50 * coeff);
	sleep(1);
	tier3c = GetHeroCreatures(PlayerHero, CREATURE_ORC_WARRIOR);
end;

function mission_start()
	SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
	SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
	--SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
	--SetObjectiveState("sobj2", OBJECTIVE_ACTIVE);
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
	EnableHeroAI(AIHero, nil);
	
	SetRegionBlocked( "sobj2_region", not nil, PLAYER_2 );
	SetPlayerResource(PLAYER_1, ORE, 0);
	SetPlayerResource(PLAYER_1, WOOD, 0);
	SetPlayerResource(PLAYER_1, MERCURY, 0);
	SetPlayerResource(PLAYER_1, SULFUR, 0);
	SetPlayerResource(PLAYER_1, CRYSTAL, 0);
	SetPlayerResource(PLAYER_1, GEM, 0);
	SetPlayerResource(PLAYER_1, GOLD, 0);
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes(PLAYER_3, 1);
end;

---------------------------------------------- Creature count --------------------------------------------------

--headsMonsters = {}

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
	cur_ai_hero_x, cur_ai_hero_y = GetObjectPosition( AIHero1 );
	if cur_ai_hero_x == prev_ai_hero_x and cur_ai_hero_y == prev_ai_hero_y then
		print("AI is blocked!")
		AddHeroCreatures( AIHero1, CREATURE_ORC_WARRIOR, 50 );
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
		SetAIHeroAttractor( targetName, AIHero1, 1 );
		print("Now AI target is ", targetName );
		while IsObjectExists( targetName ) == not nil do sleep(1); end;
		print("TargetSearch: Object ",targetName," does not exist!");
		print("TargetSearch: targetsArrayLength=",targetsArrayLength );	
		sleep(5);
		print("TargetSearch: (sleep)targetsArrayLength=",targetsArrayLength );	
	until targetsArrayLength == 0 or ai_head >= 1000;
	if ai_head >= 1000 then 
		return
	end;
	print("TargetSearch: All monsters are destroyed or rival has collected more than 1000 heads");	
	if IsObjectExists("mpost") then
		SetAIHeroAttractor( "mpost", AIHero1, 1 );
		print("TargetSearch: Now rival target is castle");
		while isCastleDestroyed == 0 do sleep(5); end;
		print("TargetSearch: Castle is destroyed");
	end;
	if HUTSLength ~= 0 then
		repeat
			HutIndex = random( HUTSLength ) + 1;
			HutName = HUTS[ HutIndex ];
			SetAIHeroAttractor( HutName , AIHero1, 1 );
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
	while IsHeroAlive( AIHero1 )==not nil and ai_head < 1000 do
		while GetBuildingClosestThanRadius( AIHero1, HUTS, HUTSLength, ClosestBuildingRadius ) == nil do sleep(5); end;
		closestBuilding = GetBuildingClosestThanRadius( AIHero1, HUTS, HUTSLength, ClosestBuildingRadius );
		print("DestroyClosestBuildings: AI senses the building ", closestBuilding ," near him");
		EnableHeroAI( AIHero1, nil );
		print("DestroyClosestBuildings: AI for enemy hero is blocked");
		local x,y,floor = GetObjectPosition( closestBuilding );
		
		while IsBuildingExist( closestBuilding ) == not nil do
			while GetCurrentPlayer() ~= PLAYER_2 do sleep(1); end;
			if IsBuildingExist( closestBuilding ) == not nil then
				EnableHeroAI( AIHero1, not nil );
				if CanMoveHero( AIHero1, x, y, floor ) then
					MoveHero( AIHero1, x, y, floor );
				else
					print("DestroyClosestBuildings: building ", closestBuilding, " is currently unavailable");
				end;
			else
				break;
			end;
			while GetCurrentPlayer() == PLAYER_2 do sleep(1); end;
			sleep(1);
		end;
		MoveHero( AIHero1, GetObjectPosition(AIHero1) );-- Необходимо, чтобы АИ не тупил, пытаясь бежать в тайл разрушенного здания
		EnableHeroAI( AIHero1, not nil );
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

function GetHeadMonsterCount( monsterName )
	for index, monster in targetsArray do
		if monster.name == monsterName then
			return monster.count
		end
	end
	return 0
end

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
	while ai_head < 1000 do sleep(2); end;
	--while ai_head < 200 do sleep(5); end;
	--print("AI has collected 1000 heads");
	--while GetCurrentPlayer()~=PLAYER_1 do sleep(5); end;
	--print("messageBox");
	--MessageBox( {"/Maps/Scenario/A2C2M1/ai_heads_m.txt"; ai_heads_collected=ai_head, gotai_heads_collected=head } );
	print("Rival has collected more than 1000 heads");
	while GetCurrentPlayer()~=PLAYER_1 do sleep(1); end;
	sleep(5);
	MessageBox( PATH.."MsgBox_RivalHasCollectedHeads.txt" );	
	KUJIN_X, KUJIN_Y = GetObjectPosition( AIHero );
	while 1 do
		while GetCurrentPlayer()~=PLAYER_2 do 
			sleep(1); 
		end;
		EnableHeroAI( AIHero1, nil );
		if CanMoveHero( AIHero1, KUJIN_X, KUJIN_Y, GROUND ) == not nil then
			EnableHeroAI( AIHero1, not nil );
			print("MoveRivalToStart: AI has moved to Kujin");
			MoveHero( AIHero1, KUJIN_X, KUJIN_Y, GROUND );
		else
			print("MoveRivalToStart: Path is blocked!");
		end;
		while GetCurrentPlayer()==PLAYER_2 do 
			sleep(1); 
			if ai_head < 1000  then
				EnableHeroAI( AIHero1, not nil );
				local x, y, f = GetObjectPosition( AIHero1 );
				MoveHero( AIHero1, x, y, f);
				startThread( MoveRivalToStart );
				return
			end;
		end;
		sleep(1);
	end;
	print("MoveRivalToStart: WARNING!!!");
end;

---------------------------------- Objective 1 ----------------------------

function IsGotaiCollectAllHeads()
	--while head < 1000 do sleep(1); end;
	for i=1, 5 do
		while head < 200*i do sleep(5); end;
		print("collected more than ", 200*i, " heads");
		--SetObjectiveProgress("obj1", i, PLAYER_1);
		sleep(5);
		MessageBox( { "/Maps/Scenario/A2C2M1/heads_message.txt"; txt_head = head, ai_heads = ai_head } );
	end;
	MessageBox( PATH.."MsgBox_TimeToReturnToStart.txt" );	
end;

function WinCheck( heroName )
	print( heroName.." has entered in the finish region" );
	if heroName == PlayerHero then
		if head >=1000 then
			StartDialogScene("/DialogScenes/A2C2/M1/S2/DialogScene.xdb#xpointer(/DialogScene)", "WinMission");
		else
			print("Gotai does not have enough heads!");
			MessageBox("/Maps/Scenario/A2C2M1/MsgBox_NotEnoghHeads.txt");
		end;
	else
		if ai_head >=1000 then
			MessageBox("/Maps/Scenario/A2C2M1/MsgBox_RivalWasFaster.txt");
			sleep(1);
			Loose();
		end;
	end;
end;

function WinMission()
	if GetObjectiveState( "sobj1" ) ~= OBJECTIVE_FAILED then
		SetObjectiveState( "sobj1", OBJECTIVE_COMPLETED );
		SetGameVar( "A2C2M1_orcs_saved", GetHeroCreatures( PlayerHero, CREATURE_ORC_WARRIOR) );
		Play2DSound( VOICEOVER_OBJECTIVE_KEEP_ORKS_COMPLETED );
		BlockGame();
		sleep( GetSoundTimeInSleeps( VOICEOVER_OBJECTIVE_KEEP_ORKS_COMPLETED ) );
		UnblockGame();
	end;
	SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
	SaveHeroAllSetArtifactsEquipped( PlayerHero, "A2C2M1" );
	sleep(5);
	Win(PLAYER_1);
end;

------------------------------------------ Objective 2 ------------------------------------------

function objective2()
	while 1 do
		if IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState("obj2", OBJECTIVE_FAILED);
			Loose();
			break;
		elseif GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			break;
		end;
	sleep( 3 );
	end;
end;

------------------------------------------ Sub Objective 1 ------------------------------------------


------------------------------------------ Sub Objective 2 ------------------------------------------

function RemoveIfExists( objectName )
	if IsObjectExists( objectName ) == not nil then
		RemoveObject( objectName  );
	else
		print("RemoveIfExists: object ", objectName, " does not exist and can not be removed");
	end;
end;


------------------------------------------ Sub Objective 2 ------------------------------------------

function sobjective3( hero )
	if hero == PlayerHero then
		QuestionBox( { PATH.."MsgBox_WantPayForGoblinsHelp.txt"; helpCost=GOBLINS_HELP_COST, headsStolen=GOBLINS_HEADS_STOLEN_COUNT }, "WantPay", "DontPay" );
	end;
end;

function DontPay()
	print("empty");
end;

function WantPay()
	if GetPlayerResource(PLAYER_1, GOLD) >= GOBLINS_HELP_COST  then 
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - GOBLINS_HELP_COST );
		if GetObjectiveState("sobj3") == OBJECTIVE_UNKNOWN then
			SetObjectiveState( "sobj3", OBJECTIVE_ACTIVE );
			sleep(1);
		end;
		SetObjectiveState( "sobj3", OBJECTIVE_COMPLETED ); 
		if ai_head >= GOBLINS_HEADS_STOLEN_COUNT then
			ai_head = ai_head - GOBLINS_HEADS_STOLEN_COUNT;
			head = head + GOBLINS_HEADS_STOLEN_COUNT;
			MessageBox( { PATH.."MsgBox_AIHeadsWasStolen.txt"; ai_heads_stolen = GOBLINS_HEADS_STOLEN_COUNT } );
			ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = GOBLINS_HEADS_STOLEN_COUNT }, PlayerHero, PLAYER_1, 4 );
		elseif ai_head < GOBLINS_HEADS_STOLEN_COUNT then
			MessageBox( { PATH.."MsgBox_AIHeadsWasStolen.txt"; ai_heads_stolen = ai_head } );
			ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = ai_head }, PlayerHero, PLAYER_1, 4 );
			ai_head = 0;
			head = head + ai_head;
		end;
		StartAdvMapDialog( ADVMAPSCENE_STEAL_HEADS_COMPLETE, "RemoveGoblin" );
	else
		MessageBox( {PATH.."MsgBox_NotEnoughMoney.txt"; money = GOBLINS_HELP_COST } );
	end;
end;

function RemoveGoblin()
	RemoveObject("bandit");
end;


function GetObjectCreatureNumber( objectName )
	for CreatureID=1, CREATURES_COUNT do
		if GetObjectCreatures( objectName, CreatureID ) > 0 then
			local count = GetObjectCreatures( objectName, CreatureID );
			return count;
		end;
	end;
end;


function IsTargetTouched( heroName, objectName )
	print("IsTargetTouched: Object ", objectName, " is touched");
	local collected_heads=GetHeadsFromArray( objectName );
	removeTargetFromArray( objectName );
	if heroName == PlayerHero then
		head = head  + collected_heads;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = collected_heads }, PlayerHero, PLAYER_1, 4 );
	else
		ai_head = ai_head  + collected_heads;
		print("IsTargetTouched: AI has collected ", ai_head ," heads" );
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = collected_heads }, AIHero1, PLAYER_1, 4 );
	end;	
end;

function IsBuildingTouched( heroName, objectName )
	print("IsBuildingTouched started");
	RazeBuildingWithEffects( objectName );
	razedBuildingName = objectName;
	if objectName == "mpost" then
		isCastleDestroyed = 1;
		castleHeadsCount = random(50) + 270-GetDifficulty()*10;
		if heroName == PlayerHero then
			head = head + castleHeadsCount;
		else
			ai_head = ai_head + castleHeadsCount;
			print("IsBuildingTouched: AI has collected ", ai_head ," heads" );
		end;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = castleHeadsCount }, heroName, PLAYER_1, 4 );	
	else
		removeHutFromArray( objectName );
		hutHeadsCount = random(20) + 150-GetDifficulty()*25;
		if heroName == PlayerHero then
			head = head + hutHeadsCount;
		else
			ai_head = ai_head + hutHeadsCount ;
			print("IsBuildingTouched: AI has collected ", ai_head ," heads" );
		end;
		ShowFlyingSign( { "/Maps/Scenario/A2C2M1/show_heads_count.txt"; heads_collected = hutHeadsCount }, heroName, PLAYER_1, 4 );
	end;
end;

Trigger( OBJECT_TOUCH_TRIGGER, "bandit", "sobjective3" );

for i=1, MONSTER_COUNT do
	Trigger( OBJECT_TOUCH_TRIGGER, "m"..i, "IsTargetTouched");
end;
for i=1, 8 do
	Trigger( OBJECT_TOUCH_TRIGGER, "hut"..i, "IsBuildingTouched");
end;
Trigger( OBJECT_TOUCH_TRIGGER, "mpost", "IsBuildingTouched");

function ReturnKujin()
	SetObjectPosition( "Kujin", KUJIN_X, KUJIN_Y, GROUND );
	SetObjectRotation( "Kujin", 180 );
	SetObjectiveState( "sobj3", OBJECTIVE_ACTIVE );
end;

function PlaySObjectiveSceneWest( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceWest", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceNorth", nil );
		SetObjectPosition( "Kujin", KUJIN_WEST_X, KUJIN_WEST_Y, GROUND );
		SetObjectRotation( "Kujin", 250 );
		SetObjectRotation( heroName, 90 );
		sleep(1);
		StartAdvMapDialog( ADVMAPSCENE_STEAL_HEADS_ACTIVE_WEST, "ReturnKujin" );
	end;
end;

function PlaySObjectiveSceneNorth( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceWest", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceNorth", nil );
		SetObjectRotation( "Kujin", 160 );
		SetObjectPosition( "Kujin", KUJIN_NORTH_X, KUJIN_NORTH_Y, GROUND );
		SetObjectRotation( heroName, -30 );
		sleep(1);
		StartAdvMapDialog( ADVMAPSCENE_STEAL_HEADS_ACTIVE_NORTH, "ReturnKujin" );
	end;
end;
 
function IsFirstCombatFinished( combatIndex )
    if GetSavedCombatResult( combatIndex ) ~= COMBAT_RESULT_NONE then
		if GetSavedCombatArmyPlayer( combatIndex, 1 ) == PLAYER_1 then
			Trigger( COMBAT_RESULTS_TRIGGER, nil );
			startThread( SetObjectiveSave3TierCreatures_Active );
		end;
	end;
end;

function SetObjectiveSave3TierCreatures_Active()
	SetObjectiveState( "sobj1", OBJECTIVE_ACTIVE );
	sleep(1);
	while 2*GetHeroCreatures(PlayerHero, CREATURE_ORC_WARRIOR) >= tier3c  do sleep(1); end;
	SetObjectiveState("sobj1", OBJECTIVE_FAILED);
	SetGameVar("A2C2M1_orcs_saved", 0);	
end;


mission_start();
startThread( objective2 );
startThread( diff_setup );
startThread( startSetArtifactsInit );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "finish", "WinCheck" );

Trigger( COMBAT_RESULTS_TRIGGER, "IsFirstCombatFinished" );

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceWest", "PlaySObjectiveSceneWest" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "GateEntranceNorth", "PlaySObjectiveSceneNorth" );

startThread( MoveRivalToStart );
startThread( TargetSearch );
startThread( IsGotaiCollectAllHeads );
startThread( DestroyClosestBuildings );
startThread( ShowRivalHeadsMessageboxes );
H55_NewDayTrigger = 1;
--Trigger ( NEW_DAY_TRIGGER, "UpdateHeadsMonsters" );