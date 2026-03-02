doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_UNICORN_HORN_BOW,
	ARTIFACT_PLATE_MAIL_OF_STABILITY,
	ARTIFACT_PEDANT_OF_MASTERY,
	ARTIFACT_RING_OF_LIFE,
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M1");
end

startThread(H55_InitSetArtifacts);

---VARS AND CONSTANTS---
borders={'Border1','Border2','Border3','Border4','Border5'};
points={'Border1','Border2','Border3','Border4','Border5'};
SylvanPosts = {
 ["Border1"] = { 15, 76, 0, nil },
 ["Border2"] = { 32, 67, 0, nil },
 ["Border3"] = { 49, 54, 0, nil },
 ["Border4"] = { 65, 37, 0, nil },
 ["Border5"] = { 103, 21, 0, nil },
}

ai_regions={'ai_block1','ai_block2','ai_block3','ai_block4','ai_block5'};
pl_message_regions={'player_alarm1','player_alarm2','player_alarm3','player_alarm4','player_alarm5'};
pl_fail_regions={'player_fail1','player_fail2','player_fail3','player_fail4','player_fail5'};
heroes={'Tamika','Straker','Pelt','Nemor','Effig'};

function block_regions_for_ai()
	for i,h in ai_regions do
		SetRegionBlocked(ai_regions[i], 1, 2);
	end
end

function contest_point()
	for k,h in pl_message_regions do
		sleep(5);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,pl_message_regions[k],"at_sylvan_post_gate");
	end
end

function mark_attacked(id)
    C5M1_attacked_garrison[id] = 1   -- any non-nil value
end

function at_sylvan_post_gate(h_n)
	if GetObjectOwner(h_n) == 1 then
		MessageBox('/Maps/Scenario/C5M1/alarm.txt');
	elseif GetObjectOwner(h_n) == 2 then
		local x,y,z = GetObjectPosition(h_n);
		local choice = nil;
		local closest_distance = 30;
		local onslaught_hero = nil;
		for name, coords in SylvanPosts do
			local dx = coords[1] - x;
			local dy = coords[2] - y;
			local distance = math.sqrt(dx*dx + dy*dy);
			if closest_distance > distance then
				closest_distance = distance;
				choice = name;
				onslaught_hero = coords[4];
			end
		end
		print(h_n);
		print(onslaught_hero);
		if choice ~= nil and onslaught_hero == h_n and GetObjectOwner(choice) ~= 2 then
			ChangeHeroStat(h_n, STAT_MOVE_POINTS, -5000);
			startThreadOnce(MakeHeroInteractWithObject, h_n, choice);
			SylvanPosts[choice][4] = nil;
		end
	end
end

function borderCross_message()
	for m,h in pl_fail_regions do
		sleep(5);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,pl_fail_regions[m],"bordercross_fail");
	end
end

function bordercross_fail(h_n)
	if GetObjectOwner(h_n) == 1 then
		OBJECTIVES.state.borderCross[2] = 3;
	end
end

function borderPosts_capture()
	for i = 1,5 do
		sleep(5);
		Trigger(OBJECT_CAPTURE_TRIGGER,borders[i], 'borderPosts_capture_count');
	end
end

function borderPosts_capture_count(play_1,play_2,name_h,garrison)
	bor = 0;
	for a = 1,5 do
		sleep(5);
		if GetObjectOwner(borders[a]) == 2 then
			bor = bor + 1;
		end
	end
	if OBJECTIVES.state.holdBorders[2] < 10 then
		if play_1 == 1 and bor == 1 then
			OBJECTIVES.state.recapturePost[2] = 2;
		elseif play_1 == 2 and bor == 0 then
			OBJECTIVES.state.recapturePost[2] = 4;
		end
	end
	if GetObjectOwner(garrison) == 2 then
		SylvanPosts[garrison][4] = nil;
	end
end

function attackBorder(hero, order)
	pos = SylvanPosts[order];
	exp = GetHeroStat("Heam", STAT_EXPERIENCE);
	ChangeHeroStat(hero, STAT_EXPERIENCE, exp*(dif/4));
	if IsHeroAlive(hero) == nil then
		DeployReserveHero(hero, RegionToPoint('EnemyHere'));
	end
	local num = GetDate(MONTH)*4 - 4 + GetDate(WEEK);
	AddHeroCreatures(hero, CREATURE_SKELETON_ARCHER, 20 + num*10 + dif*3);
	AddHeroCreatures(hero,			CREATURE_ZOMBIE, 10 + num*5  + dif*3);
	AddHeroCreatures(hero,		  	 CREATURE_GHOST,  7 + num*4  + dif);
	AddHeroCreatures(hero, 	  CREATURE_VAMPIRE_LORD,  4 + num*2  + dif/2);
	AddHeroCreatures(hero,	   	  CREATURE_DEMILICH,      num    + dif/2);
	AddHeroCreatures(hero,		 	CREATURE_WRAITH,  1 + num*dif/4);
	AddHeroCreatures(hero,	 CREATURE_SHADOW_DRAGON,  1 + num*dif/8);
	sleep(5);
	DenyAIHeroFlee(hero, not nil);
	MoveHero(hero, pos[1], pos[2], pos[3]);
	SylvanPosts[order][4] = hero;
	print(hero," attack at border post ",pos[1],":",pos[2],":",pos[3]);
end

DIFFICULTY = {
	[0] = function()
		dif = 1;
		demon_invasion_day = 43;
		SetTownBuildingLimitLevel('Damlad', 11, 2);
		SetTownBuildingLimitLevel('Damlad', 12, 2);
		AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
	end,

	[1] = function()
		dif = 2;
		demon_invasion_day = 39;
	end,

	[2] = function()
		dif = 3;
		demon_invasion_day = 34;
	end,

	[3] = function()
		dif = 4;
		demon_invasion_day = 30;
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C5/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	demonArmy = function()
		StartDialogScene("/DialogScenes/C5/M1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	recapturePostStart = function()
		StartDialogScene("/DialogScenes/C5/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	recapturePostFinish = function()
		StartDialogScene("/DialogScenes/C5/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,

	outro = function()
		StartDialogScene("/DialogScenes/C5/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
}

OBJECTIVES = {
	state = {
		holdBorders		= { "prim1", 1 }, -- hold at least 3 border posts for X days
		borderCross		= { "prim2", 1 }, -- do not cross the borders
		isAlive			= { "prim3", 1 }, -- do not let Heam die
		demonArmy		= { "prim4", 1 }, -- destroy demon army
		recapturePost	= { "prim5", 1 }, -- recapture all lost military posts
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		bor = 0;
		startThread(DIFFICULTY[GetDifficulty()]);
		Save("autosave");
		CINEMATICS.intro();
		print(dif);
		startThread(block_regions_for_ai);
		-- Warnings for borderCross
		startThread(contest_point);
		startThread(borderCross_message);
		-- Enemy capture tracker for holdBorders and recapturePost
		startThread(borderPosts_capture);
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(10);
				Win();
				return
			end
		end
	end,

	holdBorders_attack_count = 5,
	holdBorders_attack_day = 1,
	holdBorders = function()
		if OBJECTIVES.state.holdBorders[2] == 1 then
			SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.holdBorders[2] = 2;
		elseif OBJECTIVES.state.holdBorders[2] == 2 and GetDate(ABSOLUTE_DAY) > OBJECTIVES.holdBorders_attack_day and GetDate(DAY_OF_WEEK) > random(6) then
			OBJECTIVES.holdBorders_attack_day = OBJECTIVES.holdBorders_attack_day + 7;
			hero_idx = random(OBJECTIVES.holdBorders_attack_count) + 1;
			position_idx = random(OBJECTIVES.holdBorders_attack_count) + 1;
			local hero = heroes[hero_idx];
			local post = points[position_idx];
			attackBorder(hero, post);
			OBJECTIVES.holdBorders_attack_count = OBJECTIVES.holdBorders_attack_count - 1;
			heroes=remove_element(hero, heroes);
			points=remove_element(post, points);
		end
		if OBJECTIVES.state.holdBorders[2] > 1 and OBJECTIVES.state.demonArmy[2] == 3 then
			SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.holdBorders[2] = 10;
		end

		if bor > 2 then
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
		end
	end,

	borderCross = function()
		if OBJECTIVES.state.borderCross[2] == 1 then
			SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.borderCross[2] = 2;
		elseif OBJECTIVES.state.borderCross[2] == 3 then
			MessageBox('/Maps/Scenario/C5M1/fail.txt');
			sleep(10);
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.borderCross[2] = 11;
		end
	end,

	isAlive = function()
		-- start of this task is handled by C5M1.xdb
		if (IsHeroAlive("Heam") == nil) then
			SetObjectiveState("prim3", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	demonArmy = function()
		if OBJECTIVES.state.demonArmy[2] == 1 and GetDate(DAY) == demon_invasion_day then
			DeployReserveHero("Biara" , RegionToPoint('EnemyHere'));
			exp = GetHeroStat("Heam", STAT_EXPERIENCE);
			ChangeHeroStat("Biara", STAT_EXPERIENCE, exp*(dif/4));
			AddHeroCreatures("Biara",		 	 CREATURE_FAMILIAR, dif *  30);
			AddHeroCreatures("Biara",	    CREATURE_HORNED_LEAPER, dif *  20);
			AddHeroCreatures("Biara", 			  CREATURE_CERBERI, dif *  15);
			AddHeroCreatures("Biara",   CREATURE_INFERNAL_SUCCUBUS, dif *  12);
			AddHeroCreatures("Biara", CREATURE_FRIGHTFUL_NIGHTMARE, dif *   7);
			AddHeroCreatures("Biara",				CREATURE_BALOR, dif *   4);
			AddHeroCreatures("Biara",			CREATURE_ARCHDEVIL, dif *   3);
			EnableHeroAI("Biara", not nil);
			sleep(5);
			startThread(H55_AttackTown,"Biara", "Damlad");
			OBJECTIVES.state.demonArmy[2] = 2;
		elseif OBJECTIVES.state.demonArmy[2] == 2 and IsObjectVisible(PLAYER_1, "Biara") then
			CINEMATICS.demonArmy();
			sleep(10);
			AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 5);
			for i = 1,5 do
				sleep(5);
				Trigger(OBJECT_CAPTURE_TRIGGER,borders[i], nil);
			end
			SetObjectiveState('prim4', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.demonArmy[2] = 3;
		elseif OBJECTIVES.state.demonArmy[2] == 3 and IsHeroAlive("Biara") == nil then
			SaveHeroAllSetArtifactsEquipped("Heam", "C5M1");
			SetObjectiveState("prim4", OBJECTIVE_COMPLETED);
			sleep(5);
			LevelUpHero("Heam");
			OBJECTIVES.state.demonArmy[2] = 10;
		end
	end,

	recapturePost_play = not nil,
	recapturePost = function()
		if OBJECTIVES.state.recapturePost[2] == 2 then
			if OBJECTIVES.recapturePost_play ~= nil then CINEMATICS.recapturePostStart(); end
			SetObjectiveState('prim5', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.recapturePost[2] = 3;
		elseif OBJECTIVES.state.recapturePost[2] == 4 then
			if OBJECTIVES.recapturePost_play ~= nil then
				CINEMATICS.recapturePostFinish();
				OBJECTIVES.recapturePost_play = nil;
			end
			SetObjectiveState('prim5', OBJECTIVE_COMPLETED);
			AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 1);
			OBJECTIVES.state.recapturePost[2] = 1;
		end
		
		if OBJECTIVES.state.holdBorders[2] == 10 then
			if GetObjectiveState('prim5') == OBJECTIVE_ACTIVE then
				SetObjectiveState('prim5', OBJECTIVE_COMPLETED);
			end
			OBJECTIVES.state.recapturePost[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
