-- ##### _AI_debug #####
-- 0: no debug prints
-- 1: prints target
-- 2: prints message for each computed func so error debug is easier
_AI_debug = 0;

-- ##### How to use #####
--Add this to map script.
--
--startThread( AI_main )
--
-- ##### How to configure ######

-- The following array denotes the attractor values for all non human players controlled by the LUA-AI
-- player1, player2, player3 is the info for that player heroes and their targers. Set it in your map lua file.
--AI_CONTROLLED = {
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

_ai_lists = {
  towns = GetObjectNamesByType("TOWN"),
  heroes = GetObjectNamesByType("HERO"),
}

function _AI_print(mode, message)
    if _AI_debug >= mode then
      print(message);
    end
end

function _AI_MostImportantTarget(hero, ignore_threshold)
    local minIndex, minValue = 0, math.huge;
    for i, value in hero.weights do
      if value > ignore_threshold and value <= minValue then
        minIndex = i;
        minValue = value;
        _AI_print(4, ignore_threshold .. " | " .. i .. ": " .. value .. " | " .. hero.targets[i]);
      end
    end
    return minIndex, minValue
end

function _AI_roamHero(name)
    -- two lines are required to unbind AI hero target before release it in roaming mode
    if IsHeroAlive(name) == nil then
      return
    end
    _AI_print(1, "Activate ROAMING mode for ".. name);
    local x, y, z = GetObjectPosition(name);
    MoveHero(name, x, y, z);
    EnableHeroAI(name, not nil);
end

function _AI_SetHeroTarget(name, hero, idx)
   target = hero.targets[idx];
   if target == nil then
      return 0
   end
   _AI_print(2, "Set hero target: " .. target)
  local status, result;

  if hero.types[idx] == "towns" then
    status, result = pcall(H55_AttackTown, name, target);
  else
    local x,y,z = GetObjectPosition(target);
    status, result = pcall(MoveHero, name, x, y, z);
  end
  if status then
    _AI_print(1, target .. ": Found!");
    return target;
  end
  _AI_print(1, target .. ": Blocked;");
  return 0;
end

function _AI_FindHeroTarget(name, hero, tries_left, threshold)
  _AI_print(2, "try: ".. tries_left)

  if table.length(hero.targets) == 0 or tries_left == 0 then
    _AI_roamHero(name);
      return "Roam"
  end

  local idx, value = _AI_MostImportantTarget(hero, threshold)
  local choice = _AI_SetHeroTarget(name, hero, idx)
  if choice == 0 then
    choice = _AI_FindHeroTarget(name, hero, tries_left-1, value)
  end
  return choice
end

function _AI_AddHeroTargets(name, hero, player, list, ttype, ai)
    _AI_print(1, "Adding targets " .. ttype .. " for hero " .. name)
    for num, item in list do
      if IsHeroAlive(name) == nil then
        return
      end
      _AI_print(2, name .. " item: " .. num .. " - " .. item)
      local owner_status = pcall(GetObjectOwner, item);
      local place_status = pcall(GetObjectPosition, item);
      if owner_status ~= nil and place_status ~= nil then
        local owner = owner_status[1];
        if owner ~= player and ai.enemies[owner].is_enemy == 1 then
          local x, y, z = place_status[1], place_status[2], place_status[3];
          local cost = 0;
          local p_cost = pcall(CalcHeroMoveCost,name,x,y,z);
          if p_cost == nil or p_cost[1] < 0 then
              cost = H55_GetDistance(name, item)*100
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
        end
      end
    end
end

function _AI_UpdateTargetWeight(player)
  if AI_CONTROLLED["player" .. player].state ~= 2 then return end
  _AI_print(1, "updating weight for player " .. player)
  local ai = AI_CONTROLLED["player" .. player];

  -- update hero list with the currently available roster
  _ai_lists.heroes = GetObjectNamesByType("HERO");

  for name, hero in ai.heroes do
    if IsHeroAlive(name) == nil then
      ai.heroes[name] = nil;
      _AI_print(2, "Hero is DEAD: " .. name)
    else
      _AI_print(2, "Hero is ALIVE: " .. name)
      hero.weights = {};
      hero.targets = {};
      hero.types   = {};

      -- make a list of hero targets and choose one
      _AI_AddHeroTargets(name, hero, player, _ai_lists.heroes, "heroes", ai )
      _AI_AddHeroTargets(name, hero, player, _ai_lists.towns ,  "towns", ai )
      hero.current_target = _AI_FindHeroTarget(name, hero, 10, 0);
    end
  end
end

function AI_main()
  _AI_print(2, "============ START AI MAIN ============")
  last_updated_player = 0;
  while true do
    for i = 1, 8 do
      _AI_print(5, "==== AI: state for player " .. i)
      if IsPlayerCurrent( i ) and i ~= last_updated_player then
        _AI_print(4, "==== AI: Starting thread for player " .. i)
        startThreadOnce( _AI_UpdateTargetWeight,  i );
        last_updated_player = i;
      end
    end
    sleep(5)
  end
end

function _AI_report(player)
  for name, hero in AI_CONTROLLED["player" .. player].heroes do
    print("=== ".. name .. " ===");
    for w, _ in hero.targets do
      print(w..": ".. hero.targets[w] .. " = " .. hero.weights[w])
    end
    if hero.current_target == "Roam" then
      print("Hero Roaming")
    else
      local x, y, z = GetObjectPosition(hero.current_target);
      print("Hero going towards ".. hero.current_target .. " at " ..x .. "," .. y .. "," .. z)
    end
  end
end

function ADD_ASSAULT_HERO(name)
  local player = GetObjectOwner(name)
  AI_CONTROLLED["player" .. player].heroes[name] = {
      weights = {},
      targets = {},
      types   = {},
      current_target = "Roam"
  }
  EnableHeroAI(  name, 1);
  DenyAIHeroFlee(name, 1);
end
      
function _AI_update(player)
   _AI_UpdateTargetWeight(player);
end

--
-- ###### Deprecated functions ########
--function _AI_getMoveCost(name, hero)
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