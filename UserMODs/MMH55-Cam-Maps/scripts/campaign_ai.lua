-- ##### AI debug #####
-- 0: no debug prints
-- 1: prints target
-- 2: prints message for each computed func so error debug is easier
H55c_AI_debug = 0;
H55c_AI_error = "None";
H55c_AI_crash_counter = 0;
H55c_AI_error_stamp = "None";
H55c_AI_run_during_player_turn = "Not yet run";
-- ##### How to use #####
--Add this to map script.
--
--startThread( H55c_AI_main )
--
-- ##### How to configure ######

-- The following array denotes the attractor values for all non human players controlled by the LUA-AI
-- player1, player2, player3 is the info for that player heroes and their targers. Set it in your map lua file.
--H55c_AI_CONTROLLED = {
--  player1 = {        -- player 1player/human so state should be 0 to skip control of the heroes
--      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
--       heroes = {},
--      enemies = {},     -- one entry per active map player;
--                 -- #################################
--                 -- item(default value): Description
--                 -- #################################
--                 -- float priority(1.0, higher mean more important):
--                -- denotes how important targets of that player are to be destroyed compared to similar
--                -- objects of other enemies at similar distance.
--                 -- float heroes(1.0, higher mean more important):
--                -- denotes how important this player heroes are to be destroyed compared to other
--                -- targets of the same player
--                 -- float towns(1.0, higher mean more important):
--                -- same as heroes but for towns
--                 -- bool is_enemy(): self explanatory.
--                -- If 0 adventure map objects owned by that player will not be included in target roster
--
--  },
--  player2 = {          -- Red Inferno AI player
--      state = 2,       -- AI player with specific purpose so control set to 2
--       heroes = {},
--      enemies = {
--      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
--      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
--    }
--  }
--}

function H55c_AI_crash()
	H55c_AI_crash_counter = H55c_AI_crash_counter + 1;
	H55c_AI_error_stamp = H55c_AI_error;
	print("AI error: " .. H55c_AI_error);
	sleep(1000);
	__threads[H55c_AI_UpdateTargetWeight] = nil; -- required to fix an issue with StartThreadOnce not cleaning funcs that crash from the threadlist.
end

function H55c_AI_print(mode, message)
	if H55c_AI_debug >= mode then
		print(message);
	end
end

H55c_AI_lists = {
  towns = GetObjectNamesByType("TOWN"),
  heroes = GetObjectNamesByType("HERO"),
  others = {},
}

function H55c_AI_MostImportantTarget(hero, ignore_threshold)
	H55c_AI_error = "H55c_AI_MostImportantTarget";
	errorHook(H55c_AI_crash);
	local minIndex, minValue = 0, math.huge;
	for i, value in hero.weights do
		if value > ignore_threshold and value <= minValue then
			minIndex = i;
			minValue = value;
			H55c_AI_print(4, ignore_threshold .. " | " .. i .. ": " .. value .. " | " .. hero.targets[i]);
		end
	end
	return minIndex, minValue
end

function H55c_AI_roamHero(name)
	H55c_AI_error = "H55c_AI_roamHero";
	errorHook(H55c_AI_crash);
	if IsHeroAlive(name) == nil then
		return
	end
	H55c_AI_print(1, "Activate ROAMING mode for ".. name);
	-- these next two lines are required to unbind AI hero target before release it in roaming mode
	local x, y, z = GetObjectPosition(name);
	pcall( MoveHero, name, x, y, z );
	EnableHeroAI(name, not nil);
end

function H55c_AI_SetHeroTarget(name, hero, idx)
	H55c_AI_error = "H55c_AI_SetHeroTarget";
	errorHook(H55c_AI_crash);
	local target = hero.targets[idx];
	if target == nil then
		return 0
	end
	H55c_AI_print(2, "Set hero target: " .. target)
	local status, result;

	if hero.types[idx] == "towns" then
		status, result = pcall(H55_AttackTown, name, target);
	else
		local x,y,z = GetObjectPosition(target);
		status, result = pcall(MoveHero, name, x, y, z);
	end
	if status then
		H55c_AI_print(1, target .. ": Found!");
		return target;
	end
	H55c_AI_print(1, target .. ": Blocked;");
	return 0;
end

function H55c_AI_FindHeroTarget(name, hero, tries_left, threshold)
	H55c_AI_error = "H55c_AI_FindHeroTarget";
	errorHook(H55c_AI_crash);
	H55c_AI_print(2, "try: ".. tries_left)

	if table.length(hero.targets) == 0 or tries_left == 0 then
		H55c_AI_roamHero(name);
		return "Roam"
	end

	local idx, value = H55c_AI_MostImportantTarget(hero, threshold)
	local choice = H55c_AI_SetHeroTarget(name, hero, idx)
	if choice == 0 then
		hero.weights[idx] = math.huge;
		choice = H55c_AI_FindHeroTarget(name, hero, tries_left-1, 0)
	end
	return choice
end

function H55c_AI_AddHeroTargets(name, hero, player, list, ttype, ai)
	H55c_AI_error = "H55c_AI_AddHeroTargets";
	errorHook(H55c_AI_crash);
	H55c_AI_print(1, "Adding targets " .. ttype .. " for hero " .. name)
	for num, item in list do
		if IsHeroAlive(name) == nil then
			return
		end
		if ttype == "heroes" and IsHeroAlive(item) == nil then
			H55c_AI_print(2, "Skipping, hero is dead: " .. item);
		else
			H55c_AI_print(2, name .. " item: " .. num .. " - " .. item)
			local owner_status = pcall(GetObjectOwner, item);
			local place_status = pcall(GetObjectPosition, item);
			if owner_status ~= nil and place_status ~= nil then
				local owner = owner_status[1];
				if owner ~= player and ai.enemies[owner] and ai.enemies[owner].is_enemy == 1 then
					local x, y, z = place_status[1], place_status[2], place_status[3];
					local cost = 99999999;
					local p_cost = pcall(CalcHeroMoveCost,name,x,y,z);
					if p_cost == nil or p_cost[1] < 0 then
						local h55_cost = pcall(H55_GetDistance, name, item);
						if h55_cost ~= nil and h55_cost[1] > 0 then
							cost = h55_cost[1]*100;
						end
					else
						cost = p_cost[1];
					end
					local priority  = ai.enemies[owner].priority;
					local attractor = ai.enemies[owner][ttype];
					local result    = cost/(attractor*attractor);       -- adjust cost based on importance of the target type
					result          = result/priority;                  -- adjust cost based on priority to defeat the owner of the target
					H55_Insert(hero.weights, result);
					H55_Insert(hero.targets,   item);
					H55_Insert(  hero.types,  ttype);
				else
					H55c_AI_print(2, "Skipping: " .. item);
				end
			end
		end
	end
end

function H55c_AI_UpdateTargetWeight(player)
	H55c_AI_error = "H55c_AI_UpdateTargetWeight";
	H55c_AI_last_run_day = GetDate(ABSOLUTE_DAY)
	H55c_AI_run_during_player_turn = GetCurrentPlayer();
	errorHook(H55c_AI_crash);
	local ai = H55c_AI_CONTROLLED["player" .. player];
	if ai.state ~= 2 then return end
	H55c_AI_print(1, "updating weight for player " .. player)
	

	-- update hero list with the currently available roster
	H55c_AI_lists.heroes = GetObjectNamesByType("HERO");

	for name, hero in ai.heroes do
		if IsHeroAlive(name) == nil then
			ai.heroes[name] = nil;
			H55c_AI_print(2, "Hero is DEAD: " .. name)
		else
			H55c_AI_print(2, "Hero is ALIVE: " .. name)
			hero.weights = {};
			hero.targets = {};
			hero.types   = {};

			-- make a list of hero targets and choose one
			H55c_AI_AddHeroTargets(name, hero, player, H55c_AI_lists.heroes, "heroes", ai )
			H55c_AI_AddHeroTargets(name, hero, player, H55c_AI_lists.towns ,  "towns", ai )
			--H55c_AI_AddHeroTargets(name, hero, player, H55c_AI_lists.others, "others", ai )
			hero.current_target = H55c_AI_FindHeroTarget(name, hero, 10, 0);
		end
	end
end

function H55c_AI_main()
	H55c_AI_error = "H55c_AI_main";
	errorHook(H55c_AI_crash);
	H55c_AI_print(2, "============ START AI MAIN ============")
	while true do
		for i = 1, 8 do
			if H55c_AI_CONTROLLED["player"..i] ~= nil and H55c_AI_CONTROLLED["player"..i].state == 2 then
				pcall(startThreadOnce, H55c_AI_UpdateTargetWeight, i );
			end
		end
		sleep(30);
	end
end

-- ############### DEBUG functions ###############

function H55c_AIUpdate(player)
	H55c_AI_UpdateTargetWeight(player);
end

function H55c_AIReport(player)
	for name, hero in H55c_AI_CONTROLLED["player" .. player].heroes do
		--print("=== ".. name .. " ===");
		local message = name..": ";
		for w, _ in hero.targets do
			message = message .. hero.targets[w] .. "(".. hero.weights[w] .. ") | "
			--print(w..": ".. hero.targets[w] .. " = " .. hero.weights[w])
		end
		print(message);
		if hero.current_target == "Roam" then
			print("Hero Roaming")
		else
			local x, y, z = GetObjectPosition(hero.current_target);
			print("Hero going towards ".. hero.current_target .. " at " ..x .. "," .. y .. "," .. z)
		end
	end
end

function H55c_AIAddHero(...)
	local name = arg[1];
	H55c_AI_print(0, "Adding hero "..name);
	local player = GetObjectOwner(name)
	H55c_AI_CONTROLLED["player" .. player].heroes[name] = {
		weights = {},
		targets = {},
		types   = {},
		current_target = "Roam"
	}
  --H55c_AI_lists.others = others
	EnableHeroAI(  name, not nil);
	DenyAIHeroFlee(name, not nil);
end

function H55c_AIRemoveHero(...)
	local name = arg[1];
	H55c_AI_print(0, "Removing hero " .. name)
	if IsHeroAlive(name) == nil then
		return 
	end
	local player = GetObjectOwner(name)

	if H55c_AI_CONTROLLED["player" .. player] ~= nil then
		if H55c_AI_CONTROLLED["player" .. player].heroes ~= nil then
			H55c_AI_CONTROLLED["player" .. player].heroes[name] = nil
		end
	end
	pcall(H55c_AIResetMovement, name);
end

function H55c_AIResetMovement(name)
	EnableHeroAI(name, not nil);
	sleep(10);
	local x,y,z = GetObjectPosition(name);
	MoveHero(name, x, y, z);
end

function H55c_AIStats()
	print( "last updated on day ", H55c_AI_last_run_day, " during player ", H55c_AI_run_during_player_turn," turn." );
	print( H55c_AI_crash_counter," AI crashes so far. Last crash type at ", H55c_AI_error_stamp );
end
--
-- ###### Deprecated functions ########
--function H55c_AI_getMoveCost(name, hero)
--  local points = 0;
--  local result = pcall(CalcHeroMoveCost,name,x,y,z);
--  if result ~= nil then
--    points = result[1];
--  else
--    local towns = GetObjectNamesByType("TOWN");
--    for _, town in towns do
--
--    end
--   end
--end