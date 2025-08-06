H55_NewDayTrigger = 1;
H55_PlayerStatus = {0,1,1,1,2,2,2,2};
ChangeHeroStat("Inagost", STAT_EXPERIENCE, 5000);
ChangeHeroStat("Brem", STAT_EXPERIENCE, 5000);

SetRegionBlocked("block3", 1, PLAYER_2);
SetRegionBlocked("block4", 1, PLAYER_2);
SetRegionBlocked("block1", 1, PLAYER_3);
SetRegionBlocked("block2", 1, PLAYER_3);
SetRegionBlocked("blocking1", 1, PLAYER_2);
SetRegionBlocked("blocking2", 1, PLAYER_2);

if GetDifficulty() == DIFFICULTY_EASY then
	weekun = 36;
	print (weekun);
	AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 30);
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	weekun = 28;
	AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 15);
	print (weekun);
end;
if GetDifficulty() == DIFFICULTY_HARD then
	weekun = 14;
	AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 5);
	print (weekun);
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	weekun = 2;
	print (weekun);
end;


Trigger (OBJECT_CAPTURE_TRIGGER, 'Home', 'LooseHome');
function LooseHome ()
	SetObjectiveState("DefendHome", OBJECTIVE_FAILED);
	sleep (10);
	Loose (); 
end;

Trigger (OBJECT_CAPTURE_TRIGGER, 'Haven', 'TakeHaven');
function TakeHaven (heroname)
	if heroname == 'Nadaur' then 
		EnableHeroAI('Nadaur', not nil);
		Trigger (OBJECT_CAPTURE_TRIGGER, 'Haven', nil);
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == "Eruina" ) then
		SetObjectiveState("Survival", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "LostHero5" );
function LostHero5( HeroName5 )
	if HeroName5 == "Inagost" then
		StartDialogScene("/DialogScenes/Single/SM2/R3/DialogScene.xdb#xpointer(/DialogScene)");
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil );
	end;
end;

function Objective1()
	while 1 do 
	  sleep (10);
	    if GetObjectOwner("Haven") == 1 and GetObjectOwner("Dungeon") == 1 then
			print (GetObjectOwner("Haven"), " " ,GetObjectOwner("Dungeon"));
			SetObjectiveState('Start', OBJECTIVE_COMPLETED);
			DeployReserveHero ('Nadaur', RegionToPoint('EnemyHere'));
			sleep (2);
			LevelUpHero("Eruina");
			startThread(AddTroops);
			EnableHeroAI('Nadaur', not nil);	
			MoveHero('Nadaur', RegionToPoint('Enter'));
			sleep (5);
			SetObjectiveState('Final', OBJECTIVE_ACTIVE); 
			startThread(FinalBattle);
			break
		end;
		if GetDate(MONTH) == 4 then
			SetObjectiveState('Start', OBJECTIVE_FAILED);
			DeployReserveHero ('Nadaur', RegionToPoint('EnemyHere'));
			sleep (2);
			startThread(AddTroops);
			EnableHeroAI('Nadaur', not nil);	
			MoveHero('Nadaur', RegionToPoint('EnemyHere1'));
			sleep (5);
			SetObjectiveState('Final', OBJECTIVE_ACTIVE); 
			startThread(FinalBattle);
			break
	    end;
    end;
end;

function AddTroops ()
	X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	ChangeHeroStat('Nadaur', STAT_EXPERIENCE, 10000*X);
	AddObjectCreatures('Nadaur', CREATURE_SPRITE , 16*X);
	AddObjectCreatures('Nadaur', CREATURE_WAR_DANCER , 9*X);
	AddObjectCreatures('Nadaur', CREATURE_GRAND_ELF , 7*X);
	AddObjectCreatures('Nadaur', CREATURE_DRUID_ELDER , 4*X);
	AddObjectCreatures('Nadaur', CREATURE_WAR_UNICORN , 3*X);
	AddObjectCreatures('Nadaur', CREATURE_TREANT_GUARDIAN , 2*X);
	AddObjectCreatures('Nadaur', CREATURE_GOLD_DRAGON , 1*X);
	filmdata = 3;
	H55_NewDayTrigger = 0;
	H55_SecNewDayTrigger = 1;
end;

function H55_SecTriggerDaily()
	filmdata = filmdata - 1;
	if filmdata == 0 then
		StartDialogScene("/DialogScenes/Single/SM2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		H55_SecNewDayTrigger = 0;
	end;
end;

function FinalBattle ()
	Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_4, "LostHero2" );
	function LostHero2( HeroName )
		if ( HeroName == "Nadaur" ) then
			StartDialogScene("/DialogScenes/Single/SM2/R6/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("Final", OBJECTIVE_COMPLETED);
			sleep (10);
			Win (0);
		end;
	end;
end;

function H55_TriggerDaily()
	if GetDate(ABSOLUTE_DAY) == weekun then
		SetRegionBlocked("blocking1", nil, PLAYER_2);
		SetRegionBlocked("blocking2", nil, PLAYER_2);
	end;
end;

StartDialogScene("/DialogScenes/Single/SM2/R1/DialogScene.xdb#xpointer(/DialogScene)");
startThread(Objective1);
SetObjectiveState('Start', OBJECTIVE_ACTIVE); 