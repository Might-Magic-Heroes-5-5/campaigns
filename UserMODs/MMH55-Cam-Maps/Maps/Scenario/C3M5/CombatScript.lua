	CreatureList = {CREATURE_PEASANT,
					CREATURE_MILITIAMAN,
					CREATURE_FOOTMAN,
					CREATURE_SWORDSMAN,
					CREATURE_ARCHER,
					CREATURE_MARKSMAN,
					CREATURE_GRIFFIN,
					CREATURE_ROYAL_GRIFFIN,
					CREATURE_PRIEST,
					CREATURE_CLERIC,
					CREATURE_CAVALIER,
					CREATURE_PALADIN,
					CREATURE_ANGEL,
					CREATURE_ARCHANGEL};
	CreatureList.n = 14;
	CreaturesNameForMessage = {  "Peasants","Militiaman",
								   "Footman","Swordsman",
								   "Archers","Marksman",
								   "Griffins","Royal griffins",
								   "Clerics","Priests",
								   "Paladins","Paladins",
								   "Angels","Archangels"};	
	DEFENDER_SIDE = 1;
	if GetGameVar("C3M5_Difficulty") == "heroic" then							
		print("Difficulty level is HEROIC. Godric has new reinforcements.");
		SetGameVar("C3M5_creatures12",GetGameVar("C3M5_creatures12") + 2); -- Paladins
		SetGameVar("C3M5_creatures5",GetGameVar("C3M5_creatures5") + 25); -- Archers
		SetGameVar("C3M5_creatures3",GetGameVar("C3M5_creatures3") + 65); -- Footman
		SetGameVar("C3M5_creatures13",GetGameVar("C3M5_creatures13") + 5); -- Angel
	end;

function PrintGodricsReinforcements()
	for i = 1, 14 do
		print("Godric has ",GetGameVar("C3M5_creatures"..i)," ",CreaturesNameForMessage[i]);
	end;
end;

	
function GodricsReinforcements()
	print("Thread GodricsReinforcements has been started...");	
	repeat
		sleep(10);
		len = table.length(GetDefenderCreatures());
	until len == 0;
	print("Godric does not have any creatures.");
	k = 0;
	for i = 1, 14 do
		if GetGameVar("C3M5_creatures"..i) ~= "0" then
			print("C3M5_creatures"..i.." = ", GetGameVar("C3M5_creatures"..i));
			k = k + 1;
			print("k = ", k);
		end;
	end;
	if k == 0 then
		print("Godric does not have any reinforcements. You won!");
		Finish(ATTACKER);
		return
	else
		print("Godric has reinforcements. Number of reinforcements = ",k);
		j = 0;
		for i = 1, 14 do
			PlacedCreatureQuantity = GetGameVar("C3M5_creatures"..i);
			if PlacedCreatureQuantity ~= "0" and j<=5 then
				if k < 5 then
					AddCreature(DEFENDER, CreatureList[i],PlacedCreatureQuantity,15,3*j);
				else
					AddCreature(DEFENDER, CreatureList[i],PlacedCreatureQuantity,15,2*j);
				end;
				j = j + 1;
			end;
		end;
		sleep(20);
		repeat
			sleep(10);
			GodricsCreatures = GetDefenderCreatures();
		until table.length(GodricsCreatures) == 0;
		Finish(ATTACKER);
	end;
end;

function PlayerLoose()
	repeat 
		sleep(10);
	until table.length(GetAttackerCreatures()) == 0;
	Finish(DEFENDER);	
end;

if GetAttackerHero() ~= nil and GetDefenderHero() ~= nil then
	print("This combat between hero and hero");
	if GetHeroName(GetAttackerHero()) == "Godric" or GetHeroName(GetDefenderHero()) == "Godric" then
		print("Final combat has begun");
		if GetGameVar("C3M5_Difficulty") == "normal" then
			print("Godric has reinforcemets for NORMAL difficulty level");
			SetGameVar("C3M5_creatures12",GetGameVar("C3M5_creatures12") + 2); -- Paladins
			SetGameVar("C3M5_creatures5",GetGameVar("C3M5_creatures5") + 25); -- Archers
			SetGameVar("C3M5_creatures3",GetGameVar("C3M5_creatures3") + 65); -- Footman
			SetGameVar("C3M5_creatures13",GetGameVar("C3M5_creatures13") + 5); -- Angel
		else
			if GetGameVar("C3M5_Difficulty") == "hard" then
				print("Godric has reinforcemets for HARD difficulty level");
				SetGameVar("C3M5_creatures12",GetGameVar("C3M5_creatures12") + 25); -- Paladins
				SetGameVar("C3M5_creatures5",GetGameVar("C3M5_creatures5") + 85); -- Archers
				SetGameVar("C3M5_creatures3",GetGameVar("C3M5_creatures3") + 120); -- Footman
				SetGameVar("C3M5_creatures13",GetGameVar("C3M5_creatures13") + 20); -- Angel
			else
				print("Godric has reinforcemets for HEROIC difficulty level");
			end;	
		end;
		EnableAutoFinish(nil);
		SetControlMode(ATTACKER,MODE_MANUAL);
		while combatStarted() == nil do
			sleep(1)
		end;
		print("Combat has been started...");
		startThread(PlayerLoose);
		startThread(GodricsReinforcements);
	else
		print("It is not final combat");
	end;
end;

---------- DEBUG FUNCTIONS --------------
function AddGodric7Reinf()
	SetGameVar("C3M5_creatures12",2); -- Paladins
	SetGameVar("C3M5_creatures5",25); -- Archers
	SetGameVar("C3M5_creatures11",65); -- Cavalier
	SetGameVar("C3M5_creatures13",5); -- Angel
	SetGameVar("C3M5_creatures7",5); -- Griffin
	SetGameVar("C3M5_creatures14",5); -- ArchAngel
	SetGameVar("C3M5_creatures8",5); -- Royal Griffin
	PrintGodricsReinforcements()
end;

function AddGodric6Reinf()
	SetGameVar("C3M5_creatures12",2); -- Paladins
	SetGameVar("C3M5_creatures5",25); -- Archers
	SetGameVar("C3M5_creatures13",5); -- Angel
	SetGameVar("C3M5_creatures7",5); -- Griffin
	SetGameVar("C3M5_creatures14",5); -- ArchAngel
	SetGameVar("C3M5_creatures8",5); -- Royal Griffin
	PrintGodricsReinforcements()
end;

function AddGodric4Reinf()
	SetGameVar("C3M5_creatures12",2); -- Paladins
	SetGameVar("C3M5_creatures5",25); -- Archers
	SetGameVar("C3M5_creatures13",5); -- Angel
	SetGameVar("C3M5_creatures7",5); -- Griffin
	PrintGodricsReinforcements()
end;

PrintGodricsReinforcements()