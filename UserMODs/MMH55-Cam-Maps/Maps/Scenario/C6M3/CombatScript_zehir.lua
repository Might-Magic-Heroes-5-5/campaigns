d = GetDifficulty() + 1;
defender_turn = 0
game_time = GetGameVar("game_time");
army_rating = 2*d + game_time/10 -- 2 points per month

function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	print("Markal's turn number ",defender_turn);
		-- every turn Markal's mana is being reset to 510 points
		-- and he casts UnholyWord
	if defender_turn == 1 then
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER,  CREATURE_MANES,  army_rating*20, math.random(3,10), math.random(2,12));
		SummonCreature(DEFENDER, CREATURE_VAMPIRE, army_rating*15, math.random(3,10), math.random(2,12));
	end
	if defender_turn == 2 then
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*15, math.random(3,10), math.random(2,12));
		SummonCreature(DEFENDER,  CREATURE_LICH,  army_rating*8, math.random(3,10), math.random(2,12));
	end
	if defender_turn == 3 then
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
	end
	if defender_turn == 4 then
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
	end
	if defender_turn == 5 then
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
	end
	if defender_turn == 6 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));		
		SetUnitManaPoints(GetDefenderHero(),510);
	end
	if defender_turn == 7 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
		SetUnitManaPoints(GetDefenderHero(),510);
	end
	if defender_turn == 8 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
		SetUnitManaPoints(GetDefenderHero(),510);
	end
	if defender_turn == 9 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
		SetUnitManaPoints(GetDefenderHero(),510);
	end
	if defender_turn == 10 then
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*10, math.random(3,10), math.random(2,12));
		SetUnitManaPoints(GetDefenderHero(),510);
	end
	
	return not nil;
end

death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		-- summoning creatures upon the death of the first necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*66, math.random(3,10), math.random(2,12));
	end
	if death == 2 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, army_rating*15, math.random(3,10), math.random(2,12));
	end
	if death == 3 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*31, math.random(3,10), math.random(2,12));
	end
	if death == 4 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, army_rating*23, math.random(3,10), math.random(2,12));
	end
	if (table.length(GetDefenderCreatures()) == 0) then Finish(ATTACKER) end;
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
