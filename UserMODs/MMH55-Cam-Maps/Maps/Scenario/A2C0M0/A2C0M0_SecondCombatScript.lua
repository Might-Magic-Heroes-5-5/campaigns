print("Second Combat script started...");
isTutorialMessageShowed = 0;

while combatStarted() == nil do
	sleep(1)
end;
print("combat is started...");

function AttackerCreatureMove( creatureName )
	if GetCreatureType( creatureName )==CREATURE_CENTAUR then
		if isTutorialMessageShowed == 0 then
			isTutorialMessageShowed = 1;
			TutorialMessageBox( "Is_CentaursAttacks" );
		end;
	end;
	return nil;
end;