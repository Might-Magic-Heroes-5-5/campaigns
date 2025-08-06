H55_PlayerStatus = {0,1,2,2,2,2,2,2};

--- Забираем у игрока все ресурсы, кроме бабла - чтобы жизнь медом не казалась.
for res_count=0,5,1 do
	SetPlayerResource(PLAYER_1, res_count, 0);
end;
SetPlayerResource(PLAYER_1, 6, 10000);
------- DEMON THIEF ARMY DEPENDANCE OF GAME DIFFICULTY-----
ArmyMult = 0;
Diff = GetDifficulty ();
print ('Slojnost: ', Diff);
if Diff == DIFFICULTY_HARD then ArmyMult = 1; end;
if Diff == DIFFICULTY_HEROIC then ArmyMult = 2; end;
------- DAY OF OPENING PATH FOR DEMON HEROES --------------
DayOfInvasion = 16;
if Diff == DIFFICULTY_HARD then DayOfInvasion = 14; end;
if Diff == DIFFICULTY_HEROIC then DayOfInvasion = 12; end;
-----------------------------------------------------------
if Diff == DIFFICULTY_EASY and IsObjectExists('Manes') then RemoveObject('Manes'); end;
if Diff == DIFFICULTY_NORMAL and IsObjectExists('Manes') then RemoveObject('Manes'); end;
-----------------------------------------------------------
	
StartDialogScene("/DialogScenes/Single/SM6/R1/DialogScene.xdb#xpointer(/DialogScene)")

SetRegionBlocked('DemonBorder1', not nil, PLAYER_2);
SetRegionBlocked('DemonBorder2', not nil, PLAYER_2);
SetRegionBlocked('ElfDwelling', not nil, PLAYER_2); -- ne dadim demonu nanimat elfov


Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim1', 'CastleTaken');
function CastleTaken ()
	sleep (4);
	DemonThiefAppears ();
end;
function DemonThiefAppears ()
		SetObjectiveState  ('prim2', OBJECTIVE_ACTIVE);
		DeployReserveHero('Grok', RegionToPoint('Portal'));
		if IsObjectExists('SukBarrier') then RemoveObject('SukBarrier'); end;
		if IsObjectExists('DemonBarrier') then RemoveObject('DemonBarrier'); end;
		if IsObjectExists('Druids') then RemoveObject('Druids'); end;
		sleep (5);
		EnableHeroAI('Grok', not nil); --H55 fix
		if ArmyMult > 0 then
		 AddHeroCreatures('Grok', CREATURE_PIT_FIEND, 1*ArmyMult); --- PIT FIENDS
		 AddHeroCreatures('Grok', CREATURE_CERBERI, 4*ArmyMult); --- CERBERI
		 AddHeroCreatures('Grok', CREATURE_NIGHTMARE, 2*ArmyMult); --- HELL CHARGERS
		 AddHeroCreatures('Grok', CREATURE_HORNED_DEMON, 16*ArmyMult); --- HORNED DEMONS
		end;
		if Diff == DIFFICULTY_EASY then -- na urovne slojnosti EASY ubiraem polovinu voysk Groka
		 DemonHalfArmy ('Grok');
		end;
	BlockGame();
		x, y, z = RegionToPoint('BowPlace');
		OpenCircleFog(x, y, z, 9, PLAYER_1);
		MoveCamera(x, y, z, 50, 3.14/4, 0);
		x, y, z = RegionToPoint('PortalCenter');
		OpenCircleFog(x, y, z, 3, PLAYER_1);
		 MoveHeroRealTime ('Grok', RegionToPoint('BowPlace'));
		sleep (55);
	UnblockGame();
-- opening location of the Bow
		Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'DemonThiefDie');		
end;


----------------------------DEMON-THIEF AND HIS RUN-------------------------------------
Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'BowPlace', 'DemonTakeBow')
function DemonTakeBow (heroname)
   if heroname == 'Grok' then
	sleep (10);	
	print ('Demon take bow. TAKE BOW I SAD!');	
	sleep (5);
	StartDialogScene("/DialogScenes/Single/SM6/R2/DialogScene.xdb#xpointer(/DialogScene)")
	sleep (5);
	GiveArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW,not nil);
	if IsObjectExists('Bow') then RemoveObject('Bow'); end;
--	EnableHeroAI('Grok', not nil);
--	SetAIHeroAttractor('Portal', 'Grok', 2); -- *)$&)$&)$&$)$&!@**+#*?????
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'NearPortal', 'ComeToPortal')
	MoveHero('Grok', RegionToPoint ('InfernoNearHome'));
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'InfernoNearHome','RoadToInfernoPartTwo')
	x, y, z = RegionToPoint('InfernoHome');
	OpenCircleFog(x, y, z, 5, PLAYER_1);
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'BowPlace', nil);
	ChangeHeroStat ('Orrin', STAT_EXPERIENCE, 2500);	
	if Diff == DIFFICULTY_EASY then startThread(TriggerPlayer); end; -- zapusk threada pro zamedlenie
	if Diff == DIFFICULTY_NORMAL then startThread(TriggerPlayer); end; -- zapusk threada pro zamedlenie
	end;
end;

function ComeToPortal (heroname)
	print ('Come to potral');
	if heroname == 'Grok' then
		--EnableHeroAI('Grok', nil);
		print ('Disable grok');
		ChangeHeroStat ('Grok', STAT_MOVE_POINTS,-100000); --Stop GRok
 		--sleep (1);
		--MoveHero ('Grok', RegionToPoint ('Portal'));
		Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'NearPortal', nil);
--		Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Portal', 'PortalDestroy')
	end;
end;
--function PortalDestroy (heroname) --(ne)Unichtojaem portal, zabiraem hod u Groka, otpravlayem ego domoy
--	print ('Destroy portal');
--	if heroname == 'Grok' then
--		print ('Stop grok!!');
--		ChangeHeroStat ('Grok', STAT_MOVE_POINTS,-100000);
		--MoveHero('Grok', RegionToPoint ('InfernoNearHome'));
--		Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Portal', nil);
--		SetAIHeroAttractor('Portal', 'Grok', 0);
--		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Brod','Part1brod');
--		SetAIHeroAttractor('Brod_Obj', 'Grok', 2);
--		print ('portal - next waypoint - brod');				
--	end;
--end;

--function Part1brod (heroname)
--	print ('part1-brod');
---	if heroname == 'Grok' then
--		print ('brod - next waypoint - crossroad');		
--		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Brod',nil);
--		SetAIHeroAttractor('Brod_Obj', 'Grok', 0);
--		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Crossroad','Part2crossroad');
--		SetAIHeroAttractor('Crossroad_Obj', 'Grok', 2);
--	end;		
--end;
--function Part2crossroad (heroname)
--	print ('part2');
--	if heroname == 'Grok' then
--		print ('crossroad - next waypoint - garnison');
--		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Crossroad',nil);
--		SetAIHeroAttractor('Crossroad_Obj', 'Grok', 0);
--		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoNearHome','RoadToInfernoPartTwo')
--		SetAIHeroAttractor('WestGarnison', 'Grok', 2);
--	end;		
--end;

function RoadToInfernoPartTwo (heroname) -- prohodim cherez garnizon
	if heroname == 'Grok' then
		SetRegionBlocked('DemonBorder2', nil, PLAYER_2);
		--ChangeHeroStat ('Grok', STAT_MOVE_POINTS,-100000);
		--EnableHeroAI('Grok', nil);
		sleep (3);
		MoveHero('Grok', RegionToPoint ('InfernoHome'));
		--SetAIHeroAttractor('InfernoCastle', 'Grok', 2);
		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoNearHome', nil)
	end;
end;

Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoHome', 'BringBowToInferno');
function BringBowToInferno (heroName)
	if (heroName == 'Grok') and HasArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW) then
    StartDialogScene("/DialogScenes/Single/SM6/R4/DialogScene.xdb#xpointer(/DialogScene)")
	Loose ();
	end;
end;
----------------------------DEATH-OF-DEMON-THIEF-------------------------------------------
function DemonThiefDie (whodie, whydie)
	if whodie == 'Grok' then
		print ('GRok is dead');
		if IsObjectExists ('Bow') == not nil then
			MessageBox ("/Maps/SingleMissions/SM6/GrockIsDead.txt");
			print ('GRok died without bow');
			RemoveObject('Bow');
			GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW,not nil);	
			TakeBow ();			
		elseif whydie == nil then
			print ('Grok was killed by mobs');
			MessageBox ("/Maps/SingleMissions/SM6/GrockIsDead.txt");
			GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW,not nil);	
			TakeBow ();
		elseif whydie == 'Orrin' then
			print ('Grok was killed by Orrin');
			ChangeHeroStat ('Orrin', STAT_EXPERIENCE, 3500);
			TakeBow ();
		else print ('Grok was killed by other hero ', whydie);
			sleep (2);
			RemoveArtefact(whydie, ARTIFACT_UNICORN_HORN_BOW,not nil);	
			GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW,not nil);	
			TakeBow ();
		end;
	end;		
end;

function TakeBow ()
    StartDialogScene("/DialogScenes/Single/SM6/R3/DialogScene.xdb#xpointer(/DialogScene)")
	sleep (2);
	SetObjectiveState  ('prim2', OBJECTIVE_COMPLETED);
	SetObjectiveState  ('prim3', OBJECTIVE_ACTIVE);
	SetObjectiveState  ('fake_objective', OBJECTIVE_ACTIVE); -- Fake obj needet to show final movie
	Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim3', 'DefeatAllDemons');
end;

function DefeatAllDemons ()
	print ('Defeat all demons')
	StartDialogScene("/DialogScenes/Single/SM6/R5/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState  ('fake_objective', OBJECTIVE_COMPLETED); -- Fake obj needet to show final movie
end;

---------- DEMONIC INVASION - MESSAGE AND OPEN PATHS FOR DEMON HEROES -----
--ElvenCityUnderSiege = not nil;
H55_NewDayTrigger = 1;
function H55_TriggerDaily()
	if GetDate(DAY) == DayOfInvasion then
		MessageBox ("/Maps/SingleMissions/SM6/ElvenCitySiege.txt");
		x, y, z = RegionToPoint('ElvenCityCenter');
		OpenCircleFog(x, y, z, 7, PLAYER_1);
		SetRegionBlocked('DemonBorder1', nil, PLAYER_2);
		SetRegionBlocked('DemonBorder2', nil, PLAYER_2);
		H55_NewDayTrigger = 0;
	end;	
end;
Trigger (OBJECT_CAPTURE_TRIGGER, 'SylvanBorder', 'ElvenCity');
function ElvenCity (oldplayer, newplayer, hero)
	--	if GetObjectOwner ('SylvanBorder')==PLAYER_1 then
	if oldplayer == PLAYER_2 and newplayer == PLAYER_1 then
		MessageBox ("/Maps/SingleMissions/SM6/ElvenCitySiegeOver.txt");
		SetObjectOwner ('SylvanCastle', PLAYER_1);
		--ElvenCityUnderSiege = false;
		Trigger (OBJECT_CAPTURE_TRIGGER, 'SylvanBorder', nil);
	end;
end;
---------------ZAMEDLENIE-GROKA-NA-UROVNE-SLOJNOSTI-NORMAL--------------------------------------

function TriggerPlayer()
	print("Grok neset artifact...");
	while IsObjectExists('Grok') do
--and HasArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW) do
		print ('cicl');
		CurrentPlayer = GetCurrentPlayer();
		while CurrentPlayer == GetCurrentPlayer() do
			CurrentPlayer = GetCurrentPlayer();
			sleep(1);
		end;
		print("Player triggered");
		if CurrentPlayer == PLAYER_1 then
			print("PLAYER'S 2 turn");
			startThread(HeroSlow);
			else print("PLAYER'S 1 turn");
		end;
		sleep(10);
	end;
end;

function HeroSlow ()
	print ('Slow');
	if IsObjectExists('Grok') then
--and GetCurrentPlayer() == PLAYER_2 then
		print ('STOYAT GROK, YA SKAZAL STOYAT!');
		MovePoints = GetHeroStat('Grok', STAT_MOVE_POINTS);
		print ('old ', MovePoints);
		Delta = (MovePoints/4)*(-1);
		print ('delta ', Delta);
		ChangeHeroStat('Grok', STAT_MOVE_POINTS, Delta);
		sleep (1);
		MovePoints = GetHeroStat('Grok', STAT_MOVE_POINTS);
		print ('new ', MovePoints);
	end;
end;
---------------------------------------------------------------------------------------------------
function DemonHalfArmy (heroname) -- functiya upolovinivaet armiyu heroname-a (esli on demon)
	DividingNumber = 2;
	local creatures = {
	CREATURE_FAMILIAR,
	CREATURE_IMP,
	CREATURE_DEMON,
	CREATURE_HORNED_DEMON,
	CREATURE_HELL_HOUND,
	CREATURE_CERBERI,
	CREATURE_SUCCUBUS,
	CREATURE_INFERNAL_SUCCUBUS,
	CREATURE_NIGHTMARE,
	CREATURE_FRIGHTFUL_NIGHTMARE,
	CREATURE_PIT_FIEND,
	CREATURE_BALOR,
	CREATURE_DEVIL,
	CREATURE_ARCHDEVIL	
	}
		
	for index, creature in creatures do
		local count = GetHeroCreatures(heroname, creature) / DividingNumber;
		if count > 0 then
			RemoveHeroCreatures(heroname, creature, count);
		end;
	end;
	
 end;
---------------------------------------------------