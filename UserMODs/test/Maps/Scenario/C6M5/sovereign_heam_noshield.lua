print("sovereign vs heam - no shield");
d = GetDifficulty() + 1;

--monsters: infernal succubus, cerberi, vampires

 
function Prepare()
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, 22, 55 + d * 5, 10, 8);
	sleep(10);
	SummonCreature(DEFENDER, 22, 55 + d * 5, 10, 3);
	sleep(10);

end

function Start()
	EnableAutoFinish(nil);
	sleep(10);
	SummonCreature(DEFENDER, 20, 50 + d * 5, 5, 3);
	sleep(10);
	SummonCreature(DEFENDER, 20, 50 + d * 5, 5, 5);
	sleep(10);
	SummonCreature(DEFENDER, 25, 25 + d * 5, 13, 8);
	sleep(10);
	EnableCinematicCamera(not nil);
end

death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		SummonCreature(DEFENDER, 41, 20 + d * 5, 8, 6);
	end
	if death == 3 then
		sleep(10);
		SummonCreature(DEFENDER, 28, 15 + d * 5, 8, 6);
	end
	local defenders = GetDefenderCreatures();
	if (table.length(defenders) == 0) then Finish(ATTACKER) end;
end

function AttackerCreatureDeath()
	local attackers = GetAttackerCreatures();
	if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end


function DefenderHeroMove(heroName)
	UnitCastGlobalSpell(GetDefenderHero(), 239);
	return not nil
end
