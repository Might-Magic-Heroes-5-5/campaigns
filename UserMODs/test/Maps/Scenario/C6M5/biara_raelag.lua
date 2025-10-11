print("biara vs raelag")
d = GetDifficulty();

function Prepare()
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, 20, 55 + d * 5, 7, 12);
	sleep(10);
	SummonCreature(DEFENDER, 20, 55 + d * 5, 7, 3);
	sleep(10);
	SummonCreature(DEFENDER, 20, 55 + d * 5, 7, 8);
	sleep(15);
end

function Start() 
	EnableAutoFinish(nil);
	sleep(30);
	SummonCreature(DEFENDER, 22, 50 + d * 5, 13, 3);
	sleep(10);
	SummonCreature(DEFENDER, 22, 50 + d * 5, 13, 12);
	sleep(10);
	EnableCinematicCamera(not nil);
end


death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		SummonCreature(DEFENDER, 25, 30 + d * 5, 12, 8);
	end
	if death == 2 then
		sleep(10);
		SummonCreature(DEFENDER, 27, 15 + d * 5, 7, 12);
		sleep(10);
		SummonCreature(DEFENDER, 27, 15 + d * 5, 7, 3);
		sleep(1);
	end

	local defenders = GetDefenderCreatures();
	if (table.length(defenders) == 0) then Finish(ATTACKER) end;
end

function AttackerCreatureDeath()
	local attackers = GetAttackerCreatures();
	if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end


-- looking for certain creature in the army and casting uberchanlight on it --

function FindAttackerCreature()
            local creatures = GetAttackerCreatures()
            for index,creature in creatures do
                        if GetCreatureType(creature) == CREATURE_CHAOS_HYDRA then
                                   return creature
                        end
            end
            return nil
end
 
-- function DefenderHeroMove(heroName)
	-- UnitCastAimedSpell(GetDefenderHero(), 238, FindAttackerCreature());
	-- return not nil
-- end



