H55_PlayerStatus = {0,1,1,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M3");
    LoadHeroAllSetArtifacts("Zehir", "C6M2" );
end;

startThread(H55_InitSetArtifacts);

function MeetingHeam()
	while 1 do
		if IsObjectVisible(PLAYER_1, "Heam")==not nil then
		sleep(5);
		StartDialogScene("/DialogScenes/C6/M3/D3/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("obj4",OBJECTIVE_ACTIVE);
		SetObjectiveVisible("obj4", not nil);
		SetObjectiveVisible("obj6", not nil);
		SetObjectiveState("obj1",OBJECTIVE_COMPLETED);
		SetObjectOwner("Heam",PLAYER_1);
		ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1473);
		print("Heam should join us");
		return 1;
		end
	sleep();
	end
end	

function MeetingGodric()
		sleep(1);
		StartDialogScene("/DialogScenes/C6/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", nil);
		SetObjectiveVisible("obj3", not nil);
		SetObjectiveVisible("obj7", not nil);
		SetObjectiveState("obj2",OBJECTIVE_COMPLETED);
		SetObjectOwner("Godric",PLAYER_1);
		print("Godric should join us");
		DeployReserveHero("Heam", 84, 41, 0);
		sleep(10);
		MoveHero("Heam", 86, 42, 0);
		EnableHeroAI("Heam", nil);
		startThread( MeetingHeam );
		startThread( objective6 );
		startThread( objective7 );
		startThread(AreHeroesAlive);
		ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1532);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"guardian","GodricMeetsAllies");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"town","GodricFight");
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", nil);
		SetObjectEnabled("prison", nil);
end	

town_array = {"town1","town2","town3","town4"};
town_array.n = 4;

function TownCounter ()
	print( "Town_count() = ",Town_count() );
	if Town_count() == 4 then
		SetObjectiveState("obj3",OBJECTIVE_COMPLETED);
		ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2162);
		SetObjectEnabled("markalgate", not nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "markalgate", nil);
	end;
end;
		
function Town_count()
	local count = 0;

	for i=1, town_array.n do
		if ( GetObjectOwner(town_array[i]) == PLAYER_1 ) then
			count = count + 1;
		end;
	end;
	return count;
end;

--- godric meets allies ---

function GodricMeetsAllies()
	if GetObjectOwner("firstborder",PLAYER_1) == not nil then 
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"guardian",nil)
			else
				SetObjectOwner("firstborder",PLAYER_1)
				sleep(1);
				StartDialogScene("/DialogScenes/C6/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER,"guardian",nil)
	end
end


--- godric says he have to fight --
function GodricFight(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
			StartDialogScene("/DialogScenes/C6/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"town",nil);
	end
end

---Is Zehir Alive---
function objective5()
        if GetObjectiveState("obj5") == OBJECTIVE_UNKNOWN then
                SetObjectiveState('obj5',OBJECTIVE_ACTIVE);
        else
                print("Warning!!! obj5 is not UNKNOWN");
        end;
while 1 do
        if IsHeroAlive("Zehir")==nil then
                print("Zehir is dead!!!");
                if GetObjectiveState("obj5") == OBJECTIVE_ACTIVE or GetObjectiveState("obj5") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("obj5",OBJECTIVE_FAILED);
                else
                        print("Warning!!! obj5 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("obj5") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState('obj5',OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! obj5 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

---Is Heam Alive---
function objective6()
while 1 do
        if IsHeroAlive("Heam") == nil then
                print("Heam is dead!!!");
                if GetObjectiveState("obj6") == OBJECTIVE_ACTIVE or GetObjectiveState("obj6") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("obj6",OBJECTIVE_FAILED);
                else
                        print("Warning!!! obj6 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("obj6") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState('obj6',OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! obj6 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

---Is Godric Alive---
function objective7()
while 1 do
        if IsHeroAlive("Godric")==nil then
                print("Godric is dead!!!");
                if GetObjectiveState("obj7") == OBJECTIVE_ACTIVE or GetObjectiveState("obj7") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("obj7",OBJECTIVE_FAILED);
                else
                        print("Warning!!! obj7 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("obj7") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState('obj7',OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! obj7 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

function WinLoose()
	while 1 do
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and
			GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and
			GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and
			GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
			--SaveHeroAllSetArtifactsEquipped("Zehir", "C6M3");
			sleep(20);
			Win();
			return
		end;
		if GetObjectiveState("obj1") == OBJECTIVE_FAILED or
			GetObjectiveState("obj2") == OBJECTIVE_FAILED or
			GetObjectiveState("obj3") == OBJECTIVE_FAILED or
			GetObjectiveState("obj4") == OBJECTIVE_FAILED or
			GetObjectiveState("obj5") == OBJECTIVE_FAILED or
			GetObjectiveState("obj6") == OBJECTIVE_FAILED or
			GetObjectiveState("obj7") == OBJECTIVE_FAILED then
			sleep(40);
			Loose();
			return
		end;
		sleep(10);
	end;
end;

---gathering heroes to fight markal---

d = GetDifficulty() - 1;
a = 0; b = 0; c = 0

-- zehir godric findan --

function fight_zehir()
			print("starting combat");
			StartCombat("Zehir", "Berein", 6,
			CREATURE_WRAITH, 15 + d * 5,
			CREATURE_SKELETON_ARCHER, 60 + d * 5,
			CREATURE_ZOMBIE, 50 + d * 5,
			CREATURE_GHOST, 50 + d * 5,		
			CREATURE_VAMPIRE_LORD, 55 + d * 5,
			CREATURE_DEMILICH, 30 + d * 5,
			'/Maps/Scenario/C6M3/CombatScript_zehir.xdb#xpointer(/Script)',
			"fight_godric",
			'/Scenes/CombatArenas/Boss_c6m3_Dirt.xdb#xpointer(/AdventureFlybyScene)');
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gathering",nil)
			Trigger(OBJECT_TOUCH_TRIGGER, "spes", nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "post", nil);
end	

function fight_godric()
		StartCombat("Godric", "Berein", 4,
		CREATURE_DEMILICH, 30 + d * 5,
		CREATURE_SKELETON_ARCHER, 70 + d * 5,
		CREATURE_MANES, 70 + d * 5,		
		CREATURE_VAMPIRE, 65 + d * 5,
		'/Maps/Scenario/C6M3/CombatScript_godric.xdb#xpointer(/Script)',
		"SpesFight",
		'/Scenes/CombatArenas/Boss_c6m3_Dirt2.xdb#xpointer(/AdventureFlybyScene)')		
end	

function SpesFight()
if IsHeroAlive("Godric")==not nil then SiegeTown("Heam", "/Maps/Scenario/C6M3/Spes.xdb#xpointer(/AdvMapTown)",
'/Scenes/CombatArenas/Boss_c6m3_Siege.xdb#xpointer(/AdventureFlybyScene)')
else Loose()
end
end


function theend()
	if IsHeroAlive("Zehir")==nil or IsHeroAlive("Heam")==nil or IsHeroAlive("Godric")==nil then
			sleep();
			Loose();
		else
			FinalSave();
	end
end

function FinalSave()
	SaveHeroAllSetArtifactsEquipped("Zehir", "C6M3");
	Save("Scene_18");
	sleep(10);
	FinalCutscene();
end

function FinalCutscene()
	--cutscene c6m3 markal's death --
	print("executing cutscene")
	StartCutScene("/Maps/Cutscenes/C6M3/_.(AnimScene).xdb#xpointer(/AnimScene)");
	sleep(20);
	SetObjectiveState("obj4",OBJECTIVE_COMPLETED);
end

function AreHeroesAlive()
	while 1 do
		if IsHeroAlive("Zehir")==nil or IsHeroAlive("Heam")==nil or IsHeroAlive("Godric")==nil then
				sleep();
				Loose();
		end
	sleep();
	end
end

-- Entering Markal's realm SelectionBox --


function AreYouReady()
	QuestionBox('/Maps/Scenario/C6M3/message-8.txt', "fight_zehir");
end

function YouAreNotReady()
	MessageBox('/Maps/Scenario/C6M3/message-9.txt');
end


---markal's gate are locked ---

function MarkalGateMessage()
	MessageBox('/Maps/Scenario/C6M3/message-7.txt');
end

-- Zehir is too fast --

function FastZehirCheck()
	while 1 do
		if IsHeroAlive("Heam")==not nil and IsHeroAlive("Godric")==not nil then
			Trigger(OBJECT_TOUCH_TRIGGER, "spes", "AreYouReady");
			Trigger(OBJECT_TOUCH_TRIGGER, "post", "AreYouReady");
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gathering","AreYouReady");
			print("checking full party");
			break;
		end
	sleep();
	end
end

---perform---

SetPlayerHeroesCountNotForHire(PLAYER_1, 6);
StartDialogScene("/DialogScenes/C6/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
H55_CamFixTooManySkills(PLAYER_1,"Zehir");
GiveExp( "Nathaniel", 80000 );
GiveExp( "Brem", 80000 );

Trigger(OBJECT_TOUCH_TRIGGER, "spes", "YouAreNotReady");
Trigger(OBJECT_TOUCH_TRIGGER, "post", "YouAreNotReady");
Trigger(REGION_ENTER_AND_STOP_TRIGGER,"gathering","YouAreNotReady");
startThread( FastZehirCheck );

SetObjectEnabled("markalgate", nil);
Trigger(OBJECT_TOUCH_TRIGGER, "markalgate", "MarkalGateMessage");
SetObjectEnabled("spes", nil);
SetObjectEnabled("post", nil);
EnableHeroAI("Godric", nil);
SetRegionBlocked("heam", not nil, PLAYER_2);
SetRegionBlocked("block", not nil, PLAYER_2);
SetObjectiveVisible("obj3", nil);
SetObjectiveVisible("obj4", nil);
SetObjectiveVisible("obj6", nil);
SetObjectiveVisible("obj7", nil);	
Trigger(OBJECT_CAPTURE_TRIGGER, "town1", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town2", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town3", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town4", "TownCounter");
Trigger(OBJECT_TOUCH_TRIGGER, "prison", "MeetingGodric");
--Trigger(REGION_ENTER_AND_STOP_TRIGGER, "gathering", "GatheringMessage");
startThread( objective5 );
startThread( WinLoose );