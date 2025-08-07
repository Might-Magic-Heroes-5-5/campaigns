COMBAT = 9999;
THREAD = 9998;
WINDOW = 9997;

-- ====== How to use tutorials ======
--TutorialActivateHint( szID )
--TutorialSetBlink( szID, nOn )
--TutorialMessageBox( szID )
--IsTutorialMessageBoxOpen()
--
-- ====== How to reset tutorials from console ======
--consoleCmd("setvar Options.Tutorial.Blink.end_of_turn_blink = 0")

function manageTutorials(list)
	while true do
    sleep(5);
    if IsTutorialEnabled() then
     	SetGameVar( "temp.tutorial", 1 );
    else
     	SetGameVar( "temp.tutorial", 0 );
    end
    
		for _, item in list do
      local id          = item[1];
      local triggerType = item[2];
      local object      = item[3];
      local action      = item[4];
      local state       = item[5];

			if IsTutorialItemEnabled( id ) then
				if (state == 0) then
					if triggerType == COMBAT then
						SetGameVar( "temp." .. id, 1 );
					elseif triggerType == THREAD then
						startThreadOnce( loadstring(action .. "()"));
          elseif triggerType == WINDOW then
            pcall(TutorialActivateHint, id )
          elseif triggerType == PLAYER_REMOVE_HERO_TRIGGER then
            pcall(Trigger, triggerType, object, action);
          elseif triggerType == REGION_ENTER_AND_STOP_TRIGGER then
            pcall(Trigger, triggerType, object, action );
          else
            if Exists(object) then
              pcall(Trigger, triggerType, object, "startThreadOnce(" ..action .. ")" );
            end
          end
          item[5] = 1;
				end
			else
				if (state == 1) then
					if triggerType == COMBAT then
						SetGameVar( "temp." .. id, 0 );
          elseif triggerType == THREAD or triggerType == WINDOW then
             -- do nothing
					else
            if Exists(object) then
              pcall(Trigger, triggerType, object, nil);
            end
          end
          item[5] = 0;
        end
      end
    end
  end
end

__threads = {};
function startThreadOnce( func, p1, p2, p3 )
	if __threads[ func ] then
		return
	end
	newfunc = function()
		%func( %p1, %p2, %p3);
		__threads[ %func ] = nil;
	end
	__threads[ func ] = newfunc;
	startThread( newfunc );
end

function _fog()
    OpenCircleFog(0, 0, 0, 9999, PLAYER_1);
end

creature_costs =
{  15,  25,   50,  80,   85,  130,   250, 370, 600, 850, 1300, 1700, 2800, 3500, -- haven
	 25,  45,   40,  60,  110,  160,   240, 350, 550, 780, 1400, 1666, 2666, 3666, -- inferno
	 19,  30,   40,  60,  100,  140,   250, 380, 620, 850, 1400, 1700, 1600, 1900, -- undead
	 35,  55,   70, 120,  120,  190,   320, 440, 630, 900, 1100, 1400, 2500, 3400, -- sylvan
	 22,  35,   45,  70,  100,  150,   250, 340, 460, 630, 1400, 1700, 2700, 3300, -- academy
	 60, 100,  125, 175,  140,  200,   300, 450, 550, 800, 1400, 1700, 3000, 3700, -- dungeon
  400, 400,  400, 400, 1200, 1200, 10000,                                        -- neutrals
	 24,  40,   45,  65,  130,  185,   160, 220, 470, 700, 1300, 1700, 2700, 3400, -- fortress
 	 25,  80,  130, 370,  850, 1700,  3500,                                        -- haven alts
  150, 350, 1800, 900,                                                           -- a1 neutrals
	 10,  20,   50,  70,   80,  120,   260, 360, 350, 500, 1250, 1600, 2900, 3450, -- stronghold
	 45,  60,  160, 350,  780, 1666,  3666,                                        -- inferno alts
	100, 175,  200, 450,  800, 1700,  3700,                                        -- dungeon alts
	 55, 120,  190, 440,  900, 1400,  3400,                                        -- sylvan alts
	 30,  60,  140, 380,  850, 1700,  1900,                                        -- necro alts
	 35,  70,  150, 340,  630, 1700,  3300,                                        -- academy alts
	 40,  65,  185, 220,  700, 1700,  3400,                                        -- fortress alts
	 20,  70,  120, 360,  500, 1600,  3450 };                                      -- stronghold alts

function CalcArmy( heroname )
	total = 0;
	for i = 1, CREATURES_COUNT-1 do
    if creature_costs[i] ~= nil then
		  total = total + GetHeroCreatures( heroname, i ) * creature_costs[i];
    end
	end
	return total;
end

function IsAnyHeroPlayerHasCreature( playerID, creatureID )
	local heroes = {};
	local m, h;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if GetHeroCreatures( h, creatureID ) > 0 then
			print( "hero ", h, " has ", creatureID );
    		return not nil;
	    end
	end
	return nil;
end