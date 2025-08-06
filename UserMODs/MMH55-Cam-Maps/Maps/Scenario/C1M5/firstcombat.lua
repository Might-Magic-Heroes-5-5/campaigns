--if GetGameVar("temp.tutorial") == "1" then
	while combatStarted() == nil do
		sleep(1);
	end;

	SetGameVar("temp.C1M5_firstcombat", 0);
	TutorialMessageBox( 'c1_m5_wait' );
--end;
