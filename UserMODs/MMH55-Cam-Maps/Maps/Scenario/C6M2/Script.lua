doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M2");
    LoadHeroAllSetArtifacts("Zehir", "C6M1" );
end;

startThread(H55_InitSetArtifacts);


---Objectives---

play = 0

function SilverCitiesCaptured()
	if play == 0 then 
		StartDialogScene("/DialogScenes/C6/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("obj1",OBJECTIVE_COMPLETED); 
		ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2448);
		play = play + 1
			else SetObjectiveState("obj1",OBJECTIVE_COMPLETED); 
	end;
end	

town_array = {"town1","town2","town3"};
town_array.n = 3;

function TownCounter ()
	print( "Town_count() = ",Town_count() );
	if Town_count() == 3 then
		SilverCitiesCaptured();
		else SetObjectiveState("obj1",OBJECTIVE_ACTIVE); 
	end;
end;
		
function Town_count()
	local count = 0;
	for i=1, town_array.n do
		if ( GetObjectOwner(town_array[i]) == PLAYER_1 ) then
			count = count + 1;
		end;
		if ( GetObjectOwner(town_array[i]) == PLAYER_3 ) then
			count = count - 1;
		end;
	end;
	return count; 
end;

function SpellsLearned()
	StartDialogScene("/DialogScenes/C6/M2/R3/DialogScene.xdb#xpointer(/DialogScene)");
end	
	
function UpgradingAlSafir()
	SetTownBuildingLimitLevel("insar", TOWN_BUILDING_MAGIC_GUILD, 2);
	while 1 do
--		i = GetTownBuildingLevel( "insar", TOWN_BUILDING_MAGIC_GUILD )
--		print("ch3ck insar = ",i);
		if GetObjectOwner("town3") == PLAYER_1 then 
			SetTownBuildingLimitLevel("insar", TOWN_BUILDING_MAGIC_GUILD, 5) 
			SetRegionBlocked("block", nil, PLAYER_3);
			SetRegionBlocked("block", nil, PLAYER_2);
			end
		if GetObjectOwner("town3") == PLAYER_1 and GetTownBuildingLevel( "town3", TOWN_BUILDING_MAGIC_GUILD ) == 5 then
			sleep(10);
			if GetObjectiveState("obj2") == OBJECTIVE_ACTIVE  then
				SetObjectiveState("obj2",OBJECTIVE_COMPLETED);
				ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2788);
			else
				print("Warning!!! obj2 is not ACTIVE");
			end;
			return 1;
		end;	
	sleep();
	end;	
end	



function obj3()
	while 1 do
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED then
			sleep(1);
			SetObjectiveVisible("obj3", not nil);
		end;
		sleep();	
	end;
end

-- lorekeep = nar ankar


function CapturingNarAnkar()
			Save("Scene_17");
			sleep(20);
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2378);
			StartDialogScene("/DialogScenes/C6/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");	
			SetObjectiveState("obj3",OBJECTIVE_COMPLETED);
			Trigger(OBJECT_CAPTURE_TRIGGER, "nar_ankar", nil);
end

function dialog4()
while 1 do
	if GetObjectiveState("obj1")==OBJECTIVE_COMPLETED and GetObjectiveState("obj2")==OBJECTIVE_COMPLETED then
		sleep(20);
		StartDialogScene("/DialogScenes/C6/M2/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep();
		break;
	end;
sleep(5)
end;
end;



--WinLoose--
function WinLoose()
	while 1 do
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and
			GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Zehir", "C6M2");
			sleep(5);
			Win(); 
			return
		end;
		if GetObjectiveState("obj1") == OBJECTIVE_FAILED or GetObjectiveState("obj2") == OBJECTIVE_FAILED or 
			GetObjectiveState("obj3") == OBJECTIVE_FAILED or GetObjectiveState("obj4") == OBJECTIVE_FAILED then
			sleep(40);
			Loose();
			return
		end;
		sleep();
	end;
end;


function obj4()
	if GetObjectiveState("obj4") == OBJECTIVE_UNKNOWN then
		SetObjectiveState('obj4',OBJECTIVE_ACTIVE);
	else
		print("Warning!!! obj4 is not UNKNOWN");
	end;
while 1 do
	if IsHeroAlive("Zehir")==nil then
		print("Zehir is dead!!!");
		if GetObjectiveState("obj4") == OBJECTIVE_ACTIVE or GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
			SetObjectiveState("obj4",OBJECTIVE_FAILED);
		else
			print("Warning!!! obj4 is not ACTIVE or COMPLETED");
		end;
		return 1;
	end;
	if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED 
		and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
		if GetObjectiveState("obj4") == OBJECTIVE_ACTIVE  then
			SetObjectiveState('obj4',OBJECTIVE_COMPLETED);
		else
			print("Warning!!! obj4 is not ACTIVE");
		end;
		return 1;
	end;
sleep();
end;
end;

function obj1()
	if GetObjectiveState("obj1") == OBJECTIVE_UNKNOWN then
		SetObjectiveState('obj1',OBJECTIVE_ACTIVE);
	else
		print("Warning!!! obj1 is not UNKNOWN");
	end;
sleep();
end;



-- perform script
StartDialogScene("/DialogScenes/C6/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
H55_CamFixTooManySkills(PLAYER_1,"Zehir");

GiveExp( "Aberrar", 13200 );

SetObjectiveVisible("obj3", nil);
SetRegionBlocked("block", not nil, PLAYER_3);
SetRegionBlocked("block", not nil, PLAYER_2);
Trigger(OBJECT_CAPTURE_TRIGGER, "town1", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town2", "TownCounter");
Trigger(OBJECT_CAPTURE_TRIGGER, "town3", "TownCounter");
startThread(UpgradingAlSafir);
startThread(WinLoose);
--startThread(dialog4);
startThread(obj4);
startThread(obj3);
startThread(obj1);
--startThread(CapturingNarAnkar);
Trigger(OBJECT_CAPTURE_TRIGGER, "nar_ankar", "CapturingNarAnkar");