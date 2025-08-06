defender_turn = 0
function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	print("Markal's turn number ",defender_turn);
		-- every turn Markal's mana is being reset to 510 points
		-- and he casts UnholyWord
	if defender_turn == 1 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, 20, 8, 2);
		SummonCreature(DEFENDER, CREATURE_VAMPIRE, 15, 3, 2);
		print("resetting mana");
	end
	if defender_turn == 2 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		SummonCreature(DEFENDER, CREATURE_LICH, 15, 3, 2);
		print("resetting mana");
	end
	if defender_turn == 3 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		print("resetting mana");
	end
	if defender_turn == 4 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		print("resetting mana");
	end
	if defender_turn == 5 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SetUnitManaPoints(GetDefenderHero(),510);
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		print("resetting mana");
	end
	if defender_turn == 6 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);		
		SetUnitManaPoints(GetDefenderHero(),510);
		print("resetting mana");
	end
	if defender_turn == 7 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		SetUnitManaPoints(GetDefenderHero(),510);
		print("resetting mana");
	end
	if defender_turn == 8 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		SetUnitManaPoints(GetDefenderHero(),510);
		print("resetting mana");
	end
	if defender_turn == 9 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		SetUnitManaPoints(GetDefenderHero(),510);
		print("resetting mana");
	end
	if defender_turn == 10 then
--		UnitCastGlobalSpell(GetDefenderHero(),21)
		SummonCreature(DEFENDER, CREATURE_MANES, 10, 8, 2);
		SetUnitManaPoints(GetDefenderHero(),510);
		print("resetting mana");
	end
end

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
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, 15, 8, 2);
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

print("Combat Zehir");
SetUnitManaPoints(GetDefenderHero(),510)
setATB(GetDefenderHero(), 0 );
sleep(20);