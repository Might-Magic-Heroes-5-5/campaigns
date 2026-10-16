doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M4");
    LoadHeroAllSetArtifacts(  "Raelag", "C4M3" );
    -- LoadHeroAllSetArtifacts( "Kelodin", "C4M3" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1,  "Raelag" );
	H55_CamFixTooManySkills( PLAYER_1, "Kelodin" );
end

startThread(H55_InitSetArtifacts);
ENEMY_HERO = "Calid";

H55c_SetCampaignResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0 );

if GetDifficulty() == DIFFICULTY_EASY then
	dif = 0;
end
if GetDifficulty() == DIFFICULTY_NORMAL then
	dif = 0;
end
if GetDifficulty() == DIFFICULTY_HARD then
	dif = 1;
end
if GetDifficulty() == DIFFICULTY_HEROIC then
	dif = 2;
end

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	print ( HeroName );
	if HeroName == "Raelag" or HeroName == "Kelodin" then
		SetObjectiveState("prim3", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end
end

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "LostHero2" );
function LostHero2( HeroName3 )
	if HeroName3 == ENEMY_HERO then
		StartDialogScene('/DialogScenes/C4/M4/R3/DialogScene.xdb#xpointer(/DialogScene)');
		SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
		sleep ( 20 );
		GiveBorderguardKey(1 , RED_KEY);
		LevelUpHero("Raelag");
	end
end

Trigger(OBJECT_TOUCH_TRIGGER , 'Gate','key');

function key()
	SaveHeroAllSetArtifactsEquipped(  "Raelag", "C4M4");
	-- SaveHeroAllSetArtifactsEquipped( "Kelodin", "C4M4");
	sleep(50);
	StartDialogScene('/DialogScenes/C4/M4/R4/DialogScene.xdb#xpointer(/DialogScene)');
	SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
	sleep(30);
	LevelUpHero("Raelag"); -- function works only below level 40
	sleep(20);
	Win();
end

function tent_use()
	--	RemoveObject("Mushrooms");
	Trigger(OBJECT_TOUCH_TRIGGER, 'tent' , "tent_use2");
	sleep (1);
	StartDialogScene('/DialogScenes/C4/M4/D1/DialogScene.xdb#xpointer(/DialogScene)');
end

function tent_use2()
	MessageBox('/Maps/Scenario/C4M4/keymaster.txt');
end

function teleport(HeroName2)
	Trigger(OBJECT_TOUCH_TRIGGER, 'teleport1' , nil);
	BlockGame();
	SetObjectPosition(HeroName2, 68, 50);
	sleep(12);
	SetObjectEnabled('teleport1', not nil);
	StartDialogScene('/DialogScenes/C4/M4/R2/DialogScene.xdb#xpointer(/DialogScene)');
	sleep ( 6 );
	RemoveObject("del1");
	RemoveObject("del8");
	sleep ( 2 );
	RemoveObject("del2");
	RemoveObject("del7");
	sleep ( 2 );
	RemoveObject("del5");
	RemoveObject("del4");
	sleep ( 2 );
	RemoveObject("del3");
	RemoveObject("del6");
	SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
	sleep(2);
	MoveHeroRealTime(ENEMY_HERO, 81, 51);
	sleep(20);
	SetObjectPosition(ENEMY_HERO, 64, 78, 0);
	UnblockGame();
end

function H55_TriggerDaily()
	if GetDate(MONTH) == 3 then
		Loose();
	end
	if GetDate(MONTH) == 2 and GetDate(WEEK) == 4 and GetDate(DAY_OF_WEEK) == 1 then
		MessageBox ("/Maps/Scenario/C4M4/C4M4_1.txt");
	end
	if GetDate(MONTH) == 1 and GetDate(WEEK) == 2 and GetDate(DAY_OF_WEEK) == 3 then
		EnableHeroAI(ENEMY_HERO, not nil);
	end
end

StartDialogScene('/DialogScenes/C4/M4/R1/DialogScene.xdb#xpointer(/DialogScene)');
EnableHeroAI(ENEMY_HERO, nil);
SetObjectEnabled('tent', nil);
SetObjectEnabled('teleport1', nil);
SetObjectEnabled('Gate', nil);
Trigger(OBJECT_TOUCH_TRIGGER , 'tent','tent_use');
Trigger(OBJECT_TOUCH_TRIGGER, 'teleport1', 'teleport');
H55_NewDayTrigger = 1;

if GetDifficulty() == DIFFICULTY_NORMAL then
	print ("hard");
	AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 25);
	AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 15);
	AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 2);
	RemoveObject("dogs");
end

if GetDifficulty() == DIFFICULTY_EASY then
	print ("normal");
	AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 30);
	AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 20);
	AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 5);
	RemoveObject("dogs");
end

local lab = GetDifficulty() + 1
exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
ChangeHeroStat(ENEMY_HERO, STAT_EXPERIENCE , exp/(3-dif));
for i=1,15 do
	SetRegionBlocked("blok"..i, 1, PLAYER_2);
end
SetRegionBlocked("blok20", 1, PLAYER_2);

AddHeroCreatures(ENEMY_HERO,CREATURE_IMP , 50 + dif*100);
AddHeroCreatures(ENEMY_HERO,CREATURE_HORNED_DEMON ,35 + dif*75);
AddHeroCreatures(ENEMY_HERO,CREATURE_CERBERI , 25 + dif*50);
AddHeroCreatures(ENEMY_HERO,CREATURE_INFERNAL_SUCCUBUS , 8 + dif*35);
AddHeroCreatures(ENEMY_HERO,CREATURE_BALOR , 2 + dif*10);
AddHeroCreatures(ENEMY_HERO,CREATURE_ARCHDEVIL , 1 + dif*3);
GiveHeroWarMachine("Calid", WAR_MACHINE_BALLISTA);
GiveHeroWarMachine("Calid", WAR_MACHINE_FIRST_AID_TENT);
GiveHeroWarMachine("Calid", WAR_MACHINE_AMMO_CART);

if lab > 1 then
    ChangeHeroStat(ENEMY_HERO, STAT_ATTACK, 4 * GetDifficulty());
	ChangeHeroStat(ENEMY_HERO, STAT_DEFENCE, 4 * GetDifficulty());
	ChangeHeroStat(ENEMY_HERO, STAT_SPELL_POWER, 4 * GetDifficulty());
	ChangeHeroStat(ENEMY_HERO, STAT_KNOWLEDGE, 4 * GetDifficulty());

    AddObjectCreatures("keymaster_guard", CREATURE_NOSFERATU, 30 * GetDifficulty());
    AddObjectCreatures("keymaster_guard", CREATURE_SKELETON_ARCHER, 100 * GetDifficulty());
    AddObjectCreatures("keymaster_guard", CREATURE_ZOMBIE, 30 * GetDifficulty());
    AddObjectCreatures("keymaster_guard", CREATURE_GHOST, 40 * GetDifficulty());

    AddObjectCreatures("dem1", CREATURE_HORNED_DEMON, 90 * GetDifficulty());
    AddObjectCreatures("dem1", CREATURE_FAMILIAR, 153 * GetDifficulty());
    AddObjectCreatures("dem1", CREATURE_CERBERI, 40 * GetDifficulty());

    AddObjectCreatures("dem2", CREATURE_IMP, 70 * GetDifficulty());    
    AddObjectCreatures("dem2", CREATURE_HORNED_LEAPER, 55 * GetDifficulty());
    AddObjectCreatures("dem2", CREATURE_HELL_HOUND, 45 * GetDifficulty());

    AddObjectCreatures("dogs", CREATURE_HORNED_DEMON, 180 * GetDifficulty());
    AddObjectCreatures("dogs", CREATURE_HORNED_LEAPER, 180 * GetDifficulty());

    AddObjectCreatures("BorderLine", CREATURE_SWORDSMAN, 200 * GetDifficulty());
    AddObjectCreatures("BorderLine", CREATURE_MARKSMAN, 100 * GetDifficulty());
    AddObjectCreatures("BorderLine", CREATURE_VINDICATOR, 150 * GetDifficulty());
    AddObjectCreatures("BorderLine", CREATURE_MILITIAMAN, 200 * GetDifficulty());

    AddObjectCreatures("hill_guards", CREATURE_FRIGHTFUL_NIGHTMARE, 15 * GetDifficulty());
    AddObjectCreatures("hill_guards", CREATURE_HORNED_LEAPER, 50 * GetDifficulty());
    AddObjectCreatures("hill_guards", CREATURE_HELL_HOUND, 40 * GetDifficulty());
    AddObjectCreatures("hill_guards", CREATURE_INFERNAL_SUCCUBUS, 15 * GetDifficulty());

    AddObjectCreatures("elf1", CREATURE_SPRITE, 100 * GetDifficulty());
    AddObjectCreatures("elf1", CREATURE_BLADE_JUGGLER, 80 * GetDifficulty());
    AddObjectCreatures("elf1", CREATURE_WOOD_ELF, 40 * GetDifficulty());

    AddObjectCreatures("elf2", CREATURE_SHARP_SHOOTER, 50 * GetDifficulty());
    AddObjectCreatures("elf2", CREATURE_PIXIE, 80 * GetDifficulty());
    AddObjectCreatures("elf2", CREATURE_BLADE_JUGGLER, 65 * GetDifficulty());

    AddObjectCreatures("hav1", CREATURE_SWORDSMAN, 50 * GetDifficulty());
    AddObjectCreatures("hav1", CREATURE_MILITIAMAN, 150 * GetDifficulty());
    AddObjectCreatures("hav1", CREATURE_MARKSMAN, 60 * GetDifficulty());

    AddObjectCreatures("aca1", CREATURE_OBSIDIAN_GOLEM, 30 * GetDifficulty());
    AddObjectCreatures("aca1", CREATURE_MASTER_GREMLIN, 100 * GetDifficulty());
    AddObjectCreatures("aca1", CREATURE_STONE_GARGOYLE, 100 * GetDifficulty());

    AddObjectCreatures("dwa1", CREATURE_BLACKBEAR_RIDER, 30 * GetDifficulty());
    AddObjectCreatures("dwa1", CREATURE_STONE_DEFENDER, 80 * GetDifficulty());
    AddObjectCreatures("dwa1", CREATURE_AXE_FIGHTER, 70 * GetDifficulty());

    AddObjectCreatures("orc1", CREATURE_GOBLIN_DEFILER, 30 * GetDifficulty());
    AddObjectCreatures("orc1", CREATURE_SHAMAN_WITCH, 20 * GetDifficulty());
    AddObjectCreatures("orc1", CREATURE_CENTAUR, 65 * GetDifficulty());
    AddObjectCreatures("orc1", CREATURE_ORC_WARRIOR, 55 * GetDifficulty());

    AddObjectCreatures("elf3", CREATURE_WAR_DANCER, 40 * GetDifficulty());
    AddObjectCreatures("elf3", CREATURE_SPRITE, 60 * GetDifficulty());
    AddObjectCreatures("elf3", CREATURE_SHARP_SHOOTER, 30 * GetDifficulty());

    AddObjectCreatures("hav2", CREATURE_FOOTMAN, 50 * GetDifficulty());
    AddObjectCreatures("hav2", CREATURE_MILITIAMAN, 100 * GetDifficulty());
    AddObjectCreatures("hav2", CREATURE_ARCHER, 80 * GetDifficulty());

    AddObjectCreatures("dar1", CREATURE_BLOOD_WITCH, 30 * GetDifficulty());
    AddObjectCreatures("dar1", CREATURE_SCOUT, 60 * GetDifficulty());
    AddObjectCreatures("dar1", CREATURE_MINOTAUR, 40 * GetDifficulty());

    AddObjectCreatures("hav3", CREATURE_SWORDSMAN, 30 * GetDifficulty());
    AddObjectCreatures("hav3", CREATURE_PEASANT, 150 * GetDifficulty());
    AddObjectCreatures("hav3", CREATURE_ARCHER, 80 * GetDifficulty());

    AddObjectCreatures("hav4", CREATURE_GRIFFIN, 30 * GetDifficulty());
    AddObjectCreatures("hav4", CREATURE_MILITIAMAN, 100 * GetDifficulty());
    AddObjectCreatures("hav4", CREATURE_ARCHER, 80 * GetDifficulty());
    AddObjectCreatures("hav4", CREATURE_SWORDSMAN, 50 * GetDifficulty());

    AddObjectCreatures("elf4", CREATURE_WAR_UNICORN, 10 * GetDifficulty());
    AddObjectCreatures("elf4", CREATURE_BLADE_JUGGLER, 30 * GetDifficulty());
    AddObjectCreatures("elf4", CREATURE_SHARP_SHOOTER, 20 * GetDifficulty());
    AddObjectCreatures("elf4", CREATURE_DRUID, 15 * GetDifficulty());

    AddObjectCreatures("nec1", CREATURE_ZOMBIE, 100 * GetDifficulty());
    AddObjectCreatures("nec1", CREATURE_SKELETON_ARCHER, 100 * GetDifficulty());
    AddObjectCreatures("nec1", CREATURE_MANES, 70 * GetDifficulty());

    AddObjectCreatures("hav5", CREATURE_SWORDSMAN, 40 * GetDifficulty());
    AddObjectCreatures("hav5", CREATURE_PEASANT, 150 * GetDifficulty());
    AddObjectCreatures("hav5", CREATURE_ARCHER, 60 * GetDifficulty());

    AddObjectCreatures("elf5", CREATURE_WOOD_ELF, 25 * GetDifficulty());
    AddObjectCreatures("elf5", CREATURE_DRYAD, 60 * GetDifficulty());
    AddObjectCreatures("elf5", CREATURE_BLADE_JUGGLER, 50 * GetDifficulty());

    AddObjectCreatures("inf1", CREATURE_CERBERI, 30 * GetDifficulty());
    AddObjectCreatures("inf1", CREATURE_IMP, 60 * GetDifficulty());
    AddObjectCreatures("inf1", CREATURE_HORNED_LEAPER, 50 * GetDifficulty());
    AddObjectCreatures("inf1", CREATURE_SUCCUBUS, 20 * GetDifficulty());

    AddObjectCreatures("acaa", CREATURE_STEEL_GOLEM, 50 * GetDifficulty());
    AddObjectCreatures("acaa", CREATURE_GREMLIN, 150 * GetDifficulty());
    AddObjectCreatures("acaa", CREATURE_STONE_GARGOYLE, 100 * GetDifficulty());
	
	AddObjectCreatures("nec2", CREATURE_LICH_MASTER, 15 * GetDifficulty());
    AddObjectCreatures("nec2", CREATURE_WALKING_DEAD, 60 * GetDifficulty());
    AddObjectCreatures("nec2", CREATURE_POLTERGEIST, 30 * GetDifficulty());
    AddObjectCreatures("nec2", CREATURE_NOSFERATU, 15 * GetDifficulty());	

    AddObjectCreatures("nec3", CREATURE_GHOST, 40 * GetDifficulty());
    AddObjectCreatures("nec3", CREATURE_SKELETON_ARCHER, 100 * GetDifficulty());
    AddObjectCreatures("nec3", CREATURE_WALKING_DEAD, 100 * GetDifficulty());

    AddObjectCreatures("inf2", CREATURE_INFERNAL_SUCCUBUS, 20 * GetDifficulty());
    AddObjectCreatures("inf2", CREATURE_IMP, 100 * GetDifficulty());
    AddObjectCreatures("inf2", CREATURE_DEMON, 100 * GetDifficulty());
    AddObjectCreatures("inf2", CREATURE_HELL_HOUND, 50 * GetDifficulty());
	
    AddObjectCreatures("acaa2", CREATURE_ARCH_MAGI, 30 * GetDifficulty());
    AddObjectCreatures("acaa2", CREATURE_GREMLIN_SABOTEUR, 100 * GetDifficulty());
    AddObjectCreatures("acaa2", CREATURE_STONE_GARGOYLE, 100 * GetDifficulty());
    AddObjectCreatures("acaa2", CREATURE_IRON_GOLEM, 50 * GetDifficulty());
	
    AddObjectCreatures("inf3", CREATURE_CERBERI, 30 * GetDifficulty());
    AddObjectCreatures("inf3", CREATURE_FAMILIAR, 100 * GetDifficulty());
    AddObjectCreatures("inf3", CREATURE_HORNED_LEAPER, 50 * GetDifficulty());
	
    AddObjectCreatures("nec5", CREATURE_POLTERGEIST, 50 * GetDifficulty());
    AddObjectCreatures("nec5", CREATURE_SKELETON_WARRIOR, 80 * GetDifficulty());
    AddObjectCreatures("nec5", CREATURE_ZOMBIE, 60 * GetDifficulty());
	
    AddObjectCreatures("acaa3", CREATURE_STEEL_GOLEM, 50 * GetDifficulty());
    AddObjectCreatures("acaa3", CREATURE_GREMLIN_SABOTEUR, 100 * GetDifficulty());
    AddObjectCreatures("acaa3", CREATURE_MARBLE_GARGOYLE, 80 * GetDifficulty());

    AddObjectCreatures("dar2", CREATURE_BLACK_RIDER, 20 * GetDifficulty());
    AddObjectCreatures("dar2", CREATURE_SCOUT, 50 * GetDifficulty());
    AddObjectCreatures("dar2", CREATURE_BLOOD_WITCH_2, 40 * GetDifficulty());
    AddObjectCreatures("dar2", CREATURE_MINOTAUR, 30 * GetDifficulty());
	
    AddObjectCreatures("nec4", CREATURE_VAMPIRE_LORD, 30 * GetDifficulty());
    AddObjectCreatures("nec4", CREATURE_SKELETON_ARCHER, 100 * GetDifficulty());
    AddObjectCreatures("nec4", CREATURE_WALKING_DEAD, 100 * GetDifficulty());
    AddObjectCreatures("nec4", CREATURE_POLTERGEIST, 50 * GetDifficulty());	
end
