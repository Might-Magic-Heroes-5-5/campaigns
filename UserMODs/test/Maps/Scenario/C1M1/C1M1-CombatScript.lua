once = 0;
ahero = GetAttackerHero();

function Prepare()
print( 'prepare');
SetControlMode( ATTACKER, MODE_AUTO );
end;

function Start()
print( 'start');
SetControlMode( ATTACKER, MODE_MANUAL );
end;

function HeroHint()
	while 1 do
		sleep(1);
		if combatReadyPerson() == ahero then
			print( combatReadyPerson )
			--setATB('hero-attacker', 0 );
			if once == 0 then
				commandDefend( ahero );
				print( ahero,' defended' )
				sleep( 20 );
				once = 1;
			elseif once == 1 then
				print( ahero );
				WaitForTutorialMessageBox();
				TutorialMessageBox( "c1_m1_t11_hero" );
				--once = 2;
			else
				break;
			end;
		end;
	end;
end;

--sleep( 20 );

--print( 'autoplace' );
--SetControlMode( ATTACKER, MODE_AUTO );
--sleep( 1 );
--SetControlMode( ATTACKER, MODE_MANUAL );
--postEvent( 'autoplace_army_force' );

--if GetGameVar( "temp.tutorial" ) == "1" then
	--sleep( 1 );
	--postEvent( 'confirm_placement' );
	
	while combatStarted() == nil do
		sleep(1);
	end;

	--setATB( ahero, 0 );
	startThread( HeroHint );

	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m1_t11_1" );
	WaitForTutorialMessageBox();

	sleep(5);
	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m1_t11_2" );
	WaitForTutorialMessageBox();

	sleep(5);
	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m1_t11_3" );
	WaitForTutorialMessageBox();

	sleep(5);
	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m1_t11_4" );
--end;