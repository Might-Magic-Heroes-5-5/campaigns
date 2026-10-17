doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

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

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M2");
    LoadHeroAllSetArtifacts( "Heam", "C5M1" );
	sleep(25); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Heam" );
end

startThread(H55_InitSetArtifacts);

obelisks={'o1','o2','o3','o4','o5','o6','o7'} --массив имен обелисков раскрывающих местоположение драконов
xregions={88,114,76,86,46,16,28}
yregions={87,70,105,57,82,69,111}
blocked_regions={'rb1','rb2','rb3','rb4','rb5','rb6','rb7'}
dragons={'d1','d2','d3','d4','d5','d6','d7'}
inferno_towns={'1','2','3'}
message21='/Maps/Scenario/C5M2/objectives/messages/message21.txt'
n = 7;

DeployReserveHero( "Zydar", 52, 94, GROUND );
DeployReserveHero( "Ash", 22, 24, GROUND );
DeployReserveHero( "Oddrema", 14, 20, GROUND );
DeployReserveHero( "Deleb", 20, 20, GROUND );
local demons = GetDifficulty() + 1
ChangeHeroStat("Deleb", STAT_ATTACK, 6);
ChangeHeroStat("Deleb", STAT_DEFENCE, 2);
ChangeHeroStat("Deleb", STAT_SPELL_POWER, 6);
ChangeHeroStat("Deleb", STAT_KNOWLEDGE, 3);
GiveHeroSkill("Deleb", SKILL_WAR_MACHINES);
GiveHeroSkill("Deleb", SKILL_WAR_MACHINES);
if demons > 1 then
	-- extra stats
	ChangeHeroStat("Deleb", STAT_ATTACK, 2 * GetDifficulty());
	ChangeHeroStat("Deleb", STAT_DEFENCE, 2 * GetDifficulty());
	ChangeHeroStat("Deleb", STAT_SPELL_POWER, 2 * GetDifficulty());
	ChangeHeroStat("Deleb", STAT_KNOWLEDGE, 2 * GetDifficulty());
	-- extra skills/perks
	GiveExp("Deleb", 19900); -- level 12 to 16
	GiveHeroSkill("Deleb", SKILL_DESTRUCTIVE_MAGIC);
	GiveHeroSkill("Deleb", PERK_MASTER_OF_LIGHTNINGS);
	GiveHeroSkill("Deleb", PERK_MASTER_OF_ICE);
	GiveHeroSkill("Deleb", HERO_SKILL_SET_AFIRE);
	--spells
	TeachHeroSpell("Deleb", SPELL_CHAIN_LIGHTNING);
	TeachHeroSpell("Deleb", SPELL_FROST_RING);
	-- units
	AddHeroCreatures("Deleb", CREATURE_IMP, 30);
	AddHeroCreatures("Deleb", CREATURE_SUCCUBUS, 10);
	AddHeroCreatures("Deleb", CREATURE_HELL_HOUND, 8);

	GiveExp("Efion", 3200); -- level 1 to 4
	-- extra skills/perks
	GiveHeroSkill("Efion", PERK_MASTER_OF_SICKNESS);
	GiveHeroSkill("Efion", PERK_MASTER_OF_CURSES);
	GiveHeroSkill("Efion", SKILL_DARK_MAGIC);
	--spells
	TeachHeroSpell("Efion", SPELL_SLOW);
	TeachHeroSpell("Efion", SPELL_CURSE);
	TeachHeroSpell("Efion", SPELL_DISRUPTING_RAY);

	GiveExp("Zydar", 3200);
	GiveExp("Ash", 5900);
	GiveExp("Oddrema", 5900);
end
if demons > 2 then
	GiveExp("Deleb", 41200); -- level 16 to 20
	-- extra skills/perks
	GiveHeroSkill("Deleb", SKILL_LEARNING);
	GiveHeroSkill("Deleb", PERK_INTELLIGENCE);
	GiveHeroSkill("Deleb", SKILL_LUCK);
	GiveHeroSkill("Deleb", PERK_LUCKY_STRIKE);
	--spells
	TeachHeroSpell("Deleb", SPELL_DEEP_FREEZE);
	TeachHeroSpell("Deleb", SPELL_METEOR_SHOWER);

	GiveExp("Efion", 6800); -- level 4 to 8
	-- extra skills/perks
	GiveHeroSkill("Efion", SKILL_LEARNING);
	GiveHeroSkill("Efion", RANGER_FEAT_INSIGHTS);
	GiveHeroSkill("Efion", HERO_SKILL_SHATTER_LIGHT_MAGIC);
	GiveHeroSkill("Efion", HERO_SKILL_CORRUPT_LIGHT);
	--spells
	TeachHeroSpell("Efion", SPELL_FORGETFULNESS);
	TeachHeroSpell("Efion", SPELL_PLAGUE);
	TeachHeroSpell("Efion", SPELL_WEAKNESS);

	GiveExp("Zydar", 6800);
	GiveExp("Ash", 8100);
	GiveExp("Oddrema", 8100);
end
if demons > 3 then
	GiveExp("Deleb", 85300); -- level 20 to 24
	-- extra skills/perks
	GiveHeroSkill("Deleb", SKILL_DEFENCE);
	GiveHeroSkill("Deleb", PERK_EVASION);
	GiveHeroSkill("Deleb", SKILL_LOGISTICS);
	GiveHeroSkill("Deleb", HERO_SKILL_SNATCH);
	--spells
	TeachHeroSpell("Deleb", SPELL_IMPLOSION);
	TeachHeroSpell("Deleb", SPELL_ARMAGEDDON);


	GiveExp("Efion", 10600); -- level 8 to 12
	-- extra skills/perks
	GiveHeroSkill("Efion", DEMON_FEAT_FIRE_PROTECTION);
	GiveHeroSkill("Efion", RANGER_FEAT_STORM_WIND);
	GiveHeroSkill("Efion", WARLOCK_FEAT_PAYBACK);
	GiveHeroSkill("Efion", PERK_EAGLE_EYE);
	--spells
	TeachHeroSpell("Efion", SPELL_ANIMATE_DEAD);
	TeachHeroSpell("Efion", SPELL_SORROW);
	TeachHeroSpell("Efion", SPELL_TELEPORT);
	-- units
	AddHeroCreatures("Efion", CREATURE_IMP, 30);
	AddHeroCreatures("Efion", CREATURE_SUCCUBUS, 10);
	AddHeroCreatures("Efion", CREATURE_HELL_HOUND, 8);

	GiveExp("Zydar", 10600);
	GiveExp("Ash", 11800);
	GiveExp("Oddrema", 11800);
end

DIFFICULTY = {
	[0] = function()
		releaseEnemyHero = 29;
		C5M2_daysToRevive = 9;
		AddHeroCreatures("Heam", CREATURE_GRAND_ELF, 20);
		print("normal");
	end,

	[1] = function()
		releaseEnemyHero = 22;
		C5M2_daysToRevive = 7;
        AddHeroCreatures("Heam", CREATURE_GRAND_ELF, 10);
		print("hard");
	end,

	[2] = function()
		releaseEnemyHero = 15;
		C5M2_daysToRevive = 5;
		print("heroic");
	end,

	[3] = function()
		releaseEnemyHero = 8;
		C5M2_daysToRevive = 3;
		print("impossible");
	end,
}

function new_obelisks_mechanic(hero_name)
	local d_name --
	local x,y,z --координаты точки в которой сгенеряться мобы
	local j=1
	if OBJECTIVES.state.captureTowns[2] < 2 then --знает ли игрок как работают обелиски
		MessageBox('/Maps/Scenario/C5M2/objectives/messages/message11.txt') --бла бла бла ничего не происходит потому что вы не знаете что это зе фигня
		return --игроку ещё не рассказали о том как работаю драконьи обелиски
	end

	local obelisk = obelisk_touch(hero_name);
	if obelisk == nil then
		MessageBox('/Maps/Scenario/C5M2/objectives/messages/message13.txt') --бла бла бла ничего не происходит потому что вы здесь были
		return
	end

	MessageBox('/Maps/Scenario/C5M2/objectives/messages/message12.txt') --бла бла бла вам открылось местоположение одной группы драконов
	MarkObjectAsVisited(obelisk, hero_name);
	d_name=random(n)+1;n=n-1;print('d_name=',d_name); x=xregions[d_name]; y=yregions[d_name]; z=0; --в каком регионе генерим драконов
	CreateMob(dragons[j], 56, 3, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим 3 драконов в указанном регионе
	MoveCamera(x, y, z, 50, 1.57);
	xregions=remove_element(x,xregions);
	yregions=remove_element(y,yregions);
	obelisks=remove_element(obelisk,obelisks)
	OpenCircleFog(x,y,z,7,1)
	dragons=remove_element(dragons[j],dragons)
end

function obelisk_touch(toucher)
	local xh,yh,zh = GetObjectPos(toucher); -- координаты героя активировавшего обелиск
	for i,h in obelisks do
		local x,y,z=GetObjectPos(obelisks[i]);
		if zh==z and xh>=x-1 and xh<=x+1 and yh>=y-1 and yh<=y+1 then --определяем обелиск рядом с которым стоит герой
			print('active obelisk=',obelisks[i]) --для проверки
			return obelisks[i]
		end
	end
end

function PlayerOwnsTown(player)
	local towns = 0;
	for i,h in inferno_towns do
		if GetObjectOwner(h) == player then
			towns = towns + 1;
		end
	end
	return towns;
end

CINEMATICS = {
	intro = function()
		StartDialogScene('/DialogScenes/C5/M2/D1/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,

	dragonsCollected = function()
		StartDialogScene('/DialogScenes/C5/M2/R2/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,

	captureTowns = function()
		StartDialogScene('/DialogScenes/C5/M2/R1/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,

	townsCaptured = function()
		StartDialogScene('/DialogScenes/C5/M2/R3/DialogScene.xdb#xpointer(/DialogScene)');
		sleep( 2 );
	end,
}

OBJECTIVES = {
	state = {
		collectDragons		= { "prim1", 1 }, -- Collect 20 emerald dragons
		captureTowns		= { "prim2", 1 }, -- capture all demon towns
		isAlive				= { "prim3", 1 }, -- do not let Findan/Heam die
		eventManager   		= {	   "_", 1 }, -- Manages when zone for AI will be unblocked
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		SetRegionBlocked("block", 1, 2);
		for i,h in blocked_regions do
			SetRegionBlocked(blocked_regions[i], 1, 2);
		end
		CINEMATICS.intro();
		DIFFICULTY[GetDifficulty()]();
		--включает новую-читовую функциональность обелисков и отключаем базовую
		for i,h in obelisks do
			SetObjectEnabled(obelisks[i], nil);
			Trigger(OBJECT_TOUCH_TRIGGER,obelisks[i], 'new_obelisks_mechanic')
		end
		SetTownBuildingLimitLevel('player_town', 13, 0);
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

			if GetObjectiveState("prim3") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if OBJECTIVES.state.collectDragons[2] == 10 and OBJECTIVES.state.captureTowns[2] == 10 then
				SaveHeroAllSetArtifactsEquipped("Heam", "C5M2");
				sleep(50);
				Win();
				return
			end
		end
	end,

	collectDragons = function()
		-- completion of this task is handled by C5M2.xdb
		if OBJECTIVES.state.collectDragons[2] == 1 then
			SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.collectDragons[2] = 2;
		elseif OBJECTIVES.state.collectDragons[2] == 2 and GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
			CINEMATICS.dragonsCollected();
			sleep(10);
			LevelUpHero("Heam");
			OBJECTIVES.state.collectDragons[2] = 10;
		end
	end,

	captureTowns = function()
		-- completion of this task is handled by C5M2.xdb
		if OBJECTIVES.state.captureTowns[2] == 1 and PlayerOwnsTown(PLAYER_1) > 0 then
			CINEMATICS.captureTowns();
			AddHeroCreatures("Heam", 56 , 1);
			SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureTowns[2] = 2;
		elseif OBJECTIVES.state.captureTowns[2] == 2 and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
			CINEMATICS.townsCaptured();
			SetTownBuildingLimitLevel('player_town', 13, 2);
			AddHeroCreatures("Heam", 56 ,5);
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Heam") == nil then
			SetObjectiveState("prim3", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	eventManager_released = 0,
	eventManager_reviveBegun = 0,
	eventManager_reviveDay = 0,
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.state.eventManager[2] == 1 and OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.eventManager_released == 0 and OBJECTIVES.date > releaseEnemyHero then
				SetRegionBlocked("block", nil, 2);
				print ("AI released");
				OBJECTIVES.eventManager_released = 1;
			end
			
			if IsHeroAlive("Deleb") == nil and GetObjectOwner("3") == PLAYER_2 then
				if OBJECTIVES.eventManager_reviveDay > 0 then
					OBJECTIVES.eventManager_reviveDay = OBJECTIVES.eventManager_reviveDay - 1;
					print(OBJECTIVES.eventManager_reviveDay," days before enemy spawns");
				elseif OBJECTIVES.eventManager_reviveBegun == 0 then
					OBJECTIVES.eventManager_reviveDay = C5M2_daysToRevive;
					OBJECTIVES.eventManager_reviveBegun = 1;
					print("Enemy hero has died, respawn counter set to ",C5M2_daysToRevive);
				else
					print("Spawning enemy hero..");
					DeployReserveHero("Deleb", 16, 20, GROUND);
					OBJECTIVES.eventManager_reviveBegun = 0;
					sleep(10);
				end
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
