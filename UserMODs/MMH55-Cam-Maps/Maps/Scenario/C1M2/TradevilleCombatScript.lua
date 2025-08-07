if GetGameVar( "temp.tutorial", 0 ) == '1' then

	sleep(20);
	TutorialMessageBox( "c1_m2_t12" ); -- flying units
	WaitForTutorialMessageBox();
	while combatStarted() == nil do
		sleep(1);
	end

	WaitForTutorialMessageBox();
	TutorialMessageBox( "c1_m2_t13" ); -- siege of a fortress

	if GetGameVar("temp.C1M2_perk_hint", 0) == '1' then
		SetGameVar("temp.C1M2_perk_hint", 2 );
		while 1 do
			sleep(1);
			if combatReadyPerson() == 'hero-attacker' then
				--setATB('hero-attacker', 0 );
				WaitForTutorialMessageBox();
				TutorialMessageBox( "c1_m2_heroperk" );
				TutorialSetBlink( "cast_spell_blink", 1 );
				WaitForTutorialMessageBox();
				TutorialSetBlink( "cast_spell_blink", 0 );
				break;
			end
		end
	end
end