H55_PlayerStatus = {0,1,1,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M2");
    LoadHeroAllSetArtifacts("Raelag", "C4M1" );
end;

startThread(H55_InitSetArtifacts);

---Global Var's---
town_array = {"town1","town2","town3"};
visited=nil	--был ли реалаг у оракула
reinforce_day=nil --день прихода подмоги
timer=nil --день прихода Шадии
support=nil --имя героя пришедшего на подмогу
reinf = 0
startweek = 0
first = 0;
Graal_Found = 0;
---Message Boxes---
not_realag="/Maps/Scenario/C4M2/text/not_raelag.txt"
oracul_visited="/Maps/Scenario/C4M2/text/visited.txt"
---------------------
SetRegionBlocked("a1", 1, PLAYER_2);
SetRegionBlocked("a2", 1, PLAYER_2);
SetRegionBlocked("a3", 1, PLAYER_2);
SetRegionBlocked("a4", 1, PLAYER_2);
SetRegionBlocked("b1", 1, PLAYER_2);
SetRegionBlocked("c1", 1, PLAYER_2);
SetRegionBlocked("c2", 1, PLAYER_2);
SetRegionBlocked("c3", 1, PLAYER_2);
---Dialog Scenes---
C4M2D1="/DialogScenes/C4/M2/D1/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R1="/DialogScenes/C4/M2/R1/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R2="/DialogScenes/C4/M2/R2/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R3="/DialogScenes/C4/M2/R3/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R4="/DialogScenes/C4/M2/R4/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R5="/DialogScenes/C4/M2/R5/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R6="/DialogScenes/C4/M2/R6/DialogScene.xdb#xpointer(/DialogScene)"
C4M2R7="/DialogScenes/C4/M2/R7/DialogScene.xdb#xpointer(/DialogScene)"
C4M2D2="/DialogScenes/C4/M2/D2/DialogScene.xdb#xpointer(/DialogScene)"
C4M2D3="/DialogScenes/C4/M2/D3/DialogScene.xdb#xpointer(/DialogScene)" ---------Новая !!!

---functions---
function PObjective3()
	while GetTownBuildingLevel( "Angkar", TOWN_BUILDING_GRAIL ) ~= 1 do
--		print ("working");
		sleep( 5 );
		if ( Graal_Found == 1 ) and ( IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil ) then
--			SetObjectiveState( "prim2", OBJECTIVE_FAILED );
			sleep( 5 );
			if GetTownBuildingLevel( "Angkar", TOWN_BUILDING_GRAIL ) ~= 1 then
				Loose();
			end;
			return
		end;
	end;
end;

function Graal()
	print ("start");
	while IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil do
		sleep(2);
	end;
	startThread( PObjective3 );
	print ("end");
	Graal_Found = 1;
	if visited==nil then
		visited=not nil
		SetObjectiveState('prim2',OBJECTIVE_ACTIVE)
		sleep(1)
		SetObjectiveState('prim1',OBJECTIVE_COMPLETED)
	end;
end;

function IsAnyHeroPlayerHasArtifact( playerID, artifID )
	local heroes = {};
	local m = 0;
	local h = 0;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if HasArtefact( h, artifID ) then
			return not nil;
	    end;
	end;
	return nil;
end;

function oracul(name) --фэйковая функциональность оракула, комплит первой и старт второй обжектив, вызывается триггером
	if name=='Raelag' then
		if visited==nil then
			visited=not nil
			StartDialogScene(C4M2D2) --Сцена посещения оракула
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE)
			OpenCircleFog( 28, 139, 1, 5, PLAYER_1 ); ---фог вокруг выхода
			sleep(1)
			SetObjectiveState('prim1',OBJECTIVE_COMPLETED)
			GiveExp( "Raelag", 500 ); ---addexp!!!
			return
		else
			MessageBox(oracul_visited) -- фраза при повторном посещении
		end
	else
		MessageBox(not_realag) -- к оракулу зашел не Раелаг, оракул говорит:"ты кто такой? иди в бобруйск!"
	end
end

function post_capturing() --вызывается триггером, после первой активации вызвающий триггер снимаетс
	StartDialogScene(C4M2R1) --Сцена посещения гарнизона
	SetObjectiveState('prim3',OBJECTIVE_ACTIVE)
	sleep(1)
	Trigger(OBJECT_CAPTURE_TRIGGER, "post1", nil)
	Trigger(OBJECT_CAPTURE_TRIGGER, "post2", nil)
end

function levelup() --вызывается из консоли если карта проходится отдельно от кампании (чтобе привести Раелага к нужному уровню)
	ChangeHeroStat('Raelag', STAT_EXPERIENCE,4600)
end

function town_triggering() --вызывается в начале миссии, развешивает триггеры на все города АИ
	for i,town in town_array do
		Trigger(OBJECT_CAPTURE_TRIGGER, town, "town_capture")
	end
end

function town_capture() --вызывается триггером, после первой активации вызвающий триггер снимаетс
	StartDialogScene(C4M2R3) --Сцена на захват перврго города.
	sleep(1)
	SetObjectiveState('sec1', OBJECTIVE_ACTIVE)
	startThread( Mess_go_1 ) ----------------///////DB
	timer=GetDate(ABSOLUTE_DAY)+1
	H55_SecNewDayTrigger = 0;
	H55_NewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER,'delay')

	SetAIPlayerAttractor('point1', PLAYER_2, 2)
	SetAIPlayerAttractor('point2', PLAYER_2, 2)
	print("Attractor////////////////////!")

	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point1', 'goto1')
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point2', 'goto2')
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape1', 'remove_messanger')
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape2', 'remove_messanger')

	for i,town in town_array do
		Trigger(OBJECT_CAPTURE_TRIGGER, town, nil)
	end
	startweek = GetDate(WEEK)
end
-----------------------------------------////////////DB
function Mess_go_1()
	if IsHeroAlive("Eruina") then	
		MoveHero( "Eruina", 59, 173, 0 )
	end
	if  IsHeroAlive("Almegir") then	
		MoveHero( "Almegir", 59, 173, 0 )
	end
	if  IsHeroAlive("Dalom") then	
		MoveHero( "Dalom", 59, 173, 0 )
		print("ALL_go_to_point!////////////////////!")
	end
end
-----------------------------------------////////////DB

function goto1( heroname )
	if GetObjectOwner(heroname)==PLAYER_2 then
		EnableHeroAI( heroname, nil )
		MoveHero( heroname, 59, 173, -1 )
		print("Goto1////////////////////1")
	end
end

function goto2( heroname )
	if GetObjectOwner(heroname)==PLAYER_2 then
		EnableHeroAI( heroname, nil )
		MoveHero( heroname, 2, 131, -1 )
		print("Goto1////////////////////2")
	end
end

function remove_messanger(heroname)
	if GetObjectOwner(heroname)==PLAYER_2 then
		RemoveObject(heroname)
		--Trigger(NEW_DAY_TRIGGER,'delay')
		SetAIPlayerAttractor('point1',PLAYER_2,0)
		SetAIPlayerAttractor('point2',PLAYER_2,0)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape1', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape2', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point1', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point2', nil)
		reinf = 1
	end
end

function hero_update()
	k = GetDate(WEEK) - startweek
	print( "k = "..k )
	diff = GetDifficulty()
	ChangeHeroStat('Inagost', STAT_EXPERIENCE, 12000 + k * 3000 )

	AddObjectCreatures('Inagost', CREATURE_ASSASSIN, 200 + random(7) + k*7 )
	AddObjectCreatures('Inagost', CREATURE_RAVAGER, 50 + random(4) + k*4 )
	AddObjectCreatures('Inagost', CREATURE_MATRIARCH, 20 + random(2) + k*2 )
	AddObjectCreatures('Inagost', CREATURE_BLACK_DRAGON, 6 + k )
	EnableHeroAI('Inagost' , nil);
	H55_NewDayTrigger = 0;
	H55_SecNewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, 'MoveHeroInagost');
end;

function H55_SecTriggerDaily()
	local x,y,z = GetObjectPosition("Raelag");
	MoveHero("Inagost",x,y,z);
end;
	
function Reinforcement_Adgot()
	if ( random( 2 ) == 1 ) then
		DeployReserveHero('Inagost', 59, 173, 0)
	else
		DeployReserveHero('Inagost', 2, 131, 0)
	end
	sleep(1)
	SetObjectiveState('sec2', OBJECTIVE_ACTIVE) ------Появляется герой противника!!!!
	hero_update()
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, 'adgot_hero_death');
	--Trigger(NEW_DAY_TRIGGER,nil) --после срабатывания триггер снимается чтобы не мешалс
end;

function H55_TriggerDaily() --вызывается триггером
	if GetDate(ABSOLUTE_DAY)==timer then
		StartDialogScene(C4M2D3) --Сцена появления Шадии
		sleep(1)
		SetObjectiveState('prim5', OBJECTIVE_ACTIVE)
		DeployReserveHero('Kelodin', 14, 156, 1)
	end
	if reinf == 1 then
		StartDialogScene(C4M2R4) --Сцена если пропустили гонцов
		sleep(1)
		SetObjectiveState('sec1', OBJECTIVE_FAILED)
		startThread( Reinforcement_Adgot )
		reinf = 0;
	end
end

function script_crap()
	DeployReserveHero('Inagost', 59, 173, 0)
	sleep(1)
	hero_update()
end

function adgot_hero_death(heroname)
	if heroname=='Inagost' then
		StartDialogScene(C4M2R5) --Сцена когда разгромим пришедшего героя
		SetObjectiveState('sec2',OBJECTIVE_COMPLETED)
		GiveExp( "Raelag", 3000 ); ---addexp!!!
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 0;
		--Trigger(NEW_DAY_TRIGGER, nil);
	end
end

function objective2()
	if GetObjectiveState('prim2')==OBJECTIVE_COMPLETED then
		ChangeHeroStat("Raelag", STAT_LUCK, 3);  -------Oblico_Morale!
		StartDialogScene(C4M2R6) --Сцена после постройки грааля
		sleep(2)
		startThread(WinConditions);
	end
end

function objective3()
	if GetObjectiveState('prim3')==OBJECTIVE_COMPLETED then
		ChangeHeroStat("Raelag", STAT_LUCK, 3);  -------Oblico_Morale!
		if first == 0 then
			startThread( Test1 );
			StartDialogScene(C4M2R2); --Сцена на захват всех городов клана
			first = 1;
		end;
		sleep(2)
		startThread(objective3_1); ---проверка гонцов нв комплит
		startThread(WinConditions);
	end
end
----------------------------///
function objective3_1()
	if ( GetObjectiveState('prim3')==OBJECTIVE_COMPLETED ) and ( GetObjectiveState('sec1') == OBJECTIVE_ACTIVE )then
		sleep(2)
		SetObjectiveState('sec1', OBJECTIVE_COMPLETED) ---комплит гонцов
	end
end
----------------------------///
function WinConditions()
	if ( GetObjectiveState('prim3') == OBJECTIVE_COMPLETED ) and ( GetObjectiveState('prim2') == OBJECTIVE_COMPLETED )then
		sleep(2)
		SaveHeroAllSetArtifactsEquipped("Raelag", "C4M2");
--		SetObjectiveState('prim5',OBJECTIVE_COMPLETED)
		SetObjectiveState('prim6',OBJECTIVE_COMPLETED)
		--GiveExp( "Raelag", 5000 ); ---addexp!!!
		sleep(2)
		print("Victoria................................!!!")
		Win();
	end
end;

function player_hero( name )
	if ( name == "Raelag" ) then -- raelag was eliminated
		SetObjectiveState( 'prim6', OBJECTIVE_FAILED )
		sleep(1)
		print("Raelag_kaput................................!!!")
		Loose()
	elseif ( GetObjectiveState( 'prim5') == OBJECTIVE_ACTIVE ) and ( name == "Kelodin" ) then -- shadya was eliminated
		SetObjectiveState( 'prim5', OBJECTIVE_FAILED )
		sleep(1)
		print("Shadia_kaput................................!!!")
		Loose();
	end;
end

------------------------------------------!!!!Last
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "escape1","Start_ai" );

function Start_ai( heroname )
	if IsPlayerHeroesInRegion(2, "escape1") == not nil and GetObjectOwner(heroname)==PLAYER_2 then
		sleep( );
		EnableHeroAI( heroname,not nil)
	end;
end;

---------------------------------------------------!!

SetPlayerHeroesCountNotForHire(1, 4 )

------------------------I find clovers!
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t1","One", nil );
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2","Two", nil );

--function One()
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t1", nil );
--SetObjectPosition("Raelag", 68, 122, 0);
--CreateArtifact("Clover", ARTIFACT_FOUR_LEAF_CLOVER, 67, 122, 0);
--end;

--function Two()
--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2", nil );
--SetObjectPosition("Raelag", 30, 149, 0);
--end;
-------------------------------
function Test1()
	local enemy = {};
	enemy = GetPlayerHeroes(PLAYER_2);
	for i, hero in enemy do
		RemoveObject(hero);
	end;
end;

------------------------Script Start---
DestroyTownBuildingToLevel("Angkar",TOWN_BUILDING_SPECIAL_4,0,0);
H55_CamFixTooManySkills(PLAYER_1,"Raelag");

town_triggering()
StartDialogScene(C4M2D1) --Сцена стартовая
OpenCircleFog( 46, 137, 1, 5, PLAYER_1 );
SetObjectEnabled('oracul', nil)
print("1")
SetAIPlayerAttractor('point1',PLAYER_2,-1)
print("2")
SetAIPlayerAttractor('point2',PLAYER_2,-1)
print("3")
Trigger(OBJECT_CAPTURE_TRIGGER, "post1", "post_capturing")
Trigger(OBJECT_CAPTURE_TRIGGER, "post2", "post_capturing")
Trigger(OBJECT_TOUCH_TRIGGER, "oracul", "oracul")
SetTrigger(OBJECTIVE_STATE_CHANGE_TRIGGER , 'prim2', 'objective2')
SetTrigger(OBJECTIVE_STATE_CHANGE_TRIGGER , 'prim3', 'objective3')
print("4")
Trigger(PLAYER_REMOVE_HERO_TRIGGER , PLAYER_1, 'player_hero')
print("5")
sleep (20);
startThread( Graal );
print("6")