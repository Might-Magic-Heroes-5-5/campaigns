doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,2,2,2,2,2,1,2};
H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_UNICORN_HORN_BOW,
	ARTIFACT_PLATE_MAIL_OF_STABILITY,
	ARTIFACT_PEDANT_OF_MASTERY,
	ARTIFACT_RING_OF_LIFE,
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M4");
    LoadHeroAllSetArtifacts( "Heam", "C5M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Heam" );
end

function CollectArtifact()
	OBJECTIVES.state.collectArtifacts[2] = OBJECTIVES.state.collectArtifacts[2] + 1;
end

function ComeToTieruIsland()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Tieru_Island', nil );
    OBJECTIVES.state.findTieru[2] = 2;
end

function meetTieru()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Jazaz_Here', nil );
	OBJECTIVES.state.saveTieru[2] = 3;
end

function TieruDeath()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', nil );
	OBJECTIVES.state.saveTieru[2] = 5;
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C5/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	findTieruIsland = function()
		StartDialogScene("/DialogScenes/C5/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	demonAttack = function()
		BlockGame();
		MoveHeroRealTime('Biara', RegionToPoint('Biara_Here'));
		sleep( 10 );
		MoveHeroRealTime('Jazaz', RegionToPoint('Jazaz_Here'));
		sleep( 15 );	
		UnblockGame();
	end,
	
	goToTieru = function()
		BlockGame();
		leftmove = GetHeroStat( 'Heam', STAT_MOVE_POINTS );
		ChangeHeroStat( 'Heam', STAT_MOVE_POINTS,1000000 );
		MoveHeroRealTime( 'Heam', RegionToPoint('Heam_Here') );
		SetStandState('TieruHut', 1);
		x, y, z = RegionToPoint('Biara_Here');
		MoveCamera(x, y, z, 65, 3.14/4, 3.14/2+(3.14/6));
		MoveHeroRealTime('Biara', RegionToPoint('Biara_Step_Here'));
		sleep( 160 );
		x, y, z = RegionToPoint('Teleport_Here');
		y=y+0.5;
		SetObjectPosition ('Biara', x,y,z);
		ChangeHeroStat('Heam', STAT_MOVE_POINTS, -1000000);
		ChangeHeroStat('Heam', STAT_MOVE_POINTS, leftmove);
		UnblockGame();
	end,
	
	deathOfTieru = function()
		StartDialogScene("/DialogScenes/C5/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/C5/M4/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
		RemoveObject ('1alpha-wight');
		RemoveObject ('6alpha-water');	
		RemoveObject ('beta-liches');	
		RemoveObject ('Delta-wight');
	end,
	
	[1] = function()
		diff = 2;
		RemoveObject ('1alpha-wight');
		RemoveObject ('6alpha-water');	
		RemoveObject ('beta-liches');	
		RemoveObject ('Delta-wight');
	end,
	
	[2] = function()
		diff = 3;
		RemoveObject ('1alpha-wight');
		RemoveObject ('6alpha-water');
		RemoveObject ('J-treant');
		AddObjectCreatures('earth_elem', CREATURE_EARTH_ELEMENTAL, 5);
		AddObjectCreatures('fire_demons', CREATURE_HORNED_DEMON, 20);
		AddObjectCreatures('C-golem', CREATURE_STEEL_GOLEM, 140); --ohrana mashinnogo depo
		AddObjectCreatures('J-cerber', CREATURE_CERBERI, 50); -- ohrana spell powera
		AddObjectCreatures('K-dragon', CREATURE_SHADOW_DRAGON, 8); -- ohrana Ring of Life
		AddObjectCreatures('Delta-matron', CREATURE_MATRON, 3); -- podzemley. ohrana kmowlege
	end,
	
	[3] = function()
		diff = 4;
		RemoveObject ('L1-sprites');
		RemoveObject ('J-treant');
		AddObjectCreatures('earth_elem', CREATURE_EARTH_ELEMENTAL, 10); -- podzemniy prohod
		AddObjectCreatures('fire_demons', CREATURE_HORNED_DEMON, 40);
		AddObjectCreatures('C-golem', CREATURE_STEEL_GOLEM, 200); --ohrana mashinnogo depo
		AddObjectCreatures('C-golem2', CREATURE_IRON_GOLEM, 240); --ohrana spell-powera
		AddObjectCreatures('J-cerber', CREATURE_CERBERI, 100); -- ohrana spell powera
		AddObjectCreatures('Gamma-priest', CREATURE_PRIEST, 20); -- podzemley. ohrana nichki
		AddObjectCreatures('Gamma-nightmare', CREATURE_FRIGHTFUL_NIGHTMARE, 35); -- podzemley. ohrana areni
		AddObjectCreatures('K-dragon', CREATURE_SHADOW_DRAGON, 16); -- ohrana Ring of Life
		AddObjectCreatures('Delta-matron', CREATURE_MATRON, 5); -- podzemley. ohrana kmowlege
		AddObjectCreatures('Delta-wight', CREATURE_WIGHT, 20); -- podzemley. mob na hodu
	end,
}

OBJECTIVES = {
	state = {
			   findTieru = { "prim1", 1 }, -- Find Tieru 
			   saveTieru = { "prim2", 0 }, -- Try to save Tieru 
			 defeatBiara = { "prim3", 0 }, -- Defeat Biara in battle
		collectArtifacts = {  "Sec1", 1 }, -- Collect all 4 artifacts
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		startThread( H55_InitSetArtifacts );
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0 );
		CINEMATICS.intro();
		startThread( DIFFICULTY[GetDifficulty()] );
		Trigger( OBJECT_TOUCH_TRIGGER, 				'Armor', 'CollectArtifact' );
		Trigger( OBJECT_TOUCH_TRIGGER, 'Pendant_of_Mastery', 'CollectArtifact' );
		Trigger( OBJECT_TOUCH_TRIGGER, 				  'Bow', 'CollectArtifact' );
		Trigger( OBJECT_TOUCH_TRIGGER, 		 'Ring_of_Life', 'CollectArtifact' );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Tieru_Island', 'ComeToTieruIsland' );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   'Jazaz_Here',  'meetTieru' );
    end,

    run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			-- Loss of the mission is handled by C5M4.xdb
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	findTieru = function()
	-- start of this task is handled by C5M4.xdb
		if OBJECTIVES.state.findTieru[2] == 2 then
			CINEMATICS.findTieruIsland();
			SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.saveTieru[2] = 1;
			OBJECTIVES.state.findTieru[2] = 10;
		end
	end,
	
	saveTieru = function()
		if OBJECTIVES.state.saveTieru[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			DeployReserveHero( 'Jazaz', RegionToPoint('Jazaz_Deploy_Here') );
			DeployReserveHero( 'Biara', RegionToPoint('Biara_Deploy_Here') );
			x, y, z = RegionToPoint('Biara_Here');
			OpenCircleFog(x, y, z, 11, PLAYER_1);
			x, y, z = RegionToPoint('Biara_Deploy_Here');
			OpenCircleFog(x, y, z, 8, PLAYER_1);
			x, y, z = RegionToPoint('Jazaz_Here');
			OpenCircleFog(x, y, z, 8, PLAYER_2);
			sleep(15);
			EnableHeroAI( 'Jazaz', nil );
			EnableHeroAI( 'Biara', nil );
			local ArmyMult = diff + GetDate(MONTH);
			AddHeroCreatures( 'Jazaz',				 CREATURE_BALOR,  2 * ArmyMult ); --- PIT FIENDS
			AddHeroCreatures( 'Jazaz', 			   CREATURE_CERBERI, 15 * ArmyMult ); --- CERBERI
			AddHeroCreatures( 'Jazaz', CREATURE_FRIGHTFUL_NIGHTMARE,  7 * ArmyMult ); --- HELL CHARGERS
			AddHeroCreatures( 'Jazaz', 		  CREATURE_HORNED_DEMON, 20 * ArmyMult ); --- HORNED DEMONS
			AddHeroCreatures( 'Jazaz', 	 		 CREATURE_ARCHDEVIL,  2 * ArmyMult );
			AddHeroCreatures( 'Biara', 	 CREATURE_INFERNAL_SUCCUBUS, 20 * ArmyMult );
			AddHeroCreatures( 'Biara', 	  CREATURE_SUCCUBUS_SEDUCER, 20 * ArmyMult );
			AddHeroCreatures( 'Biara', 	 		  CREATURE_SUCCUBUS, 25 * ArmyMult );
			AddHeroCreatures( 'Biara', 	 		   CREATURE_CERBERI, 30 * ArmyMult );
			SetObjectEnabled('ExitToIsland', nil); -- There is no way back!  -- blokiruem vihod s ostrova.
			Trigger( OBJECT_TOUCH_TRIGGER, 'ExitToIsland', 'MessageBox("/Maps/Scenario/C5M4/Texts/NoWay.txt")' );
			OBJECTIVES.state.saveTieru[2] = 2;
		elseif OBJECTIVES.state.saveTieru[2] == 3 then
			CINEMATICS.demonAttack();
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', 'TieruDeath' );
			OBJECTIVES.state.saveTieru[2] = 4;
		elseif OBJECTIVES.state.saveTieru[2] == 5 then
			CINEMATICS.goToTieru();
			CINEMATICS.deathOfTieru();
			SetObjectiveState( 'prim2', OBJECTIVE_FAILED );
			OBJECTIVES.state.defeatBiara[2] = 1;
			OBJECTIVES.state.saveTieru[2] = 11;
		end
	end,
	
	defeatBiara = function()
		if OBJECTIVES.state.defeatBiara[2] == 1 then
			SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
			x, y, z = RegionToPoint('Teleport_Here');
			OpenCircleFog(x, y, z, 10, PLAYER_1);	
			MoveCamera(x, y, z, 40, 3.14/2, 3.14);
			OBJECTIVES.state.defeatBiara[2] = 2;
		elseif OBJECTIVES.state.defeatBiara[2] == 2 and IsHeroAlive("Biara") == nil then
			SaveHeroAllSetArtifactsEquipped( "Heam", "C5M4" );
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatBiara[2] = 10;
		end
	end,
	
	collectArtifacts_count = 0,
	collectArtifacts = function()
	-- start of this task is handled by C5M4.xdb
		if OBJECTIVES.state.collectArtifacts[2] == 2 then
			OBJECTIVES.collectArtifacts_count = OBJECTIVES.collectArtifacts_count + 1;
			SetObjectiveProgress( 'Sec1', OBJECTIVES.collectArtifacts_count, PLAYER_1 );
			ChangeHeroStat( 'Heam', STAT_EXPERIENCE, OBJECTIVES.collectArtifacts_count*5000 );
			if OBJECTIVES.collectArtifacts_count == 4 then
				OBJECTIVES.state.collectArtifacts[2] = 3;
			else
				OBJECTIVES.state.collectArtifacts[2] = 1;
			end
		elseif OBJECTIVES.state.collectArtifacts[2] == 3 then
			SetObjectiveState( 'Sec1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.collectArtifacts[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );

function c5m4_dbg()
	H55_Speedrun(1);
	SetObjectPosition("Heam", 81, 85, 0 );
end
