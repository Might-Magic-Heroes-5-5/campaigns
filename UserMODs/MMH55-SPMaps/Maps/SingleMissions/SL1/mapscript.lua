objects = {"o1", "o2", "o3", "o4", "o5", "o6", "o7", "o8", "o9"};
diff = 0


SetRegionBlocked("at1", not nil, PLAYER_2);
SetRegionBlocked("at2", not nil, PLAYER_2);
SetRegionBlocked("at3", not nil, PLAYER_2);
SetRegionBlocked("at4", not nil, PLAYER_2);

function diffcheck()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 0.5;
		print ("easy");
		startThread(diffsetup);
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 1;
		print ("normal");
		startThread(diffsetup);
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 2;
		print ("Hard");
		startThread(diffsetup);
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 3;
		print ("Impossible");
		startThread(diffsetup);
	end;
end;


function diffsetup()
	for i, object in objects do
		for creatureID = 1, 91 do 
			CreatureSetUp = GetObjectCreatures(object, creatureID);
			if GetObjectCreatures(object, creatureID) > 2 then
				RemoveObjectCreatures(object, creatureID, CreatureSetUp);
				AddObjectCreatures(object, creatureID, CreatureSetUp * diff);
			end;	
		end;
	end;
end;

function objectives()
	StartDialogScene("/DialogScenes/Single/SL1/R1/DialogScene.xdb#xpointer(/DialogScene)");
	if GetObjectiveState("obj1")==OBJECTIVE_UNKNOWN then
		SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
	end;
	if GetObjectiveState("obj2")==OBJECTIVE_UNKNOWN then 
		SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
	end;
	if GetObjectiveState("obj3")==OBJECTIVE_UNKNOWN then
		SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
	end;
end;


function am()
	while 1 do
		local heroes = GetPlayerHeroes(PLAYER_1);
		local count = 0
		h = "Maahir";
		if HasArtefact(h, ARTIFACT_RING_OF_MAGI) then
			count = count + 1;
		end;
		if HasArtefact(h, ARTIFACT_CROWN_OF_MAGI) then
			count = count + 1;
		end;
		if HasArtefact(h, ARTIFACT_ROBE_OF_MAGI) then
			count = count + 1;
		end;
		if HasArtefact(h, ARTIFACT_STAFF_OF_MAGI) then
			count = count + 1;
		end;			
		if count < 4 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			startThread (objective_1);
		end;
	sleep(3);
	end;
end;	


function objective_1()
while 1 do
	local heroes = {};
	local m = 0;
	local h = 0;
	local count = 0;
	heroes = GetPlayerHeroes(PLAYER_1);
	--for m, h in heroes do
		h = "Maahir";
		if HasArtefact(h, ARTIFACT_RING_OF_MAGI) then
			count = count + 1;
	   	end;
		if HasArtefact(h, ARTIFACT_CROWN_OF_MAGI) then
			count = count + 1;
	   	end;
		if HasArtefact(h, ARTIFACT_ROBE_OF_MAGI) then
			count = count + 1;
	   	end;
		if HasArtefact(h, ARTIFACT_STAFF_OF_MAGI) then
			count = count + 1;
	   	end;
	--end;
	local sl = GetPlayerHeroes(PLAYER_1);
	local res
	if count == 4 then
		print("Player 1 has all artifacts ");
		SetObjectiveState("obj1",OBJECTIVE_COMPLETED);
		startThread (am);
		break;
	end;
sleep(5);
end;	
end;

function reward_obj1()
	while 1 do
		local count = 0
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
			count = count + 1;
		end;
		local sl
		local res
		heroes = GetPlayerHeroes(PLAYER_1)
		res = GetPlayerResource(PLAYER_1, GOLD) + 10000
		if count == 1 then
			SetPlayerResource(PLAYER_1, GOLD, res);
			LevelUpHero("Maahir");
			break;
		end;
	sleep(3);
	end;
end;


function objective_2()
	while 1 do
		if IsHeroAlive("Aberrar")==nil then
			SetObjectiveState("obj2",OBJECTIVE_COMPLETED);
			break;
		end;
	sleep(5);
	end;
end;	

function winner()
	while 1 do
		if GetObjectiveState("obj1")==OBJECTIVE_COMPLETED and GetObjectiveState("obj2")==OBJECTIVE_COMPLETED then
			StartDialogScene("/DialogScenes/Single/SL1/R8/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
			sleep(5);
			Win();
			break;
		end;
	sleep(3)
	end;
end;	

function Looser()
	while 1 do	
		if IsHeroAlive("Maahir")==nil then	
			Loose();
			break
		end;
		sleep(10)
	end;
end;

--------------------TT----------------------

function as1()
while 1 do
	if HasArtefact("Maahir", 44) then
		print("Maahir has robe");
		StartDialogScene("/DialogScenes/Single/SL1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		break;
	end;
sleep(3);
end;
end;

function as2()
while 1 do	
	if HasArtefact("Maahir", 46) then
		print("Maahir has crown");
		StartDialogScene("/DialogScenes/Single/SL1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		break;
	end;
sleep(3);	
end;	
end;

function as3()
while 1 do	
	if HasArtefact("Maahir", 45) then
		print("Maahir has staff");
		StartDialogScene("/DialogScenes/Single/SL1/R4/DialogScene.xdb#xpointer(/DialogScene)");
		break;
	end;
sleep(3);	
end;	
end;

function as4()
while 1 do
	if HasArtefact("Maahir", 47) then
		print("Maahir has ring");
		StartDialogScene("/DialogScenes/Single/SL1/R5/DialogScene.xdb#xpointer(/DialogScene)");
		break;
	end;
sleep(3);	
end;	
end;

---------------Artifact Check--------------------


function ac()
	while 1 do
		local artifacts = { "a4", "a2", "a1", "a3" };
		local artifacts1 = { ARTIFACT_RING_OF_MAGI, ARTIFACT_CROWN_OF_MAGI, ARTIFACT_ROBE_OF_MAGI, ARTIFACT_STAFF_OF_MAGI };
		local heroes = GetPlayerHeroes(PLAYER_1);
		sleep( 3 );
		for i, art in artifacts do
			local has = 0;
			if IsObjectExists( art )==nil then
				for j, hero in heroes do
					if HasArtefact( hero, artifacts1[i] ) then
						has = 1;
						break;
					end;
				end;
				if has == 0 then
					MessageBox("/Maps/SingleMissions/SL1/message.txt");
					sleep(3);
					SetObjectiveState("obj1", OBJECTIVE_FAILED);
					sleep(3);
					Loose();
					break;
				end;
			end;
		end;
	end;
end;


diffcheck();
objectives();
startThread (reward_obj1);
startThread (objective_1);
startThread (objective_2);
startThread (winner);
startThread (Looser);
startThread (ac);
startThread (as1);
startThread (as2);
startThread (as3);
startThread (as4);