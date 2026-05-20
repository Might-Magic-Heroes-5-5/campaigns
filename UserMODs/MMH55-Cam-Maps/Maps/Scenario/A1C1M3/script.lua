doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end
H55_PlayerStatus = {0,1,1,2,2,2,2,2};
H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M3");
	LoadHeroAllSetArtifacts( 'Freyda' , "A1C1M2" );
end

startThread(H55_InitSetArtifacts);

rebels_id = 0; -- глобальный идентификатор для рандомно генерящихся кричей
date_to_delete = {}; -- массив с датами удаления кричей
rebels_alive = {}; -- живые и мёртвые генерённые кричи
message_capture_mine_show_once = 0; -- одноразовый переключатель на показ перезахвата шахты
ai_alert = 0; -- приоритет замков для АИ
reinf_cnt = 0; -- число захватов замков игроком 1

town_capture = {
	[ "town1" ] = { 11,  7,   CREATURE_ZEALOT, 'rangeattack' },
	[ "town2" ] = { 46, 39, CREATURE_CHAMPION,       'happy' },
	[ "town3" ] = { 67, 68,   CREATURE_ZEALOT, 'rangeattack' },
	[ "town4" ] = { 15, 80,               nil,           nil },
}

function distance( ... )
	if arg.n == 2 then
		x1, y1 = GetObjectPosition( arg[1] );
		x2, y2 = GetObjectPosition( arg[2] );
	elseif arg.n == 4 then
		x1, y1 = arg[1], arg[2];
		x2, y2 = arg[3], arg[4];
	end
	dist = sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) );
	return dist;
end

function A1C1M3_SetPlayer2Army(coef)
	-- Garrisons
	AddObjectCreatures( "garrison1",     CREATURE_ARCHER, 100 * coef );
	AddObjectCreatures( "garrison1",    CREATURE_FOOTMAN,  80 * coef );
	AddObjectCreatures( "garrison1", CREATURE_MILITIAMAN, 140 * coef );
	AddObjectCreatures( "garrison1",   CREATURE_MARKSMAN, 100 * coef );
	AddObjectCreatures( "garrison2",     CREATURE_ARCHER, 100 * coef );
	AddObjectCreatures( "garrison2",    CREATURE_FOOTMAN,  80 * coef );
	AddObjectCreatures( "garrison2", CREATURE_MILITIAMAN, 140 * coef );
	AddObjectCreatures( "garrison2",   CREATURE_MARKSMAN, 100 * coef );
	AddObjectCreatures( "garrison3",  CREATURE_SWORDSMAN,  50 * coef );
	AddObjectCreatures( "garrison3",     CREATURE_PRIEST,  10 * coef );
	AddObjectCreatures( "garrison3",   CREATURE_MARKSMAN,  75 * coef );
	-- Heroes
	AddObjectCreatures(      "Ving", CREATURE_MILITIAMAN, 50 * coef );
	AddObjectCreatures(      "Ving",     CREATURE_ARCHER, 25 * coef );
	AddObjectCreatures(      "Ving",    CREATURE_FOOTMAN, 10 * coef );
	AddObjectCreatures(      "Ving",     CREATURE_PRIEST,  2 * coef );
	ChangeHeroStat( 'Ving', STAT_EXPERIENCE, 10000 * coef );
	AddObjectCreatures(     "Sarge", CREATURE_MILITIAMAN, 50 * coef );
	AddObjectCreatures(     "Sarge",     CREATURE_ARCHER, 25 * coef );
	AddObjectCreatures(     "Sarge",    CREATURE_FOOTMAN, 10 * coef );
	AddObjectCreatures(     "Sarge",   CREATURE_CHAMPION,  1 * coef );
	ChangeHeroStat( 'Sarge', STAT_EXPERIENCE, 10000 * coef );
	AddObjectCreatures(    "Duncan", CREATURE_MILITIAMAN, 80 * coef );
	AddObjectCreatures(    "Duncan",   CREATURE_MARKSMAN, 40 * coef );
	AddObjectCreatures(    "Duncan",  CREATURE_SWORDSMAN, 20 * coef );
	AddObjectCreatures(    "Duncan",     CREATURE_PRIEST,  3 * coef );
	AddObjectCreatures(    "Duncan",   CREATURE_CHAMPION,  4 * coef );
	ChangeHeroStat( 'Duncan', STAT_EXPERIENCE, 35000 * math.pow(2, coef));
end

DIFFICULTY = {
	[0] = function()
		ai_alert = 1;
		mine_capture_prob = 5; -- удельная вероятность захвата шахты
		SetPlayerStartResources(PLAYER_1, 15, 15, 10, 10, 10, 10, 15000);
		SetPlayerStartResources(PLAYER_2, 10, 10,  5,  5,  5,  5,  5000);
		rebels_quantities_coeff = 0.05;
		A1C1M3_SetPlayer2Army(1);
	end,

	[1] = function()
		ai_alert = 1;
		mine_capture_prob = 6; 											-- удельная вероятность захвата шахты
		SetPlayerStartResources(PLAYER_1, 15, 15,  5,  5,  5,  5, 10000);
		SetPlayerStartResources(PLAYER_2, 15, 15, 10, 10, 10, 10, 10000);
		rebels_quantities_coeff = 0.1; 								-- коэффициент на кол-во кричей, генерящихся рандомно
		A1C1M3_SetPlayer2Army(2);
	end,
	
	[2] = function()
		ai_alert = 2;
		mine_capture_prob = 8; 											-- удельная вероятность захвата шахты
		SetPlayerStartResources(PLAYER_1, 10, 10,  5,  5,  5,  5,  8000);
		SetPlayerStartResources(PLAYER_2, 30, 30, 15, 15, 15, 15, 20000);
		rebels_quantities_coeff = 0.15;									-- коэффициент на кол-во кричей, генерящихся рандомно
		A1C1M3_SetPlayer2Army(3);
	end,
	
	[3] = function()
		ai_alert = 2;
		mine_capture_prob = 10;											-- удельная вероятность захвата шахты
		SetPlayerStartResources(PLAYER_1,  5,  5,  5,  5,  5,  5,  6000);
		SetPlayerStartResources(PLAYER_2, 45, 45, 25, 25, 25, 25, 40000);
		rebels_quantities_coeff = 0.2;									-- коэффициент на кол-во кричей, генерящихся рандомно
		A1C1M3_SetPlayer2Army(4);
	end,
}

-- Действие триггера на захват города.
-- Вызывается при захвате любого из городов
function TownCaptured( oldowner, newowner, heroname, objectname )
	if newowner == PLAYER_1 then -- подкрепления даются только человеку-игроку
		SetAIPlayerAttractor( objectname, PLAYER_2, ai_alert );
		if town_capture[objectname][3] ~= nil then
			local px, py = town_capture[ objectname ][1], town_capture[ objectname ][2]; -- получить координаты, куда хочется ставить кричу
			local xh, yh = GetObjectPosition( heroname ); -- координаты героя
			if distance( px, py, xh, yh ) < 2 then -- если герой рядом с желаемой позицией
				dx = px - xh;
				dy = py - yh;
				if ( dx == 0 ) or ( dy == 0 ) then -- сместить желаемую позицию в сторону от героя
					px = px + dx;
					py = py + dy;
				elseif ( objectname == "town1" ) or ( objectname == "town2" ) or ( objectname == "town4" ) then
					px = px + dx;
				else
					py = py + dy;
				end
			end
			for i = 1, rebels_id do -- найти всех повстанцев в окрестностях желаемой позиции и удалить их
				if rebels_alive[i] == 1 then
					monstername = "monster" .. i;
					if IsObjectExists( monstername ) then
						local ox, oy = GetObjectPosition( monstername );
						if ( ox <= px + 1 ) and ( ox >= px - 1 ) and ( oy <= py + 1 ) and ( oy >= py - 1 ) then
							RemoveObject( monstername );
							rebels_alive[i] = 0;
						end
					end
				end
			end
			PlayVisualEffect( "/Effects/_(Effect)/Spells/DimesionDoorEnd.xdb#xpointer(/Effect)", "", "tele", px + 0.5, py + 0.5, 0, 0, 0 );
			sleep( 10 );
			local unit_name = "Gad_"..objectname;
			CreateMonster( unit_name, town_capture[objectname][3], 11, px, py, 0, 0, 0 );
			sleep(20);
			PlayObjectAnimation( unit_name, town_capture[objectname][4], ONESHOT );
			ShowFlyingSign( "/Maps/Scenario/A1C1M3/reinforcement.txt", unit_name, PLAYER_1, 5 );
			town_capture[objectname][3] = nil;
		end
	elseif newowner == PLAYER_2 then
		SetAIPlayerAttractor( objectname, PLAYER_2, 0 );
	end
end

-- Функция подсчитывает сколько шахт у PLAYER_1 и случайным образом 
-- с некоторой вероятностью отдает одну шахту второму игроку
function CheckMines()
	local mines = {};
	local cnt = 0;
	local minestr;
	
	for i = 1, 12 do -- найти все шахты игрока 1
		minestr = 'mine' .. i;
		if GetObjectOwner( minestr ) == PLAYER_1 then
			cnt = cnt + 1;
			mines[cnt] = minestr;
		end
	end
	if ( cnt == 0 ) then -- если шахт нет, то выйти
		return
	end
	print( "player owned mines: ", cnt );
	if ( random( 100 ) < cnt * mine_capture_prob ) then -- вероятность = кол-во * уд. вероятность
		minestr = mines[random( cnt ) + 1]; -- получить случайную шахту
		cost = 0;
		for i = 1, CREATURES_COUNT - 1 do -- посчитать стоимость охраны
			if creature_costs[ i ] ~= nil then
				cost = cost + creature_costs[ i ] * GetObjectCreatures( minestr, i );
			end
		end
		if ( cost >= 9 * creature_costs[ CREATURE_FOOTMAN ] ) then	-- стоимость шахты, выйти если у шахты есть охрана
			--print( "mine has guards" );
			return
		end
		if distance( 'Freyda', minestr ) <= 5 then -- выйти если Фрейда рядом с шахтой
			--print( "Freyda is nearby" );
			return
		end
		if message_capture_mine_show_once == 0 then
			CINEMATICS.mineCaptured( minestr );
			message_capture_mine_show_once = 1;
		end
		SetObjectOwner( minestr, PLAYER_2 );
		for i = 1, 179 do -- удалить старую охрану шахты
			RemoveObjectCreatures( minestr, i, 1000 );
		end
		sleep(10);
		AddObjectCreatures( minestr, CREATURE_MILITIAMAN, 30 + random( 10 ) + OBJECTIVES.date ); -- дать охрану шахте
		ShowFlyingSign( "/Maps/Scenario/A1C1M3/minelost.txt", 'Freyda', PLAYER_1, 5 );
	end
end

-- Функция дезертирует кричей в двеллингах городов
function CheckDwellings()
	print("CheckDwellings...");
	for i = 1, 4 do
		local has_deserted = nil;
		local dwellingstr = 'town' .. i;
		if GetObjectOwner( dwellingstr ) == PLAYER_1 then -- если город принадлежит игроку 1
			for i = 1, 14 do
				local num = GetObjectDwellingCreatures( dwellingstr, i );
				if num > 0 then
					SetObjectDwellingCreatures( dwellingstr, i, num/2 );
					has_deserted = not nil;
				end
			end
		end
		if has_deserted ~= nil then
			ShowFlyingSign( "/Maps/Scenario/A1C1M1/messagebox13.txt", dwellingstr, PLAYER_1, 10 );
		end
	end
end

-- Функция генерит на карту несколько кричей (повстанцы)
function CreateRebels()
	print("CreateRebels...");
	local rebels_types = { CREATURE_PEASANT, CREATURE_MILITIAMAN, CREATURE_ARCHER, CREATURE_FOOTMAN, CREATURE_SWORDSMAN };
	local rebels_quantities = { 45, 39, 33, 25, 20 };
	local mood = 3; -- wild
	local courage = 1; -- alway fight
	local rebels_num = 7; -- кол-во генерируемых кричей
	local previous_pos = {};
	
	for i = 1, rebels_num do
		local x = random( 75 ) + 5;
		local y = random( 60 ) + 20;
		local floor = 0;
		local badpos = 0;
		
		previous_pos[i] = { x, y };

		for j = 1, i - 1 do
			if ( math.abs( previous_pos[j][1] - x ) <= 1 ) and ( math.abs( previous_pos[j][2] - y ) <= 1 ) then
				badpos = 1;
			end
		end
		
		if ( badpos == 0 ) and ( IsTilePassable( x, y, floor ) ) then -- если клетка свободна
			local type = random( 4 ) + 1;
			local creaturetype = rebels_types[ type ];
			local quantity = rebels_quantities[ type ] * (1 + rebels_quantities_coeff*(1 + random( 4 ) + OBJECTIVES.date/7));
			rebels_id = rebels_id + 1;
			local monstername = 'monster' .. rebels_id;
			CreateMonster( monstername, creaturetype, quantity, x, y, floor, mood, courage, random( 360 ) ); -- создать кричу
			date_to_delete[rebels_id] = GetDate() + 1 + random( 3 ); -- занести в список дат время, когда надо удалять кричу
			rebels_alive[rebels_id] = 1;
		end
	end
end

-- Функция удаляет поставленных ранее кричей
function DeleteRebels()
	print("DeleteRebels...");
	for i, date in date_to_delete do
		if rebels_alive[i] == 1 then
			if IsObjectExists( 'monster' .. i ) and ( GetDate() == date ) then -- если крича существует и наступило время удаления
				rebels_alive[i] = 0;
				RemoveObject( 'monster' .. i );
			end
		end
	end
end

-- Действие триггера: послать Андрея к гномам
function SendAndrei( heroname )
	if GetObjectOwner( heroname ) ~= PLAYER_1 then
		return
	end
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event1', nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event2', nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event3', nil );
	BlockGame();
	DeployReserveHero( 'Brem', 15, 81, 0 );
	DisableCameraFollowHeroes( 0, 0, 1 ); -- не двигать камеру за Андреем
	OpenCircleFog( 21, 86, 0, 9, PLAYER_1 );
	MoveCamera( 21, 82, 0, 50, 0, 0, 0, 1 ); -- переместить камеру
	sleep( 100 );
	MoveHeroRealTime( 'Brem', 31, 93, 0 ); -- послать Андрея к Гномам
	_, dy = GetObjectPosition( 'Brem' );
	while dy > 0 do
		_, dy = GetObjectPosition( 'Brem' );
		dy = 93 - dy;
		sleep( 10 );
	end
	RemoveObject( 'Brem' );
	DisableCameraFollowHeroes( 0, 0, 0 );
	UnblockGame();
end

function ownedTowns(player)
	local cnt = 0;
	for i = 1, 4 do
		if GetObjectOwner( 'town' .. i ) == player then
			cnt = cnt + 1;
		end
	end
	return cnt;
end

BATTLES = {
	ShapeShifter = function( heroname, objectname )
		Trigger( OBJECT_TOUCH_TRIGGER, objectname, nil );
		PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", objectname, "eff1", 0, 0, 0, 0, 0 );
		sleep( 20 );
		if objectname == "demon1" then
			StartCombat( heroname, nil, 3, CREATURE_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, nil, nil );
			SetRegionBlocked( 'block1', nil, PLAYER_2 );
		elseif objectname == "demon2" then
			StartCombat( heroname, nil, 3, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, nil, nil );
			SetRegionBlocked( 'block2', nil, PLAYER_2 );
		elseif objectname == "demon3" then
			StartCombat( heroname, nil, 3, CREATURE_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, nil, nil );
			SetRegionBlocked( 'block3', nil, PLAYER_2 );
		end
		RemoveObject( objectname );
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A1C1/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	welcomedByHorror = function( heroname )
		if GetObjectOwner( heroname ) ~= PLAYER_1 then
			return
		end
		MoveCamera( 59, 9, 0, 17, 0, 0, 0, 1 ); -- придвинуть камеру без поворотов
		sleep( 20 );
		Play3DSound( "/Sounds/_(Sound)/Creatures/Inferno/ArchDevil/Happy.xdb#xpointer(/Sound)", GetObjectPosition( 'dead' ) ); -- страшный звук
		sleep( 20 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireWall_end.(Effect).xdb#xpointer(/Effect)", "dead", "deadeffect1", 0, 0, 0, 0, 0 ); -- огонёк
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireWall_end.(Effect).xdb#xpointer(/Effect)", "dead", "deadeffect2", 0, 0, 0, 90, 0 ); -- еще один
		Play2DSound( "/Sounds/_(Sound)/Spells/FireWall_end.xdb#xpointer(/Sound)");--, 59, 10, 0 ); -- звук огонька
		sleep( 20 );
		RemoveObject( 'dead' ); -- убрать жертву-пизанта
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'horror', nil );
	end,
	
	mineCaptured = function( minestr )
		BlockGame();
		x, y, f = GetObjectPosition( minestr );
		CreateMonster( 'fake_peasant', CREATURE_PEASANT, 30, x, y, f, 0, 0 ); -- ??????? ?????
		MoveCamera( x, y, f, 25, 0, 0, 0, 1 );
		sleep( 100 );
		Play3DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, f );
		PlayObjectAnimation( 'fake_peasant', 'attack00', ONESHOT );
		sleep( 20 );
		MessageBox( "/Maps/Scenario/A1C1M3/minecapture.txt" );
		RemoveObject( 'fake_peasant' );
		UnblockGame();
	end,
	
	captureDuncan = function()
		StartDialogScene("/DialogScenes/A1C1/M3/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,	
}

OBJECTIVES = {
	state = {
		captureTowns 	= { "prim1", 1 },		-- capture towns
		captureDuncan	= { "prim2", 1 },		-- capture Duncan prisoner
		isAlive			= { "prim3", 1 },		-- Freyda must survive
		dailyTrigger	= {     "_", 1 },		-- Check dwellings, mines, rebels
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		H55_CamFixTooManySkills(PLAYER_1,'Freyda');
		CINEMATICS.intro();
		EnableHeroAI( 'Duncan', nil );
		SetHeroRoleMode( 'Duncan', HERO_ROLE_MODE_HERMIT );
		SetHeroRoleMode(   'Ving', HERO_ROLE_MODE_HERMIT );
		SetHeroRoleMode(  'Sarge', HERO_ROLE_MODE_HERMIT );
		startThread(DIFFICULTY[GetDifficulty()]);
		for i = 1, 3 do
			SetRegionBlocked( 'block' .. i, not nil, PLAYER_2 );                			-- заблокировать оборотней для АИ
			SetRegionBlocked( 'AIblockG' .. i, not nil, PLAYER_2);
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event' .. i, 'SendAndrei' ); 			-- триггер на приближение к столице
			SetObjectEnabled( 'demon' .. i, nil ); 						   					-- отключить им ф-ность
			Trigger( OBJECT_TOUCH_TRIGGER, "demon" .. i, "BATTLES.ShapeShifter" ); 			-- повесить триггер на них
		end

		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'horror', 'CINEMATICS.welcomedByHorror' );
		for i = 1, 4 do
			Trigger( OBJECT_CAPTURE_TRIGGER, "town" .. i, "TownCaptured" ); 		-- повесить триггер на захват любого из городов
		end
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end
			
			if GetObjectiveState("prim3") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState( "prim1" ) == OBJECTIVE_COMPLETED and GetObjectiveState( "prim2" ) == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped('Freyda', "A1C1M3");
				sleep( 50 );
				Win();
			end
		end
	end,
	
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 then
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureTowns[2] = 2;
		elseif OBJECTIVES.state.captureTowns[2] == 2 and ownedTowns(PLAYER_1) == 4 then
			SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.captureTowns[2] = 3;
		elseif OBJECTIVES.state.captureTowns[2] == 3 and ownedTowns(PLAYER_1) < 4 then
			OBJECTIVES.state.captureTowns[2] = 1;
		end			
	end,
	
	captureDuncan = function()
		-- start of this task is handled by A1C1M3.xdb
		if OBJECTIVES.state.captureDuncan[2] == 1 and IsHeroAlive('Duncan') == nil then
			CINEMATICS.captureDuncan();
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.captureDuncan[2] = 10;
		end
	end,
	
	isAlive = function()
		-- start of this task is handled by A1C1M3.xdb
		if OBJECTIVES.state.isAlive[2] > 0 and IsHeroAlive('Freyda') == nil or OBJECTIVES.state.isAlive[2] > 1 and IsHeroAlive("Laszlo") == nil then
			SetObjectiveState("prim3", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	dailyTrigger_day = 1,
	dailyTrigger = function()
		if OBJECTIVES.state.dailyTrigger[2] == 1 and OBJECTIVES.dailyTrigger_day < OBJECTIVES.date then
			CheckMines();
			CheckDwellings();
			CreateRebels();
			DeleteRebels();
			OBJECTIVES.dailyTrigger_day = OBJECTIVES.date;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
