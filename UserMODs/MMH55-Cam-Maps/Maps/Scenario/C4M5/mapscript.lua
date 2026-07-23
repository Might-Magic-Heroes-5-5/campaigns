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
end;

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

ChangeHeroStat("Jazaz", STAT_EXPERIENCE, 75000);
ChangeHeroStat("Efion", STAT_EXPERIENCE, 75000);

SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 1000);
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
		GiveExp( "Raelag", 3000 ); ---addexp!!!
		GiveExp( "Kelodin", 3000 ); ---addexp!!!
		ChangeHeroStat("Raelag", STAT_MORALE, 1);  -------Oblico_Morale!
		ChangeHeroStat("Kelodin", STAT_MORALE, 1);  -------Oblico_Morale!
		startThread(PObjective34); -----Palaedra!!!
	end;
end;


function PObjective2()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Raelag") == nil or IsHeroAlive("Kelodin") == nil then   ----Заменить 2го героя!!!
			print("Heroes deads.................................");
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			break;
		end;
	end;
end;
---------------------------------------------Захват и разрушение замков!

function Castle_1()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Az_Hakol") == PLAYER_1) then
			RazeTown("Az_Hakol");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R2/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end;
	end;
end;

function Castle_2()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Mammon") == PLAYER_1) then
			RazeTown("Mammon");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R3/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end;
	end;
end;

function Castle_3()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Eh_Tares") == PLAYER_1) then	
			RazeTown("Eh_Tares");
			sleep( 10 );
			StartDialogScene("/DialogScenes/C4/M5/R4/DialogScene.xdb#xpointer(/DialogScene)")  
			break;
		end;
	end;
end;
------------------------------------------------
function WinLoose_1()
	while 1 do
		if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			Loose();
			return
		end;
		sleep();
	end;
end;
------------------------------------------------
function Post_01()  
	while 1 do
		sleep(10);
		if IsPlayerHeroesInRegion(1, "post_1") == true then   
			SetObjectOwner("POST1",1);
			SetObjectOwner("POST2",1);
			break;
		end;
	end;
end;
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
    
        if koef > 1 then
                GiveHeroSkill( "Veyer", PERK_BALLISTA );
                GiveHeroSkill( "Veyer", SKILL_LEARNING );
                AddHeroCreatures( "Veyer", CREATURE_IMP, 300 );
                AddHeroCreatures( "Veyer", CREATURE_CERBERI, 250 );
                AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 50);
                AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL,  20 );
                AddHeroCreatures( "Veyer",CREATURE_FIRE_ELEMENTAL, 100);
        end
	if koef > 2 then
		TeachHeroSpell( "Veyer",   SPELL_BERSERK );	
		TeachHeroSpell( "Veyer", SPELL_VAMPIRISM );
                GiveHeroSkill( "Veyer", SKILL_LEARNING );
                GiveHeroSkill( "Veyer", SKILL_LEARNING );
                GiveHeroSkill( "Veyer", PERK_FIRST_AID );
                AddHeroCreatures( "Veyer", CREATURE_IMP, 200 );
                AddHeroCreatures( "Veyer", CREATURE_CERBERI, 200 );
                AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 50);
                AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL, 15 );
                AddHeroCreatures( "Veyer",CREATURE_FIRE_ELEMENTAL, 50);
        end
        if koef > 3 then
                GiveHeroSkill( "Veyer", HERO_SKILL_QUICKNESS_OF_MIND );
                GiveHeroSkill( "Veyer", PERK_EAGLE_EYE );
                GiveHeroSkill( "Veyer", NECROMANCER_FEAT_LAST_AID );
                GiveHeroSkill( "Veyer", PERK_TOUGHNESS );
               AddHeroCreatures( "Veyer", CREATURE_IMP, 100 );
                AddHeroCreatures( "Veyer", CREATURE_CERBERI, 150 );
                AddHeroCreatures( "Veyer", CREATURE_FRIGHTFUL_NIGHTMARE, 40);
                AddHeroCreatures( "Veyer", CREATURE_ARCHDEVIL, 15 );
                AddHeroCreatures( "Veyer",CREATURE_FIRE_ELEMENTAL, 50);
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
end;

function PObjective3_4complete()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Veyer") == nil then 
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			--SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
			SaveHeroAllSetArtifactsEquipped(  "Raelag", "C4M5" );
			SaveHeroAllSetArtifactsEquipped( "Kelodin", "C4M5" );
			ChangeHeroStat("Raelag", STAT_MORALE, 1);  -------Oblico_Morale!
			ChangeHeroStat("Kelodin", STAT_MORALE, 1);  -------Oblico_Morale!
			sleep(6);
			Save("Save") 
			sleep(10);
			StartDialogScene("/DialogScenes/C4/M5/D1/DialogScene.xdb#xpointer(/DialogScene)")
			sleep(10);
			StartCutScene("/Maps/Cutscenes/C4M5/_.(AnimScene).xdb#xpointer(/AnimScene)");
			Win(); 
			break;
		end;	
	end;
end;

function PObjective3_4defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Isabell") == nil then
			SetObjectiveState('prim4',OBJECTIVE_FAILED);
			sleep(20);
			Loose();
			break;
		end;
	end;
end;
--------------------------------//Main thread//
startThread(Start_Dialog);
--startThread(PObjective1);
startThread(PObjective2);
startThread(Castle_1);
startThread(Castle_2);
startThread(Castle_3);
startThread(WinLoose_1);
startThread(Post_01);
