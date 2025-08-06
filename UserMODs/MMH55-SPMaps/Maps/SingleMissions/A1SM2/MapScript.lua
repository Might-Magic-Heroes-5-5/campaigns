StartDialogScene( "/DialogScenes/A1Single/SM2/S1/DialogScene.xdb#xpointer(/DialogScene)" );

DenyAIHeroesFlee( PLAYER_2, 1, "Almegir" );

PlayerHero1 = "Heam"
--StartAdvMapDialog( 0 );
----------------------------------\\\\\

function DoWin()
  SetObjectiveState( "Prim2", OBJECTIVE_COMPLETED );
  Win();
end;

function Objective1_enemy()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Almegir") == nil then
			sleep(10);
			SetObjectiveState( "Prim1", OBJECTIVE_COMPLETED );
			break;
		end;
	end;
end;

function Towns()  
	while 1 do
		sleep(10);
		if (GetObjectOwner("Air") == PLAYER_1) and (GetObjectOwner("Fire") == PLAYER_1) and (GetObjectOwner("Water") == PLAYER_1) and (GetObjectOwner("Earth") == PLAYER_1) and (GetObjectOwner("Final") == PLAYER_1) and (GetObjectOwner("First") == PLAYER_1) then
			sleep(10);
			SetObjectiveState( "Prim3", OBJECTIVE_COMPLETED );
			break;
		end;
	end;
end;

function Winner()  
	while 1 do
		sleep(10);
		if GetObjectiveState("Prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("Prim3") == OBJECTIVE_COMPLETED then
			sleep(2);
			SetObjectPosition( "Heam", 80, 76, 1 );
			CreateMonster( "fake", CREATURE_WAR_DANCER, 1, 84, 76, 1, 0, 0 );
			StartAdvMapDialog( 0, "DoWin" );
			break;
		end;
	end;
end;


Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" ); --- триггер на потерю героя игроком
function LostHero( HeroName )
	if HeroName == PlayerHero1 then
		SetObjectiveState("Prim2", OBJECTIVE_FAILED);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		sleep (8);
		Loose();
	end;
end;


-------------------------------//////MAIN

 
startThread( Objective1_enemy );
startThread( Towns );
startThread( Winner );