doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TOME_OF_DESTRUCTION,
};

temp_hero = "Agbeth"
function visitSeer( hero, objectName )
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		OBJECTIVES.visitSeer_visitor = hero;
		OBJECTIVES.state.visitSeer[2] = 3;
	end
end

function reachEnemyGarrison(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, "garrison", nil );
		OBJECTIVES.eventManager_enemyActivationDay = 1;
	end
end

function meetDemon( hero )
	FirstTempHero = hero;
	if GetObjectOwner( hero ) ~= PLAYER_1 then return end
	if hero ~= "Agbeth" and GetObjectOwner( hero ) == PLAYER_1 then
		MessageBox( "/Maps/SingleMissions/a2s3/d_message_notPlayerHero1.txt" );
	elseif hero == "Agbeth" then
		OBJECTIVES.state.findRelic[2] = 1;
		Trigger ( REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", "visitDemonAgain" );
	end
end

function visitDemonAgain( hero )
	if GetObjectOwner( hero ) ~= PLAYER_1 then return end
	if hero ~= "Agbeth" and GetObjectOwner( hero ) == PLAYER_1 then
		MessageBox( "/Maps/SingleMissions/a2s3/d_message_notPlayerHero.txt" );
	elseif hero == "Agbeth" then
		if HasArtefact( hero, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
			temp_hero = hero
			QuestionBox( "/Maps/SingleMissions/a2s3/d_question.txt", "GiveTomeToDemon" );
		elseif HasArtefact( hero, ARTIFACT_TOME_OF_DESTRUCTION ) == nil and FirstTimeTouch == 1 then
			MessageBox( "/Maps/SingleMissions/a2s3/d_message.txt" );
		end;
		FirstTimeTouch = 1;
	end
end

function GiveTomeToDemon()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", nil );
	OBJECTIVES.state.findRelic[2] = 3;
end

function visitSacrificialAltar( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		conHero = hero
		QuestionBox("/Maps/SingleMissions/a2s3/question_convertion.txt", "convertDwarves");
	end;
end;

function convertDwarves()
	local conversions = {
		{ 	 CREATURE_DEFENDER,	CREATURE_INFERNAL_SUCCUBUS,	 "/Maps/SingleMissions/a2s3/demon_answer.txt" },
		{ CREATURE_AXE_FIGHTER,				CREATURE_BALOR, "/Maps/SingleMissions/a2s3/demon1_answer.txt" },
	};

	for i, conversion in conversions do
		local sourceCreature = conversion[1];
		local targetCreature = conversion[2];
		local failureMessage = conversion[3];

		local sourceCount = GetHeroCreatures(conHero, sourceCreature);

		if sourceCount > 2 then
			local convertedCount = math.floor(sourceCount / 2);
			RemoveHeroCreatures(conHero, sourceCreature, sourceCount);
			sleep(10);
			AddHeroCreatures(conHero, targetCreature, convertedCount);
		else
			MessageBox(failureMessage);
		end
	end
end

function VO_WhenTomeOfDestructionIsFound()
	while 1 do	
		if HasArtefact( "Agbeth", ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
			Play2DSound( "/Maps/SingleMissions/A2S3/SM3_VO14_Agbeth_01sound.xdb#xpointer(/Sound)" );
			break
		end
		sleep( 20 );
	end
end

function enemy_garrisons_setup()
	for i,EnemyObject in EnemyObjects do	
		for creatureID = CREATURE_DEFENDER, CREATURE_MAGMA_DRAGON do 
			local CreatureSetUp = GetObjectCreatures( EnemyObject, creatureID );
			if GetObjectCreatures( EnemyObject, creatureID ) > 2 then
				RemoveObjectCreatures( EnemyObject, creatureID, CreatureSetUp );
				AddObjectCreatures( EnemyObject, creatureID, CreatureSetUp * diff );
			end;
		end;
	end;
end;

function enemy_heroes_setup()
	for i,hero in EnemyHeroes do	
		for creatureID = CREATURE_DEFENDER, CREATURE_MAGMA_DRAGON do 
			local CreatureSetUp = GetHeroCreatures( hero, creatureID );
			if GetHeroCreatures( hero, creatureID ) > 2 then
				RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
				AddHeroCreatures( hero, creatureID, CreatureSetUp * diff );
			end;
		end;
	end;
end;

-------------------AI Deffence-----------------------
function aggro()
	if GetObjectOwner("f_town") == PLAYER_1 then
		if 	GetObjectOwner("f_town1") == PLAYER_2 then
			SetAIHeroAttractor("f_town", "Hangvul", 1);
			SetAIHeroAttractor("f_town", "Egil", 2);
			SetAIHeroAttractor("f_town", EnemyHero2, 2);
		end;	
	end;
	if GetObjectOwner("f_town") == PLAYER_2 then
		SetAIHeroAttractor("f_town", "Hangvul", -1);
		SetAIHeroAttractor("f_town", "Egil", -1);
		SetAIHeroAttractor("f_town", EnemyHero2, -1);
	end;
	if GetObjectOwner("f_town1") == PLAYER_1 then
		if 	GetObjectOwner("f_town") == PLAYER_2 then
			SetAIHeroAttractor("f_town1", "Hangvul", 1);
			SetAIHeroAttractor("f_town1", "Egil", 2);
			SetAIHeroAttractor("f_town1", EnemyHero2, 2);
		end;
	end;
	if GetObjectOwner("f_town1") == PLAYER_2 then
		SetAIHeroAttractor("f_town1", "Hangvul", -1);
		SetAIHeroAttractor("f_town1", "Egil", -1);
		SetAIHeroAttractor("f_town1", EnemyHero2, -1);
	end;
end;

A2S3_RIDERS = { "Brand", "Svea", "Helmar", "Karli" };
A2S3_RIDERS.current = 1;
A2S3_ENEMY_TOWNS = {
	["f_town"]  = {  17, 112, 1 },
	["f_town1"] = { 112, 114, 1 },
}

EnemyHero2 = "Brand"
c_object = "f_town"
RIDE_TARGETS = { "mine1", "mine2", "mine3", "mine4","mine5", "d_town", "tier1_dwelling", "tier2_dwelling", "tier3_dwelling", "dm_post", "mine6", "mine7" };

function ride_target()
	if IsHeroAlive(EnemyHero2) == nil then
		return
	end
	
	local available = {};
	
	local index = 0;
	for i, target in RIDE_TARGETS do
		if GetObjectOwner(target) == PLAYER_1 then
			index = index + 1;
			available[index] = target;
		end
	end

	if index == 0 then
		c_object = "f_town";
		return
	end

	c_object = available[math.random(1,index)];
	SetAIHeroAttractor(c_object, EnemyHero2, 1);
end

function retarget()
	if GetObjectOwner(c_object) == PLAYER_2 then
		SetAIHeroAttractor(c_object, EnemyHero2, -1);
		sleep( 1 );
		ride_target();
	end; 
end

DIFFICULTY = {
	[0] = function()
		diff = 0.5;
		print ("normal");
	end,

	[1] = function()
		diff = 1;
		print ("hard");
	end,

	[2] = function()
		diff = 2;
		print ("heroic");
	end,

	[3] = function()
		diff = 3;
		print ("impossible");
	end,
}

CINEMATICS = {
	wait = 0,
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
		StartDialogScene("/DialogScenes/A2Single/SM3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	seizeFirstTown = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO5_Agbeth_01sound.xdb#xpointer(/Sound)";
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps( snd ) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	seizeSecondTown = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO11_Agbeth_01sound.xdb#xpointer(/Sound)";
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps( snd ) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	seizeWarrens = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO9_Agbeth_01sound.xdb#xpointer(/Sound)";
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps( snd ) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	seizePost = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO10_Agbeth_01sound.xdb#xpointer(/Sound)";
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps( snd ) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	defeatFirstGeneral = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;	
		StartDialogScene("/DialogScenes/A2Single/SM3/S2/DialogScene.xdb#xpointer(/DialogScene)");
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO7_Agbeth_01sound.xdb#xpointer(/Sound)"		
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps(snd) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	defeatSecondGeneral = function()
		repeat sleep(10) until CINEMATICS.wait == 0;
		CINEMATICS.wait = 1;
		local snd = "/Maps/SingleMissions/A2S3/SM3_VO12_Agbeth_01sound.xdb#xpointer(/Sound)"	
		Play2DSound( snd );
		sleep( GetSoundTimeInSleeps(snd) + 2 );
		CINEMATICS.wait = 0;
	end,
	
	meetDemon = function()
		CINEMATICS.playAndWait( 0 );
	end,
	
	giveTomeToDemon = function()
		CINEMATICS.playAndWait( 1 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		seizeTowns 		= { "obj2", 1 },
		defeatGenerals  = { "obj3", 1 },
		isAlive 		= { "obj4", 1 },
		seizeWarrens 	= { "sobj1", 1 },
		findRelic 		= { "sobj2", 0 },
		seizePost 		= { "sobj3", 1 },
		visitSeer 		= { "sobj4", 1 },
		eventManager    = { "_", 1 }, -- managers riders
		
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		for i, target in { "mine1", "mine2", "mine3", "mine4", "mine5", "mine6", "mine7", "tier1_dwelling", "tier2_dwelling", "tier3_dwelling", "dm_post", "d_town" } do
			Trigger(OBJECT_CAPTURE_TRIGGER, target, "retarget");
		end
		EnemyObjects = { "f_town", "f_town1", "garrison" };
		EnemyHeroes = { "Hangvul", "Egil" };
		CINEMATICS.intro();
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", "visitSeer");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", "meetDemon" );
		FirstTimeTouch = 0;
		conHero = ""
		Trigger(OBJECT_CAPTURE_TRIGGER, "f_town", "aggro");
		Trigger(OBJECT_CAPTURE_TRIGGER, "f_town1", "aggro");
		DIFFICULTY[GetDifficulty()]();
		enemy_heroes_setup();
		enemy_garrisons_setup();
		BlockTownGarrisonForAI( "f_town", not nil );
		BlockTownGarrisonForAI( "f_town1", not nil );
		SetRegionBlocked("AI_portal_off", not nil, PLAYER_2);	-- BLock AI from the portal to Effion
		SetRegionBlocked("AI_block", not nil, PLAYER_2);		-- Block AI from visiting the Seer
		EnableHeroAI("Efion", nil );
		SetObjectEnabled("Efion", nil);
		SetObjectEnabled("hut", nil);
		EnableHeroAI("Hangvul", nil);
		EnableHeroAI("Egil", nil);
		SetAIHeroAttractor( "d_town", "Hangvul", 0 );
		SetAIHeroAttractor( "d_town", "Egil", 0 );
		startThread( VO_WhenTomeOfDestructionIsFound );
		Trigger(OBJECT_TOUCH_TRIGGER, "garrison", "reachEnemyGarrison");
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

			if GetObjectiveState("obj4") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	seizeTowns_plays = { 0, 0 },
	seizeTowns = function()
		if OBJECTIVES.state.seizeTowns[2] == 1 then
			SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.seizeTowns[2] = 2;
		elseif OBJECTIVES.state.seizeTowns[2] == 2 then		
			if GetObjectOwner("f_town") == PLAYER_1 and GetObjectOwner("f_town1") == PLAYER_1 then
				SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.seizeTowns[2] = 3;
			end
			if (GetObjectOwner("f_town") == PLAYER_1 or GetObjectOwner("f_town1") == PLAYER_1) and OBJECTIVES.seizeTowns_plays[1] == 0 then
				startThread( CINEMATICS.seizeFirstTown );
				OBJECTIVES.seizeTowns_plays[1] = 1;
			end
			if GetObjectOwner("f_town") == PLAYER_1 and GetObjectOwner("f_town1") == PLAYER_1 and OBJECTIVES.seizeTowns_plays[2] == 0 then
				startThread( CINEMATICS.seizeSecondTown );
				OBJECTIVES.seizeTowns_plays[2] = 1;
			end
		elseif OBJECTIVES.state.seizeTowns[2] == 3 and (GetObjectOwner("f_town") ~= PLAYER_1 or GetObjectOwner("f_town1") ~= PLAYER_1) then
			SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.seizeTowns[2] = 2;
		end
	end,
	
	defeatGenerals_plays = { 0, 0 },
	defeatGenerals = function()
		if OBJECTIVES.state.defeatGenerals[2] == 1 then
			SetObjectiveState( "obj3", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.defeatGenerals[2] = 2;
		elseif OBJECTIVES.state.defeatGenerals[2] == 2 and IsHeroAlive( "Hangvul" ) == nil and IsHeroAlive( "Egil" ) == nil then
			SetObjectiveState( "obj3", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatGenerals[2] = 10;
		end
		
		if IsHeroAlive( "Hangvul" ) == nil and OBJECTIVES.defeatGenerals_plays[1] == 0 then
			CINEMATICS.defeatFirstGeneral();
			OBJECTIVES.defeatGenerals_plays[1] = 1;
		end
		if IsHeroAlive( "Egil" ) == nil and OBJECTIVES.defeatGenerals_plays[2] == 0 then
			CINEMATICS.defeatSecondGeneral();
			OBJECTIVES.defeatGenerals_plays[2] = 1;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Agbeth") == nil then
			SetObjectiveState("obj4", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	seizeWarrens_play = 0,
	seizeWarrens = function()
		if OBJECTIVES.state.seizeWarrens[2] == 1 and ( GetObjectOwner("DwarvenWarren1") == PLAYER_1 or GetObjectOwner("DwarvenWarren2") == PLAYER_1 or OBJECTIVES.state.visitSeer[2] == 10) then
			SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.seizeWarrens[2] = 2;
		elseif OBJECTIVES.state.seizeWarrens[2] == 2 and GetObjectOwner("DwarvenWarren1") == PLAYER_1 and GetObjectOwner("DwarvenWarren2") == PLAYER_1 then
			SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
			if OBJECTIVES.seizeWarrens_play == 0 then
				startThread( CINEMATICS.seizeWarrens );
				OBJECTIVES.seizeWarrens_play = 1;
			end
			OBJECTIVES.state.seizeWarrens[2] = 3;
		elseif OBJECTIVES.state.seizeWarrens[2] == 3 and ( GetObjectOwner("DwarvenWarren1") ~= PLAYER_1 or GetObjectOwner("DwarvenWarren2") ~= PLAYER_1 ) then 
			SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.seizeWarrens[2] = 2;
		end
	end,
	
	findRelic = function()
		if OBJECTIVES.state.findRelic[2] == 1 then
			CINEMATICS.meetDemon();
			SetObjectiveState( "sobj2", OBJECTIVE_ACTIVE );
			MessageBox( "/Maps/SingleMissions/a2s3/demon_q.txt" );
			visitDemonAgain( FirstTempHero );
			OBJECTIVES.state.findRelic[2] = 2;
		elseif OBJECTIVES.state.findRelic[2] == 3 then
			CINEMATICS.giveTomeToDemon();
			SetObjectiveState( "sobj2", OBJECTIVE_COMPLETED );
			local x, y, level = GetObjectPosition( temp_hero )
			BlockGame();
			Trigger( OBJECT_TOUCH_TRIGGER, "touch_point", "visitSacrificialAltar" );
			RemoveArtefact( temp_hero, ARTIFACT_TOME_OF_DESTRUCTION );
			PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", "Efion" );
			sleep( 25 );
			RemoveObject( "Efion" );
			sleep(50);
			OpenCircleFog( 29, 46, GROUND, 5, PLAYER_1 );
			MoveCamera( 29, 46, GROUND, 25, 3.14/3, 0, 1, 1, 1 );
			sleep( 80 );
			MessageBox( "/Maps/SingleMissions/a2s3/altar_present.txt" );
			sleep( 20 );
			MoveCamera( x, y, level, 25, 3.14/3, 0, 1, 1, 1 );
			UnblockGame();
			OBJECTIVES.state.findRelic[2] = 10;
		end
	end,
	
	seizePost_play = 0,
	seizePost = function()
		if OBJECTIVES.state.seizePost[2] == 1 and ( OBJECTIVES.state.visitSeer[2] == 10 or GetObjectOwner("m_post") == PLAYER_1 ) then
			SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.seizePost[2] = 2;
		elseif OBJECTIVES.state.seizePost[2] == 2 and GetObjectOwner("m_post") == PLAYER_1 then
			SetObjectiveState("sobj3", OBJECTIVE_COMPLETED);
			if OBJECTIVES.seizePost_play == 0 then
				startThread( CINEMATICS.seizePost );
				OBJECTIVES.seizePost_play = 1;
			end
			OBJECTIVES.state.seizePost[2] = 3;
		elseif OBJECTIVES.state.seizePost[2] == 3 and GetObjectOwner("m_post") ~= PLAYER_1 then
			SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.seizePost[2] = 2;
		end
	end,
		
	visitSeer_visitor = nil,
	visitSeer = function()
		if OBJECTIVES.state.visitSeer[2] == 1 then
			OpenCircleFog( 89, 48, UNDERGROUND, 5, PLAYER_1 );
			SetObjectiveState( "sobj4", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.visitSeer[2] = 2;
		elseif OBJECTIVES.state.visitSeer[2] == 3 then
			SetObjectiveState("sobj4", OBJECTIVE_COMPLETED);
			OpenCircleFog(22, 47, GROUND, 5, PLAYER_1);
			MoveCamera(22, 47, GROUND, 25, 3.14/3, 0, 1, 1, 1);
			sleep( 80 );
			MessageBox("/Maps/SingleMissions/a2s3/d_present.txt");
			sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S3/SM3_VO8_Agbeth_01sound.1.xdb#xpointer(/Sound)" ) );
			local x,y,level = GetObjectPosition(OBJECTIVES.visitSeer_visitor);
			MoveCamera(x, y, level, 25, 3.14/3, 0, 1, 1, 1);
			OBJECTIVES.state.visitSeer[2] = 10;
		end
	end,

	eventManager_enemyActivationDay = 113, -- Month 5 day 1
	eventManager_riderActivation = 15,
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			if OBJECTIVES.date >= OBJECTIVES.eventManager_riderActivation and IsHeroAlive(EnemyHero2) == nil then
				EnemyHero2 = A2S3_RIDERS[A2S3_RIDERS.current];
				for town, coords in A2S3_ENEMY_TOWNS do
					if GetObjectOwner(town) == PLAYER_1 then
						DeployReserveHero(EnemyHero2, coords[1], coords[2], coords[3]);
						ride_target();
						A2S3_RIDERS.current = math.mod(A2S3_RIDERS.current, 4) + 1;
						OBJECTIVES.eventManager_riderActivation = OBJECTIVES.date + 14;
						break;
					end
				end
			end
			
			if OBJECTIVES.state.seizeWarrens[2] == 3 then
				for i, res in {
					{ WOOD,     2 },
					{ ORE,      2 },
					{ SULFUR,   2 },
					{ MERCURY,  2 },
					{ CRYSTAL,  2 },
					{ GEM,      2 },
					{ GOLD,  2000 },
				} do
					local amount = GetPlayerResource(PLAYER_2, res[1]);
					if amount >= res[2] then
						SetPlayerResource(PLAYER_2, res[1], amount - res[2]);
					end
				end
			end
			if OBJECTIVES.state.seizePost[2] == 3 then
				local reductions = {
					{ { CREATURE_DEFENDER,     CREATURE_STONE_DEFENDER,   CREATURE_STOUT_DEFENDER }, 14, 12 },
					{ { CREATURE_AXE_FIGHTER, 	  CREATURE_AXE_THROWER,		   CREATURE_HARPOONER }, 12, 10 },
					{ { CREATURE_BEAR_RIDER,  CREATURE_BLACKBEAR_RIDER, CREATURE_WHITE_BEAR_RIDER }, 10,  8 },
					{ { CREATURE_BROWLER,			CREATURE_BERSERKER, 	CREATURE_BATTLE_RAGER },  8,  6 },
					{ { CREATURE_RUNE_MAGE,   	   CREATURE_FLAME_MAGE, 	CREATURE_FLAME_KEEPER },  6,  4 },
					{ { CREATURE_THANE,       		  CREATURE_WARLORD,    CREATURE_THUNDER_THANE },  4,  2 },
					{ { CREATURE_FIRE_DRAGON, 	 CREATURE_MAGMA_DRAGON, 	 CREATURE_LAVA_DRAGON },  2,  1 },
				};

				for tier, data in reductions do
					local creatures = data[1];
					local minimum   = data[2];
					local reduction = data[3];

					for i, creatureID in creatures do
						local count = GetObjectCreatures("garrison", creatureID);

						if count > minimum then
							RemoveObjectCreatures("garrison", creatureID, reduction);
						end
					end
					sleep(1);
				end
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
		
		if OBJECTIVES.date >= OBJECTIVES.eventManager_enemyActivationDay then
			EnableHeroAI( "Hangvul", not nil );
			EnableHeroAI( "Egil", not nil );
			OBJECTIVES.eventManager_enemyActivationDay = 9999999;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );

function a2s3_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		MakeHeroInteractWithObject("Agbeth", "m_post");
	elseif var == 2 then
		MakeHeroInteractWithObject("Agbeth", "DwarvenWarren1");
		MakeHeroInteractWithObject("Agbeth", "DwarvenWarren2");
	end
end