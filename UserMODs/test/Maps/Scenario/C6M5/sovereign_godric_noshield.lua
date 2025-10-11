print("sovereign vs godric - no shield");
d = GetDifficulty() + 1;

--monsters: alot of frightful nightmares, imps and demons

function Prepare()
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, 24, 20 + d * 5, 10, 8);
	sleep(10);
	SummonCreature(DEFENDER, 24, 20 + d * 5, 10, 3);
	sleep(10);

end
 
function Start()
	EnableAutoFinish(nil);
	sleep(30);
	SummonCreature(DEFENDER, 18, 50 + d * 5, 4, 3);
	sleep(10);
	SummonCreature(DEFENDER, 18, 50 + d * 5, 4, 8);
	sleep(10);
	EnableCinematicCamera(not nil);
end

death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		SummonCreature(DEFENDER, 28, 7 + d * 5, 8, 6);
	end
	if death == 3 then
		sleep(10);
		SummonCreature(DEFENDER, 26, 12 + d * 5, 8, 6);
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

