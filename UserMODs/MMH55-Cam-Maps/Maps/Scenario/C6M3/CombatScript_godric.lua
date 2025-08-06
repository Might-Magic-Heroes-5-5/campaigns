defender_turn = 0
function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	if defender_turn == 1 then
		-- summoning reinforcements on the 1st turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 40, 7, 2);
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 52, 8, 3);
		print("first summon");
	end
	if defender_turn == 3 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 40, 7, 4);
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 22, 8, 4);
		print("second summon");
	end
	if defender_turn == 4 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 35, 7, 7);
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 16, 9, 3);
		print("second summon");
	end
	if defender_turn == 5 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 28, 2, 3);
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 12, 9, 5);
		print("second summon");
	end	
end

-- reinforcements after death
death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		-- summoning creatures upon the death of the first necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 66, 8, 6);
	end
	if death == 2 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_MANES, 15, 8, 2);
	end
	if death == 3 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, 31, 8, 1);
	end
	if death == 4 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 23, 8, 7);
	end
end

while combatStarted() == nil do
	sleep(1);
end;

setATB(GetDefenderHero(), 0 );
print("Combat Godric");
sleep(10);
--SetUnitManaPoints(GetDefenderHero(),333)

function Start()
	UnitCastGlobalSpell(GetDefenderHero(),21)
end	