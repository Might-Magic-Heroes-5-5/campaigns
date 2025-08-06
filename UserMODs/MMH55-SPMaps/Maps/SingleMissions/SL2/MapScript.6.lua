StartDialogScene("/DialogScenes/Single/SL2/R1/DialogScene.xdb#xpointer(/DialogScene)");
H55_PlayerStatus = {0,1,1,1,1,2,2,2};
Resources_plus = {{WOOD,5},{ORE,5},{GEM,3},{CRYSTAL,3},{SULFUR,3},{MERCURY,3},{GOLD,3000}};
Resources_minus = {{WOOD,-10},{ORE,-10},{GEM,-5},{CRYSTAL,-5},{SULFUR,-5},{MERCURY,-5},{GOLD,-5000}};
Resources_plus.n = 7;
Resources_minus.n = 7;
ArmyMdf = GetDate(WEEK)/2*(1 + GetDifficulty()/2);
AllTowns = {{"Academy","AcademyPoint","AcademyStart"},{"Sylvan","SylvanPoint","SylvanStart"},{"Necropolis","NecropolisPoint","NecropolisStart"},{"Inferno","InfernoPoint","InfernoStart"}};
AllTowns.n = 4;
PlayerTowns = {};
ReservedHeroes = {"Mardigo","Nathaniel","Orrin","Sarge"};
ArmyMdf = 1;

function WaitDay()
	local Xday;
	Xday = GetDate(DAY) + 1;
	while Xday ~= GetDate(DAY) do
		sleep(5);
	end;
end;

--function calculates multiplier for army of Invaders.
function modificator()
	while 1 do
		sleep(60);
		ArmyMdf = GetDate(MONTH)*(0.5 + GetDifficulty());
	end;
end;

--function determines moment when necessary start Invasion of imperial forces
function TimeToStartInvasion()
	print("Thread TimeToStartInvasion has been started...");
	while 1 do
		local j = 0;
		sleep(60)
		for i=1,4 do
			if GetObjectOwner(AllTowns[i][1]) == PLAYER_1 then
				j = j + 1;
			end;
		end;
		if j == 4 then
			print("Player has captured all towns on the map");
			startThread(Invasion,40);
			SetObjectiveState("CaptureTowns",OBJECTIVE_COMPLETED);
			StartDialogScene("/DialogScenes/Single/SL2/R2/DialogScene.xdb#xpointer(/DialogScene)");
			break;
		end;
	end;
end;

function StartGalibScene()
	print("Thread StartGalibScene has been started...");
	while IsObjectVisible(PLAYER_1,"Tan") == nil do
		sleep(10);
	end;
	print("Player can see hero Galib. Scene started...");
	StartDialogScene("/DialogScenes/Single/SL2/R3/DialogScene.xdb#xpointer(/DialogScene)");
end;

function ShowMeHero(HeroName)
	local x,y = GetObjectPosition(HeroName);
	OpenCircleFog(x,y,GROUND,15,PLAYER_1);
	MoveCamera(x,y,GROUND);
end;

function Invasion(delay)
		print("Thread Invasion has been started...");
		sleep(1);
		SetObjectiveState("Defence", OBJECTIVE_ACTIVE);
		startThread(ReachTown,"Tan", AllTowns[2][2], AllTowns[2][3]);
		sleep (delay);
		ShowMeHero("Tan");
		print("modificator = ",ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_ARCH_MAGI, 10*ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_MAGI, 10*ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_GENIE, 5*ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_RAKSHASA, 3*ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_STONE_GARGOYLE, 20*ArmyMdf);
		AddHeroCreatures('Tan', CREATURE_GREMLIN, 30*ArmyMdf);
		startThread(ReachTown,"Faiz", AllTowns[1][2], AllTowns[1][3]);
		sleep(delay);
		ShowMeHero("Faiz");
		startThread(ReachTown,"Astral", AllTowns[3][2], AllTowns[3][3]);
		sleep(delay);
		ShowMeHero("Astral");
		startThread(ReachTown,"Havez", AllTowns[4][2], AllTowns[4][3]);
		sleep(delay);
		ShowMeHero("Havez");
		AddHeroCreatures('Faiz', CREATURE_MAGI, 10*ArmyMdf);
		AddHeroCreatures('Faiz', CREATURE_RAKSHASA, 10*ArmyMdf);
		AddHeroCreatures('Faiz', CREATURE_MASTER_GENIE, 12*ArmyMdf);
		AddHeroCreatures('Faiz', CREATURE_GIANT , 4*ArmyMdf);
		AddHeroCreatures('Faiz', CREATURE_STEEL_GOLEM , 25*ArmyMdf);
		AddHeroCreatures('Faiz', CREATURE_MASTER_GREMLIN , 40*ArmyMdf);
			sleep ( 1 );
		AddHeroCreatures('Astral', CREATURE_GENIE, 15*ArmyMdf);
		AddHeroCreatures('Astral', CREATURE_TITAN, 5*ArmyMdf);
		AddHeroCreatures('Astral', CREATURE_ARCH_MAGI, 20*ArmyMdf);
		AddHeroCreatures('Astral', CREATURE_GREMLIN, 100*ArmyMdf);
		AddHeroCreatures('Astral', CREATURE_IRON_GOLEM, 40*ArmyMdf);
			sleep ( 1 );
		AddHeroCreatures('Havez', CREATURE_TITAN , 3*ArmyMdf);
		AddHeroCreatures('Havez', CREATURE_MASTER_GREMLIN , 30*ArmyMdf);
		AddHeroCreatures('Havez', CREATURE_STEEL_GOLEM, 20*ArmyMdf);
		AddHeroCreatures('Havez', CREATURE_ARCH_MAGI, 8*ArmyMdf);
		AddHeroCreatures('Havez', CREATURE_IRON_GOLEM , 25*ArmyMdf);
		AddHeroCreatures('Havez', CREATURE_OBSIDIAN_GARGOYLE , 30*ArmyMdf);
		startThread(PlayerWin);
		print("Army has been added for the all enemy heroes");
		sleep(delay);
		StartDialogScene("/DialogScenes/Single/SL2/R3/DialogScene.xdb#xpointer(/DialogScene)");
end;

--function initiate reids of enemy heroes. One time per 10 Days.
function EnemyRaiders()
	print("Thread EnemyRaiders has been started...");
	local n=0;
	while n ~= 4 do
		sleep(10);
		if mod(GetDate(DAY),10) == 0 then
			PlayerTowns = {};
			n = n + 1;
			print("n = ",n);
			local j=0;
			for i=1,4 do
				if GetObjectOwner(AllTowns[i][1]) == PLAYER_1 then
					print("Player has town ",AllTowns[i][1]);
					j = j + 1;
					PlayerTowns[j] = {};
					PlayerTowns[j][1] = AllTowns[i][1];
					PlayerTowns[j][2] = AllTowns[i][2];
					PlayerTowns[j][3] = AllTowns[i][3];
					print("Town name is ",PlayerTowns[j][1]);
					print("Destination Point name is ",PlayerTowns[j][2]);
					print("Deploy point name is ",PlayerTowns[j][3]);
				end;
			end;
			if j == 0 then
				print("Player has not got any towns :(");
				return
			else
				print("Player has got ",j," town(s)");
				Rnd = 1 + random(j);
				startThread(ReachTown,ReservedHeroes[n],PlayerTowns[Rnd][2],PlayerTowns[Rnd][3]);
				WaitDay();
			end;
		end;
	end;
end;

function ReachTown(HeroName,DestinationRegionName,DeployRegionName)
	print(HeroName," has been deployed and he is going to reach", DestinationRegionName);
	DeployReserveHero(HeroName,RegionToPoint(DeployRegionName));
	print("Waiting...");
	sleep(20);
	--EnableHeroAI(HeroName, nil);
	MoveHero(HeroName,RegionToPoint(DestinationRegionName));
	--Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, DestinationRegionName, "EnableHeroAi");
end;

function EnableHeroAi(HeroName)
	print("Thread EnableHeroAi has been started...");
	for i=1,4 do
		if IsObjectInRegion(HeroName, AllTowns[i][2]) == 1 then
			print("Hero ", HeroName, " is in region ",AllTowns[i][2]);
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, AllTowns[i][2], nil);
			print("AI for the ", HeroName," has been switched ON.");
			--EnableHeroAI(HeroName,not nil);
			break;
		end;
	end;
end;

--function randomly adds or removes resources from player
function H55_TriggerDaily()
print("Thread GiveMeMoney has been started");
H55_NewDayTrigger = 0;
	if mod((GetDate(DAY)-1),7) == 0 then
		local result = 1 + random(6);
		if result == 4 or result == 5 then
			print("Zachot!");
			MessageBox("/Maps/SingleMissions/SL2/ResourcesPlus.txt");
				for i=1,Resources_plus.n do
					print("Resource type is ",Resources_plus[i][1],"Quantity(+) = ",Resources_plus[i][2]);
					SetPlayerResource(PLAYER_1,Resources_plus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1])+Resources_plus[i][2]);
					H55_NewDayTrigger = 1;
				end;
		else
			if result == 6 then
				print("Nizachot");
				MessageBox("/Maps/SingleMissions/SL2/ResourcesMinus.txt");
				for i=1,Resources_minus.n do
					if GetPlayerResource(PLAYER_1,Resources_minus[i][1]) > Resources_minus[i][2] then
						print("Resource type is ",Resources_plus[i][1],"Quantity(-) = ",Resources_plus[i][2]);
						SetPlayerResource(PLAYER_1,Resources_minus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1])-Resources_minus[i][2]);
						H55_NewDayTrigger = 1;
					else
						print("Resource type is ",Resources_plus[i][1],"Quantity(=) = ",GetPlayerResource(PLAYER_1,Resources_minus[i][1]));
						SetPlayerResource(PLAYER_1,Resources_minus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1]));
						H55_NewDayTrigger = 1;
					end;
				end;
			else
				print("Week of nothing");
				H55_NewDayTrigger = 1;
			end;
		end;
	end;
end;

--<====================== WIN ============================>
function PlayerWin()
	print("Thread PlayerWin has been started...");
	while 1 do
		sleep(10);
		if  IsHeroAlive("Faiz")     == nil and
			IsHeroAlive("Tan")     == nil and
			IsHeroAlive("Astral")== nil and
			IsHeroAlive("Havez")   == nil then
			SetObjectiveState("Defence", OBJECTIVE_COMPLETED);
			StartDialogScene("/DialogScenes/Single/SL2/R4/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			Win(PLAYER_1);
			return
		end;
	end;
end;
--<========================END WIN ============================>

--<====================== LOOSE ============================>
function PlayerLoose()
	print("Thread PlayerLoose has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive("Effig") == nil then
			print("Hero Raven is dead. You loose.");
			Loose(PLAYER_1);
			return
		end;
	end;
end;
--<========================END LOOSE ============================>

H55_NewDayTrigger = 1;
startThread(modificator);
startThread(TimeToStartInvasion);
--startThread(EnemyRaiders);
startThread(PlayerLoose);