--GiveExp( "Ving", 202000 ); ---addexp___________________TEST!!!
--zehir_stop
-------------------------------------------------
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
-------------------------------------------------
function x2()
	InitAllSetArtifacts("A2C3M4", "Zehir" );
	LoadHeroAllSetArtifacts( "Zehir",  "A2C3M3"  );
end
-------------------------------------------------
OpenCircleFog( 91, 86, 0, 16, PLAYER_1 ); ---фог_cо_столицы

SetObjectEnabled( "f_portal", nil )
 
PlayerHero = "Zehir"

BlockTownGarrisonForAI( "Talonguard", not nil )
BlockTownGarrisonForAI( "delf", not nil )

BlockTownGarrisonForAI( "inf1", not nil )
BlockTownGarrisonForAI( "inf2", not nil )
BlockTownGarrisonForAI( "inf3", not nil )
BlockTownGarrisonForAI( "inf4", not nil )

first_visit = 0
second_visit = 0
Inferno_count = 0;

print("Start_A2C3M4_final.................");

SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
--SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 10000);

SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
SetObjectiveState('prim2',OBJECTIVE_ACTIVE);

SetObjectiveState('sec1',OBJECTIVE_ACTIVE);

GiveExp( "Biara", 15100000 ); ---addexp
GiveExp( "Menel", 245000 ); -----addexp
GiveExp( "Dalom", 400000 ); -----addexp
GiveExp( "Marder", 390000 ); ----addexp
GiveExp( "Nymus", 360000 ); -----addexp
GiveExp( "Deleb", 280000 ); -----addexp
GiveExp( "Ferigl", 600000 ); ----addexp
---------------------------------------
--GiveExp( "Grok", 800000 ); ------addexp
--GiveExp( "Oddrema", 800000 ); ---addexp
--GiveExp( "Calid", 800000 ); -----addexp
--GiveExp( "Efion", 800000 ); -----addexp

EnableHeroAI("Biara", nil);
EnableHeroAI("Ferigl", nil);
---------------------------------------
EnableHeroAI("Efion", nil);
EnableHeroAI("Oddrema", nil);
EnableHeroAI("Calid", nil);
EnableHeroAI("Jazaz", nil);

SetRegionBlocked("block_elf", 1, PLAYER_4); 
SetRegionBlocked("elf", 1, PLAYER_4); 

SetRegionBlocked("biara", 1, PLAYER_2); 

SetRegionBlocked("border_demons", 1, PLAYER_1); 

SetRegionBlocked("red_hero1", 1, PLAYER_2); 
SetRegionBlocked("red_hero2", 1, PLAYER_2);
SetRegionBlocked("red_hero3", 1, PLAYER_2);  

SetRegionBlocked("i_boss1", 1, PLAYER_2); 
SetRegionBlocked("i_boss2", 1, PLAYER_2);
SetRegionBlocked("i_boss3", 1, PLAYER_2); 

SetRegionBlocked("drag1", 1, PLAYER_2);

SetRegionBlocked("DD", 1, PLAYER_4);  

SetRegionBlocked("final_wey1", 1, PLAYER_1);  
SetRegionBlocked("final_wey2", 1, PLAYER_1);

MakeHeroReturnToTavernAfterDeath( PlayerHero, 1, 1);

--------------------------------------//////D_Level
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		RemoveObjectCreatures("Talonguard", CREATURE_ARCHDEVIL, 15); 
		RemoveObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 15);
	elseif slozhnost == DIFFICULTY_HARD then
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 25 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 25 );
	elseif slozhnost == DIFFICULTY_HEROIC then
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 45 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 45 );
	end;
	print('difficulty = ',slozhnost);
end;

function Time_events()
	if ( GetDate(MONTH) == 4 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		AddObjectCreatures("Talonguard", CREATURE_ARCHDEVIL, 30); 
		AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 30);
		sleep(5);   
	end;
	if ( GetDate(MONTH) == 5 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		AddObjectCreatures("Talonguard", CREATURE_ARCHDEVIL, 75); 
		AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 75);
		sleep(5);   
	end;
end;
--------------------------------------/////Main_Hero_Death
function Main_hero_de()  
	while 1 do
		sleep(10);
		if IsHeroAlive(PlayerHero) == nil then 
			sleep(3);
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			sleep(8);
			Loose();
			break;
		end;
	end;
end;
---------------------------------------/////Episode1_WOLFSTAN
function Complete_prim1()
	while 1 do	
		sleep( 10 );
		if GetObjectOwner("mine1") == PLAYER_1 and GetObjectOwner("mine2") == PLAYER_1 and GetObjectOwner("mine3") == PLAYER_1 then
			sleep( 3 );
			--Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO2_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Захват шахт
			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
			SetObjectEnabled( "f_portal", not nil )
			RemoveObject("ef1");
			sleep( 8 );
			SetObjectiveState('prim3',OBJECTIVE_ACTIVE);
			OpenCircleFog( 159, 99, 0, 8, PLAYER_1 );  
			MoveCamera(159, 99, 0, 50, 1);
			sleep( 16 )
			OpenCircleFog( 138, 154, 1, 10, PLAYER_1 );
			MoveCamera(138, 154, 1, 50, 1);
			sleep( 5 )
			VoiceOver2();
--			Save( "AllyCombat1" );
			break;
		end;
	end;
end;

function VoiceOver2()
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
	sleep( 45 );
	startThread( Start_Wolfstan );
end;

function Start_Wolfstan()
	BlockGame();
	DeployReserveHero( "Wulfstan", 131, 155, 1 );
--	SetObjectRotation("Wulfstan", 90);
	sleep( 8 );
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO15_Wulfstan_01sound.xdb#xpointer(/Sound)" );
	sleep( 44 );
	WulfstanSetUp();
end;

function WulfstanSetUp()
	LoadHeroAllSetArtifacts( "Wulfstan",  "A2C3M3"  );
	H55_CamFixTooManySkills(PLAYER_1,"Wulfstan");
	sleep( 2 );
	ChangeHeroStat( "Wulfstan", STAT_MANA_POINTS, 500 );
	startThread( Inferno_1_capture ); 
	ChangeHeroStat( "Wulfstan", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Wulfstan", 143, 152, 1 );
	sleep(20);
	startThread( Wolfstan_de ); 
	UnblockGame();
end;

function Wolfstan_de()  
	while 1 do
		sleep(3);
		if IsHeroAlive("Wulfstan") == nil then 
			sleep(2);
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			sleep(1);
			Loose();
			break;
		end;
	end;
end;

function Inferno_1_capture()
	while 1 do	
		sleep( 5 );
		if (GetObjectOwner("inf2") == PLAYER_1) then
			startThread( VoiceOver14 );
			SetObjectOwner( "Wulfstan", PLAYER_3 );
			sleep( 3 )
			RazeTown( "inf2" );
			Inferno_count = Inferno_count + 1;
--			SetObjectOwner( "inf2", PLAYER_3 );
			EnableHeroAI("Wulfstan", nil);
--			SetPlayerTeam(  PLAYER_3, 1 ); ---------------only_1
			sleep( 3 );
			break;
		end;
	end;
end;

function VoiceOver14()
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO14_Thorod_01sound.xdb#xpointer(/Sound)" );
end;

--------------------------------------
Trigger(OBJECT_TOUCH_TRIGGER, "f_portal", "x_enter");

function x_enter()
	if GetObjectiveState("prim2") ~= OBJECTIVE_COMPLETED then
		MessageBox("/Maps/Scenario/a2c3m4/enter_message.txt");
		sleep( 2 );
	end;
end;

---------------------------------------/////Episode2_FREYDA
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons","obj4", nil );


function obj4()
	sleep(3);
	SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
	sleep(5);
	SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
	sleep(5);
	startThread( Start_Freyda );
	OpenCircleFog( 159, 77, 0, 4, PLAYER_1 );
	OpenCircleFog( 160, 49, 0, 4, PLAYER_1 );  
	startThread(Complete_prim4);	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons",nil);
end;

function Start_Freyda()
	BlockGame();
	sleep(5);
	OpenCircleFog( 32, 25, 1, 10, PLAYER_1 );
	MoveCamera(32, 25, 1, 50, 1);
	sleep(15);
	DeployReserveHero( "Freyda", 33, 18, 1 );
	DeployReserveHero( "Duncan", 33, 16, 1 );
--	SetObjectRotation("Freyda", 0);
--	SetObjectRotation("Duncan", 0);
	sleep(8);
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO18_Freyda_01sound.xdb#xpointer(/Sound)" );
	sleep( 40 );
	LoadHeroAllSetArtifacts( "Freyda",  "A2C3M2"  );  -----!
	H55_CamFixTooManySkills(PLAYER_1,"Freyda");
	sleep( 2 );
	ChangeHeroStat( "Freyda", STAT_MANA_POINTS, 500 );
	startThread( Inferno_2_capture ); 
	ChangeHeroStat( "Freyda", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Freyda", 34, 31, 1 );
	sleep( 3 );
	MoveHeroRealTime( "Duncan", 33, 28, 1 );
	startThread( Freyda_de ); 
	sleep(60);
	UnblockGame();
--	FreydaSetUp();
end;

--function FreydaSetUp()
--	LoadHeroAllSetArtifacts( "Freyda",  "A2C3M2"  );
--	sleep( 2 );
--	ChangeHeroStat( "Freyda", STAT_MANA_POINTS, 500 );
--	startThread( Inferno_2_capture ); 
--	ChangeHeroStat( "Freyda", STAT_MOVE_POINTS, 30000 );
--	MoveHeroRealTime( "Freyda", 34, 31, 1 );
--	sleep( 5 );
--	MoveHeroRealTime( "Duncan", 33, 28, 1 );
--	startThread( Freyda_de ); 
--	sleep(60);
--	UnblockGame();
--end;

function Freyda_de()  
	while 1 do
		sleep(3);
		if IsHeroAlive("Freyda") == nil then 
			sleep(2);
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			sleep(1);
			Loose();
			break;
		end;
	end;
end;

function Inferno_2_capture()
	while 1 do	
		sleep( 5 );
		if (GetObjectOwner("inf4") == PLAYER_1) then
			startThread( VoiceOver11 );
			SetObjectOwner( "Freyda", PLAYER_3 );
			SetObjectOwner( "Duncan", PLAYER_3 );
			sleep( 3 );
			RazeTown( "inf4" );
			Inferno_count = Inferno_count + 1;			
			EnableHeroAI( "Freyda", nil );
			EnableHeroAI( "Duncan", nil );
			sleep( 3 );
			break;
		end;
	end;
end;

function VoiceOver11()
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO11_Duncan_01sound.xdb#xpointer(/Sound)" );
end;
---------------------------------------/////Episode3_GOTAY
function Complete_prim4()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Marder") == nil and IsHeroAlive("Nymus") == nil then 
			sleep(2);
			RemoveObject("f1");
			RemoveObject("f2");
			SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
			sleep(3);
			SetObjectiveState('prim5',OBJECTIVE_ACTIVE);
			sleep(3);
			startThread(Complete_prim5);
			SetRegionBlocked("border_demons", nil, PLAYER_1); ---------!!!
			SetRegionBlocked("block_elf", nil, PLAYER_4); -------------free_dark_elves!!
			startThread( Start_Kujin ); 
			break;
		end;
	end;
end;

function Start_Kujin()
	BlockGame();
	sleep(5);
	OpenCircleFog( 150, 56, 1, 10, PLAYER_1 );
	MoveCamera(150, 56, 1, 50, 1);
	sleep(15);
	DeployReserveHero( "Gottai", 155, 61, 1 );
	DeployReserveHero( "Kujin", 153, 61, 1 );
	sleep ( 1 );
	H55_CamFixTooManySkills(PLAYER_1,"Gottai");
	H55_CamFixTooManySkills(PLAYER_1,"Kujin");
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO16_Kujin_01sound.xdb#xpointer(/Sound)" );
	sleep( 44 );
	KujinSetUp();
end;

function KujinSetUp()
	LoadHeroAllSetArtifacts( "Kujin",  "A2C2M4"  );
	-- LoadHeroAllSetArtifacts( "Gottai",  "A2C2M5"  ); --was not in TOE originally
	sleep( 2 );
	ChangeHeroStat( "Kujin", STAT_MANA_POINTS, 500 );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_RALLING_CRY  );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_CALL_OF_BLOOD  );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_WORD_OF_THE_CHIEF  );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_FEAR_MY_ROAR  );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_BATTLECRY  );
	--TeachHeroSpell( "Kujin", SPELL_WARCRY_SHOUT_OF_MANY  );
	sleep(8);
	startThread( Inferno_3_capture ); 
	ChangeHeroStat( "Gottai", STAT_MOVE_POINTS, 30000 );
	ChangeHeroStat( "Kujin", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Gottai", 148, 49, 1 );
	MoveHeroRealTime( "Kujin", 146, 51, 1 );
	sleep(20);
	startThread( Kujin_de ); 
	UnblockGame();
end;

function Kujin_de()  
	while 1 do
		sleep(1);
		if IsHeroAlive("Kujin") == nil then 
			sleep(1);
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			Loose();
			break;
		end;
	end;
end;

function Inferno_3_capture()
	while 1 do	
		sleep( 5 );
		if (GetObjectOwner("inf3") == PLAYER_1) then
			startThread( VoiceOver13 );
			SetObjectOwner( "Gottai", PLAYER_3 );
			SetObjectOwner( "Kujin", PLAYER_3 );
			sleep( 3 );
			RazeTown( "inf3" );
			Inferno_count = Inferno_count + 1;
--			SetObjectOwner( "inf3", PLAYER_3 );
			EnableHeroAI("Gottai", nil);
			EnableHeroAI("Kujin", nil);
			sleep( 3 );
			break;
		end;
	end;
end;

function VoiceOver13()
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO13_Orc1_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------/////Episode4_ELLAYA
function Complete_prim5()  
	while 1 do
		sleep(10);
		if GetPlayerState(PLAYER_4) == 3 then
			sleep(3);
			SetObjectiveState( "prim5", OBJECTIVE_COMPLETED );
			SetObjectiveState( "Pri7_FreeLand", OBJECTIVE_COMPLETED );
			print ('................Elves_defeated....');
			startThread(Remove_guards); -------------Guards_remove
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO9_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили дарк эльфов
			MessageBox("/Maps/Scenario/a2c3m4/Def_elf.txt");
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb1_1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb2_1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb3_1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb4_1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb2", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb3", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bb4", nil );
			sleep(25);
			SetObjectiveState('prim6',OBJECTIVE_ACTIVE);
			startThread( Start_Ellaya ); 
			break;
		end;
	end;
end;

function Start_Ellaya()
	BlockGame();
	sleep(5);
	OpenCircleFog( 28, 150, 1, 10, PLAYER_1 );
	MoveCamera(28, 150, 1, 50, 1);
	sleep(15);
	DeployReserveHero( "Shadwyn", 28, 154, 1 );
	sleep(8);
	ChangeHeroStat( "Shadwyn", STAT_MANA_POINTS, 500 );
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO17_Ylaya_01sound.xdb#xpointer(/Sound)" );
	sleep( 20 );
	YlayaDeploySetUp();
end;

function YlayaDeploySetUp()
	startThread( Inferno_4_capture ); 
	ChangeHeroStat( "Shadwyn", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Shadwyn", 28, 143, 1 );
	sleep(20);
	startThread( Ellaya_de ); 
	UnblockGame();	
end;

function Ellaya_de()  
	while 1 do
		sleep(3);
		if IsHeroAlive("Shadwyn") == nil then 
			sleep(2);
			SetObjectiveState("prim1", OBJECTIVE_FAILED);
			sleep(1);
			Loose();
			break;
		end;
	end;
end;

function Inferno_4_capture()
	while 1 do	
		sleep( 5 );
		if (GetObjectOwner("inf1") == PLAYER_1) then
			startThread( VoiceOver12 );
			SetObjectOwner( "Shadwyn", PLAYER_3 );
			sleep( 3 );
			RazeTown( "inf1" );
			Inferno_count = Inferno_count + 1;
--			SetObjectOwner( "inf1", PLAYER_3 );
			EnableHeroAI("Shadwyn", nil);
			sleep( 3 );
			break;
		end;
	end;
end;

function VoiceOver12()
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO12_Ylaya_01sound.xdb#xpointer(/Sound)" );
end;
----------------------------------RemoveGuards
function Remove_guards()
	RemoveObjectCreatures("x1", CREATURE_ARCH_DEMON, 35);
	RemoveObjectCreatures("x2", CREATURE_ARCH_DEMON, 35);
	SetRegionBlocked("final_wey1", nil, PLAYER_1);
	RemoveObject("final_gate1");
	SetRegionBlocked("final_wey2", nil, PLAYER_1);
	RemoveObject("final_gate2");
end;
-----------------------------/////Episode5
--function pre_scene()
--	StartDialogScene("/DialogScenes/A2C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----///Сцена финальная 1
--end;

--Trigger (OBJECT_TOUCH_TRIGGER, "Talonguard", "pre_scene");

function Complete_obj6()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Talonguard") == PLAYER_1) then
			sleep( 2 );
			StartDialogScene("/DialogScenes/A2C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)","Secscene"); ----///Сцена финальная 1
			break;
		end;
	end;
end;

function Secscene ()
	StartDialogScene("/DialogScenes/A2C3/M4/S2/DialogScene.xdb#xpointer(/DialogScene)","Allwin"); ----///Сцена финальная 2
end;

function Allwin ()
	print("Allwin");
	Win();
end;	
----------------------------//////Deploy_ally_creatures
function Inferno_1()
	while 1 do	
		sleep( 5 );
		if Inferno_count == 4 then	
			sleep( 3 );
			CreateMonster( "m1", CREATURE_BLACK_DRAGON, 75, 96, 88, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
			CreateMonster( "m2", CREATURE_MAGMA_DRAGON, 75, 96, 86, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
			CreateMonster( "m3", CREATURE_CYCLOP_UNTAMED, 75, 96, 84, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
			CreateMonster( "m4", CREATURE_ARCHANGEL, 75, 96, 82, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
--			startThread(Inferno_2);
			break;
		end;
	end;
end;
------------------------------------------////Sec_Objectives
function Complete_sec1()
	while 1 do	
		sleep( 10 );
		if GetObjectOwner("DT1") == PLAYER_1 and GetObjectOwner("DT2") == PLAYER_1 then
			sleep( 3 );
			SetObjectiveState('sec1',OBJECTIVE_COMPLETED);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO3_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Захват дварф шахт
			sleep( 3 );
			LevelUpHero( PlayerHero );
			break;
		end;
	end;
end;

------------------------------------------/////
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec2_start","SecondObj2", nil );

function SecondObj2()
	sleep(3);	
	SetObjectiveState('sec2',OBJECTIVE_ACTIVE);
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO4_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Демон инферно
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec2_start",nil);
	sleep(3);
	startThread(Sec2_hero_de);
end;

function Sec2_hero_de()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Deleb") == nil then 
			sleep(3);
			SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
			sleep(2);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO5_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили демона
			break;
		end;
	end;
end;

-------------------------------------//////
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec3_start","SecondObj3", nil );

function SecondObj3()
	sleep(3);	
	SetObjectiveState('sec3',OBJECTIVE_ACTIVE);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec3_start",nil);
	sleep(3);
	startThread(Matriarh);
end;

function Matriarh()  
	while 1 do
		sleep(10);
		if IsObjectExists ("gvard") == nil then
			sleep(3);
			SetObjectiveState("sec3", OBJECTIVE_COMPLETED);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO6_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили охрану матриархов
			sleep(2);
			break;
		end;
	end;
end;

------------------------------------///////
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec4_start","SecondObj4", nil );

function SecondObj4()
	sleep(3);	
	SetObjectiveState('sec4',OBJECTIVE_ACTIVE);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec4_start",nil);
	sleep(3);
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO8_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO
	startThread(Demension);
end;

function Demension()  
	while 1 do
		sleep(10);
		if KnowHeroSpell ( PlayerHero, 50) == not nil then
			sleep(3);
			SetObjectiveState("sec4", OBJECTIVE_COMPLETED);
			sleep(2);
			break;
		end;
	end;
end;

--------------------------------------////////
doFile("/scripts/A2_Zehir/A2_Zehir.lua");

function summon_creatures()
    if GetDifficulty() == DIFFICULTY_EASY then
        ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 8, 10000);
    end;
    if GetDifficulty() == DIFFICULTY_NORMAL then
        ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 16, 16000);
    end;
    if GetDifficulty() == DIFFICULTY_HARD then
        ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 18, 20000);
    end;
    if GetDifficulty() == DIFFICULTY_HEROIC then
        ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 20, 24000);
    end;
    ZehirAbilitiesInit("Zehir");
end

-----------------------------------------------------
function Summon_town()
	ZehirTownInit("z_town");
	AddTownPoint(9, 90, GROUND, 90, "zehir", 35000, "zehir1");
end;
-------------------------------------------------
function Z_graal() 
	if GetGameVar("A2C3M3_Graal") == "1" then
		GiveArtefact(PlayerHero, ARTIFACT_GRAAL);
	elseif GetGameVar("A2C3M3_Graal") == "2" then
		UpgradeTownBuilding( "z_town", TOWN_BUILDING_GRAIL )	
	end;
end;
-----------------------------------------------------

function Allheroes_voises()
	while 1 do	
		sleep( 10 );
		--if (GetObjectOwner("inf1") == PLAYER_3) and (GetObjectOwner("inf2") == PLAYER_3) and (GetObjectOwner("inf3") == PLAYER_3) and (GetObjectOwner("inf4") == PLAYER_3) then
		if Inferno_count == 4 then	
			sleep( 15 );
			BlockGame();
			MoveCamera(96, 85, GROUND, 25, 3.14/3, 0, 1, 1, 1);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO10_Zehir_01sound.xdb#xpointer(/Sound)" ); -----------VO прибытие кричей
			sleep( 32 );
			UnblockGame();
			break;
		end;
	end;
end;
------------------------------------//DemohHeroesDiffLevel

function KujinFightSetUp()
	if GetDifficulty()==DIFFICULTY_EASY then
		RemoveObjectCreatures("inf4", CREATURE_ARCHDEVIL, 10); 
		--RemoveObjectCreatures("inf4", CREATURE_PIT_SPAWN , 15);
		--RemoveObjectCreatures("inf4", CREATURE_NIGHTMARE, 35);
		--RemoveObjectCreatures("inf4", CREATURE_INFERNAL_SUCCUBUS, 85);
			--RemoveObjectCreatures("inf2", CREATURE_HORNED_DEMON, 200); 
			--RemoveObjectCreatures("inf2", CREATURE_INFERNAL_SUCCUBUS , 25);
			--RemoveObjectCreatures("inf2", CREATURE_PIT_FIEND, 20);
			RemoveObjectCreatures("inf2", CREATURE_ARCHDEVIL, 20);
			--RemoveObjectCreatures("inf2", CREATURE_HELLMARE, 15);
			--RemoveObjectCreatures("inf2", CREATURE_SUCCUBUS_SEDUCER, 30);
	end;	
	if GetDifficulty()==DIFFICULTY_NORMAL then
		TeachHeroSpell( "Efion", SPELL_BERSERK );
		TeachHeroSpell( "Efion", SPELL_SLOW );
		TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
		TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
		TeachHeroSpell( "Efion", SPELL_CURSE  );
	end;
	if GetDifficulty()==DIFFICULTY_HARD then
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 12 );
		AddHeroCreatures( "Calid", CREATURE_HELL_HOUND, 150 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 150 );
		TeachHeroSpell( "Calid", SPELL_BERSERK );
	AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 200 );
	AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 30 );
	AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 10 );
	AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 50 );
	AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 10 );
	AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 50 );
	AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 30 );
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 10 );
		AddHeroCreatures( "Efion", CREATURE_PIT_FIEND, 15 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 50 );
		TeachHeroSpell( "Efion", SPELL_SLOW );
		TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
		TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
		TeachHeroSpell( "Efion", SPELL_CURSE  );
	end;
	if GetDifficulty()==DIFFICULTY_HEROIC then
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 20 );
		AddHeroCreatures( "Calid", CREATURE_HELL_HOUND, 300 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 300 );
		TeachHeroSpell( "Calid", SPELL_BERSERK );
	AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 400 );
	AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 50 );
	AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 20 );
	AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 60 );
	AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 15 );
	AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 30 );
	AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 20 );
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 20 );
		AddHeroCreatures( "Efion", CREATURE_PIT_SPAWN, 35 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 65 );
	TeachHeroSpell( "Efion", SPELL_SLOW );
	TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
	TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
	TeachHeroSpell( "Efion", SPELL_CURSE  );
	end;
end;
-----------------------------------////BLOCK_ENTER_UNDEGR
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zeh1","St_1" );

--function St_1 ()
--	SetObjectPosition( PlayerHero, 129, 162, 0 );
--	print("Return1");
--end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zeh1","St_1" );

function St_1 ( heroname )
	HN = heroname;
	SetObjectPosition( HN, 129, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zeh2","St_2" );

function St_2 ( heroname )
	HN = heroname;
	SetObjectPosition( HN, 33, 13, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zeh3","St_3" );

function St_3 ( heroname )
	HN = heroname;
	SetObjectPosition( HN, 158, 68, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "elf","St_4" );

function St_4 ( heroname )
	HN = heroname;
	SetObjectPosition( HN, 28, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end;


-----------------------------------------------------------EllayaCombat_Settings

diff = 0;

function DiffSetUp()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 1
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 2
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 3
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 4
	end;
end; 

function GarrisonSetUp()
    for creatureID = 1, CREATURES_COUNT - 1 do 
        CreatureSetUp = GetObjectCreatures( "inf1", creatureID );
        if GetObjectCreatures("inf1", creatureID ) > 2 then
		   RemoveObjectCreatures("inf1", creatureID, CreatureSetUp );
           AddObjectCreatures("inf1", creatureID, CreatureSetUp + ( CreatureSetUp / 100 * 10) * diff );
        end;
    end;
end;

------------------------------------------------------/MAIN
H55_CamFixTooManySkills(PLAYER_1,"Zehir");

startThread( KujinFightSetUp );
startThread( DiffSetUp );
startThread( GarrisonSetUp ); 

startThread( x2 ); 
startThread( Allheroes_voises ); 
startThread( Z_graal ); 
startThread( Diff_level ); 
startThread( Time_events ); 
startThread( summon_creatures ); --!!!

startThread(Main_hero_de);
startThread(Complete_prim1);
startThread(Complete_obj6);

startThread(Inferno_1);

startThread(Complete_sec1);
startThread(Summon_town);