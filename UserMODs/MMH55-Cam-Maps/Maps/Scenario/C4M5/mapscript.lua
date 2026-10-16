doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M5");
    LoadHeroAllSetArtifacts(  "Raelag", "C4M4" );
    -- LoadHeroAllSetArtifacts( "Kelodin", "C4M4" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1,  "Raelag" );
	H55_CamFixTooManySkills( PLAYER_1, "Kelodin" );
end

startThread(H55_InitSetArtifacts);
OpenCircleFog( 10, 29, 0, 5, PLAYER_1 ); ---фог у выхода с карты

SetRegionBlocked("stop1", 1, PLAYER_2);
SetRegionBlocked("stop2", 1, PLAYER_2);
SetRegionBlocked("stop3", 1, PLAYER_2);
SetRegionBlocked("stop4", 1, PLAYER_2);
SetRegionBlocked("stop5", 1, PLAYER_2);

--SetRegionBlocked("border", 1, PLAYER_2); ---!

SetRegionBlocked("c1", 1, PLAYER_2);
SetRegionBlocked("c2", 1, PLAYER_2);
SetRegionBlocked("v1", 1, PLAYER_2);
SetRegionBlocked("v2", 1, PLAYER_2);

Raelag = "Raelag";
Kelodin = "Kelodin";  
Isabell = "Isabell"
Berein = "Berein"
Veyer = "Veyer"

--Hint: create a function to be inside all 5 enemy heroes: will be useful to reduce the lines of change hero stats 
-- Once is done, delete this hint and the extra lines for stats added  

blue_player_heroes = {"Marder", "Deleb", "Calid", "Jazaz", "Efion"}; -- Marbas, Deleb, Grawl, Nebiros, Alastor

local extra = GetDifficulty() + 1 
GiveExp("Jazaz", 200000);
GiveExp("Efion", 200000);
if extra > 1 then
	for i, hero in blue_player_heroes do  -- Marbas, Deleb, Grawl, Nebiros, Alastor
	  ChangeHeroStat(hero, STAT_ATTACK, GetDifficulty() * 5);
	  ChangeHeroStat(hero, STAT_DEFENCE, GetDifficulty() * 5);
	  ChangeHeroStat(hero, STAT_SPELL_POWER, GetDifficulty() * 5);
	  ChangeHeroStat(hero, STAT_KNOWLEDGE, GetDifficulty() * 5);	  
	end
	-- Marbas
	GiveExp("Marder", 363000);
	GiveHeroSkill("Marder", SKILL_GATING);
	GiveHeroSkill("Marder", PERK_DEMONIC_FIRE);
	GiveHeroSkill("Marder", DEMON_FEAT_DEMONIC_RETALIATION);
	GiveHeroSkill("Marder", DEMON_FEAT_QUICK_GATING);
	-- Deleb
	GiveExp("Deleb", 363000);
	GiveHeroSkill("Deleb", HERO_SKILL_EMPATHY);
	GiveHeroSkill("Deleb", WARLOCK_FEAT_POWER_OF_STONE);
	GiveHeroSkill("Deleb", DEMON_FEAT_CRITICAL_GATING);
	GiveHeroSkill("Deleb", PERK_MASTER_OF_CURSES);
	--Grawl
	GiveExp("Calid", 363000);
	GiveHeroSkill("Calid", SKILL_DEFENCE);
	GiveHeroSkill("Calid", PERK_PROTECTION);
	GiveHeroSkill("Calid", NECROMANCER_FEAT_DEADLY_COLD);
	GiveHeroSkill("Calid", SKILL_GATING);
	-- Nebiros
	GiveExp("Jazaz", 143000); 
	GiveHeroSkill("Jazaz", SKILL_GATING);
	GiveHeroSkill("Jazaz", PERK_DEMONIC_FIRE);
	GiveHeroSkill("Jazaz", DEMON_FEAT_DEMONIC_RETALIATION);

	AddHeroCreatures("Jazaz", CREATURE_HORNED_DEMON, 160 * GetDifficulty());
	AddHeroCreatures("Jazaz", CREATURE_FIRE_ELEMENTAL, 45 * GetDifficulty());
	AddHeroCreatures("Jazaz", CREATURE_DEVIL, 5 * GetDifficulty());
	AddHeroCreatures("Jazaz", CREATURE_IMP, 415 * GetDifficulty());
	AddHeroCreatures("Jazaz", CREATURE_EARTH_ELEMENTAL, 40 * GetDifficulty());
	AddHeroCreatures("Jazaz", CREATURE_SUCCUBUS, 15 * GetDifficulty());
	-- Alastor
	GiveExp("Efion", 143000); 
	GiveHeroSkill("Efion", SKILL_GATING);
	GiveHeroSkill("Efion", PERK_DEMONIC_FIRE);
	GiveHeroSkill("Efion", DEMON_FEAT_DEMONIC_RETALIATION);
		
	AddHeroCreatures("Efion", CREATURE_CERBERI, 90 * GetDifficulty());
	AddHeroCreatures("Efion", CREATURE_DEMON, 230 * GetDifficulty());
	AddHeroCreatures("Efion", CREATURE_FIRE_ELEMENTAL, 28 * GetDifficulty());
	AddHeroCreatures("Efion", CREATURE_DEVIL, 3 * GetDifficulty());
	AddHeroCreatures("Efion", CREATURE_IMP, 532 * GetDifficulty());
	AddHeroCreatures("Efion", CREATURE_SUCCUBUS, 19 * GetDifficulty());
	-------------------------------------------------------------------------------------------
	-- Additional units to have access to the underground; normally is the easiest way to "escape" from demon armies and engage with Veyer.
	-- The function will work yet for "normal" difficulty but not in "impossible"; Veyer is stronger and would be reasonable cut down the towns first.
	-- The enemy heroes and garrisons are as well more powerfull in higher difficulties
	AddObjectCreatures("Swift_boots", CREATURE_FRIGHTFUL_NIGHTMARE, 25 * GetDifficulty());
	AddObjectCreatures("Swift_boots", CREATURE_FIREBREATHER_HOUND, 50 * GetDifficulty());
	AddObjectCreatures("Swift_boots", CREATURE_SUCCUBUS, 40 * GetDifficulty());
	AddObjectCreatures("Swift_boots", CREATURE_PIT_SPAWN, 15 * GetDifficulty());

	AddObjectCreatures("frontierguard_red", CREATURE_HELLMARE, 20 * GetDifficulty());
	AddObjectCreatures("frontierguard_red", CREATURE_HORNED_DEMON, 70 * GetDifficulty());
	AddObjectCreatures("frontierguard_red", CREATURE_CERBERI, 40 * GetDifficulty());
	AddObjectCreatures("frontierguard_red", CREATURE_SUCCUBUS, 35 * GetDifficulty());

	AddObjectCreatures("underground_guard1", CREATURE_HELL_HOUND, 125 * GetDifficulty());
	AddObjectCreatures("underground_guard1", CREATURE_QUASIT, 225 * GetDifficulty());
	AddObjectCreatures("underground_guard1", CREATURE_HORNED_LEAPER, 225 * GetDifficulty());

	AddObjectCreatures("keymasterguard_blue", CREATURE_POLTERGEIST, 250 * GetDifficulty());
	AddObjectCreatures("keymasterguard_blue", CREATURE_SKELETON_WARRIOR, 500 * GetDifficulty());
	AddObjectCreatures("keymasterguard_blue", CREATURE_VAMPIRE_LORD, 100 * GetDifficulty());
	AddObjectCreatures("keymasterguard_blue", CREATURE_DEMILICH, 30 * GetDifficulty());

	AddObjectCreatures("keymasterguard_red", CREATURE_INFERNAL_SUCCUBUS, 100 * GetDifficulty());
	AddObjectCreatures("keymasterguard_red", CREATURE_QUASIT, 333 * GetDifficulty());
	AddObjectCreatures("keymasterguard_red", CREATURE_HORNED_LEAPER, 170 * GetDifficulty());
	AddObjectCreatures("keymasterguard_red", CREATURE_FIREBREATHER_HOUND, 100 * GetDifficulty());

	AddObjectCreatures("underground_guard2", CREATURE_HELL_HOUND, 125 * GetDifficulty());
	AddObjectCreatures("underground_guard2", CREATURE_QUASIT, 285 * GetDifficulty());
	AddObjectCreatures("underground_guard2", CREATURE_HORNED_LEAPER, 225 * GetDifficulty());

	--underground direction west to Eh_Tares
	AddObjectCreatures("undergroundW1", CREATURE_SUCCUBUS_SEDUCER, 50 * GetDifficulty());
	AddObjectCreatures("undergroundW1", CREATURE_QUASIT, 200 * GetDifficulty());
	AddObjectCreatures("undergroundW1", CREATURE_HORNED_DEMON, 170 * GetDifficulty());
	AddObjectCreatures("undergroundW1", CREATURE_CERBERI, 100 * GetDifficulty());

	AddObjectCreatures("undergroundW2", CREATURE_ARCHDEVIL, 10 * GetDifficulty());
	AddObjectCreatures("undergroundW2", CREATURE_BALOR, 10 * GetDifficulty());
	AddObjectCreatures("undergroundW2", CREATURE_HELLMARE, 15 * GetDifficulty());

	AddObjectCreatures("undergroundW3", CREATURE_LICH_MASTER, 25 * GetDifficulty());
	AddObjectCreatures("undergroundW3", CREATURE_DISEASE_ZOMBIE, 200 * GetDifficulty());
	AddObjectCreatures("undergroundW3", CREATURE_GHOST, 150 * GetDifficulty());
	AddObjectCreatures("undergroundW3", CREATURE_NOSFERATU, 100 * GetDifficulty());

	AddObjectCreatures("undergroundW4", CREATURE_AIR_ELEMENTAL, 100 * GetDifficulty());
	AddObjectCreatures("undergroundW4", CREATURE_EARTH_ELEMENTAL, 100 * GetDifficulty());
	AddObjectCreatures("undergroundW4", CREATURE_FIRE_ELEMENTAL, 100 * GetDifficulty());
	AddObjectCreatures("undergroundW4", CREATURE_WATER_ELEMENTAL, 100 * GetDifficulty());

	--underground direction south to Ur_Henoch
	AddObjectCreatures("undergroundS1", CREATURE_POLTERGEIST, 100 * GetDifficulty());
	AddObjectCreatures("undergroundS1", CREATURE_SKELETON_WARRIOR, 450 * GetDifficulty());
	AddObjectCreatures("undergroundS1", CREATURE_DISEASE_ZOMBIE, 225 * GetDifficulty());

	AddObjectCreatures("undergroundS2", CREATURE_HELLMARE, 20 * GetDifficulty());
	AddObjectCreatures("undergroundS2", CREATURE_INFERNAL_SUCCUBUS, 40 * GetDifficulty());
	AddObjectCreatures("undergroundS2", CREATURE_BALOR, 10 * GetDifficulty());
	AddObjectCreatures("undergroundS2", CREATURE_ARCHDEVIL, 5 * GetDifficulty());

	AddObjectCreatures("undergroundS3", CREATURE_VAMPIRE_LORD, 100 * GetDifficulty());
	AddObjectCreatures("undergroundS3", CREATURE_SKELETON_WARRIOR, 700 * GetDifficulty());
	AddObjectCreatures("undergroundS3", CREATURE_ZOMBIE, 280 * GetDifficulty());
	AddObjectCreatures("undergroundS3", CREATURE_MANES, 200 * GetDifficulty());

	AddObjectCreatures("undergroundS4", CREATURE_POLTERGEIST, 170 * GetDifficulty());
	AddObjectCreatures("undergroundS4", CREATURE_SKELETON_ARCHER, 730 * GetDifficulty());
	AddObjectCreatures("undergroundS4", CREATURE_DISEASE_ZOMBIE, 290 * GetDifficulty());
	AddObjectCreatures("undergroundS4", CREATURE_VAMPIRE, 120 * GetDifficulty());

	AddObjectCreatures("undergroundS5", CREATURE_LICH_MASTER, 30 * GetDifficulty());
	AddObjectCreatures("undergroundS5", CREATURE_VAMPIRE_LORD, 50 * GetDifficulty());
	AddObjectCreatures("undergroundS5", CREATURE_WRAITH, 20 * GetDifficulty());

	AddObjectCreatures("undergroundS6", CREATURE_WRAITH, 20 * GetDifficulty());
	AddObjectCreatures("undergroundS6", CREATURE_GHOST, 150 * GetDifficulty());
	AddObjectCreatures("undergroundS6", CREATURE_VAMPIRE, 100 * GetDifficulty());
	AddObjectCreatures("undergroundS6", CREATURE_DEMILICH, 35 * GetDifficulty());

	-- ground south
	AddObjectCreatures("south1", CREATURE_FRIGHTFUL_NIGHTMARE, 40 * GetDifficulty());
	AddObjectCreatures("south1", CREATURE_BALOR, 25 * GetDifficulty());

	AddObjectCreatures("south2", CREATURE_NOSFERATU, 90 * GetDifficulty());
	AddObjectCreatures("south2", CREATURE_SKELETON_WARRIOR, 333 * GetDifficulty());
	AddObjectCreatures("south2", CREATURE_ZOMBIE, 244 * GetDifficulty());
	AddObjectCreatures("south2", CREATURE_MANES, 188 * GetDifficulty());

	----Trying to avoid Deleb to take the "Raelag reinfocerments"
	AddObjectCreatures("stash", CREATURE_BALOR, 35 * GetDifficulty());
	AddObjectCreatures("stash", CREATURE_HELL_HOUND, 150 * GetDifficulty());
	AddObjectCreatures("stash", CREATURE_SUCCUBUS_SEDUCER, 80 * GetDifficulty());
	AddObjectCreatures("stash", CREATURE_FRIGHTFUL_NIGHTMARE, 50 * GetDifficulty());

	-- ground west 
	AddObjectCreatures("west1", CREATURE_PIT_SPAWN, 18 * GetDifficulty());
	AddObjectCreatures("west1", CREATURE_FIREBREATHER_HOUND, 75 * GetDifficulty());
	AddObjectCreatures("west1", CREATURE_INFERNAL_SUCCUBUS, 45 * GetDifficulty());
	AddObjectCreatures("west1", CREATURE_FRIGHTFUL_NIGHTMARE, 28 * GetDifficulty());

	AddObjectCreatures("west2", CREATURE_BALOR, 25 * GetDifficulty());
	AddObjectCreatures("west2", CREATURE_HELLMARE, 40 * GetDifficulty());
	AddObjectCreatures("west2", CREATURE_ARCHDEVIL, 10 * GetDifficulty());
	-------------------------------------------------------------------------------
	-- Inferno garrisons
	-- Side where is viable to run in early game
	AddObjectCreatures("inferno_garrison1", CREATURE_ARCHDEVIL, 3 * GetDifficulty());
	AddObjectCreatures("inferno_garrison1", CREATURE_CERBERI, 98 * GetDifficulty());
	AddObjectCreatures("inferno_garrison1", CREATURE_IMP, 500 * GetDifficulty());

	AddObjectCreatures("inferno_garrison2", CREATURE_ARCHDEVIL, 15 * GetDifficulty());
	AddObjectCreatures("inferno_garrison2", CREATURE_BALOR, 25 * GetDifficulty());
	AddObjectCreatures("inferno_garrison2", CREATURE_HORNED_DEMON, 450 * GetDifficulty());
	AddObjectCreatures("inferno_garrison2", CREATURE_INFERNAL_SUCCUBUS, 55 * GetDifficulty());
	AddObjectCreatures("inferno_garrison2", CREATURE_CERBERI, 300 * GetDifficulty());

	AddObjectCreatures("inferno_garrison3", CREATURE_CERBERI, 400 * GetDifficulty());
	AddObjectCreatures("inferno_garrison3", CREATURE_ARCHDEVIL, 8 * GetDifficulty());

	AddObjectCreatures("inferno_garrison4", CREATURE_HORNED_DEMON, 100 * GetDifficulty());
	AddObjectCreatures("inferno_garrison4", CREATURE_NIGHTMARE, 20 * GetDifficulty());

	AddObjectCreatures("inferno_garrison5", CREATURE_HELL_HOUND, 300 * GetDifficulty());
	AddObjectCreatures("inferno_garrison5", CREATURE_SUCCUBUS, 55 * GetDifficulty());
	AddObjectCreatures("inferno_garrison5", CREATURE_DEMON, 600 * GetDifficulty());

	AddObjectCreatures("inferno_garrison6", CREATURE_ARCHDEVIL, 3 * GetDifficulty());
	AddObjectCreatures("inferno_garrison6", CREATURE_IMP, 600 * GetDifficulty());
	AddObjectCreatures("inferno_garrison6", CREATURE_SUCCUBUS, 35 * GetDifficulty());
	AddObjectCreatures("inferno_garrison6", CREATURE_HELL_HOUND, 200 * GetDifficulty());

	-- Large garrisons situated in the middle of the map
	AddObjectCreatures("inferno_garrison7", CREATURE_ARCHDEVIL, 30 * GetDifficulty());
	AddObjectCreatures("inferno_garrison7", CREATURE_HELL_HOUND, 1000 * GetDifficulty());
	AddObjectCreatures("inferno_garrison7", CREATURE_BALOR, 50 * GetDifficulty());
	AddObjectCreatures("inferno_garrison7", CREATURE_SUCCUBUS, 85 * GetDifficulty());

	AddObjectCreatures("inferno_garrison8", CREATURE_ARCHDEVIL, 35 * GetDifficulty());
	AddObjectCreatures("inferno_garrison8", CREATURE_SUCCUBUS, 180 * GetDifficulty());
	AddObjectCreatures("inferno_garrison8", CREATURE_IMP, 3000 * GetDifficulty());
	AddObjectCreatures("inferno_garrison8", CREATURE_HELL_HOUND, 600 * GetDifficulty());

	AddObjectCreatures("inferno_garrison9", CREATURE_ARCHDEVIL, 30 * GetDifficulty());
	AddObjectCreatures("inferno_garrison9", CREATURE_BALOR, 50 * GetDifficulty());
	AddObjectCreatures("inferno_garrison9", CREATURE_CERBERI, 800 * GetDifficulty());
	AddObjectCreatures("inferno_garrison9", CREATURE_SUCCUBUS, 350 * GetDifficulty());
	AddObjectCreatures("inferno_garrison9", CREATURE_FIRE_ELEMENTAL, 400 * GetDifficulty());
	-------------------------------------------------------------------------------------------------
end
if extra > 2 then
	-- Extra units and skills for inferno heroes 
	-- Marbas
	GiveExp("Marder", 744000);
	GiveHeroSkill("Marder", NECROMANCER_FEAT_TWILIGHT);
	GiveHeroSkill("Marder", NECROMANCER_FEAT_SPELLPROOF_BONES);
	GiveHeroSkill("Marder", KNIGHT_FEAT_TRIPLE_BALLISTA);
	GiveHeroSkill("Marder", RANGER_FEAT_FOG_VEIL);

	AddHeroCreatures("Marder", CREATURE_IMP, 50);
	AddHeroCreatures("Marder", CREATURE_SUCCUBUS, 10);
	AddHeroCreatures("Marder", CREATURE_BALOR, 5);
	AddHeroCreatures("Marder", CREATURE_HELL_HOUND, 50);
	-- Deleb
	GiveExp("Deleb", 744000);
	GiveHeroSkill("Deleb", PERK_INTELLIGENCE);
	GiveHeroSkill("Deleb", NECROMANCER_FEAT_LAST_AID);
	GiveHeroSkill("Deleb", PERK_MASTER_OF_SICKNESS);
	GiveHeroSkill("Deleb", KNIGHT_FEAT_RETRIBUTION);

	AddHeroCreatures("Deleb", CREATURE_ARCHDEVIL, 3);
	AddHeroCreatures("Deleb", CREATURE_HORNED_DEMON, 100);
	AddHeroCreatures("Deleb", CREATURE_DEVIL, 5);
	AddHeroCreatures("Deleb", CREATURE_HELL_HOUND, 80);
	--Grawl
	GiveExp("Calid", 744000);
	GiveHeroSkill("Calid", PERK_DEMONIC_FIRE);
	GiveHeroSkill("Calid", DEMON_FEAT_DEMONIC_RETALIATION);
	GiveHeroSkill("Calid", WIZARD_FEAT_MAGIC_CUSHION); -- protection from shatter dark magic
	GiveHeroSkill("Calid", RANGER_FEAT_ELVEN_LUCK);

	AddHeroCreatures("Calid", CREATURE_ARCHDEVIL, 5);
	AddHeroCreatures("Calid", CREATURE_HELL_HOUND, 50);
	AddHeroCreatures("Calid", CREATURE_IMP, 50);
	AddHeroCreatures("Calid", CREATURE_BALOR, 10);

	-- Nebiros
	GiveExp("Jazaz", 247000);
	GiveHeroSkill("Jazaz", SKILL_GATING);
	GiveHeroSkill("Jazaz", DEMON_FEAT_CRITICAL_GATING);
	GiveHeroSkill("Jazaz", SKILL_LEARNING);
	GiveHeroSkill("Jazaz", SKILL_GATING);
	-- Alastor
	GiveExp("Efion", 247000);
	GiveHeroSkill("Efion", SKILL_GATING);
	GiveHeroSkill("Efion", DEMON_FEAT_CRITICAL_GATING);
	GiveHeroSkill("Efion", SKILL_LEARNING);
	GiveHeroSkill("Efion", PERK_INTELLIGENCE);
	end
	if extra > 3 then
	-- Marbas
	GiveExp("Marder", 1550000);
	GiveHeroSkill("Marder", HERO_SKILL_RUNIC_MACHINES);
	GiveHeroSkill("Marder", HERO_SKILL_QUICKNESS_OF_MIND);
	GiveHeroSkill("Marder", PERK_MASTER_OF_WRATH);
	GiveHeroSkill("Marder", WARLOCK_FEAT_TELEPORT_ASSAULT);

	AddHeroCreatures("Marder", CREATURE_IMP, 100);
	AddHeroCreatures("Marder", CREATURE_SUCCUBUS, 20);
	AddHeroCreatures("Marder", CREATURE_BALOR, 10);
	AddHeroCreatures("Marder", CREATURE_HELL_HOUND, 100);
	-- Deleb
	GiveExp("Deleb", 1550000);
	GiveHeroSkill("Deleb", HERO_SKILL_QUICKNESS_OF_MIND);
	GiveHeroSkill("Deleb", RANGER_FEAT_STORM_WIND);
	GiveHeroSkill("Deleb", RANGER_FEAT_SOIL_BURN);
	GiveHeroSkill("Deleb", NECROMANCER_FEAT_SPELLPROOF_BONES);

	AddHeroCreatures("Deleb", CREATURE_ARCHDEVIL, 5);
	AddHeroCreatures("Deleb", CREATURE_HORNED_DEMON, 200);
	AddHeroCreatures("Deleb", CREATURE_DEVIL, 10);
	AddHeroCreatures("Deleb", CREATURE_HELL_HOUND, 160);
	--Grawl
	GiveExp("Calid", 1550000);
	GiveHeroSkill("Calid", DEMON_FEAT_CRITICAL_GATING);
	GiveHeroSkill("Calid", HERO_SKILL_SET_AFIRE);
	GiveHeroSkill("Calid", NECROMANCER_FEAT_DEAD_LUCK);
	GiveHeroSkill("Calid", KNIGHT_FEAT_STUDENT_AWARD);	

	AddHeroCreatures("Calid", CREATURE_ARCHDEVIL, 10);
	AddHeroCreatures("Calid", CREATURE_HELL_HOUND, 100);
	AddHeroCreatures("Calid", CREATURE_IMP, 100);
	AddHeroCreatures("Calid", CREATURE_BALOR, 20);
	-- Nebiros
	GiveExp("Jazaz", 420000);
	GiveHeroSkill("Jazaz", SKILL_GATING);
	GiveHeroSkill("Jazaz", HERO_SKILL_QUICKNESS_OF_MIND);
	GiveHeroSkill("Jazaz", SKILL_LEARNING);
	GiveHeroSkill("Jazaz", SKILL_LEARNING);
	-- Alastor
	GiveExp("Efion", 420000);
	GiveHeroSkill("Efion", SKILL_GATING);
	GiveHeroSkill("Efion", HERO_SKILL_QUICKNESS_OF_MIND);
	GiveHeroSkill("Efion", SKILL_LEARNING);
	GiveHeroSkill("Efion", SKILL_LEARNING);
end

H55c_SetCampaignResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 1000 );
SetHeroRoleMode( 'Efion', HERO_ROLE_MODE_HERMIT );		
SetHeroRoleMode( 'Jazaz', HERO_ROLE_MODE_HERMIT );
--OpenRegionFog (1, "PALAEDRA");

function Start_Dialog()
StartDialogScene("/DialogScenes/C4/M5/R1/DialogScene.xdb#xpointer(/DialogScene)") 
end

--------------------------------------------
function PObjective1() 
	if IsObjectInRegion(Raelag, "PALAEDRA") and IsObjectInRegion(Kelodin, "PALAEDRA") then	
		print("PLAYER 1 in area.........................."); 
		sleep(2);
		SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
		ChangeHeroStat("Raelag", STAT_MORALE, 1);
		startThread(PObjective34); -----Palaedra!!!
	end
end


function PObjective2()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Raelag") == nil or IsHeroAlive("Kelodin") == nil then   ----Заменить 2го героя!!!
			print("Heroes deads.................................");
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			break;
		end
	end
end
---------------------------------------------Захват и разрушение замков!

function Castle_1()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Az_Hakol") == PLAYER_1) then
			RazeTown("Az_Hakol");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R2/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end
	end
end

function Castle_2()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Mammon") == PLAYER_1) then
			RazeTown("Mammon");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R3/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end
	end
end

function Castle_3()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Eh_Tares") == PLAYER_1) then	
			RazeTown("Eh_Tares");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R4/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end
	end
end
------------------------------------------------
function WinLoose_1()
	while 1 do
		if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			Loose();
			return
		end
		sleep();
	end
end
------------------------------------------------
function Post_01()  
	while 1 do
		sleep(10);
		if IsPlayerHeroesInRegion(1, "post_1") == true then   
			SetObjectOwner("POST1",1);
			SetObjectOwner("POST2",1);
			break;
		end
	end
end
------------------------------------------------------///////ACT2
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "PALAEDRA","PObjective1", nil );  --PALAEDRA!!!

function PrepareVeyerCombat()
	local koef = GetDifficulty() + 1;
	AddHeroCreatures( "Veyer", CREATURE_IMP, 499);
    AddHeroCreatures( "Veyer",	  CREATURE_CERBERI, 400);
    AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 100);
    AddHeroCreatures( "Veyer",	CREATURE_ARCHDEVIL,  25);
    AddHeroCreatures( "Veyer", CREATURE_FIRE_ELEMENTAL, 100);
	ChangeHeroStat( "Veyer", STAT_ATTACK, koef * 5 );
    ChangeHeroStat( "Veyer",     STAT_DEFENCE, koef * 5 );
    ChangeHeroStat( "Veyer", STAT_SPELL_POWER, koef * 5 );
    ChangeHeroStat( "Veyer", STAT_KNOWLEDGE, koef * 5 );
    sleep(7);
    ChangeHeroStat( "Veyer", STAT_MANA_POINTS, 500);
	sleep(7);
	GiveArtifact("Veyer", 9); -- Shield of Crystal Ice = +40% fire protection  
	GiveArtifact("Veyer", 43); -- Dragon Flame Tongue = +40% cold protection 
	GiveArtifact("Veyer",20) -- Ring of Lightning Protection = +40% lightning protection
	GiveArtifact("Veyer", 62); -- Cloak of Sylanna = +40% earth protection
	if koef > 1 then
		GiveHeroSkill( "Veyer", NECROMANCER_FEAT_LAST_AID );
		GiveHeroSkill( "Veyer", PERK_INTELLIGENCE );
		GiveHeroSkill( "Veyer", WIZARD_FEAT_WILDFIRE );
		GiveHeroSkill( "Veyer", DEMON_FEAT_CRITICAL_GATING );
		GiveHeroSkill( "Veyer", HERO_SKILL_EMPATHY );
		GiveHeroSkill( "Veyer", PERK_TOUGHNESS );
		GiveHeroSkill( "Veyer", SKILL_LEADERSHIP );
		GiveHeroSkill( "Veyer", HERO_SKILL_SHATTER_DARK_MAGIC );
		GiveHeroSkill( "Veyer", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC );
		GiveHeroSkill( "Veyer", PERK_RESISTANCE );
		AddHeroCreatures( "Veyer", CREATURE_IMP, 300 );
		AddHeroCreatures( "Veyer", CREATURE_CERBERI, 250 );
		AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 50);
		AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL,  20 );
		AddHeroCreatures( "Veyer", CREATURE_FIRE_ELEMENTAL, 100);
		sleep(7);
		ChangeHeroStat( "Veyer", STAT_MANA_POINTS, 500);
		sleep(7);
	end
	if koef > 2 then
		GiveHeroSkill( "Veyer", WIZARD_FEAT_MAGIC_CUSHION); -- protection from shatter dark magic
		GiveHeroSkill( "Veyer", KNIGHT_FEAT_ANCIENT_SMITHY );
		GiveHeroSkill( "Veyer", HERO_SKILL_RUNIC_MACHINES );
		GiveHeroSkill( "Veyer", NECROMANCER_FEAT_DEAD_LUCK );
		GiveHeroSkill( "Veyer", PERK_CATAPULT );
		GiveHeroSkill( "Veyer", KNIGHT_FEAT_STUDENT_AWARD);	
		GiveHeroSkill( "Veyer", HERO_SKILL_SHATTER_DARK_MAGIC );
		GiveHeroSkill( "Veyer", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC );	
		GiveHeroSkill( "Veyer", DEMON_FEAT_GATING_MASTERY );	
		GiveHeroSkill( "Veyer", DEMON_FEAT_QUICK_GATING );	
		GiveArtifact("Veyer", 25); -- Golden Horseshoe = +3 luck				
		AddHeroCreatures( "Veyer", CREATURE_IMP, 200 );
		AddHeroCreatures( "Veyer", CREATURE_CERBERI, 200 );
		AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 50);
		AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL, 15 );
		AddHeroCreatures( "Veyer", CREATURE_FIRE_ELEMENTAL, 50);
		sleep(7);
		ChangeHeroStat( "Veyer", STAT_MANA_POINTS, 500);
		sleep(7);
	end
	if koef > 3 then
		GiveHeroSkill( "Veyer", HERO_SKILL_QUICKNESS_OF_MIND );
		GiveHeroSkill( "Veyer", RANGER_FEAT_SUN_FIRE );
		GiveHeroSkill( "Veyer", HERO_SKILL_WEAKEN_DARK );
		GiveHeroSkill( "Veyer", HERO_SKILL_DETAIN_DARK );
		GiveHeroSkill( "Veyer", HERO_SKILL_WEAKEN_DESTRUCTIVE );
		GiveHeroSkill( "Veyer", HERO_SKILL_DETAIN_DESTRUCTIVE );	
		GiveHeroSkill( "Veyer", DEMON_FEAT_ABSOLUTE_GATING);
		GiveHeroSkill( "Veyer", HERO_SKILL_DWARVEN_LUCK);
		GiveHeroSkill( "Veyer", KNIGHT_FEAT_TRIPLE_BALLISTA);				
		AddHeroCreatures( "Veyer", CREATURE_IMP, 100 );
		AddHeroCreatures( "Veyer", CREATURE_CERBERI, 150 );
		AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 40);
		AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL, 15 );
		AddHeroCreatures( "Veyer", CREATURE_FIRE_ELEMENTAL, 50);
		sleep(7);
		ChangeHeroStat( "Veyer", STAT_MANA_POINTS, 500);
		sleep(7);
	end
end

function PObjective34()
sleep(2);
BlockGame();
sleep(2);
DeployReserveHero( "Veyer", 4, 31, GROUND );
DeployReserveHero( "Isabell", 4, 24, GROUND );
DeployReserveHero( "Berein", 3, 23, GROUND );
--EnableHeroAI("Veyer",nil);
EnableHeroAI("Isabell",nil);
EnableHeroAI("Berein",nil);   
sleep(6);
PrepareVeyerCombat();
MoveHeroRealTime( "Isabell", 5, 25, GROUND );
MoveHeroRealTime( "Berein", 4, 23, GROUND );
sleep(2);
SetObjectiveState('prim3',OBJECTIVE_ACTIVE); 
SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
sleep(1);
UnblockGame();
sleep(2);
startThread(PObjective3_4complete);
startThread(PObjective3_4defead);
ChangeHeroStat("Raelag", STAT_MOVE_POINTS, 12000);
ChangeHeroStat("Raelag", STAT_MORALE, 2);  -------Oblico_Morale!
end

function PObjective3_4complete()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Veyer") == nil then 
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			--SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
			SaveHeroAllSetArtifactsEquipped(  "Raelag", "C4M5" );
			--SaveHeroAllSetArtifactsEquipped( "Kelodin", "C4M5" );
			sleep(10);
			Save("Save") 
			sleep(10);
			StartDialogScene("/DialogScenes/C4/M5/D1/DialogScene.xdb#xpointer(/DialogScene)")
			sleep(10);
			StartCutScene("/Maps/Cutscenes/C4M5/_.(AnimScene).xdb#xpointer(/AnimScene)");
			Win(); 
			break;
		end	
	end
end

function PObjective3_4defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Isabell") == nil then
			SetObjectiveState('prim4',OBJECTIVE_FAILED);
			sleep(20);
			Loose();
			break;
		end
	end
end

startThread(Start_Dialog);
startThread(PObjective2);
startThread(Castle_1);
startThread(Castle_2);
startThread(Castle_3);
startThread(WinLoose_1);
startThread(Post_01);
