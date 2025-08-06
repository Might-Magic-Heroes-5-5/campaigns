H55_PlayerStatus = {0,1,1,1,1,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M4");
end;

startThread(H55_InitSetArtifacts);

function DeployDungeonArmy ()
	print("DeployDungeonArmy () started!");
	DeployReserveHero("Raelag", 36, 128, 0);
	DeployReserveHero("Kelodin", 33, 129, 0);
	EnableHeroAI("Raelag", nil);
	EnableHeroAI("Kelodin", nil);
	StartDialogScene("/DialogScenes/C6/M4/D2/DialogScene.xdb#xpointer(/DialogScene)")
	SetObjectiveState("prim3",OBJECTIVE_ACTIVE);
	sleep(10)
	MoveHeroRealTime("Raelag", 37, 128, 0);
	MoveHeroRealTime("Kelodin", 34, 129, 0);
	--OpenRegionFog(PLAYER_1, "region1");
	OpenCircleFog(36, 128, 0, 6, PLAYER_1);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , "deploy", nil);
end
	
function RaelagTalks(nameHero)
	if GetObjectOwner(nameHero) ~= PLAYER_1 then
		return
	end;
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "region1", nil);
	StartDialogScene("/DialogScenes/C6/M4/D4/DialogScene.xdb#xpointer(/DialogScene)")
	sleep(1)
	UnreserveHero("Raelag");
	sleep(1)	
	SetObjectOwner("Raelag", PLAYER_1);
	sleep(1)	
	LoadHeroAllSetArtifacts("Raelag", "C4M5");
	H55_CamFixTooManySkills(PLAYER_1,"Raelag");
	UnreserveHero("Kelodin");
	sleep(1);		
	SetObjectOwner("Kelodin", PLAYER_1);
	sleep(1);
	H55_CamFixTooManySkills(PLAYER_1,"Kelodin");
	SetObjectiveState("prim4",OBJECTIVE_ACTIVE);
	ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1366);
	SetObjectiveState("prim3",OBJECTIVE_COMPLETED);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "region1", nil);
	startThread( objective4 )
end
	
function FinalDialogue()
	-- Isabell Ritual cutscene
	SaveHeroAllSetArtifactsEquipped("Zehir", "C6M4");
	SaveHeroAllSetArtifactsEquipped("Heam", "C6M4");
	SaveHeroAllSetArtifactsEquipped("Godric", "C6M4");
	SaveHeroAllSetArtifactsEquipped("Raelag", "C6M4");
	sleep(1);
	Save("Scene_19");
	--sleep(40);
	StartCutScene("/Maps/Cutscenes/C6M4/_.(AnimScene).xdb#xpointer(/AnimScene)", "SetObjectiveState('prim1',OBJECTIVE_COMPLETED)");
	--sleep(40);
	
	--Win();
end

function cut()
	StartCutScene("/Maps/Cutscenes/C6M4/_.(AnimScene).xdb#xpointer(/AnimScene)");
end

---Are Primary Heroes Alive---
function objective2()
        if GetObjectiveState("prim2") == OBJECTIVE_UNKNOWN then
                SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
        else
                print("Warning!!! prim2 is not UNKNOWN");
        end;
while 1 do
        if IsHeroAlive("Zehir")==nil or IsHeroAlive("Godric")==nil or IsHeroAlive("Heam")==nil then
                print("One of the primary heroes is dead!!!");
                if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE or GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("prim2",OBJECTIVE_FAILED);
                else
                        print("Warning!!! prim2 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and 
        	GetObjectiveState("prim3") == OBJECTIVE_COMPLETED and
        	GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! prim2 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

---Are Secondary Heroes Alive---
function objective4()
while 1 do
        if IsHeroAlive("Raelag")==nil or IsHeroAlive("Kelodin")==nil then
                print("One of the secondary heroes is dead!!!");
                if GetObjectiveState("prim4") == OBJECTIVE_ACTIVE or GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("prim4",OBJECTIVE_FAILED);
                else
                        print("Warning!!! prim4 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and 
        	GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("prim4") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! prim4 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

function WinLoose()
	while 1 do
		-- if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and
			-- GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
			-- sleep(20);
			-- return
		-- end;
		if GetObjectiveState("prim1") == OBJECTIVE_FAILED or
			GetObjectiveState("prim2") == OBJECTIVE_FAILED or
			GetObjectiveState("prim3") == OBJECTIVE_FAILED or
			GetObjectiveState("prim4") == OBJECTIVE_FAILED then
			sleep(40);
			Loose();
			return
		end;
		sleep();
	end;
end;

d = GetDifficulty() - 1;

function IsabellDifficulty()
		AddHeroCreatures("Isabell", CREATURE_MILITIAMAN, 200 + d * 10);
		AddHeroCreatures("Isabell", CREATURE_MARKSMAN, 100 + d * 10);
		AddHeroCreatures("Isabell", CREATURE_SWORDSMAN, 70 + d * 10);
		AddHeroCreatures("Isabell", CREATURE_ROYAL_GRIFFIN, 50 + d * 5);
		AddHeroCreatures("Isabell", CREATURE_CLERIC, 40 + d * 5);
		AddHeroCreatures("Isabell", CREATURE_PALADIN, 30 + d * 5);
		AddHeroCreatures("Isabell", CREATURE_ARCHANGEL, 6 + d * 5);
end

--AddHeroCreatures(heroname, creatureID, quantity);

---perform---
SetPlayerHeroesCountNotForHire(PLAYER_1, 6);
StartDialogScene("/DialogScenes/C6/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
sleep(1);
H55_CamFixTooManySkills(PLAYER_1,"Zehir");
H55_CamFixTooManySkills(PLAYER_1,"Godric");
H55_CamFixTooManySkills(PLAYER_1,"Heam");
LoadHeroAllSetArtifacts("Zehir", "C6M3" );
LoadHeroAllSetArtifacts("Godric", "C1M5");
--LoadHeroAllSetArtifacts("Raelag", "C4M5");
LoadHeroAllSetArtifacts("Heam", "C5M5");

GiveExp( "Sarge", 10000 );
GiveExp( "Gles", 20000 );
GiveExp( "Nathaniel", 10000 );
GiveExp( "Straker", 18000 );
GiveExp( "Christian", 10000 );
GiveExp( "Tamika", 15000 );
GiveExp( "Effig", 20000 );

EnableHeroAI("Isabell", nil);
SetRegionBlocked("forbid", not nil, PLAYER_4);
SetRegionBlocked("forbid", not nil, PLAYER_5);
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "region1", "RaelagTalks");
Trigger(REGION_ENTER_AND_STOP_TRIGGER , "deploy", "DeployDungeonArmy");
Trigger(OBJECT_CAPTURE_TRIGGER, "talonguard", "FinalDialogue");
startThread( objective2 );
startThread( WinLoose );

--removing monsters off Isabell Army on EASY
IsabellDifficulty();