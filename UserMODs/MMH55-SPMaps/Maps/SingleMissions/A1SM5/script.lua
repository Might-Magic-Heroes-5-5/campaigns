doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};
A1SM5_LIGHTS = {
	["tele1"] = "a1sm5_1",
	["tele2"] = "a1sm5_2",
	["tele3"] = "a1sm5_3",
}

function ChangeLight( hero, object )
	sleep(30);
	SetAmbientLight( 0, A1SM5_LIGHTS[object] );
end

function MeetMarkal()
	sleep( 10 );
	StartDialogScene( "/DialogScenes/A1Single/SM5/S2/DialogScene.xdb#xpointer(/DialogScene)", "AttackZehir" );
end;

function AttackZehir()
	BlockGame();
	MoveCamera( 67, 69, 1, 40, 1.0, 0, 0, 0 );
	sleep( 40 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/AnimateDead.xdb#xpointer(/Effect)", "", "", 67.5, 75.5, 0, 0, 1 );
	sleep( 17 );
	DeployReserveHero( "Berein", 67, 75, 1 );
	repeat sleep( 10 ) until IsHeroAlive( "Berein" ) ~= nil;	
	local weeks = GetDate( WEEK ) + ( GetDate( MONTH ) - 1 ) * 4;
	local army_coeff = 0.2 + 0.2 * GetDifficulty();
	AddHeroCreatures( "Berein", CREATURE_SKELETON_ARCHER, 23 + army_coeff * 35 * weeks );
	AddHeroCreatures( "Berein", CREATURE_ZOMBIE, 17 + army_coeff * 15 * weeks );
	AddHeroCreatures( "Berein", CREATURE_GHOST, 12 + army_coeff * 9 * weeks );
	AddHeroCreatures( "Berein", CREATURE_VAMPIRE_LORD, 8 + army_coeff * 6 * weeks );
	AddHeroCreatures( "Berein", CREATURE_DEMILICH, 5 + army_coeff * 3 * weeks );
	AddHeroCreatures( "Berein", CREATURE_WRAITH, 3 + army_coeff * 2 * weeks );
	AddHeroCreatures( "Berein", CREATURE_SHADOW_DRAGON, 1 + army_coeff * 1 * weeks );
	sleep( 100 );
	MoveHeroRealTime( "Berein", GetObjectPosition( "Zehir" ) );
	sleep( 50 );
	UnblockGame();
	repeat sleep( 10 ) until IsHeroAlive( "Berein" ) == nil;
	Win( PLAYER_1 );
end

StartDialogScene( "/DialogScenes/A1Single/SM5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
Trigger( OBJECT_TOUCH_TRIGGER, "tele1", "ChangeLight" );
Trigger( OBJECT_TOUCH_TRIGGER, "tele2", "ChangeLight" );
Trigger( OBJECT_TOUCH_TRIGGER, "tele3", "ChangeLight" );
Trigger( OBJECT_TOUCH_TRIGGER, "tele4", "MeetMarkal" );
SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 0);

function a1sm5_dbg( var )
	if var == 1 then
		MakeHeroInteractWithObject("Zehir", "tele1");
	elseif var == 11 then
		MakeHeroInteractWithObject("Zehir", "tele2");
	elseif var == 111 then
		MakeHeroInteractWithObject("Zehir", "tele3");
	elseif var == 2 then
		H55_Speedrun(1);
		SetObjectPosition("Zehir", 67, 65, 0);
	end
end