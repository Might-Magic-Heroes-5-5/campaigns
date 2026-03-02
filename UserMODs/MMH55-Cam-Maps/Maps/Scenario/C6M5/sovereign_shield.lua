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

-- looking for dead catapult --

function FindAttackerCatapult()
	local machines = GetAttackerWarMachines()
	for index,machine in machines do
		if GetWarMachineType(machine) == WAR_MACHINE_CATAPULT then
		   return machine
		end
	end
	return nil
end

catapult = FindAttackerCatapult()

function AttackerWarMachineDeath(unitName)
	if unitName == catapult then
		Finish(DEFENDER)
	end
end

-- looking for dead shield --

shield = GetDefenderBuilding(BUILDING_MAGIC_WALL)

function DefenderBuildingDeath(buildingName)
	if buildingName == shield then
		sleep(10);
		Finish(ATTACKER)
	end
end

function Prepare()
    EnableCinematicCamera(nil);
    sleep(15);
end

growth = 2;
function Start()
    EnableAutoFinish(nil);
	for i = 1, 2 + d do
		summon_unit_from_tier(math.random(1,7), growth, nil);
		sleep(20);
	end;
   
    EnableCinematicCamera(not nil);
end

function DefenderHeroMove(heroName)
    UnitCastGlobalSpell(GetDefenderHero(), 239);
    return not nil
end

function AttackerCreatureDeath()
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

function DefenderCreatureDeath()
	summon_unit_from_tier(math.random(1,7), growth, nil);
	summon_unit_from_tier(math.random(1,7), growth, nil);
end
