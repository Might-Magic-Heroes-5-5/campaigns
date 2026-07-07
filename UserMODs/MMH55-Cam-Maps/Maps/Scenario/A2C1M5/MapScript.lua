doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};
H55c_AI_CONTROLLED = {
  player1 = {				-- player 1player/human so state should be 0 to skip control of the heroes
	state = 0,				-- 0 human, 1 unmanaged AI, 2 managed AI
	heroes = {},
	enemies = {},
  },
  player2 = {				-- Blue Haven player
	state = 1,				-- Enemy to the player but not targeting him directly
	heroes = {},
	enemies = {},
  },
  player3 = {				-- Red Inferno demon spawn heros
	state = 2,				-- Leads onslaught against the human player aiming at besiging his newly conquered towns.
	heroes = {},
	enemies = {
		{ priority = 1.0, heroes = 0.1, towns = 1.0, is_enemy = 1 },  -- PLAYER1
		{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
		{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
    },
  },
}

function f_artifacts_sets()
	InitAllSetArtifacts( "A2C1M5", "Arantir",  "OrnellaNecro" );
	LoadHeroAllSetArtifacts( "OrnellaNecro", "A2C1M4" );
	LoadHeroAllSetArtifacts(      "Arantir", "A2C1M4" );
	sleep(40);
	H55_CamFixTooManySkills(PLAYER_1, "OrnellaNecro");
	H55_CamFixTooManySkills(PLAYER_1,	   "Arantir");
end

startThread( f_artifacts_sets );

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_STAFF_OF_VEXINGS,
	ARTIFACT_CLOAK_OF_MOURNING,
	ARTIFACT_RING_OF_DEATH,
	ARTIFACT_SKULL_HELMET
};

DevastatorName = "";
NearSoulkeeperName = "";
AvengerName = "";

function InitTeleportsPairs()
	TeleportsPairs = {};
	TeleportsPairs.Count = 7;
	for i = 1, TeleportsPairs.Count do
		TeleportsPairs[i] = {};
		local nGroup = i + 14;
		TeleportsPairs[i].In = "In"..nGroup;
		TeleportsPairs[i].Out = "Out"..nGroup;
		TeleportsPairs[i].Elemental_Out = "Elemental_Out_"..nGroup;
		TeleportsPairs[i].Blocked = 1;
		TeleportsPairs[i].Angle = 0;
		SetObjectEnabled(TeleportsPairs[i].In, nil);
		Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].In, "TouchTeleportPairIn");
		Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].Out, "TouchTeleportPairOut");
	end;
	TeleportsPairs[1].Angle = 1.57;
	TeleportsPairs[2].Angle = 4.71;
	TeleportsPairs[3].Angle = 1.57;
	TeleportsPairs[4].Angle = 0;
	TeleportsPairs[5].Angle = 1.57;
	TeleportsPairs[6].Angle = 4.71;
	TeleportsPairs[7].Angle = 1.57;
	startThread(CheckTeleportPairOutElementals);
end

function CheckTeleportPairOutElementals()
	while 1 do
		local count = 0;
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].Blocked == 1 then
				if IsObjectExists(TeleportsPairs[i].Elemental_Out) == 1 then
					count = count + 1;
				else
					SetObjectEnabled(TeleportsPairs[i].In, not nil);
					TeleportsPairs[i].Blocked = 0;
				end
			end
		end
		if count == 0 then
			break
		end
		sleep(20);
	end
end

function TouchTeleportPairIn(heroName, objectName)
	if GetObjectOwner(heroName) == PLAYER_1 then
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].In == objectName then	
				if TeleportsPairs[i].Blocked == 1 then
					local x, y, f = GetObjectPosition(TeleportsPairs[i].Out);
					OpenCircleFog(x, y, f, 4, 1);
					MoveCamera(x, y, f, 35, 1, TeleportsPairs[i].Angle, 0, 0, 1);		
					MessageBox("/Maps/Scenario/A2C1M5/messagebox_027.txt");
				end
			end
		end
	end
end

function TouchTeleportPairOut(heroName, objectName)
	if GetObjectOwner(heroName) == PLAYER_1 then
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].Out == objectName then	
				if TeleportsPairs[i].Blocked == 1 then
					Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].In, nil);
					Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].Out, nil);
					SetObjectEnabled(TeleportsPairs[i].In, not nil);
					TeleportsPairs[i].Blocked = 0;
				end
			end
		end
	end
end

function visitMagicBarrier(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, 'Gate_to_Flammschrein', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_002.txt')");
		OBJECTIVES.state.removeMagicBarrier[2] = 1;
		OBJECTIVES.state.avengeTheGhost[2] = 1;
	end
end

function UseTreasurePortal(hero, object)
	Trigger(OBJECT_TOUCH_TRIGGER, object, nil); 
	for i, name in { 'Teleport_to_hero', 'Teleport_to_trees', 'Teleport_to_gold' } do
		if name ~= object then 
			Trigger(OBJECT_TOUCH_TRIGGER, name, "MessageBox('/Maps/Scenario/A2C1M5/messagebox_007.txt')"); 
			SetObjectEnabled(name, nil);
		end
	end
end

function meetAssassins(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		AvengerName = hero;
		OBJECTIVES.state.avengeTheGhost[2] = 3;
	end
end

function spareAssassins(hero)
	OBJECTIVES.state.avengeTheGhost[2] = 9;
end

function attackAssassins()
	OBJECTIVES.state.avengeTheGhost[2] = 5;
end

function returnToGhost()
	if IsObjectExists('Assasin') == nil then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", nil );			
		OBJECTIVES.state.avengeTheGhost[2] = 7;
	else
		MessageBox('/Maps/Scenario/A2C1M5/messagebox_005.txt')
	end
end

function f_ready_destroy_altar( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		if GetHeroStat(hero, STAT_SPELL_POWER) <= 9 then
			MessageBox("/Maps/Scenario/A2C1M5/messagebox_033.txt"); -- Message that cannot destroy altar
		else
			Trigger( OBJECT_TOUCH_TRIGGER, 'Inferno_altar', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_019.txt')" );
			OBJECTIVES.destroyPortal_destroyer = hero;
			OBJECTIVES.state.destroyPortal[2] = 4;
		end
	end	
end

fire_message = 0;
function SuccubusTurnsToFire(hero)
	BlockGame();
	DevastatorName = hero;
	SetObjectPosition('Ritual_Succubus', 141, 166, GROUND);
	SetObjectPosition('Fire_for_move_to_altar', 22, 138, GROUND);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Fire_hug", "HeroBurnsInFire");
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", "SuccubusReturnFromFire");
	if fire_message == 0 then
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_028.txt");
		fire_message = 1;
	end
	UnblockGame();
end

function HeroBurnsInFire()
	if DevastatorName ~= "" then
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_017.txt");
		sleep(10);
		RemoveObject(DevastatorName);
	end
end

return_fire_message = 0;
function SuccubusReturnFromFire(hero)
	if DevastatorName == hero then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", nil);
		DevastatorName = "";
		SetObjectPosition('Ritual_Succubus', 22, 138, GROUND);
		SetObjectPosition('Fire_for_move_to_altar', 140, 166, GROUND);
		if return_fire_message == 0 then
			return_fire_message = 1;
			startThread( MessageBox, "/Maps/Scenario/A2C1M5/messagebox_018.txt" );
		end
	end
end

function f_meet_paladin( hero ) -- Запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, 'Paladin', "f_meet_paladin");
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, 'Paladin', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_025.txt')");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Soulkeeper_speaks_go_away", nil);
		OBJECTIVES.state.killPaladinSoulKeeper[2] = 1;
	end
end

RITUAL_TILES = {
	['Tile_44_154'] = {  44, 154, 0, 10, 1,  3.14, 0, 0, 1 },
	['Tile_65_111'] = {  65, 111, 0, 30, 1,  1.57, 0, 0, 1 },
	['Tile_20_12']  = {  20,  12, 0, 30, 1,  1.57, 0, 0, 1 },
	['Tile_149_67'] = { 149,  67, 0, 30, 1, 3.925, 0, 0, 1 },
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
	
	outro = function()
		StartDialogScene("/DialogScenes/A2C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,	

	ArantirTalkToOrnella = function()
		BlockGame();
		local x_ara, y_ara, floor_ara = GetObjectPosition( "Arantir" );
		local x_orn, y_orn, floor_orn = GetObjectPosition( "OrnellaNecro" );
		SetObjectPosition( "Arantir", 23, 13, GROUND );
		SetObjectPosition( "OrnellaNecro", 23, 11, GROUND );
		sleep(10);
		SetObjectRotation( "Arantir", 0 );
		SetObjectRotation( "OrnellaNecro", 180 );
		UnblockGame();
		CINEMATICS.playAndWait( 8 );
		SetObjectPosition( "Arantir", x_ara, y_ara, floor_ara );
		SetObjectPosition( "OrnellaNecro", x_orn, y_orn, floor_orn );
		UnblockGame();
	end,
	
	performRitual = function()
		OBJECTIVES.state.OrnellaIsAlive[2] = 2;
		BlockGame();
		MakeHeroReturnToTavernAfterDeath('Gles', 0); -- НЕВозвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath('Effig', 0); -- НЕВозвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath('Muscip', 0); -- НЕВозвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath('OrnellaNecro', 0); -- НЕВозвращение героя в таверну
		for key, value in RITUAL_TILES do
			OpenCircleFog(value[1], value[2], value[3], value[4], value[5]);		
			MoveCamera(value[1], value[2], value[3], value[4] + 20, value[5], value[6], value[7], value[8],value[9]);	
			sleep(40);
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", key, 0, 0, 0, 0, 0 );
			Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" );
			sleep(60);
		end
		OpenCircleFog(137, 128, 0, 10, 1);
		for i = 1,4 do
			local sacrifice = GetObjectsInRegion( "Ritual_"..i, OBJECT_HERO );
			if table.length(sacrifice) > 0 then RemoveObject(sacrifice[0]); end;
		end
		if IsHeroAlive("GhostFSLord") ~= nil then RemoveObject('GhostFSLord'); 	end
		MoveCamera(137, 128, 0, 30, 1, 4.71, 0, 0, 1);
		sleep(40);
		if IsObjectExists( 'Fire_wall' ) ~= nil then
			PlayVisualEffect( "/Effects/_(Effect)/Spells/UnholyWord.xdb#xpointer(/Effect)", 'Fire_wall', 0, 0, 0, 6, 0 );
			sleep(4);
			Play2DSound( "/Sounds/_(Sound)/Spells/UnholyWord.xdb#xpointer(/Sound)" ); ----------------BARIER
			sleep(40);	
			RemoveObject('Fire_wall');
		end
		sleep(40);
		Play2DSound( "/Maps/Scenario/A2C1M5/C1M5_AM3_Arantir_01sound.xdb#xpointer(/Sound)" );
		UnblockGame();
	end,
	
	meetGhost = function()
		BlockGame();
		OpenCircleFog(145, 122, GROUND, 4, 1);
		MoveCamera(145, 122, 0, 40, 1, 0, 0, 0, 1);
		sleep(25);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Summon_ghost', 0, 0, 0, 0, 0 );
		sleep(20);
		DeployReserveHero("GhostFSLord", 145, 123, GROUND);
		sleep(50);
		EnableHeroAI("GhostFSLord", not nil);	
		SetObjectRotation("GhostFSLord", 270);
		MoveHeroRealTime("GhostFSLord", 139, 128, GROUND);
		sleep(60);
		MoveCamera(139, 128, 0, 40, 1, 0.785, 0, 0, 1);
		sleep(50);
		SetObjectRotation( "GhostFSLord", 270 );
		sleep(50);
		local x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( 'Arantir' );
		local x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( 'OrnellaNecro' );
		SetObjectPosition( 'Arantir', 134, 128, GROUND );
		SetObjectPosition( 'OrnellaNecro', 132, 128, GROUND );
		SetObjectRotation( 'Arantir', 90 );
		SetObjectRotation( 'OrnellaNecro', 90 );
		UnblockGame();
		CINEMATICS.playAndWait( 0 );
		BlockGame();
		sleep(50);
		EnableHeroAI("GhostFSLord", nil);
		SetObjectPosition( 'Arantir', x_ara_scene, y_ara_scene, floor_ara_scene );
		SetObjectPosition( 'OrnellaNecro', x_orn_scene, y_orn_scene, floor_orn_scene );
		UnblockGame();
	end,
	
	meetPaladin = function()
		BlockGame();
		SetRegionBlocked( "RegionToArantir", nil );
		local x, y = RegionToPoint( "RegionToArantir" );
		local x_to_return, y_to_return, floor_to_return = GetObjectPosition( "Arantir" );
		SetObjectRotation( "Arantir", 315 );
		SetObjectPosition( "Arantir", x, y, GROUND );
		sleep(20);
		UnblockGame();
		CINEMATICS.playAndWait( 5 );
		BlockGame();
		if table.length(GetObjectsInRegion( "RegionToArantir", OBJECT_HERO )) > 0 then -- if Arantir is in region he needs to return back
			SetObjectPosition( "Arantir", x_to_return, y_to_return, floor_to_return );
		end
		OpenCircleFog(169, 67, 0, 12, 1);		
		MoveCamera(169, 67, 0, 40, 1, 0.935, 0, 0, 1);
		sleep(80);
		UnblockGame();
	end,
	
	paladinToDeathKnight = function()
		BlockGame();
		MoveCamera(126, 2, 0, 30, 1, 2.355, 0, 0, 1);
		sleep(35);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", 'Paladin', 0, 0, 0, 0, 0 );
		sleep(35);
		if IsObjectExists('Paladin') then RemoveObject('Paladin'); end
		sleep(10);
		CreateMonster("Death_Knight", CREATURE_DEATH_KNIGHT, 15, 126, 2, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 135);
		local x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( 'Arantir' );
		SetObjectPosition( 'Arantir', 129, 3, GROUND );
		SetObjectRotation( 'Arantir', 270 );
		CINEMATICS.playAndWait( 6 );
		sleep(15);
		sleep(10);
		SetObjectPosition( 'Arantir', x_ara_scene, y_ara_scene, floor_ara_scene );
		SetDisabledObjectMode( "Death_Knight" , DISABLED_INTERACT );
		UnblockGame();
	end,
	
	showAssassins = function()
		BlockGame();
		OpenCircleFog(93, 57, GROUND, 6, PLAYER_1);
		MoveCamera(93, 57, 0, 30, 1, 1.57, 0, 0, 1);
		sleep(60);
		OpenCircleFog(100, 60, GROUND, 6, 1);
		MoveCamera(100, 60, 0, 30, 1, 1.57, 0, 0, 1);	
		sleep(60);
		OpenCircleFog(122, 120, GROUND, 6, 1);		
		MoveCamera(122, 120, 0, 30, 1, 1.57, 0, 0, 1);
		sleep(60);
		UnblockGame();
	end,
	
	meetAssassins = function()
		BlockGame();
		SetObjectPosition( 'Arantir', 94, 60, GROUND );
		SetObjectRotation( 'Arantir', 0 );
		sleep(20);
		UnblockGame();
		CINEMATICS.playAndWait( 3 );
	end,
	
	assassinsKillSuccub = function()
		BlockGame();
		OpenCircleFog(16, 140, 0, 6, 1);
		OpenCircleFog(23, 138, 0, 5, 1);
		if IsObjectExists('Ritual_Succubus') then RemoveObject('Ritual_Succubus'); end
		if IsObjectExists('Assasin') then RemoveObject('Assasin'); end
		if IsObjectExists('Fire_for_move_to_altar') then  RemoveObject('Fire_for_move_to_altar'); end
		sleep(10);
		CreateMonster("Succubus_target", CREATURE_INFERNAL_SUCCUBUS , 1, 22, 138, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 90);
		sleep(20);
		MoveCamera(21, 138, 0, 27, 1, 0, 0, 0, 1);
		sleep(40);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Under_assassin', 0, 0, 0, 0, 0 );
		sleep(30);
		CreateMonster("Assassin_killer", CREATURE_ASSASSIN, 1, 20, 138, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 90);
		sleep(20);
		CINEMATICS.playAndWait( 4 );
		PlayObjectAnimation( "Assassin_killer", "attack00", ONESHOT_STILL );
		sleep(15);
		PlayObjectAnimation( "Succubus_target", "death", ONESHOT_STILL );
		sleep(5);
		PlayObjectAnimation( "Assassin_killer", "stir02", ONESHOT_STILL );
		sleep(30);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Under_succubus', 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Under_assassin', 0, 0, 0, 0, 0 );
		sleep(20);
		RemoveObject("Succubus_target");
		RemoveObject("Assassin_killer");
		UnblockGame();
	end,
	
	destroyPortal = function()
		BlockGame();
		SetObjectPosition(OBJECTIVES.destroyPortal_destroyer, 19, 138, GROUND);	
		sleep(20);			
		MoveCamera(23, 138, 0, 35, 1, 4.71, 0, 0, 1);
		sleep(20);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)", 'Inferno_altar', 0, 0, 0, 0, 0 );
		Play2DSound( "/Sounds/_(Sound)/Spells/Armageddon.xdb#xpointer(/Sound)" ); ----------------DESTROY_ALTAR_SDN
		sleep(170);
		for i = 1, 10 do
			pcall(RemoveObject, "Smoke_"..i);
		end
		SetObjectPosition('Smoke_11', 16, 139, GROUND);
		UnblockGame();
	end,

	ghostReward = function()
		BlockGame();
		MoveCamera(139, 128, 0, 40, 1, 0.785, 0, 0, 1);
		sleep(20);
		local x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( 'Arantir' );
		local x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( 'OrnellaNecro' );
		SetObjectPosition( 'Arantir', 134, 128, GROUND );
		SetObjectPosition( 'OrnellaNecro', 132, 128, GROUND );
		SetObjectRotation( 'Arantir', 90 );
		SetObjectRotation( 'OrnellaNecro', 90 );
		UnblockGame();
		CINEMATICS.playAndWait( 2 );
		BlockGame();
		sleep(20);
		SetObjectPosition( 'Arantir', x_ara_scene, y_ara_scene, floor_ara_scene );
		SetObjectPosition( 'OrnellaNecro', x_orn_scene, y_orn_scene, floor_orn_scene );
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_006.txt");	
		OpenCircleFog(104, 60, GROUND, 6, 1);		
		MoveCamera(104, 60, 0, 30, 1, 0, 0, 0, 1);
		sleep(60);
		OpenCircleFog(100, 64, GROUND, 6, 1);		
		MoveCamera(100, 64, 0, 30, 1, 0, 0, 0, 1);
		sleep(60);
		OpenCircleFog(97, 60, GROUND, 6, 1);		
		MoveCamera(97, 60, 0, 30, 1, 0, 0, 0, 1);		
		sleep(60);
		UnblockGame();
	end,
	
	meetGhostDaughterValeria = function()
		CINEMATICS.playAndWait( 7 );
	end,
	
	meetMochab = function()
		BlockGame();
		if IsObjectExists("Orlando") == nil then DeployReserveHero('Orlando', 153, 133, GROUND); sleep(10); end
		OpenCircleFog(153, 133, GROUND, 4, 1);
		MoveCamera(153, 133, 0, 40, 1, 4.71, 0, 0, 0);		
		startThread(SetAmbientLight, 0, "Daylight", not nil, 10);
		SetObjectRotation('Orlando', 270 );
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_020.txt");
		sleep(20);
		MoveHeroRealTime('Orlando', 158, 151, GROUND);
		EnableHeroAI("Orlando", nil);
		UnblockGame();
	end
}

function f_save(hero)
	if hero == 'Arantir' then
		SetRegionBlocked( "Flammschrein_Ghost_arrives", nil, PLAYER_1 );
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_Deactivator_for_Flammschrein_Ghost_arrives");
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_029.txt");		-- It is Arantir that must advance towards Flammschrein
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", nil);
		sleep(2);
	elseif hero == 'RedHeavenHero03' then
		SetRegionBlocked( "Flammschrein_Ghost_arrives", 1, PLAYER_1 );
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_Deactivator_for_Flammschrein_Ghost_arrives");
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_030.txt"); -- Valeria refuses to attack Flammschrein. It must be Arantir who will do the deed
	end
end

function f_Deactivator_for_Flammschrein_Ghost_arrives(hero)
	if hero == 'Arantir' or hero == 'RedHeavenHero03' then
		SetRegionBlocked("Flammschrein_Ghost_arrives", nil, PLAYER_1);
	end
end

---------------------------------------------------
--*-- UNUSED MESSAGES --*--
---------------------------------------------------
-- MessageBox('/Maps/Scenario/A2C1M5/messagebox_001.txt');	-- related to Oracle figure that is not present in campaign. Likely initial idea by Nival that was scrapped.
-- MessageBox("/Maps/Scenario/A2C1M5/messagebox_011.txt");	-- related to Oracle figure that is not present in campaign. Likely initial idea by Nival that was scrapped.
-- MessageBox("/Maps/Scenario/A2C1M5/messagebox_008.txt");
-- MessageBox("/Maps/Scenario/A2C1M5/messagebox_021.txt");

function f_show_message_soulkeeper_speak_go_away_023(hero)
	BlockGame();
	NearSoulkeeperName = hero;
	SetRegionBlocked("6_block_zone_for_AI_players", 1, PLAYER_1);
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_Soulkeeper_speaks_go_away", "f_Deactivator_for_Soulkeeper_speaks_go_away");	
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_023.txt");
	UnblockGame();
end

function f_Deactivator_for_Soulkeeper_speaks_go_away(hero)
	if NearSoulkeeperName == hero then
		NearSoulkeeperName = "";
		SetRegionBlocked("6_block_zone_for_AI_players", nil, PLAYER_1);
	end
end

function mumiesFinalPlead()
	if IsObjectExists('Final_gift') ~= nil then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mummy_speaks", nil);
		sleep(50);
		ShowFlyingSign("/Maps/Scenario/A2C1M5/messagebox_032.txt", 'Final_gift', PLAYER_1, 12.0);
	end	
end

function SetObjectCreatures( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end
end

function f_add_creatures_to_prisoner()
	if IsObjectExists('RedHeavenHero03') == not nil then
		AddHeroCreatures('RedHeavenHero03', 	CREATURE_SERAPH,  17 -  2 * diff );
		AddHeroCreatures('RedHeavenHero03',	  CREATURE_CHAMPION,  33 -  3 * diff );
		AddHeroCreatures('RedHeavenHero03', 	CREATURE_ZEALOT,  61 - 4 * diff );
		AddHeroCreatures('RedHeavenHero03', CREATURE_VINDICATOR, 130 - 10 * diff );
		Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, nil);
	end
end

A2C1M5_EVIL_TOWN_REINFORCEMENTS = {
		--   T7, T6, T5, T4,  T3,  T2
	 [1] = {  4,   8, 14, 20,  36,  64 },
	 [2] = {  7,  14, 25, 35,  56, 112 },
	 [3] = {  10, 20, 35, 50,  80, 160 },
	 [4] = {  13, 26, 46, 65, 104, 208 },
}

function A2C1M5_reinforceEvilTown( game_diff )
	AddObjectCreatures('Flammschrein',         CREATURE_ARCH_DEMON, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][1]);
	AddObjectCreatures('Flammschrein',          CREATURE_PIT_SPAWN, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][2]);
	AddObjectCreatures('Flammschrein',           CREATURE_HELLMARE, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][3]);
	AddObjectCreatures('Flammschrein',   CREATURE_SUCCUBUS_SEDUCER, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][4]);
	AddObjectCreatures('Flammschrein', CREATURE_FIREBREATHER_HOUND, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][5]);
	AddObjectCreatures('Flammschrein',      CREATURE_HORNED_LEAPER, A2C1M5_EVIL_TOWN_REINFORCEMENTS[game_diff][6]);
end

function f_activate_castle_Merlon()
	SetRegionBlocked("4_block_zone_for_player2", nil, PLAYER_2);
	Trigger( OBJECT_CAPTURE_TRIGGER, 	  'Garrison_ost', nil );
	Trigger( OBJECT_CAPTURE_TRIGGER, 'Garrison_sud_west', nil );
	SetRegionBlocked(   "Temp_block_player2", nil, PLAYER_2 );
	SetRegionBlocked( "Temp_block_player2_2", nil, PLAYER_2 );
	print("nord_free");
end;

function f_activate_castle_Stormdale()
	SetRegionBlocked("3_block_zone_for_player2", nil, PLAYER_2);
	Trigger(OBJECT_CAPTURE_TRIGGER, 'Garrison_nord', nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, 'Garrison_center_nord', nil);
	print("center_free");
end;

function GameVarBonus()
	if GetGameVar("BONUS_A2C1M4") =="1" then
		PLAYER_GOLD = GetPlayerResource(PLAYER_1, GOLD);
		SetPlayerResource(PLAYER_1, GOLD, PLAYER_GOLD + 10000);
	end
end;

function OwnedTowns(player)
	local count = 0;
	for i, town in { 'Merlon', 'Stormdale', 'Chillbury', 'Vigil' } do
		if GetObjectOwner(town) == player then
			count = count + 1
		end
	end
	return count;
end

function IsArantirReadyForRitual()
	if OwnedTowns(PLAYER_1) < 4 then return end;
	for i=1,4 do
		local sacrifice = GetObjectsInRegion( "Ritual_"..i, OBJECT_HERO );
		if table.length(sacrifice) == 0 or sacrifice[0] == 'RedHeavenHero03' or sacrifice[0] == 'Arantir' then return end;
	end
	if ( IsHeroInRitualZone( 'OrnellaNecro' ) == nil ) then return end;
	return 1;
end

function IsHeroInRitualZone( hero )
	if ( IsObjectInRegion( hero, 'Ritual_1' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( hero, 'Ritual_2' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( hero, 'Ritual_3' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( hero, 'Ritual_4' ) == not nil ) then return not nil end;
	return nil;
end

function SetupInfernalWaveHeroes(diff)
	if diff > 1 then
		ChangeHeroStat("Jazaz", STAT_EXPERIENCE, 42700);
		GiveHeroSkill("Jazaz", SKILL_GATING);
		GiveHeroSkill ("Jazaz", PERK_DEMONIC_FIRE);
		GiveHeroSkill ("Jazaz", DEMON_FEAT_DEMONIC_RETALIATION);
		TeachHeroSpell("Jazaz", SPELL_ICE_BOLT);
		TeachHeroSpell("Jazaz", SPELL_LIGHTNING_BOLT);	
		TeachHeroSpell("Jazaz", SPELL_STONE_SPIKES);
		ChangeHeroStat("Grok", STAT_EXPERIENCE, 70500);
		GiveHeroSkill("Grok", SKILL_GATING);
		GiveHeroSkill ("Grok", PERK_DEMONIC_FIRE);
		GiveHeroSkill ("Grok", DEMON_FEAT_DEMONIC_RETALIATION);
		ChangeHeroStat("Oddrema", STAT_EXPERIENCE, 123000);
		ChangeHeroStat("Deleb", STAT_EXPERIENCE, 176000);
	end
	if diff > 2 then
		ChangeHeroStat("Jazaz", STAT_EXPERIENCE, 85300);
		GiveHeroSkill("Jazaz", SKILL_GATING);
		TeachHeroSpell("Jazaz", SPELL_FROST_RING);
		TeachHeroSpell("Jazaz", SPELL_CHAIN_LIGHTNING);	
		TeachHeroSpell("Jazaz", SPELL_METEOR_SHOWER);
		ChangeHeroStat("Grok", STAT_EXPERIENCE, 147000);
		GiveHeroSkill("Grok", SKILL_GATING);	
		ChangeHeroStat("Oddrema", STAT_EXPERIENCE, 253000);	
		ChangeHeroStat("Deleb", STAT_EXPERIENCE, 363000);
	end
	if diff > 3 then
		ChangeHeroStat("Jazaz", STAT_EXPERIENCE, 176000);
		GiveHeroSkill("Jazaz", SKILL_GATING);
		TeachHeroSpell("Jazaz", SPELL_IMPLOSION);
		TeachHeroSpell("Jazaz", SPELL_DEEP_FREEZE);			
		ChangeHeroStat("Grok", STAT_EXPERIENCE, 304000);
		GiveHeroSkill("Grok", SKILL_GATING);		
		ChangeHeroStat("Oddrema", STAT_EXPERIENCE, 518000);	
		ChangeHeroStat("Deleb", STAT_EXPERIENCE, 744000);
		TeachHeroSpell("Deleb", SPELL_IMPLOSION);		
	end
	ChangeHeroStat("Jazaz", STAT_ATTACK, 5 * diff);
	ChangeHeroStat("Jazaz", STAT_DEFENCE, 4 * diff);
	ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 3 * diff);
	ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 2* diff);	
	ChangeHeroStat("Grok", STAT_ATTACK, 3 * diff);
	ChangeHeroStat("Grok", STAT_DEFENCE, 2 * diff);
	ChangeHeroStat("Grok", STAT_SPELL_POWER, 5 * diff);
	ChangeHeroStat("Grok", STAT_KNOWLEDGE, 4 * diff);
	ChangeHeroStat("Oddrema", STAT_ATTACK, 3 * diff);
	ChangeHeroStat("Oddrema", STAT_DEFENCE, 2 * diff);
	ChangeHeroStat("Oddrema", STAT_SPELL_POWER, 5 * diff);
	ChangeHeroStat("Oddrema", STAT_KNOWLEDGE, 4 * diff);
	ChangeHeroStat("Deleb", STAT_ATTACK, 3 * diff);
	ChangeHeroStat("Deleb", STAT_DEFENCE, 2 * diff);
	ChangeHeroStat("Deleb", STAT_SPELL_POWER, 5 * diff);
	ChangeHeroStat("Deleb", STAT_KNOWLEDGE, 4 * diff);
end

function SetupGarrisions(diff)
	AddObjectCreatures("Garrison_ost", CREATURE_BATTLE_GRIFFIN , 52 * diff);
	AddObjectCreatures("Garrison_ost", CREATURE_VINDICATOR, 80 * diff);
	AddObjectCreatures("Garrison_ost", CREATURE_LONGBOWMAN, 126 * diff);
	AddObjectCreatures("Garrison_ost", CREATURE_ZEALOT, 26 * diff);	
	
	AddObjectCreatures("Garrison_center", CREATURE_VINDICATOR, 80 * diff);
	AddObjectCreatures("Garrison_center", CREATURE_LONGBOWMAN, 126 * diff);
	AddObjectCreatures("Garrison_center", CREATURE_CHAMPION, 42 * diff);	
	AddObjectCreatures("Garrison_center", CREATURE_ZEALOT, 52 * diff);	
	
	AddObjectCreatures("Garrison_sud_west", CREATURE_LONGBOWMAN, 75 * diff);
	AddObjectCreatures("Garrison_sud_west", CREATURE_VINDICATOR, 55 * diff);
	AddObjectCreatures("Garrison_sud_west", CREATURE_CHAMPION , 15 * diff);
	AddObjectCreatures("Garrison_sud_west", CREATURE_LANDLORD , 128 * diff);
	
	AddObjectCreatures("Garrison_center_nord", CREATURE_BATTLE_GRIFFIN, 32 * diff);
	AddObjectCreatures("Garrison_center_nord", CREATURE_ZEALOT, 21 * diff);
	AddObjectCreatures("Garrison_center_nord", CREATURE_VINDICATOR, 72 * diff);
	AddObjectCreatures("Garrison_center_nord", CREATURE_CHAMPION, 12 * diff);

	AddObjectCreatures("Garrison_nord", CREATURE_SERAPH, 14 * diff);
	AddObjectCreatures("Garrison_nord", CREATURE_CHAMPION, 28 * diff);
	AddObjectCreatures("Garrison_nord", CREATURE_BATTLE_GRIFFIN, 74 * diff);
end

FEDEX_DELIVERY = {
	[1] = { CREATURE_BONE_DRAGON, 2, CREATURE_WIGHT, 4, 		CREATURE_LICH, 6, CREATURE_VAMPIRE, 10, CREATURE_MANES, 18, CREATURE_WALKING_DEAD, 32, CREATURE_SKELETON, 50 }, -- normal
	[2] = { CREATURE_BONE_DRAGON, 1, CREATURE_WIGHT, 2, 	    CREATURE_LICH,  3, CREATURE_VAMPIRE,  5, CREATURE_MANES,  9, CREATURE_WALKING_DEAD, 16, CREATURE_SKELETON, 25 }, -- hard
	[3] = { 	CREATURE_VAMPIRE, 3, CREATURE_LICH, 2, CREATURE_DEATH_KNIGHT,  1 }, -- heroic
	[4] = {		   CREATURE_LICH, 1, CREATURE_VAMPIRE, 2 }, -- impossible
};

DIFFICULTY = {
	[0] = function()
		diff = 1;
		CreateArtifact("", ARTIFACT_LION_HIDE_CAPE , 138, 7, GROUND);
		SetObjectCreatures( 'Final_gift', CREATURE_DEATH_KNIGHT, 60 );
		SetObjectCreatures( 'Final_gift', CREATURE_MUMMY, 120 );
		SetObjectCreatures( 'Final_gift', CREATURE_ZOMBIE, 430 );	
		AddObjectCreatures('Nergal-shum', CREATURE_BONE_DRAGON, 7);
		AddObjectCreatures('Nergal-shum', CREATURE_WIGHT, 14);
		AddObjectCreatures('Nergal-shum', CREATURE_LICH, 20);
		AddObjectCreatures('Nergal-shum', CREATURE_DEATH_KNIGHT, 12);
		AddObjectCreatures('Nergal-shum', CREATURE_MUMMY, 20);	
		AddObjectCreatures('Chillbury', CREATURE_ARCHER, 30);
		AddObjectCreatures('Chillbury', CREATURE_FOOTMAN, 18);
		AddObjectCreatures('Vigil', CREATURE_ARCHER, 30);
		AddObjectCreatures('Vigil', CREATURE_FOOTMAN, 18);
		print("Difficulty Level is NORMAL");
	end,
	
	[1] = function()
		diff = 2;
		SetObjectCreatures( 'Final_gift', CREATURE_DEATH_KNIGHT, 40 );
		SetObjectCreatures( 'Final_gift', CREATURE_MUMMY, 120 );
		SetObjectCreatures( 'Final_gift', CREATURE_ZOMBIE, 430 );	
		AddObjectCreatures('Nergal-shum', CREATURE_LICH, 15);
		AddObjectCreatures('Nergal-shum', CREATURE_DEATH_KNIGHT, 8);
		AddObjectCreatures('Nergal-shum', CREATURE_MUMMY, 15);	
		AddObjectCreatures('Chillbury', CREATURE_ARCHER, 30);
		AddObjectCreatures('Chillbury', CREATURE_FOOTMAN, 18);
		AddObjectCreatures('Chillbury', CREATURE_GRIFFIN, 10);
		AddObjectCreatures('Vigil', CREATURE_ARCHER, 30);
		AddObjectCreatures('Vigil', CREATURE_FOOTMAN, 18);
		AddObjectCreatures('Vigil', CREATURE_GRIFFIN, 10);
		AddHeroCreatures("Efion", CREATURE_PIT_SPAWN, 2);
		AddHeroCreatures("Efion", CREATURE_BALOR, 2);
		AddHeroCreatures("Efion", CREATURE_PIT_FIEND, 2);
		GiveExp("RedHeavenHero01", 147000);
		ChangeHeroStat("RedHeavenHero01", STAT_ATTACK, 5);
		ChangeHeroStat("RedHeavenHero01", STAT_DEFENCE, 5);	
		ChangeHeroStat("RedHeavenHero01", STAT_SPELL_POWER, 2);		
		ChangeHeroStat("RedHeavenHero01", STAT_KNOWLEDGE, 2);			
		GiveExp("RedHeavenHero05", 147000);
		ChangeHeroStat("RedHeavenHero05", STAT_ATTACK, 5);
		ChangeHeroStat("RedHeavenHero05", STAT_DEFENCE, 5);	
		ChangeHeroStat("RedHeavenHero05", STAT_SPELL_POWER, 2);		
		ChangeHeroStat("RedHeavenHero05", STAT_KNOWLEDGE, 2);	
		print("Difficulty Level is HARD");
	end,
	
	[2] = function()
		diff = 3;
		SetObjectCreatures( 'Final_gift', CREATURE_DEATH_KNIGHT, 25 );
		SetObjectCreatures( 'Final_gift', CREATURE_MUMMY, 90 );
		SetObjectCreatures( 'Final_gift', CREATURE_ZOMBIE, 360 );	
		AddObjectCreatures('Nergal-shum', CREATURE_DEATH_KNIGHT, 6);
		AddObjectCreatures('Nergal-shum', CREATURE_MUMMY, 8);
		AddObjectCreatures('Chillbury', CREATURE_ARCHER, 30);
		AddObjectCreatures('Chillbury', CREATURE_FOOTMAN, 18);
		AddObjectCreatures('Chillbury', CREATURE_GRIFFIN, 10);
		AddObjectCreatures('Chillbury', CREATURE_PRIEST, 6);
		AddObjectCreatures('Vigil', CREATURE_ARCHER, 30);
		AddObjectCreatures('Vigil', CREATURE_FOOTMAN, 18);
		AddObjectCreatures('Vigil', CREATURE_GRIFFIN, 10);
		AddObjectCreatures('Vigil', CREATURE_PRIEST, 6);
		AddHeroCreatures("Efion", CREATURE_PIT_SPAWN, 4);
		AddHeroCreatures("Efion", CREATURE_BALOR, 4);
		AddHeroCreatures("Efion", CREATURE_PIT_FIEND, 4);
		GiveExp("RedHeavenHero01", 451000);
		ChangeHeroStat("RedHeavenHero01", STAT_ATTACK, 10);
		ChangeHeroStat("RedHeavenHero01", STAT_DEFENCE, 10);	
		ChangeHeroStat("RedHeavenHero01", STAT_SPELL_POWER, 4);		
		ChangeHeroStat("RedHeavenHero01", STAT_KNOWLEDGE, 4);		
		GiveExp("RedHeavenHero05", 451000);	
		ChangeHeroStat("RedHeavenHero05", STAT_ATTACK, 10);
		ChangeHeroStat("RedHeavenHero05", STAT_DEFENCE, 10);	
		ChangeHeroStat("RedHeavenHero05", STAT_SPELL_POWER, 4);		
		ChangeHeroStat("RedHeavenHero05", STAT_KNOWLEDGE, 4);		
		print("Difficulty Level is HEROIC");
	end,
	
	[3] = function()
		diff = 4;
		SetObjectCreatures( 'Final_gift', CREATURE_DEATH_KNIGHT, 15 );
		SetObjectCreatures( 'Final_gift', CREATURE_MUMMY, 70 );
		SetObjectCreatures( 'Final_gift', CREATURE_ZOMBIE, 300 );
		AddObjectCreatures('Nergal-shum', CREATURE_LICH, 2);
		AddObjectCreatures('Nergal-shum', CREATURE_DEATH_KNIGHT, 1);
		AddObjectCreatures('Nergal-shum', CREATURE_MUMMY, 2);
		AddObjectCreatures('Chillbury', CREATURE_ARCHER, 45);
		AddObjectCreatures('Chillbury', CREATURE_FOOTMAN, 27);
		AddObjectCreatures('Chillbury', CREATURE_GRIFFIN, 15);
		AddObjectCreatures('Chillbury', CREATURE_PRIEST, 9);
		AddObjectCreatures('Chillbury', CREATURE_CAVALIER, 6);
		AddObjectCreatures('Vigil', CREATURE_ARCHER, 45);
		AddObjectCreatures('Vigil', CREATURE_FOOTMAN, 27);
		AddObjectCreatures('Vigil', CREATURE_GRIFFIN, 15);
		AddObjectCreatures('Vigil', CREATURE_PRIEST, 9);
		AddObjectCreatures('Vigil', CREATURE_CAVALIER, 6);
		AddHeroCreatures("Efion", CREATURE_PIT_SPAWN, 6);
		AddHeroCreatures("Efion", CREATURE_BALOR, 6);
		AddHeroCreatures("Efion", CREATURE_PIT_FIEND, 6);
		GiveExp("RedHeavenHero01", 1071000);
		ChangeHeroStat("RedHeavenHero01", STAT_ATTACK, 15);
		ChangeHeroStat("RedHeavenHero01", STAT_DEFENCE, 15);	
		ChangeHeroStat("RedHeavenHero01", STAT_SPELL_POWER, 6);		
		ChangeHeroStat("RedHeavenHero01", STAT_KNOWLEDGE, 6);			
		GiveExp("RedHeavenHero05", 1071000);
		ChangeHeroStat("RedHeavenHero05", STAT_ATTACK, 15);
		ChangeHeroStat("RedHeavenHero05", STAT_DEFENCE, 15);	
		ChangeHeroStat("RedHeavenHero05", STAT_SPELL_POWER, 6);		
		ChangeHeroStat("RedHeavenHero05", STAT_KNOWLEDGE, 6);		
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

OBJECTIVES = {
	state = {
	   ArantirIsAlive 	  	 = { "pri1", 1 },		-- Arantir must survive
	   captureFlammshrein 	 = { "pri2", 1 },		-- Capture town of Flammschrein
	   findOracle			 = { "pri3", 0 },		-- 
	   removeMagicBarrier	 = { "pri4", 0 },		-- Disable the magic barrier on the garrison
	   OrnellaIsAlive		 = { "pri5", 1 },		-- Ornella must survive
	   defeatMochab			 = { "pri6", 1 },		-- 
	   destroyPortal		 = { "sec1", 1 },		--
	   avengeTheGhost		 = { "sec2", 0 },		-- kill the killers of ghost of Flammschrein
	   killPaladinSoulKeeper = { "sec3", 0 },   	-- free Paladin ghost by killing the demon Soulkeeper (1-2 active, 10 completed)
	   eventManager		 	 = {    "_", 1 }, 		-- controls release of reserved heroes
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		InitTeleportsPairs();
		GameVarBonus();
		SetPlayerStartResources( PLAYER_2, 240, 240, 80, 140, 80, 80, 100000 );
		SetPlayerStartResources( PLAYER_3,  80,  80, 30,  45, 30, 30,  40000 );
		OpenCircleFog(165, 39, 0, 3, 1);
		UnreserveHero('Gles');
		UnreserveHero('Effig');
		MakeHeroReturnToTavernAfterDeath( 'Gles', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'Effig', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'Muscip', 1 ); -- Возвращение героя в таверну
		AllowPlayerTavernHero( PLAYER_1, 'Gles', 1 );
		AllowPlayerTavernHero( PLAYER_1, 'Effig', 1 );
		UnreserveHero('RedHeavenHero04'); -- Заменить на скриптовое рождение если Ai будет тупить.
		UnreserveHero('RedHeavenHero02'); -- Заменить на скриптовое рождение если Ai будет тупить.
		UnreserveHero('RedHeavenHero06'); -- Заменить на скриптовое рождение если Ai будет тупить.
		AllowPlayerTavernHero( PLAYER_2, 'RedHeavenHero04', 1 );
		AllowPlayerTavernHero( PLAYER_2, 'RedHeavenHero02', 1 );
		AllowPlayerTavernHero( PLAYER_2, 'RedHeavenHero06', 1 );
		MakeHeroReturnToTavernAfterDeath( 'RedHeavenHero04', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'RedHeavenHero02', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'RedHeavenHero06', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'RedHeavenHero05', 1 ); -- Возвращение героя в таверну
		MakeHeroReturnToTavernAfterDeath( 'RedHeavenHero01', 1 ); -- Возвращение героя в таверну
		AllowPlayerTavernHero( PLAYER_3,   'Jazaz', 1 );
		AllowPlayerTavernHero( PLAYER_3, 	'Grok', 1 );
		AllowPlayerTavernHero( PLAYER_3, 'Oddrema', 1 );
		AllowPlayerTavernHero( PLAYER_3,   'Deleb', 1 );
		DenyAIHeroFlee(	 	 'Arantir', not nil );
		DenyAIHeroFlee( 'OrnellaNecro', not nil );
		EnableHeroAI('Efion', nil);
		SetRegionBlocked("1_block_zone_for_player2", 1, PLAYER_2);
		SetRegionBlocked("1_block_zone_for_player3", 1, PLAYER_3);
		SetRegionBlocked("2_block_zone_for_player2", 1, PLAYER_2);
		SetRegionBlocked("2_block_zone_for_player3", 1, PLAYER_3);
		SetRegionBlocked("3_block_zone_for_player3", 1, PLAYER_3);
		SetRegionBlocked("3_block_zone_for_player2", 1, PLAYER_2);
		SetRegionBlocked("4_block_zone_for_player2", 1, PLAYER_2);
		for i = 1, 6 do 
			SetRegionBlocked(i.."_block_zone_for_AI_players", 1, PLAYER_2);
			SetRegionBlocked(i.."_block_zone_for_AI_players", 1, PLAYER_3);
		end
		SetRegionBlocked("Alarm_succubus", 1, PLAYER_2);
		SetRegionBlocked("Alarm_succubus", 1, PLAYER_3);
		SetRegionBlocked("Stop_for_player", 1, PLAYER_2);
		SetRegionBlocked("Stop_for_player", 1, PLAYER_3);
		SetRegionBlocked("Temp_block_player2", 1, PLAYER_2);
		SetRegionBlocked("Temp_block_player2_2", 1, PLAYER_2);
		for i = 1, 13 do
			SetRegionBlocked("Block_teleport_"..i, 1, PLAYER_2);
			SetRegionBlocked("Block_teleport_"..i, 1, PLAYER_3);
		end
		SetRegionBlocked( "Start_west_block", 1, PLAYER_2 ); -- Стартовая временная блокировка у западного города
		SetRegionBlocked(  "Start_ost_block", 1, PLAYER_2 ); -- Стартовая временная блокировка у восточного города
		SetDisabledObjectMode( 'Assasin' , DISABLED_ATTACK );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Assasin', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_004.txt')");
		SetObjectEnabled('Assasin', nil);
		SetDisabledObjectMode( 'Paladin' , DISABLED_INTERACT );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Paladin', "f_meet_paladin");
		SetObjectEnabled('Paladin', nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Soulkeeper_speaks_go_away", "f_show_message_soulkeeper_speak_go_away_023");
		SetDisabledObjectMode( 'Tomb' , DISABLED_INTERACT );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Tomb', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_010.txt')");
		SetObjectEnabled('Tomb', nil);
		SetDisabledObjectMode( 'Gate_to_Flammschrein' , DISABLED_INTERACT );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Gate_to_Flammschrein', "visitMagicBarrier");
		SetObjectEnabled('Gate_to_Flammschrein', nil);
		SetDisabledObjectMode( 'Teleport_to_gold', DISABLED_INTERACT );
		SetDisabledObjectMode( 'Teleport_to_hero', DISABLED_INTERACT );
		SetDisabledObjectMode( 'Teleport_to_trees', DISABLED_INTERACT );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_gold', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_007.txt')");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_hero', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_007.txt')");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_trees', "MessageBox('/Maps/Scenario/A2C1M5/messagebox_007.txt')");
		SetObjectEnabled('Teleport_to_gold', nil);
		SetObjectEnabled('Teleport_to_hero', nil);
		SetObjectEnabled('Teleport_to_trees', nil);
		Trigger(OBJECT_CAPTURE_TRIGGER,			 'Garrison_ost', 	"f_activate_castle_Merlon" ); -- defeat the bottom (right) garrison unlocks AI access top->bottom map
		Trigger(OBJECT_CAPTURE_TRIGGER,		'Garrison_sud_west', 	"f_activate_castle_Merlon" ); -- defeat the bottom (left) garrison unlocks AI access top->bottom map
		Trigger(OBJECT_CAPTURE_TRIGGER, 		'Garrison_nord',  "f_activate_castle_Stormdale" ); -- defeat the top (left) garrison activates AI town Merlon (Top-center)
		Trigger(OBJECT_CAPTURE_TRIGGER,  'Garrison_center_nord',  "f_activate_castle_Stormdale" ); -- defeat the top (right) garrison activates AI town Merlon (Top-center)
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Alarm_succubus", "SuccubusTurnsToFire");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Sign1', "OpenCircleFog(115, 81, 0, 3, 1)" );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Sign2', "OpenCircleFog(123, 124, 0, 3, 1)" );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Sign3', "OpenCircleFog(137, 128, 0, 9, 1)" );
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mummy_speaks", "mumiesFinalPlead");
		SetDisabledObjectMode( 'Ritual_Succubus', DISABLED_ATTACK );
		SetObjectEnabled('Ritual_Succubus', nil);
		SetDisabledObjectMode( 'Final_gift', DISABLED_INTERACT );
		Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, "f_add_creatures_to_prisoner");
		for i = 15,21 do
			SetDisabledObjectMode( 'In'..i, DISABLED_INTERACT );   	-- disable portal entries
			SetDisabledObjectMode( 'Out'..i, DISABLED_INTERACT );	-- disable portal exits
		end		
		SetDisabledObjectMode( 'Inferno_altar' , DISABLED_INTERACT );
		SetObjectEnabled('Inferno_altar', nil);
		DIFFICULTY[GetDifficulty()]();
		SetRegionBlocked( "RegionToArantir", not nil ); -- keep it locked for CINEMA purposes (teleporting Arantir there);
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", "CINEMATICS.meetGhostDaughterValeria");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", "f_save");
		SetupGarrisions(diff);
		SetupInfernalWaveHeroes(diff);
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
			
			if GetObjectiveState("pri1") == OBJECTIVE_FAILED or GetObjectiveState("pri5") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("pri2") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				SaveHeroAllSetArtifactsEquipped(      "Arantir", "A2C1M4" );
				SaveHeroAllSetArtifactsEquipped( "OrnellaNecro", "A2C1M4" );
				sleep(100);
				Win();
				return
			end
		end
	end,
		
	ArantirIsAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.ArantirIsAlive[2] == 1 and IsHeroAlive("Arantir") == nil then
			SetObjectiveState("pri1", OBJECTIVE_FAILED );
			OBJECTIVES.state.ArantirIsAlive[2] = 11;
		end
	end,
	
	captureFlammshrein = function()
		if OBJECTIVES.state.captureFlammshrein[2] == 1 then
			SetObjectiveState( 'pri2', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureFlammshrein[2] = 2;
		elseif OBJECTIVES.state.captureFlammshrein[2] == 2 and GetObjectOwner('Flammschrein') == PLAYER_1 then
			SetObjectiveState( "pri2", OBJECTIVE_COMPLETED );
			OpenCircleFog(158, 156, 0, 15, 1);		
			sleep(15);
			MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);		
			sleep(15);
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			sleep(15);
			Play2DSound( "/Sounds/_(Sound)/Spells/Earthquake.xdb#xpointer(/Sound)" ); ----------------DESTROY_FLAMM_SDN
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			sleep(15);
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
			sleep(15);
			SetAmbientLight(0, "Default", not nil, 1);		
			sleep(50);
			OBJECTIVES.state.captureFlammshrein[2] = 10;
		end
	end,
	
	removeMagicBarrier = function()
		if OBJECTIVES.state.removeMagicBarrier[2] == 1 then
			SetObjectiveState( 'pri4', OBJECTIVE_ACTIVE );
			CINEMATICS.meetGhost();
			OBJECTIVES.state.removeMagicBarrier[2] = 2;
		elseif OBJECTIVES.state.removeMagicBarrier[2] == 2 and IsArantirReadyForRitual() ~= nil then
			CINEMATICS.ArantirTalkToOrnella();
			CINEMATICS.performRitual();
			SetObjectiveState( "pri4", OBJECTIVE_COMPLETED );
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, '1_block_zone_for_player2', nil);
			SetObjectEnabled( 'Gate_to_Flammschrein', not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Gate_to_Flammschrein', nil);
			OBJECTIVES.state.removeMagicBarrier[2] = 10;
		end
	end,
	
	OrnellaIsAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.OrnellaIsAlive[2] == 1 and IsHeroAlive("OrnellaNecro") == nil then
			SetObjectiveState( "pri5", OBJECTIVE_FAILED );
			OBJECTIVES.state.OrnellaIsAlive[2] = 11;
		elseif OBJECTIVES.state.OrnellaIsAlive[2] == 2 then
			SetObjectiveVisible( "pri5", nil );
			OBJECTIVES.state.OrnellaIsAlive[2] = 10;
		end		
	end,

	defeatMochab = function()
		if OBJECTIVES.state.defeatMochab[2] == 1 and GetObjectOwner('Gate_to_Flammschrein') == PLAYER_1 then
			CINEMATICS.meetMochab();
			SetObjectiveState( 'pri6', OBJECTIVE_ACTIVE );	
			OBJECTIVES.state.defeatMochab[2] = 2;
		elseif OBJECTIVES.state.defeatMochab[2] == 2 and IsHeroAlive('Orlando') == nil then
			SetObjectiveState( 'pri6', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatMochab[2] = 10;
		end
	end,
	
	destroyPortal_destroyer = "Arantir",
	destroyPortal_spawns = { 'Jazaz', 'Grok', 'Oddrema', 'Deleb' },
	destroyPortal = function()
		if OBJECTIVES.state.destroyPortal[2] == 2 then
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE );
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Alarm_succubus", nil);
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Fire_hug", nil);	
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Inferno_altar', "f_ready_destroy_altar");
			OBJECTIVES.state.destroyPortal[2] = 3;
		elseif OBJECTIVES.state.destroyPortal[2] == 4 then
			CINEMATICS.destroyPortal();	
			SetObjectiveState('sec1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.destroyPortal[2] = 10;
		end
		
		local count = OwnedTowns(PLAYER_1);
		local hero = OBJECTIVES.destroyPortal_spawns[count];
		if hero ~= nil  then
			DeployReserveHero(hero, 18, 140, GROUND);
			sleep(30);
			UnreserveHero(hero);
			SetupInfernalHeroArmy(hero, diff);
			H55c_AIAddHero( hero );
			OBJECTIVES.destroyPortal_spawns[count] = nil;
		end
	end,
	
	avengeTheGhost = function()
		if OBJECTIVES.state.avengeTheGhost[2] == 1 then
			Trigger(OBJECT_TOUCH_TRIGGER, 'Assasin', nil);
			MessageBox("/Maps/Scenario/A2C1M5/messagebox_003.txt");
			Trigger(OBJECT_TOUCH_TRIGGER, 'Assasin', "meetAssassins");
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE );
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", "returnToGhost"); -- Ghost killers are still alive;
			CINEMATICS.showAssassins();
			OBJECTIVES.state.avengeTheGhost[2] = 2;
		elseif OBJECTIVES.state.avengeTheGhost[2] == 3 then
			local x_ara, y_ara, floor_ara = GetObjectPosition( 'Arantir' );
			CINEMATICS.meetAssassins();
			QuestionBox("/Maps/Scenario/A2C1M5/messagebox_015.txt", "spareAssassins", "attackAssassins");
			SetObjectPosition( 'Arantir', x_ara, y_ara, floor_ara );
			OBJECTIVES.state.avengeTheGhost[2] = 4;
		elseif OBJECTIVES.state.avengeTheGhost[2] == 5 then
			BlockGame();
			Trigger(OBJECT_TOUCH_TRIGGER, 'Assasin', nil);
			SetObjectEnabled('Assasin', not nil);
			sleep(20);
			MakeHeroInteractWithObject( AvengerName, 'Assasin' );
			UnblockGame();
			OBJECTIVES.state.avengeTheGhost[2] = 6;
		elseif OBJECTIVES.state.avengeTheGhost[2] == 7 then
			SetObjectEnabled('Teleport_to_gold', not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_gold', "UseTreasurePortal");
			SetObjectEnabled('Teleport_to_hero', not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_hero', "UseTreasurePortal");
			SetObjectEnabled('Teleport_to_trees', not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_trees', "UseTreasurePortal");
			SetObjectEnabled('Tomb', not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'Tomb', nil);
			CINEMATICS.ghostReward();
			SetObjectiveState( "sec2", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.avengeTheGhost[2] = 10;
		elseif OBJECTIVES.state.avengeTheGhost[2] == 9 then			
			CINEMATICS.assassinsKillSuccub();
			OBJECTIVES.state.destroyPortal[2] = 2;
			SetObjectiveState( 'sec2', OBJECTIVE_FAILED );
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", "MessageBox('/Maps/Scenario/A2C1M5/messagebox_016.txt')"); -- ghost is doomed, murderers spared
			OBJECTIVES.state.avengeTheGhost[2] = 11;
		end
	end,
	
	killPaladinSoulKeeper = function()
		if OBJECTIVES.state.killPaladinSoulKeeper[2] == 1 then
			SetRegionBlocked("6_block_zone_for_AI_players", nil, PLAYER_1);
			CINEMATICS.meetPaladin();
			SetObjectiveState( 'sec3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.killPaladinSoulKeeper[2] = 2;
		elseif OBJECTIVES.state.killPaladinSoulKeeper[2] == 2 and IsObjectExists('Efion') == nil then
			SetObjectiveState( "sec3", OBJECTIVE_COMPLETED );
			SetObjectPosition( 'Sulfur1', 169, 66, GROUND );	
			CINEMATICS.paladinToDeathKnight();
			OBJECTIVES.state.killPaladinSoulKeeper[2] = 10;
		end
	end,
	
	eventManager_day = 0,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.date >= 29 - 7 * diff then
				SetRegionBlocked( "Start_west_block", nil, PLAYER_2 ); -- Упраздняет блокировку зоны у западного города
				SetRegionBlocked(  "Start_ost_block", nil, PLAYER_2 ); -- Упраздняет блокировку зоны у восточного города
			end
			
			if GetDate( DAY_OF_WEEK ) == 1 then
				A2C1M5_reinforceEvilTown(diff);
			end
			
			if GetDate( DAY_OF_WEEK ) == 5 then
				local car = "caravan"..GetDate(DAY);
				CreateCaravan(car, PLAYER_1, GROUND, 130, 1, GROUND, 136, 14 );
				sleep(10);
				SetObjectRotation(car, 180);
				for i = 1, table.length(FEDEX_DELIVERY[diff]), 2 do
					AddObjectCreatures(car, FEDEX_DELIVERY[diff][i], FEDEX_DELIVERY[diff][i + 1]);
				end
				OpenCircleFog(130, 1, 0, 4, 1);		
				MoveCamera(130, 1, 0, 30, 1, 3.14, 0, 0, 1);
				sleep(30);
				MessageBox("/Maps/Scenario/A2C1M5/messagebox_01"..math.random(2,4)..".txt");
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
startThread( H55c_AI_main );

function a2c1m5_dbg(var)
	if var == 0 then H55_Speedrun(1); end
	if var == 1 then SetObjectPosition("Arantir", 132, 128, 0); end
	if var == 11 then SetObjectPosition("Arantir", 95, 58, 0); end
	if var == 111 then SetObjectPosition("Arantir", 19, 135, 0); end
	if var == 1111 then SetObjectPosition("Arantir", 80, 6, 0); end
	if var == 11111 then SetObjectPosition("Arantir", 137, 152, 0); end
	if var == 2 then 
		for i, town in { 'Merlon', 'Stormdale', 'Chillbury', 'Vigil' } do
			SetObjectOwner(town, 1);
		end
	end
	if var == 22 then 
		for i = 1,4 do
			local x,y,z = RegionToPoint( "Ritual_"..i );
			SetObjectPosition(GetPlayerHeroes(PLAYER_1)[i], x, y, z);
		end
	end
end

function SetupInfernalHeroArmy(hero, coef)
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetObjectCreatures(hero, creatureID);
		if CreatureSetUp > 1 then
			RemoveObjectCreatures(hero, creatureID, CreatureSetUp);
			AddObjectCreatures(hero, creatureID, CreatureSetUp * coef);
		end
	end
end