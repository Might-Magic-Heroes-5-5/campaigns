ahero = GetAttackerHero();

if GetGameVar( "temp.tutorial", 0 ) == '1' then

	if GetGameVar("temp.C1M2_archers_hint", 0) == '0' then
    SetGameVar("temp.C1M2_archers_hint", 1 );
		while combatStarted() == nil do
			sleep(1);
		end
		TutorialMessageBox( "c1_m2_t2" );
	end

	if GetGameVar("temp.C1M2_perk_hint", 0) == '1' then
		print('hero has perk');
		while 1 do
			sleep(1);
			if combatReadyPerson() == ahero then
				WaitForTutorialMessageBox();
				TutorialMessageBox( "c1_m2_heroperk" );
				TutorialSetBlink( "cast_spell_blink", 1 );
				WaitForTutorialMessageBox();
				TutorialSetBlink( "cast_spell_blink", 0 );
  			SetGameVar("temp.C1M2_perk_hint", 2 );
				break;
			end
		end
	end

end