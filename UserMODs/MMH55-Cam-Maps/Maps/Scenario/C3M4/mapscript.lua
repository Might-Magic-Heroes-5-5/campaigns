doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M4");
    LoadHeroAllSetArtifacts( "Berein",   "C3M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Berein" );
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

Cyrus = "Cyrus";  --Cayrus!!!
Berein = "Berein";
EnableHeroAI("Cyrus",nil);

H55c_SetCampaignResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0);	

local army_diff = GetDifficulty() + 1;      
ChangeHeroStat("Cyrus", STAT_ATTACK, 3 * army_diff);
ChangeHeroStat("Cyrus", STAT_DEFENCE, 3 * army_diff);
ChangeHeroStat("Cyrus", STAT_SPELL_POWER, 4 * army_diff);
ChangeHeroStat("Cyrus", STAT_KNOWLEDGE, 4 * army_diff);
if army_diff > 1 then
    GiveExp("Cyrus", 363000);
    AddHeroCreatures("Cyrus", CREATURE_MASTER_GREMLIN, 117* GetDifficulty());   
    AddHeroCreatures("Cyrus", CREATURE_OBSIDIAN_GARGOYLE, 25* GetDifficulty());   
    AddHeroCreatures("Cyrus", CREATURE_STEEL_GOLEM, 80* GetDifficulty());   
    AddHeroCreatures("Cyrus", CREATURE_ARCH_MAGI, 20* GetDifficulty());    
    AddHeroCreatures("Cyrus", CREATURE_MASTER_GENIE, 15* GetDifficulty()); 
    AddHeroCreatures("Cyrus", CREATURE_RAKSHASA_KSHATRI, 10* GetDifficulty());
    AddHeroCreatures("Cyrus", CREATURE_TITAN, 5 * GetDifficulty()); 	
end
if army_diff > 2 then
    GiveExp("Cyrus", 744000);
end   
if army_diff > 3 then
    GiveExp("Cyrus", 1550000);

end 						
----------------------------------//Titans
function mob1()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "100", nil );
MessageBox ("/Maps/Scenario/C3M4/Message/C3M4_1.txt");
CreateMob(1,CREATURE_TITAN, 10,66,90,1,2,1);
end;

function mob2()	
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "200", nil );
CreateMob(2,CREATURE_TITAN, 20,117,92,1,2,1);
end;

function mob3()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "300", nil );
CreateMob(3,CREATURE_TITAN,30,38,20,1,2,1);
end;

function mob4()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "400", nil );
CreateMob(3,CREATURE_TITAN,40,63,71,1,2,1);
CreateMob(3,CREATURE_TITAN,100,63,64,1,2,1);
end;

--------------------------------//Start first dialog
function Dialog1()
StartDialogScene("/DialogScenes/C3/M4/R1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Start final dialog
end;

-------------------------------//Objectives

function PObjective1()
	while 1 do	
		sleep( 10 );	
		if IsHeroAlive("Cyrus") == nil then
			print("Cayrus dead.................................");
			SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
			break;
		end;
	end;
end;

function PObjective2()
	while 1 do
		sleep(10);
		if IsHeroAlive("Berein") == nil then
			print("Berein dead.................................");
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			break;
		end;
	end;
end;

-----------------------------//Winner
function WinLoose()
	while 1 do
		if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
			StartDialogScene("/DialogScenes/C3/M4/D1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Start final dialog
			--GiveExp( "Berein", 500 ); ---addexp!!!
			SaveHeroAllSetArtifactsEquipped("Berein", "C3M4");
			sleep(30);
			Win();
			return
		end;
		if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			Loose();
			return
		end;
		sleep();
	end;
end;
----------------------------------
function Post_Bone2()
	while 1 do
		sleep(4);
		if IsPlayerHeroesInRegion(1, "Bone") == not nil then
			SetObjectOwner("B1",1);
			SetObjectOwner("B2",1);
			break;
		end;
	end;
end;
--------------------------------//Main thread
startThread(Dialog1);

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "100","mob1", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "200","mob2", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "300","mob3", nil );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "400","mob4", nil );

startThread(PObjective1);
startThread(PObjective2);
startThread(WinLoose);
--startThread(Post_Bone2);