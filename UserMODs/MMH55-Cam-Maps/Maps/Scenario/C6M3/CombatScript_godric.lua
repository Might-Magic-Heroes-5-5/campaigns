d = GetDifficulty() + 1;
defender_turn = 0
game_time = GetGameVar("game_time");
army_rating = game_time/(18-3*d) -- 2.33/3/3.5/4.67 points per month
waves = 9 + d;

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

-- Markal summons and casts during first "wave" turns
function DefenderHeroMove(heroName)
	defender_turn = defender_turn + 1
	if defender_turn <= waves then
		if defender_turn == 1 then
			SummonCreature(DEFENDER, CREATURE_SHADOW_DRAGON, army_rating *  3, get_coords(nil));
			SummonCreature(DEFENDER,	  CREATURE_SKELETON, army_rating * 80, get_coords(nil));
			SummonCreature(DEFENDER,		  CREATURE_LICH, army_rating * 20, get_coords(not nil));
			return nil	-- cast a spell
		elseif defender_turn == 2 then
			SummonCreature(DEFENDER, 	   CREATURE_ZOMBIE, army_rating * 30, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_VAMPIRE_LORD, army_rating *  7, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SKELETON, army_rating * 20, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SKELETON, army_rating * 20, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn == 3 then
			SummonCreature(DEFENDER,  CREATURE_SKELETON_ARCHER, army_rating * 60, get_coords(nil));
			SummonCreature(DEFENDER,	CREATURE_SHADOW_DRAGON, army_rating *  2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_WARRIOR, army_rating * 30, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_WARRIOR, army_rating * 30, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn == 4 then
			SummonCreature(DEFENDER,  CREATURE_SKELETON_ARCHER, army_rating * 50, get_coords(nil));
			SummonCreature(DEFENDER,    CREATURE_SHADOW_DRAGON, army_rating *  2, get_coords(nil));
			SummonCreature(DEFENDER,	 CREATURE_VAMPIRE_LORD, army_rating *  5, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_WARRIOR, army_rating * 40, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_WARRIOR, army_rating * 40, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn == 5 then
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_WRAITH, army_rating * 3, get_coords(nil));
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_WRAITH, army_rating * 3, get_coords(nil));
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn == 6 then
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_WRAITH, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_WRAITH, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_WRAITH, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER,  CREATURE_WIGHT, army_rating * 2, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating * 30, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_ARCHER, army_rating * 30, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn == 7 then
			SummonCreature(DEFENDER,     CREATURE_SHADOW_DRAGON, army_rating* 1, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SKELETON_WARRIOR, army_rating* 30, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SHADOW_DRAGON, army_rating* 1, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SKELETON_WARRIOR, army_rating* 30, get_coords(nil));
			SummonCreature(DEFENDER,     CREATURE_SHADOW_DRAGON, army_rating* 1, get_coords(nil));
			return nil	-- cast a spell
		elseif defender_turn <= waves and math.fmod(defender_turn, 8) ~= 9 then
			SummonCreature(DEFENDER,	  CREATURE_BONE_DRAGON, army_rating *  1, get_coords(nil));
			SummonCreature(DEFENDER, 	CREATURE_SHADOW_DRAGON, army_rating *  1, get_coords(nil));
			SummonCreature(DEFENDER,			CREATURE_WIGHT, army_rating *  1, get_coords(nil));
			SummonCreature(DEFENDER,			CREATURE_WIGHT, army_rating *  1, get_coords(nil));
			SummonCreature(DEFENDER, CREATURE_SKELETON_WARRIOR, army_rating * 30, get_coords(nil));
			SummonCreature(DEFENDER, 	  CREATURE_BONE_DRAGON, army_rating *  1, get_coords(nil));
			return nil	-- cast a spell
		else
			UnitCastGlobalSpell(GetDefenderHero(), 21);
		end
		return not nil -- defend because Markal already did special action
	end
	return nil -- cast a spell
end

-- reinforcements after death
death = 0
unit_type = { CREATURE_SKELETON_WARRIOR, CREATURE_GHOST, CREATURE_SKELETON_ARCHER, CREATURE_ZOMBIE, CREATURE_POLTERGEIST, CREATURE_DISEASE_ZOMBIE, CREATURE_NOSFERATU };
unit_size = {                         5,           1.75,                      5.5,               3,                  1.5,                       4,                  1 };
function DefenderCreatureDeath()
	if (table.length(GetDefenderCreatures()) == 0) then
		Finish(ATTACKER)
		return
	end
	
	death = death + 1;

	if death <= 7 then
		SummonCreature(DEFENDER, unit_type[death], army_rating*math.random(10, 15)*unit_size[death], get_coords(not nil));
	end
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
SetUnitManaPoints(GetDefenderHero(),510)
setATB(GetDefenderHero(), 0 );
sleep(10);
