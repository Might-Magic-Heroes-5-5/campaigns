
function WaitForTutorialMessageBox()
	while IsTutorialMessageBoxOpen() do
		sleep(1);
	end
end

function CreatureHired()
	if GetGameVar( "temp.tutorial" ) == '1' and  GetGameVar( 'temp.creaturehired' ) == '0' then
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m2_creaturehired" ); -- creatures
		SetGameVar( 'temp.creaturehired', 1 );
	end
end

if GetGameVar( "temp.tutorial" ) == '1' then
	SetGameVar("temp.C1M2_CountVisitToTown", GetGameVar("temp.C1M2_CountVisitToTown") + 1 );
	if GetGameVar("temp.C1M2_CountVisitToTown" ) == "1" then
		TutorialSetBlink( "build_blink", 1 );
		WaitForTutorialMessageBox()
		TutorialMessageBox( "c1_m2_t6_1" ); -- prerequisites1
		sleep(20);
		TutorialSetBlink( "build_blink", 0 );
	elseif GetGameVar("temp.C1M2_CountVisitToTown") == "2" then
		TutorialMessageBox( "c1_m2_t6_3" ); --type buildings
	end
end