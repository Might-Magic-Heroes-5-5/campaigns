H55_PlayerStatus = {0,2,2,2,2,2,1,2};

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

StartDialogScene("/DialogScenes/C5/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M4");
    LoadHeroAllSetArtifacts("Heam", "C5M3" );
end;

startThread(H55_InitSetArtifacts);

------- REMOVE ALL RESOURSES FROM PLAYER - HE NEED TO COLLECT THEM ---
for res_count=0,6,1 do
	SetPlayerResource(1, res_count, 0);
end;
------- DEMON HEROES ARMY DEPENDANCE OF GAME DIFFICULTY---------------
ArmyMult = 0;
Diff = GetDifficulty ();
if Diff == DIFFICULTY_HARD then ArmyMult = 1; end;
if Diff == DIFFICULTY_HEROIC then ArmyMult = 2; end;
------- REMOVE SOME HARD MOBS FROM MAP IN EASY AND NORMAL MODE -------
if Diff == DIFFICULTY_EASY then
	RemoveObject ('1alpha-wight');
	RemoveObject ('6alpha-water');	
	RemoveObject ('beta-liches');	
	RemoveObject ('Delta-wight');	
	
end;
if Diff == DIFFICULTY_NORMAL then
	RemoveObject ('1alpha-wight');
	RemoveObject ('6alpha-water');	
	RemoveObject ('beta-liches');	
	RemoveObject ('Delta-wight');	
	
end;
if Diff == DIFFICULTY_HARD then
	RemoveObject ('1alpha-wight');
	RemoveObject ('6alpha-water');
	--RemoveObject ('L1-sprites');
	RemoveObject ('J-treant');
  -- Dobavlaem krichey v armii mobov
	AddObjectCreatures('earth_elem', CREATURE_EARTH_ELEMENTAL, 5);
	AddObjectCreatures('fire_demons', CREATURE_HORNED_DEMON, 20);
	AddObjectCreatures('C-golem', CREATURE_STEEL_GOLEM, 40); --ohrana mashinnogo depo
	AddObjectCreatures('J-cerber', CREATURE_CERBERI, 25); -- ohrana spell powera
	AddObjectCreatures('K-dragon', CREATURE_SHADOW_DRAGON, 4); -- ohrana Ring of Life
	AddObjectCreatures('Delta-matron', CREATURE_MATRON, 3); -- podzemley. ohrana kmowlege
end;
------- REMOVE ADDITIONAL JOIN CREATURES IN not nil HARD MODE -----------
if Diff == DIFFICULTY_HEROIC then
  -- Ubiraem chast soyuznikov
	--RemoveObject ('2alpha-sprites');
	--RemoveObject ('2beta-pixie');
	--RemoveObject ('1beta-druids');
	RemoveObject ('L1-sprites');
	--RemoveObject ('L2-pixies');
	RemoveObject ('J-treant');
  -- Dobavlaem krichey v armii mobov
	AddObjectCreatures('earth_elem', CREATURE_EARTH_ELEMENTAL, 10); -- podzemniy prohod
	AddObjectCreatures('fire_demons', CREATURE_HORNED_DEMON, 40);
	AddObjectCreatures('C-golem', CREATURE_STEEL_GOLEM, 100); --ohrana mashinnogo depo
	AddObjectCreatures('C-golem2', CREATURE_IRON_GOLEM, 140); --ohrana spell-powera
	AddObjectCreatures('J-cerber', CREATURE_CERBERI, 50); -- ohrana spell powera
	AddObjectCreatures('Gamma-priest', CREATURE_PRIEST, 20); -- podzemley. ohrana nichki
	AddObjectCreatures('Gamma-nightmare', CREATURE_FRIGHTFUL_NIGHTMARE, 22); -- podzemley. ohrana areni
	AddObjectCreatures('K-dragon', CREATURE_SHADOW_DRAGON, 8); -- ohrana Ring of Life
	AddObjectCreatures('Delta-matron', CREATURE_MATRON, 5); -- podzemley. ohrana kmowlege
	AddObjectCreatures('Delta-wight', CREATURE_WIGHT, 15); -- podzemley. mob na hodu
	
end;	
----------------------------------------------------------------------

------- ARTIFACT COLLECTION SECONDARY OBJECTIVE ----------------------
ArtifactCollected = 0;
Trigger (OBJECT_TOUCH_TRIGGER, 'Armor', 'CollectOne');
Trigger (OBJECT_TOUCH_TRIGGER, 'Pendant_of_Mastery', 'CollectOne');
Trigger (OBJECT_TOUCH_TRIGGER, 'Bow', 'CollectOne');
Trigger (OBJECT_TOUCH_TRIGGER, 'Ring_of_Life', 'CollectOne');

function CollectOne ()
	print ('CollectOne started - ', ArtifactCollected);
	ArtifactCollected = ArtifactCollected +1;
	SetObjectiveProgress('Sec1', ArtifactCollected, PLAYER_1);
	print ('CollectOne ended - ', ArtifactCollected);
	ChangeHeroStat('Heam', STAT_EXPERIENCE, ArtifactCollected*5000);
	if ArtifactCollected == 4 then SetObjectiveState('Sec1', OBJECTIVE_COMPLETED); end;
end;
----------------------------------------------------------------------


Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Tieru_Island', 'ComeToIsland');
function ComeToIsland ()
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Tieru_Island', nil);
--	print ('SRABOTAL ENTER REGION')
-- $%@$!($)$%!$))%$)% )%$ $)% )% )!$&% )& )!!!!!!!!!!!!!!!!! --	
    StartDialogScene("/DialogScenes/C5/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
	SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
	
	DeployReserveHero('Jazaz', RegionToPoint('Jazaz_Deploy_Here'));
	DeployReserveHero('Biara', RegionToPoint('Biara_Deploy_Here'));
	sleep (3);
	EnableHeroAI('Jazaz', nil );
	EnableHeroAI('Biara', nil);
	if Diff == DIFFICULTY_EASY then -- UMENSENIE ARMIY DEMONOV DLYA UROVNYA SLOJNOSTI "EASY"
		DemonHalfArmy ('Jazaz');
		DemonHalfArmy ('Biara');
	end;
	if ArmyMult>0 then 	------ ADDITIONAL TROOPS FOR JAZAZ AND BIARA
	 AddHeroCreatures('Jazaz', CREATURE_BALOR, 3*ArmyMult); --- PIT FIENDS
	 AddHeroCreatures('Jazaz', CREATURE_CERBERI, 31*ArmyMult); --- CERBERI
	 AddHeroCreatures('Jazaz', CREATURE_FRIGHTFUL_NIGHTMARE, 6*ArmyMult); --- HELL CHARGERS
	 AddHeroCreatures('Jazaz', CREATURE_HORNED_DEMON, 32*ArmyMult); --- HORNED DEMONS
	 if ArmyMult==2 then AddHeroCreatures('Jazaz', CREATURE_ARCHDEVIL, 2*ArmyMult)
		else AddHeroCreatures('Jazaz', CREATURE_DEVIL, 2*ArmyMult); end;
	 AddHeroCreatures('Biara', CREATURE_INFERNAL_SUCCUBUS, 29*ArmyMult);
	end;
	x, y, z = RegionToPoint('Biara_Here');
	OpenCircleFog(x, y, z, 11, PLAYER_1);
	x, y, z = RegionToPoint('Biara_Deploy_Here');
	OpenCircleFog(x, y, z, 8, PLAYER_1);
	x, y, z = RegionToPoint('Jazaz_Here');
	OpenCircleFog(x, y, z, 8, PLAYER_2);
	SetObjectEnabled('ExitToIsland', nil); -- There is no way back!  -- blokiruem vihod s ostrova.
	Trigger (OBJECT_TOUCH_TRIGGER, 'ExitToIsland', 'NoWayBack');
end;
function NoWayBack ()
	MessageBox ("/Maps/Scenario/C5M4/Texts/NoWay.txt");
end;


Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Jazaz_Here', 'ComeToTieru');
function ComeToTieru ()
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Jazaz_Here', nil);
--	print ('Come To Tieru started...');
	BlockGame(); ------------ DEMONS ATTACK - THE MOVIE -------------------------------
--print ('nachalos');	
	MoveHeroRealTime('Biara', RegionToPoint('Biara_Here'));
	sleep (10);
	MoveHeroRealTime('Jazaz', RegionToPoint('Jazaz_Here'));
	sleep (15);	
	UnblockGame();---------------------------------------------------------------------

	sleep (5);
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', 'TieruDeath');
end;


function TieruDeath ()
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', nil);
	sleep (3);
	BlockGame();  ----- DEATH OF TIERU - THE MOVIE -------------------------------------
	sleep (2);																		 --!
	leftmove = GetHeroStat ('Heam', STAT_MOVE_POINTS);								 --!
	ChangeHeroStat ('Heam', STAT_MOVE_POINTS,1000000);								 --!
	MoveHeroRealTime('Heam', RegionToPoint('Heam_Here'));	
	x, y, z = RegionToPoint('Biara_Here');
	MoveCamera(x, y, z, 65, 3.14/4, 3.14/2+(3.14/6));	--3.14-(3.14/4)				 --!
	--sleep (30); -- ??!?!
	sleep (1); 																		 --!
	SetStandState('TieruHut', 1);													 --!
	sleep (50);																		 --!
	MoveHeroRealTime('Biara', RegionToPoint('Biara_Step_Here'));					 --!
	x, y, z = RegionToPoint('Teleport_Here');										 --!
    y=y+0.5;																    	 --!
	SetObjectPosition ('Biara', x,y,z);												 --!
	UnblockGame();----------------------------------------------------------------------
	ChangeHeroStat ('Heam', STAT_MOVE_POINTS,-1000000);
	ChangeHeroStat ('Heam', STAT_MOVE_POINTS,leftmove);
---------TEMP - ubrat 2 next strochki dlya testa
--	Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim3', 'BiaraLoose');
	sleep (10);
	Save ('Will_of_Tieru');
    StartDialogScene("/DialogScenes/C5/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState('prim2', OBJECTIVE_FAILED);
	SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
	Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_7, 'BiaraLoose')
	sleep (40);
	x, y, z = RegionToPoint('Teleport_Here');
	OpenCircleFog(x, y, z, 10, PLAYER_1);	
	MoveCamera(x, y, z, 40, 3.14/2, 3.14);
end;

function AllBack ()  --------- TEMP
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', 'TieruDeath');
	SetObjectPosition ('Biara', RegionToPoint('Biara_Here'));
	SetObjectPosition ('Heam', RegionToPoint('Jazaz_Here'));
	SetStandState('TieruHut', 0);
end;
function StartIt()   ------------- TEMP
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Cut_Scene2', 'TieruDeath');
	DeployReserveHero('Biara', RegionToPoint('Biara_Here'));
end;



function BiaraLoose (LooseHero, WinnerHero)
	if LooseHero == 'Biara' then
		SaveHeroAllSetArtifactsEquipped("Heam", "C5M4");
		StartDialogScene("/DialogScenes/C5/M4/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep (20);
		ChangeHeroStat('Heam', STAT_EXPERIENCE, 0);
		SetObjectiveState('prim3', OBJECTIVE_COMPLETED);
		Win();
	end;
end;


-- Демон прикрывающий бегство Биары.
--function DemonShipCombat ()
-- Biara_Retret_Zone пока не существует.
--  if IsObjectInRegion('Biara', 'Biara_Retreat_Zone') and watercombat then
-- DeployReserveHero('Oddrema', 139,48, GROUND);
-- EnableHeroAI('Oddrema', nil);
--   MoveHero ('Oddrema',123,57);
-- end;
--end;
--------------------------------------------------
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
H55_CamFixTooManySkills(PLAYER_1,"Heam");