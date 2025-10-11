H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M3");
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M2" );
end;

startThread(H55_InitSetArtifacts);

rebels_id = 0; -- глобальный идентификатор для рандомно генерящихся кричей
date_to_delete = {}; -- массив с датами удаления кричей
rebels_alive = {}; -- живые и мёртвые генерённые кричи
mine_capture_prob = 0; -- удельная вероятность захвата шахты
rebels_quantities_coeff = 0; -- коэффициент на кол-во кричей, генерящихся рандомно
message_capture_mine_show_once = 0; -- одноразовый переключатель на показ перезахвата шахты
ai_alert = 0; -- приоритет замков для АИ
reinf_cnt = 0; -- число захватов замков игроком 1
change_money_for_ai = 0;
LASZLO = 'Laszlo';
DUNCAN = 'Duncan';
ANDREI = 'Brem';
FREYDA = 'Freyda';

-- стоимость каждой кричи
creature_costs = { 15, 25, 50, 80, 85, 130, 250, 370, 600, 850, 1300, 1700, 2800, 3500, -- haven
	25, 45, 40, 60, 110, 160, 240, 350, 550, 780, 1400, 1666, 2666, 3666, -- inferno
	19, 30, 40, 60, 100, 140, 250, 380, 620, 850, 1400, 1700, 1600, 1900, -- undead
	35, 55, 70, 120, 120, 190, 320, 440, 630, 900, 1100, 1400, 2500, 3400, -- sylvan
	22, 35, 45, 70, 100, 150, 250, 340, 460, 630, 1400, 1700, 2700, 3300, -- academy
	60, 100, 125, 175, 140, 200, 300, 450, 550, 800, 1400, 1700, 3000, 3700, -- dungeon
	400, 400, 400, 400, 1200, 1200, 10000, -- neutrals
	24, 40, 45, 65, 130, 185, 160, 220, 470, 700, 1300, 1700, 2700, 3400, -- fortress
	25, 80, 130, 370, 850, 1700, 3500, -- haven alts
	150, 350, 1800, 900,-- a1 neutrals
	10, 20, 50, 70, 80, 120, 260, 360, 350, 500, 1250, 1600, 2900, 3450, -- stronghold
	45, 60, 160, 350, 780, 1666, 3666, -- inferno alts
	100, 175, 200, 450, 800, 1700, 3700, -- dungeon alts
	55, 120, 190, 440, 900, 1400, 3400, -- sylvan alts
	30, 60, 140, 380, 850, 1700, 1900, -- necro alts
	35, 70, 150, 340, 630, 1700, 3300, -- academy alts
	40, 65, 185, 220, 700, 1700, 3400, -- fortress alts
	20, 70, 120, 360, 500, 1600, 3450 }; -- stronghold alts

tele_pos = {};
tele_pos[ "town1" ] = { 11, 7 };
tele_pos[ "town2" ] = { 46, 39 };
tele_pos[ "town3" ] = { 67, 68 };
tele_pos[ "town4" ] = { 15, 80 };

function distance( ... )
	if arg.n == 2 then
		x1, y1 = GetObjectPosition( arg[1] );
		x2, y2 = GetObjectPosition( arg[2] );
	elseif arg.n == 4 then
		x1, y1 = arg[1], arg[2];
		x2, y2 = arg[3], arg[4];
	end;
	dist = sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) );
	return dist;
end;

-- установка настроек по уровню сложности
function SetupDifficulty()
	slozhnost = GetDifficulty();
	if slozhnost == DIFFICULTY_EASY then
		ai_alert = 1;
		mine_capture_prob = 6;
		start_wood = 15;
		start_ore = 15;
		start_sec_resource = 10;
		start_gold = 15000;
		rebels_quantities_coeff = 1.0;
		laszlo_army_coeff = 3.0;
		laszlo_attack_town = 1;
		change_money_for_ai = 1;
		garrison_koeff = 0;
	elseif slozhnost == DIFFICULTY_NORMAL then
		ai_alert = 1;
		mine_capture_prob = 6;
		start_wood = 15;
		start_ore = 15;
		start_sec_resource = 5;
		start_gold = 10000;
		rebels_quantities_coeff = 1.0;
		laszlo_army_coeff = 3.0;
		laszlo_attack_town = 1;
		change_money_for_ai = 1;
		garrison_koeff = 0;
	elseif slozhnost == DIFFICULTY_HARD then
		ai_alert = 1;
		mine_capture_prob = 8;
		start_wood = 10;
		start_ore = 10;
		start_sec_resource = 5;
		start_gold = 8000;
		rebels_quantities_coeff = 1.0;
		laszlo_army_coeff = 1.0;
		laszlo_attack_town = 0;
		change_money_for_ai = 0; -- no gold changes for ai
		garrison_koeff = 1;
	elseif slozhnost == DIFFICULTY_HEROIC then
		ai_alert = 1;
		mine_capture_prob = 10;
		start_wood = 5;
		start_ore = 5;
		start_sec_resource = 5;
		start_gold = 6000;
		rebels_quantities_coeff = 1.0;
		laszlo_army_coeff = 1.0;
		laszlo_attack_town = 0;
		change_money_for_ai = 0; -- no gold changes for ai
		garrison_koeff = 2;
	end;
	print('difficulty = ',slozhnost);
	guards_count = 30 * rebels_quantities_coeff; -- кол-во охраны в захватываемой шахте
	mine_cost = creature_costs[ CREATURE_MILITIAMAN ] * guards_count; -- стоимость шахты
	if garrison_koeff > 0 then
		AddObjectCreatures( "garrison1", CREATURE_ARCHER, 30 * garrison_koeff );
		AddObjectCreatures( "garrison1", CREATURE_FOOTMAN, 20 * garrison_koeff );
		AddObjectCreatures( "garrison1", CREATURE_MILITIAMAN, 40 * garrison_koeff );
		AddObjectCreatures( "garrison1", CREATURE_MARKSMAN, 30 * garrison_koeff );
		AddObjectCreatures( "garrison2", CREATURE_FOOTMAN, 20 * garrison_koeff );
		AddObjectCreatures( "garrison2", CREATURE_MARKSMAN, 30 * garrison_koeff );
		AddObjectCreatures( "garrison2", CREATURE_ARCHER, 30 * garrison_koeff );
		AddObjectCreatures( "garrison2", CREATURE_MILITIAMAN, 40 * garrison_koeff );
		AddObjectCreatures( "garrison3", CREATURE_SWORDSMAN, 15 * garrison_koeff );
		AddObjectCreatures( "garrison3", CREATURE_PRIEST, 5 * garrison_koeff );
		AddObjectCreatures( "garrison3", CREATURE_MARKSMAN, 25 * garrison_koeff );
	end;
end;

-- Действие триггера на захват города.
-- Вызывается при захвате любого из городов
function TownCaptured( oldowner, newowner, heroname, objectname )
	local cnt = 0;
	if newowner == PLAYER_2 then -- если захватил враг, то раскомплитить задание
		if ( GetObjectiveState( 'prim1' ) == OBJECTIVE_COMPLETED ) then
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
		end;
		return
	end;
	if newowner == PLAYER_1 then -- подкрепления даются только человеку-игроку
		reinf_cnt = reinf_cnt + 1;
		if ( reinf_cnt == 1 ) or ( reinf_cnt == 2 ) then -- если первый или второй захват города
			local px, py = tele_pos[ objectname ][1], tele_pos[ objectname ][2]; -- получить координаты, куда хочется ставить кричу
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
				end;
			end;
			for i = 1, rebels_id do -- найти всех повстанцев в окрестностях желаемой позиции и удалить их
				if rebels_alive[i] == 1 then
					monstername = "monster" .. i;
					if IsObjectExists( monstername ) then
						local ox, oy = GetObjectPosition( monstername );
						if ( ox <= px + 1 ) and ( ox >= px - 1 ) and ( oy <= py + 1 ) and ( oy >= py - 1 ) then
							RemoveObject( monstername );
							rebels_alive[i] = 0;
						end;
					end;
				end;
			end;
			PlayVisualEffect( "/Effects/_(Effect)/Spells/DimesionDoorEnd.xdb#xpointer(/Effect)", "", "tele", px + 0.5, py + 0.5, 0, 0, 0 );
			sleep( 3 );
			if reinf_cnt == 1 then -- поставить ренегатов			
				CreateMonster( "Gad1", CREATURE_ZEALOT, 11, px, py, 0, 0, 0 ); -- создать кричу
				sleep( 15 );
				PlayObjectAnimation( 'Gad1', 'rangeattack', ONESHOT );
			elseif reinf_cnt == 2 then
				CreateMonster( "Gad2", CREATURE_CHAMPION, 4, px, py, 0, 0, 0 ); -- создать кричу
				sleep( 15 );
				PlayObjectAnimation( 'Gad2', 'happy', ONESHOT );
			end;
			ShowFlyingSign( "/Maps/Scenario/A1C1M3/reinforcement.txt", 'Gad' .. reinf_cnt, PLAYER_1, 4 );
			--SetRegionBlocked( objectname, 1, PLAYER_2 );
			-- возможен казус: АИ может подобрать поставленных кричей
			-- теоретически можно наделать регионов и блокать тот, на котором стоит крича
		end;
	end;
	for i = 1, 4 do -- поставить повышенный приоритет всем захваченным городам
		if GetObjectOwner( 'town' .. i ) ~= PLAYER_2 then
			SetAIPlayerAttractor( 'town' .. i, PLAYER_2, ai_alert );
			cnt = cnt + 1;
		end;
	end;
	if cnt < 4 then
		return
	end;
	SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
	startThread( HowToWin );
end;

-- Действие триггера на убийство героев игрока 2
function EnemyHeroKilled( heroname )
	if heroname == DUNCAN then
		StartDialogScene( "/DialogScenes/A1C1/M3/S2/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 1 );
		SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
		startThread( HowToWin );
	end;
end;

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
		end;
	end;
	if ( cnt == 0 ) then -- если шахт нет, то выйти
		return
	end;
	--print( "player owned mines: ", cnt );
	if ( random( 100 ) < cnt * mine_capture_prob ) then -- вероятность = кол-во * уд. вероятность
		minestr = mines[random( cnt ) + 1]; -- получить случайную шахту
		cost = 0;
		for i = 1, CREATURES_COUNT - 1 do -- посчитать стоимость охраны
			cost = cost + creature_costs[ i ] * GetObjectCreatures( minestr, i );
		end;
		if ( cost >= mine_cost ) then -- выйти если у шахты есть охрана
			--print( "mine has guards" );
			return
		end;
		if distance( FREYDA, minestr ) <= 5 then -- выйти если Фрейда рядом с шахтой
			--print( "Freyda is nearby" );
			return
		end;
		if message_capture_mine_show_once == 0 then
			x, y, f = GetObjectPosition( minestr );
			zoom = 25;
			BlockGame();
			CreateMonster( 'fake_peasant', CREATURE_PEASANT, 30, x, y, f, 0, 0 ); -- создать кричу
			MoveCamera( x, y, f, zoom, 0, 0, 0, 1 );
			sleep( 20 );
			Play3DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, f );
			PlayObjectAnimation( 'fake_peasant', 'happy', ONESHOT );
			sleep( 20 );
			UnblockGame();
		end;
		SetObjectOwner( minestr, PLAYER_2 );
		for i = 1, CREATURES_COUNT - 1 do -- удалить старую охрану шахты
			RemoveObjectCreatures( minestr, i, 1000 );
		end;
		AddObjectCreatures( minestr, CREATURE_MILITIAMAN, guards_count + random( 10 ) ); -- дать охрану шахте
		if message_capture_mine_show_once == 0 then -- показать сообщение один раз
			RemoveObject( 'fake_peasant' );
			MessageBox( "/Maps/Scenario/A1C1M3/minecapture.txt" );
			message_capture_mine_show_once = 1;
		else
			ShowFlyingSign( "/Maps/Scenario/A1C1M3/minelost.txt", FREYDA, PLAYER_1, 3 );
		end;
	end;
end;

-- Функция дезертирует кричей в двеллингах городов
function CheckDwellings()
	for i = 1, 4 do
		dwellingstr = 'town' .. i;
		if GetObjectOwner( dwellingstr ) == PLAYER_1 then -- если город принадлежит игроку 1
			for i = 1, CREATURES_COUNT - 1 do
				num = GetObjectDwellingCreatures( dwellingstr, i );
				if num > 0 then
					SetObjectDwellingCreatures( dwellingstr, i, num - 1 ); -- если более одной, то уменьшить
				end;
			end;
		end;
	end;
end;

-- Функция генерит на карту несколько кричей (повстанцы)
function CreateRebels()
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
			end;
		end;
		
		if ( badpos == 0 ) and ( IsTilePassable( x, y, floor ) ) then -- если клетка свободна
			local type = random( 4 ) + 1;
			local creaturetype = rebels_types[ type ];
			local quantity = rebels_quantities[ type ] * rebels_quantities_coeff + random( 5 );
			rebels_id = rebels_id + 1;
			local monstername = 'monster' .. rebels_id;
			CreateMonster( monstername, creaturetype, quantity, x, y, floor, mood, courage, random( 360 ) ); -- создать кричу
			date_to_delete[rebels_id] = GetDate() + 1 + random( 3 ); -- занести в список дат время, когда надо удалять кричу
			rebels_alive[rebels_id] = 1;
		end;
	end;
	startThread( RebelsAping );
end;

-- найти существующих повстанцев и сделать анимацию тем из них, кого видит игрок
function RebelsAping()
	sleep( 5 );
	for i = 1, rebels_id do
		if rebels_alive[i] == 1 then
			local monstername = 'monster' .. i;
			if IsObjectExists( monstername ) then
				if IsObjectVisible( PLAYER_1, monstername ) then
					PlayObjectAnimation( monstername, 'attack00', ONESHOT );
				end;
			else
				rebels_alive[i] = 0;
			end;
		end;
	end;
end;

-- Функция удаляет поставленных ранее кричей
function DeleteRebels()
	for i, date in date_to_delete do
		if rebels_alive[i] == 1 then
			if IsObjectExists( 'monster' .. i ) and ( GetDate() == date ) then -- если крича существует и наступило время удаления
				rebels_alive[i] = 0;
				RemoveObject( 'monster' .. i );
			end;
		end;
	end;
end;

-- АИ читит себе деньги, так что я ему даю скриптом. Деньги зависят от кол-ва городов под его контролем.
function GiveMoneyToAI()
	local money = 0;
	if ( GetObjectOwner( 'town4' ) == PLAYER_2 ) then
		money = money + 2000;
	end;
	for i = 1, 3 do
		if ( GetObjectOwner( 'town' .. i ) == PLAYER_2 ) then
			money = money + 1500;
		end;
	end;
	if ( GetObjectOwner( 'mine12' ) == PLAYER_2 ) then
		money = money + 1000;
	end;
	SetPlayerResource( PLAYER_2, GOLD, money );
end;

-- Действие триггера NEW_DAY_TRIGGER
function H55_TriggerDaily()
	--SetPlayerResource( PLAYER_2, GOLD, 1000 );
	if change_money_for_ai == 1 then
		GiveMoneyToAI(); -- контролировать выдачу денег АИ, ибо читит, гад
	end;
	CheckMines();
	CheckDwellings();
	CreateRebels();
	DeleteRebels();
end;

-- Действие триггера: послать Андрея к гномам
function SendAndrei( heroname )
	if GetObjectOwner( heroname ) ~= PLAYER_1 then
		return
	end;
	for i = 1, 3 do
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event' .. i, nil );
	end;
	BlockGame();
	DeployReserveHero( ANDREI, 15, 81, 0 );
	DisableCameraFollowHeroes( 0, 0, 1 ); -- не двигать камеру за Андреем
	OpenCircleFog( 21, 86, 0, 9, PLAYER_1 );
	MoveCamera( 21, 82, 0, 50, 0, 0, 0, 1 ); -- переместить камеру
	sleep( 15 );
	MoveHeroRealTime( ANDREI, 31, 93, 0 ); -- послать Андрея к Гномам
	_, dy = GetObjectPosition( ANDREI );
	while dy > 0 do
		_, dy = GetObjectPosition( ANDREI );
		dy = 93 - dy;
		sleep( 1 );
	end;
	RemoveObject( ANDREI );
	UnblockGame();
	DisableCameraFollowHeroes( 0, 0, 0 );
	--DeployReserveHero( DUNCAN, 15, 77 );
	--sleep( 1 );
	
	ChangeHeroStat( DUNCAN, STAT_EXPERIENCE, 60000 ); -- crap for this time
	--AddHeroCreatures( DUNCAN, CREATURE_CAVALIER, 10 );
	--Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'EnemyHeroKilled' );
--	startThread( DeployLaszlo ); -- вызвать Лазло  ---------------------------------!!!!!!!!!DB
end;

-- Функция ставит Лазло, даёт ему войск и направляет к Столице
function DeployLaszlo()
	local coeff = ( GetDate( WEEK ) + ( GetDate( MONTH ) - 1 ) * 4 ) * laszlo_army_coeff + 1;
	local pos = { { 11, 79 }, { 13, 79 }, { 17, 79 }, { 19, 79 } };
	local reinfs = { { CREATURE_ZEALOT, 3 * coeff }, { CREATURE_VINDICATOR, 9 * coeff },
		{ CREATURE_CHAMPION, 2 * coeff }, { CREATURE_LONGBOWMAN, 10 * coeff } };
	
	DeployReserveHero( LASZLO, 57, 4, 0 );
	AddHeroCreatures( LASZLO, CREATURE_ZEALOT, 3 * coeff );
	AddHeroCreatures( LASZLO, CREATURE_CHAMPION, 2 * coeff );
	AddHeroCreatures( LASZLO, CREATURE_VINDICATOR, 10 * coeff );
	AddHeroCreatures( LASZLO, CREATURE_LONGBOWMAN, 12 * coeff );
	AddHeroCreatures( LASZLO, CREATURE_BATTLE_GRIFFIN, 5 * coeff );
	sleep( 1 );
	--EnableHeroAI( LASZLO, nil ); --H55 fix
	sleep( 1 );
	x, y = GetObjectPosition( 'town4' );
	if laszlo_attack_town == 0 then -- если Лазло не будет атаковать Столицу, то он встанет рядом
		x = x + 1;
		y = y - 10;
	end;
	
	MoveHeroRealTime( LASZLO, x, y );
	sleep( 1 );
	MoveHero( LASZLO, x, y );
	
	if laszlo_attack_town == 0 then
		local dy = 1000;
		while dy > 2 do
			sleep( 3 );
			_, dy = GetObjectPosition( LASZLO );
			dy = y - dy;
		end; -- ! можно заблокать путь через гарнизон и тогда Лазло встанет !
		if GetObjectOwner( 'town4' ) == PLAYER_2 then
			for i = 1, 4 do
				CreateMonster( 'siege1', reinfs[i][1], reinfs[i][2], pos[i][1], pos[i][2], 0, 0, 0, 180 );
			end;
		end;
	end;
	while GetObjectOwner( 'town4' ) == PLAYER_2 do
		sleep( 3 );
	end;
	MoveHero( LASZLO, GetObjectPos( LASZLO ) );
	--EnableHeroAI( LASZLO,not nil); --H55 fix
end;

-- Действие триггера при обнюхивании лучников-суккубов
function ShapeShifter( heroname, objectname )
	--print( heroname, ' touched ', objectname );
	Trigger( OBJECT_TOUCH_TRIGGER, objectname, nil );
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Gating.xdb#xpointer(/Effect)", objectname, "eff1", 0, 0, 0, 0, 0 );
	sleep( 3 );
	if objectname == "demon1" then
		StartCombat( heroname, nil, 3, CREATURE_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, nil, nil );
		SetRegionBlocked( 'block1', nil, PLAYER_2 );
	elseif objectname == "demon2" then
		StartCombat( heroname, nil, 3, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, nil, nil );
		SetRegionBlocked( 'block2', nil, PLAYER_2 );
	elseif objectname == "demon3" then
		StartCombat( heroname, nil, 3, CREATURE_SUCCUBUS, 9, CREATURE_INFERNAL_SUCCUBUS, 9, CREATURE_SUCCUBUS, 9, nil, nil );
		SetRegionBlocked( 'block3', nil, PLAYER_2 );
	end;
	RemoveObject( objectname );
end;

function PlayerHeroKilled( heroname )
	if ( heroname == FREYDA ) or ( heroname == LASZLO ) then
		SetObjectiveState( 'prim3', OBJECTIVE_FAILED );
		sleep( 1 );
		Loose();
	end;
end;

-- УЖОС!!!
function Horror( heroname )
	if GetObjectOwner( heroname ) ~= PLAYER_1 then
		return
	end;
	MoveCamera( 59, 9, 0, 17, 0, 0, 0, 1 ); -- придвинуть камеру без поворотов
	sleep( 2 );
	Play3DSound( "/Sounds/_(Sound)/Creatures/Inferno/ArchDevil/Happy.xdb#xpointer(/Sound)", GetObjectPosition( 'dead' ) ); -- страшный звук
	sleep( 7 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/FireWall_end.(Effect).xdb#xpointer(/Effect)", "dead", "deadeffect1", 0, 0, 0, 0, 0 ); -- огонёк
	PlayVisualEffect( "/Effects/_(Effect)/Spells/FireWall_end.(Effect).xdb#xpointer(/Effect)", "dead", "deadeffect2", 0, 0, 0, 90, 0 ); -- еще один
	Play2DSound( "/Sounds/_(Sound)/Spells/FireWall_end.xdb#xpointer(/Sound)");--, 59, 10, 0 ); -- звук огонька
	sleep( 3 );
	RemoveObject( 'dead' ); -- убрать жертву-пизанта
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'horror', nil );
end;

function HowToWin()
	while 1 do
		sleep( 3 );
		if ( GetObjectiveState( "prim1" ) == OBJECTIVE_COMPLETED ) and ( GetObjectiveState( "prim2" ) == OBJECTIVE_COMPLETED ) then
			SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M3");
			sleep( 1 );
			Win();
		end;
	end;
end;

-------------------
H55_CamFixTooManySkills(PLAYER_1,"Freyda");
StartDialogScene( "/DialogScenes/A1C1/M3/S1/DialogScene.xdb#xpointer(/DialogScene)" );

SetupDifficulty();
EnableHeroAI( DUNCAN, nil ); -- Дункан сидит в своей столице
SetPlayerStartResource( PLAYER_1, WOOD, start_wood );
SetPlayerStartResource( PLAYER_1, ORE, start_ore );
SetPlayerStartResource( PLAYER_1, SULFUR, start_sec_resource );
SetPlayerStartResource( PLAYER_1, CRYSTAL, start_sec_resource );
SetPlayerStartResource( PLAYER_1, GEM, start_sec_resource );
SetPlayerStartResource( PLAYER_1, MERCURY, start_sec_resource );
SetPlayerStartResource( PLAYER_1, GOLD, start_gold );
for i = 1, 3 do
	SetRegionBlocked( 'block' .. i, 1, PLAYER_2 ); -- заблокировать оборотней для АИ
	SetObjectEnabled( 'demon' .. i, nil ); -- отключить им ф-ность
	Trigger( OBJECT_TOUCH_TRIGGER, "demon" .. i, "ShapeShifter" ); -- повесить триггер на них
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'horror', 'Horror' ); -- триггер УЖОСА
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "NewDay" ); -- триггер на новый день
for i = 1, 4 do
	Trigger( OBJECT_CAPTURE_TRIGGER, "town" .. i, "TownCaptured" ); -- повесить триггер на захват любого из городов
	EnableAIHeroHiring( PLAYER_3, 'town' .. i, nil );
end;
for i = 1, 3 do
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'event' .. i, 'SendAndrei' ); -- триггер на приближение к столице
end;
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, 'PlayerHeroKilled' ); -- триггер на убийство героя игрока 2
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, 'EnemyHeroKilled' ); -- триггер на убийство героя игрока 2
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, 'PlayerHeroKilled' ); -- триггер на убийство героя игрока 3
SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );