ahero = GetAttackerHero();

function Prepare()
  print( 'prepare');
  SetControlMode( ATTACKER, MODE_AUTO );
end
once = 0;
function Start()
  print( 'start');
  SetControlMode( ATTACKER, MODE_MANUAL );
end

function HeroHint()
	while 1 do
		sleep(1);
		if combatReadyPerson() == ahero then
			print( combatReadyPerson )
			if once == 0 then
				commandDefend( ahero );
				print( ahero,' defended' )
				sleep( 20 );
				once = 1;
			elseif once == 1 then
				print( ahero );
				WaitForTutorialMessageBox();
				TutorialMessageBox( "c1_m1_t11_hero" );
				break;
			end
		end
	end
end

	while combatStarted() == nil do
		sleep(1);
	end

	--setATB( ahero, 0 );
	startThread( HeroHint );

	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m1_t11_1" );
	WaitForTutorialMessageBox();
	