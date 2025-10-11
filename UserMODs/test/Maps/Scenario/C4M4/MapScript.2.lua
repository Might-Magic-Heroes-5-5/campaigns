doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M4");
    LoadHeroAllSetArtifacts("Raelag","C4M3");
end;

startThread(H55_InitSetArtifacts);

---FUNCTIONS---
for a = 0,6 do
	SetPlayerResource(PLAYER_1, a, 0);
end;

if GetDifficulty() == DIFFICULTY_EASY then
	dif = 0;
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	dif = 0;
end;
if GetDifficulty() == DIFFICULTY_HARD then
	dif = 1;
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	dif = 2;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	print ( HeroName );
	if HeroName == "Raelag" or HeroName == "Kelodin" then
		SetObjectiveState("prim3", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "LostHero2" );
function LostHero2( HeroName3 )
	if (HeroName3 == "Efion") then
		StartDialogScene('/DialogScenes/C4/M4/R3/DialogScene.xdb#xpointer(/DialogScene)');
		SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
		sleep ( 2 );
		GiveBorderguardKey(1 , RED_KEY);
		LevelUpHero("Raelag");
	end;
end;

Trigger(OBJECT_TOUCH_TRIGGER , 'Gate','key');

function key()
	SaveHeroAllSetArtifactsEquipped("Raelag", "C4M4");
	StartDialogScene('/DialogScenes/C4/M4/R4/DialogScene.xdb#xpointer(/DialogScene)');
	SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
	sleep(5);
	--LevelUpHero("Raelag");
	sleep(10);
	Win();
end;

function tent_use()
	--	RemoveObject("Mushrooms");
	Trigger(OBJECT_TOUCH_TRIGGER, 'tent' , "tent_use2");
	sleep (1);
	StartDialogScene('/DialogScenes/C4/M4/D1/DialogScene.xdb#xpointer(/DialogScene)');
end;

function tent_use2()
	MessageBox('/Maps/Scenario/C4M4/keymaster.txt');
end;

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
	MoveHeroRealTime('Efion', 81, 51);
	sleep(20);
	SetObjectPosition('Efion', 64, 78, 0);
	UnblockGame();
--	EnableHeroAI('Efion', not nil);
end;

function H55_TriggerDaily()
	if GetDate(MONTH) == 3 then
		Loose();
	end;
	if GetDate(MONTH) == 2 and GetDate(WEEK) == 4 and GetDate(DAY_OF_WEEK) == 1 then
		MessageBox ("/Maps/Scenario/C4M4/C4M4_1.txt");
	end;
	if GetDate(MONTH) == 1 and GetDate(WEEK) == 2 and GetDate(DAY_OF_WEEK) == 3 then
		EnableHeroAI('Efion', not nil);
	end;
end;


---SCRIPT MAIN PART---
StartDialogScene('/DialogScenes/C4/M4/R1/DialogScene.xdb#xpointer(/DialogScene)');
EnableHeroAI('Efion', nil);
SetObjectEnabled('tent', nil);
SetObjectEnabled('teleport1', nil);
SetObjectEnabled('Gate', nil);
Trigger(OBJECT_TOUCH_TRIGGER , 'tent','tent_use');
Trigger(OBJECT_TOUCH_TRIGGER, 'teleport1', 'teleport');
H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER, 'loose');

if GetDifficulty() == DIFFICULTY_NORMAL then
	print ("normal");
	AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 25);
	AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 15);
	AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 2);
	RemoveObject("dogs");
end;

if GetDifficulty() == DIFFICULTY_EASY then
	print ("easy");
	AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 30);
	AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 20);
	AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 5);
	RemoveObject("dogs");
end;

H55_CamFixTooManySkills(PLAYER_1,"Raelag");
H55_CamFixTooManySkills(PLAYER_1,"Kelodin");
exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
ChangeHeroStat('Efion', STAT_EXPERIENCE , exp/(3-dif));
AddHeroCreatures('Efion',CREATURE_IMP , 50 + dif*40);
AddHeroCreatures('Efion',CREATURE_HORNED_DEMON ,35 + dif*25);
AddHeroCreatures('Efion',CREATURE_CERBERI , 25 + dif*15);
AddHeroCreatures('Efion',CREATURE_INFERNAL_SUCCUBUS , 8 + dif*13);
AddHeroCreatures('Efion',CREATURE_BALOR , 2 + dif*5);
AddHeroCreatures('Efion',CREATURE_ARCHDEVIL , 1 + dif);

SetRegionBlocked("blok1", 1, PLAYER_2);
SetRegionBlocked("blok2", 1, PLAYER_2);
SetRegionBlocked("blok3", 1, PLAYER_2);
SetRegionBlocked("blok4", 1, PLAYER_2);
SetRegionBlocked("blok5", 1, PLAYER_2);
SetRegionBlocked("blok6", 1, PLAYER_2);
SetRegionBlocked("blok7", 1, PLAYER_2);
SetRegionBlocked("blok8", 1, PLAYER_2);
SetRegionBlocked("blok9", 1, PLAYER_2);
SetRegionBlocked("blok10", 1, PLAYER_2);
SetRegionBlocked("blok11", 1, PLAYER_2);
SetRegionBlocked("blok12", 1, PLAYER_2);
SetRegionBlocked("blok13", 1, PLAYER_2);
SetRegionBlocked("blok14", 1, PLAYER_2);
SetRegionBlocked("blok15", 1, PLAYER_2);
SetRegionBlocked("blok20", 1, PLAYER_2);
print ("blok");