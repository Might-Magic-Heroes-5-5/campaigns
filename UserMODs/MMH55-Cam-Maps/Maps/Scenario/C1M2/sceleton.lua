ahero = GetAttackerHero();
if GetGameVar( "temp.tutorial" ) == '1' then

	if GetGameVar("temp.C1M2_archers_hint") == '0' then
    SetGameVar("temp.C1M2_archers_hint", 1 );
		while combatStarted() == nil do
			sleep(20);
		end
		TutorialMessageBox( "c1_m2_t2" );
	end

	sleep(100);
	if GetGameVar("temp.C1M2_perk_hint") == '1' then
		print('hero has perk');
		while 1 do
			sleep(20);
			if combatReadyPerson() == ahero then
				TutorialSetBlink( "cast_spell_blink", 1 );
				WaitForTutorialMessageBox();
				TutorialMessageBox( "c1_m2_heroperk" );
				sleep(50);
				TutorialSetBlink( "cast_spell_blink", 0 );
				SetGameVar("temp.C1M2_perk_hint", 2 );
				break;
			end
		end
	end

end