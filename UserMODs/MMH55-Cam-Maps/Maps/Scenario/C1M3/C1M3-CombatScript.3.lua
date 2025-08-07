hired_at_this_visit = 0;

function WaitForTutorialMessageBox()
	while IsTutorialMessageBoxOpen() do
		sleep(1);
	end
end

function HeroHired()
  if ( GetGameVar( "temp.tutorial", 0 ) == '1' ) then
  	if ( GetGameVar( 'temp.hero_visiting' ) == '1' ) or ( hired_at_this_visit == 1 ) then
  		WaitForTutorialMessageBox();
  		TutorialMessageBox( "c1_m3_herohired" ); -- hero hired
  	end
	  hired_at_this_visit = 1;
  end
end

if GetGameVar("temp.tutorial", 0) == "1" then
	SetGameVar("temp.C1M3_Tradeville", GetGameVar("temp.C1M3_Tradeville", 0) + 1 );
	if GetGameVar("temp.C1M3_Tradeville", 0) == "1" then
		TutorialMessageBox("c1_m3_t3");
	elseif GetGameVar("temp.C1M3_Tradeville", 0) == "2" then
		TutorialMessageBox("c1_m3_t4");
	elseif GetGameVar("temp.C1M3_Tradeville", 0) == "3" then
		TutorialMessageBox("c1_m3_t5");
	elseif GetGameVar("temp.C1M3_Tradeville", 0) == "4" then
		TutorialMessageBox("c1_m3_t9_1");
	elseif GetGameVar("temp.C1M3_Tradeville", 0) == "5" then
		TutorialMessageBox( "c1_m4_t11" ); -- hire heroes
	end
end
