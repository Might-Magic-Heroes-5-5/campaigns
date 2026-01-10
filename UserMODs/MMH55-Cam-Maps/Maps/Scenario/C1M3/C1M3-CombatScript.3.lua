function WaitForTutorialMessageBox()
	while IsTutorialMessageBoxOpen() do
		sleep(1);
	end
end

if GetGameVar("temp.tutorial") == "1" then
	SetGameVar("temp.C1M3_Tradeville", GetGameVar("temp.C1M3_Tradeville") + 1 );
	if GetGameVar("temp.C1M3_Tradeville") == "2" then
		TutorialMessageBox("c1_m3_t3");
	elseif GetGameVar("temp.C1M3_Tradeville") == "4" then
		TutorialMessageBox("c1_m3_t4");
	elseif GetGameVar("temp.C1M3_Tradeville") == "6" then
		TutorialMessageBox("c1_m3_t9_1");
	end
end
