if GetGameVar("temp.tutorial", 0) == "1" then
	SetGameVar("temp.CountVisitToTown", GetGameVar("temp.CountVisitToTown", 0) + 1 );
	if GetGameVar("temp.CountVisitToTown", 0) == "1" then 
		TutorialMessageBox( "c1_m4_t10" );
	elseif GetGameVar("temp.CountVisitToTown", 0) == "2" then
		TutorialMessageBox( "c1_m4_t12" );
	end
end
