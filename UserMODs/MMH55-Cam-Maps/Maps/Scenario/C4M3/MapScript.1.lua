H55_PlayerStatus = {0,1,1,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M3");
    LoadHeroAllSetArtifacts("Raelag", "C4M2" );
end;

startThread(H55_InitSetArtifacts);

town_array = { "Town1", "Town2", "Town3", "Town4", "Town5", "Town6", "Town7" };
hero_array = {"Calid","Deleb","Efion"};
dang_array = {"Dalom","Almegir","Eruina","Menel","Inagost","Ferigl","Segref"};
count = 0;
envassion1 = 0;
envassion2 = 0;
envassion3 = 0;
defeathero = 0;
H55_C4M3_Invader = 'Calid';

StartDialogScene("/DialogScenes/C4/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");

if GetDifficulty() == DIFFICULTY_EASY then
	print ("easy");
	dif = 0;
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE)/4;
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
	end;
	for a = 0,6 do
		SetPlayerResource(PLAYER_2, a, 0);
		SetPlayerResource(PLAYER_3, a, 0);
	end;
	AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 50);
	AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 30);
	AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 5);
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	print ("normal");
	dif = 0;
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE)/2;
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
	end;
	for a = 0,6 do
		SetPlayerResource(PLAYER_2, a, 0);
		SetPlayerResource(PLAYER_3, a, 0);
	end;
end;

if GetDifficulty() == DIFFICULTY_HARD then
	print ("Hard");
	dif = 1;
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		AddObjectCreatures(dang_array[i], CREATURE_ASSASSIN , 30);
		AddObjectCreatures(dang_array[i], CREATURE_BLOOD_WITCH , 20);
		SetTownBuildingLimitLevel('Town3', 13, 1);
	end;
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	print ("Impossible");
	dif = 2;
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE) + GetHeroStat("Kelodin", STAT_EXPERIENCE);
	for i,h in dang_array do
		ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		AddObjectCreatures(dang_array[i], CREATURE_ASSASSIN , 45);
		AddObjectCreatures(dang_array[i], CREATURE_BLOOD_WITCH , 30);
		AddObjectCreatures(dang_array[i], CREATURE_MINOTAUR_KING , 37);
		SetTownBuildingLimitLevel('Town3', 13, 1);
		SetTownBuildingLimitLevel('Town4', 13, 1);
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == "Raelag" or HeroName == "Kelodin") then
		SetObjectiveState("Survival", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end;
end;

function Town1inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town1', 'Town1c');
	function Town1c ()
		if GetObjectOwner('Town1') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town1";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town1";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town1";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town1inc );
	end;
end;

function Town2inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town2', 'Town2c');
	function Town2c ()
		if GetObjectOwner('Town2') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town2";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town2";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town2";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town2inc );
	end;
end;

function Town3inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town3', 'Town3c');
	function Town3c ()
		if GetObjectOwner('Town3') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town3";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town3";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town3";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town3inc );
	end;
end;

function Town4inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town4', 'Town4c');
	function Town4c ()
		if GetObjectOwner('Town4') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town4";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town4";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town4";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town4inc );
	end;
end;

function Town5inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town5', 'Town5c');
	function Town5c ()
		if GetObjectOwner('Town5') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town5";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town5";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town5";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town5inc );
	end;
end;

function Town6inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town6', 'Town6c');
	function Town6c ()
		if GetObjectOwner('Town6') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town6";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town6";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town6";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town6inc );
	end;
end;

function Town7inc()
	Trigger (OBJECT_CAPTURE_TRIGGER, 'Town7', 'Town7c');
	function Town7c ()
		if GetObjectOwner('Town7') == 1 then
			count = count + 1;
			sleep (5);
			if count == 2 and envassion1 == 0 then
				Pos = "Town7";
				startThread(Envasion1);
			end;
			sleep (5);
			if count == 4 and envassion2 == 0 then
				Pos = "Town7";
				startThread(Envasion2);
			end;
			sleep (5);
			if count == 6 and envassion3 == 0 then
				Pos = "Town7";
				startThread(Envasion3);
			end;
		else
			count = count - 1;
		end;
	startThread( Town7inc );
	end;
end;

function Envasion1()
	envassion1 = 1; 
	sleep (5);
	StartDialogScene("/DialogScenes/C4/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
	sleep (10);
	SetObjectiveState("Envasion", OBJECTIVE_ACTIVE);
	DeployReserveHero ('Calid', RegionToPoint('EnemyHere'));
	sleep (2);
	startThread( AddTroops1 );
	--EnableHeroAI('Calid', nil);
	x,y,z = RegionToPoint('EnemyHere');
	OpenCircleFog(x, y, z, 2 , PLAYER_1);
	MoveCamera(x,y,z , 50, 1.57);
	sleep (10);
	SetAIHeroAttractor(Pos,'Calid',2);
	SetAIPlayerAttractor(Pos,GetObjectOwner('Calid'),2);
	DenyAIHeroFlee('Calid',1);
	startThread(H55_AttackTown,'Calid',Pos);
	--H55_NewDayTrigger = 1;
	--H55_C4M3_Invader = 'Calid';
	--MoveHero('Calid', GetObjectPosition(Pos));
end;

-- function H55_TriggerDaily()
	-- local x,y,z = GetObjectPosition(Pos);
	-- if IsObjectExists(H55_C4M3_Invader) then
		-- if CanMoveHero(H55_C4M3_Invader,x,y,z) == not nil then
			-- MoveHero(H55_C4M3_Invader,x,y,z);
		-- end;
	-- else
		-- Print("H55 Waiting for next demon invasion...");
	-- end;
-- end;

function Envasion2()
	envassion2 = 1; 
	DeployReserveHero ('Deleb', RegionToPoint('EnemyHere'));
	sleep (2);
	startThread( AddTroops2 );
	SetAIHeroAttractor(Pos,'Deleb',2);
	SetAIPlayerAttractor(Pos,GetObjectOwner('Calid'),2);
	DenyAIHeroFlee('Deleb',1);
	startThread(H55_AttackTown,'Deleb',Pos);
	--EnableHeroAI('Deleb', nil);	
	--H55_NewDayTrigger = 1;
	--H55_C4M3_Invader = 'Deleb';
	--MoveHero('Deleb', GetObjectPosition(Pos));
end;


function Envasion3()
	envassion3 = 1; 
	DeployReserveHero ('Efion', RegionToPoint('EnemyHere'));
	sleep (2);
	startThread( AddTroops3 );
	SetAIHeroAttractor(Pos,'Efion',2);
	SetAIPlayerAttractor(Pos,GetObjectOwner('Calid'),2);
	DenyAIHeroFlee('Efion',1);
	startThread(H55_AttackTown,'Efion',Pos);
	--EnableHeroAI('Efion', nil);
	--H55_NewDayTrigger = 1;
	--H55_C4M3_Invader = 'Efion';
	--MoveHero('Efion', GetObjectPosition(Pos));
end;

function AddTroops1()
	ChangeHeroStat('Calid', STAT_EXPERIENCE , exp);
	X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Calid', CREATURE_IMP , 16*X + 8*X*dif);
	AddObjectCreatures('Calid', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
	AddObjectCreatures('Calid', CREATURE_CERBERI , 8*X + 4*X*dif);
	AddObjectCreatures('Calid', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
	AddObjectCreatures('Calid', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
end;

function AddTroops2()
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
	ChangeHeroStat('Deleb', STAT_EXPERIENCE , exp/(3-dif));
	X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Deleb', CREATURE_IMP , 16*X + 8*X*dif);
	AddObjectCreatures('Deleb', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
	AddObjectCreatures('Deleb', CREATURE_CERBERI , 8*X + 4*X*dif);
	AddObjectCreatures('Deleb', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
	AddObjectCreatures('Deleb', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
	AddObjectCreatures('Deleb', CREATURE_BALOR , 2*X + 1*X*dif);
end;

function AddTroops3()
	exp = GetHeroStat("Raelag", STAT_EXPERIENCE) + GetHeroStat("Kelodin", STAT_EXPERIENCE);
	ChangeHeroStat('Efion', STAT_EXPERIENCE , exp/(3-dif));
	X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Efion', CREATURE_IMP , 16*X + 8*X*dif);
	AddObjectCreatures('Efion', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
	AddObjectCreatures('Efion', CREATURE_CERBERI , 8*X + 4*X*dif);
	AddObjectCreatures('Efion', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
	AddObjectCreatures('Efion', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
	AddObjectCreatures('Efion', CREATURE_BALOR , 2*X + 1*X*dif);
	AddObjectCreatures('Efion', CREATURE_ARCHDEVIL , 1*X + 1*X*dif);
end;

function Infernohero(inferno_hero)
	if inferno_hero == 'Calid' or inferno_hero == 'Deleb' or inferno_hero == 'Efion' then
		defeathero = defeathero + 1;
		print (defeathero);
		print (inferno_hero);
		if defeathero == 3 then
			StartDialogScene("/DialogScenes/C4/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("Envasion", OBJECTIVE_COMPLETED);
			sleep (5);
			LevelUpHero("Raelag");
		end;
	end;
end;

function victory()
	while 1 do 
		sleep (1);
		if GetObjectOwner("Town7") == 1 and GetObjectOwner("Town6") == 1 and GetObjectOwner("Town5") == 1 and GetObjectOwner("Town4") == 1 and GetObjectOwner("Town3") == 1 and GetObjectOwner("Town2") == 1 and GetObjectOwner("Town1") == 1 then
			SaveHeroAllSetArtifactsEquipped("Raelag", "C4M3");
			Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil);
			Save("quicksave");
			StartDialogScene("/DialogScenes/C4/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
			sleep (5);
			--LevelUpHero("Raelag");
			sleep (5);
			Win();
		break;
		end;
	end;
end;

H55_CamFixTooManySkills(PLAYER_1,"Raelag");
H55_CamFixTooManySkills(PLAYER_1,"Kelodin");
startThread( Town1inc );
startThread( Town2inc );
startThread( Town3inc );
startThread( Town4inc );
startThread( Town5inc );
startThread( Town6inc );
startThread( Town7inc );
startThread( victory );
Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, 'Infernohero');