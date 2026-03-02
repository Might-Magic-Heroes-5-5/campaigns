doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_UNICORN_HORN_BOW,
	ARTIFACT_PLATE_MAIL_OF_STABILITY,
	ARTIFACT_PEDANT_OF_MASTERY,
	ARTIFACT_RING_OF_LIFE,
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M5");
    LoadHeroAllSetArtifacts("Heam", "C5M4" );
end

startThread(H55_InitSetArtifacts);

dang_array = {"Nemor","Pelt","Straker","Tamika","Effig"};
shadow_dragons = {"SD1", "SD2", "SD3", "SD4", "SD5", "SD6"};
regions={'sdregion1','sdregion2','sdregion3','sdregion4','sdregion5','sdregion6',"AI_block_1","AI_block_2","AI_block_3","AI_block_4","AI_blok","AI_block_5","AI_block_6","AI_blok","AI_blok1","AI_blok2","AI_blok3","AI_block_7","AI_block_8"}
towns={'town1','town2','town3','town4','town5','town6'}
respawns_x={37,84,41,160,95,26}
respawns_y={39,86,152,31,92,21}
respawns_z={GROUND,GROUND,GROUND,GROUND,UNDERGROUND,UNDERGROUND}
kolyan_army={
 [0]={30,25,20,15},
 [1]={50,40,30,25},
 [2]={70,55,40,35},
 [3]={90,70,50,45},
}

creatures_types={CREATURE_SKELETON_ARCHER, CREATURE_ZOMBIE, CREATURE_GHOST, CREATURE_VAMPIRE_LORD, CREATURE_DEMILICH, CREATURE_WRAITH, CREATURE_SHADOW_DRAGON}

function blocking()  --блокает проходимость тайлов вокруг шадоу драконов дл€ PLAYER_2, чтоб он сам их не поубивал как дурак
	for i,h in regions do
		SetRegionBlocked(regions[i], not nil, PLAYER_2)
		print (regions[i], "block");
	end
end

function set_light(type)
	if type == 0 then
		SetAmbientLight(0, "c5m5_dawn", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dawn.xdb#xpointer(/AmbientLight)");
	elseif type == 1 then
		SetAmbientLight(0, "c5m5_dusk1", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dusk1.xdb#xpointer(/AmbientLight)");
	elseif type == 2 then
		SetAmbientLight(0, "c5m5_dusk2", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dusk2.xdb#xpointer(/AmbientLight)");
	elseif type == 3 then
		SetAmbientLight(0, "c5m5_dusk3", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dusk3.xdb#xpointer(/AmbientLight)");
	elseif type == 4 then
		SetAmbientLight(0, "c5m5_dusk4", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dusk4.xdb#xpointer(/AmbientLight)");
	elseif type == 5 then
		SetAmbientLight(0, "c5m5_dusk5", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_dusk5.xdb#xpointer(/AmbientLight)");
	elseif type == 6 then
		SetAmbientLight(0, "c5m5_night", not nil, 5)
		SetCombatLight("/Lights/_(AmbientLight)/AdvMap/C5M5/c5m5_night.xdb#xpointer(/AmbientLight)");
	end
end

function dragons_count() --возвращает количество оставшихс€ на карте шадоу драгонов
	local m=0
	for i,h in shadow_dragons do
		if IsObjectExists(shadow_dragons[i])==nil then
			SetRegionBlocked(regions[i], nil, PLAYER_2);	--разблочиваем проходимость региона дл€ PLAYER_2 потому как дракона уже нет
		else
			m=m+1;									 		--"жив" ли данный стек шадоу драгонов?
		end
	end
	return m
end

function ressurect(loser, winner) --триггерна€ функци€, запускаетс€ после смерти геро€ PLAYER_2, респавнит  ол€на...или не респавнит
	if loser=='Nikolay' then --убитого геро€ зовут  ол€н?
		if winner~=nil then --его убили или сам слажал?
			if GetHeroCreatures(winner, CREATURE_PHOENIX) > 0 or OBJECTIVES.state.killDragons[2] == 10 or OBJECTIVES.state.defeatNikolay[2] == 2 then --были ли у убийцы фениксы в армии на конец битвы, или  ол€на убили при солнечном свете?
				OBJECTIVES.state.defeatNikolay[2] = 9;
			else --облом с фениксами или светом вышел?
				if first_time==1 then --который уже раз  ол€на валим?
					first_time=0
					CINEMATICS.resurectNikolay();
				end
			end
		end
		DeployReserveHero('Nikolay',check_place()) --респавн  ол€на
		sleep(15) --без этой паузы следующа€ функци€ не стаботает!!!!
		DenyAIHeroFlee('Nikolay', not nil);
		update_army() --добавление  ол€ну свежей армии
	end
end

function update_army() --добавление армии  ол€ну после респавноа
	local diff = GetDifficulty();
	for i,h in kolyan_army[diff] do
		AddHeroCreatures('Nikolay', creatures_types[i+3] , 1+diff_mod[i])
		print("Kolyan gain ",1+diff_mod[i], creatures_types[i+3])
	end
end

function check_place() --выбирает место куда отреспавнить  ол€на, респавнит р€дом с одним из своих замков, если таких нет, то у любого из андедских
	local fake_array={};a=6
	for i,h in towns do
		if GetObjectOwner(towns[i])==PLAYER_2 then
			fake_array[i]=towns[i]
		end
	end
	if a==0 then
		a=table.length(fake_array[i])
	end	
	b=random(a)+1
	return respawns_x[b],respawns_y[b],respawns_z[b]
end

function quest(hero_n)
	if hero_n == "Heam" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		OBJECTIVES.state.dwarvenSet[2] = 3;
	else
		ShowFlyingSign("/Maps/Scenario/C5M5/C5M5.txt", "hut", -1, 3.0);
	end
end

function quest_final(hero_n)
	if hero_n == "Heam" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		OBJECTIVES.state.setToSeer[2] = 3;
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene('/DialogScenes/C5/M5/R1/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
    end,
	
	resurectNikolay = function()
		StartDialogScene('/DialogScenes/C5/M5/R2/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
    end,
	
	dwarvenSetStart = function()
		StartDialogScene('/DialogScenes/C5/M5/R3/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
    end,
	
	dwarvenSetFinish = function()
		StartDialogScene('/DialogScenes/C5/M5/R4/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
    end,
	
	setToSeer = function()
		StartDialogScene('/DialogScenes/C5/M5/R5/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
	
	notifyMages = function()
		StartDialogScene('/DialogScenes/C5/M5/D1/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
	
	dragonsLeft0 = function()
		StartDialogScene('/DialogScenes/C5/M5/R8/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
	
	dragonsLeft3 = function()
		StartDialogScene('/DialogScenes/C5/M5/R7/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
	
	dragonsLeft5 = function()
		StartDialogScene('/DialogScenes/C5/M5/R6/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
	
	showDragons = function()
		BlockGame();
		for i,h in shadow_dragons do
			if IsObjectExists(shadow_dragons[i])~=nil and IsObjectVisible(PLAYER_1, shadow_dragons[i]) then
				local x,y,z = GetObjectPosition(shadow_dragons[i]);
				MoveCamera(x, y, z, 50, 0.925, 0.279, 0, 1);
				sleep(100);
			end
		end
		sleep(5);
		UnblockGame();
	end,
	
	outro = function()
		StartDialogScene('/DialogScenes/C5/M5/D2/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
    end,
}

function disableEnemyFleeing()
	sleep(30); -- wait till Nikolay is deployed and part of the roster
	local heroes = GetPlayerHeroes(PLAYER_2)
	for i, hero in heroes do
		print(hero);
		DenyAIHeroFlee(hero, not nil)
	end
end

DIFFICULTY = {
	[0] = function()
		print ("easy");
		dif = 0;
		night_diff = 1;
		exp = GetHeroStat("Heam", STAT_EXPERIENCE)/4;
		for i,h in dang_array do
			ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		end
		for a = 0,6 do
			SetPlayerResource(PLAYER_2, a, 0);
		end
		AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
	end,
	
	[1] = function()
		print ("normal");
		dif = 0;
		night_diff = 1.25;
		exp = GetHeroStat("Heam", STAT_EXPERIENCE)/2;
		for i,h in dang_array do
			ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
		end;
		for a = 0,6 do
			SetPlayerResource(PLAYER_2, a, 0);
		end
		ChangeHeroStat('Nikolay', STAT_ATTACK, 5);
		ChangeHeroStat('Nikolay', STAT_DEFENCE, 5);
	end,
	
	[2] = function()
		print ("Hard");
		dif = 1;
		night_diff = 1.5;
		exp = GetHeroStat("Heam", STAT_EXPERIENCE);
		for i,h in dang_array do
			ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
			AddObjectCreatures(dang_array[i], CREATURE_SKELETON_ARCHER , 30);
			AddObjectCreatures(dang_array[i], CREATURE_ZOMBIE , 20);
		end
		ChangeHeroStat('Nikolay', STAT_ATTACK, 10);
		ChangeHeroStat('Nikolay', STAT_DEFENCE, 10);
	end,
	
	[3] = function()
		print ("Impossible");
		dif = 2;
		night_diff = 1.75;
		exp = GetHeroStat("Heam", STAT_EXPERIENCE);
		for i,h in dang_array do
			ChangeHeroStat(dang_array[i], STAT_EXPERIENCE, exp);
			AddObjectCreatures(dang_array[i], CREATURE_SKELETON_ARCHER, 45);
			AddObjectCreatures(dang_array[i], CREATURE_ZOMBIE, 30);
			AddObjectCreatures(dang_array[i], CREATURE_GHOST, 37);
		end
		ChangeHeroStat('Nikolay', STAT_ATTACK, 15);
		ChangeHeroStat('Nikolay', STAT_DEFENCE, 15);
	end,
}

OBJECTIVES = {
	state = {
		defeatNikolay	= { "prim1", 1 }, 	-- Defeat Nikolay
		isAlive			= { "Prim4", 1 }, 	-- Is Findan alive?
		dwarvenSet		= {  "sec1", 1 }, 	-- Collect the Dwarven Set
		setToSeer		= {  "sec2", 0 }, 	-- Bring the Dwarven Set to Sear
		notifyMages		= {  "none", 1 }, 	-- Cinematic trigger
		killDragons     = {  "none", 1 },   --
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		first_time=1
		H55_CamFixTooManySkills(PLAYER_1,"Heam");
		H55_CamFixTooManySkills(PLAYER_1,"Diraya");
		H55_CamFixTooManySkills(PLAYER_1,"Nadaur");
		CINEMATICS.intro();
		DeployReserveHero('Nikolay',84,86,GROUND);
		exp = GetHeroStat("Heam", STAT_EXPERIENCE);
		ChangeHeroStat('Nikolay', STAT_EXPERIENCE, 900000+exp);
		blocking();
		Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'ressurect');
		startThread(DIFFICULTY[GetDifficulty()]);
		disableEnemyFleeing();
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

			if GetObjectiveState("Prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				sleep(10);
				Win();
				return
			end
		end
	end,
	
	progress_sky = 0,
	progress_day = 0,
	great_night_progress = 0,
	defeatNikolay = function()
		-- Objective is started by C5M5.xdb
		if OBJECTIVES.state.defeatNikolay[2] == 1 and OBJECTIVES.progress_day < GetDate(ABSOLUTE_DAY) then
			OBJECTIVES.great_night_progress=OBJECTIVES.great_night_progress+dragons_count()*night_diff;
			print ("zlo = ", OBJECTIVES.great_night_progress);
			local power=OBJECTIVES.great_night_progress/1008 --насколько драконы закончили свою работу
			local new_progress = 1 + math.floor(power * 5);
			print('power= ',power,' | progress= ', new_progress);
			if power>1 then  --вызываетс€ когда параметр power становитс€ больше 1, типа "¬елика€ Ќочь" достигла своего апоге€ и андедов уже не остановить
				new_progress = 6;
				for i,h in regions do
					SetRegionBlocked(regions[i], nil, PLAYER_2)
					print (regions[i], "unblock");
				end
				sleep(5);
				EnableHeroAI('Nikolay', not nil);
				AddHeroCreatures('Nikolay', CREATURE_SHADOW_DRAGON, 666);
				OBJECTIVES.state.defeatNikolay[2] = 2;
			end
			if OBJECTIVES.state.killDragons[2] < 10 and OBJECTIVES.progress_sky ~= new_progress then
				set_light(new_progress);
				if new_progress == 4 then 
					pcall(startThread, MessageBox, "/Maps/Scenario/C5M5/night1.txt");
					CINEMATICS.showDragons();
				end
				if new_progress == 5 then pcall(startThread, MessageBox, "/Maps/Scenario/C5M5/night2.txt"); end
				if new_progress == 6 then pcall(startThread, MessageBox, "/Maps/Scenario/C5M5/night3.txt"); end
				OBJECTIVES.progress_sky = new_progress;
			end
			OBJECTIVES.progress_day = OBJECTIVES.date;
		elseif OBJECTIVES.state.defeatNikolay[2] == 2 then
			ChangeHeroStat('Nikolay', STAT_MOVE_POINTS, 6500000);
			if OBJECTIVES.progress_day <= OBJECTIVES.date then
				local h_x, h_y, h_z = GetObjectPosition("Heam");
				local move_nikolay = pcall(MoveHero, 'Nikolay', h_x, h_y, h_z);
				if move_nikolay == nil then
					SetObjectPosition('Nikolay', check_place());
				end
				OBJECTIVES.progress_day = OBJECTIVES.date + 1;
			end
		elseif OBJECTIVES.state.defeatNikolay[2] == 9 then
			SaveHeroAllSetArtifactsEquipped("Heam", "C5M5");
			SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
			Save("autosave");
			sleep(10);
			CINEMATICS.outro();
			OBJECTIVES.state.defeatNikolay[2] = 10;
		end
	end,	
	
	isAlive = function()
		-- Objective is started by C5M5.xdb
		if IsHeroAlive("Heam") == nil then
			SetObjectiveState("Prim4", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	dwarvenSet = function()
		if OBJECTIVES.state.dwarvenSet[2] == 1 then
			SetObjectEnabled('hut', nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest");
			OBJECTIVES.state.dwarvenSet[2] = 2;
		elseif OBJECTIVES.state.dwarvenSet[2] == 3 then
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE);
			sleep(15);
			CINEMATICS.dwarvenSetStart();
			OBJECTIVES.state.dwarvenSet[2] = 4;
		elseif OBJECTIVES.state.dwarvenSet[2] == 4 then
			if HasArtefact("Heam", 48) == not nil and HasArtefact("Heam", 49) == not nil and HasArtefact("Heam", 50) == not nil and HasArtefact("Heam", 51) == not nil then
				CINEMATICS.dwarvenSetFinish();
				SetObjectiveState('sec1', OBJECTIVE_COMPLETED);
				OBJECTIVES.state.setToSeer[2] = 1;
				OBJECTIVES.state.dwarvenSet[2] = 10;
			end
		end
	end,
	
	setToSeer = function()
		if OBJECTIVES.state.setToSeer[2] == 1 then
			SetObjectiveState('sec2', OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest_final");
			OBJECTIVES.state.setToSeer[2] = 2;
		elseif OBJECTIVES.state.setToSeer[2] == 3 then
			CINEMATICS.setToSeer();
			AddHeroCreatures("Heam",CREATURE_PHOENIX,5);
			sleep(5);
			SetObjectiveState('sec2', OBJECTIVE_COMPLETED);
			SetObjectFlashlight("Heam", "phoenix");
			RemoveArtefact("Heam", 48);
			RemoveArtefact("Heam", 49);
			RemoveArtefact("Heam", 50);
			RemoveArtefact("Heam", 51);
			ResetObjectFlashlight("hut");
			OBJECTIVES.state.setToSeer[2] = 10;
		end
	end,
	
	notifyMages = function()
		if GetDate(MONTH) == 2 then
			CINEMATICS.notifyMages();
			OBJECTIVES.state.notifyMages[2] = 10;
		end
	end,
	
	killDragons = function()
		local m=dragons_count();
		if OBJECTIVES.state.killDragons[2] == 1 and m == 5 then
			CINEMATICS.dragonsLeft5();
			OBJECTIVES.state.killDragons[2] = 2;
		elseif OBJECTIVES.state.killDragons[2] == 2 and m == 3 then
			CINEMATICS.dragonsLeft3();
			OBJECTIVES.state.killDragons[2] = 3;
		elseif OBJECTIVES.state.killDragons[2] == 3 and m == 0 then
			CINEMATICS.dragonsLeft0(); --все драконы убиты
			set_light(0);
			OBJECTIVES.state.killDragons[2] = 10;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function go()
	MakeHeroInteractWithObject("Heam", "Nikolay");
end

function fast()
	OBJECTIVES.great_night_progress=990;
end