doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M3");
    LoadHeroAllSetArtifacts("Berein", "C3M2" );
end;

H55_NewDayTrigger = 1;
ElvenHeroActive = 0;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

StartDialogScene("/DialogScenes/C3/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
C3M3_C1 = 0;
C3M3_C2 = 0;
C3M3_C3 = 0;
C3M3_C4 = 0;
C3M3_C5 = 0;
C3M3_C6 = 0;
C3M3_C7 = 0;
C3M3_C8 = 0;
C3M3_C9 = 0;
D_day_timer = 0;
counter = 0;
StaffFlag = 0;
Town1Converted = 0;
Town2Converted = 0;
Town3Converted = 0;
ElvenCondition = 0;
CyrusName = "Cyrus";
ElvenHero = "Nadaur";
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

function DifficultyDependency()
	if GetDifficulty() == DIFFICULTY_EASY then
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
	else
		if GetDifficulty() == DIFFICULTY_NORMAL then
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
		else
		if GetDifficulty() == DIFFICULTY_HARD then
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
			else
				if GetDifficulty() == DIFFICULTY_HEROIC then
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
				end;
			end;
		end;
	end;
end;

function EnableAIForRazzakAndTimerkhan()
	sleep(5);
	while GetDate(DAY) ~= 36 and GetObjectOwner("Town1")==PLAYER_2 do
		sleep(15);
	end;
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
		end;
		else
			print("hero Razzak is dead");
	end;
	while GetDate(DAY) ~= 57 do
		sleep(15);
	end;
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
		end;
		else
			print("hero Maahir is dead");
	end;
end;


function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;


function ObjectiveGetArtefactComplete(ArtefactName,ObjectiveName,Scene)
	while 1 do
		sleep(5);
		if HasArtefact( "Berein", ArtefactName) == not nil then
			print("Objective ",ObjectiveName," for artefact ",ArtefactName," completed");
			startThread(SetArtefactUntrans,ArtefactName);
			SetObjectiveState(ObjectiveName,OBJECTIVE_COMPLETED);
			StartDialogScene(Scene);
			ObjectiveExp("Berein");
			return
		end;
	end;
end;


function PObjective4()
	while D_day_timer == 0 do
		sleep(5);
	end;
	sleep(30);
	if GetObjectiveState("prim4") == OBJECTIVE_UNKNOWN then
		SetObjectiveState("prim4",OBJECTIVE_ACTIVE);--при установке состояния задания в OBJECTIVE_ACTIVE оно автоматически становится видимым игроку
	else
		print("Warning!!! prim4 is not UNKNOWN");
	end;
	while 1 do
		sleep();
	end;
end;

function PObjective5()
	sleep(30);
while 1 do
	if IsHeroAlive("Berein")==nil or IsHeroAlive("Isabell")==nil then
		SetObjectiveState("prim5",OBJECTIVE_FAILED);
		sleep(6);
		print("Hero is dead!!!");
		Loose(PLAYER_1);
		return 1;
	end;
	if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim1") == OBJECTIVE_COMPLETED
		and GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
		if GetObjectiveState("prim5") == OBJECTIVE_ACTIVE  then
			SetObjectiveState("prim5",OBJECTIVE_COMPLETED);
		else
			print("Warning!!! prim5 is not ACTIVE");
		end;
		return 1;
	end;
sleep(5);
end;
end;

function SObjective1()
	while 1 do
		sleep(10);
		if HasArtefact("Berein",ARTIFACT_STAFF_OF_VEXINGS) == not nil then
			SetObjectiveState("sec1",OBJECTIVE_ACTIVE);
			startThread(CompleteSObj1);
			break;
		end;
	end;
end;

function CompleteSObj1()
	while 1 do
		sleep(10);
		if Town1Converted==1 and Town2Converted==1 and Town3Converted==1 then
			print("All towns are converted");
			SetObjectiveState("sec1",OBJECTIVE_COMPLETED);
			ObjectiveExp("Berein");
			break;
		end;
	end;
end;

function messages( dialog )
	if dialog == 1 then
		print("scene 1 has been started...");
		C3M3_C1 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		C3M3_C2 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 4 then
		C3M3_C4 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 5 then
		C3M3_C5 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 6 then
		C3M3_C6 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 7 then
		C3M3_C7 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R6/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 8 then
		C3M3_C8 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R7/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 9 then
		C3M3_C9 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R8/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 10 then
		C3M3_C10 = 1;
		StartDialogScene("/DialogScenes/C3/M3/R9/DialogScene.xdb#xpointer(/DialogScene)");
	end;
end;
-----------------------------------------------

---Astral retreat---
function cyrus_retreat(heroname)
	if GetObjectOwner(heroname) == PLAYER_1 then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "astral_can_be_in_sight", nil);
		SetRegionBlocked("teleport",nil,PLAYER_2);
		SetRegionBlocked("teleport",nil,PLAYER_3);
		print("Thread cyrus_retreat");
		BlockGame();  -------------------!
		OpenRegionFog(PLAYER_1,"CyrusRegion");
		OpenRegionFog(PLAYER_1,"teleport");
		ChangeHeroStat(CyrusName, STAT_MOVE_POINTS, 4000);
		sleep(10);
		MoveHeroRealTime(CyrusName,145,152);
	else
		print("Academy hero ", heroname," has entered in region near Cyrus");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "astral_can_be_in_sight","cyrus_retreat", nil );
	end;
end

---assemble 1000 skeletons---
function SObjective2()
local staff_day;
while 1 do
	if GetObjectiveState('prim1')==OBJECTIVE_COMPLETED then
		staff_day=GetDate( ABSOLUTE_DAY ) + 1 ---2 day delay---
		while staff_day >= GetDate( ABSOLUTE_DAY ) do
			sleep(10);
		end;
		print("Assemble 1000 skeletons!");
		SetObjectiveState("sec2",OBJECTIVE_ACTIVE);
		messages( 4 );
		break;
	end;
	sleep(2);
end;
sleep(10);
print("Skeleton quantity checking has been started...");
while 1 do
	skeletons = GetHeroCreatures('Berein', CREATURE_SKELETON) ---чек на количество скелетов у берейна---
	skeleton_archers = GetHeroCreatures('Berein', CREATURE_SKELETON_ARCHER) ---чек на количество скелетов лучников у берейна---
	skeleton_warriors = GetHeroCreatures('Berein', CREATURE_SKELETON_WARRIOR)
	if skeletons + skeleton_archers + skeleton_warriors  >= 1000 then
		print("Berein assembles ", skeletons, " skeletons");
		print("and ", skeleton_archers , " skeleton_archers");
		print("and ", skeleton_warriors , " skeleton_warriors.");
		SetObjectiveState("sec2",OBJECTIVE_COMPLETED);
		messages( 5 );
		sleep(10);
		ObjectiveExp("Berein");
		break;
	end;
	sleep(10);
end;
	print('assemble 1000 skeletons - OK');
end;

---assemble 20 bone dragons---
function SObjective3()	
while 1 do
	local BoneDragons = GetHeroCreatures('Berein', CREATURE_BONE_DRAGON); ---количество костяных драконов у берейна---
	local ShadowDragons = GetHeroCreatures('Berein', CREATURE_SHADOW_DRAGON);
	local HorrorDragons = GetHeroCreatures('Berein', CREATURE_HORROR_DRAGON);
	if BoneDragons + ShadowDragons + HorrorDragons >= 20 then
		if GetObjectiveState('sec3') == OBJECTIVE_ACTIVE  then
			SetObjectiveState('sec3',OBJECTIVE_COMPLETED);
			D_day_timer = 1;
			counter = counter + 1;
			if counter == 1 then
				ObjectiveExp("Berein");
				print("counter = ",counter);
			end;
			sleep(3);
			Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
		else
			print("Warning!!! sec3 is not ACTIVE");
		end;
		startThread(IfDragonsLost);
		break;
	end;
	sleep(5);
end;
end;

function IfDragonsLost()
	repeat
		BoneDragons = GetObjectCreatures('Berein', CREATURE_BONE_DRAGON);
		ShadowDragons = GetObjectCreatures('Berein', CREATURE_SHADOW_DRAGON);
		HorrorDragons = GetHeroCreatures('Berein', CREATURE_HORROR_DRAGON);
		sleep(10);
	until BoneDragons + ShadowDragons + HorrorDragons <= 19;
	SetObjectiveState('sec3',OBJECTIVE_ACTIVE);
	startThread(SObjective3);
end;


-- Secondary objective. It starts when Markal ("Berein" in script) take the artifact "Staff of vexings" to another hero.

function ReturnArtefactToBerein(ArtefactName,ObjectiveName)
	print("Thread ReturnArtefactToBerein for artefact ",ArtefactName," has been started...");
	while 1 do
		PlayerHeroes = GetPlayerHeroes(PLAYER_1);
		for i=0,table.length(PlayerHeroes) - 1 do
			--print("i = ",i,"Hero is ", PlayerHeroes[i],". Staff");
			if HasArtefact(PlayerHeroes[i],ArtefactName) == not nil then
				OldArtefactOwner = PlayerHeroes[i];
				break;
			end;
		end;
		sleep(20);
		if HasArtefact("Berein",ArtefactName) == not nil then
			ObjectiveExp(OldArtefactOwner);
			print("Old Artefact Owner is ",OldArtefactOwner);
			SetObjectiveState(ObjectiveName,OBJECTIVE_COMPLETED);
			startThread(StartTownTrigger,"Town1","CurseTown1");
			startThread(StartTownTrigger,"Town2","CurseTown2");
			startThread(StartTownTrigger,"Town3","CurseTown3");
			return
		end;
	end;
end;

function GiveStaffOfVexings(HeroName)
	if GetObjectOwner(HeroName) == PLAYER_1 then
		GiveArtefact(HeroName, ARTIFACT_STAFF_OF_VEXINGS );
		print("Our hero ",HeroName," has got Staff of vexings");
		if HeroName ~= "Berein" then
			ObjectiveExp(HeroName);
			SetObjectiveState("sec4",OBJECTIVE_ACTIVE);
			startThread(ReturnArtefactToBerein,ARTIFACT_STAFF_OF_VEXINGS,"sec4");
			else
			startThread(StartTownTrigger,"Town1","CurseTown1");
			startThread(StartTownTrigger,"Town2","CurseTown2");
			startThread(StartTownTrigger,"Town3","CurseTown3");
		end;
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town1', nil);
	else
		print("Enemy hero touch staff");
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town1', "GiveStaffOfVexings");
	end;
end;

function GiveCloackOfMourning(HeroName)
	if GetObjectOwner(HeroName) == PLAYER_1 then
		GiveArtefact( HeroName, ARTIFACT_CLOAK_OF_MOURNING );
		print("Our hero ",HeroName," has got Cloak of mourning");
		if HeroName ~= "Berein" then
			ObjectiveExp(HeroName);
			SetObjectiveState("Sec6",OBJECTIVE_ACTIVE);
			startThread(ReturnArtefactToBerein,ARTIFACT_CLOAK_OF_MOURNING,"Sec6");
		end;
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town2', "CurseTown2");
	else
		print("Enemy hero touch cloak");
		Trigger(OBJECT_TOUCH_TRIGGER ,'Town2', "GiveCloackOfMourning");
	end;
end;

function StartTownTrigger(TownName,FunctionName,Cloak)
	while GetObjectOwner(TownName) ~= PLAYER_1 do
		sleep(10);
	end;
	Trigger(OBJECT_TOUCH_TRIGGER ,TownName, FunctionName);
	print("Trigger for ",TownName," with function ",FunctionName," has been started...");
end;


function CurseTown1(HeroName)
	print("CurseTown1 has been started");
	print("Hero name is ",HeroName);
	print("Town owner is ",GetObjectOwner("Town1"));
	print("Has Artefact = ",HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )," must be not nil.");
	print("IsAnyHeroInTown() = ",IsAnyHeroInTown("Town1"));
	if  HeroName == "Berein" and
	    HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )==not nil and
	    GetObjectOwner("Town1") == PLAYER_1 and
		IsAnyHeroInTown("Town1") == 0 then
		QuestionBox("/Maps/Scenario/C3M3/messages/CurseTown.txt", "TransformingTown1");
	end;
end;


function CurseTown2(HeroName)
	print("CurseTown2 has been started");
	print("Hero name is ",HeroName);
	print("Town owner is ",GetObjectOwner("Town2"));
	print("Has Artefact = ",HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )," must be not nil.");
	print("IsAnyHeroInTown() = ",IsAnyHeroInTown("Town2"));
	if  HeroName == "Berein" and
		HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )==not nil and
		GetObjectOwner("Town2") == PLAYER_1 and
		IsAnyHeroInTown("Town2") == 0 then
		QuestionBox("/Maps/Scenario/C3M3/messages/CurseTown.txt", "TransformingTown2");
	end;
end;

function CurseTown3(HeroName)
	print("CurseTown3 has been started");
	print("Hero name is ",HeroName);
	print("Town owner is ",GetObjectOwner("Town3"));
	print("Has Artefact = ",HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )," must be not nil.");
	print("IsAnyHeroInTown() = ",IsAnyHeroInTown("Town3"));
	if  HeroName == "Berein" and
		HasArtefact( "Berein", ARTIFACT_STAFF_OF_VEXINGS )==not nil and
		GetObjectOwner("Town3") == PLAYER_1 and
		IsAnyHeroInTown("Town3") == 0 then
		QuestionBox("/Maps/Scenario/C3M3/messages/CurseTown.txt", "TransformingTown3");
	end;
end;

function IsAnyHeroInTown(TownName)
	if GetTownHero(TownName) ~= nil then return 1 else return 0 end;
end;

function SObjective5()
	while GetObjectOwner('Town1') ~= PLAYER_1 and GetObjectOwner('Town2') ~= PLAYER_1 and IsObjectVisible( PLAYER_1, ElvenHero ) == nil do --town capture check
		sleep();
	end;	
	SetObjectiveState("sec5",OBJECTIVE_ACTIVE);--при установке состояния задания в OBJECTIVE_ACTIVE оно автоматически становится видимым игроку
	if C3M3_C7 == 0 then
		messages( 7 );
	end;
	ElvenHeroActive = 1;
	EnableHeroAI(ElvenHero, not nil);
	startThread(elves_help_completed);
end;
---elves help---
function elves_help_completed()
	while 1 do
		sleep(10);
		if IsHeroAlive(ElvenHero) == nil then
			print("Elven Hero is dead");
			ElvenHeroActive = 0;
			if ElvenCondition == 0 then
				SetObjectiveState("sec5",OBJECTIVE_COMPLETED);
				sleep(10);
				StartDialogScene("/DialogScenes/C3/M3/R7/DialogScene.xdb#xpointer(/DialogScene)");
				sleep(5);
				--ObjectiveExp("Berein");
			else
				print("Game over");
			end;
			return
		end;
	end;
end;

function H55_TriggerDaily()
	if ElvenHeroActive == 1 and IsObjectExists(ElvenHero) then
		if CanMoveHero(ElvenHero,110,23,0) then
			MoveHero(ElvenHero,110,23,0);
		end;
	end;	
end;

---portal check---
function port_check(HeroName)
	if HeroName == "Berein" then
		if GetObjectiveState("sec3") == OBJECTIVE_COMPLETED then
			if      GetObjectiveState("prim1") == OBJECTIVE_COMPLETED
				and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
				ElvenCondition = 1;
				SaveHeroAllSetArtifactsEquipped("Berein", "C3M3");
				SetObjectiveState("prim5",OBJECTIVE_COMPLETED);
				sleep(3);
				SetObjectiveState("prim4",OBJECTIVE_COMPLETED);
				sleep(3);
				StartDialogScene("/DialogScenes/C3/M3/R9/DialogScene.xdb#xpointer(/DialogScene)");
				sleep(5);
				Win(PLAYER_1);
			else
				MessageBox("/Maps/Scenario/C3M3/MessageBox_VampirsGarmentNeed.txt");
				Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
			end;
		else
			MessageBox("/Maps/Scenario/C3M3/MessageBox_MarkalMustHaveDragons.txt");
			Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
		end;
	else
		MessageBox("/Maps/Scenario/C3M3/MessageBox_OnlyBereinInPortal.txt");
		Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
	end;
end


function SetBuildingsEnabled(TownName)
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_DWELLING_4,2);
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_DWELLING_6,2);
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_DWELLING_5,2);
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_DWELLING_7,2);
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_MAGIC_GUILD,5);
	SetTownBuildingLimitLevel(TownName,TOWN_BUILDING_FORT,3);
	print("High level buildings were enabled to construct for town ",TownName);
end;

function TransformingTown1()
	local currentRes = GetPlayerResource( PLAYER_1, GOLD );
	if IsAnyHeroInTown("Town1") == 0 then
		if currentRes < 10000 then
			MessageBox( "/Maps/Scenario/C3M3/messages/CurseNegative.txt" );
		else
			Trigger(OBJECT_TOUCH_TRIGGER, "Town1", nil);
			SetPlayerResource( PLAYER_1, GOLD, currentRes - 10000 );
			TransformTown("Town1", TOWN_NECROMANCY);
			MessageBox( "/Maps/Scenario/C3M3/messages/Town1Transformed.txt" );
			Town1Converted = 1;
			if (GetDifficulty() == DIFFICULTY_NORMAL or GetDifficulty() == DIFFICULTY_EASY) then SetBuildingsEnabled("Town1"); end;
		end;
	else
		print("Can not transform. Hero is in Town.");
		MessageBox( "/Maps/Scenario/C3M3/HeroInTown.txt" );
	end;
end;

function TransformingTown2()
	local currentRes = GetPlayerResource( PLAYER_1, GOLD );
	if IsAnyHeroInTown("Town2") == 0 then
		if currentRes < 10000 then
			MessageBox( "/Maps/Scenario/C3M3/messages/CurseNegative.txt" );
		else
			Trigger(OBJECT_TOUCH_TRIGGER, "Town2", nil);
			SetPlayerResource( PLAYER_1, GOLD, currentRes - 10000 );
			TransformTown("Town2", TOWN_NECROMANCY);
			MessageBox( "/Maps/Scenario/C3M3/messages/Town2Transformed.txt" );
			Town2Converted = 1;
			if (GetDifficulty() == DIFFICULTY_NORMAL or GetDifficulty() == DIFFICULTY_EASY) then SetBuildingsEnabled("Town2");end;
		end;
	else
		print("Can not transform. Hero is in Town.");
		MessageBox( "/Maps/Scenario/C3M3/HeroInTown.txt" );
	end;
end;

function TransformingTown3()
	local currentRes = GetPlayerResource( PLAYER_1, GOLD );
	if IsAnyHeroInTown("Town3") == 0 then
		if currentRes < 10000 then
			MessageBox( "/Maps/Scenario/C3M3/messages/CurseNegative.txt" );
		else
			Trigger(OBJECT_TOUCH_TRIGGER, "Town3", nil);
			SetPlayerResource( PLAYER_1, GOLD, currentRes - 10000 );
			TransformTown("Town3", TOWN_NECROMANCY);
			MessageBox( "/Maps/Scenario/C3M3/messages/Town3Transformed.txt" );
			Town3Converted = 1;
			if (GetDifficulty() == DIFFICULTY_NORMAL or GetDifficulty() == DIFFICULTY_EASY) then SetBuildingsEnabled("Town3");end;
		end;
	else
		print("Can not transform. Hero is in Town.");
		MessageBox( "/Maps/Scenario/C3M3/HeroInTown.txt" );
	end;
end;

function ObjectiveExp(HeroName)
	local ToLevel = GetExpToLevel(GetHeroLevel(HeroName)+1);
	local delta = (ToLevel - GetHeroStat(HeroName, STAT_EXPERIENCE)) / 2;
	print("delta = ", delta);
	if delta >= 0 then
		ChangeHeroStat(HeroName, STAT_EXPERIENCE,delta);
	else
		print("Warning! Delta is negative. Hero gain 100 exp");
		ChangeHeroStat(HeroName, STAT_EXPERIENCE,100);
	end;
	print("Now ",HeroName, " has ", GetHeroStat(HeroName, STAT_EXPERIENCE)," exp");
end;

function GetExpToLevel( j )
	local a = 1;
	if j >= 30 then a = 30 else a = j end;
	local sum;      --LEVEL 1 2    3    4    5    6    7    8     9     10    11    12
	ExpArrayLess12 = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
	ExpArrayLess12.n = 12;
					--LEVEL 13    14    15    16    17    18    19    20    21    22     23     24
	ExpArrayMore12 = {24320,28784,34141,40569,48283,57539,68647,81977,97972,117166,140200,167839};
	ExpArrayMore12.n = 12;
					--LEVEL 25     26     27     28     29     30     31      32      33      34
	ExpArrayMore25 = {201007,244126,304491,395040,539917,786208,1229533,2071000,3756484,7294215};
	ExpArrayMore25.n = 10;
	if a <= 12 then
		sum = ExpArrayLess12[a];
	else
		if a < 25 then
			sum = ExpArrayMore12[a-12];
		else
			if a < 35 then
				sum = ExpArrayMore25[a-24];
			else
				print("Das ist fantastisch!!!");
				sum = 0;
			end;
		end;
	end;
	print("Hero need ", sum, " experience to gain level ",a);
	return sum;
end;

-- function GetExpToLevel( j )
	-- local sum;      --LEVEL 1 2    3    4    5    6    7    8     9     10    11    12
	-- ExpArrayLess12 = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
	-- ExpArrayLess12.n = 12;
					-- --LEVEL 13    14    15    16    17    18    19    20    21    22     23     24
	-- ExpArrayMore12 = {24320,28784,34141,40569,48283,57539,68647,81977,97972,117166,140200,167839};
	-- ExpArrayMore12.n = 12;
					-- --LEVEL 25     26     27     28     29     30     31      32      33      34
	-- ExpArrayMore25 = {201007,244126,304491,395040,539917,786208,1229533,2071000,3756484,7294215};
	-- ExpArrayMore25.n = 10;
	-- if j <= 12 then
		-- sum = ExpArrayLess12[j];
	-- else
		-- if j < 25 then
			-- sum = ExpArrayMore12[j-12];
		-- else
			-- if j < 35 then
				-- sum = ExpArrayMore25[j-24];
			-- else
				-- print("Das ist fantastisch!!!");
				-- sum = 0;
			-- end;
		-- end;
	-- end;
	-- print("Hero need ", sum, " experience to gain level ",j);
	-- return sum;
-- end;

function cyrus_out(heroname)
	print("Cyrus has gone");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"slonek",nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "cyrus_teleport", "port_check", nil);
	UnblockGame();
	messages(9);
	SetObjectiveState("sec3",OBJECTIVE_ACTIVE);
	SetObjectiveVisible("prim3",nil);
	sleep(5);
	startThread( SObjective3 );
	SetObjectEnabled("cyrus_teleport",nil);
	SetRegionBlocked("teleport",1,PLAYER_2);
	SetRegionBlocked("teleport",1,PLAYER_3);
end;

function onError()
	print("Error occured in function SetArtefactUntrans");
end;

function SetArtefactUntrans(ArtefactName)
	errorHook(onError);
	RemoveArtefact("Berein",ArtefactName);
	GiveArtefact("Berein",ArtefactName,1);
end;

function ShowLevel()
	print("Town1. Dwelling 7 Level = ",GetTownBuildingLevel("Town1",TOWN_BUILDING_DWELLING_7));
	print("Town1. Dwelling 6 Level = ",GetTownBuildingLevel("Town1",TOWN_BUILDING_DWELLING_6));
	print("Town1. Magic Guild Level = ",GetTownBuildingLevel("Town1",TOWN_BUILDING_MAGIC_GUILD));
	print("Town2. Dwelling 7 Level = ",GetTownBuildingLevel("Town2",TOWN_BUILDING_DWELLING_7));
	print("Town2. Dwelling 6 Level = ",GetTownBuildingLevel("Town2",TOWN_BUILDING_DWELLING_6));
	print("Town2. Magic Guild Level = ",GetTownBuildingLevel("Town2",TOWN_BUILDING_MAGIC_GUILD));
	print("Town3. Dwelling 7 Level = ",GetTownBuildingLevel("Town3",TOWN_BUILDING_DWELLING_7));
	print("Town3. Dwelling 6 Level = ",GetTownBuildingLevel("Town3",TOWN_BUILDING_DWELLING_6));
	print("Town3. Magic Guild Level = ",GetTownBuildingLevel("Town3",TOWN_BUILDING_MAGIC_GUILD));
end;

-----------------
---C3M3 script---
-----------------
---Disable AI of quest heroes---
H55_CamFixTooManySkills(PLAYER_1,"Berein");
H55_CamFixTooManySkills(PLAYER_1,"Isabell");
EnableHeroAI(CyrusName, nil);
EnableHeroAI(ElvenHero, nil);
startThread( ObjectiveGetArtefactComplete,  ARTIFACT_STAFF_OF_VEXINGS, "prim1","/DialogScenes/C3/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
startThread( ObjectiveGetArtefactComplete,  ARTIFACT_CLOAK_OF_MOURNING, "prim2","/DialogScenes/C3/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
startThread( PObjective4 );
startThread( PObjective5 );
startThread( SObjective1 );
startThread( SObjective2 );
startThread( SObjective5 );
startThread(DifficultyDependency);
startThread(EnableAIForRazzakAndTimerkhan);
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "astral_can_be_in_sight","cyrus_retreat", nil );
Trigger(OBJECT_TOUCH_TRIGGER ,'Town1', "GiveStaffOfVexings");
Trigger(OBJECT_TOUCH_TRIGGER ,'Town2', "GiveCloackOfMourning");
Trigger(REGION_ENTER_AND_STOP_TRIGGER,"slonek","cyrus_out");
print("all functions is run");