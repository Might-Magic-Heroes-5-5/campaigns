doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

GRAIL_LOCATIONS = {
	[-1] = { xyz = {  35,  20, 0 }, message = "/Maps/SingleMissions/SL3/Text/finalsign1.txt", scene = "/DialogScenes/Single/SL3/R12/DialogScene.xdb#xpointer(/DialogScene)" },
	[0]  = { xyz = {  60,  82, 1 }, message = "/Maps/SingleMissions/SL3/Text/finalsign2.txt", scene = "/DialogScenes/Single/SL3/R13/DialogScene.xdb#xpointer(/DialogScene)" },
	[1]  = { xyz = { 106, 101, 0 }, message = "/Maps/SingleMissions/SL3/Text/finalsign3.txt", scene = "/DialogScenes/Single/SL3/R14/DialogScene.xdb#xpointer(/DialogScene)" },
}

SIGN = {
	CURRENT = 0,
	FINALE = -1,
	VISITS = {},
	
	setupFinale = function()
		local x,y,z = GetObjectPosition("grail");
		for key, value in GRAIL_LOCATIONS do
			if value.xyz[1] == x and value.xyz[2] == y and value.xyz[3] == z then
				SIGN.FINALE = key;
				return
			end
		end
	end,
	
	isFirstVisit = function( sign_id )
		if SIGN.VISITS[sign_id] == nil then
			for i = 1, 10 do
				if sign_id == "sign"..i then
					SIGN.CURRENT = i;
					SIGN.VISITS[sign_id] = 1;
					return 1;
				end
			end
		end
		return nil;
	end,
	
	activateNext = function()
		pcall( Trigger, OBJECT_TOUCH_TRIGGER, "sign"..(SIGN.CURRENT + 1), 'VisitSign' );
		pcall( SetObjectEnabled, "sign"..(SIGN.CURRENT + 1), nil );
	end,
	
	deactivatePrevious = function()
		pcall( Trigger, OBJECT_TOUCH_TRIGGER, (SIGN.CURRENT - 1), nil );
		pcall( SetObjectEnabled, (SIGN.CURRENT - 1), not nil );
	end,
	
	playScene = function()
		if SIGN.CURRENT == 10 then
			StartDialogScene(GRAIL_LOCATIONS[SIGN.FINALE].scene);
		else
			CINEMATICS.signVisit(SIGN.CURRENT + 2);
		end
	end,
	
	show = function(sign)
		local index = SIGN.CURRENT;
		if sign ~= "sign"..SIGN.CURRENT then -- show previous sign
			index =  SIGN.CURRENT - 1;
		end
		local message = "Maps/SingleMissions/SL3/Text/truesign"..index..".txt";
		if index == 10 then
			message = GRAIL_LOCATIONS[SIGN.FINALE].message;
		end
		ShowFlyMessage(message, sign, PLAYER_1, 8);
		MessageBox(message);
	end
}

function VisitSign(hero, object)
	if OBJECTIVES.state.readSigns[2] == 0 then
		OBJECTIVES.state.readSigns[2] = 1;
	end
	if SIGN.isFirstVisit(object) ~= nil then
		SIGN.show(object);
		OBJECTIVES.state.readSigns[2] = 3;
		if hero == "Ossir" then
			SIGN.playScene();
		end
		SIGN.activateNext(object);
		SIGN.deactivatePrevious(object);
	else
		SIGN.show(object);
	end
end

function information()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Warning", nil );
	MessageBox ("/Maps/SingleMissions/SL3/Text/stops.txt");
end

OBJECTIVES = {
	state = {
		findGrail = { "pri1", 1 },	-- find the Grail
		readSigns = { "Sec1", 0 },	-- read  the signs
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Warning","information", nil );
		Trigger (OBJECT_TOUCH_TRIGGER, 'sign1','VisitSign');
		SetObjectEnabled('sign1', nil);
		SIGN.setupFinale();
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end
			
			-- Win and Loss are handled by the map.xdb file
		end
	end,
	
	findGrail = function()
		if OBJECTIVES.state.findGrail[2] == 1 and IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) then
			CINEMATICS.outro();
			sleep(100);
			SetObjectiveState('Prim1',OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findGrail[2] = 10;
		end
	end,
	
	readSigns = function()
		if OBJECTIVES.state.readSigns[2] == 1 then
			SetObjectiveState('Sec1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.readSigns[2] = 2;
		elseif OBJECTIVES.state.readSigns[2] == 3 then
			ChangeHeroStat("Ossir", STAT_EXPERIENCE, 500 * SIGN.CURRENT);
			SetObjectiveProgress('Sec1', SIGN.CURRENT-1, PLAYER_1);
			if SIGN.CURRENT < 10 then
				OBJECTIVES.state.readSigns[2] = 2;
			else
				OBJECTIVES.state.readSigns[2] = 4;
			end
		elseif OBJECTIVES.state.readSigns[2] == 4 then
			SetObjectiveProgress('Sec1', SIGN.CURRENT + SIGN.FINALE, PLAYER_1);
			OBJECTIVES.state.readSigns[2] = 10;
		end
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/Single/SL3/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/Single/SL3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	signVisit = function(id)
		StartDialogScene("/DialogScenes/Single/SL3/R"..id.."/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}
------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function sl3_dbg(var)
	MakeHeroInteractWithObject("Ossir", "sign"..var);
end
