SetControlMode( ATTACKER, MODE_MANUAL );

ahero = GetAttackerHero();

if GetGameVar( "temp.C1M1.num_combat", 0 ) == '0' then
	TutorialMessageBox( "c1_m1_t11_new" );
	SetGameVar( "temp.C1M1.num_combat", 1 );
end

while combatStarted() == nil do
	sleep(1);
end

while 1 do
	sleep(1);
	if combatReadyPerson() and (combatReadyPerson() ~= ahero) then
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m1_t11_5" );
		TutorialSetBlink( "defend_blink", 1 );
		WaitForTutorialMessageBox();
		sleep(10);
		TutorialSetBlink( "defend_blink", 0 );
		break;
	end
end
	