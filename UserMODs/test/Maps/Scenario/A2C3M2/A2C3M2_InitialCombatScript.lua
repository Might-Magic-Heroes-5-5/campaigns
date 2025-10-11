--Combat Script
print("Combat script has been started");
PATH = "Maps/Scenario/A2C3M2/";

isTimeToSummonDeamons = 0;
isDeamonsAlreadySummoned = 0;
	
while combatStarted() == nil do sleep(1); end;
print("Combat is started...");
	
enemyUnitsCount = table.length(GetAttackerCreatures());
enemyUnits = GetAttackerCreatures();
NonSummonedCreaturesCount = 0;
zealotName = "";

EnableAutoFinish( nil );

InitialCreatures = GetDefenderCreatures();
InitialCreaturesCount = table.length( GetDefenderCreatures() );


function GetUnsummonedCreatures()
	CurrentDefenderCreatures = GetDefenderCreatures();
	CurrentCreaturesCount = table.length( GetDefenderCreatures() );
	NonSummonedCreaturesCount = 0;
	for i=0, CurrentCreaturesCount-1 do
		for j=0, InitialCreaturesCount-1 do
			if CurrentDefenderCreatures[i] == InitialCreatures[j] then
				NonSummonedCreaturesCount = NonSummonedCreaturesCount + 1;
				break;
			end;
		end;
		if IsJoinedCreature(CurrentDefenderCreatures[i])==1 then
			NonSummonedCreaturesCount = NonSummonedCreaturesCount + 1;
			break;
		end;
	end;
	return NonSummonedCreaturesCount;
end;

function IsJoinedCreature( creatureName )
	for i=0, enemyUnitsCount-1 do
		if creatureName==enemyUnits[i] then
			return 1;
		end;
	end;
	return 0;
end;

function TimeToSummonDeamons()
	while table.length(GetAttackerCreatures()) == enemyUnitsCount do sleep(1); end;
	isTimeToSummonDeamons = 1;
	print("Enemy hero has lost creature");
end;

function SummonDeamons()
	combatSetPause( 1 );
	SummonCreature( ATTACKER, CREATURE_QUASIT, 50, 1, 1, nil);
	sleep(10);
	SummonCreature( ATTACKER, CREATURE_HORNED_LEAPER, 45, 1, 3, nil );
	sleep(10);
	SummonCreature( ATTACKER, CREATURE_FIREBREATHER_HOUND, 15, 1 ,5, nil );
	sleep(10);
	SummonCreature( ATTACKER, CREATURE_SUCCUBUS_SEDUCER, 10, 1 ,7, nil );
	sleep(10);
	
	attackerCreatures = GetAttackerCreatures();
	for i=0, table.length(attackerCreatures)-1 do
		if  GetCreatureType( attackerCreatures[i] ) ~= CREATURE_QUASIT and
			GetCreatureType( attackerCreatures[i] ) ~= CREATURE_HORNED_LEAPER and
			GetCreatureType( attackerCreatures[i] ) ~= CREATURE_FIREBREATHER_HOUND and
			GetCreatureType( attackerCreatures[i] ) ~= CREATURE_SUCCUBUS_SEDUCER then
				creatureType = GetCreatureType( attackerCreatures[i] );
				creatureNumber = GetCreatureNumber( attackerCreatures[i] );
				creature_x, creature_y = GetUnitPosition( attackerCreatures[i] );
				removeUnit( attackerCreatures[i] );
				AddCreature( DEFENDER, creatureType, creatureNumber, creature_x, creature_y );
		end;
	end;
	sleep(5);
	defenderCreatures = GetDefenderCreatures();
	for i=0, table.length( defenderCreatures )-1 do
		playAnimation( defenderCreatures[i], "happy", ONESHOT );
	end;
	sleep(45);
	combatSetPause( nil );
	MessageBox( PATH.."MsgBox_Combat_InfernoSummoned.txt" );
	startThread( WinIfEnemyLostArmy );
	--EnableAutoFinish( 1 );
	print( "All Red heaven troops were replaced" );
end;


   
function AttackerHeroMove( heroName )
	if isTimeToSummonDeamons==1 and isDeamonsAlreadySummoned==0 then
		isDeamonsAlreadySummoned = 1;
		playAnimation( GetAttackerHero(), "buff", ONESHOT );
		sleep(15);
		startThread( SummonDeamons );
		return not nil;
	else
		return nil;
	end;
end;

function LooseIfZehirLostArmy()
	repeat sleep(1); until GetUnsummonedCreatures() == 0;
	sleep(40);
	Finish( ATTACKER );
end;

function WinIfEnemyLostArmy()
	print("WinIfEnemyLostArmy started");
	repeat sleep(1); until table.length(GetAttackerCreatures()) == 0;
	sleep(40);
	
	CurrenCreatures = GetDefenderCreatures();
	for i=0, table.length( CurrenCreatures )-1 do
		if GetCreatureType( CurrenCreatures[i] )==CREATURE_ZEALOT then
			RemoveCombatUnit( CurrenCreatures[i] );
			break;
		end;
	end;
	
	Finish( DEFENDER );
end;

startThread( LooseIfZehirLostArmy );
startThread( TimeToSummonDeamons );
print("MAIN: Functions started...");