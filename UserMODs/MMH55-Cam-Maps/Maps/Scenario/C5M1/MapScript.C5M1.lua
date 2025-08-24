H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_UNICORN_HORN_BOW,
ARTIFACT_PLATE_MAIL_OF_STABILITY,
ARTIFACT_PEDANT_OF_MASTERY,
ARTIFACT_RING_OF_LIFE,
ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M1");
end;

startThread(H55_InitSetArtifacts);

---VARS AND CONSTANTS---
borders={'Border1','Border2','Border3','Border4','Border5'};
points={'attack1','attack2','attack3','attack4','attack5'};
borders2={'Border1','Border2','Border3','Border4','Border5'};
ai_regions={'ai_block1','ai_block2','ai_block3','ai_block4','ai_block5'};
pl_message_regions={'player_alarm1','player_alarm2','player_alarm3','player_alarm4','player_alarm5'};
pl_fail_regions={'player_fail1','player_fail2','player_fail3','player_fail4','player_fail5'};
heroes={'Tamika','Straker','Pelt','Nemor','Effig'};

C5M1T1='/Maps/Scenario/C5M1/C5M1T1.txt';
alarmh='/Maps/Scenario/C5M1/alarm.txt';
failh='/Maps/Scenario/C5M1/fail.txt';

will = 0;

a={} --временный массив
b={} --временный массив
c={} --временный массив

time = 0;
n = 5;
bor = 1;

if GetDifficulty() == DIFFICULTY_EASY then
	dif = 0;
	print ("easy");
	m = 43;
	SetTownBuildingLimitLevel('Damlad', 11, 2);
	SetTownBuildingLimitLevel('Damlad', 12, 2);
	AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	dif = 0;
	m = 39;
end;
if GetDifficulty() == DIFFICULTY_HARD then
	dif = 1;
	m = 34;
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	dif = 2;
	m = 30;
end;

print (dif);

---FUNCTIONS---
function block() ---блокает регионы для героев АИ
	for i,h in ai_regions do
		SetRegionBlocked(ai_regions[i], 1, 2);
--		print (ai_regions[i]);
	end;
end;

function alarm()
	for k,h in pl_message_regions do
		sleep (1);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,pl_message_regions[k],"ahtung");
	end;
end;

function kauk()
	for m,h in pl_fail_regions do
		sleep (1);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,pl_fail_regions[m],"fail");
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == "Heam" ) then
		SetObjectiveState("prim3", OBJECTIVE_FAILED);
		sleep (15);
		Loose();
	end;
end;

function biarakill()
	while 1 do
	sleep (10);
		if IsHeroAlive("Biara") == nil then
			SaveHeroAllSetArtifactsEquipped("Heam", "C5M1");
			StartDialogScene("/DialogScenes/C5/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("prim4", OBJECTIVE_COMPLETED);
			sleep (5);
			LevelUpHero("Heam");
			sleep (5);
			Win();
			break;
		end;
	end;
end;

function borders_trigger()
	for i = 1,5 do
		sleep (1);
		Trigger(OBJECT_CAPTURE_TRIGGER,borders[i], 'defend');
	end;
end;

function defend(play_1,play_2,name_h)
	if play_1 == 1 then
		for a = 1,5 do
			sleep (1);
			if GetObjectOwner(borders[a]) == 2 then
				bor = bor + 1;
			end;
		end;
		if bor < 3 then
			if will == 0 then
				SetObjectiveState('prim5', OBJECTIVE_ACTIVE);
				sleep (10);
				StartDialogScene("/DialogScenes/C5/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
			else
				SetObjectiveState('prim5', OBJECTIVE_ACTIVE);
			end
		else
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			sleep (3);
			Loose();
		end;
		bor = 1;
	else
		if will == 0 then
			SetObjectiveState('prim5', OBJECTIVE_COMPLETED);
			StartDialogScene("/DialogScenes/C5/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
			will = 1;
			AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 1);
		else
			SetObjectiveState('prim5', OBJECTIVE_COMPLETED);
			AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 1);
		end;
	end;
end;

H55_NewDayTrigger = 1;
--Trigger (NEW_DAY_TRIGGER,"timer");
function H55_TriggerDaily()
	if GetDate(DAY) == m then
		DeployReserveHero ("Biara" , RegionToPoint('EnemyHere'));
		exp = GetHeroStat("Heam", STAT_EXPERIENCE);
		ChangeHeroStat("Biara", STAT_EXPERIENCE , exp/(3-dif));
		AddHeroCreatures("Biara",CREATURE_IMP , (5 + dif)*10);
		AddHeroCreatures("Biara",CREATURE_HORNED_DEMON , (5 + dif)*5);
		AddHeroCreatures("Biara",CREATURE_CERBERI , (5 + dif)*2);
		AddHeroCreatures("Biara",CREATURE_INFERNAL_SUCCUBUS , (5 + dif*2));
		AddHeroCreatures("Biara",CREATURE_FRIGHTFUL_NIGHTMARE , (5 + dif));
		AddHeroCreatures("Biara",CREATURE_BALOR , 2 + dif);
		AddHeroCreatures("Biara",CREATURE_ARCHDEVIL , 2 + dif);
		EnableHeroAI("Biara" ,not nil);
		sleep (5);
		startThread(H55_AttackTown,"Biara","Damlad");
		--MoveHero("Biara", GetObjectPosition("Damlad"));
		startThread(biarakill);
	end;
	if GetDate(DAY) == m+2 then
		StartDialogScene("/DialogScenes/C5/M1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep (10);
		bor = 1;
		SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
		AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 5);
		for i = 1,5 do
			sleep (1);
			Trigger(OBJECT_CAPTURE_TRIGGER,borders[i], nil);
		end;
		SetObjectiveState('prim4', OBJECTIVE_ACTIVE);
	end;
	if GetDate(WEEK) > time and GetDate(DAY_OF_WEEK) > random(6) then
		time = time + 1;
		reserve = random(n) + 1;
		border_a = random(n) + 1;
		exp = GetHeroStat("Heam", STAT_EXPERIENCE);
		ChangeHeroStat(heroes[reserve], STAT_EXPERIENCE , exp/(3-dif));
		DeployReserveHero (heroes[reserve] , RegionToPoint('EnemyHere'));
		AddHeroCreatures(heroes[reserve],CREATURE_SKELETON_ARCHER , 20 + GetDate(WEEK)*10 + dif*5);
		AddHeroCreatures(heroes[reserve],CREATURE_ZOMBIE , 15 + GetDate(WEEK)*7 + dif*3);
		AddHeroCreatures(heroes[reserve],CREATURE_GHOST , 9 + GetDate(WEEK)*4 + dif*2);
		AddHeroCreatures(heroes[reserve],CREATURE_VAMPIRE_LORD , 5 + GetDate(WEEK)*2 + dif);
		AddHeroCreatures(heroes[reserve],CREATURE_DEMILICH , GetDate(WEEK) + dif);
		AddHeroCreatures(heroes[reserve],CREATURE_WRAITH , 2 + GetDate(WEEK)*dif/2);
		AddHeroCreatures(heroes[reserve],CREATURE_SHADOW_DRAGON , 1 + GetDate(WEEK)*dif/4);
		EnableHeroAI(heroes[reserve],not nil);
		sleep (5);
		MoveHero(heroes[reserve], RegionToPoint(points[border_a]));
		n = n - 1;
		x = heroes[reserve];
		y = points[border_a];
		print (x);
		print (y);
		heroes=remove_element(x,heroes);
		points=remove_element(y , points);			
	end;
end;

function remove_element(element_name,array_name) --функция для убирания элемента из массива (array_name-имя массива,element_name-имя элемента)
	local j=1 --индекс временного массива
	local a={}
	for i, h in array_name do
		if array_name[i] ~= element_name
			then
				a[j]=array_name[i];
				j=j+1;
			else
		end;
	end;
	array_name={}
	array_name=a
	return array_name
end;

function fail(h_n)
	if GetObjectOwner(h_n) == 1 then
		MessageBox(failh);
		sleep (20);
		SetObjectiveState("prim2", OBJECTIVE_FAILED);
		sleep (20);
		Loose();
	end;
	startThread(kauk);
end;

function ahtung(h_n)
	if GetObjectOwner(h_n) == 1 then
		MessageBox(alarmh);
		startThread(alarm);
	end;
end;

---MAIN PART---
Save("autosave");
StartCutScene("/Maps/Cutscenes/C4M5/_.(AnimScene).xdb#xpointer(/AnimScene)");
StartDialogScene("/DialogScenes/C5/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
startThread(block);
startThread(alarm);
startThread(kauk);
startThread(borders_trigger);
SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
SetObjectiveState('prim2', OBJECTIVE_ACTIVE);