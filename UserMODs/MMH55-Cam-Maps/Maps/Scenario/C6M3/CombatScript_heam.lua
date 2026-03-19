d = GetDifficulty() + 1;
defender_turn = 0
game_time = GetGameVar("game_time");
waves = game_time/(22-3*d) -- 2.15/2.54/3.11/3.5
army_rating = d*0.2

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
			Xmin =  2, Xmax =  7,
			Ymin =  2, Ymax = 13,
		},
	},
	
	units = {
		{ id = {     CREATURE_SKELETON, CREATURE_SKELETON_ARCHER, CREATURE_SKELETON_WARRIOR }, size = 200 },
		{ id = { CREATURE_WALKING_DEAD,          CREATURE_ZOMBIE,   CREATURE_DISEASE_ZOMBIE }, size = 150 },
		{ id = {        CREATURE_MANES,           CREATURE_GHOST,      CREATURE_POLTERGEIST }, size = 100 },
		{ id = {      CREATURE_VAMPIRE,    CREATURE_VAMPIRE_LORD,        CREATURE_NOSFERATU }, size =  70 },
		{ id = {         CREATURE_LICH,        CREATURE_DEMILICH,      CREATURE_LICH_MASTER }, size =  35 },
		{ id = {        CREATURE_WIGHT,          CREATURE_WRAITH,          CREATURE_BANSHEE }, size =  15 },
		{ id = {  CREATURE_BONE_DRAGON,   CREATURE_SHADOW_DRAGON,    CREATURE_HORROR_DRAGON }, size =  10 },
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

death = 0;
function DefenderCreatureDeath(unit_s)
	if (table.length(GetDefenderCreatures()) == 0) then
		Finish(ATTACKER);
		return
	end
	
	death = death + 1;
	if death <= waves then
		print("wave "..death);
		local unit_type = GetCreatureType(unit_s);
		for i = 1, 7 do
			if string.match(summon.units[i].id[1], unit_type) or string.match(summon.units[i].id[2], unit_type) or string.match(summon.units[i].id[3], unit_type) then
				local fort = nil;
				if i == 5 then
					fort = not nil;
				end
				SummonCreature(DEFENDER, summon.units[i].id[3], (1 + death*army_rating) * summon.units[i].size, get_coords(fort));
				break
			end
		end
	end
end

function AttackerCreatureDeath(unit)
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

function Start()
	EnableAutoFinish(nil);
	UnitCastGlobalSpell(GetDefenderHero(),21);
end

while combatStarted() == nil do
	sleep(1);
end;
		
print("Combat Findan");
setATB(GetDefenderHero(), 0 );
sleep(20);
