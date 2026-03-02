d = GetDifficulty() + 1;

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
	units = {
		{ id = {     CREATURE_FAMILIAR,                 CREATURE_IMP,             CREATURE_QUASIT }, size = 100 },
		{ id = { CREATURE_HORNED_DEMON,        CREATURE_HORNED_DEMON,      CREATURE_HORNED_LEAPER }, size =  90 },
		{ id = {   CREATURE_HELL_HOUND,             CREATURE_CERBERI, CREATURE_FIREBREATHER_HOUND }, size =  50 },
		{ id = {     CREATURE_SUCCUBUS,   CREATURE_INFERNAL_SUCCUBUS,   CREATURE_SUCCUBUS_SEDUCER }, size =  40 },
		{ id = {    CREATURE_NIGHTMARE, CREATURE_FRIGHTFUL_NIGHTMARE,           CREATURE_HELLMARE }, size =  30 },
		{ id = {    CREATURE_PIT_FIEND,               CREATURE_BALOR,          CREATURE_PIT_SPAWN }, size =  15 },
		{ id = {        CREATURE_DEVIL,           CREATURE_ARCHDEVIL,         CREATURE_ARCH_DEMON }, size =   7 },
	},
}

function is_ranged(id)
	if id == 4 then
		return not nil
	end
	return nil
end

function is_large(id)
	if id > 4 then
		return not nil
	end
	return nil
end

function get_summon_tier(large_tries)
	local tier = math.random(1,7);
	while is_ranged(tier) ~= nil do
		tier = get_summon_tier(0);
	end
	
	if is_large(tier) == nil and large_tries > 0 then
		tier = get_summon_tier(large_tries - 1);
	end
	
	return tier;
end

function get_coords(in_fort)
	local coords = summon.outside.coords;
	if in_fort == not nil then
		coords = summon.inside.coords;
	end
	local x = math.random(coords.Xmin, coords.Xmax);
	local y = math.random(coords.Ymin, coords.Ymax);

	return x, y;
end

function summon_unit_from_tier(tier, growth, in_fort)
	local upgrade_type = math.random(2) + 1;
	local unit_id = summon.units[tier].id[upgrade_type];
	local stack_size = summon.units[tier].size * growth;
	if tier == 4 then 
		in_fort = not nil;
	end
	SummonCreature(DEFENDER, unit_id, stack_size, get_coords(in_fort));
end

--monsters: alot of frightful nightmares, imps and demons

function Prepare()
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, 24, 20 + d * 5, 10, 8);
	sleep(10);
	SummonCreature(DEFENDER, 24, 20 + d * 5, 10, 3);
	sleep(10);

end

growth = 2.5;
function Start()
	EnableAutoFinish(nil);
	sleep(30);
	summon_unit_from_tier(get_summon_tier(3), growth, nil);
	sleep(10);
	summon_unit_from_tier(get_summon_tier(3), growth, nil);
	sleep(10);
	EnableCinematicCamera(not nil);
end

death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death < (2 + 2*d) and math.fmod(death, 3) == 0 then
		summon_unit_from_tier(get_summon_tier(2), growth, nil);
		summon_unit_from_tier(get_summon_tier(2), growth, nil);
		summon_unit_from_tier(get_summon_tier(2), growth, nil);
		summon_unit_from_tier(get_summon_tier(2), growth, nil);
	end

	local defenders = GetDefenderCreatures();
	if (table.length(defenders) == 0) then Finish(ATTACKER) end;
end

function DefenderHeroMove(heroName)
	UnitCastGlobalSpell(GetDefenderHero(), 239);
	return not nil
end

function AttackerCreatureDeath()
	local attackers = GetAttackerCreatures();
	if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end
