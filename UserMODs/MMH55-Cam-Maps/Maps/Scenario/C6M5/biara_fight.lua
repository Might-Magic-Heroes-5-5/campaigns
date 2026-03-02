print("biara fight")
d = GetDifficulty()+1;

summon = {
	inside = {
		count = 0,
		coords =  {
			Xmin = 11, Xmax = 14,
			Ymin =  4, Ymax = 11,
		},
	},
	outside = {
		count = 0,
		coords =  {
			Xmin =  5, Xmax =  7,
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

function get_summon_tier()
	current_tier = current_tier + 1;
	if is_ranged(current_tier) ~= nil then
		get_summon_tier();
	end
	if current_tier > 7 then
		current_tier = 1;
	end
	return current_tier;
end

function is_large(id)
	if id >= 5 then
		return not nil
	end
	return nil
end

function is_ranged(id)
	if id == 4 then
		return not nil
	end
	return nil
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
	SummonCreature(DEFENDER, unit_id, stack_size, get_coords(in_fort));
end

function Prepare()
	EnableAutoFinish(nil)
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, CREATURE_INFERNAL_SUCCUBUS, d * 75, 15, 1);
	sleep(10);
	SummonCreature(DEFENDER, CREATURE_INFERNAL_SUCCUBUS, d * 75, 15, 14);
	sleep(15);
end

function Start()
	sleep(30);
	SummonCreature(DEFENDER, CREATURE_HORNED_DEMON, 100,  7, 12);
	sleep(10); 
	SummonCreature(DEFENDER, CREATURE_HORNED_DEMON, 100,  7,  3);
	sleep(10);
	SummonCreature(DEFENDER, CREATURE_HORNED_DEMON, 100,  7,  8);
	sleep(10);
	EnableCinematicCamera(not nil);
end

death = 0;
succubus_kills = 0;
current_tier = 2;

function DefenderCreatureDeath(unit_s)
	death = death + 1;
	print("wave "..death);
	if death <= (2 + d*2) and math.fmod(death, 2) == 0 then
		
		local tier = get_summon_tier();
		sleep(30);
		summon_unit_from_tier(current_tier, 1, nil);
		summon_unit_from_tier(current_tier, 1, nil);
		summon_unit_from_tier(current_tier, 1, nil);
	end
	if (table.length(GetDefenderCreatures()) == 0) then Finish(ATTACKER) end;
end

function AttackerCreatureDeath()
	local attackers = GetAttackerCreatures();
	if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

-- looking for certain creature in the army and casting uberchanlight on it --

function FindAttackerCreature()
	local creatures = GetAttackerCreatures();
	local size = table.length(creatures);
	if size > 3 then
		print(creatures);
		local choice = math.random(0, size - 1);
		print(choice.." "..size);
		return creatures[choice];
	end
	return nil
end
 
function DefenderHeroMove(heroName)
	UnitCastAimedSpell(GetDefenderHero(), 238, FindAttackerCreature());
	return not nil
end
