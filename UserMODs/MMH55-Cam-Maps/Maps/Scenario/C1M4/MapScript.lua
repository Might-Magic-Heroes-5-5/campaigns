doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M4");
	LoadHeroAllSetArtifacts( "Isabell" , "C1M3" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Isabell" );
end

startThread(H55_InitSetArtifacts);
HERO_NAME = "Isabell";

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end

CINEMATICS = {
    intro = function()
      StartDialogScene("/DialogScenes/C1/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
    end,

    captureTown = function()
      StartDialogScene("/DialogScenes/C1/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
    end,

    buildGuild = function()
      StartDialogScene("/DialogScenes/C1/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
    end,

    atBridge = function()
      StartDialogScene("/DialogScenes/C1/M4/D2/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
      x, y, fl = GetObjectPos( "hut" );
      OpenCircleFog( x, y, fl, 4, PLAYER_1 );
    end,

    atSeer = function()
      StartDialogScene("/DialogScenes/C1/M4/R3/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
     	x, y, fl = GetObjectPos( "crypt" );
    	OpenCircleFog( x, y, fl, 4, PLAYER_1 );
    end,

    bootsOfLevitation = function()
      StartDialogScene("/DialogScenes/C1/M4/R4/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
    end,
    
    outro = function()
      StartCutScene( "/Maps/Cutscenes/C1M4/_.(AnimScene).xdb#xpointer(/AnimScene)")
      sleep(2)
    end,
    
    outpostUnavailable = function()
	    MessageBox("/Maps/Scenario/C1M4/outpost.txt");
    end,
    
    oracleUnavailable = function()
	    MessageBox( "/Maps/Scenario/C1M4/visited.txt" );
    end,
}

TUTORIALS = {
    list = {
      	{     "c1_m4_t7", REGION_ENTER_AND_STOP_TRIGGER,       "t7_1",              "TUTORIALS.magicWell", 0 },
      	{     "c1_m4_t7", REGION_ENTER_AND_STOP_TRIGGER,       "t7_2",              "TUTORIALS.magicWell", 0 },
      	{     "c1_m4_t1", REGION_ENTER_AND_STOP_TRIGGER,         "t1",             "TUTORIALS.firstSpell", 0 },
      	{     "c1_m4_t4", REGION_ENTER_AND_STOP_TRIGGER,         "t4", "TUTORIALS.spellpowerAndKnowledge", 0 },
       	--{     "c1_m4_t8", REGION_ENTER_AND_STOP_TRIGGER,  "adventure",          "TUTORIALS.instantTravel", 0 },
      	-- {     "c1_m4_t9",          OBJECT_TOUCH_TRIGGER,       "t9_1",         "TUTORIALS.circlesOfMagic", 0 },
      	-- {     "c1_m4_t9",          OBJECT_TOUCH_TRIGGER,       "t9_4",         "TUTORIALS.circlesOfMagic", 0 },
      	-- {     "c1_m4_t9",          OBJECT_TOUCH_TRIGGER,       "t9_5",         "TUTORIALS.circlesOfMagic", 0 },
      	{     "c1_m4_t5",          OBJECT_TOUCH_TRIGGER, "FirstSpell",               "TUTORIALS.learning", 0 },
      	{    "c1_m4_t14",                        THREAD,            0,        "TUTORIALS.resurrectAllies", 0 },
      	{ "magic_skills",                        WINDOW,            0,                                  0, 0 },
    },

    run = function()
      SetGameVar(          "temp.tutorial", 1);
      SetGameVar(  "temp.CountVisitToTown", 0);
      SetGameVar(       "temp.CombatCount", 0);
      SetGameVar(      "temp.SpellLearned", 0);
      SetGameVar( "temp.ArhangelsCaptured", 0);
      manageTutorials(TUTORIALS.list);
    end,

    markComplete = function(name)
      print(name);
      for _, item3 in TUTORIALS.list do
        if item3[4] == name then
          item3[5] = 2;
        end
      end
    end,

    learning = function()
      SetGameVar( "temp.SpellLearned", 1 );
      Trigger( OBJECT_TOUCH_TRIGGER , "FirstSpell", nil );
      TUTORIALS.markComplete("TUTORIALS.learning");
    end,
    
    instantTravel = function()
      TutorialMessageBox( "c1_m4_t8" );
	    Trigger( REGION_ENTER_AND_STOP_TRIGGER , "adventure", nil );
	    TUTORIALS.markComplete("TUTORIALS.instantTravel");
    end,

    magicWell = function()
      TutorialMessageBox( "c1_m4_t7" );
    	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7_1", nil );
    	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7_2", nil );
    	TUTORIALS.markComplete("TUTORIALS.magicWell");
    end,

    firstSpell = function( hero )
      print( hero )
      TutorialMessageBox( "c1_m4_t1" );
      startThread( TUTORIALS.magicSchools, hero );
	    Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t1", nil );
	    TUTORIALS.markComplete("TUTORIALS.firstSpell");
    end,

    magicSchools = function( hero )
    	local x, y, l = GetObjectPos( hero );
    	local cx, cy, cl;
    	cx, cy, cl = x, y, l;
    	while len( cx - x + 1, cy - y ) < 20 do
    		cx, cy, cl = GetObjectPos( hero );
    		sleep(3);
    	end
    	TutorialMessageBox( "c1_m4_t2" );
    end,

    spellpowerAndKnowledge = function()
      TutorialMessageBox( "c1_m4_t4" );
	    Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t4", nil );
	    TUTORIALS.markComplete("TUTORIALS.spellpowerAndKnowledge");
    end,
    
    circlesOfMagic = function()
      TutorialMessageBox( "c1_m4_t9" );
	    Trigger( OBJECT_TOUCH_TRIGGER, "t9_1", nil);
      Trigger( OBJECT_TOUCH_TRIGGER, "t9_4", nil);
      Trigger( OBJECT_TOUCH_TRIGGER, "t9_5", nil);
      TUTORIALS.markComplete("TUTORIALS.circlesOfMagic");
    end,

    resurrectAllies = function()
	    while IsAnyHeroPlayerHasCreature( PLAYER_1, CREATURE_ARCHANGEL ) == nil do
		    sleep(10);
	    end
	    SetGameVar("temp.ArhangelsCaptured", 1);
	    TUTORIALS.markComplete("TUTORIALS.resurrectAllies");
    end,
}

BATTLES = {
	crypt = {
		start = function(heroname)
			local coeffs = { 0.4, 0.8, 1.4, 2.0 };
			local coeff = coeffs[ __difficulty + 1 ];
			local weeks = GetDate( WEEK ) + GetDate( MONTH ) * 4;
			print( 'weeks passed = ', weeks );
			local archers = 52 + coeff * 20 * weeks;
			local zombies = 39 + coeff * 15 * weeks;
			local ghosts = 25 + coeff * 9 * weeks;
			local lichs = 10 + coeff * 3 * weeks;
			local wraiths = 5 + coeff * 2 * weeks;
			print( 'army: '..archers..' '..zombies..' '..ghosts..' '..lichs..' '..wraiths);
			StartCombat( heroname, nil, 5, CREATURE_ZOMBIE, zombies, CREATURE_SKELETON_ARCHER, archers,
			CREATURE_GHOST, ghosts, CREATURE_WRAITH, wraiths, CREATURE_LICH, lichs, nil, 'BATTLES.crypt.finish' );
		end,
    
		finish = function(heroname, is_won)
			if is_won then
				GiveArtefact( heroname, ARTIFACT_BOOTS_OF_LEVITATION );
				Trigger( OBJECT_TOUCH_TRIGGER, "crypt", nil );
				MarkObjectAsVisited( 'crypt', heroname );
				sleep(3);
				OBJECTIVES.state.findBoots[2] = OBJECTIVES.state.findBoots[2] + 1;
			end
		end,
	}
}

OBJECTIVES = {
	
    state = {
      visitSeer	  = {   "sec1", 1 },
      findBoots	  = {   "sec2", 1 },
      meetElves   = {  "prim1", 1 },
      captureTown = { "prim2a", 1 },
      buildGuild  = {  "prim2", 1 },
      isAlive     = {  "prim3", 1 },
    },

    start = function()
      OBJECTIVES.prepare();
      OBJECTIVES.run();
    end,

    prepare = function()
      SetPlayerResource(PLAYER_1,   WOOD,0);
      SetPlayerResource(PLAYER_1,    ORE,0);
      SetPlayerResource(PLAYER_1,    GEM,0);
      SetPlayerResource(PLAYER_1,CRYSTAL,0);
      SetPlayerResource(PLAYER_1,MERCURY,0);
      SetPlayerResource(PLAYER_1, SULFUR,0);
      SetPlayerResource(PLAYER_1,   GOLD,0);
      ally_hero_on_site = 0;
      CINEMATICS.intro()
      OpenCircleFog( 34, 161, 0, 8, PLAYER_1 );
      OpenCircleFog( 81, 165, 0, 8, PLAYER_1 );
      x,y,z = RegionToPoint('Fog');
      OpenCircleFog(x, y, z, 5, PLAYER_1);
	end,

    run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] >= 1 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped(HERO_NAME, "C1M4");
				CINEMATICS.outro();
				Save("scene2");
				sleep(20);
				Win();
				return
			end
		end
	end,

	_visitBridge = function()
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "brige", nil );
		OBJECTIVES.state.visitSeer[2] = 3;
    end,

	_visitSeer = function(hero, obj)
		MarkObjectAsVisited('hut', hero);
		Trigger( OBJECT_TOUCH_TRIGGER, "hut", "CINEMATICS.oracleUnavailable" );
		OBJECTIVES.state.visitSeer[2] = 5;
    end,

	visitSeer = function()
		if OBJECTIVES.state.visitSeer[2] == 1 then
		    SetRegionBlocked('block', 1, PLAYER_1);
			SetObjectEnabled('hut', nil);
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "brige", "OBJECTIVES._visitBridge");
			OBJECTIVES.state.visitSeer[2] = 2;
		elseif OBJECTIVES.state.visitSeer[2] == 3 then
			CINEMATICS.atBridge();
			Trigger( OBJECT_TOUCH_TRIGGER, "hut", "OBJECTIVES._visitSeer" );
			SetObjectiveState("sec1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.visitSeer[2] = 4;
		elseif OBJECTIVES.state.visitSeer[2] == 5 then
			CINEMATICS.atSeer();
			OBJECTIVES.state.findBoots[2] = 3;
			SetObjectiveState( "sec1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.visitSeer[2] = 10;
		end
    end,

	findBoots = function()
		if OBJECTIVES.state.findBoots[2] == 1 then
			SetObjectEnabled('crypt', nil);
			Trigger(OBJECT_TOUCH_TRIGGER, 'crypt', 'BATTLES.crypt.start');
			OBJECTIVES.state.findBoots[2] = 2;
		elseif OBJECTIVES.state.findBoots[2] == 3 then
			SetObjectiveState("sec2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findBoots[2] = 4;
		elseif (OBJECTIVES.state.findBoots[2] == 4 or OBJECTIVES.state.findBoots[2] == 5) and HasArtefact(HERO_NAME, ARTIFACT_BOOTS_OF_LEVITATION) ~= nil then
			CINEMATICS.bootsOfLevitation();
			SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findBoots[2] = 10;
		end
    end,
    
	_MeetElves = function(heroname)
		if heroname == HERO_NAME then
			OBJECTIVES.state.meetElves[2] = 3;
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER,  "meeting_place", nil );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "meeting_place1", nil );
		else
			 MessageBox("/Maps/Scenario/C1M4/tutorial/C1M4_C8.txt");
		end
    end,
    
    meetElves = function()
		if OBJECTIVES.state.meetElves[2] == 1 then
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER,  "meeting_place", "OBJECTIVES._MeetElves" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "meeting_place1", "OBJECTIVES._MeetElves" );
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.meetElves[2] = 2;
		elseif OBJECTIVES.state.meetElves[2] == 3 then
		    SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.meetElves[2] = 10;
		end
    end,

	captureTown_week = 0,
    captureTown = function()
    -- start and completion of this task is handled by C1M4.xdb
		if OBJECTIVES.state.captureTown[2] == 1 and GetObjectOwner('mirakl') == PLAYER_1 then
			CINEMATICS.captureTown();
			OBJECTIVES.captureTown_week = GetDate(WEEK) + GetDate( MONTH ) * 4;
			OBJECTIVES.state.captureTown[2] = 10;
		end
    end,
    
	buildGuild = function()
    -- start and completion of this task is handled by C1M4.xdb
		if OBJECTIVES.state.buildGuild[2] == 1 then
			SetObjectEnabled('outpost', nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "outpost", "CINEMATICS.outpostUnavailable" );
			OBJECTIVES.state.buildGuild[2] = 2;
		elseif OBJECTIVES.state.buildGuild[2] == 2 and GetObjectOwner("mirakl") == PLAYER_1 and GetTownBuildingLevel( "mirakl", TOWN_BUILDING_MAGIC_GUILD ) == 3 then
			CINEMATICS.buildGuild();
			GiveExp(HERO_NAME, 20000 );
			Trigger(OBJECT_TOUCH_TRIGGER, "outpost", nil );
			SetObjectEnabled( 'outpost', 1 );
			SetRegionBlocked( 'block', nil, PLAYER_1 );
			OBJECTIVES.state.buildGuild[2] = 10;
		end
	end,

	isAlive = function()
	-- start of this task is handled by C1M4.xdb
		if IsHeroAlive(HERO_NAME) == nil then
			SetObjectiveState('prim3', OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
    end,
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( TUTORIALS.run );
