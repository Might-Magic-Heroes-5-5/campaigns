doFile("/scripts/A2_Zehir/A2_Zehir.lua");
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function GiveTransferrableArtifacts()
	InitAllSetArtifacts( "A2C3M2", "Zehir", "Duncan", "Freyda" );
    LoadHeroAllSetArtifacts( "Zehir", "A2C3M1" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Zehir");
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};
PATH = "Maps/Scenario/A2C3M2/"; -- Путь к файлам карты
VOICEOVER_ZEHIR_FOUND_SECOND_CLERIC   = "/Maps/Scenario/A2C3M2/C3M2_VO3_Zehir_01sound.xdb#xpointer(/Sound)";
VOICEOVER_ZEHIR_FOUND_THIRD_CLERIC    = "/Maps/Scenario/A2C3M2/C3M2_VO10_Zehir_01sound.xdb#xpointer(/Sound)";
VOICEOVER_MAIN_INFERNO_TOWN_DESTROYED = "/Maps/Scenario/A2C3M2/C3M2_VO6_Duncan_01sound.xdb#xpointer(/Sound)";
VOICEOVER_INFERNO_HERO_DEFEATED       = "/Maps/Scenario/A2C3M2/C3M2_VO7_Freyda_01sound.xdb#xpointer(/Sound)";
-- MessageBox( PATH.."MsgBox_ZehirGiveGraalFreydaAndDuncan.txt" ); -- unusued message

EFFECT_ARMAGEDDON = "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)";
EFFECT_HOLY_WORD = "/Effects/_(Effect)/Spells/HolyWord.xdb#xpointer(/Effect)";
EFFECT_INFERNO_GATING = "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)"
SOUND_EFFECT_HOLY_WORD = "/Sounds/_(Sound)/Spells/HolyWord_______255.xdb#xpointer(/Sound)";
SOUND_EFFECT_GATING = "/Sounds/_(Sound)/Spells/SummonOverEnd.xdb#xpointer(/Sound)";
isOkPressed  = 0;

function ShowReplaceToDeamonCreature( originalCreatureName, deamonCreatureType, quantity )
	BlockGame();
	sleep(50);
	local x,y,floor = GetObjectPosition( originalCreatureName );
	rotation = 0;
	if originalCreatureName == "demon_deamon" then rotation = 180;
	elseif originalCreatureName=="demon_balor" then rotation = 135;
	elseif originalCreatureName=="demon_devil" then rotation = 315;
	end
	OpenCircleFog( x, y, floor, 5, PLAYER_1 );
	MoveCamera( x, y, floor, 40, 1, rotation/57, 0, 0, 1 );
	sleep(15);
	PlayVisualEffect( EFFECT_INFERNO_GATING, "", "tag", x+0.5, y+0.5, floor );
	Play2DSound( SOUND_EFFECT_GATING );
	sleep( GetSoundTimeInSleeps( SOUND_EFFECT_GATING ) / 2.1 );
	RemoveObject( originalCreatureName );
	sleep(2);
	CreateMonster( "deamon", deamonCreatureType, quantity, x, y, floor, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, rotation );
	UnblockGame();
end

function IsClericJoined( hero, object )
	H55c_Message.show( PATH.."MsgBox_ClericGreetings.txt" );
	
	if OBJECTIVES.getClerics_count == 1 then
		Play2DSound( VOICEOVER_ZEHIR_FOUND_SECOND_CLERIC );
	elseif OBJECTIVES.getClerics_count == 2 then
		Play2DSound( VOICEOVER_ZEHIR_FOUND_THIRD_CLERIC );
	end

	if object == "cleric" then
		SetClericOnRitePosition( CREATURE_CLERIC, hero, object );
	elseif object == "priest" then
		SetClericOnRitePosition( CREATURE_PRIEST, hero, object );
	end
end

function SetClericOnRitePosition( clericType, heroName, objectName )
	SetRegionBlocked( clericType.."Region", nil);
	local RITE_X, RITE_Y = GetObjectPosition( "rite_selection" ); -- координаты места ритуала
	OpenCircleFog( RITE_X, RITE_Y, GROUND, 8, PLAYER_1 );	
	MoveCamera( RITE_X, RITE_Y, GROUND, 30, 1, 4, 0, 0, 1 );
	RemoveObject( objectName );
	sleep(20);
	if clericType == CREATURE_ZEALOT then angle = 225;
	elseif clericType == CREATURE_CLERIC then angle = 135;
	elseif clericType == CREATURE_PRIEST then angle = 45;
	end
	local x,y = RegionToPoint( clericType.."Region" );
	local clericName = "cleric"..clericType;
	CreateMonster( clericName, clericType, 1, x,y, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, angle );
	sleep(10);
	SetObjectEnabled( clericName, nil );
	SetDisabledObjectMode( clericName, DISABLED_INTERACT );
	Trigger( OBJECT_TOUCH_TRIGGER, clericName, "IsClericTouched");
	PlayObjectAnimation( clericName, "happy" ,ONESHOT );
	sleep(100);
	local hero_x, hero_y, hero_floor = GetObjectPosition( heroName );
	MoveCamera( hero_x, hero_y, hero_floor, 70, 1, 0, 0, 0, 1 );
	OBJECTIVES.getClerics_count = OBJECTIVES.getClerics_count + 1;
end

function IsClericTouched( hero )
	if hero ~= "Zehir" then
		MessageBox( PATH.."MsgBox_ClericNeedGotai.txt" );
	elseif OBJECTIVES.getClerics_count < 3 then
		MessageBox( PATH.."MsgBox_ClericAnswer.txt" );
	elseif HasArtefact( hero, ARTIFACT_GRAAL ) == nil then
		MessageBox( PATH.."MsgBox_ClericRequestArtifact.txt" );
	elseif GetObjectiveState( "prim3_MoveTown" ) ~= OBJECTIVE_COMPLETED then
		MessageBox( PATH.."MsgBox_ClericNeedTown.txt" );
	else
		MessageBox( PATH.."MsgBox_ClericAllConditionsCompleted.txt");
	end
end

function IsAllRequiredElementsCollected( heroName )
	if heroName ~= "Zehir" then
		MessageBox( PATH.."MsgBox_HeroIsNotZehir.txt" );
	elseif HasArtefact( "Zehir", ARTIFACT_GRAAL ) == nil then
		MessageBox( PATH.."MsgBox_ZehirHaveNotGraal.txt" );
	elseif GetObjectiveState( "prim2_CollectAllClerics" ) ~= OBJECTIVE_COMPLETED then
		MessageBox( PATH.."MsgBox_NotAllOBJECTIVES.getClerics_count.txt" );
	elseif GetObjectiveState( "prim3_MoveTown" ) ~= OBJECTIVE_COMPLETED then
		MessageBox( PATH.."MsgBox_TownNotMoved.txt" );
	elseif OBJECTIVES.state.performRite[2] == 2 and IsObjectExists( "InfernoBoss" ) ~= nil then
		OBJECTIVES.state.performRite[2] = 3;
	elseif IsObjectExists( "InfernoBoss" ) ~= nil then
		MessageBox( PATH.."InfernoBossNotDefeated.txt" );
	else
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "rite_area", nil );
		OBJECTIVES.state.performRite[2] = 6;
	end
end

function PlayInfernoBossAnimations()
	while IsObjectExists( "InfernoBoss" ) ~= nil do
		PlayObjectAnimation( "InfernoBoss", "stir00", ONESHOT );
		sleep(150);
		if IsObjectExists( "InfernoBoss" ) ~= nil then
			PlayObjectAnimation( "InfernoBoss", "happy", ONESHOT );
		end
		sleep(150);
	end
end

function IsPlayerHeroHasArtifact( player, artifact )
	currentPlayerHeroes = GetPlayerHeroes( player );
	for i=0, table.length( currentPlayerHeroes )-1 do
		if HasArtefact( currentPlayerHeroes[i], artifact ) == not nil then
			return not nil;
		end
	end
	return nil;
end

function SetupDemonHero()
	GiveExp("Grok", 100000 + 250000 * GetDifficulty());
	AddHeroCreatures("Grok", CREATURE_ARCH_DEMON, 1 + 10 * GetDifficulty() );
	AddHeroCreatures("Grok", CREATURE_PIT_SPAWN, 1 + 20 * GetDifficulty() );
	AddHeroCreatures("Grok", CREATURE_HORNED_LEAPER, 1 + 175 * GetDifficulty() );
	AddHeroCreatures("Grok", CREATURE_SUCCUBUS_SEDUCER, 1 + 50 * GetDifficulty() );
	AddHeroCreatures("Grok", CREATURE_QUASIT, 1 + 500 * GetDifficulty() );
	AddHeroCreatures("Grok", CREATURE_NIGHTMARE, 1 + 33 * GetDifficulty() );
	ChangeHeroStat ("Grok", STAT_ATTACK, 1 + 5 * GetDifficulty());
	ChangeHeroStat ("Grok", STAT_DEFENCE, 1 + 5 * GetDifficulty());
	ChangeHeroStat ("Grok", STAT_SPELL_POWER, 1 + 5 * GetDifficulty());
	ChangeHeroStat ("Grok", STAT_KNOWLEDGE, 1 + 5 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_INFERNAL_SUCCUBUS, 1 + 100 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_SUCCUBUS, 1 + 150 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_SUCCUBUS_SEDUCER, 1 + 100 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_DEMON, 1 + 300 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_FAMILIAR, 1 + 400 * GetDifficulty());
	AddObjectCreatures("rightGarrison", CREATURE_HELL_HOUND, 1 + 300 * GetDifficulty());	
	AddObjectCreatures("rightGarrison", CREATURE_PIT_FIEND, 5 + 30 * GetDifficulty());	
	AddObjectCreatures("leftGarrison", CREATURE_ARCHDEVIL, 1 + 15 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_PIT_SPAWN, 1 + 20 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_BALOR, 1 + 18 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_QUASIT, 1 + 200 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_NIGHTMARE, 1 + 50 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_FRIGHTFUL_NIGHTMARE, 1 + 45 * GetDifficulty());
	AddObjectCreatures("leftGarrison", CREATURE_SUCCUBUS_SEDUCER, 1 + 50 * GetDifficulty());
end

function RemoveZehirAndHisTown(hero)
	if hero == "Zehir" then
		MakeHeroReturnToTavernAfterDeath( "Zehir", 0, 0 );
		SaveHeroAllSetArtifactsEquipped( "Zehir", "A2C3M2" );	
		sleep(20);
		RemoveObject( "Zehir" );
		CurrentPlayerHeroes = GetPlayerHeroes( PLAYER_1 );
		for i=0, table.length(CurrentPlayerHeroes)-1 do
			if CurrentPlayerHeroes[i] ~= "Duncan" and CurrentPlayerHeroes[i] ~= "Freyda" then
				pcall ( RemoveObject, CurrentPlayerHeroes[i] );
			end
		end
	
		local town_x, town_y = GetObjectPosition( "ZehirsTown" );
		MoveCamera( town_x, town_y, GROUND, 50, 1,4, 0, 0, 1 );
		sleep(20);
		ZehirMoveTownPlayEffect( "ZehirsTown" );
		RemoveObject( "ZehirsTown" );
		DisableCameraFollowHeroes( 0, 0, 0 );
	end
end

function GiveGrailYes()
	GiveArtefact( "Duncan", ARTIFACT_GRAAL );
	isOkPressed = 1;
end

function GiveGrailNo()
	SetGameVar( "A2C3M2_ZehirHasGrail", "1" );
	isOkPressed = 1;
end

function IsSecondaryDeamonTownCaptured( oldOwner, newOwner, hero )
	if newOwner == PLAYER_1 then
		GiveArtefact( hero, ARTIFACT_CROWN_OF_COURAGE );
		GiveArtefact( hero, ARTIFACT_LION_HIDE_CAPE );
		GiveArtefact( hero, ARTIFACT_NECKLACE_OF_BRAVERY );
		ShowFlyingSign( PATH.."MsgBox_GainOgreSetArtifacts.txt", hero, PLAYER_1, 4 );
	end
end

function RedHeavenGreatings( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "RedHeavenTownBorder", nil );
		H55c_Message.show( PATH.."MsgBox_RedHeavenJoin.txt" );
		SetObjectOwner( "archer_tower1", PLAYER_1 );
		SetObjectOwner( "archer_tower2", PLAYER_1 );
		SetObjectOwner( "footman_tower1", PLAYER_1 );
		SetObjectOwner( "footman_tower2", PLAYER_1 );
		SetObjectOwner( "military_post1", PLAYER_1 );
		SetObjectOwner( "RH_SawMill", PLAYER_1 );
		SetObjectOwner( "RH_OrePit", PLAYER_1 );
		if GetObjectOwner( "military_post2" ) == PLAYER_3 then
			SetObjectOwner( "military_post2", PLAYER_NONE );
		end
		SetObjectOwner( "red_heaven_garrison", PLAYER_1 );
		SetObjectOwner( "red_heaven_town", PLAYER_1 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_7, 2 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_6, 2 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_5, 2 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_4, 2 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_FORT, 3 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_MAGIC_GUILD, 5 );
		
		RH_heroes = GetObjectsInRegion( "RedHeavenRegion", OBJECT_HERO );
		if table.length( RH_heroes ) > 0 then
			for i=0, table.length( RH_heroes )-1 do
				sleep(10);
				SetObjectOwner( RH_heroes[i], PLAYER_1 );
			end
		end
		
		RH_mines={'gold_mine_2_1', 'gold_mine_2_2', 'gold_mine_2_3', 'gem_mine_2', 'ore_pit_2', 'sawmill_2', 'alchemist_lab_2', 'crystal_cavern_2', 'sulfur_deposit_2'};

		for i=1, table.length( RH_mines ) do
			if GetObjectOwner( RH_mines[i] )==PLAYER_3 then
				sleep(10);
				SetObjectOwner( RH_mines[i], PLAYER_1);
			end
		end
	end
end

DISCO = {
	hasStarted = 0,
	ACCESS_COUNTER = 0,
	Lights = { "green_light", "red_light", "blue_light", "yellow_light", "no_light" },
	ANIMATIONS = { "happy", "happy", "happy", "hit", "hit", "attack00", "death", "cast", "rangeattack" },

	ENTER = function( hero )
		if hero == "Zehir" then
			if DISCO.ACCESS_COUNTER == 1 then
				SetObjectPosition( hero, 12, 25, UNDERGROUND );
				startThread( DISCO.START );
			else
				DISCO.ACCESS_COUNTER = DISCO.ACCESS_COUNTER+1;
				print("easterEggCounter = "..DISCO.ACCESS_COUNTER);
			end
		end
	end,
	
	START = function()
		if DISCO.hasStarted == 1 then
			return
		end
		DISCO.hasStarted = 1;
		for i = 1,4 do startThread( DISCO.playLights, "discoLight"..i ); end
		for i= 1,20 do startThread( DISCO.playAnimation, "m"..i ); end
	end,

	playAnimation = function( dancerName )
		while IsObjectExists( dancerName ) ~= nil do
			local anim = DISCO.ANIMATIONS[ random(table.length(DISCO.ANIMATIONS)) + 1 ];
			PlayObjectAnimation( dancerName, anim, ONESHOT );
			sleep( random(15)+50 );
		end;
		print("Object "..dancerName.." doesn't exist");
	end,

	playLights = function( object )
		print("DiscoLights for object "..object.. " started");
		while 1 do
			SetObjectFlashlight( object, DISCO.Lights[ random( table.length( DISCO.Lights ))+1]);
			sleep( random(30) );
			ResetObjectFlashlight( object );
		end
	end,
	
	EXIT = function( hero )
		SetObjectPosition( hero, 119, 36, UNDERGROUND );
	end
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
		ZehirCreaturesAdd( CREATURE_MASTER_GENIE, 20, CRYSTAL, 20, 3000 ); 
		print( "normal" );
	end,
	
	[1] = function()
		diff = 2;
		ZehirCreaturesAdd( CREATURE_MASTER_GENIE, 18, CRYSTAL, 20, 3000 );
		print( "hard" );
	end,
	
	[2] = function()
		diff = 3;
		ZehirCreaturesAdd( CREATURE_MASTER_GENIE, 14, CRYSTAL, 20, 3000 );
		print( "heroic" );
	end,
	
	[3] = function()
		diff = 4;
		ZehirCreaturesAdd( CREATURE_MASTER_GENIE, 12, CRYSTAL, 20, 3000 );
		print( "impossible" );
	end,
}

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
		CINEMATICS.playAndWait( 0 ); -- speak with enemy hero
		local x,y,floor = GetObjectPosition( "Zehir" );
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "Loose(PLAYER_1)" );
		MoveHeroRealTime( "RedHeavenHero02", x, y, floor );
		repeat sleep( 50 ) until IsHeroAlive( "RedHeavenHero02") == nil;
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		CreateMonster("tmp_zealot", CREATURE_ZEALOT, 1, 127,40,GROUND,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN,100);
		sleep(20);
		CINEMATICS.playAndWait( 2 ); -- speak with the zealot after battle
		sleep(20);
		SetClericOnRitePosition( CREATURE_ZEALOT, "Zehir", "tmp_zealot" );	-- Поставить клерика на место ритуала
		UnblockGame();
	end,
	
	meetCleric = function()
		BlockGame();
		CreateMonster("tmp_zealot", CREATURE_ZEALOT, 1, 127,40,GROUND,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN,100);
		sleep(20);
		CINEMATICS.playAndWait( 2 );
		sleep(20);
		SetClericOnRitePosition( CREATURE_ZEALOT, "Zehir", "tmp_zealot" );	-- Поставить клерика на место ритуала
		UnblockGame();
	end,
	
	summonInfernoBoss = function()
		BlockGame();
		local x, y = RegionToPoint( "ZehirRegion" );
		PlayVisualEffect( EFFECT_INFERNO_GATING, "", "tag", x+0.5, y+0.5, GROUND );
		Play2DSound( SOUND_EFFECT_GATING );
		sleep(15);
		SetObjectPosition( "InfernoBoss", x, y, GROUND );
		sleep(1);
		SetObjectRotation( "InfernoBoss", 315 );
		SetRegionBlocked( "ZehirRegion", nil );
		sleep(1);
		PlayObjectAnimation( "InfernoBoss", "stir00", ONESHOT );
		sleep(20);
		MessageBox( PATH.."RitualPlaceBossFight.txt" );
		startThread( PlayInfernoBossAnimations );
		UnblockGame();
	end,
	
	startRite = function()
		BlockGame();
		local Rx, Ry, Rf =  RegionToPoint( "ZehirRegion" );
		MoveHeroRealTimeAndReachPoint( "Zehir", Rx, Ry, Rf);
		while 1 do
			sleep(10);
			local x, y, f = GetObjectPosition("Zehir");
			if x == Rx and y == Ry and z == Rz then
				break
			end
		end
		SetObjectRotation( "Zehir", 315);
		sleep(20);
		PlayObjectAnimation( "cleric"..110, "cast", ONESHOT );
		PlayObjectAnimation( "cleric"..10, "cast", ONESHOT );
		PlayObjectAnimation( "cleric"..9, "cast", ONESHOT );
		sleep(20);
		local x_r,y_r = RegionToPoint("rite_area" );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'megaboom', x_r,y_r, 7, 0, GROUND );
		PlayVoiceoverAndBlockGame( SOUND_EFFECT_HOLY_WORD, 3 );
		UnblockGame();
	end,
	
	demonTransformation = function()
		BlockGame();
		OpenCircleFog( 97, 88, GROUND, 16 , PLAYER_1 );
		MoveCamera( 88,84,GROUND,70,1,4,0,0,1 );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 97, 97, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 103, 92, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 103, 85, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 89, 91, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 89, 81, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 96, 71, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 81, 82, 10, 0, GROUND );
		Play2DSound( SOUND_EFFECT_HOLY_WORD );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_HOLY_WORD ) / 1.65 );
		for i = 1, 9 do
			RemoveObject("rock"..i);
		end
		ReplaceDwelling( "daemon_level3_dwelling1", TOWN_INFERNO );
		ReplaceDwelling( "daemon_level3_dwelling2", TOWN_INFERNO );
		ReplaceDwelling( "daemon_level2_dwelling1", TOWN_INFERNO );
		ReplaceDwelling( "daemon_level2_dwelling2", TOWN_INFERNO );
		ReplaceDwelling( "deamon_military_post1", TOWN_INFERNO );
		ReplaceDwelling( "deamon_military_post2", TOWN_INFERNO );
		TransformTown("main_deamon_town", TOWN_INFERNO );
		sleep(1);
		Play2DSound( "/Maps/Scenario/A2C3M2/C3M2_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_TOWN_HALL );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_BLACKSMITH );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_MAGIC_GUILD );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_MAGIC_GUILD );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_DWELLING_1 );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_DWELLING_2 );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_MARKETPLACE );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_DWELLING_1 );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_DWELLING_2 );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_FORT );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_FORT );
		UpgradeTownBuilding( "main_deamon_town", TOWN_BUILDING_TAVERN );
		local x,y,floor = GetObjectPosition("RedHeavenHero03");
		sleep(1);
		RemoveObject("RedHeavenHero03");
		sleep(1);
		DeployReserveHero( "Grok", x, y, floor );
		sleep(35);
		OpenCircleFog( 11, 119, GROUND, 12 , PLAYER_1 );
		MoveCamera( 11,119, GROUND, 70, 1,4,0,0,1 );
		sleep(5);
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 11, 119, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 18, 114, 10, 0, GROUND );
		PlayVisualEffect( EFFECT_HOLY_WORD, '', 'boom', 19, 121, 10, 0, GROUND );
		Play2DSound( SOUND_EFFECT_HOLY_WORD );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_HOLY_WORD ) / 1.65 );
		ReplaceDwelling( "daemon_level3_dwelling1_2", TOWN_INFERNO );
		ReplaceDwelling( "daemon_level1_dwelling1", TOWN_INFERNO );
		TransformTown("secondary_deamon_town", TOWN_INFERNO );
		sleep(30);
		UpgradeTownBuilding( "secondary_deamon_town", TOWN_BUILDING_TAVERN );
		UpgradeTownBuilding( "red_heaven_town", TOWN_BUILDING_TAVERN );
		DisableAutoEnterTown( "main_deamon_town", not nil );
		DisableAutoEnterTown( "secondary_deamon_town", not nil );
		ShowReplaceToDeamonCreature( "demon_deamon", CREATURE_HORNED_LEAPER, 50 + 50 * diff );
		ShowReplaceToDeamonCreature( "demon_balor", CREATURE_PIT_SPAWN, 5 + 10 * diff );
		ShowReplaceToDeamonCreature( "demon_devil", CREATURE_ARCH_DEMON, 6 + 4 * diff);
		UnblockGame();
	end,
	
	zehirMeetsDuncanAndFreyda = function()
		BlockGame();
		DisableCameraFollowHeroes( 1, 0, 0 );
		local zehir_x, zehir_y = GetObjectPosition( "Zehir" );
		MoveCamera( zehir_x, zehir_y, GROUND, 50, 1,4, 0, 0, 1 );
		SetObjectPosition( "Zehir", 2, 70, GROUND );
		sleep(20);
		MoveCamera( 2, 70, GROUND, 50, 1,4, 0, 0, 1 );
		UnblockGame();	
		StartDialogScene( "/DialogScenes/A2C3/M2/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		QuestionBox( PATH.."MsgBox_GiveGraalZehirOrDuncan.txt", "GiveGrailYes", "GiveGrailNo" );
		while isOkPressed == 0 do sleep(10); end; 
		BlockGame();
		MoveHeroRealTimeAndReachPoint("Zehir", 1, 69, GROUND );
		UnblockGame();	
	end,
}

OBJECTIVES = {
	state = {
		findGrail				= {					"Prim1_FindGraal", 1 },	-- find the Grail
		getClerics				= { 		"prim2_CollectAllClerics", 1 },	-- find enough clerics for the rite
		moveTown				= {					 "prim3_MoveTown", 1 },	-- move the town next to rite location
		performRite				= {			   "prim4_PerformTheRite", 1 },	-- perform the rite
		killHeroAndDestroyTown	= { 	"prim5_CaptureDeamonMainTown", 1 },	-- Capture main inferno town
		giveGrail				= { 		 "prim6_GiveGraalToZehir", 1 },	-- Zehir must have the grail
		isFreydaAlive			= { 		"prim7_FreydaMustSurvive", 1 },	-- Freyda must survive
		isDuncanAlive			= { 			  "DuncanMustSurvive", 1 },	-- Duncan must survive
		isZehirAlive			= { 		 "Prim9_ZehirMustSurvive", 1 },	-- Zehir must survive
		captureSecDemonTown		= { "sec1_CaptureDeamonSecondaryTown", 1 },	-- Capture and destroy the secondary demon town
		eventManager			= { 							  "_", 1 }, --
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetGameVar( "A2C3M2_ZehirHasGrail", "0");
		SetGameVar( "A2C3M3_Graal", "0");
		BlockGame();
		GiveTransferrableArtifacts();
		ZehirAbilitiesInit("Zehir");
		ZehirTownInit("ZehirsTown");
		AddTownPoint(92, 127, GROUND, 0, "summon_town_area", 15000, "landing_zone");
		SetRegionBlocked( "landing_zone", not nil, PLAYER_1);
		DIFFICULTY[GetDifficulty()]();
		if GetDifficulty() ~= DIFFICULTY_EASY then
			AddObjectCreatures( "InfernoBoss", CREATURE_ARCHDEVIL, 1+20*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_BALOR, 1+30*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_FRIGHTFUL_NIGHTMARE, 1+40*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_CERBERI,  1+100*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_HORNED_DEMON, 1+150*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_SUCCUBUS, 1+70*GetDifficulty() );
			AddObjectCreatures( "InfernoBoss", CREATURE_FAMILIAR, 1+300*GetDifficulty() );
		end
		CINEMATICS.intro();
		SetPlayerStartResource( PLAYER_1, CRYSTAL, 60 );
		SetPlayerStartResource( PLAYER_1, MERCURY, 20 );
		SetRegionBlocked( "garrison1", not nil, PLAYER_2 ); 
		SetRegionBlocked( "garrison2", not nil, PLAYER_2 );
		SetRegionBlocked( "level2_border1", not nil, PLAYER_2 ); 
		SetRegionBlocked( "level2_border2", not nil, PLAYER_2 );
		SetRegionBlocked( "level3_border", not nil, PLAYER_2 );
		SetRegionBlocked( "RedHeavenTownBorder", not nil, PLAYER_3 );
		SetObjectEnabled( "main_deamon_town", nil );
		DisableAutoEnterTown( "main_deamon_town", not nil );
		SetObjectEnabled( "secondary_deamon_town", nil );
		DisableAutoEnterTown( "secondary_deamon_town", not nil );
		EnableHeroAI( "RedHeavenHero03", nil );
		EnableHeroAI( "RedHeavenHero02", nil );
		for i, tavern_hero_race in { TOWN_DUNGEON, TOWN_NECROMANCY, TOWN_STRONGHOLD, TOWN_PRESERVE, TOWN_FORTRESS, TOWN_INFERNO, TOWN_ACADEMY } do
			AllowHeroHiringByRaceInTown( "red_heaven_town", tavern_hero_race, 0 );
		end
		SetObjectEnabled( "red_heaven_town", nil );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_6, 0 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_5, 0 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_DWELLING_4, 0 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_FORT, 1 );
		SetTownBuildingLimitLevel( "red_heaven_town", TOWN_BUILDING_MAGIC_GUILD, 1 );
		SetPlayerHeroesCountNotForHire( PLAYER_1, 2 );
		-- Prepare rite locations and cleric triggers
		for i, rite_region in { "110Region", "10Region", "9Region", "ZehirRegion" } do
			SetRegionBlocked( rite_region, not nil, PLAYER_1 );
		end
		for i, rite_priest in { "cleric", "priest" } do 
			SetObjectEnabled( rite_priest, nil );
			SetDisabledObjectMode( rite_priest, DISABLED_INTERACT );
			Trigger( OBJECT_TOUCH_TRIGGER, rite_priest, "IsClericJoined" )
		end
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "rite_area", "IsAllRequiredElementsCollected" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "disco_enter", "DISCO.ENTER" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "disco_exit", "DISCO.EXIT" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "ZehirsExit", "RemoveZehirAndHisTown");
		sleep( 10 ); -- required for PCs with faster CPUs in order to not break meetCleric() cinematics.
		UnblockGame();
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
			
			if GetObjectiveState("Prim1_FindGraal") == OBJECTIVE_FAILED or GetObjectiveState("Prim9_ZehirMustSurvive") == OBJECTIVE_FAILED or GetObjectiveState("prim7_FreydaMustSurvive") == OBJECTIVE_FAILED or GetObjectiveState("DuncanMustSurvive") == OBJECTIVE_FAILED then
				Loose( PLAYER_1 );
				return
			end

			if GetObjectiveState("prim5_CaptureDeamonMainTown") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped( "Freyda", "A2C3M2");
				SaveHeroAllSetArtifactsEquipped( "Duncan", "A2C3M2");
				sleep( 200 );
				Win();
				return
			end
		end
	end,
	
	findGrail = function()
		if OBJECTIVES.state.findGrail[2] == 1 then
			--CINEMATICS.meetCleric();
			SetObjectiveState( "Prim1_FindGraal", OBJECTIVE_ACTIVE ); 
			OBJECTIVES.state.findGrail[2] = 2;
		elseif OBJECTIVES.state.findGrail[2] == 2 and IsPlayerHeroHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) then
			OBJECTIVES.state.findGrail[2] = 3;
		elseif OBJECTIVES.state.findGrail[2] == 3 then
			if HasArtefact( "Zehir", ARTIFACT_GRAAL ) then
				SetObjectiveState( "Prim1_FindGraal", OBJECTIVE_COMPLETED ); 
				OBJECTIVES.state.findGrail[2] = 10;
			elseif IsPlayerHeroHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil then
				MessageBox( PATH.."HeroLostGraal.txt" );
				SetObjectiveState( "Prim1_FindGraal", OBJECTIVE_FAILED ); 
				OBJECTIVES.state.findGrail[2] = 11;
			end
		end
	end,	
	
	getClerics_count = 0,
	getClerics = function()
		if OBJECTIVES.state.getClerics[2] == 1 then
			SetObjectiveState( "prim2_CollectAllClerics", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.getClerics[2] = 2;
		elseif OBJECTIVES.state.getClerics[2] == 2 and OBJECTIVES.getClerics_count >= 3 then
			SetObjectiveState( "prim2_CollectAllClerics", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.getClerics[2] = 10;
		end
	end,	
	
	moveTown = function()
		if OBJECTIVES.state.moveTown[2] == 1 then
			SetObjectiveState( "prim3_MoveTown", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.moveTown[2] = 2;
		elseif OBJECTIVES.state.moveTown[2] == 2 and GetObjectPosition("ZehirsTown") == 92 then
			SetObjectiveState( "prim3_MoveTown", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.moveTown[2] = 10;
		end
	end,	
	
	performRite = function()
		if OBJECTIVES.state.performRite[2] == 1 then
			SetObjectiveState( "prim4_PerformTheRite", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.performRite[2] = 2;
		elseif OBJECTIVES.state.performRite[2] == 3 then
			CINEMATICS.summonInfernoBoss();
			OBJECTIVES.state.performRite[2] = 4;
		elseif OBJECTIVES.state.performRite[2] == 4 and IsObjectExists( "InfernoBoss" ) == nil then
			MessageBox( PATH.."MsgBox_GoToTheCenter.txt" );
			OBJECTIVES.state.performRite[2] = 5;
		elseif OBJECTIVES.state.performRite[2] == 6 then
			CINEMATICS.startRite();
			OBJECTIVES.state.performRite[2] = 7;
		elseif OBJECTIVES.state.performRite[2] == 7 then
			CINEMATICS.demonTransformation();
			SetupDemonHero();
			SetObjectiveState( "prim4_PerformTheRite", OBJECTIVE_COMPLETED );
			sleep(15);
			DeployReserveHero( "Duncan", 4, 68, GROUND );
			DeployReserveHero( "Freyda", 5, 70, GROUND );
			sleep(20);
			H55_CamFixTooManySkills( PLAYER_1, "Duncan" );
			H55_CamFixTooManySkills( PLAYER_1, "Freyda" );
			sleep(1);
			SetObjectRotation( "Duncan", 90 );
			SetObjectRotation( "Freyda", 90 );
			sleep(1);
			UnreserveHero( "Duncan" );
			UnreserveHero( "Freyda" );
			CINEMATICS.zehirMeetsDuncanAndFreyda();
			Trigger( OBJECT_CAPTURE_TRIGGER, "secondary_deamon_town", "IsSecondaryDeamonTownCaptured" );
			SetObjectEnabled( "secondary_deamon_town", not nil );
			SetObjectEnabled( "main_deamon_town", not nil );
			SetObjectEnabled( "red_heaven_town", not nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "RedHeavenTownBorder", "RedHeavenGreatings" );
			SetObjectOwner( "archer_tower1", PLAYER_3 );
			SetObjectOwner( "archer_tower2", PLAYER_3 );
			SetObjectOwner( "footman_tower1", PLAYER_3 );
			SetObjectOwner( "footman_tower2", PLAYER_3 );
			SetObjectOwner( "military_post1", PLAYER_3 );
			SetObjectOwner( "military_post2", PLAYER_3 );
			SetObjectOwner( "red_heaven_town", PLAYER_3 );
			SetObjectOwner( "red_heaven_garrison", PLAYER_3 );
			UpgradeTownBuilding( "red_heaven_town", TOWN_BUILDING_TAVERN );
			UpgradeTownBuilding( "secondary_deamon_town", TOWN_BUILDING_TAVERN );
			RH_heroes = GetObjectsInRegion( "RedHeavenRegion", OBJECT_HERO );
			if table.length( RH_heroes ) > 0 then
				for i=0, table.length( RH_heroes )-1 do
					RemoveObject( RH_heroes[i] );
				end
			end
			OBJECTIVES.state.performRite[2] = 10;
		end
	end,
	
	killHeroAndDestroyTown = function()
		if OBJECTIVES.state.killHeroAndDestroyTown[2] == 1 and OBJECTIVES.state.performRite[2] == 10 then
			SetObjectiveState( "prim5_CaptureDeamonMainTown", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.killHeroAndDestroyTown[2] = 2;
		elseif OBJECTIVES.state.killHeroAndDestroyTown[2] == 2 then
			if GetObjectOwner("main_deamon_town") == PLAYER_1 then
				Play2DSound( VOICEOVER_MAIN_INFERNO_TOWN_DESTROYED );
				OBJECTIVES.state.killHeroAndDestroyTown[2] = 3;
			elseif IsHeroAlive("Grok") == nil then
				Play2DSound( VOICEOVER_INFERNO_HERO_DEFEATED );
				OBJECTIVES.state.killHeroAndDestroyTown[2] = 3;
			end
		elseif OBJECTIVES.state.killHeroAndDestroyTown[2] == 3 and GetObjectOwner("main_deamon_town") == PLAYER_1 and IsHeroAlive("Grok") == nil then
			SetObjectiveState( "prim5_CaptureDeamonMainTown", OBJECTIVE_COMPLETED );
			RazeTown("main_deamon_town");
			OBJECTIVES.state.killHeroAndDestroyTown[2] = 10;
		end
	end,
	
	captureSecDemonTown = function()
		if OBJECTIVES.state.captureSecDemonTown[2] == 1  and OBJECTIVES.state.performRite[2] == 10 then
			SetObjectiveState( "sec1_CaptureDeamonSecondaryTown", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureSecDemonTown[2] = 2;
		elseif OBJECTIVES.state.captureSecDemonTown[2] == 2 and GetObjectOwner("secondary_deamon_town") == PLAYER_1 then
			SetObjectiveState( "sec1_CaptureDeamonSecondaryTown", OBJECTIVE_COMPLETED );
			RazeTown( "secondary_deamon_town" );
			OBJECTIVES.state.captureSecDemonTown[2] = 10;
		end
	end,
	
	giveGrail = function()
		if OBJECTIVES.state.giveGrail[2] == 1 and IsPlayerHeroHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) and HasArtefact( "Zehir", ARTIFACT_GRAAL ) == nil then
			SetObjectiveState( "prim6_GiveGraalToZehir", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.giveGrail[2] = 2;
		elseif OBJECTIVES.state.giveGrail[2] == 2 and HasArtefact( "Zehir", ARTIFACT_GRAAL ) then
			RemoveArtefact( "Zehir", ARTIFACT_GRAAL );  -- удалить артефакт, чтобы выдать снова но с параметром untransferable
			sleep(10);
			GiveArtefact( "Zehir", ARTIFACT_GRAAL, 1 ); -- запретить Зехиру передавать артефакт другим героям. (Set artifact untransferable)
			SetObjectiveState( "prim6_GiveGraalToZehir", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.giveGrail[2] = 10;
		end
	end,
	
	isFreydaAlive = function()
		if OBJECTIVES.state.isFreydaAlive[2] == 1 and OBJECTIVES.state.performRite[2] == 10 then
			SetObjectiveState( "prim7_FreydaMustSurvive", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.isFreydaAlive[2] = 2;
		elseif OBJECTIVES.state.isFreydaAlive[2] == 2 and IsHeroAlive("Freyda") == nil then
			SetObjectiveState( "prim7_FreydaMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isFreydaAlive[2] = 11;
		end
	end,
	
	isDuncanAlive = function()
		if OBJECTIVES.state.isDuncanAlive[2] == 1  and OBJECTIVES.state.performRite[2] == 10 then
			SetObjectiveState( "DuncanMustSurvive", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.isDuncanAlive[2] = 2;
		elseif OBJECTIVES.state.isDuncanAlive[2] == 2 and IsHeroAlive("Duncan") == nil then
			SetObjectiveState( "DuncanMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isDuncanAlive[2] = 11;
		end
	end,

	isZehirAlive = function()
	-- start of task is handled by map.xdb file
		if OBJECTIVES.state.isZehirAlive[2] == 1 then
			if OBJECTIVES.state.performRite[2] >= 6 then
				SetObjectiveState( "Prim9_ZehirMustSurvive", OBJECTIVE_COMPLETED );
				OBJECTIVES.state.isZehirAlive[2] = 10;
			elseif IsHeroAlive( "Zehir" ) == nil then
				SetObjectiveState( "Prim9_ZehirMustSurvive", OBJECTIVE_FAILED );
				OBJECTIVES.state.isZehirAlive[2] = 11;
			end
		end
	end,
	
	eventManager_DuncanFreydaDeployment = 0,
	eventManager = function()
		if OBJECTIVES.state.eventManager[2] == 1 and OBJECTIVES.state.performRite[2] == 10 then
			OBJECTIVES.eventManager_DuncanFreydaDeployment = OBJECTIVES.date;
			OBJECTIVES.state.eventManager[2] = 2;
		elseif OBJECTIVES.state.eventManager[2] == 2 and OBJECTIVES.date - OBJECTIVES.eventManager_DuncanFreydaDeployment >= 21 then
			SetRegionBlocked( "garrison1", nil, PLAYER_2 );
			SetRegionBlocked( "garrison2", nil, PLAYER_2 );
			print("TimeToOpenBordersToAI: AI has access to level 1 area");
			OBJECTIVES.state.eventManager[2] = 3;
		elseif OBJECTIVES.state.eventManager[2] == 3 and OBJECTIVES.date - OBJECTIVES.eventManager_DuncanFreydaDeployment >= 42 then
			SetRegionBlocked( "level2_border1", nil, PLAYER_2 );
			SetRegionBlocked( "level2_border2", nil, PLAYER_2 );
			print("TimeToOpenBordersToAI: AI has access to level 2 area");
			OBJECTIVES.state.eventManager[2] = 4;
		elseif OBJECTIVES.state.eventManager[2] == 4 and OBJECTIVES.date - OBJECTIVES.eventManager_DuncanFreydaDeployment >= 84 then
			SetRegionBlocked( "level3_border", nil, PLAYER_2 );
			print("TimeToOpenBordersToAI: AI has access to level 3 area");
			OBJECTIVES.state.eventManager[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function a2c3m2_dbg( var )
	H55_Speedrun(1);
	if var == 1 then
		IsClericJoined("Zehir", "cleric");
		IsClericJoined("Zehir", "priest");
		GiveArtefact("Zehir", 53);
		SetObjectPosition("Zehir", 98, 118, 0 );
	elseif var == 2 then
		MakeTownMovable("ZehirsTown");
		OBJECTIVES.state.performRite[2] = 7;
		OBJECTIVES.state.moveTown[2] = 10;
	end
end