print("Combat script started...");

while combatStarted() == nil do
	sleep(1)
end;
print("combat is started...");

EnableAutoFinish( nil );


function PlayerWin()
	repeat sleep(1); until table.length(GetDefenderCreatures())==0;
	
	playAnimation( GetDefenderHero(), "stir02", ONESHOT_STILL );
	sleep(40);
	Finish( ATTACKER );
end;

function EnemyWin()
	repeat sleep(1); until table.length(GetAttackerCreatures())==0;
	Finish( DEFENDER );
end;



--function GiveTurnToEnemyHero()
--	repeat sleep(1); until table.length(GetDefenderCreatures())==0;
--	setATB( GetDefenderHero(), 1.25 );
--end;

--function DefenderHeroMove()
--	print("Defender hero move");
--	if GetHeroName( GetDefenderHero() )=="Orlando" then
--		if table.length(GetDefenderCreatures()) < 2 then
--			print( "Enemy hero has one or less than one creatures. It is time to escape!" );
--			playAnimation( GetDefenderHero(), "stir02", ONESHOT_STILL );
--			sleep(40);
--			Finish( ATTACKER );
--			return not nil;
--		end;
--	end;
--	return nil;
--end;

--startThread( GiveTurnToEnemyHero );
startThread( PlayerWin );
startThread( EnemyWin );