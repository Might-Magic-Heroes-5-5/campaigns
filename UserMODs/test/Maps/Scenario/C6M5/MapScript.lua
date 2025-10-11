H55_PlayerStatus = {0,1,2,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M5");
	--LoadHeroAllSetArtifacts("Godric", "C1M5");
	--LoadHeroAllSetArtifacts("Raelag", "C4M5");
	--LoadHeroAllSetArtifacts("Heam", "C5M5");
	LoadHeroAllSetArtifacts("Godric", "C6M4");
	LoadHeroAllSetArtifacts("Raelag", "C6M4");
	LoadHeroAllSetArtifacts("Heam", "C6M4");
    LoadHeroAllSetArtifacts("Zehir", "C6M4");
end;

startThread(H55_InitSetArtifacts);

town_array = {"town1","town2","town3","town4"};
town_array.n = 4;

function TownCounter ()
	print( "Town_count() = ",Town_count() );
	if Town_count() == 4 then
		SetObjectEnabled("bcitadel", not nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", "bfight")
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

function barmy()
	MessageBox('/Maps/Scenario/C6M5/message-5.txt');
end

function bfight()
	QuestionBox('/Maps/Scenario/C6M5/message-6.txt', "fight_godric");
end

-- biara combat sequence --
-- godric heam zehir raelag --

function fight_godric()
Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", nil)
SiegeTown("Godric", "/Maps/Scenario/C6M5/Ur-Hekal.xdb#xpointer(/AdvMapTown)", 
'/Scenes/CombatArenas/Boss_c6m5_Biara.xdb#xpointer(/AdventureFlybyScene)');
end

function fight_heam()
SiegeTown("Heam", "/Maps/Scenario/C6M5/Ur-Hekal (2).xdb#xpointer(/AdvMapTown)", 
'/Scenes/CombatArenas/Boss_c6m5_Biara2.xdb#xpointer(/AdventureFlybyScene)');
end

function fight_zehir()
SiegeTown("Zehir", "/Maps/Scenario/C6M5/Ur-Hekal (3).xdb#xpointer(/AdvMapTown)", 
'/Scenes/CombatArenas/Boss_c6m5_Biara3.xdb#xpointer(/AdventureFlybyScene)');
end

function fight_raelag()
SiegeTown("Raelag", "/Maps/Scenario/C6M5/Ur-Hekal (4).xdb#xpointer(/AdvMapTown)", 
'/Scenes/CombatArenas/Boss_c6m5_Biara4.xdb#xpointer(/AdventureFlybyScene)');
end

function BiaraIsDead()
	SetObjectiveState("capture_biara",OBJECTIVE_COMPLETED);
	SetObjectiveState("reach_deamon_lord",OBJECTIVE_ACTIVE);
	BlockGame();
	Save("Scene_21")
	sleep(20);
	StartDialogScene("/DialogScenes/C6/M5/D1/DialogScene.xdb#xpointer(/DialogScene)","teleporting");	
	sleep(20);
	UnblockGame();
end

function teleporting()
	SetObjectPosition("Zehir", 69, 67);	
	BlockGame();
	SetObjectPosition("Godric", 68, 66);	
	SetObjectPosition("Heam", 67, 65);	
	SetObjectPosition("Raelag", 66, 64);	
	sleep(10);
	ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2356);
	ChangeHeroStat("Heam", STAT_EXPERIENCE, 2562);
	ChangeHeroStat("Godric", STAT_EXPERIENCE, 2346);
	ChangeHeroStat("Raelag", STAT_EXPERIENCE, 2784);
	UnblockGame();
	ChangeHeroStat("Zehir",STAT_MOVE_POINTS,3000)
	ChangeHeroStat("Godric",STAT_MOVE_POINTS,3000)
	ChangeHeroStat("Heam",STAT_MOVE_POINTS,3000)
	ChangeHeroStat("Raelag",STAT_MOVE_POINTS,3000)

--	Trigger(NEW_DAY_TRIGGER, "fight_godric_sovereign");
end

function Question()
	QuestionBox('/Maps/Scenario/C6M5/message-8.txt', "CrossBattleDialogue"); --"Info");
end

--function Info()
	--CrossBattleDialogue();
	--MessageBox('/Maps/Scenario/C6M5/message-9.txt',"fight_godric_sovereign");
--end

-- sovereign combat sequence --
-- godric heam zehir raelag --

function fight_godric_sovereign()
StartCombat("Godric", "Kha-Beleth", 1, 
			16, 73 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_godric.xdb#xpointer(/Script)', 
			"fight_heam_sovereign", 
			'/Arenas/CombatArena/FinalCombat/FinalCombat.(AdvMapTownCombat).xdb#xpointer(/AdvMapTownCombat)');
end

function fight_heam_sovereign()
StartCombat("Heam", "Kha-Beleth", 1, 
			16, 53 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_heam.xdb#xpointer(/Script)', 
			"fight_zehir_sovereign", 
			'/Arenas/CombatArena/FinalCombat/FinalCombat.(AdvMapTownCombat).xdb#xpointer(/AdvMapTownCombat)');
end

function fight_zehir_sovereign()
StartCombat("Zehir", "Kha-Beleth", 1, 
			16, 33 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_zehir.xdb#xpointer(/Script)', 
			"fight_raelag_sovereign", 
			'/Arenas/CombatArena/FinalCombat/FinalCombat.(AdvMapTownCombat).xdb#xpointer(/AdvMapTownCombat)');
end

function fight_raelag_sovereign()
StartCombat("Raelag", "Kha-Beleth", 1, 
			16, 83 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_raelag.xdb#xpointer(/Script)', 
			"CrossBattleDialogue", 
			'/Arenas/CombatArena/FinalCombat/FinalCombat.(AdvMapTownCombat).xdb#xpointer(/AdvMapTownCombat)');
end

function CrossBattleDialogue()
	--if IsHeroAlive("Raelag") == not nil then
		StartDialogScene("/DialogScenes/C6/M5/D2/DialogScene.xdb#xpointer(/DialogScene)", "fight_godric_sovereign_noshield");
		--else Loose()
	--end		
end
	
--shield is destroyed--

d = GetDifficulty() + 1;

function fight_godric_sovereign_noshield()
			print("starting combat");
			StartCombat("Godric", "Kha-Beleth", 2, 
			16, 56 + d * 5, 18, 32 + d * 5,
			'/Maps/Scenario/C6M5/sovereign_godric_noshield.xdb#xpointer(/Script)', 
			"fight_heam_sovereign_noshield", 
			'/Scenes/CombatArenas/Boss_c6m5_Sovereign1_2.xdb#xpointer(/AdventureFlybyScene)');
end	

function fight_heam_sovereign_noshield()
			print("starting combat");
			StartCombat("Heam", "Kha-Beleth", 1, 
			16, 67 + d * 5,
			'/Maps/Scenario/C6M5/sovereign_heam_noshield.xdb#xpointer(/Script)', 
			"fight_zehir_sovereign_noshield", 
			'/Scenes/CombatArenas/Boss_c6m5_Sovereign2_2.xdb#xpointer(/AdventureFlybyScene)');
end	

function fight_zehir_sovereign_noshield()
			print("starting combat");
			StartCombat("Zehir", "Kha-Beleth", 1, 
			16, 53 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_zehir_noshield.xdb#xpointer(/Script)', 
			"fight_raelag_sovereign_noshield", 
			'/Scenes/CombatArenas/Boss_c6m5_Sovereign3_2.xdb#xpointer(/AdventureFlybyScene)');
end	

function fight_raelag_sovereign_noshield()
			print("starting combat");
			StartCombat("Raelag", "Kha-Beleth", 1, 
			16, 73 + d * 5,	
			'/Maps/Scenario/C6M5/sovereign_raelag_noshield.xdb#xpointer(/Script)', 
			"SovereignIsDead", 
			'/Scenes/CombatArenas/Boss_c6m5_Sovereign4_2.xdb#xpointer(/AdventureFlybyScene)');
end	


function SovereignIsDead()
	if IsHeroAlive("Raelag") == not nil then
			Save("Scene_22");
			sleep(40);
			StartDialogScene("/DialogScenes/C6/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			SetObjectiveState("reach_deamon_lord",OBJECTIVE_COMPLETED);
			SetObjectiveState("save_isabell",OBJECTIVE_COMPLETED);
		else Loose()
	end
end

function HeroesMustSurvive()
	print("Thread HeroesMustSurvive has been started...");
	while 1 do
		sleep(1);
		if (   IsHeroAlive("Zehir")  == nil 
			or IsHeroAlive("Godric") == nil 
			or IsHeroAlive("Raelag") == nil 
			or IsHeroAlive("Heam")   == nil) then
			SetObjectiveState("prim4",OBJECTIVE_FAILED);
			sleep(1);
			Loose(0);
			break;
		end;
	end;
end;

function WinLoose()
	while 1 do
		if GetObjectiveState("save_isabell") == OBJECTIVE_COMPLETED and
			GetObjectiveState("capture_biara") == OBJECTIVE_COMPLETED then
			sleep(20);
			Win(); 
			return
		end;
		if GetObjectiveState("save_isabell") == OBJECTIVE_FAILED or
			GetObjectiveState("capture_biara") == OBJECTIVE_FAILED then
			sleep(40);
			Loose();
			return
		end;
		sleep();
	end;
end;

g = 0
h = 0
j = 0
k = 0

function ddoorTransfer()
	while 1 do
--	print(g + h + j + k);
		if IsObjectInRegion("Zehir", "ddoor01") == not nil then g =1 end
		if IsObjectInRegion("Godric", "ddoor03") == not nil then h =1 end
		if IsObjectInRegion("Raelag", "ddoor04") == not nil then j =1 end
		if IsObjectInRegion("Heam", "ddoor02") == not nil then k =1 end
		if g + h + j + k == 4 then 
			SetObjectEnabled("bcitadel", not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", "bfight") ;
			break;
			end
	sleep(1);
	end
end

function own()
	SetObjectPosition("Zehir", 56, 45);	
	SetObjectPosition("Godric", 57, 46);	
	SetObjectPosition("Heam", 58, 47);	
	SetObjectPosition("Raelag", 59, 48);	
end

StartDialogScene("/DialogScenes/C6/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
H55_CamFixTooManySkills(PLAYER_1,"Zehir");
H55_CamFixTooManySkills(PLAYER_1,"Godric");
H55_CamFixTooManySkills(PLAYER_1,"Heam");
H55_CamFixTooManySkills(PLAYER_1,"Raelag");
SetObjectEnabled("bcitadel", nil);
Trigger(OBJECT_CAPTURE_TRIGGER, "town1", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town2", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town3", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town4", "TownCounter");
startThread(HeroesMustSurvive);
startThread(WinLoose);
startThread(ddoorTransfer);

Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", "barmy")
Trigger(OBJECT_TOUCH_TRIGGER, "scitadel", "Question")

OpenCircleFog(58, 51, 0, 10, PLAYER_1);

-- woot! i eldur og drumur!