function AgraelDefeated()
	print("Thread AgraelDefeated has been started...");
	while 1 do
		sleep(2);
		AgraelCreatures = {};
		if GetHeroName(GetAttackerHero()) == "Agrael" then
			AgraelCreatures = GetAttackerCreatures();
		else
			AgraelCreatures = GetDefenderCreatures();
		end;
		local len = table.length(AgraelCreatures);
		DefeatCondition = TimeToDefeat();
		if DefeatCondition == 1 then
			print("Agrael does not have any creatures. :(");
			sleep(15);
			--if GetHeroName(GetAttackerHero()) == "Veyer" then
				--print("Attacker is Veyer. Agrael win");
				--addUnit(CREATURE_FAMILIAR,1,3,3,1,"imp");
				--Finish(DEFENDER);
			--else
				--print("Attacker is Agrael. Agrael win");
				--addUnit(CREATURE_FAMILIAR,0,3,3,1,"imp");
				--Finish(ATTACKER);
			--end;
			SetGameVar("C2M2_VeyerDefeated",1);
			Break();			
			return
		end;
	end;
end;

function AgraelWin()
	print("Thread AgraelWin has been started...");
	while 1 do
		sleep(2);
		VeyerCreatures = {};
		if GetHeroName(GetAttackerHero()) == "Agrael" then
			VeyerCreatures = GetDefenderCreatures();
		else
			VeyerCreatures = GetAttackerCreatures();
		end;
		local len = table.length(VeyerCreatures);
		if len == 0 then
			print("Veyer does not have any creatures. :(");
			sleep(15);
			--if GetHeroName(GetAttackerHero()) == "Veyer" then
				--print("Attacker is Veyer. Agrael win");
				--Finish(DEFENDER);
				--else
				--print("Attacker is Agrael. Agrael win");
				--Finish(ATTACKER);
			--end;
			SetGameVar("C2M2_VeyerDefeated",1);
			Break();
			return
		end;
	end;
end;

function SummonedCreaturesAttacker()
	print("Thread SummonedCreaturesAttacker has been started...");
	InitialCreaturesArray = {};
	SummonedCreaturesArray = {};
	l = 0;
	while 1 do
		InitialCreaturesArray = GetAttackerCreatures();
		sleep(10);
		TempArray = {};
		if table.length(GetAttackerCreatures()) > table.length(InitialCreaturesArray) then
			print("Hero has summoned creature");
			TempArray = GetAttackerCreatures();
			TempArray = ConcatArray(TempArray,InitialCreaturesArray);
			for i = 1,table.length(TempArray) do
				k = 0;
				for j = 1,table.length(TempArray) do
					if TempArray[i] == TempArray[j] then
						k = k + 1;
					end;
				end;
				if k == 1 then
					print("Summoned creature is ", TempArray[i]);
					l = l + 1;
					SummonedCreaturesArray[l] = TempArray[i];
					break;
				end;
			end;
		end;		
	end;
end;

function SummonedCreaturesDefender()
	print("Thread SummonedCreaturesDefender has been started...");
	InitialCreaturesArray = {};
	SummonedCreaturesArray = {};
	l = 0;
	while 1 do
		InitialCreaturesArray = GetDefenderCreatures();
		sleep(10);
		TempArray = {};
		if table.length(GetDefenderCreatures()) > table.length(InitialCreaturesArray) then
			print("Hero has summoned creature");
			TempArray = GetDefenderCreatures();
			TempArray = ConcatArray(TempArray,InitialCreaturesArray);
			for i = 1,table.length(TempArray) do
				k = 0;
				for j = 1,table.length(TempArray) do
					if TempArray[i] == TempArray[j] then
						k = k + 1;
					end;
				end;
				if k == 1 then
					print("Summoned creature is ", TempArray[i]);
					l = l + 1;
					SummonedCreaturesArray[l] = TempArray[i];
					break;
				end;
			end;
		end;		
	end;
end;

function TimeToDefeat()
	if GetHeroName(GetAttackerHero()) == "Agrael" then
		CurrentCreatures = GetAttackerCreatures();
	else
		CurrentCreatures = GetDefenderCreatures();
	end;
	z = 0;
	for i = 0,table.length(CurrentCreatures) - 1 do
		for j = 1,table.length(SummonedCreaturesArray) do
			if CurrentCreatures[i] == SummonedCreaturesArray[j] then
				z = z + 1;
				break;
			end;
		end;
	end;
	if z == table.length(CurrentCreatures) then
		print("Time to defeat");
		return 1;
	else
		return 0;
	end;
end;


function ConcatArray( array1, array2 )
local cnt;
local num = table.length(array1);
local arr = {};

	if ( num == nil ) then
		num = 0;
	end;
	
	if ( num > 0 ) then
		for cnt = 1, num do
			arr[cnt] = array1[cnt];
		end;
		arr.n = table.length(array1);
	end;
	
	if ( array2 == nil ) or ( table.length(array2) == 0 ) then
		return arr;
	end;

	for cnt = 1, table.length(array2) do
		arr[cnt + num] = array2[cnt];
	end;
	
	arr.n = num + table.length(array2);
	return arr;
end;



if GetAttackerHero() ~= nil and GetDefenderHero() ~= nil then
	print("This combat between hero and hero");
if GetHeroName(GetAttackerHero()) == "Veyer" or GetHeroName(GetDefenderHero()) == "Veyer" then
	print("Final combat has begun");
	EnableAutoFinish(nil);
	while combatStarted() == nil do
		sleep(1)
	end;
	startThread(AgraelDefeated);
	startThread(AgraelWin);
	if GetHeroName(GetAttackerHero()) == "Agrael" then
		startThread(SummonedCreaturesAttacker);
	else
		startThread(SummonedCreaturesDefender);
	end;
	else
	print("It is not final combat");
	end;
end;