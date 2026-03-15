d = GetDifficulty();
defender_turn = 0
game_time = GetGameVar("game_time");
army_rating = 2*d + game_time/14 -- 2 points per month

summon = {
	inside = {
		count = 0,
		coords =  {
			Xmin =  8, Xmax = 14,
			Ymin =  2, Ymax = 13,
		},
	},
	outside = {
		count = 0,
		coords =  {
			Xmin =  5, Xmax = 10,
			Ymin =  2, Ymax = 13,
		},
	},
}

function get_coords(in_fort)
	local coords = summon.outside.coords;
	if in_fort == not nil then
		coords = summon.inside.coords;
	end
	local x = math.random(coords.Xmin, coords.Xmax);
	local y = math.random(coords.Ymin, coords.Ymax);

	return x, y;
end

function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	if defender_turn == 1 then
		-- summoning reinforcements on the 1st turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*40, get_coords(not nil));
		SummonCreature(DEFENDER,  CREATURE_DISEASE_ZOMBIE, army_rating*52,     get_coords(nil));
		print("first summon");
	 elseif defender_turn == 3 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*40, get_coords(not nil));
		SummonCreature(DEFENDER,  CREATURE_DISEASE_ZOMBIE, army_rating*22, get_coords(nil));
		print("second summon");
	elseif defender_turn == 5 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*35, get_coords(not nil));
		SummonCreature(DEFENDER,  CREATURE_DISEASE_ZOMBIE, army_rating*16, get_coords(nil));
		print("second summon");
	elseif defender_turn == 7 then
		-- summoning reinforcements on the 3rd turn of Markal
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*28, get_coords(not nil));
		SummonCreature(DEFENDER,  CREATURE_DISEASE_ZOMBIE, army_rating*12, get_coords(nil));
		print("second summon");
	elseif defender_turn < 10 then
		UnitCastGlobalSpell(GetDefenderHero(),21)
	end
	return nil
end

-- reinforcements after death
death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		-- summoning creatures upon the death of the first necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*66, get_coords(not nil));
	end
	if death == 2 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_MANES, army_rating*15, get_coords(nil));
	end
	if death == 3 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating*31, get_coords(not nil));
	end
	if death == 4 then
		sleep(10);
		-- summoning creatures upon the death of the second necrostack
		SummonCreature(DEFENDER, CREATURE_WALKING_DEAD, army_rating*23, get_coords(nil));
	end
	if (table.length(GetDefenderCreatures()) == 0) then Finish(ATTACKER) end;
end

function AttackerCreatureDeath(unit)
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

function Start()
	EnableAutoFinish(nil);
	UnitCastGlobalSpell(GetDefenderHero(),21)
end	

while combatStarted() == nil do
	sleep(1);
end;

print("Combat Godric");
setATB(GetDefenderHero(), 0 );
sleep(10);
