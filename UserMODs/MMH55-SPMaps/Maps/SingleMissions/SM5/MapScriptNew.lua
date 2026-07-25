doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,2,2,2,2,2,2,2};

function PlayerWin()
	while 1 do
		sleep(20);
		if IsObjectInRegion("Christian", "end") == not nil then
			SetObjectiveState("HeroSurvive", OBJECTIVE_COMPLETED);
			sleep(20);
			SetObjectiveState("PlayerWin", OBJECTIVE_COMPLETED);
			sleep(100);
			Win(0);
			return
		end
	end
end

function LostHero( HeroName )
	if ( HeroName == "Christian" ) then
		SetObjectiveState("HeroSurvive", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end
end

function redkey()
	SetObjectiveState('first', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER, "red", "redquest");
end

function bluekey()
	SetObjectiveState('second', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER, "blue", "bluequest");
end

function greenkey()
	SetObjectiveState('third', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER, "green", "greenquest");
end

function redquest()
	print("Thread redquest has been started...");
	local peasants = GetHeroCreatures("Christian",CREATURE_PEASANT);
	local familiars = GetHeroCreatures("Christian",CREATURE_FAMILIAR);
	local hunters = GetHeroCreatures("Christian",CREATURE_WOOD_ELF);
	local gremlins = GetHeroCreatures("Christian",CREATURE_GREMLIN);
	
	if peasants < 20 then
		print("Not enough peasants");
	elseif peasants < 2 * familiars or familiars == 0 then
		print("Failed: peasants >= 2 * familiars");
	elseif hunters < 5 * gremlins or gremlins == 0 then
		print("Failed: hunters >= 5 * gremlin");
	elseif familiars < 10 * gremlins or gremlins == 0 then
		print("Failed: familiars >= 10 * gremlins");
	elseif familiars < 2 * hunters or hunters == 0 then
		print("Failed: familiars >= 2 * hunters");
	else
		SetObjectiveState("first",OBJECTIVE_COMPLETED);
		ObjectiveExp("Christian");
		Trigger(OBJECT_TOUCH_TRIGGER, "red" , nil);
		GiveBorderguardKey(1 , RED_KEY);
	end
end

function bluequest()
	Zombie = GetHeroCreatures("Christian",CREATURE_ZOMBIE);
	Walking_dead = GetHeroCreatures("Christian",CREATURE_WALKING_DEAD);
	Vampire = GetHeroCreatures("Christian",CREATURE_VAMPIRE);
	Vampire_lord = GetHeroCreatures("Christian",CREATURE_VAMPIRE_LORD);
	Lich = GetHeroCreatures("Christian",CREATURE_LICH);
	Demilich = GetHeroCreatures("Christian",CREATURE_DEMILICH);
	if (Zombie + Walking_dead == 25 and Vampire + Vampire_lord == 20 and Lich + Demilich == 16) then
		SetObjectiveState("second",OBJECTIVE_COMPLETED);
		ObjectiveExp("Christian");
		Trigger(OBJECT_TOUCH_TRIGGER, "blue" , nil);
		GiveBorderguardKey(1 , BLUE_KEY);
	end
end

function greenquest()
	if (GetHeroCreatures("Christian",CREATURE_GIANT) == 1
		and GetHeroCreatures("Christian",CREATURE_DEVIL) == 2 
		and GetHeroCreatures("Christian",CREATURE_BONE_DRAGON) == 2
		and GetHeroCreatures("Christian",CREATURE_ANGEL) == 5) then
		SetObjectiveState( "third", OBJECTIVE_COMPLETED );
		ObjectiveExp("Christian");
		Trigger(OBJECT_TOUCH_TRIGGER, "green" , nil);
		GiveBorderguardKey(1 , GREEN_KEY);
		startThread(PlayerWin);
	end
end

SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 1000 * (4 - GetDifficulty()));
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
Trigger( OBJECT_TOUCH_TRIGGER , "red" , "redkey" );
Trigger( OBJECT_TOUCH_TRIGGER , "blue" , "bluekey" );
Trigger( OBJECT_TOUCH_TRIGGER , "green" , "greenkey" );
SetObjectEnabled("red", nil);
SetObjectEnabled("blue", nil);
SetObjectEnabled("green", nil);
SetObjectiveState('HeroSurvive', OBJECTIVE_ACTIVE);
SetObjectiveState('PlayerWin', OBJECTIVE_ACTIVE);
