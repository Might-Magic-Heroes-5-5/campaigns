doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M3");
    LoadHeroAllSetArtifacts(  "Berein", "C3M2" );
    LoadHeroAllSetArtifacts( "Isabell", "C1M5" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1,  "Berein" );
	H55_CamFixTooManySkills( PLAYER_1, "Isabell" );
end;

startThread(H55_InitSetArtifacts);
H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

CyrusName = "Cyrus";
ElvenHero = "Nadaur";
		
DIFFICULTY = {
	[0] = function()
		factor = 1;
		SetPlayerStartResource(PLAYER_1,ORE,20);
		SetPlayerStartResource(PLAYER_1,WOOD,20);
		SetPlayerStartResource(PLAYER_1,SULFUR,10);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,10);
		SetPlayerStartResource(PLAYER_1,MERCURY,10);
		SetPlayerStartResource(PLAYER_1,GEM,10);
		SetPlayerStartResource(PLAYER_1,GOLD,20000);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_4,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_5,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_MAGIC_GUILD,2);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_FORT,1);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_4,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_5,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_MAGIC_GUILD,2);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_FORT,1);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_DWELLING_5,0);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_MAGIC_GUILD,2);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_FORT,1);
		CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,120,117,16,0); --mausoleum
		CreateMonster("lich",CREATURE_LICH,16,80,20,0); --Crystall mine
		CreateMonster("vampire",CREATURE_VAMPIRE,22,138,10,0); --lighthouse
		CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,30,95,71,0); --shrine
		CreateMonster("wight",CREATURE_WIGHT,12,129,89,0); --Town1
		CreateMonster("demilich",CREATURE_DEMILICH,20,91,114,0); --Redwood observatory
		CreateMonster("skeleton_archer2",CREATURE_SKELETON_ARCHER,250,30,53,0); --teleport
		CreateMonster("vampire_lord2",CREATURE_VAMPIRE_LORD,30,99,144,0);--center
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,80);
		AddHeroCreatures("Berein",CREATURE_LICH,10);
		AddHeroCreatures("Berein",CREATURE_MANES,35);
		AddHeroCreatures("Isabell",CREATURE_FOOTMAN,15);
		AddHeroCreatures("Isabell",CREATURE_ARCHER,35);
		print("Difficulty level is easy. Factor = ", factor);
	end,
	
	[1] = function()
		factor = 1;
		SetPlayerStartResource(PLAYER_1,ORE,15);
		SetPlayerStartResource(PLAYER_1,WOOD,15);
		SetPlayerStartResource(PLAYER_1,SULFUR,6);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,6);
		SetPlayerStartResource(PLAYER_1,MERCURY,6);
		SetPlayerStartResource(PLAYER_1,GEM,6);
		SetPlayerStartResource(PLAYER_1,GOLD,15000);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_MAGIC_GUILD,3);
		SetTownBuildingLimitLevel("Town1",TOWN_BUILDING_FORT,2);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_MAGIC_GUILD,3);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_FORT,2);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_MAGIC_GUILD,3);
		SetTownBuildingLimitLevel("Town3",TOWN_BUILDING_FORT,2);
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,40);
		AddHeroCreatures("Isabell",CREATURE_FOOTMAN,10);
		CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,120,117,16,0); --mausoleum
		CreateMonster("lich",CREATURE_LICH,16,80,20,0); --Crystall mine
		CreateMonster("vampire",CREATURE_VAMPIRE,22,138,10,0); --lighthouse
		CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,30,95,71,0); --shrine
		CreateMonster("wight",CREATURE_WIGHT,12,129,89,0); --Town1
		CreateMonster("demilich",CREATURE_DEMILICH,20,91,114,0); --Redwood observatory
		CreateMonster("skeleton_archer2",CREATURE_SKELETON_ARCHER,250,30,53,0); --teleport
		CreateMonster("vampire_lord2",CREATURE_VAMPIRE_LORD,30,99,144,0);--center
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,40);
		AddHeroCreatures("Berein",CREATURE_LICH,5);
		AddHeroCreatures("Berein",CREATURE_MANES,15);
		AddHeroCreatures("Isabell",CREATURE_FOOTMAN,10);
		AddHeroCreatures("Isabell",CREATURE_ARCHER,15);
		print("Difficulty level is normal. Factor = ", factor);
	end,
	
	[2] = function()
		SetPlayerStartResource(PLAYER_1,ORE,10);
		SetPlayerStartResource(PLAYER_1,WOOD,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,2);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,2);
		SetPlayerStartResource(PLAYER_1,MERCURY,2);
		SetPlayerStartResource(PLAYER_1,GEM,2);
		SetPlayerStartResource(PLAYER_1,GOLD,8000);
		factor = 2;
		CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,120,117,16,0); --mausoleum
		CreateMonster("vampire",CREATURE_VAMPIRE,22,138,10,0); --lighthouse
		CreateMonster("demilich",CREATURE_DEMILICH,20,91,114,0); --Redwood observatory
		CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,30,95,71,0); --shrine
		TeachHeroSpell("Maahir",SPELL_PHANTOM);
		TeachHeroSpell("Maahir",SPELL_RESURRECT);
		TeachHeroSpell("Sufi",SPELL_CONJURE_PHOENIX);
		print("Difficulty level is hard. Factor = ", factor);
	end,
	
	[3] = function()
		factor = 3;
		SetPlayerStartResource(PLAYER_1,ORE,10);
		SetPlayerStartResource(PLAYER_1,WOOD,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,2);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,2);
		SetPlayerStartResource(PLAYER_1,MERCURY,2);
		SetPlayerStartResource(PLAYER_1,GEM,2);
		SetPlayerStartResource(PLAYER_1,GOLD,8000);
		TeachHeroSpell("Razzak",SPELL_PHANTOM );
		TeachHeroSpell("Razzak",SPELL_RESURRECT);
		TeachHeroSpell("Maahir",SPELL_PHANTOM);
		TeachHeroSpell("Maahir",SPELL_RESURRECT);
		TeachHeroSpell("Sufi",SPELL_PHANTOM );
		TeachHeroSpell("Sufi",SPELL_CONJURE_PHOENIX);
		TeachHeroSpell("Havez",SPELL_PHANTOM );
		print("Difficulty level is heroic. Factor = ", factor);
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C3/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
    
	staffInMarkal = function()
		StartDialogScene("/DialogScenes/C3/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	cloakInMarkal = function()
		StartDialogScene("/DialogScenes/C3/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	assembleSkeletonsStart = function()
		StartDialogScene("/DialogScenes/C3/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	assembleSkeletonsFinish = function()
		StartDialogScene("/DialogScenes/C3/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	convinceElvesStart = function()
		StartDialogScene("/DialogScenes/C3/M3/R6/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	convinceElvesFinish = function()
		StartDialogScene("/DialogScenes/C3/M3/R7/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	ringInMarkal = function()
		StartDialogScene("/DialogScenes/C3/M3/R8/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/C3/M3/R9/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	townTransformed = function()
		MessageBox( "/Maps/Scenario/C3M3/messages/Town1Transformed.txt" );
		sleep( 2 );
	end,
	
	townTransformBlockedByHero = function()
		MessageBox( "/Maps/Scenario/C3M3/HeroInTown.txt" );
		sleep( 2 );
	end,
	
	townTransformBlockedByResources = function()
		MessageBox( "/Maps/Scenario/C3M3/messages/CurseNegative.txt" );
		sleep( 2 );
	end
}

OBJECTIVES = {
	state = {
		staffInMarkal     = { "prim1", 1 }, -- Markal has Staff of Vexings
		cloakInMarkal     = { "prim2", 1 }, -- Markal has Cloak of Mourning
		ringInMarkal      = { "prim3", 0 }, -- Get ring of Unrepetant
		followCyrus       = { "prim4", 0 }, -- Follow Cyrus through the portal
		isAlive           = { "prim5", 1 }, --  are Markal and Isabell still alive?
		convertTowns      = {  "sec1", 1 }, --  Convert Academy towns to Necropolis
		assembleSkeletons = {  "sec2", 1 }, --  Markal to collect 1000 skeletons
		assembleDragons   = {  "sec3", 0 }, --  Markal to collect bone dragons
		-- giveStaff         = {  "sec4", 0 }, --  Player has Staff of Vexings but not in Markal.
		convinceElves     = {  "sec5", 1 }, --  Kill the Elven hero
		-- giveCloak         = {  "sec6", 0 }, --  Player has Cloak of Mourning but not in Markal.
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
	end,

	prepare = function()
		C3M3_towns = {
			convert = {
				count = 0,
				["Town1"] = nil,
				["Town2"] = nil,
				["Town3"] = nil,
			},
			vault = {
				["Town1"] = ARTIFACT_STAFF_OF_VEXINGS,
				["Town2"] = ARTIFACT_CLOAK_OF_MOURNING,
				["Town3"] = nil,
			}
		};
		SetRegionBlocked("antislonik",1,PLAYER_2);
		SetRegionBlocked("antislonik",1,PLAYER_3);
		SetRegionBlocked("gate",1,PLAYER_2);
		SetRegionBlocked("gate",1,PLAYER_3);
		SetRegionBlocked("closed",1,PLAYER_2);
		SetRegionBlocked("closed",1,PLAYER_3);
		SetRegionBlocked("closed2",1,PLAYER_2);
		SetRegionBlocked("closed2",1,PLAYER_3);
		SetRegionBlocked("cloesd3",1,PLAYER_2);
		SetRegionBlocked("cloesd3",1,PLAYER_3);
		SetRegionBlocked("landing",1,PLAYER_2);
		SetRegionBlocked("landing",1,PLAYER_3);
		SetRegionBlocked("ambush1",1,PLAYER_2);
		SetRegionBlocked("ambush1",1,PLAYER_3);
		SetRegionBlocked("teleport",1,PLAYER_2);
		SetRegionBlocked("teleport",1,PLAYER_3);
		SetObjectEnabled("El_Safir_teleport",nil);
		SetObjectEnabled(CyrusName,nil);
		EnableHeroAI("Razzak",nil);
		EnableHeroAI("Maahir",nil);
		CINEMATICS.intro()
		startThread(DIFFICULTY[GetDifficulty()]);
		
		---Disable AI of quest heroes---
		EnableHeroAI(CyrusName, nil);
		EnableHeroAI(ElvenHero, nil);
		startThread(EnableAIForRazzakAndTimerkhan);
		
		-- Setup special interactions for Academy Towns --
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town1', "C3M3_touch_town");
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town2', "C3M3_touch_town");
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town3', "C3M3_touch_town");
		
		-- Prepare end of campaign events triggers --
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "astral_can_be_in_sight","cyrus_retreat", nil );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"slonek","cyrus_out");
		print("all functions is run");
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

			if GetObjectiveState("prim5") == OBJECTIVE_FAILED then
				Loose(PLAYER_1);
				return
			end
			
			if GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Berein", "C3M3");
				SaveHeroAllSetArtifactsEquipped("Isabell", "C3M3");
				sleep(10);
				CINEMATICS.outro();
				sleep(5);
				Win(PLAYER_1);
			end
		end
	end,
	
	staffInMarkal = function()
		if HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS ) ~= nil then
			print("Objective prim1 for artefact Staff of Vexings completed");
			startThread(SetArtefactUntrans, "Berein", ARTIFACT_STAFF_OF_VEXINGS);
			CINEMATICS.staffInMarkal();
			SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
			ObjectiveExp("Berein");
			OBJECTIVES.state.staffInMarkal[2] = 10;
		end
	end,
	
	cloakInMarkal = function()
		if HasArtefact( "Berein", ARTIFACT_CLOAK_OF_MOURNING ) ~= nil then
			print("Objective prim2 for artefact Cloak of Mourning completed");
			startThread(SetArtefactUntrans, "Berein", ARTIFACT_CLOAK_OF_MOURNING);
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			CINEMATICS.cloakInMarkal();
			ObjectiveExp("Berein");
			OBJECTIVES.state.cloakInMarkal[2] = 10;
		end
	end,
	
	ringInMarkal = function()
		if OBJECTIVES.state.ringInMarkal[2] == 1 then
			SetRegionBlocked("teleport", nil, PLAYER_2);
			SetRegionBlocked("teleport", nil, PLAYER_3);
			print("Thread cyrus_retreat");
			BlockGame();
			OpenRegionFog(PLAYER_1, "CyrusRegion");
			OpenRegionFog(PLAYER_1, "teleport");
			ChangeHeroStat(CyrusName, STAT_MOVE_POINTS, 4000);
			sleep(10);
			MoveHeroRealTime(CyrusName, 145, 152);
			OBJECTIVES.state.ringInMarkal[2] = 2;
		elseif OBJECTIVES.state.ringInMarkal[2] == 3 then
			Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
			UnblockGame();
			CINEMATICS.ringInMarkal();
			SetObjectiveVisible("prim3", nil);
			sleep(5);
			SetObjectEnabled("cyrus_teleport", nil);
			SetRegionBlocked("teleport", 1, PLAYER_2);
			SetRegionBlocked("teleport", 1, PLAYER_3);
			OBJECTIVES.state.assembleDragons[2] = 1;
			OBJECTIVES.state.followCyrus[2] = 1;
			OBJECTIVES.state.ringInMarkal[2] = 10;
		end
	end,
	
	followCyrus = function()
		if OBJECTIVES.state.followCyrus[2] == 1 then
			SetObjectiveState("prim4", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.followCyrus[2] = 2;
		elseif OBJECTIVES.state.followCyrus[2] == 2 then
			-- waiting for Markal to visit the Teleport		
		elseif OBJECTIVES.state.followCyrus[2] == 3 then
			if OBJECTIVES.state.assembleDragons[2] ~= 4 then
				MessageBox("/Maps/Scenario/C3M3/MessageBox_MarkalMustHaveDragons.txt");
				OBJECTIVES.state.followCyrus[2] = 2; -- Markal should try again.
			elseif OBJECTIVES.state.staffInMarkal[2] ~= 10 or OBJECTIVES.state.cloakInMarkal[2] ~= 10 then 
				MessageBox("/Maps/Scenario/C3M3/MessageBox_VampirsGarmentNeed.txt");
				OBJECTIVES.state.followCyrus[2] = 2; -- Markal should try again.
			else
				SetObjectiveState("prim4", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.followCyrus[2] = 10;
			end
		end
	end,
		
	isAlive = function()
		if IsHeroAlive("Berein") == nil or IsHeroAlive("Isabell") == nil then
			SetObjectiveState("prim5", OBJECTIVE_FAILED);
			sleep(2);
			OBJECTIVES.state.isAlive[2] = 11;
		elseif OBJECTIVES.state.followCyrus[2] == 10 then
			SetObjectiveState("prim5", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	convertTowns = function()
		if OBJECTIVES.state.convertTowns[2] == 1 and HasArtefact("Berein", ARTIFACT_STAFF_OF_VEXINGS) == not nil then
			SetObjectiveState("sec1",OBJECTIVE_ACTIVE);
			OBJECTIVES.state.convertTowns[2] = 2;
		elseif OBJECTIVES.state.convertTowns[2] == 2 and C3M3_towns.convert.count == 3 then
			print("All towns are converted");
			SetObjectiveState("sec1",OBJECTIVE_COMPLETED);
			ObjectiveExp("Berein");
			OBJECTIVES.state.convertTowns[2] = 10;
		end
	end,
	
	assembleSkeletons_day = 0,
	assembleSkeletons = function()
		if OBJECTIVES.state.assembleSkeletons[2] == 1 and OBJECTIVES.state.staffInMarkal[2] == 10 then
			OBJECTIVES.assembleSkeletons_day = GetDate ( DAY ) + 2;
			OBJECTIVES.state.assembleSkeletons[2] = 2;
		elseif OBJECTIVES.state.assembleSkeletons[2] == 2
		and OBJECTIVES.assembleSkeletons_day <= GetDate ( DAY ) then
			SetObjectiveState("sec2", OBJECTIVE_ACTIVE);
			CINEMATICS.assembleSkeletonsStart();
			OBJECTIVES.state.assembleSkeletons[2] = 3;
			
		elseif OBJECTIVES.state.assembleSkeletons[2] == 3 then
			local skeletons = GetHeroCreatures('Berein', CREATURE_SKELETON);
			local skeleton_archers = GetHeroCreatures('Berein', CREATURE_SKELETON_ARCHER);
			local skeleton_warriors = GetHeroCreatures('Berein', CREATURE_SKELETON_WARRIOR);
			if skeletons + skeleton_archers + skeleton_warriors  >= 1000 then
				print("Berein assembled ".. skeletons .."+"..skeleton_archers.."+"..skeleton_warriors.." skeletons");
				SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
				CINEMATICS.assembleSkeletonsFinish();
				ObjectiveExp("Berein");
				OBJECTIVES.state.assembleSkeletons[2] = 10;
			end
		end
	end,
	
	assembleDragons_have20 = function()
		local bone_dragons   = GetHeroCreatures('Berein', CREATURE_BONE_DRAGON);
		local shadow_dragons = GetHeroCreatures('Berein', CREATURE_SHADOW_DRAGON);
		local horror_dragons = GetHeroCreatures('Berein', CREATURE_HORROR_DRAGON);
		return (bone_dragons + shadow_dragons + horror_dragons) >= 20;
	end,
	
	assembleDragons = function()
		if OBJECTIVES.state.assembleDragons[2] == 1 then 
			SetObjectiveState("sec3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.assembleDragons[2] = 2;
		elseif OBJECTIVES.state.assembleDragons[2] == 2 and OBJECTIVES.assembleDragons_have20() ~= nil then
			ObjectiveExp("Berein");
			OBJECTIVES.state.assembleDragons[2] = 3;
		elseif OBJECTIVES.state.assembleDragons[2] == 3 and OBJECTIVES.assembleDragons_have20() ~= nil then
			SetObjectiveState('sec3', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.assembleDragons[2] = 4;
		elseif OBJECTIVES.state.assembleDragons[2] == 4 and OBJECTIVES.assembleDragons_have20() == nil then
			SetObjectiveState('sec3', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.assembleDragons[2] = 3;
		end
	end,
	
	-- giveStaff.old_owner = nil;
	-- giveStaff = function()
		-- if GetPlayerState(PLAYER_1) == PLAYER_ACTIVE then
			-- for i, hero in GetPlayerHeroes(PLAYER_1) do
				-- if HasArtefact(hero, ARTIFACT_STAFF_OF_VEXINGS) then
					-- if hero ~= "Berein" then
						-- if OBJECTIVES.state.giveStaff[2] == 1 then 
							-- ObjectiveExp(HeroName);
							-- SetObjectiveState("sec4", OBJECTIVE_ACTIVE);
							-- OBJECTIVES.state.giveStaff[2] = 2;
						-- end
						-- giveStaff.old_owner = HeroName;
					-- else
						-- if OBJECTIVES.state.giveStaff[2] == 2 then
							-- SetObjectiveState("sec4", OBJECTIVE_COMPLETED);
							-- ObjectiveExp(giveStaff.old_owner);
						-- end
						-- OBJECTIVES.state.giveStaff[2] = 10;
					-- end 
				-- end
			-- end
		-- end
	-- end,
	
	convinceElves_day = 0,
	convinceElves = function()
		if OBJECTIVES.state.convinceElves[2] == 1
		and (GetObjectOwner('Town1') == PLAYER_1 or GetObjectOwner('Town2') == PLAYER_1 or IsObjectVisible( PLAYER_1, ElvenHero ) ~= nil) then
			SetObjectiveState("sec5", OBJECTIVE_ACTIVE); --при установке состояния задания в OBJECTIVE_ACTIVE оно автоматически становится видимым игроку
			CINEMATICS.convinceElvesStart();
			EnableHeroAI(ElvenHero, not nil);
			OBJECTIVES.state.convinceElves[2] = 2;
		elseif OBJECTIVES.state.convinceElves[2] == 2 then
			convinceElves_day = GetDate( DAY );
			OBJECTIVES.state.convinceElves[2] = 3;
		elseif OBJECTIVES.state.convinceElves[2] == 3 then
			if IsHeroAlive(ElvenHero) == nil then
				OBJECTIVES.state.convinceElves[2] = 4;
			elseif ((convinceElves_day + 1) == GetDate( DAY )) and IsObjectExists(ElvenHero) ~= nil and CanMoveHero(ElvenHero,110,23,0) then
				MoveHero(ElvenHero,110,23,0);
				OBJECTIVES.state.convinceElves[2] = 2;
			else
				OBJECTIVES.state.convinceElves[2] = 2;
			end
		elseif OBJECTIVES.state.convinceElves[2] == 4 then
			print("Elven Hero is dead");
			SetObjectiveState("sec5", OBJECTIVE_COMPLETED);
			sleep(10);
			CINEMATICS.convinceElvesFinish();
			OBJECTIVES.state.convinceElves[2] = 10;
		end
	end,
	
	-- giveCloak.old_owner = nil;
	-- giveCloak = function()
		-- if GetPlayerState(PLAYER_1) == PLAYER_ACTIVE then
			-- for i, hero in GetPlayerHeroes(PLAYER_1) do
				-- if HasArtefact(hero, ARTIFACT_CLOAK_OF_MOURNING) then
					-- if hero ~= "Berein" then
						-- if OBJECTIVES.state.giveCloak[2] == 1 then 
							-- ObjectiveExp(HeroName);
							-- SetObjectiveState("sec6", OBJECTIVE_ACTIVE);
							-- OBJECTIVES.state.giveCloak[2] = 2;
						-- end
						-- giveCloak.old_owner = HeroName;
					-- else
						-- if OBJECTIVES.state.giveCloak[2] == 2 then
							-- SetObjectiveState("sec6", OBJECTIVE_COMPLETED);
							-- ObjectiveExp(giveCloak.old_owner);
						-- end
						-- OBJECTIVES.state.giveCloak[2] = 10;
					-- end 
				-- end
			-- end
		-- end
	-- end
}

function EnableAIForRazzakAndTimerkhan()
	sleep(5);
	while GetDate(DAY) ~= 36 and GetObjectOwner("Town1")==PLAYER_2 do
		sleep(15);
	end
	SetObjectEnabled("El_Safir_teleport",1);
	print("Teleport near El Safir has been enabled...");
	if IsHeroAlive("Razzak") ~= nil then
		EnableHeroAI("Razzak",not nil);
		AddHeroCreatures("Razzak",CREATURE_MASTER_GREMLIN,factor*150);
		AddHeroCreatures("Razzak",CREATURE_MASTER_GENIE,factor*20);
		AddHeroCreatures("Razzak",CREATURE_MAGI,factor*30);
		AddHeroCreatures("Razzak",CREATURE_TITAN,factor*4);
		AddHeroCreatures("Razzak",CREATURE_STONE_GARGOYLE,factor*150);
		AddHeroCreatures("Razzak",CREATURE_STEEL_GOLEM,factor*100);
		print("AI has been enabled for hero Razzak.");
		if GetObjectOwner("Town1") == PLAYER_1 then
			SetAIHeroAttractor ("Town1","Razzak",2);
		end
	else
		print("hero Razzak is dead");
	end
	while GetDate(DAY) ~= 57 do
		sleep(15);
	end
	if IsHeroAlive("Maahir") ~= nil then
		EnableHeroAI("Maahir",not nil);
		AddHeroCreatures("Maahir",CREATURE_MASTER_GREMLIN,factor*250);
		AddHeroCreatures("Maahir",CREATURE_GENIE,factor*30);
		AddHeroCreatures("Maahir",CREATURE_ARCH_MAGI,factor*60);
		AddHeroCreatures("Maahir",CREATURE_TITAN,factor*8);
		AddHeroCreatures("Maahir",CREATURE_OBSIDIAN_GARGOYLE,factor*200);
		AddHeroCreatures("Maahir",CREATURE_STEEL_GOLEM,factor*150);
		AddHeroCreatures("Maahir",CREATURE_RAKSHASA,factor*25);
		print("AI has been enabled for hero Maahir.");
		if GetObjectOwner("Town1") == PLAYER_1 then
			SetAIHeroAttractor ("Town1","Maahir",2);
		end
	else
		print("hero Maahir is dead");
	end
end

function cyrus_retreat(heroname)
	if GetObjectOwner(heroname) == PLAYER_1 then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "astral_can_be_in_sight", nil);
		OBJECTIVES.state.ringInMarkal[2] = 1;
	end
end

function cyrus_out(heroname)
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"slonek",nil);
	OBJECTIVES.state.ringInMarkal[2] = 3;
end

function C3M3_touch_town(hero, town)
	print(hero,' in town ', town);
	artifact = C3M3_towns.vault[town];
	if hero == "Berein" and GetObjectOwner(town) == PLAYER_1 then
		if artifact ~= nil and HasArtefact(hero, artifact) == nil then
			GiveArtefact(hero, artifact);
		end
		if HasArtefact(hero, ARTIFACT_STAFF_OF_VEXINGS) and IsAnyHeroInTown(town) == 0 and C3M3_towns.convert[town] == nil then
			QuestionBox("/Maps/Scenario/C3M3/messages/CurseTown.txt", "TransformingTown('"..town.."')");
		end
	end
end

function GiveStaffOfVexings(HeroName)
	if GetObjectOwner(HeroName) == PLAYER_1 then
		GiveArtefact(HeroName, ARTIFACT_STAFF_OF_VEXINGS );
		print("Our hero ",HeroName," has got Staff of vexings");
	end
end

function GiveCloackOfMourning(HeroName)
	if GetObjectOwner(HeroName) == PLAYER_1 then
		GiveArtefact( HeroName, ARTIFACT_CLOAK_OF_MOURNING );
		print("Our hero ",HeroName," has got Cloak of mourning");
	end
end

function TransformingTown(town)
	local currentRes = GetPlayerResource( PLAYER_1, GOLD );
	if IsAnyHeroInTown(town) == 0 then
		if currentRes < 10000 then
			CINEMATICS.townTransformBlockedByResources();
		else
			SetPlayerResource( PLAYER_1, GOLD, currentRes - 10000 );
			TransformTown(town, TOWN_NECROMANCY);
			CINEMATICS.townTransformed();
			C3M3_towns.convert.count = C3M3_towns.convert.count + 1;
			C3M3_towns.convert[town] = not nil;
			if (GetDifficulty() == DIFFICULTY_NORMAL or GetDifficulty() == DIFFICULTY_EASY) then 
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_4, 2);
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_6, 2);
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_5, 2);
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_7, 2);
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_MAGIC_GUILD, 5);
				SetTownBuildingLimitLevel(town, TOWN_BUILDING_FORT,3);
				print("High level buildings were enabled to construct for town ",town);
			end
		end
	else
		CINEMATICS.townTransformBlockedByHero();		
	end
end

function IsAnyHeroInTown(TownName)
	if GetTownHero(TownName) ~= nil then return 1 else return 0 end;
end

function port_check(HeroName)
	if HeroName ~= "Berein" then
		MessageBox("/Maps/Scenario/C3M3/MessageBox_OnlyBereinInPortal.txt");
	else
		OBJECTIVES.state.followCyrus[2] = 3;
	end
end

function onError()
	print("Error occured in function SetArtefactUntrans");
end

function SetArtefactUntrans(hero, ArtefactName)
	errorHook(onError);
	RemoveArtefact(hero, ArtefactName);
	GiveArtefact(hero, ArtefactName, 1);
end

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
