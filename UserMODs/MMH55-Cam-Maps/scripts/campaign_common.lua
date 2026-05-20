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
		if IsTutorialEnabled() == nil then
			SetGameVar( "temp.tutorial", 0 );
		else
			SetGameVar( "temp.tutorial", 1 );
			local has_changed = nil;
			local loop = 1;
			local idx = 1;
			local temp_array = {};
			local debug_count = 0;
			for _, item in list do
				debug_count = debug_count + 1;
			end
			--print(debug_count);	
			for _, item in list do
				local id          = item[1];
				local triggerType = item[2];
				local object      = item[3];
				local action      = item[4];
				local state       = item[5];
				
				
				if IsTutorialItemEnabled(id) == nil or state == 2 then
					item[5] = 2;
					--print("Removed: ",list[loop][1]);
					has_changed = not nil;
				else
					temp_array[idx] = item;
					idx = idx + 1;
					if state == 0 then
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
						elseif Exists(object) then
							pcall(Trigger, triggerType, object, "startThreadOnce(" ..action .. ")" );
						end
						item[5] = 1;
					elseif state == 1 then
						if triggerType == COMBAT then
							SetGameVar( "temp." .. id, 0 );
						elseif triggerType == THREAD or triggerType == WINDOW then
							-- do nothing
						elseif Exists(object) then
							pcall(Trigger, triggerType, object, nil);
						end
						item[5] = 0;
					end
				end
				loop = loop + 1;
			end
			
			if has_changed == not nil then
				list = temp_array;
			end
		end
		sleep(30);
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

function ObjectiveExp(HeroName)
	sleep(50);
	local ToLevel = GetExpToLevel(GetHeroLevel(HeroName)+1);
	local delta = (ToLevel - GetHeroStat(HeroName, STAT_EXPERIENCE)) / 2;
	print("delta = ", delta);
	if delta >= 0 then
		ChangeHeroStat(HeroName, STAT_EXPERIENCE,delta);
	else
		print("Warning! Delta is negative. Hero gain 100 exp");
		ChangeHeroStat(HeroName, STAT_EXPERIENCE,100);
	end
	print("Now ",HeroName, " has ", GetHeroStat(HeroName, STAT_EXPERIENCE)," exp");
end

function GetExpToLevel( j )
	local a = 1;
	if j >= 30 then a = 30 else a = j end;
	local sum;      --LEVEL 1 2    3    4    5    6    7    8     9     10    11    12
	ExpArrayLess12 = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
	ExpArrayLess12.n = 12;
					--LEVEL 13    14    15    16    17    18    19    20    21    22     23     24
	ExpArrayMore12 = {24320,28784,34141,40569,48283,57539,68647,81977,97972,117166,140200,167839};
	ExpArrayMore12.n = 12;
					--LEVEL 25     26     27     28     29     30     31      32      33      34
	ExpArrayMore25 = {201007,244126,304491,395040,539917,786208,1229533,2071000,3756484,7294215};
	ExpArrayMore25.n = 10;
	if a <= 12 then
		sum = ExpArrayLess12[a];
	else
		if a < 25 then
			sum = ExpArrayMore12[a-12];
		else
			if a < 35 then
				sum = ExpArrayMore25[a-24];
			else
				print("Das ist fantastisch!!!");
				sum = 0;
			end
		end
	end
	print("Hero need ", sum, " experience to gain level ",a);
	return sum;
end

function remove_element(element_name,array_name)
	local j=1 --индекс временного массива
	local a={}
	for i, h in array_name do
		if array_name[i] ~= element_name
			then
				a[j]=array_name[i];
				j=j+1;
			else
		end
	end
	array_name={}
	array_name=a
	return array_name
end

function IsAnyHeroPlayerHasArtifact( playerID, artifID )
	local heroes = {};
	local m = 0;
	local h = 0;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if HasArtefact( h, artifID ) then
			return not nil;
	    end
	end
	return nil
end

function PlayVoiceoverAndBlockGame( voiceoverName )
	BlockGame();
	Play2DSound( voiceoverName );
	sleep( GetSoundTimeInSleeps( voiceoverName ) )
	UnblockGame();
end

function H55c_updateArmy(hero, gain, list, ...)
	for i = 1, table.length(list) do
		local count = GetHeroCreatures( hero, list[i] );
		local new_count = count * gain;
		if arg[1] ~= nil then
			new_count = arg[1][i] * gain;
		end
		if new_count > 0 then
			AddHeroCreatures( hero, list[i], new_count );
		end
		if new_count > count + 2 and count > 0 then
			RemoveHeroCreatures( hero, list[i], count );
		end
	end
end

-- ### LUA Multiclicker guard
H55c_LUA = {
	busy = nil,
	cooldown = 60,
  
	guard = function()
	    if H55c_LUA.busy ~= nil then return not nil end;
		H55c_LUA.busy = not nil;
		startThread(H55c_LUA.timeout);
		return nil;
	end,

	timeout = function()
		sleep(H55c_LUA.cooldown);
		H55c_LUA.busy = nil;
	end
}

function H55c_debug()
	if OBJECTIVES.date == GetDate(ABSOLUTE_DAY) then
		print("Campaign script is running");
	else
		local delta = GetDate(ABSOLUTE_DAY) - OBJECTIVES.date
		print("Campaign not been running for ",delta," days. Last run was on day ",OBJECTIVES.date);
	end
	
	for k, v in OBJECTIVES.state do
		print(k,"[",v[1],"] = ",v[2]);
	end
end

function LoadAndBindHeroAllSetArtifacts( hero, loadFromMissionName )
	for i = 0, AllSetArtifactsCount - 1 do
		local artefactIdString = '_'..AllSetArtifacts[i];
		if GetGameVar(loadFromMissionName..'_'..hero..artefactIdString) == "1" then
			GiveArtefact(hero, AllSetArtifacts[i], 1);
		end;
	end;
end;

H55c_CREATURES = {
	HAVEN      = {   1,   2, 106,   3,   4, 107,   5,   6, 108,   7,   8, 109,   9,  10, 110,  11,  12, 111,  13,  14, 112 },
	INFERNO    = {  15,  16, 131,  17,  18, 132,  19,  20, 133,  21,  22, 134,  23,  24, 135,  25,  26, 136,  27,  28, 137 },
	STRONGHOLD = { 117, 118, 173, 119, 120, 174, 121, 122, 175, 123, 124, 176, 125, 126, 177, 127, 128, 178, 129, 130, 179 },
}
