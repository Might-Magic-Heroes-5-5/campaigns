
print("Start_A1SM1.....by Dmitry_B.");
StartDialogScene( "/DialogScenes/A1Single/SM1/S1/DialogScene.xdb#xpointer(/DialogScene)" );

-------------------------------------------Easy_Mod

function Diff_easy()
	slozhnost = GetDifficulty(); 
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) and slozhnost == DIFFICULTY_EASY then 
		print("Closed"); 
		SetRegionBlocked("bl1", 1, PLAYER_2);
		SetRegionBlocked("bl2", 1, PLAYER_2);
		SetRegionBlocked("bl3", 1, PLAYER_2);
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) and slozhnost == DIFFICULTY_EASY then 
		print("Open_all");
		SetRegionBlocked("bl1", nil, PLAYER_2);
		SetRegionBlocked("bl2", nil, PLAYER_2);
		SetRegionBlocked("bl3", nil, PLAYER_2);
	end;
	print('difficulty = ',slozhnost);
end;

---------------------------------Герои погибают

function DoWin()
  Win();
end;


---------------------------------Герои погибают

function Objective2_defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Giovanni") == nil or IsHeroAlive("Ornella") == nil then
			SetObjectiveState('prim2',OBJECTIVE_FAILED);
			sleep(15);
			Loose();
			break;
		end;
	end;
end;


-----------------------------------Победа

function Towns()
	while 1 do
		if (GetObjectOwner("Town1") == PLAYER_1) and (GetObjectOwner("Town2") == PLAYER_1) and (GetObjectOwner("Town3") == PLAYER_1)then
			sleep(10);
			SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
			sleep(5);			
			SetObjectPosition( "Giovanni", 67, 118, 0 );
			SetObjectPosition( "Ornella", 71, 118, 0 );
			sleep( 5 );
			StartAdvMapDialog( 0, "DoWin" );
--			StartAdvMapDialog( 1, "DoWin" );
			return
		end;
		sleep();
	end;
end;

-------------------------------////MAIN
startThread( Diff_easy );
 
startThread( Objective2_defead );
startThread( Towns );