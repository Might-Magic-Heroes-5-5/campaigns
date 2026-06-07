d = GetDifficulty() + 1;
defender_turn = 0
game_time = GetGameVar("game_time");
army_rating = game_time/(18-3*d) -- 2.33/3/3.5/4.67 points per month
waves = 12 + d;

-- Markal summons and casts during first "wave" turns
function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	if defender_turn == 1 then
		SummonCreature(DEFENDER, CREATURE_VAMPIRE, army_rating*50, math.random(3,10), math.random(2,12));
		SummonCreature(DEFENDER,  CREATURE_LICH, army_rating*20, math.random(3,10), math.random(2,12));
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*30, math.random(3,10), math.random(2,12));
		return nil	-- cast a spell
	elseif defender_turn <= waves and math.fmod(defender_turn, 2) ~= 0 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*18, math.random(3,10), math.random(2,12));
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*18, math.random(3,10), math.random(2,12));	
		SummonCreature(DEFENDER, CREATURE_VAMPIRE, army_rating*25, math.random(3,10), math.random(2,12));
		return nil	-- cast a spell
	else
		return nil -- cast a spell
	end
	return not nil -- defend because Markal already did special action
end

death = 0
function DefenderCreatureDeath()
	if (table.length(GetDefenderCreatures()) == 0) then
		Finish(ATTACKER)
		return
	end
	
	death = death + 1
	local unit_type = CREATURE_SKELETON;
	local unit_size = 2;
	if math.fmod(death, 2) == 0 then
		unit_type = CREATURE_WALKING_DEAD;
		unit_size = 1;
	end
	
	if death <= 7 then
		SummonCreature(DEFENDER, unit_type, unit_size*army_rating*math.random(20, 40), math.random(3,10), math.random(2,12));
	end
end

function AttackerCreatureDeath()
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

function Start()
	EnableAutoFinish(nil);
end

while combatStarted() == nil do
	sleep(1);
end;

print("Combat Zehir");
SetUnitManaPoints(GetDefenderHero(),510)
setATB(GetDefenderHero(), 0 );
sleep(20);
