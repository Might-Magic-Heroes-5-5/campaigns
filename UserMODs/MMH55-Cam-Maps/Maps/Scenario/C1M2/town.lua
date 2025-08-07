
function WaitForTutorialMessageBox()
	while IsTutorialMessageBoxOpen() do
		sleep(1);
	end
end

function CreatureHired()
	if GetGameVar( "temp.tutorial", 0 ) == '1' then
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m2_creaturehired" ); -- creatures
		SetGameVar( 'temp.creaturehired', 1 );
	end
end

if GetGameVar( "temp.tutorial", 0 ) == '1' then

	SetGameVar("temp.C1M2_CountVisitToTown", GetGameVar("temp.C1M2_CountVisitToTown", 0) + 1 );
	if GetGameVar("temp.C1M2_CountVisitToTown", 0) == "1" then
		TutorialMessageBox( "c1_m2_t6_1" ); -- prerequisites1
		TutorialSetBlink( "build_blink", 1 );
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m2_t6_2" ); -- prerequisites2
		WaitForTutorialMessageBox();
		TutorialSetBlink( "build_blink", 0 );
	elseif ( GetGameVar("temp.C1M2_CountVisitToTown", 0) == "2") and (GetGameVar( 'temp.creaturehired' ) ~= '1' ) then
		TutorialMessageBox( "c1_m2_t6_4" ); -- hire creatures
	elseif GetGameVar("temp.C1M2_CountVisitToTown", 0) == "3" then
		TutorialMessageBox( "c1_m2_t6_3" ); --type buildings
	end
end