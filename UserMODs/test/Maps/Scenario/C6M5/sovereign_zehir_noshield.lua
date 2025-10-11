print("sovereign vs zehir - no shield")
d = GetDifficulty() + 1;

--monsters: alot of cerberi, pit fiends and frightful nightmares

 
function Prepare()
	EnableCinematicCamera(nil);
	sleep(10);
	SummonCreature(DEFENDER, 20, 40 + d * 5, 4, 3);
	sleep(10);
	SummonCreature(DEFENDER, 20, 40 + d * 5, 4, 6);
	sleep(10);
end

function Start()
	EnableAutoFinish(nil);
	sleep(10);
	SummonCreature(DEFENDER, 24, 40 + d * 5, 10, 8);
	sleep(10);
	SummonCreature(DEFENDER, 24, 40 + d * 5, 10, 3);
	sleep(10);
	EnableCinematicCamera(not nil);
end


death = 0
function DefenderCreatureDeath()
	death = death + 1
	if death == 1 then
		sleep(10);
		SummonCreature(DEFENDER, 42, 7 + d * 5, 8, 6);
	end
	if death == 2 then
	sleep(10);
	SummonCreature(DEFENDER, 22, 20 + d * 5, 10, 4);
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
