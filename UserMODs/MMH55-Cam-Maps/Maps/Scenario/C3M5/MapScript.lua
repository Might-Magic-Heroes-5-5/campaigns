doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55c_AI_CONTROLLED = {
  player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
	   heroes = {},
	  enemies = {},
  },
  player2 = { 		   -- Blue Haven AI player with only one hero (Godric).
      state = 1,       -- Managed by scripts, Godric do nothing so control set to 1.
	   heroes = {},
	  enemies = {},
  },
  player3 = { 		   -- Orange Academy Inferno AI player
      state = 2,       -- AI player with specific purpose so control set to 2.
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.1, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
    }
  }
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M5");
    LoadHeroAllSetArtifacts("Berein", "C3M4" );
	GiveArtefact("Berein",ARTIFACT_RING_OF_DEATH);
end

startThread(H55_InitSetArtifacts);
H55_PlayerStatus = {0,1,1,2,2,2,2,2};
H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

CreatureList = {
		 CREATURE_PEASANT,	  CREATURE_MILITIAMAN,       CREATURE_LANDLORD,
		 CREATURE_FOOTMAN,     CREATURE_SWORDSMAN,     CREATURE_VINDICATOR,
		  CREATURE_ARCHER,      CREATURE_MARKSMAN,     CREATURE_LONGBOWMAN,
		 CREATURE_GRIFFIN, CREATURE_ROYAL_GRIFFIN, CREATURE_BATTLE_GRIFFIN,
		  CREATURE_PRIEST,        CREATURE_CLERIC,         CREATURE_ZEALOT,
		CREATURE_CAVALIER,       CREATURE_PALADIN,       CREATURE_CHAMPION,
		   CREATURE_ANGEL,	   CREATURE_ARCHANGEL,	       CREATURE_SERAPH
};
CreatureList.n = 21;

CreaturesNameForMessage = {
 "Peasants",     "Militiaman",        "Landlord",
  "Footman",      "Swordsman",      "Vindicator",
  "Archers",       "Marksman",      "Arbaletist",
 "Griffins", "Royal griffins", "Battle Griffins",
  "Clerics",        "Priests",         "Zealots",
"Cavaliers",       "Paladins",       "Champions",
   "Angels",     "Archangels",         "Seraphs"
 };
		   
CreatureNameFromTextFiles = { "Peasants", "Footman",  "Archers", "Griffins", "Clerics", "Paladins", "Angels" };
		 
CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C3/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	armyDeserters = function()
		StartDialogScene("/DialogScenes/C3/M5/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	captureDaughter = function()
		StartDialogScene("/DialogScenes/C3/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	ambushByAngels = function()
		StartDialogScene("/DialogScenes/C3/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	getAngelWings = function()
		StartDialogScene("/DialogScenes/C3/M5/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	outro = function()
		StartDialogScene("/DialogScenes/C3/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	showCapturedfMine = function(mine)
		x, y, z = GetObjectPosition(mine);
		MoveCamera( x, y, z, 40, 0.925, 0.279 );
		MessageBox("/Maps/Scenario/C3M5/CaptureCavernMessage.txt");
    end,
}
    
DIFFICULTY = {
	[0] = function()
		SetGameVar("C3M5_Difficulty","normal");
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,30);
		AddHeroCreatures("Berein",CREATURE_MANES,8);
		SetPlayerStartResource(1,WOOD,20);
		SetPlayerStartResource(1,ORE,20);
		SetPlayerStartResource(1,SULFUR,5);
		SetPlayerStartResource(1,MERCURY,5);
		SetPlayerStartResource(1,CRYSTAL,5);
		SetPlayerStartResource(1,GEM,5);
		SetPlayerStartResource(1,GOLD,30000);
		print("Difficulty level is easy");
	end,
	
	[1] = function()
		SetGameVar("C3M5_Difficulty","hard");
		SetPlayerStartResource(1,WOOD,16);
		SetPlayerStartResource(1,ORE,15);
		SetPlayerStartResource(1,SULFUR,3);
		SetPlayerStartResource(1,MERCURY,3);
		SetPlayerStartResource(1,CRYSTAL,3);
		SetPlayerStartResource(1,GEM,3);
		SetPlayerStartResource(1,GOLD,25000);
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,15);
		AddHeroCreatures("Berein",CREATURE_MANES,5);
		print("Difficulty level is normal");
	end,
	
	[2] = function()
		SetGameVar("C3M5_Difficulty","heroic");
		SetPlayerStartResource(1,WOOD,12);
		SetPlayerStartResource(1,ORE,10);
		SetPlayerStartResource(1,SULFUR,1);
		SetPlayerStartResource(1,MERCURY,1);
		SetPlayerStartResource(1,CRYSTAL,1);
		SetPlayerStartResource(1,GEM,1);
		SetPlayerStartResource(1,GOLD,20000);
		print("Difficulty level is hard");
	end,
	
	[3] = function()
		SetGameVar("C3M5_Difficulty","impossible");
		SetPlayerStartResource(1,WOOD,10);
		SetPlayerStartResource(1,ORE,8);
		SetPlayerStartResource(1,SULFUR,1);
		SetPlayerStartResource(1,MERCURY,1);
		SetPlayerStartResource(1,CRYSTAL,1);
		SetPlayerStartResource(1,GEM,1);
		SetPlayerStartResource(1,GOLD,15000);
		print("Difficulty level is heroic");
		START_TIME_PRESSING_MONTH = 4;
	end,
}

OBJECTIVES = {
	state = {
		defeatGodric        = { "prim1", 1 }, -- Defeat Godric
		captureDaughter     = { "prim2", 1 }, -- Markal to capture Godric's daughter Freyda
		getFreydaToTown     = { "prim3", 0 }, -- Markal to bring Freyda to Lorekeep
		captureHikm         = { "prim4", 0 }, -- Capture Hikm town
		isAlive             = { "prim5", 1 }, -- Markal and Isabell must survive
		timePressure        = {  "TimePressing", 1 }, -- Complete the mission in one month.
		deployAcademyHeroes = {  "deployAcademyHeroes", 1 }, -- Complete the mission in one month.
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		START_TIME_PRESSING_MONTH = 2;
		factor = 3;
		EnableHeroAI('Godric', nil );
		SetObjectEnabled("prison",nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "teleport", "TeleportUse");
		for i = 1,21 do
			SetGameVar("C3M5_creatures"..i,0);
		end
		Save("GodricsChoice");
		CINEMATICS.intro();
		MoveHeroRealTime("Godric", 47,30,GROUND);
		H55_CamFixTooManySkills(PLAYER_1,"Berein");
		H55_CamFixTooManySkills(PLAYER_1,"Isabell");
		H55_CamFixTooManySkills(PLAYER_2,"Godric");
		startThread(DIFFICULTY[GetDifficulty()]);
		startThread(IsabellLostArmy);
		startThread(desentir);
		startThread(CaptureCavern);		
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			if GetObjectiveState("prim5") == OBJECTIVE_FAILED or GetObjectiveState("TimePressing") == OBJECTIVE_FAILED then
				Loose();
			end
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Isabell", "C3M5");
				sleep(20);
				CINEMATICS.outro();
				sleep(50);
				Win();
				return
			end
		end
	end,
	
	defeatGodric = function()
	-- start of this task is handled by C3M5.xdb
		if IsHeroAlive("Godric") == nil then
			SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.defeatGodric[2] = 10;
		end
	end,
	
	captureDaughter = function()
		if OBJECTIVES.state.captureDaughter[2] == 1 then
			Trigger(OBJECT_TOUCH_TRIGGER, "prison", "PlayerTouchPrison");
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureDaughter[2] = 2;
		elseif OBJECTIVES.state.captureDaughter[2] == 2 then
			-- Wait	for Markal to touch Freyda's prison
		elseif OBJECTIVES.state.captureDaughter[2] == 3 then
			CINEMATICS.captureDaughter();
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			GiveArtefact("Berein",72,1); -- Artifact Freida
			OBJECTIVES.state.getFreydaToTown[2] = 1;
			OBJECTIVES.state.captureDaughter[2] = 10;
		end
	end,
	
	getFreydaToTown = function()
		if OBJECTIVES.state.getFreydaToTown[2] == 1 then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Angels", "BeforeBattleVS_Angels");
			SetObjectiveState("prim3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.getFreydaToTown[2] = 2;
		elseif OBJECTIVES.state.getFreydaToTown[2] == 2 then
			-- Wait	for Markal to enter the trap
		elseif OBJECTIVES.state.getFreydaToTown[2] == 3 then
			CINEMATICS.ambushByAngels();
			OBJECTIVES.state.getFreydaToTown[2] = 4;
			BATTLES.ambushByAngels.start();
		elseif OBJECTIVES.state.getFreydaToTown[2] == 4 then
			-- Wait	for the ambush to finish
		elseif OBJECTIVES.state.getFreydaToTown[2] == 5 then
			CINEMATICS.getAngelWings();
			SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
			GiveArtefact('Berein', ARTIFACT_ANGEL_WINGS, 1);
			sleep(10);
			RemoveArtefact("Berein",72); --Artifact Freida
			OBJECTIVES.state.captureHikm[2] = 1;
			OBJECTIVES.state.getFreydaToTown[2] = 10;
		end
	end,
	
	captureHikm = function()
		if OBJECTIVES.state.captureHikm[2] == 1 then
			SetObjectiveState('prim4', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureHikm[2] = 2;
		elseif OBJECTIVES.state.captureHikm[2] == 2 and GetObjectOwner("Hikm") == PLAYER_1 then
			SetObjectiveState('prim4', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureHikm[2] = 10;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by C3M5.xdb
		if (IsHeroAlive("Isabell") == nil or IsHeroAlive("Berein") == nil) then
			SetObjectiveState("prim5", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
		if OBJECTIVES.state.defeatGodric[2] == 10 and OBJECTIVES.state.captureHikm[2] == 10 then
			SetObjectiveState("prim5", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	timePressure_current = nil,
	timePressure_week_message = 4,
	timePressure_day_message = 6,
	timePressure = function()
		if OBJECTIVES.state.timePressure[2] == 1 and GetDate(MONTH) >= START_TIME_PRESSING_MONTH then
			SetObjectiveState("TimePressing", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.timePressure[2] = 2;
		elseif OBJECTIVES.state.timePressure[2] == 2 and OBJECTIVES.timePressure_current ~= GetDate(WEEK) then
			if OBJECTIVES.timePressure_week_message == 4 then
				MessageBox("/Maps/Scenario/C3M5/4WeekBeforeLoose.txt");
			else
				MessageBox("/Maps/Scenario/C3M5/"..OBJECTIVES.timePressure_week_message.."WeeksBeforeLoose.txt");
			end
			if OBJECTIVES.timePressure_week_message ~= 2 then 
				OBJECTIVES.timePressure_week_message = OBJECTIVES.timePressure_week_message - 1;
			else
				OBJECTIVES.state.timePressure[2] = 3;
			end
			OBJECTIVES.timePressure_current = GetDate(WEEK);
		elseif OBJECTIVES.state.timePressure[2] == 3 and OBJECTIVES.timePressure_current ~= GetDate(WEEK) then
			MessageBox("/Maps/Scenario/C3M5/7DaysBeforeLoose.txt");
			OBJECTIVES.timePressure_current = GetDate(DAY_OF_WEEK);
			OBJECTIVES.state.timePressure[2] = 4;
		elseif OBJECTIVES.state.timePressure[2] == 4 and OBJECTIVES.timePressure_current ~= GetDate(DAY_OF_WEEK) then
			if OBJECTIVES.timePressure_day_message ~= 0 then 
				MessageBox("Maps/Scenario/C3M5/"..OBJECTIVES.timePressure_day_message.."DaysBeforeLoose.txt");
				OBJECTIVES.timePressure_day_message = OBJECTIVES.timePressure_day_message - 1;
			else
				SetObjectiveState("TimePressing", OBJECTIVE_FAILED);
				OBJECTIVES.state.timePressure[2] = 11;
			end
			OBJECTIVES.timePressure_current = GetDate(DAY_OF_WEEK);
		end
		
		if OBJECTIVES.state.defeatGodric[2] == 10 and OBJECTIVES.state.captureHikm[2] == 10 then
			if GetObjectiveState("TimePressing") == OBJECTIVE_ACTIVE then
				SetObjectiveState("TimePressing", OBJECTIVE_COMPLETED);
			end
			OBJECTIVES.state.timePressure[2] = 10;
		end
	end,
	
	deployAcademyHeroes = function()
		if OBJECTIVES.state.deployAcademyHeroes[2] == 1 and GetDate(WEEK) == 2 then
			DeployReserveHero("Razzak",24,90,0);
			sleep(2);
			SetAIPlayerAttractor("Newpost",PLAYER_3,2);
			H55c_AIAddHero('Razzak');
			startThread(RazzakIsDead);
			OBJECTIVES.state.deployAcademyHeroes[2] = 2;
		elseif OBJECTIVES.state.deployAcademyHeroes[2] == 2 and OBJECTIVES.state.captureDaughter[2] == 10 then
			DeployReserveHero("Maahir",88,20,0);
			sleep(2);
			SetAIPlayerAttractor("Necorrum",PLAYER_3,2); -- Necorrum is Lorekeep
			H55c_AIAddHero('Maahir');
			OBJECTIVES.state.deployAcademyHeroes[2] = 10;
		end
	end
}

function BeforeBattleVS_Angels(heroname)
	if heroname == 'Berein' then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Angels", nil);
		OBJECTIVES.state.getFreydaToTown[2] = 3;
	end
end

BATTLES = {
  ambushByAngels = {
    start = function(hero)
      StartCombat("Berein",nil,4,CREATURE_ARCHANGEL,4,CREATURE_ANGEL,5,CREATURE_ANGEL,5,CREATURE_ARCHANGEL,4,nil,"BATTLES.ambushByAngels.finish");
    end,

    finish = function(hero, result)
      	if result ~= nil then
			OBJECTIVES.state.getFreydaToTown[2] = 5;
		end
    end,
  }
}

function RazzakIsDead()
	print("Thread RazzakIsDead has been started...");
	repeat
		sleep(10);
	until IsHeroAlive("Razzak") == nil;
	print("Razzak is dead");	
	factor = 2;
	CurrentWeek = GetDate(WEEK);
	repeat
		sleep(10);
	until GetDate(WEEK) == CurrentWeek + 2;
	factor = 1;
	print("factor = 1");
end;

function IsabellLostArmy()
	while 1 do
		sleep(5);
		if GetDate(DAY) == 2 and GetDate(WEEK) == 1 then
			print("Isabell has lost angels");
			CINEMATICS.armyDeserters();
			if GetHeroCreatures("Isabell", CREATURE_ANGEL) > 0 then
				SetGameVar("C3M5_creatures13", GetHeroCreatures("Isabell",CREATURE_ANGEL));
				print("Isabell has angels");
				sleep(2);
				RemoveHeroCreatures("Isabell",CREATURE_ANGEL, 10000);
				MessageBox("/Maps/Scenario/C3M5/AngelsLeftIsabell.txt");
			end
			break;
		end
	end
end

function desentir()
	desentir_day = GetDate(ABSOLUTE_DAY);
	while 1 do
		sleep(25);
		if GetDate(ABSOLUTE_DAY) > 2 and desentir_day ~= GetDate(ABSOLUTE_DAY) then						
			if IsHeroAlive("Godric") == nil or IsHeroAlive("Isabell") == nil then
				break;
			end
			allCreaturesQuantity = 0;							
			for i=1,21 do
				if GetHeroCreatures("Isabell", CreatureList[i]) > 0 then
					allCreaturesQuantity = allCreaturesQuantity + 1;
				end
			end
			if allCreaturesQuantity > 1 then
				rnd = 1 + random(20);
				quantity = GetHeroCreatures("Isabell", CreatureList[rnd]);
				if mod(GetDate(DAY), factor) == 0 then
					if quantity > 1 then
						RemoveHeroCreatures("Isabell",CreatureList[rnd], quantity);
						print("Isabell lost ",quantity," ", CreaturesNameForMessage[rnd]);
						if(rnd == 3 or rnd == 6 or rnd == 9 or rnd == 12 or rnd == 15 or rnd == 18 or rnd == 21) then -- change Renegade for True upgrade units
							rnd = rnd - 1;
						end
						VarName = "C3M5_creatures"..rnd;
						SetGameVar(VarName, GetGameVar(VarName) + quantity);
						print("Godric has ",GetGameVar(VarName)," ", CreaturesNameForMessage[rnd]);
						MessageBox("Maps/Scenario/C3M5/"..CreatureNameFromTextFiles[math.floor((rnd+2)/3)].."LeftIsabell.txt");
					else
						print("Quantity of "..CreaturesNameForMessage[rnd].."("..rnd..") = ",GetHeroCreatures("Isabell",CreatureList[rnd]),". Less than 2.");
					end
				else
					print("Not for deserting day. mod(GetDate(DAY),",factor,") = ",mod(GetDate(DAY),factor));
				end
			else
				print("Isabell has only 1 brave creature.");
			end
			if GetDifficulty() == 2 then
				SetGameVar("C3M5_creatures19",GetGameVar("C3M5_creatures19")  + 1); -- Angel
				SetGameVar("C3M5_creatures16",GetGameVar("C3M5_creatures16")  + 1); -- Paladins
				SetGameVar("C3M5_creatures14",GetGameVar("C3M5_creatures14")  + 2); -- Priests
				SetGameVar("C3M5_creatures4",GetGameVar("C3M5_creatures4")   + 10); -- Footman
				SetGameVar("C3M5_creatures7",GetGameVar("C3M5_creatures7")    + 7); -- Archers
			elseif GetDifficulty() == 3 then
				SetGameVar("C3M5_creatures19",GetGameVar("C3M5_creatures19")  + 1); -- Angel
				SetGameVar("C3M5_creatures16",GetGameVar("C3M5_creatures16")  + 2); -- Paladins
				SetGameVar("C3M5_creatures14",GetGameVar("C3M5_creatures14")  + 3); -- Priests
				SetGameVar("C3M5_creatures4",GetGameVar("C3M5_creatures4")   + 11); -- Footman
				SetGameVar("C3M5_creatures7",GetGameVar("C3M5_creatures7")    + 8); -- Archers
			end
			desentir_day = GetDate(ABSOLUTE_DAY);
		end
	end
end

function CaptureCavern()
	local Caverns = {"ore","wood","sulfur","cristall","gems","mercury"};
	local CavernArmyList = {  CREATURE_PEASANT, 200,
						   CREATURE_MILITIAMAN, 150,
							  CREATURE_FOOTMAN,  60,
							CREATURE_SWORDSMAN,  45,
							   CREATURE_ARCHER,  70,
							 CREATURE_MARKSMAN,  55,
							  CREATURE_GRIFFIN,  32,
						CREATURE_ROYAL_GRIFFIN,  26,
							   CREATURE_PRIEST,  12,
							   CREATURE_CLERIC,  10,
							 CREATURE_CAVALIER,   8,
							  CREATURE_PALADIN,   7,
								CREATURE_ANGEL,   5,
							CREATURE_ARCHANGEL,   4};
	local canvern_day = GetDate(DAY);
	while 1 do
		sleep(25);
		if canvern_day ~= GetDate(DAY) and mod(GetDate(DAY),5) == 0 then
			IsCreatureExist = 0;
			CavName = Caverns[1+random(6)];
			print("Cavern name is ",CavName," and its owner is ",GetObjectOwner(CavName));
			for i=1,179 do
				if GetObjectCreatures(CavName,i) ~= 0 then
					print("Building is guarded!");
					IsCreatureExist = 1;
					break
				end
			end
			if GetObjectOwner(CavName) ~= PLAYER_2 and IsCreatureExist == 0 then
				print("Cavern has been captured by Godric's forces");
				n = 1 + random(14);
				AddObjectCreatures(CavName,CavernArmyList[2*n-1],CavernArmyList[2*n]);
				SetObjectOwner(CavName,PLAYER_2);
				CINEMATICS.showCapturedfMine(CavName);
			else
				print("Object is already Godric's or guarded.");
			end
			canvern_day = GetDate(DAY);
		end
	end
end

function TeleportUse()
	print("Player try to use teleport");
	MessageBox("/Maps/Scenario/C3M5/TeleportUnusable_MsgBox.txt");
end

function PlayerTouchPrison(heroname)
	print("Player hero ",heroname," has entered prison");
	if heroname == "Berein" then
		Trigger(OBJECT_TOUCH_TRIGGER, "prison",nil)
		OBJECTIVES.state.captureDaughter[2] = 3;
	else
		MessageBox("/Maps/Scenario/C3M5/MsgBox_EnterPrison.txt");
	end
end

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
startThread( H55c_AI_main );

------------------ DEBUG ------------------------
function PrintGodricsReinforcements()
	for i = 1, 21 do
		print("Godric has ",GetGameVar("C3M5_creatures"..i)," ",CreaturesNameForMessage[i]);
	end
end

function GiveMeMines()
	SetObjectOwner("ore",1);
	SetObjectOwner("wood",1);
	SetObjectOwner("sulfur",1);
	SetObjectOwner("mercury",1);
	SetObjectOwner("cristall",1);
	SetObjectOwner("gems",1);
	for i = 1,180 do
		RemoveObjectCreatures("ore",i,10000);
		RemoveObjectCreatures("wood",i,10000);
		RemoveObjectCreatures("sulfur",i,10000);
		RemoveObjectCreatures("mercury",i,10000);
		RemoveObjectCreatures("cristall",i,10000);
		RemoveObjectCreatures("gems",i,10000);
	end
end
