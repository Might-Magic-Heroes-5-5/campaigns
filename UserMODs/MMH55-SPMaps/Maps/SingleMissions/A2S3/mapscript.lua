StartDialogScene("/DialogScenes/A2Single/SM3/S1/DialogScene.xdb#xpointer(/DialogScene)");
PlayerHero = "Agbeth"

EnemyHero = "Hangvul" 
EnemyHero1 = "Egil"
EnemyHero2 = "Brand"

EnemyHero3 = "Efion"

VoiceOver5Played = 0;
VoiceOver7Played = 0;
VoiceOver9Played = 0;
VoiceOver10Played = 0;
VoiceOver11Played = 0;
VoiceOver12Played = 0;
diff = 0
target = 0
c_object = "f_town"
once = 0
temp_hero = "Agbeth"
g_touch = 0;

DenyAIHeroFlee( PlayerHero, 1 );

function diff_setup()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 0.5;
		print ("easy");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 1;
		print ("normal");
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 2;
		print ("Hard");
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 3;
		print ("Impossible");
	end;
	sleep( 2 );
	enemy_heroes_setup();
	enemy_garrisons_setup();
	mission_start();
end;

function mission_start()	
	SetObjectiveState("obj4", OBJECTIVE_ACTIVE);

	BlockTownGarrisonForAI( "f_town", not nil );
	BlockTownGarrisonForAI( "f_town1", not nil );

	SetRegionBlocked("AI_portal_off", not nil, PLAYER_2);
	SetRegionBlocked("AI_block", not nil, PLAYER_2);
	
	EnableHeroAI( EnemyHero3, nil );
	SetObjectEnabled(EnemyHero3, nil);
	sleep( 1 );
	SetObjectEnabled("hut", nil);

	EnableHeroAI(EnemyHero, nil);
	EnableHeroAI(EnemyHero1, nil);

end;	
	
function main_ai_active()
	while 1 do
		if GetDate( MONTH ) == 5 then
			EnableHeroAI( EnemyHero, not nil );
			EnableHeroAI( EnemyHero1, not nil );
			break;
		elseif g_touch == 1 then
			break;
		end;
	sleep( 2 );
	end;
end;

function trigger_ai_active()
	g_touch = 1
	sleep( 1 );
	EnableHeroAI( EnemyHero, not nil );
	EnableHeroAI( EnemyHero1, not nil );
end;	
	
function mighty_generals()
	SetAIHeroAttractor( "d_town", EnemyHero, 0 );
	SetAIHeroAttractor( "d_town", EnemyHero1, 0 );
end;

----------------- Objective 1 -----------------

function t_objective1()
	OpenCircleFog( 89, 48, UNDERGROUND, 5, PLAYER_1 );
	SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
	SetObjectiveState( "obj3", OBJECTIVE_ACTIVE );
	SetObjectiveState( "sobj4", OBJECTIVE_ACTIVE );
	startThread( ride_start );	
end;	

----------------- Objective 2 -----------------

VoiceOver5Play = 0;
VoiceOver11Play = 0;

function t_objective2()
	while 1 do
		local townsCaptured = 0;
		
		if GetObjectOwner("f_town") == PLAYER_1 then
			townsCaptured = townsCaptured + 1;
		end;
		
		if GetObjectOwner("f_town1") == PLAYER_1 then
			townsCaptured = townsCaptured + 1;
		end;
		
		if townsCaptured == 2 and GetObjectiveState("obj2") == OBJECTIVE_ACTIVE then
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			if VoiceOver11Play == 0 then
				VoiceOver11Play = 1;
			end;
		end;
		if townsCaptured == 1 then
			if VoiceOver5Play == 0 then
				VoiceOver5Play = 1;
			end;
		end;
		if townsCaptured < 2 and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED then
			SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
		end;
		
		sleep( 2 );
	end;
end;

function VoiceOvers511()
	while 1 do
		if VoiceOver5Play == 1 and InProcess == 0 then
			InProcess = 1;
			snd = "/Maps/SingleMissions/A2S3/SM3_VO5_Agbeth_01sound.xdb#xpointer(/Sound)";
			Play2DSound( snd );
			local numSleeps = GetSoundTimeInSleeps( snd );
			sleep( numSleeps + 2 );
			InProcess = 0;
			VoiceOver5Play = 2;
		end;
		if VoiceOver11Play == 1 and InProcess == 0 then
			InProcess = 1;
			snd = "/Maps/SingleMissions/A2S3/SM3_VO11_Agbeth_01sound.xdb#xpointer(/Sound)";
			Play2DSound( snd );
			local numSleeps = GetSoundTimeInSleeps( snd );
			sleep( numSleeps + 2 );
			InProcess = 0;
			VoiceOver11Play = 2;
		end;
		sleep(2);
	end;
end;
startThread(VoiceOvers511);

----------------- Objective 3 -----------------

InProcess = 0;

function f_heroes()
	while 1 do
		if IsHeroAlive( EnemyHero ) == nil then
			if VoiceOver7Played < 1 then
				VoiceOver7Played = 1;
				StartDialogScene("/DialogScenes/A2Single/SM3/S2/DialogScene.xdb#xpointer(/DialogScene)", "VoiceOver7");
			end;
		end;
		if IsHeroAlive( EnemyHero1 ) == nil then
			if VoiceOver12Played < 1 then
				VoiceOver12Played = 1;
				startThread( VoiceOver12 );
			end;
		end;
	sleep( 2 );
	end;	
end;

function VoiceOver7()
	local snd = "/Maps/SingleMissions/A2S3/SM3_VO7_Agbeth_01sound.xdb#xpointer(/Sound)"
	local numSleeps = GetSoundTimeInSleeps(snd);
	while InProcess > 0 do sleep( 1 ); end		
	if 	InProcess == 0 then
		InProcess = 1;	
		Play2DSound( snd );
		sleep( numSleeps + 2 );
		InProcess = 0;
	end;		
end;

function VoiceOver12()	
	local snd = "/Maps/SingleMissions/A2S3/SM3_VO12_Agbeth_01sound.xdb#xpointer(/Sound)"
	local numSleeps = GetSoundTimeInSleeps(snd);
	while InProcess > 0 do sleep( 1 ); end	
	if InProcess == 0 then
		InProcess = 1;	
		Play2DSound( snd );
		sleep( numSleeps + 2 );
		InProcess = 0;
	end;
end;

function EnemyHeroesStatus()
	if IsHeroAlive( EnemyHero ) == nil and IsHeroAlive( EnemyHero1 ) == nil then
		SetObjectiveState( "obj3", OBJECTIVE_COMPLETED );
	end;
end;
	
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "EnemyHeroesStatus" );

----------------- Objective 4 -----------------

function d_heroes()
	while 1 do
		if IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState("obj4", OBJECTIVE_FAILED);
			sleep( 5 );
			Loose();
		end;
		sleep(2);
	end;
end;	

startThread(d_heroes);
-------------------Sub Objective 1-----------------------

Trigger (OBJECT_TOUCH_TRIGGER, "hut", "part1");
Trigger (OBJECT_TOUCH_TRIGGER, "DwarvenWarren1", "part1");
Trigger (OBJECT_TOUCH_TRIGGER, "DwarvenWarren2", "part1");
Trigger (OBJECT_TOUCH_TRIGGER, "m_post", "part1");

function part1( hero, objectName )
	x,y,level = GetObjectPosition(hero)
	if objectName == "DwarvenWarren1" or objectName == "DwarvenWarren2" or objectName == "hut" then	
		if GetObjectiveState("sobj1") == OBJECTIVE_UNKNOWN then	
			SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			Trigger(OBJECT_CAPTURE_TRIGGER, "DwarvenWarren1", "t_part2");
			Trigger(OBJECT_CAPTURE_TRIGGER, "DwarvenWarren2", "t_part2");
		end;
	end;
	if objectName == "m_post" or objectName == "hut" then	
		if GetObjectiveState("sobj3") == OBJECTIVE_UNKNOWN then
			SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
			Trigger(OBJECT_CAPTURE_TRIGGER, "m_post", "t_part2");
			print("Military post trigger placed - t_part2")
		end;
	end;
	if objectName == "hut" then	
		SetObjectiveState("sobj4", OBJECTIVE_COMPLETED);
		if GetObjectiveState("sobj2") == OBJECTIVE_UNKNOWN and once == 0 then
			once = 1
			OpenCircleFog(22, 47, GROUND, 5, PLAYER_1);
			sleep( 2 );
			MoveCamera(22, 47, GROUND, 25, 3.14/3, 0, 1, 1, 1);
			sleep( 5 );
			MessageBox("/Maps/SingleMissions/a2s3/d_present.txt");
			sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S3/SM3_VO8_Agbeth_01sound.1.xdb#xpointer(/Sound)" ) );
			MoveCamera(x, y, level, 25, 3.14/3, 0, 1, 1, 1);
		end;
	end;
end;	



function t_part2( oldOwner, newOwner, heroName, objectName )
	if objectName == "DwarvenWarren1" or objectName == "DwarvenWarren2" then	
		if GetObjectOwner("DwarvenWarren1") == PLAYER_1 and GetObjectOwner("DwarvenWarren2") == PLAYER_1 then
			if GetObjectiveState("sobj1") == OBJECTIVE_ACTIVE then
				SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
				H55_NewDayTrigger = 1;
				if VoiceOver9Played < 1 then
					VoiceOver9Played = 1;
					startThread( VoiceOver9 );
				end;
			end;
		end;
		if GetObjectOwner("DwarvenWarren1") == PLAYER_2 or GetObjectOwner("DwarvenWarren2") == PLAYER_2 then
			if GetObjectiveState("sobj1") == OBJECTIVE_UNKNOWN or GetObjectiveState("sobj1") == OBJECTIVE_COMPLETED then 
				SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			end;
		end;
	end;
	if objectName == "m_post" then 	
		if GetObjectOwner("m_post") == PLAYER_1 then
			if GetObjectiveState("sobj3") == OBJECTIVE_ACTIVE then
				SetObjectiveState("sobj3", OBJECTIVE_COMPLETED);
				startThread(sobjective3);
				if VoiceOver10Played < 1 then
					VoiceOver10Played = 1;
					startThread( VoiceOver10 );
				end;
			end;
		end;
		if GetObjectOwner("m_post") == PLAYER_2 then
			if GetObjectiveState("sobj3") == OBJECTIVE_UNKNOWN or GetObjectiveState("sobj3") == OBJECTIVE_COMPLETED then
				SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
				startThread(sobjective3);
			end;
		end;
	end;
end;	

function VoiceOver9()
	Play2DSound( "/Maps/SingleMissions/A2S3/SM3_VO9_Agbeth_01sound.xdb#xpointer(/Sound)" );
end;

function VoiceOver10()
	Play2DSound( "/Maps/SingleMissions/A2S3/SM3_VO10_Agbeth_01sound.xdb#xpointer(/Sound)" );
end;

function warren_reward()
	while 1 do
		if GetObjectiveState("sobj1") == OBJECTIVE_COMPLETED then 	
		s_exp = GetHeroStat(PlayerHero, STAT_EXPERIENCE);
		g_res = GetPlayerResource(PLAYER_1, GOLD);
		sleep( 2 );
			if GetDifficulty() == DIFFICULTY_EASY  then
				GiveExp(PlayerHero, (s_exp / 100) * 20);
				SetPlayerResource(PLAYER_1, GOLD, g_res + 2000);
			elseif GetDifficulty() == DIFFICULTY_NORMAL  then
				GiveExp(PlayerHero, (s_exp / 100) * 30);
				SetPlayerResource(PLAYER_1, GOLD, g_res + 4000);
			elseif GetDifficulty() == DIFFICULTY_HARD then
				GiveExp(PlayerHero, (s_exp / 100) * 40);
				SetPlayerResource(PLAYER_1, GOLD, g_res + 6000);
			elseif GetDifficulty() == DIFFICULTY_HEROIC then
				GiveExp(PlayerHero, (s_exp / 100) * 50);
				SetPlayerResource(PLAYER_1, GOLD, g_res + 8000);
			end;
			print("reward was given");
			break;
		end;
	sleep( 2 );
	end;
end;


-------------------Sub Objective 2-----------------------

Trigger ( REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", "con_quest" );

FirstTimePlayed = 0;
FirstTimeTouch = 0;
FirstTempHero = "";
HeroTouchWithArtifact = 0;

function con_quest( heroName )
	FirstTempHero = heroName;
	if heroName == PlayerHero then
		if HasArtefact( heroName, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
			HeroTouchWithArtifact = 1;
		end;
		if GetObjectiveState( "sobj2" ) == OBJECTIVE_UNKNOWN then	
			SetObjectiveState( "sobj2", OBJECTIVE_ACTIVE );
		end;
		Trigger ( REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", "d_question" );
		StartAdvMapDialog( 0, "FirstDemonMessage" );
		sleep( 8 );
		--d_question( heroName );
	elseif heroName ~= PlayerHero and GetObjectOwner( heroName ) == PLAYER_1 then
		MessageBox( "/Maps/SingleMissions/a2s3/d_message_notPlayerHero1.txt" );
	end;
end;	

function FirstDemonMessage()
	MessageBox( "/Maps/SingleMissions/a2s3/demon_q.txt" );
	if HasArtefact( FirstTempHero, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
		temp_hero = FirstTempHero;
		QuestionBox( "/Maps/SingleMissions/a2s3/d_question.txt", "dcon_activation" );
	end;
end;

function d_question( heroName )
	if heroName == PlayerHero then
		if HasArtefact( heroName, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
			temp_hero = heroName
			QuestionBox( "/Maps/SingleMissions/a2s3/d_question.txt", "dcon_activation" );
		elseif HasArtefact( heroName, ARTIFACT_TOME_OF_DESTRUCTION ) == nil and FirstTimeTouch == 1 then
			MessageBox( "/Maps/SingleMissions/a2s3/d_message.txt" );
		end;
		sleep( 1 );
		FirstTimeTouch = 1;
	elseif GetObjectOwner( heroName ) == PLAYER_1 and heroName ~= PlayerHero then
		MessageBox( "/Maps/SingleMissions/a2s3/d_message_notPlayerHero.txt" );
	end;
end;

function dcon_activation()
	if FirstTimePlayed == 0 then
		StartAdvMapDialog( 1, "con_activation" );
		FirstTimePlayed = 1;
	end;
end;

function con_activation()
	x,y,level = GetObjectPosition( temp_hero )
	if HasArtefact( temp_hero, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
		Trigger ( REGION_ENTER_AND_STOP_TRIGGER, "DemonQuest", nil );
		SetObjectiveState( "sobj2", OBJECTIVE_COMPLETED );
		Trigger ( OBJECT_TOUCH_TRIGGER, "touch_point", "q_convertion" );
		RemoveArtefact( temp_hero, ARTIFACT_TOME_OF_DESTRUCTION );
		PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", EnemyHero3 );
		sleep( 10 );
		RemoveObject( EnemyHero3 );
		print( EnemyHero3, " has been removed" );
		
			OpenCircleFog( 29, 46, GROUND, 5, PLAYER_1 );
			sleep( 2 );
			MoveCamera( 29, 46, GROUND, 25, 3.14/3, 0, 1, 1, 1 );
			sleep( 5 );
			MessageBox( "/Maps/SingleMissions/a2s3/altar_present.txt" );
			sleep( 15 );
			MoveCamera( x, y, level, 25, 3.14/3, 0, 1, 1, 1 );
	end;
end;	

function a_check()
	while 1 do
		heroes = GetPlayerHeroes(PLAYER_1)
		for i, hero in heroes do
			if IsObjectExists( "d_book" ) == nil and HasArtefact( hero ) == nil then
				if GetObjectiveState( "sobj2", OBJECTIVE_ACTIVE ) then
					SetObjectiveState( "sobj2", OBJECTIVE_FAILED );
					break;
				end;
			end;
		end;
	sleep( 2 );
	end;	
end;

conHero = ""

function q_convertion( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		conHero = heroName
		QuestionBox("/Maps/SingleMissions/a2s3/question_convertion.txt", "convertion");
	end;
end;

function convertion()
	c_creature = GetHeroCreatures( conHero, CREATURE_DEFENDER );
	a_creature = GetHeroCreatures( conHero, CREATURE_AXE_FIGHTER );
	if c_creature > 2 then
		s_creature = c_creature / 2
		if s_creature > 0 then
			RemoveHeroCreatures( conHero, CREATURE_DEFENDER, c_creature );
			sleep( 1 );
			AddHeroCreatures( conHero, CREATURE_INFERNAL_SUCCUBUS, c_creature / 2 );
		end;
	elseif c_creature < 2 then
		MessageBox( "/Maps/SingleMissions/a2s3/demon_answer.txt" );
	end;
	sleep( 1 );
	if a_creature > 2 then
		b_creature = a_creature / 2
		if b_creature > 0 then
			RemoveHeroCreatures( conHero, CREATURE_AXE_FIGHTER, a_creature );
			sleep( 1 );
			AddHeroCreatures( conHero, CREATURE_BALOR, a_creature / 2 );
		end;
	elseif c_creature < 2 then
		MessageBox( "/Maps/SingleMissions/a2s3/demon1_answer.txt" );
	end;
end;

function VoiceOverN()
	while 1 do	
		if HasArtefact( PlayerHero, ARTIFACT_TOME_OF_DESTRUCTION ) == not nil then
			Play2DSound( "/Maps/SingleMissions/A2S3/SM3_VO14_Agbeth_01sound.xdb#xpointer(/Sound)" );
			break;
		end;
	sleep( 1 );
	end;
end;

-------------------Sub Objective 3-----------------------

function sobjective3()
	while 1 do
		if GetObjectOwner("m_post") == PLAYER_1 then
			SetObjectiveState("sobj3", OBJECTIVE_COMPLETED);
			H55_NewDayTrigger = 1;
			break;
		end;
	sleep( 2 );
	end;	
end;

function H55_TriggerDaily()
	print("red_army_resource started");
	if GetObjectiveState("sobj1") == OBJECTIVE_COMPLETED then
		rwo = GetPlayerResource(PLAYER_2, WOOD);
		ror = GetPlayerResource(PLAYER_2, ORE);
		rsu = GetPlayerResource(PLAYER_2, SULFUR);
		rme = GetPlayerResource(PLAYER_2, MERCURY);
		rcr = GetPlayerResource(PLAYER_2, CRYSTAL);
		rge = GetPlayerResource(PLAYER_2, GEM);
		rgo = GetPlayerResource(PLAYER_2, GOLD);
		if rwo > 2 then
			SetPlayerResource(PLAYER_2, WOOD, rwo - 2);
		end;
		if ror > 2 then	
			SetPlayerResource(PLAYER_2, ORE, ror - 2);
		end;	
		if rsu > 2 then	
			SetPlayerResource(PLAYER_2, SULFUR, rsu - 2);
		end;
		if rme > 2 then	
			SetPlayerResource(PLAYER_2, MERCURY, rme - 2);
		end;
		if rcr > 2 then
			SetPlayerResource(PLAYER_2, CRYSTAL, rcr - 2);
		end;
		if rge > 2 then
			SetPlayerResource(PLAYER_2, GEM, rge - 2);
		end;
		if rgo > 2000 then
			SetPlayerResource(PLAYER_2, GOLD, rgo - 2000);
		end;	
	end;
	if GetObjectiveState("sobj3") == OBJECTIVE_COMPLETED then
		for creatureID = CREATURE_DEFENDER, CREATURE_STOUT_DEFENDER do 
			Tier1 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 14 then
				RemoveObjectCreatures("garrison", creatureID, Tier1);
				AddObjectCreatures("garrison", creatureID, Tier1 - 12);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_AXE_FIGHTER, CREATURE_AXE_THROWER do 
			Tier2 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 12 then
				RemoveObjectCreatures("garrison", creatureID, Tier2);
				AddObjectCreatures("garrison", creatureID, Tier2 - 10);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_BEAR_RIDER, CREATURE_BLACKBEAR_RIDER do 
			Tier3 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 10 then
				RemoveObjectCreatures("garrison", creatureID, Tier3);
				AddObjectCreatures("garrison", creatureID, Tier3 - 8);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_BROWLER, CREATURE_BERSERKER do 
			Tier4 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 8 then
				RemoveObjectCreatures("garrison", creatureID, Tier4);
				AddObjectCreatures("garrison", creatureID, Tier4 - 6);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_RUNE_MAGE, CREATURE_FLAME_MAGE do 
			Tier5 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 6 then
				RemoveObjectCreatures("garrison", creatureID, Tier5);
				AddObjectCreatures("garrison", creatureID, Tier5 - 4);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_THANE, CREATURE_WARLORD do 
			Tier6 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 4 then
				RemoveObjectCreatures("garrison", creatureID, Tier6);
				AddObjectCreatures("garrison", creatureID, Tier6 - 2);
			end;
		end;
		sleep( 1 );
		for creatureID = CREATURE_FIRE_DRAGON, CREATURE_MAGMA_DRAGON do 
			Tier7 = GetObjectCreatures("garrison", creatureID);
			if GetObjectCreatures("garrison", creatureID) > 2 then
				RemoveObjectCreatures("garrison", creatureID, Tier7);
				AddObjectCreatures("garrison", creatureID, Tier7 - 1);
			end;
		end;
	end;
end;	
	
-------------------Enemy Army Setup-----------------------

EnemyObjects = { "f_town", "f_town1", "garrison" }
EnemyHeroes = { EnemyHero, EnemyHero1 }

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
			CreatureSetUp = GetHeroCreatures( hero, creatureID );
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
			SetAIHeroAttractor("f_town", EnemyHero, 1);
			SetAIHeroAttractor("f_town", EnemyHero1, 2);
			SetAIHeroAttractor("f_town", EnemyHero2, 2);
		end;	
	end;
	if GetObjectOwner("f_town") == PLAYER_2 then
		SetAIHeroAttractor("f_town", EnemyHero, -1);
		SetAIHeroAttractor("f_town", EnemyHero1, -1);
		SetAIHeroAttractor("f_town", EnemyHero2, -1);
	end;
	if GetObjectOwner("f_town1") == PLAYER_1 then
		if 	GetObjectOwner("f_town") == PLAYER_2 then
			SetAIHeroAttractor("f_town1", EnemyHero, 1);
			SetAIHeroAttractor("f_town1", EnemyHero1, 2);
			SetAIHeroAttractor("f_town1", EnemyHero2, 2);
		end;
	end;
	if GetObjectOwner("f_town1") == PLAYER_2 then
		SetAIHeroAttractor("f_town1", EnemyHero, -1);
		SetAIHeroAttractor("f_town1", EnemyHero1, -1);
		SetAIHeroAttractor("f_town1", EnemyHero2, -1);
	end;
end;

Trigger(OBJECT_CAPTURE_TRIGGER, "f_town", "aggro");
Trigger(OBJECT_CAPTURE_TRIGGER, "f_town1", "aggro");

-------------------Raiders-----------------------

function ride_start()
	while 1 do
		if GetDate(DAY) == 15 then
			rider_deploy();
		end;
		if GetDate(DAY) == 29 then
			fortress_riders();
			sleep( 1 );
			rider_deploy();
		end;
		if GetDate(DAY) == 43 then
			fortress_riders();
			sleep( 1 );
			rider_deploy();
		end;
		if GetDate(DAY) == 57 then
			fortress_riders();
			sleep( 1 );
			rider_deploy();
		end;		
	sleep( 20 );
	end;
end;	

function fortress_riders()
	if IsHeroAlive("Brand") == nil then
		EnemyHero2 = "Svea"
	end;
	if IsHeroAlive("Svea") == nil then
		EnemyHero2 = "Helmar"
	end;
	if IsHeroAlive("Helmar") == nil then
		EnemyHero2 = "Karli"
	end;
	if IsHeroAlive("Karli") == nil then
		Trigger(PLAYER_REMOVE_HERO_TRIGGER, EnemyHero2, nil);
	end;
end;

function rider_deploy()
	if GetObjectOwner("f_town") == PLAYER_2 and GetObjectOwner("f_town1") == PLAYER_2 then
		DeployReserveHero(EnemyHero2, 17, 112, UNDERGROUND);
		sleep( 1 );
		ride_target();
	elseif GetObjectOwner("f_town") == PLAYER_1 and GetObjectOwner("f_town1") == PLAYER_2 then
		DeployReserveHero(EnemyHero2, 112, 114, UNDERGROUND);
		sleep( 1 );
		ride_target()	
	elseif GetObjectOwner("f_town1") == PLAYER_1 and GetObjectOwner("f_town") == PLAYER_2 then
		DeployReserveHero(EnemyHero2, 17, 112, UNDERGROUND);
		sleep( 1 );
		ride_target();
	end;
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, EnemyHero2, "fortress_riders");
end;

function ride_target()
	target = random(12) + 1
	sleep( 2 );
	if IsHeroAlive(EnemyHero2) == not nil then
		if target == 1 and GetObjectOwner("mine1") == PLAYER_1 then
			c_object = "mine1"
			sleep( 2 );
			SetAIHeroAttractor("mine1", EnemyHero2, 1);
		elseif target == 1 and GetObjectOwner("mine1") == PLAYER_2 then
			ride_target();
		end;
		if target == 2 and GetObjectOwner("mine2") == PLAYER_1 then
			c_object = "mine2"
			sleep( 2 );
			SetAIHeroAttractor("mine2", EnemyHero2, 1);
		elseif target == 2 and GetObjectOwner("mine2") == PLAYER_2 then
			ride_target();
		end;
		if target == 3 and GetObjectOwner("mine3") == PLAYER_1 then
			c_object = "mine3"
			sleep( 2 );
			SetAIHeroAttractor("mine3", EnemyHero2, 1);
		elseif target == 3 and GetObjectOwner("mine3") == PLAYER_2 then
			ride_target();
		end;
		if target == 4 and GetObjectOwner("mine4") == PLAYER_1 then
			c_object = "mine4"
			sleep( 2 );
			SetAIHeroAttractor("mine4", EnemyHero2, 1);
		elseif target == 4 and GetObjectOwner("mine4") == PLAYER_2 then 
			ride_target();
		end;
		if target == 5 and GetObjectOwner("mine5") == PLAYER_1 then
			c_object = "mine5"
			sleep( 2 );
			SetAIHeroAttractor("mine5", EnemyHero2, 1);
		elseif target == 5 and GetObjectOwner("mine5") == PLAYER_2 then
			ride_target();
		end;
		if target == 6 and GetObjectOwner("d_town") == PLAYER_1 then
			c_object = "d_town"
			sleep( 2 );
			SetAIHeroAttractor("d_town", EnemyHero2, 1);
		elseif target == 6 and GetObjectOwner("d_town") == PLAYER_2 then
			ride_target();
		end;
		if target == 7 and GetObjectOwner("tier1_dwelling") == PLAYER_1 then
			c_object = "tier1_dwelling"
			sleep( 2 );
			SetAIHeroAttractor("tier1_dwelling", EnemyHero2, 1);
		elseif target == 7 and GetObjectOwner("tier1_dwelling") == PLAYER_2 then
			ride_target();
		end;
		if target == 8 and GetObjectOwner("tier2_dwelling") == PLAYER_1 then
			c_object = "tier2_dwelling"
			sleep( 2 );
			SetAIHeroAttractor("tier2_dwelling", EnemyHero2, 1);
		elseif target == 8 and GetObjectOwner("tier2_dwelling") == PLAYER_2 then
			ride_target();
		end;
		if target == 9 and GetObjectOwner("tier3_dwelling") == PLAYER_1 then
			c_object = "tier3_dwelling"
			sleep( 2 );
			SetAIHeroAttractor("tier3_dwelling", EnemyHero2, 1);
		elseif target == 9 and GetObjectOwner("tier3_dwelling") == PLAYER_2 then
			ride_target();
		end;
		if target == 10 and GetObjectOwner("dm_post") == PLAYER_1 then
			c_object = "dm_post"
			sleep( 2 );
			SetAIHeroAttractor("dm_post", EnemyHero2, 1);
		elseif target == 10 and GetObjectOwner("dm_post") == PLAYER_2 then
			ride_target();
		end;
		if target == 11 and GetObjectOwner("mine6") == PLAYER_1 then
			c_object = "mine6"
			sleep( 2 );
			SetAIHeroAttractor("mine6", EnemyHero2, 1);
		elseif target == 10 and GetObjectOwner("mine6") == PLAYER_2 then
			ride_target();
		end;	
		if target == 12 and GetObjectOwner("mine7") == PLAYER_1 then
			c_object = "mine7"
			sleep( 2 );
			SetAIHeroAttractor("mine7", EnemyHero2, 1);
		elseif target == 10 and GetObjectOwner("mine7") == PLAYER_2 then
			ride_target();
		end;	
	end;
end;

function retarget()
	if GetObjectOwner(c_object) == PLAYER_2 then
		SetAIHeroAttractor(c_object, EnemyHero2, -1);
		sleep( 1 );
		ride_target();
	end;
end;

Trigger(OBJECT_CAPTURE_TRIGGER, "mine1", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine2", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine3", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine4", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine5", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine6", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "mine7", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "tier1_dwelling", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "tier2_dwelling", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "tier3_dwelling", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "dm_post", "retarget");
Trigger(OBJECT_CAPTURE_TRIGGER, "d_town", "retarget");

-------------------Win-----------------------

function t_win()
	while 1 do
		if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED then
			if GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
				SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
				sleep( 2 );
				Win();
				break;
			end;
		end;
	sleep( 2 );
	end;
end;


diff_setup();
t_objective1();
mighty_generals();
startThread( main_ai_active );
startThread( t_objective2 );
startThread( VoiceOverN );
startThread( f_heroes );
startThread( t_win );
Trigger(OBJECT_TOUCH_TRIGGER, "garrison", "trigger_ai_active");
--Trigger(OBJECT_CAPTURE_TRIGGER, "f_town", "t_objective2");
--Trigger(OBJECT_CAPTURE_TRIGGER, "f_town1", "t_objective2");