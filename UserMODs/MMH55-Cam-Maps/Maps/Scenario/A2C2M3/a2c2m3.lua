doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

H55c_AI_CONTROLLED = {
	player1 = {          -- Human Player, Stronghold Gottai
		state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
		heroes = {},
		enemies = {},
	},
	player2 = { 		   -- Blue Haven player.
		state = 2,         
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 0.5, heroes = 1.0, towns = 0.3, is_enemy = 1 },  -- PLAYER3
		}
	},
	player3 = { 		   -- Red Haven player.
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 0.5, heroes = 1.0, towns = 0.3, is_enemy = 1 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
		}
	},
}

TOWNS = { "blue_haven_west_town", "blue_haven_center_town", "blue_haven_east_town", "red_haven_west_town", "red_haven_center_town", "red_haven_east_town", "orcish_town" };
TOWNS.n = table.length( TOWNS ); -- Константа для длины массива городов TOWNS
PATH = "Maps/Scenario/A2C2M3/";
PEASANT_HUTS_COUNT = 14; -- Константа для количества домиков крестьян, которые необходимо сжечь, чтобы выполнить задание "Сжечь деревни"
SHOOT_COST = 20*(GetDifficulty() + 1);
DAY_OPEN_DUNGEON_FOR_AI = 56;

FIREBALL = "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)";
PRIEST_HIT = "/Effects/_(Effect)/Characters/Creatures/Haven/Cleric/Hit.xdb#xpointer(/Effect)";
EFFECT_DUST = "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)";
EFFECT_ICEBOLT = "/Effects/_(Effect)/Spells/IceBolt.xdb#xpointer(/Effect)"; 
EFFECT_ARMAGEDDON = "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)"
EFFECT_FIRE = "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)";
EFFECT_TOWN_BURN = "/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)";
EFFECT_ICE_EXPLOSIVE = "/Effects/_(Effect)/Spells/Dispel.xdb#xpointer(/Effect)";
EFFECT_FIREWALL = "/Effects/_(Effect)/Spells/FireWall.(Effect).xdb#xpointer(/Effect)";
EFFECT_FIRE_01 = "/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)";
EFFECT_FIRE_02 = "/Effects/_(Effect)/Towns/Inferno/DemonGate.xdb#xpointer(/Effect)";
EFFECT_GLOW = "/Effects/_(Effect)/Environment/Inferno/Hellpikes/Hellpikes4x4_3.xdb#xpointer(/Effect)";
SOUND_EFFECT_ICE_EXPLOSIVE = "/Sounds/_(Sound)/Spells/Dispel.xdb#xpointer(/Sound)";
SOUND_EFFECT_ARMAGEDDON = "/Sounds/_(Sound)/Spells/Armageddon.xdb#xpointer(/Sound)";
SOUND_EFFECT_ICE_BOLT = "/Sounds/_(Sound)/Spells/IceBolt.xdb#xpointer(/Sound)";
SOUND_EFFECT_EXPLOSIVE_3D = "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)";
VOICEOVER_GOTAI_SEES_ELEMENTALS = "/Maps/Scenario/A2C2M3/A2C3M2_VO2_SeesElementals.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_CATAPULT_HARRASMENT = "/Maps/Scenario/A2C2M3/A2C3M2_VO3_CatapultHarrasment.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_FIRST_CATAPULT_INTERACT = "/Maps/Scenario/A2C2M3/A2C3M2_VO4_FirstCatapult.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_GOTAI_SEES_HAVEN_FIGHTING = "/Maps/Scenario/A2C2M3/A2C3M2_VO5_CivilWar.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_UNDERGROUND = "/Maps/Scenario/A2C2M3/A2C3M2_VO9_Underground.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_LOOTZONE = "/Maps/Scenario/A2C2M3/C2M3_AM6_Goblin_01sound.xdb#xpointer(/Sound)";
VOICEOVER_GOBLIN_ABOUT_DUNGEON = "/Maps/Scenario/A2C2M3/C2M3_AM4_Goblin_01sound.xdb#xpointer(/Sound)";
VOICEOVER_OBJECTIVE_DESTOY_TOWNS_ACTIVE = "/Maps/Scenario/A2C2M3/A2C3M2_VO6_DestroyTownsObj.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_COLLECT_ARTIFACTS = "/Maps/Scenario/A2C2M3/C2M3_AM5_Goblin_01sound.xdb#xpointer(/Sound)";
CIVIL_WAR_UNITS = {"crossbowman1", "crossbowman2", "crossbowman3", "archer1", "archer2", "archer3", 
					"champion", "paladin", "squire", "vindicator1", "vindicator2", "peasant1", "peasant2", "priest",
					"footman_catapulter1", "footman_catapulter2", "brute" };
isFirstCatapultTouch = 0;
razedBuildings = 0; -- Переменная (integer) для подсчета количества сожженных домиков

function ChangeResource( resourceKind, quantity, objectName )
	SetPlayerResource( PLAYER_1, resourceKind, GetPlayerResource( PLAYER_1, resourceKind ) + quantity, objectName );
end

function AllowRedHaven( playerID, allow )
	AllowPlayerTavernHero( playerID, "RedHeavenHero01", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero02", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero03", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero04", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero05", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero06", allow );
end;

function GiveTransferrableArtifacts()
    InitAllSetArtifacts( "A2C2M3", "Gottai" );
    LoadHeroAllSetArtifacts( "Gottai", "A2C2M1" );--Загрузить сетовые артефакты из миссии А2С2М1
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Gottai" );
end

DIFFICULTY = {
	[0] = function()
		difLevel = 1;
		AddHeroCreatures( "Gottai", CREATURE_ORC_WARRIOR, 30);
		AddHeroCreatures( "Gottai", CREATURE_CENTAUR, 40);
		AddHeroCreatures( "Gottai", CREATURE_SHAMAN, 10);
		AddHeroCreatures( "Gottai", CREATURE_GOBLIN, 60);
		SetPlayerStartResources( PLAYER_1, 15, 15, 5, 5, 5, 5, 30000);
		print("Difficulty Level is NORMAL");
	end,
	
	[1] = function()
		difLevel = 2;
		AddHeroCreatures( "Gottai", CREATURE_ORC_WARRIOR, 20);
		AddHeroCreatures( "Gottai", CREATURE_CENTAUR, 30);
		AddHeroCreatures( "Gottai", CREATURE_SHAMAN, 5);
		AddHeroCreatures( "Gottai", CREATURE_GOBLIN, 50);
		SetPlayerStartResources( PLAYER_1, 10, 10, 3, 3, 3, 3, 25000);
		GiveExp("Maeve", 58600);
		ChangeHeroStat("Maeve", STAT_ATTACK, 5);
		ChangeHeroStat("Maeve", STAT_DEFENCE, 5);
		ChangeHeroStat("Maeve", STAT_SPELL_POWER, 3);
		ChangeHeroStat("Maeve", STAT_KNOWLEDGE, 3);
		GiveExp("RedHeavenHero03", 58600);	
		ChangeHeroStat("RedHeavenHero03", STAT_ATTACK, 5);
		ChangeHeroStat("RedHeavenHero03", STAT_DEFENCE, 5);
		ChangeHeroStat("RedHeavenHero03", STAT_SPELL_POWER, 3);
		ChangeHeroStat("RedHeavenHero03", STAT_KNOWLEDGE, 3);		
		print("Difficulty Level is HARD");
	end,
	
	[2] = function()
		difLevel = 3;
		SetPlayerStartResources( PLAYER_1, 8, 8, 1, 1, 1, 1, 12000);
		GiveExp("Maeve", 181600);
		ChangeHeroStat("Maeve", STAT_ATTACK, 10);
		ChangeHeroStat("Maeve", STAT_DEFENCE, 10);
		ChangeHeroStat("Maeve", STAT_SPELL_POWER, 6);
		ChangeHeroStat("Maeve", STAT_KNOWLEDGE, 6);
		GiveExp("RedHeavenHero03", 181600);
		ChangeHeroStat("RedHeavenHero03", STAT_ATTACK, 10);
		ChangeHeroStat("RedHeavenHero03", STAT_DEFENCE, 10);
		ChangeHeroStat("RedHeavenHero03", STAT_SPELL_POWER, 6);
		ChangeHeroStat("RedHeavenHero03", STAT_KNOWLEDGE, 6);
		print("Difficulty Level is HEROIC");
	end,
	
	[3] = function()
		difLevel = 4;
		SetPlayerStartResources( PLAYER_1, 5, 5, 1, 1, 1, 1, 8000);
		GiveExp("Maeve", 434600);
		ChangeHeroStat("Maeve", STAT_ATTACK, 15);
		ChangeHeroStat("Maeve", STAT_DEFENCE, 15);
		ChangeHeroStat("Maeve", STAT_SPELL_POWER, 9);
		ChangeHeroStat("Maeve", STAT_KNOWLEDGE, 9);		
		GiveExp("RedHeavenHero03", 434600);
		ChangeHeroStat("RedHeavenHero03", STAT_ATTACK, 15);
		ChangeHeroStat("RedHeavenHero03", STAT_DEFENCE, 15);
		ChangeHeroStat("RedHeavenHero03", STAT_SPELL_POWER, 9);
		ChangeHeroStat("RedHeavenHero03", STAT_KNOWLEDGE, 9);		
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

function BurnTownWhenConquered( oldOwner, newOwner, hero, object )
	if newOwner == PLAYER_1 and oldOwner ~= PLAYER_1 and object ~= "orcish_town" then 
		H55c_Message.show( "Maps/Scenario/A2C2M3/MsgBox_WantToBurnTown.txt" );
		PlayRazedTownEffects( object );
		RazeTown( object );
		ChangeResource(   GOLD, 16000+random(4)*1000, hero );
		sleep(3);
		ChangeResource(    ORE,  	   20+random(10), hero );
		sleep(3);
		ChangeResource(   WOOD, 	   20+random(10), hero );
		sleep(3);
		ChangeResource(    GEM,			 6+random(5), hero );
		sleep(3);
		ChangeResource( CRYSTAL,		 6+random(5), hero );
		sleep(3);
		ChangeResource( SULFUR,			 6+random(5), hero );
		sleep(3);
		ChangeResource( MERCURY,		 6+random(5), hero );
	end
end

function PlayRazedTownEffects( town )
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	local x,y,floor = GetObjectPosition( town );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire", x-1.5, 	y-1, 0, 90, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x-1.5, 	y-1, 0, 90, floor );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire",   x-1, y+0.5, 0,  0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire",   x-1, y+0.5, 0,  0, floor );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire", x+1.5, 	y-1, 0,  0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x+1.5, 	y-1, 0, 90, floor );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire",   x+1, y+0.5, 0,  0, floor );
	PlayVisualEffect(  EFFECT_FIRE_01, "", "fire",   x+1, y+0.5, 0,  0, floor );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire",   x-1, 	  y, 0,  0, floor );
	PlayVisualEffect(  EFFECT_FIRE_01, "", "fire",   x-1, 	  y, 0,  0, floor );
	PlayVisualEffect( 	  EFFECT_DUST, "", "fire",   x+4, 	  y, 0,  0, floor );
	PlayVisualEffect(  EFFECT_FIRE_02, "", "fire",   x+4, 	  y, 0,  0, floor );
end

function BurnPeasantHut( hero, object )
	if GetObjectOwner( hero ) == PLAYER_1 then
		if OBJECTIVES.state.burnVillages[2] == 0 then
			OBJECTIVES.state.burnVillages[2] = 1;
		end
		RazeBuildingWithEffects( object ); -- Сжигаем домики со эффектами дыма и огня
		razedBuildings = razedBuildings + 1; -- считаем количество посещенных домиков
		ChangeResource( GOLD, 1200+random(5)*100, hero ); -- выдать игроку денег за сжигание домика
		sleep(3);
		ChangeResource( ORE,  1+random(2), hero );
		sleep(3);
		ChangeResource( WOOD, 1+random(3), hero );
	end
end

function RazeBuildingWithEffects( object )
	x, y, floor = GetObjectPosition( object );
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	PlayVisualEffect( EFFECT_DUST, "", "tag1", x, y, 0, floor ); -- Пыль
	PlayVisualEffect( EFFECT_FIRE, "", "tag2", x, y, 0, floor ); -- Огонь
	RazeBuilding( object );
end

ELEMENTALS = {
	CHOICE = nil,
	PHONEBOOK = {
		 fire_elemental = {  "fire_elemental", "water_elemental", 0, "WaterElementalWantKillMonster.txt", "ICEBOLT", "WaterElementalWantDestroyTown.txt", "FROST_NOVA" },
		water_elemental	= { "water_elemental",  "fire_elemental", 1,  "FireElementalWantKillMonster.txt", "FIREBALL",  "FireElementalWantDestroyTown.txt", "ARMAGEDDON" },
	},
	
	FIGHTING = function()
		while IsObjectExists( "fire_elemental" ) ~= nil and IsObjectExists( "water_elemental" ) ~= nil do
			PlayObjectAnimation( "fire_elemental", "attack00", ONESHOT );
			PlayObjectAnimation( "water_elemental", "attack00", ONESHOT );
			sleep( 100 );
		end
	end,
	
	INFORMATION_FROM_MERMAID = function( hero )
		if GetObjectOwner( hero ) == PLAYER_1 then
			Trigger( OBJECT_TOUCH_TRIGGER, "mermaid", nil );
			MessageBox( PATH.."MsgBox_MermaidAboutElementals.txt" );
		end	
	end,
	
	FOUND = function(hero)
		if GetObjectOwner( hero ) == PLAYER_1 then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ElementalsArea", nil );
			PlayVoiceoverAndBlockGame( VOICEOVER_GOTAI_SEES_ELEMENTALS );
		end
	end,
	
	COMBAT = {
		START = function( hero, object )
			if GetObjectOwner( hero ) == PLAYER_1 then
				ELEMENTALS.CHOICE = ELEMENTALS.PHONEBOOK[object];
				local unit = CREATURE_FIRE_ELEMENTAL;
				if object == 'water_elemental' then
					unit = CREATURE_WATER_ELEMENTAL;
				end
				StartCombat( hero, nil, 1, unit, 20 + difLevel*20, nil, "ELEMENTALS.COMBAT.RESULT", nil, nil );
			end
		end,
		
		RESULT = function( hero, result )
			if result ~= nil then
				pcall( RemoveObject, ELEMENTALS.CHOICE[1] );
				CINEMATICS.speakWithElementals( hero, ELEMENTALS.CHOICE[3], ELEMENTALS.CHOICE[2] );
				SetRegionAutoObjectEnable(		 "titan_area", REGION_AUTOACTION_ON_ENTER, -1, -1, hero,				 "titan", 0 );
				SetRegionAutoObjectEnable( "megamonster_area", REGION_AUTOACTION_ON_ENTER, -1, -1, hero,		   "megamonster", 0 );
				SetRegionAutoObjectEnable( 		  "town_area", REGION_AUTOACTION_ON_ENTER, -1, -1, hero, "red_haven_center_town", 0 );
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER,		  "titan_area",		   "ELEMENTALS.HELP_AGAINST.TITAN" );
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", "ELEMENTALS.HELP_AGAINST.KNIGHT" );
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 	   "town_area",			"ELEMENTALS.HELP_AGAINST.TOWN" );	
			end
		end,
	},
	
	HELP_AGAINST = { 
		TOWN = function( hero )
			if ELEMENTALS.CHOICE ~= nil and GetObjectOwner( hero ) == PLAYER_1 then
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", nil );
				if GetObjectOwner( "red_haven_center_town" ) ~= PLAYER_1 then
					startThread( CINEMATICS.castSpellOnUnit, "red_haven_center_town", PATH..ELEMENTALS.CHOICE[6], ELEMENTALS.CHOICE[7], "town" );
				end
			end
		end,
		
		KNIGHT = function( hero )
			if ELEMENTALS.CHOICE ~= nil and GetObjectOwner( hero ) == PLAYER_1 then
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", nil );
				startThread( CINEMATICS.castSpellOnUnit, "megamonster", PATH..ELEMENTALS.CHOICE[4], ELEMENTALS.CHOICE[5], "unit" );
			end
		end,
		
		TITAN = function( hero )
			if ELEMENTALS.CHOICE ~= nil and GetObjectOwner( hero ) == PLAYER_1 then
				Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "titan_area", nil );
				startThread( CINEMATICS.castSpellOnUnit, "titan", PATH..ELEMENTALS.CHOICE[4], ELEMENTALS.CHOICE[5], "unit" );
			end
		end,
	},
}

WHIRLPOOL = {
	GROUND = {
		TOUCH = function( hero )
			if GetObjectOwner( hero ) == PLAYER_1 then
				QuestionBox("/Maps/Scenario/A2C2M3/MsgBox_WantToEnterWhirlPool.txt", "WHIRLPOOL.GROUND.COMBAT.START('"..hero.."')");
			end
		end,
		
		COMBAT = {
			START = function( hero )
				StartCombat(hero, nil, 2, CREATURE_WATER_ELEMENTAL, 24 * difLevel, CREATURE_WATER_ELEMENTAL, 24 * difLevel, nil, "WHIRLPOOL.GROUND.COMBAT.RESULT", nil, not nil );
			end,
		
			RESULT = function( hero, result )
				if result ~= nil then
					Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_ground", "WHIRLPOOL.GROUND.ENTER");
					local pool_x, pool_y = GetObjectPosition( "whirlpool_ground" ); 
					MoveHeroRealTimeAndReachPoint( hero, pool_x, pool_y, GROUND );
				end
			end,
		},
		
		ENTER = function( hero )
			if GetObjectOwner( hero ) == PLAYER_1 then
				BlockGame();
				local whirlpool_x, whirlpool_y, whirlpool_floor = GetObjectPosition( "whirlpool_underground" );
				OpenCircleFog( whirlpool_x, whirlpool_y, whirlpool_floor, 7, PLAYER_1 );
				MoveCamera( whirlpool_x, whirlpool_y, whirlpool_floor, 31, 1.2, 0, 1, 1, 0);
				SetObjectPosition( hero, whirlpool_x, whirlpool_y, whirlpool_floor );
				sleep(100);
				UnblockGame();
			end
		end,
	},
	
	UNDERGROUND = {
		FIRST_VISIT = function( hero )
			if GetObjectOwner( hero ) == PLAYER_1 then
				Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon_2", nil );
				Play2DSound( VOICEOVER_UNDERGROUND );
			end
		end
	},
}

function StartDemonScene( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, "demon", nil);
		CINEMATICS.attackedByDemons( hero );
	end
end

function MoveHeroRealTimeAndReachPoint( heroName, x, y, floor )
	moveCost = CalcHeroMoveCost( heroName, x, y, GROUND );
	ChangeHeroStat( heroName, STAT_MOVE_POINTS, moveCost );
	sleep(1);
	MoveHeroRealTime( heroName, x, y, GROUND );
end

function destroyTown( town )
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	RazeTown( town );
end

function destroyWindmill( name )
	local x, y, z = GetObjectPosition( name );
	PlayVisualEffect(EFFECT_DUST, "", "tag1", x, y, 0, 0, z );
	RazeBuilding( name );
	SetObjectPosition( 	  "windmill_gold",  28, 124, GROUND );
	SetObjectPosition( 	  "windmill_wood",  28, 125, GROUND );
	SetObjectPosition( 	   "windmill_ore",  28, 126, GROUND );
	SetObjectPosition( "windmill_mercury",  28, 127, GROUND );
end

function killUnit( name )
	if IsObjectExists( name ) ~= nil then
		local result = pcall( PlayObjectAnimation, name, "death", ONESHOT_STILL );
		if result ~= nil then
			sleep( 60 );
		end
		RemoveObject( name );
	end
end

function OutpostCrush( name )
	local x, y, z = GetObjectPosition( name );
	PlayVisualEffect( EFFECT_DUST, "","tag1", x, y, z );
	for i=1, 179 do
		RemoveObjectCreatures( name, i, 10000);
	end
end

function GetCatapultTarget(catapultKey)
	local catapult = CATAPULT.TARGETS[catapultKey];

	if catapult == nil then
		print("GetCatapultTarget: bad catapult key ", catapultKey);
		return nil;
	end

	local candidates = {};

	-- Static targets assigned to this catapult.
	for i, targetId in catapult.static do
		local rosterTarget = CATAPULT.TARGET_ROSTER[targetId];

		if rosterTarget ~= nil and rosterTarget.hp > 0 and IsObjectExists(targetId) ~= nil then
			local x, y, z = GetObjectPosition(targetId);
			Catapult_AddCandidate(candidates, targetId, { x, y, z }, nil);
		end
	end

	-- Dynamic enemy hero targets from regions.
	for i, regionName in catapult.regions do
		local heroes = GetObjectsInRegion(regionName, OBJECT_HERO);

		if heroes ~= nil and table.length(heroes) > 0 then
			for j, heroName in heroes do
				if GetObjectOwner(heroName) ~= PLAYER_1 then
					local x, y, z = GetObjectPosition(heroName);
					Catapult_AddCandidate(candidates, heroName, { x, y, z }, 1);
				end
			end
		end
	end

	-- No valid target: shoot at default empty coordinates.
	if table.length(candidates) == 0 then
		return {
			id = nil,
			pos = catapult.pos,
			empty = 1,
		};
	end

	return candidates[math.random(1, table.length(candidates))];
end

function PeasantHutCrush(index)
	if IsObjectExists( index ) then
		RazeBuildingWithEffects( index );
		razedBuildings = razedBuildings + 1;
	end
end

function Catapult_AddCandidate(list, id, pos, dynamic)
	local n = table.length(list) + 1;

	list[n] = {
		id = id,
		pos = pos,
		dynamic = dynamic,
	};
end

function Catapult_RemoveStaticTarget(catapultKey, targetId)
	local staticList = CATAPULT.TARGETS[catapultKey].static;
	local count = table.length(staticList);

	for i = 1, count do
		if staticList[i] == targetId then
			for j = i, count - 1 do
				staticList[j] = staticList[j + 1];
			end

			staticList[count] = nil;
			return
		end
	end
end

function Catapult_DamageTarget(catapultKey, target)
	if target.id == nil then
		return
	end

	-- Dynamic region target, not stored in TARGET_ROSTER.
	if target.dynamic ~= nil then
		killUnit(target.id);
		return
	end

	local rosterTarget = CATAPULT.TARGET_ROSTER[target.id];

	if rosterTarget == nil then
		print("Catapult_DamageTarget: missing roster target ", target.id);
		return
	end

	rosterTarget.hp = rosterTarget.hp - 1;
	print("Catapult target ", target.id, " hp ", rosterTarget.hp, " left");

	if rosterTarget.hp <= 0 then
		pcall(rosterTarget.kill, target.id);
		pcall(rosterTarget.deathScript);
		Catapult_RemoveStaticTarget(catapultKey, target.id);
	end
end

function Catapult_RunDeathScript(scriptName, targetId, catapultKey)
	if scriptName == nil then
		return
	end

	local func = _G[scriptName];

	if func ~= nil then
		pcall(func, targetId, catapultKey);
	else
		print("Catapult_RunDeathScript: missing script ", scriptName);
	end
end

function unblockBlueHero()
	SetRegionBlocked( "blue_haven_center_town_area", nil, PLAYER_2 ); 	-- unblock player 2 hero from exiting main stronghold
	H55c_AIAddHero("Maeve");
end

function unblockRedHero()
	SetRegionBlocked( "west_player3", nil, PLAYER_3 );	-- unblock player 3 hero from exiting main stronghold
	H55c_AIAddHero("RedHeavenHero03");
end

CATAPULT = {
	CHOICE = nil,
	TARGET_ROSTER = {
		blue_haven_center_town = { hp = 3, kill = destroyTown,     deathScript = unblockBlueHero },
		red_haven_east_town    = { hp = 3, kill = destroyTown,     deathScript = nil },
		red_haven_west_town    = { hp = 3, kill = destroyTown,     deathScript = unblockRedHero },
		windmill               = { hp = 1, kill = destroyWindmill, deathScript = nil },
		outpost                = { hp = 1, kill = OutpostCrush,    deathScript = nil },
		peasant_hut7           = { hp = 1, kill = PeasantHutCrush, deathScript = nil },
		megamonster            = { hp = 1, kill = killUnit,        deathScript = nil },

		peasant2               = { hp = 1, kill = killUnit,        deathScript = nil },
		squire                 = { hp = 1, kill = killUnit,        deathScript = nil },
		priest                 = { hp = 1, kill = killUnit,        deathScript = nil },
		footman_catapulter1    = { hp = 1, kill = killUnit,        deathScript = nil },
	},
	
	TARGETS = {
		sw_center_blue_town = { pos = {  56, 102, GROUND }, static = { "blue_haven_center_town" }, regions = {} },
		sw_red_town_east 	= { pos = { 149,  32, GROUND }, static = { 	  "red_haven_east_town" }, regions = {} },
		sw_red_town_west 	= { pos = {  43,  32, GROUND }, static = { 	  "red_haven_west_town" }, regions = {} },
		sw_windmill 		= { pos = {  29, 125, GROUND }, static = { 				 "windmill" }, regions = {} },
		sw_bridge_blue2 	= { pos = {  72,  73, GROUND }, static = { 				  "outpost" }, regions = {} },
		sw_bridge_blue1 	= { pos = {  79,  76, GROUND }, static = { 			 "peasant_hut7" }, regions = {} },
		sw_megamonster 		= { pos = { 140,  24, GROUND }, static = { 			  "megamonster" }, regions = {} },
		sw_bridge_red 		= { pos = {  57,  75, GROUND }, static = { "peasant2", "squire", "priest", "footman_catapulter1" }, regions = { "enemy_hero" } },
	},
	
	OPERATE = function( hero, object )
		if GetObjectOwner( hero ) ~= PLAYER_1 then return end
		if isFirstCatapultTouch == 0 then
			isFirstCatapultTouch=1;
			Play2DSound( VOICEOVER_FIRST_CATAPULT_INTERACT );
		end
		CATAPULT.CHOICE = nil;
		QuestionBox( { PATH.."WantToShoot.txt"; ore = SHOOT_COST }, "WantToShootCatapult", "DoNotShootCatapult" );
		repeat sleep(10); until CATAPULT.CHOICE ~= nil;
		if CATAPULT.CHOICE == 1 then
			local catapultKey = object;
			local catapult_name = "catapult_"..object;
			local StoneQuantity = GetPlayerResource( PLAYER_1, ORE );

			if StoneQuantity < SHOOT_COST then
				MessageBox( PATH.."NotEnoughStone.txt" );
			else
				local target = GetCatapultTarget(catapultKey);
				if target == nil then
					print("CATAPULT.OPERATE: bad catapult key ", catapultKey);
					CATAPULT.CHOICE = nil;
					return
				end
				
				SetPlayerResource( PLAYER_1, ORE, (StoneQuantity - SHOOT_COST) );
				BlockGame();
				PlayObjectAnimation( catapult_name, "rangeattack", ONESHOT );
				sleep( 30 );
				OpenCircleFog( target.pos[1], target.pos[2], target.pos[3], 7, PLAYER_1 );
				MoveCamera( target.pos[1], target.pos[2], target.pos[3], 31, 1.2, 0, 1, 1, 1 );
				sleep( 15 );
				PlayVisualEffect( FIREBALL, '', 'boom', target.pos[1], target.pos[2], 0, 0, target.pos[3] );
				Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, target.pos[1], target.pos[2], target.pos[3] );
				if target.empty == nil then
					Catapult_DamageTarget(catapultKey, target);
				else
					print("CATAPULT.OPERATE: empty shot from ", catapultKey);
				end
				sleep(50);

				local x, y, z = GetObjectPosition(catapult_name);
				MoveCamera(x, y, z, 31, 1.2, 0, 1, 1, 1);
				UnblockGame();
			end
		end
		CATAPULT.CHOICE = nil;
	end,
}

function DoNotShootCatapult()
	CATAPULT.CHOICE = 2;
end

function WantToShootCatapult()
	CATAPULT.CHOICE = 1;
end

function IsCivilWarVisible()
	for i=1, table.length( CIVIL_WAR_UNITS ) do
		if IsObjectVisible( PLAYER_1, CIVIL_WAR_UNITS[i] ) == not nil then
			return 1;
		end
	end
	return nil;
end

function StartCivilWarScene()
	while IsCivilWarVisible() == nil do sleep(10); end;
	hero_x, hero_y, hero_floor = GetObjectPosition( "Gottai" );
	OpenCircleFog( 64, 74, GROUND, 23, PLAYER_1 );
	BlockGame();	
	MoveCamera(54,69, GROUND, 31, 0.6, -0.55,0,0,1);
	sleep(10);
	PlayObjectAnimation( 	  "archer1", "rangeattack", IDLE );
	PlayObjectAnimation( 	  "archer2", "rangeattack", IDLE );
	PlayObjectAnimation( 	  "archer3", "rangeattack", IDLE );
	PlayObjectAnimation(  "vindicator1", 	"attack00", IDLE );
	PlayObjectAnimation(  "vindicator2", 	"attack00", IDLE );
	PlayObjectAnimation(	   "squire", 	"attack00", IDLE );
	PlayObjectAnimation(	 "peasant1", 	"attack00", IDLE );
	PlayObjectAnimation( 	 "peasant2", 	"attack00", IDLE );
	PlayObjectAnimation( "crossbowman1", "rangeattack", IDLE );
	PlayObjectAnimation( "crossbowman2", "rangeattack", IDLE );
	PlayObjectAnimation( "crossbowman3", "rangeattack", IDLE );
	PlayObjectAnimation( 	 "champion", 	"attack00", IDLE );
	PlayObjectAnimation( 	  "paladin", 	"attack00", IDLE );
	sleep(25);
	Play2DSound( VOICEOVER_GOTAI_SEES_HAVEN_FIGHTING );
	PlayObjectAnimation( 	 "champion", 	  "death", ONESHOT_STILL );
	PlayObjectAnimation( 	  "paladin", 	   "happy", ONESHOT );
	PlayObjectAnimation( 	  "archer1", 	   "happy", ONESHOT );
	PlayObjectAnimation( 	  "archer2", 	   "happy", ONESHOT );
	PlayObjectAnimation( 	  "archer3", 	   "happy", ONESHOT );
	sleep(25);
	PlayObjectAnimation(		"brute", "attack00", ONESHOT );
	sleep(5);
	PlayObjectAnimation( "catapult_sw_bridge_red", "rangeattack", ONESHOT );
	sleep(15);
	local x,y = GetObjectPosition( "archer2" );
	PlayVisualEffect( FIREBALL, '', 'boom', x, y, 0, 0, GROUND );
	Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, x, y, 0);
	sleep(15);
	PlayObjectAnimation( 	  "archer1", 	   "death", ONESHOT_STILL );
	PlayObjectAnimation( 	  "archer2", 	   "death", ONESHOT_STILL );
	PlayObjectAnimation( 	  "archer3", 	   "death", ONESHOT_STILL );
	sleep(15);
	PlayObjectAnimation( "paladin", "death", ONESHOT_STILL );
	sleep(20);
	PlayObjectAnimation( "crossbowman1", 	   "happy", ONESHOT );
	PlayObjectAnimation( "crossbowman2", 	   "happy", ONESHOT );
	PlayObjectAnimation( "crossbowman3", 	   "happy", ONESHOT );
	sleep(5);
	PlayObjectAnimation( "footman_catapulter1", "attack00", ONESHOT );
	sleep(25);
	PlayObjectAnimation( "catapult_sw_bridge_blue1", "rangeattack", ONESHOT );
	sleep(15);
	PlayVisualEffect( FIREBALL, '', 'boom', 76, 81, 0, 0, GROUND );
	Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, x, y, 0);
	PlayObjectAnimation( "footman_catapulter2", "attack00", ONESHOT );
	sleep(25);
	PlayObjectAnimation( "catapult_sw_bridge_blue2", "rangeattack", ONESHOT );
	sleep(15);
	x,y = GetObjectPosition( "crossbowman2" );
	PlayVisualEffect( FIREBALL, '', 'boom', x, y, 0, 0, GROUND );
	Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, x, y, 0);
	PlayObjectAnimation( "crossbowman1", 	   "death", ONESHOT_STILL );
	PlayObjectAnimation( "crossbowman2", 	   "death", ONESHOT_STILL );
	PlayObjectAnimation( "crossbowman3", 	   "death", ONESHOT_STILL );
	sleep(25);
	PlayObjectAnimation( "footman_catapulter1", "happy", ONESHOT );
	PlayObjectAnimation( "footman_catapulter2", "happy", ONESHOT );
	sleep(15);
	PlayObjectAnimation( 	 "peasant1", 	   "death", ONESHOT_STILL );
	PlayObjectAnimation(	   "priest", "rangeattack", ONESHOT_STILL );
	x,y = GetObjectPosition( "vindicator2" );
	PlayVisualEffect( PRIEST_HIT, "", "boom", x, y, 0, 180, GROUND );
	sleep(12);
	PlayObjectAnimation(  "vindicator1", "death", ONESHOT_STILL );
	PlayObjectAnimation(  "vindicator2", "death", ONESHOT_STILL );
	sleep(20);
	PlayObjectAnimation( 	   "priest", "happy", ONESHOT );
	PlayObjectAnimation( 	   "squire", "happy", ONESHOT );
	PlayObjectAnimation( 	 "peasant2", "happy", ONESHOT );
	PlayObjectAnimation( "footman_catapulter1", "happy", ONESHOT );
	PlayObjectAnimation( "footman_catapulter2", "happy", ONESHOT );
	SetObjectEnabled( 			   "priest", not nil );
	SetObjectEnabled( 			   "squire", not nil );
	SetObjectEnabled( 			 "peasant2", not nil );
	SetObjectEnabled( "footman_catapulter1", not nil );
	SetObjectEnabled( "footman_catapulter2", not nil );
	SetObjectEnabled( 				"brute", not nil );
	sleep(80);
	MoveCamera( hero_x, hero_y, hero_floor, 31, 0.6, -0.55, 0, 0, 1 );
	RemoveObject( "champion" );
	RemoveObject( "paladin" );
	RemoveObject( "archer1" );
	RemoveObject( "archer2" );
	RemoveObject( "archer3" );
	RemoveObject( "crossbowman1" );
	RemoveObject( "crossbowman2" );
	RemoveObject( "crossbowman3" );
	RemoveObject( "vindicator1" );
	RemoveObject( "vindicator2" );
	RemoveObject( "peasant1" );
	UnblockGame();
end

function ShowMeHit()
	BlockGame();
	OpenCircleFog( 129, 149, GROUND, 20, PLAYER_1 );
	MoveCamera( 119, 152, GROUND, 40, 0.68, 4.41, 0, 0, 1 );
	PlayObjectAnimation( "footman_shooter", "attack00", ONESHOT );
	sleep(15);
	PlayObjectAnimation( "damagun_catapult", "rangeattack", ONESHOT );
	UnblockGame();
end;

function DestroyCatapultIfCommanderIsDead()
	Trigger( OBJECT_TOUCH_TRIGGER, "footman_shooter", nil );
	while IsObjectExists( "footman_shooter" ) ~= nil do sleep(10); end;
	PlayVisualEffect( EFFECT_DUST, "damagun_catapult" );
	local x,y,floor = GetObjectPosition( "damagun_catapult" );
	sleep(10);
	RemoveObject( "damagun_catapult" );	
	sleep(1);
	SetObjectPosition( "damagun_catapult_razed", x, y, floor );
	PlayObjectAnimation("damagun_catapult_razed", "death", ONESHOT_STILL );
end

function PlayVoiceOverAboutUnderground(hero)
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", nil );
		Play2DSound( VOICEOVER_GOBLIN_ABOUT_DUNGEON );
	end
end

function PlayVoiceOverAboutLootZone(hero)
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_lootzone", nil );
		Play2DSound( VOICEOVER_LOOTZONE );
	end
end

function PlayVoiceOverCollectShield( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		PlayVoiceoverAndBlockGame( VOICEOVER_COLLECT_ARTIFACTS );
	end
end

function hasCapturedAllTowns()
	for i = 1, TOWNS.n do
		if GetObjectOwner(TOWNS[i]) ~= PLAYER_1 and GetObjectOwner(TOWNS[i]) ~= PLAYER_NONE then
			return nil
		end
	end
	return 1;
end

EFFECTS = {
	["FROST_NOVA"] = function( object )
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz" );
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz",  3,  3, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz",  3, -2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz", -2,  2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz", -1, -1, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz",  3, -2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz", -3,  3, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz",  1, -4, 0, 0, GROUND);
		Play2DSound( SOUND_EFFECT_ICE_BOLT );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_ICE_BOLT ) )
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz" );
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz",  3,  3, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz",  3, -2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz", -2,  2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz", -1, -1, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz",  3, -2, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz", -3,  3, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz",  1, -4, 0, 0, GROUND);
		PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, object, "hz",  1, -4, 0, 0, GROUND);
		Play2DSound( SOUND_EFFECT_ICE_EXPLOSIVE );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_ICE_EXPLOSIVE ) / 1.4 );
	end,

	["ARMAGEDDON"] = function( object )
		PlayVisualEffect( EFFECT_ARMAGEDDON, object, "hz" );
		Play2DSound( SOUND_EFFECT_ARMAGEDDON );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_ARMAGEDDON ) / 1.7 );
	end,
	
	["FIREBALL"] = function( object )
		local x, y, z = GetObjectPosition( object );
		PlayVisualEffect( FIREBALL, object, "hz" );
		Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, x, y, z );
	end,
	
	["ICEBOLT"] = function( object )
		PlayVisualEffect( EFFECT_ICEBOLT, object, "hz" );
		Play2DSound( SOUND_EFFECT_ICE_BOLT );
		sleep( GetSoundTimeInSleeps( SOUND_EFFECT_ICE_BOLT ) / 2.6 );
	end,
}

CINEMATICS = {
	are_playing = nil,
	playAndWait = function( id )
		CINEMATICS.are_playing = not nil;
		StartAdvMapDialog( id, CINEMATICS.end_play() );
		repeat sleep(30); until CINEMATICS.are_playing == nil;
	end,
		
	end_play = function()
		CINEMATICS.are_playing = nil;
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A2C2/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
		
	speakWithElementals = function(hero, id, unit_to_remove)
		if hero ~= "Gottai" then
			startThread( CINEMATICS.PlaceGotaiToScene, "Gottai", "PlaceForGotai_elementals", 90, unit_to_remove );
		end
		CINEMATICS.playAndWait(id);
		pcall(RemoveObject, unit_to_remove );
	end,
	
	PlaceGotaiToScene = function( hero, region, heroRotation, returnIfObjectNotExistName )
		local scene_x, scene_y = RegionToPoint( region );
		local init_x, init_y, init_z = GetObjectPosition( hero );
		SetRegionBlocked( region, nil );
		SetObjectPosition( hero, scene_x, scene_y, GROUND );
		SetObjectRotation( hero, heroRotation );
		repeat sleep(10); until IsObjectExists( returnIfObjectNotExistName ) == nil;
		SetObjectPosition( hero, init_x, init_y, init_z );
	end,
	
	castSpellOnUnit = function( object, message, effect, object_type )
		if IsObjectExists( object ) == nil then
			return
		end
		BlockGame();
		local object_x, object_y, object_floor = GetObjectPosition( object );
		MoveCamera( object_x, object_y, object_floor, 45, 0.9, 0, 0, 0, 1 );
		OpenCircleFog( object_x, object_y, object_floor, 7, PLAYER_1 );
		H55c_Message.show( message );
		sleep( 10 );
		EFFECTS[effect]( object );
		if object_type == "unit" then
			PlayObjectAnimation( object, "death", ONESHOT_STILL );
			sleep( 60 );
			RemoveObject( object );
		else
			RazeTown( object );
		end
		UnblockGame();
	end,
	
	attackedByDemons = function( hero )
		local monster_x, monster_y = RegionToPoint("scene_demon2");
		CreateMonster( "deamon2", CREATURE_HORNED_DEMON, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc1");
		CreateMonster( "orc1", CREATURE_ORC_WARRIOR, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc2");
		CreateMonster( "orc2", CREATURE_ORC_SLAYER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc3");
		CreateMonster( "orc3", CREATURE_ORC_WARMONGER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_khengi");
		CreateMonster( "khengi", CREATURE_GOBLIN_DEFILER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		sleep(1);
		SetObjectRotation( "deamon2", 135 );
		SetObjectRotation( "orc2", 270 );
		SetObjectRotation( "khengi", 285 );
		SetObjectEnabled( "orc1", nil );
		SetObjectEnabled( "orc2", nil );
		SetObjectEnabled( "orc3", nil );
		SetObjectEnabled( "deamon2", nil );
		SetObjectEnabled( "khengi", nil );
		CINEMATICS.playAndWait( 2 );
		SetObjectEnabled( "demon", not nil );
		SetRegionBlocked( "demon_block1", nil, PLAYER_1 );
		SetRegionBlocked( "demon_block2", nil, PLAYER_1 );
		SetRegionBlocked( "scene_orc1", nil );
		SetRegionBlocked( "scene_orc2", nil );
		SetRegionBlocked( "scene_orc3", nil );
		SetRegionBlocked( "scene_khengi", nil );
		SetRegionBlocked( "scene_demon2", nil );
		SetRegionBlocked( "scene_block_2", nil );
		SetRegionBlocked( "scene_block_1", nil );
		RemoveObject("orc1");
		RemoveObject("orc2");
		RemoveObject("orc3");
		RemoveObject("deamon2");
		RemoveObject("khengi");
		sleep(1);
		local demon_x, demon_y = GetObjectPosition("demon");
		MoveHeroRealTimeAndReachPoint( hero, demon_x, demon_y, GROUND );
	end,
}

OBJECTIVES = {
	state = {
	   captureTowns	  = {			"prim1_CaptureAllTowns", 1 },	-- Destroy all Human towns
	   isAlive 		  = {			"Prim3_HeroMustSurvive", 1 },	-- Gotai must survive
	   burnVillages   = { "sec_Objective01_BurnAllVillages", 0 }, 	-- Burn all villages
	   catapultHarass = { 								"_", 1 },	-- Enemy Catapult battery starts pounding at player's dwelling 
	   eventManager   = {								"_", 1 }, 	-- 
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		AllowRedHaven( PLAYER_1, 0 );
		AllowRedHaven( PLAYER_2, 0 );
		SetDisabledObjectMode( "demon", DISABLED_ATTACK );
		SetRegionBlocked("dungeon", not nil, PLAYER_2);
		SetRegionBlocked("dungeon", not nil, PLAYER_3);
		SetRegionBlocked("CatapultGuard_1", not nil, PLAYER_2);
		SetRegionBlocked("CatapultGuard_2", not nil, PLAYER_2);
		SetRegionBlocked("CatapultGuard_1", not nil, PLAYER_3);
		SetRegionBlocked("CatapultGuard_2", not nil, PLAYER_3);
		SetRegionBlocked( "demon_block1", not nil );
		SetRegionBlocked( "demon_block2", not nil );
		SetRegionBlocked( "PlaceForGotai_elementals", not nil, PLAYER_1 );
		SetRegionBlocked( "scene_orc1", not nil );
		SetRegionBlocked( "scene_orc2", not nil );
		SetRegionBlocked( "scene_orc3", not nil );
		SetRegionBlocked( "scene_khengi", not nil );
		SetRegionBlocked( "scene_demon2", not nil );
		SetRegionBlocked( "scene_block_2", not nil );
		SetRegionBlocked( "scene_block_1", not nil );
		SetRegionBlocked( "blue_haven_center_town_area", not nil, PLAYER_2 ); 	-- block player 2 hero from exiting main stronghold
		SetRegionBlocked( 				 "west_player3", not nil, PLAYER_3 );	-- block player 3 hero from exiting main stronghold
		DisableAutoEnterTown( "blue_haven_west_town", not nil );
		DisableAutoEnterTown( "blue_haven_center_town", not nil );
		DisableAutoEnterTown( "blue_haven_east_town", not nil );
		DisableAutoEnterTown( "red_haven_west_town", not nil );
		DisableAutoEnterTown( "red_haven_center_town", not nil );
		DisableAutoEnterTown( "red_haven_east_town", not nil );
		EnableHeroAI( "RedHeavenHero02", nil );
		EnableHeroAI( "RedHeavenHero03", nil );
		EnableHeroAI( "Maeve", nil );
		MakeTownMovable( "red_haven_center_town" );
		if (GetGameVar("A2C2M1_orcs_saved") ~= "") and (GetGameVar("A2C2M1_orcs_saved") ~= "0") then
			AddHeroCreatures( "Gottai", CREATURE_ORC_WARRIOR, GetGameVar("A2C2M1_orcs_saved"));	
			print(GetGameVar("A2C2M1_orcs_saved")," orcs has been added to hero.");
		end
		-- Отключение стандартной функциональности у домиков крестьян
		for i=1, PEASANT_HUTS_COUNT do
			SetObjectEnabled( "peasant_hut"..i, nil );
		end;
		-- Отключение стандартной функциональности у стека демонов "demon"
		SetObjectEnabled( "demon", nil );
		-- Отключение стандартной функциональности у входа в водоворот и выхода из него
		SetObjectEnabled( "whirlpool_ground", nil );
		SetObjectEnabled( "whirlpool_underground", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_ground", "WHIRLPOOL.GROUND.TOUCH");
		Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_underground", "MessageBox('Maps/Scenario/A2C2M3/MsgBox_whirlpool_reject.txt')");
		SetObjectEnabled( "fire_elemental", nil );
		SetObjectEnabled( "water_elemental", nil );
		SetDisabledObjectMode( "fire_elemental", DISABLED_ATTACK );
		SetDisabledObjectMode( "water_elemental", DISABLED_ATTACK );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ElementalsArea", "ELEMENTALS.FOUND" );
		Trigger( OBJECT_TOUCH_TRIGGER, "mermaid", "ELEMENTALS.INFORMATION_FROM_MERMAID" ); -- The mermaid next to the river bank says elementals are fighting to the south
		Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", "ELEMENTALS.COMBAT.START" );
		Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", "ELEMENTALS.COMBAT.START" );
		-- Отключение АИ у героя Рольф
		--Запретить PLAYER_2 (Rebel Heaven)	нанимать героев фракций dungeon, necromancy, inferno, stronghold
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_DUNGEON, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_NECROMANCY, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_INFERNO, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_STRONGHOLD, 0);	

		--Запретить PLAYER_3 (Red Heaven)	нанимать героев фракций dungeon, necromancy, inferno, stronghold
		AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_DUNGEON, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_NECROMANCY, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_INFERNO, 0);
		AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_STRONGHOLD, 0);		
		MakeHeroReturnToTavernAfterDeath( "RedHeavenHero01", not nil, 0);
		MakeHeroReturnToTavernAfterDeath( "RedHeavenHero04", not nil, 0);
		MakeHeroReturnToTavernAfterDeath( "RedHeavenHero05", not nil, 0);
		MakeHeroReturnToTavernAfterDeath( "RedHeavenHero06", not nil, 0);
		SetObjectPosition( "champion", 67 ,73 );
		SetObjectPosition( "paladin", 65 ,73 );
		sleep(10);
		for i=1, table.length( CIVIL_WAR_UNITS ) do
			SetObjectEnabled( CIVIL_WAR_UNITS[i], nil );
		end
		--Play2DSound( VOICEOVER_MISSION_START );
		DIFFICULTY[GetDifficulty()]();
		DenyAIHeroFlee( "Gottai", not nil );
		startThread( GiveTransferrableArtifacts );
		startThread( PlayVoiceoverAndBlockGame, VOICEOVER_OBJECTIVE_DESTOY_TOWNS_ACTIVE );
		Trigger( OBJECT_TOUCH_TRIGGER, "demon", "StartDemonScene" );
		for i=1, PEASANT_HUTS_COUNT do
			Trigger( OBJECT_TOUCH_TRIGGER, "peasant_hut"..i, "BurnPeasantHut" );
		end;
		for i=1, TOWNS.n do
			Trigger( OBJECT_CAPTURE_TRIGGER, TOWNS[i], "BurnTownWhenConquered" );
		end
		-- Configure Catapult triggers
		Trigger( OBJECT_TOUCH_TRIGGER, "footman_shooter", "DestroyCatapultIfCommanderIsDead" );
		for key, value in CATAPULT.TARGETS do
			Trigger( OBJECT_TOUCH_TRIGGER, key, "CATAPULT.OPERATE" );
		end
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_windmill", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_center_blue_town", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_blue1", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_blue2", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_red", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_red_town_east", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_megamonster", "CATAPULT.OPERATE" );
		-- Trigger( OBJECT_TOUCH_TRIGGER, "sw_red_town_west", "CATAPULT.OPERATE" );
		
		Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", "PlayVoiceOverAboutUnderground" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon", "PlayVoiceOverAboutUnderground" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_lootzone", "PlayVoiceOverAboutLootZone");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon_2", "WHIRLPOOL.UNDERGROUND.FIRST_VISIT" );
		SetRegionBlocked( "shipyard", not nil, PLAYER_2 );
		SetRegionBlocked( "shipyard", not nil, PLAYER_3 );
		Trigger( OBJECT_TOUCH_TRIGGER,	"ogreShield", "PlayVoiceOverCollectShield" );
		startThread( StartCivilWarScene );
		startThread( ELEMENTALS.FIGHTING );
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
			
			if GetObjectiveState("Prim3_HeroMustSurvive") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim1_CaptureAllTowns") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				SaveHeroAllSetArtifactsEquipped( "Gottai", "A2C2M3" );
				sleep(100);
				Win(PLAYER_1);
			end
		end
	end,
	
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 then
			SetObjectiveState( "prim1_CaptureAllTowns", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureTowns[2] = 2;
		elseif OBJECTIVES.state.captureTowns[2] == 2 and hasCapturedAllTowns() ~= nil then
			SetObjectiveState( "prim1_CaptureAllTowns", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive( "Gottai" ) == nil then
			SetObjectiveState( "Prim3_HeroMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	burnVillages = function()
		if OBJECTIVES.state.burnVillages[2] == 1 then
			MessageBox("Maps/Scenario/A2C2M3/MsgBox_CanBurnHuts.txt");  
			SetObjectiveState( "sec_Objective01_BurnAllVillages", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.burnVillages[2] = 2;
		elseif OBJECTIVES.state.burnVillages[2] == 2 and razedBuildings >= PEASANT_HUTS_COUNT then
			SetObjectiveState("sec_Objective01_BurnAllVillages", OBJECTIVE_COMPLETED );
			local PlayerHeroes = GetPlayerHeroes( PLAYER_1 );	
			for i=0, table.length(PlayerHeroes)-1 do
				ChangeHeroStat( PlayerHeroes[i], STAT_ATTACK, 2 );
				if GetHeroTown( PlayerHeroes[i] ) == nil then
					pcall(ShowFlyingSign, PATH.."MsgBox_FlyngSignPlusAttack.txt", PlayerHeroes[i], PLAYER_1, 5 );
				end
			end
			OBJECTIVES.state.burnVillages[2] = 10;
		end
	end,

	catapultHarass_day = 15,
	catapultHarass = function()
		if OBJECTIVES.state.catapultHarass[2] == 1 and OBJECTIVES.date >= OBJECTIVES.catapultHarass_day then
			Play2DSound( VOICEOVER_CATAPULT_HARRASMENT );
			ShowMeHit();
			PlayVisualEffect( FIREBALL, '', 'boom', 120, 152, 0, 0, GROUND );
			Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, 120, 152, 0);
			sleep(20);
			MessageBox(PATH.."MsgBox_CatapultHarassment.txt");
			OBJECTIVES.state.catapultHarass[2] = 2;
			OBJECTIVES.catapultHarass_day = OBJECTIVES.catapultHarass_day + 7;
		elseif OBJECTIVES.state.catapultHarass[2] >= 2 and OBJECTIVES.date >= OBJECTIVES.catapultHarass_day then
			ShowMeHit();
			PlayVisualEffect( FIREBALL, 'orc_military_post' );
			local x, y, z = GetObjectPosition('orc_military_post');
			Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, x, y, 0);
			if OBJECTIVES.state.catapultHarass[2] == 2 then
				ReplaceDwelling('orc_military_post', TOWN_STRONGHOLD, CREATURE_CYCLOP, CREATURE_WYVERN, CREATURE_ORCCHIEF_BUTCHER );
			elseif OBJECTIVES.state.catapultHarass[2] == 3 then
				ReplaceDwelling('orc_military_post', TOWN_STRONGHOLD, CREATURE_WYVERN, CREATURE_ORCCHIEF_BUTCHER );
			elseif OBJECTIVES.state.catapultHarass[2] == 4 then
				ReplaceDwelling('orc_military_post', TOWN_STRONGHOLD, CREATURE_ORCCHIEF_BUTCHER );
			elseif OBJECTIVES.state.catapultHarass[2] == 5 then
				RazeBuilding( 'orc_military_post' );
				OBJECTIVES.state.catapultHarass[2] = 11;
			end
			OBJECTIVES.state.catapultHarass[2] = OBJECTIVES.state.catapultHarass[2] + 1;
			OBJECTIVES.catapultHarass_day = OBJECTIVES.catapultHarass_day + 7;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.date >= DAY_OPEN_DUNGEON_FOR_AI then
				SetRegionBlocked( "dungeon", nil, PLAYER_2 );
				SetRegionBlocked( "dungeon", nil, PLAYER_2 );
				print("OpenDungeonForAI: Dungeon is opened fo AI" );
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

function a2c2m3_dbg(var)
	H55_Speedrun(1);
	SetPlayerStartResources( PLAYER_1, 999, 999, 999, 999,995, 995, 3000000);
	if var == 1 then
		SetObjectPosition("Gottai", 150, 67, 0 ); -- befriend elementals
	elseif var == 11 then
		SetObjectPosition("Gottai", 115, 40, 0 ); -- center town attacked by elementals
	elseif var == 12 then
		SetObjectPosition("Gottai", 161, 10, 0 ); -- death knight attacked by elementals
	elseif var == 13 then
		SetObjectPosition("Gottai", 154, 100, 0 ); -- titan attacked by elementals
	elseif var == 2 then
		OpenCircleFog(138, 138, 0, 30, 1);
		MakeHeroInteractWithObject("Gottai", "footman_shooter");
	elseif var == 22 then
		MakeHeroInteractWithObject("Gottai", "mermaid");
	elseif var == 3 then
		SetObjectPosition("Gottai", 32, 102, 0 );
	elseif var == 33 then
		SetObjectPosition("Gottai", 64, 19, 0 );
	elseif var == 333 then
		SetObjectPosition("Gottai", 154, 100, 0 );
	elseif var == 4 then
		SetObjectPosition("Gottai", 82, 82, 0 );
	end
end
