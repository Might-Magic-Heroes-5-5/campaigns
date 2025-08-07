function AttackerCreatureDeath( name )
	if GetCreatureType( name ) ~= CREATURE_ARCHANGEL then
		dead = 1;
	end
end

function GetCreatureType2( name )
	type = 0;
	if name then
		if IsCreature( name ) then
			type = GetCreatureType( name );
		end
	end
	return type;
end

ahero = GetAttackerHero();
dead = 0;

if GetGameVar("temp.tutorial", 0) == "1" then
	SetGameVar("temp.CombatCount", GetGameVar("temp.CombatCount", 0) + 1 );
	while combatStarted() == nil do
			sleep(1);
	end
	if GetGameVar("temp.CombatCount", 0) == "1" then
		TutorialMessageBox( "c1_m4_t13" );
	end
	
	if GetGameVar("temp.CombatCount", 0) ~= "1" and GetGameVar("temp.SpellLearned", 0) == "1" then
		while combatReadyPerson() ~= ahero do
			sleep(1);
		end
		TutorialMessageBox( "c1_m4_t5" );
		TutorialSetBlink( "cast_spell_blink", 1 );
		WaitForTutorialMessageBox();
		sleep(20);
		TutorialSetBlink( "cast_spell_blink", 0 );
		SetGameVar("temp.SpellLearned", 2 );
		TutorialActivateHint( "spell_book_hint" );
  end
  
	if GetGameVar( "temp.ArhangelsCaptured" ) == "1" then
		while (GetCreatureType2( combatReadyPerson() ) ~= CREATURE_ARCHANGEL) or (dead == 0) do
			sleep(1);
		end
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m4_t14" );
		SetGameVar( "temp.ArhangelsCaptured", 2 );
	end
end
