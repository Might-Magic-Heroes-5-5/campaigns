StartAdvMapDialog( 0 );

--SetObjectiveState( "obj1", OBJECTIVE_ACTIVE );
--SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
--SetObjectiveState( "obj3", OBJECTIVE_ACTIVE );
PlayerHero = "KingTolghar"
H55_PlayerStatus = {0,2,1,2,1,2,2,2};

--
function objective2()
	while 1 do
		if GetObjectOwner( "capital" ) == PLAYER_1 then
			SetObjectiveState( "obj2", OBJECTIVE_COMPLETED );
			startThread (re_objective2);
			break;
		end;
	sleep( 3 );
	end;
end;

function re_objective2()
	while 1 do
		if GetObjectOwner( "capital" ) ~= PLAYER_1 then
			SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
			startThread( objective2 );
			break;
		end;
	sleep( 2 );
	end;
end;

function objective3()
	while 1 do 
		if IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState("obj3", OBJECTIVE_FAILED);
			sleep( 3 );
			Loose();
		end;
	sleep( 3 );
	end;
end;	

Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, "obj1", "wincheck");
Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, "obj2", "wincheck");

function wincheck()
	if GetObjectiveState( "obj1" ) == OBJECTIVE_COMPLETED and GetObjectiveState( "obj2" ) == OBJECTIVE_COMPLETED then
		CreateMonster( "fake", CREATURE_BEAR_RIDER, 1, 85, 92, 1, 0, 0, 270 );
		SetObjectPosition( PlayerHero, 80, 92, 1 );
		SetObjectRotation( PlayerHero, 90);
		sleep( 5 );
		StartAdvMapDialog( 1, "DoWin" );
	end;
end;

function DoWin()
  SetObjectiveState( "obj3", OBJECTIVE_COMPLETED );
  Win();
end;

startThread( objective2 );
startThread( objective3 );