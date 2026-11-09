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

function NavalAttack(hero)
	if hero == "Heam" then
		BlockGame()
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'NavalAttack', nil );
		local x, y, z = GetObjectPosition("Oddrema");
		OpenCircleFog( x, y, z, 15, PLAYER_1 );
		MoveCamera( x - 5, y, z, 50, 0.7, 0.5 );
		ChangeHeroStat( "Oddrema", STAT_MOVE_POINTS, 10000 );
		x, y, z = GetObjectPosition("Heam");
		sleep(50);
		MoveHeroRealTime( "Oddrema", x, y, z );
		sleep(20);
		UnblockGame();
	end
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
		ChangeHeroStat( 'Heam', STAT_MOVE_POINTS,10000 );
		MoveHeroRealTime( 'Heam', RegionToPoint('Heam_Here') );
		SetStandState('TieruHut', 1);
		x, y, z = RegionToPoint('Biara_Here');
		MoveCamera(x, y, z, 65, 3.14/4, 3.14/2+(3.14/6));
		MoveHeroRealTime('Biara', RegionToPoint('Biara_Step_Here'));
		x, y, z = RegionToPoint('Teleport_Here');
		y=y+0.5;
		sleep( 115 );
		SetObjectPosition ('Biara', x,y,z);
		sleep( 55 );
		ChangeHeroStat('Heam', STAT_MOVE_POINTS, -10000);
		ChangeHeroStat('Heam', STAT_MOVE_POINTS, leftmove);
		UnblockGame();
	end,
	
	deathOfTieru = function()
		StartDialogScene("/DialogScenes/C5/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	showBiara = function()
		local x, y, z = RegionToPoint('Teleport_Here');
		OpenCircleFog(x, y, z, 10, PLAYER_1);	
		MoveCamera(x, y, z, 40, 3.14/2, 3.14);
		sleep(100);
		x, y, z = GetObjectPosition("Heam");
		MoveCamera(x, y, z, 40, 0.9, 1.1);
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
	end,
	
	[3] = function()
		diff = 4;
		RemoveObject ('L1-sprites');
		RemoveObject ('J-treant');
	end,
}

local neutro = GetDifficulty() + 1
if neutro > 1 then
        -- All those additional names were mostly unused and inside in xdb file, so I just added for higher difficulties more units to keep challenges  
        AddObjectCreatures('Alpha-vampire', CREATURE_VAMPIRE, 55 * GetDifficulty()); -- underground passage
        AddObjectCreatures('1alpha-wight', CREATURE_WIGHT, 8 * GetDifficulty()); -- underground passage		
		
		AddObjectCreatures('beta-liches', CREATURE_LICH, 45 * GetDifficulty()); -- podzemley. mob na hodu/ Underground. Mob on the move.
		
		AddObjectCreatures('Beta-rani', CREATURE_RAKSHASA, 35 * GetDifficulty()); -- podzemley. mob na hodu/ Underground.
		AddObjectCreatures('Beta-genie', CREATURE_MASTER_GENIE, 70 * GetDifficulty());
		AddObjectCreatures('Beta-giant', CREATURE_GIANT, 12 * GetDifficulty());
		
        AddObjectCreatures('C-mages', CREATURE_ARCH_MAGI, 45 * GetDifficulty()); -- ground passage	
        AddObjectCreatures('C-giant', CREATURE_GIANT, 8 * GetDifficulty()); -- ground - hunter hut direction
		AddObjectCreatures('C-golem', CREATURE_STEEL_GOLEM, 150 * GetDifficulty()); --ohrana mashinnogo depo/ war machine factory location
		AddObjectCreatures('C-golem2', CREATURE_IRON_GOLEM, 200 * GetDifficulty()); --ohrana spell-powera/ spellpower location
		
		AddObjectCreatures('D-rider', CREATURE_RIDER, 75 * GetDifficulty()); 
		AddObjectCreatures('D-earth', CREATURE_EARTH_ELEMENTAL, 80 * GetDifficulty()); 
		AddObjectCreatures('D-water', CREATURE_WATER_ELEMENTAL, 80 * GetDifficulty()); 
		AddObjectCreatures('D-devil', CREATURE_DEVIL, 12 * GetDifficulty()); 
		AddObjectCreatures('D-demilich', CREATURE_DEMILICH, 40 * GetDifficulty()); 
		AddObjectCreatures('D-dragon', CREATURE_BLACK_DRAGON, 20 * GetDifficulty()); -- unicorn horn bow location 
		
		AddObjectCreatures('Delta-matron', CREATURE_MATRON, 30 * GetDifficulty()); -- podzemley. ohrana kmowlege/ underground. guarding knowledge 
		AddObjectCreatures('Delta-wight', CREATURE_WIGHT, 50 * GetDifficulty());	
		AddObjectCreatures('Delta-succa', CREATURE_INFERNAL_SUCCUBUS, 125 * GetDifficulty());
		AddObjectCreatures('Delta-fire', CREATURE_FIRE_ELEMENTAL, 125 * GetDifficulty());
		AddObjectCreatures('Delta-nightmare', CREATURE_FRIGHTFUL_NIGHTMARE, 55 * GetDifficulty());
		
		AddObjectCreatures('E-wight', CREATURE_WIGHT, 25 * GetDifficulty()); 
		AddObjectCreatures('E-zombie', CREATURE_ZOMBIE, 350 * GetDifficulty()); 
		AddObjectCreatures('E-skelet-archer', CREATURE_SKELETON_ARCHER, 300 * GetDifficulty()); 
		AddObjectCreatures('E-succa', CREATURE_INFERNAL_SUCCUBUS, 75 * GetDifficulty()); 
		AddObjectCreatures('E-balor', CREATURE_BALOR, 22 * GetDifficulty()); 
		AddObjectCreatures('E-devil', CREATURE_ARCHDEVIL, 15 * GetDifficulty());  -- pendant of mastery location
		
		AddObjectCreatures('Gamma-priest', CREATURE_PRIEST, 22 * GetDifficulty()); -- podzemley. ohrana nichki/ underground. guarding the stash
		AddObjectCreatures('Gamma-nightmare', CREATURE_FRIGHTFUL_NIGHTMARE, 55 * GetDifficulty()); -- podzemley. ohrana areni/ underground. arena location
		AddObjectCreatures('Gamma-minotavr', CREATURE_MINOTAUR_KING, 180 * GetDifficulty());
		
		AddObjectCreatures('J-cerber', CREATURE_CERBERI, 190 * GetDifficulty()); -- ohrana spell powera/ spellpower location
		AddObjectCreatures('J-dknight', CREATURE_DEATH_KNIGHT, 35 * GetDifficulty());	
		AddObjectCreatures('J-zombie', CREATURE_ZOMBIE, 320 * GetDifficulty());
		AddObjectCreatures('J-vampire', CREATURE_VAMPIRE_LORD, 95 * GetDifficulty());
		AddObjectCreatures('J-balor', CREATURE_PIT_FIEND, 22 * GetDifficulty());		
		
		AddObjectCreatures('K-dragon', CREATURE_SHADOW_DRAGON, 21 * GetDifficulty()); -- ohrana Ring of Life / Ring of vitality location
		AddObjectCreatures('K-lich', CREATURE_LICH, 45 * GetDifficulty());	
		
		AddObjectCreatures('earth_elem', CREATURE_EARTH_ELEMENTAL, 100 * GetDifficulty()); -- podzemniy prohod/underground passage
		AddObjectCreatures('fire_demons', CREATURE_HORNED_DEMON, 350 * GetDifficulty());	

		AddObjectCreatures('mini-boss', CREATURE_FRIGHTFUL_NIGHTMARE, 25 * GetDifficulty()); -- Last stack before landing in Tieru location;Weekly growth has been unlocked
		AddObjectCreatures('mini-boss', CREATURE_BALOR, 18 * GetDifficulty()); 
		AddObjectCreatures('mini-boss', CREATURE_ARCH_DEMON, 10 * GetDifficulty()); 		
end


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
		H55c_SetCampaignResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0 );
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
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end

			-- Loss of the mission is handled by C5M4.xdb
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
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
			sleep(30);
			EnableHeroAI( 'Jazaz', nil );
			EnableHeroAI( 'Biara', nil );
			local AT = GetDifficulty() + 1
			local ArmyMult = diff + GetDate(MONTH);
			AddHeroCreatures( 'Jazaz',				 CREATURE_BALOR,  4 * ArmyMult ); --- PIT LORDS
			AddHeroCreatures( 'Jazaz', 			   CREATURE_CERBERI, 15 * ArmyMult ); --- CERBERI
			AddHeroCreatures( 'Jazaz', CREATURE_FRIGHTFUL_NIGHTMARE,  7 * ArmyMult ); --- HELL STALLION
			AddHeroCreatures( 'Jazaz', 		  CREATURE_HORNED_DEMON, 20 * ArmyMult ); --- HORNED DEMONS
			AddHeroCreatures( 'Jazaz', 	 		 CREATURE_ARCHDEVIL,  3 * ArmyMult ); --- ARCHDEVILS
			AddHeroCreatures( 'Biara', 	 CREATURE_INFERNAL_SUCCUBUS, 30 * ArmyMult ); --- SUCCUBUS MISTRESS
			AddHeroCreatures( 'Biara', 	  CREATURE_SUCCUBUS_SEDUCER, 30 * ArmyMult ); --- SUCCUBUS SEDUCER 
			AddHeroCreatures( 'Biara', 	 		  CREATURE_SUCCUBUS, 30 * ArmyMult ); --- SUCCUBUS
			AddHeroCreatures( 'Biara', 	 		   CREATURE_CERBERI, 40 * ArmyMult ); --- CERBERI
			AddHeroCreatures( 'Biara', 	 		   CREATURE_FIREBREATHER_HOUND, 40 * ArmyMult ); --- Firehound	
			AddHeroCreatures( 'Biara', 	 		   CREATURE_HELL_HOUND, 40 * ArmyMult ); --- Hell Hound	
			AddHeroCreatures( 'Biara',				 CREATURE_BALOR,  5 * ArmyMult ); --- PIT LORDS			
			ChangeHeroStat("Jazaz", STAT_ATTACK, 3 * diff);
			ChangeHeroStat("Jazaz", STAT_DEFENCE, 3 * diff);	
			ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 5 * diff);			
			ChangeHeroStat("Biara", STAT_ATTACK, 3 * diff);
			ChangeHeroStat("Biara", STAT_DEFENCE, 3 * diff);
			ChangeHeroStat("Biara", STAT_SPELL_POWER, 7 * diff);
			ChangeHeroStat("Biara", STAT_KNOWLEDGE, 3 * diff);
			sleep(3);	-- required for recover her mana		
			ChangeHeroStat("Biara", STAT_MANA_POINTS, 150);			
			sleep(3);
            if AT > 1 then
			TeachHeroSpell("Biara", SPELL_FROST_RING);
			TeachHeroSpell("Biara", SPELL_FIREBALL);			
			sleep(2);	-- required for recover her mana		
			ChangeHeroStat("Biara", STAT_MANA_POINTS, 150);			
			end
            if AT > 2 then
			TeachHeroSpell("Biara", SPELL_DEEP_FREEZE);			
			sleep(2);	-- required for recover her mana		
			ChangeHeroStat("Biara", STAT_MANA_POINTS, 150);			
			end	
            if AT > 3 then
			TeachHeroSpell("Biara", SPELL_IMPLOSION);			
			sleep(2);	-- required for recover her mana		
			ChangeHeroStat("Biara", STAT_MANA_POINTS, 150);			
			end						
			SetObjectEnabled('ExitToIsland', nil); -- There is no way back!  -- blokiruem vihod s ostrova.
			Trigger( OBJECT_TOUCH_TRIGGER, 'ExitToIsland', 'MessageBox("/Maps/Scenario/C5M4/Texts/NoWay.txt")' );
			OBJECTIVES.state.saveTieru[2] = 2;
		elseif OBJECTIVES.state.saveTieru[2] == 3 then
			CINEMATICS.demonAttack();
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', 'TieruDeath' );
			OBJECTIVES.state.saveTieru[2] = 4;
		elseif OBJECTIVES.state.saveTieru[2] == 5 then
			CINEMATICS.goToTieru();
			Save ('Will_of_Tieru');
			CINEMATICS.deathOfTieru();
			SetObjectiveState( 'prim2', OBJECTIVE_FAILED );
			OBJECTIVES.state.defeatBiara[2] = 1;
			OBJECTIVES.state.saveTieru[2] = 11;
		end
	end,
	
	defeatBiara = function()
		if OBJECTIVES.state.defeatBiara[2] == 1 then
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			CINEMATICS.showBiara();
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'NavalAttack', 'NavalAttack' );
			DeployReserveHero( 'Oddrema', 135, 55, GROUND );
			sleep( 20 );
			SetObjectRotation( "Oddrema", 66 );
			EnableHeroAI('Oddrema', nil);
			local KB = GetDifficulty() + 1
			local ArmyMult = diff + GetDate(MONTH);
			ChangeHeroStat("Oddrema", STAT_ATTACK, 15 + 2 * diff); -- started stats haven't been added from her folder
			ChangeHeroStat("Oddrema", STAT_DEFENCE, 7 + 2 * diff);
			ChangeHeroStat("Oddrema", STAT_SPELL_POWER, 15 + 10 * diff);
			ChangeHeroStat("Oddrema", STAT_KNOWLEDGE, 6 + 2 * diff);						
			AddHeroCreatures( 'Oddrema',CREATURE_INFERNAL_SUCCUBUS, 20 * ArmyMult );
			AddHeroCreatures( 'Oddrema',CREATURE_CERBERI, 35 * ArmyMult );
			AddHeroCreatures( 'Oddrema',CREATURE_FIREBREATHER_HOUND, 35 * ArmyMult );
			AddHeroCreatures( 'Oddrema',CREATURE_FRIGHTFUL_NIGHTMARE, 10 * ArmyMult );
			sleep(5);	-- required for recover her mana		
			ChangeHeroStat("Oddrema", STAT_MANA_POINTS, 150 * KB);			
			sleep(5);
			if KB > 2 then 
			TeachHeroSpell("Oddrema", SPELL_EMPOWERED_FIREBALL);
			end
			
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
			ChangeHeroStat( 'Heam', STAT_EXPERIENCE, (OBJECTIVES.collectArtifacts_count + GetDifficulty())*5000 );
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
