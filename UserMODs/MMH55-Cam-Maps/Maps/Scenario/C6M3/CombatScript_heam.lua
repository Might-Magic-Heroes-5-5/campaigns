
while combatStarted() == nil do
	sleep(1);
end;
			
setATB(GetDefenderHero(), 0 );
--SetUnitManaPoints(GetDefenderHero(),333)
sleep(20);

function Start()
	UnitCastGlobalSpell(GetDefenderHero(),21)
end	
