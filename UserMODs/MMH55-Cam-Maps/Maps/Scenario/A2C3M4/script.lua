doFile("/scripts/A2_Zehir/A2_Zehir.lua");
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts( "A2C3M4", "Zehir" );
	LoadHeroAllSetArtifacts( "Zehir",  "A2C3M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Zehir" );
end

startThread(H55_InitSetArtifacts);
Inferno_count = 0;

A2C3M4_TOWN_ATTACKS = {
	["inf2"] = { heroes = {         "Wulfstan" }, vo = "CINEMATICS.VO_Wulfstan" },
	["inf4"] = { heroes = { "Freyda", "Duncan" }, vo =   "CINEMATICS.VO_Duncan" },
	["inf3"] = { heroes = { "Gottai",  "Kujin" }, vo =   "CINEMATICS.VO_Gottai" },
	["inf1"] = { heroes = {          "Shadwyn" }, vo =  "CINEMATICS.VO_Shadwyn" },
}

function x_enter()
	if GetObjectiveState("prim2") ~= OBJECTIVE_COMPLETED then
		MessageBox("/Maps/Scenario/a2c3m4/enter_message.txt");
		sleep( 2 );
	end
end

function Start_Wulfstan()
	BlockGame();
	OpenCircleFog( 138, 154, 1, 10, PLAYER_1 );
	MoveCamera(138, 154, 1, 50, 1);
	DeployReserveHero( "Wulfstan", 131, 155, 1 );
	sleep( 10 )
	LoadHeroAllSetArtifacts( "Wulfstan", "A2C3M3" );
	PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO15_Wulfstan_01sound.xdb#xpointer(/Sound)" );
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
	ChangeHeroStat( "Wulfstan", STAT_MANA_POINTS,   500 );
	ChangeHeroStat( "Wulfstan", STAT_MOVE_POINTS, 30000 );
	H55_Insert(OBJECTIVES.isAlive_list, "Wulfstan" ); 
	MoveHeroRealTime( "Wulfstan", 143, 152, 1 );
	sleep( 20 );
	UnblockGame();
end

function Start_Freyda()
	BlockGame();
	OpenCircleFog( 32, 25, 1, 10, PLAYER_1 );
	MoveCamera(32, 25, 1, 50, 1);
	DeployReserveHero( "Freyda", 33, 18, 1 );
	DeployReserveHero( "Duncan", 33, 16, 1 );	
	sleep( 10 );
	LoadHeroAllSetArtifacts( "Freyda", "A2C3M2" );
	LoadHeroAllSetArtifacts( "Duncan", "A2C3M2" );
	PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO18_Freyda_01sound.xdb#xpointer(/Sound)" );
	H55_CamFixTooManySkills( PLAYER_1, "Freyda" );
	H55_CamFixTooManySkills( PLAYER_1, "Duncan" );	
	ChangeHeroStat( "Freyda", STAT_MANA_POINTS, 500 ); 
	ChangeHeroStat( "Freyda", STAT_MOVE_POINTS, 30000 );	
	H55_Insert(OBJECTIVES.isAlive_list, "Freyda" ); 
	H55_Insert(OBJECTIVES.isAlive_list, "Duncan" ); 
	MoveHeroRealTime( "Freyda", 34, 31, 1 );
	sleep( 20 );
	MoveHeroRealTime( "Duncan", 33, 28, 1 );
	sleep( 20 );
	UnblockGame();
end

function Start_Kujin()
	BlockGame();
	OpenCircleFog( 150, 56, 1, 10, PLAYER_1 );
	MoveCamera(150, 56, 1, 50, 1);
	DeployReserveHero( "Gottai", 155, 61, 1 );
	DeployReserveHero( "Kujin", 153, 61, 1 );
	sleep( 10 );
	LoadHeroAllSetArtifacts( "Kujin",  "A2C2M4"  );
	LoadHeroAllSetArtifacts( "Gottai",  "A2C2M5"  );
	PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO16_Kujin_01sound.xdb#xpointer(/Sound)" );
	H55_CamFixTooManySkills(PLAYER_1,"Gottai");
	H55_CamFixTooManySkills(PLAYER_1,"Kujin");
	ChangeHeroStat( "Gottai", STAT_MANA_POINTS, 500 );
	ChangeHeroStat( "Gottai", STAT_MOVE_POINTS, 30000 );
	ChangeHeroStat( "Kujin", STAT_MOVE_POINTS, 30000 );
	H55_Insert(OBJECTIVES.isAlive_list, "Gottai" );
	H55_Insert(OBJECTIVES.isAlive_list, "Kujin" );
	MoveHeroRealTime( "Gottai", 146, 51, 1 );
	sleep( 10 );
	MoveHeroRealTime( "Kujin", 148, 49, 1 );
	UnblockGame();
end

function _reachPortal(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons", nil );
		OBJECTIVES.state.reachPortal[2] = 3;
		OBJECTIVES.state.destroyBarrier[2] = 1;
	end
end

function _destroyDemons(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec2_start", nil);
		OBJECTIVES.state.destroyDemon[2] = 1;
	end
end

function _freeMatriarchs(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec3_start",nil );	
		OBJECTIVES.state.freeMatriarchs[2] = 1;
	end
end

function _learnTravelSpell(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec4_start", nil );
		OBJECTIVES.state.learnSpell[2] = 1;
	end	
end

function Summon_town()
	ZehirAbilitiesInit("Zehir");
	ZehirTownInit("z_town");
	AddTownPoint(9, 90, GROUND, 90, "zehir", 35000, "zehir1");
end

function SetUpTownFights(koef)
	if GetDifficulty() == DIFFICULTY_EASY then
        AddHeroCreatures("Zehir", CREATURE_STORM_LORD, 8);
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 466 );
		AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 83 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 103 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 70 );		
		AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 29 );		
		AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 20 );
		AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 47 );
		ChangeHeroStat("Oddrema", STAT_ATTACK, 4);
		ChangeHeroStat("Oddrema", STAT_DEFENCE, 4);
		ChangeHeroStat("Oddrema", STAT_SPELL_POWER, 4);
		ChangeHeroStat("Oddrema", STAT_KNOWLEDGE, 4);
		AddHeroCreatures( "Efion", CREATURE_FRIGHTFUL_NIGHTMARE, 40 );
		AddHeroCreatures( "Efion", CREATURE_HORNED_LEAPER, 65 );		
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 15 );
		AddHeroCreatures( "Efion", CREATURE_PIT_SPAWN, 25 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 55 );
		ChangeHeroStat("Efion", STAT_ATTACK, 4);
		ChangeHeroStat("Efion", STAT_DEFENCE, 4);
		ChangeHeroStat("Efion", STAT_SPELL_POWER, 4);
		ChangeHeroStat("Efion", STAT_KNOWLEDGE, 4);	
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 17 );
		AddHeroCreatures( "Calid", CREATURE_INFERNAL_SUCCUBUS, 116 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 333 );
		AddHeroCreatures( "Calid", CREATURE_FIREBREATHER_HOUND, 333 );
		AddHeroCreatures( "Calid", CREATURE_SUCCUBUS_SEDUCER, 116 );
		AddHeroCreatures( "Calid", CREATURE_HORNED_LEAPER, 500 );
		AddHeroCreatures( "Calid", CREATURE_NIGHTMARE, 83 );
		ChangeHeroStat("Calid", STAT_ATTACK, 8);
		ChangeHeroStat("Calid", STAT_DEFENCE, 8);
		ChangeHeroStat("Calid", STAT_SPELL_POWER, 4);
		ChangeHeroStat("Calid", STAT_KNOWLEDGE, 3);	
		AddHeroCreatures( "Jazaz", CREATURE_ARCH_DEMON, 37 );
		AddHeroCreatures( "Jazaz", CREATURE_FIREBREATHER_HOUND, 500 );
		AddHeroCreatures( "Jazaz", CREATURE_BALOR, 66);
		AddHeroCreatures( "Jazaz", CREATURE_HELLMARE, 83 );
		AddHeroCreatures( "Jazaz", CREATURE_HORNED_LEAPER, 500 );		
		ChangeHeroStat("Jazaz", STAT_ATTACK, 4);
		ChangeHeroStat("Jazaz", STAT_DEFENCE, 4);
		ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 22);
		ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 4);		
        AddHeroCreatures("Marder", CREATURE_ARCHDEVIL, 8);	
        AddHeroCreatures("Marder", CREATURE_INFERNAL_SUCCUBUS, 75);	
        AddHeroCreatures("Marder", CREATURE_CERBERI, 150);		
		AddHeroCreatures("Marder", CREATURE_HORNED_DEMON, 190);	
		AddHeroCreatures("Nymus", CREATURE_ARCH_DEMON, 10);
		AddHeroCreatures("Nymus", CREATURE_FIREBREATHER_HOUND, 150);
		AddHeroCreatures("Nymus", CREATURE_SUCCUBUS_SEDUCER, 55);
		AddHeroCreatures("Nymus", CREATURE_QUASIT, 350);	
        AddHeroCreatures("Deleb", CREATURE_CERBERI, 100);
        AddHeroCreatures("Deleb", CREATURE_FIRE_ELEMENTAL, 50);	
        AddHeroCreatures("Deleb", CREATURE_HELLMARE, 40);
        AddHeroCreatures("Deleb", CREATURE_BALOR, 20);
        AddHeroCreatures("Deleb", CREATURE_IMP, 150);		
		AddObjectCreatures("mine1", CREATURE_ARCH_DEMON, 14);
		AddObjectCreatures("mine2", CREATURE_SUCCUBUS_SEDUCER, 110);
		AddObjectCreatures("mine3", CREATURE_HELLMARE, 75);	
        AddObjectCreatures("DT1", CREATURE_HORNED_LEAPER, 200);
        AddObjectCreatures("DT1", CREATURE_SUCCUBUS_SEDUCER, 45);	
        AddObjectCreatures("DT2", CREATURE_FIREBREATHER_HOUND, 85);
        AddObjectCreatures("DT2", CREATURE_QUASIT, 250);
        AddObjectCreatures("SW2", CREATURE_QUASIT, 400);
        AddObjectCreatures("SW2", CREATURE_FRIGHTFUL_NIGHTMARE, 25);
        AddObjectCreatures("KG1", CREATURE_HELLMARE, 65);
        AddObjectCreatures("KG1", CREATURE_IMP, 260);	
        AddObjectCreatures("KG2", CREATURE_HELLMARE, 65);
        AddObjectCreatures("KG2", CREATURE_FIRE_ELEMENTAL, 65);			
	elseif GetDifficulty() == DIFFICULTY_HARD then
		AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 933 );
		AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 167 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 207 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 140 );		
		AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 57 );		
		AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 40 );
		AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 93 );
		ChangeHeroStat("Oddrema", STAT_ATTACK, 8);
		ChangeHeroStat("Oddrema", STAT_DEFENCE, 8);
		ChangeHeroStat("Oddrema", STAT_SPELL_POWER, 8);
		ChangeHeroStat("Oddrema", STAT_KNOWLEDGE, 8);		
		AddHeroCreatures( "Efion", CREATURE_FRIGHTFUL_NIGHTMARE, 60 );
		AddHeroCreatures( "Efion", CREATURE_HORNED_LEAPER, 130 );		
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 25 );
		AddHeroCreatures( "Efion", CREATURE_PIT_SPAWN, 45 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 110 );
		ChangeHeroStat("Efion", STAT_ATTACK, 8);
		ChangeHeroStat("Efion", STAT_DEFENCE, 8);
		ChangeHeroStat("Efion", STAT_SPELL_POWER, 8);
		ChangeHeroStat("Efion", STAT_KNOWLEDGE, 8);
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 33 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 666 );
		AddHeroCreatures( "Calid", CREATURE_FIREBREATHER_HOUND, 666 );
		AddHeroCreatures( "Calid", CREATURE_SUCCUBUS_SEDUCER, 232 );
		AddHeroCreatures( "Calid", CREATURE_INFERNAL_SUCCUBUS, 232 );		
		AddHeroCreatures( "Calid", CREATURE_HORNED_LEAPER, 1000 );
		AddHeroCreatures( "Calid", CREATURE_NIGHTMARE, 166 );
		ChangeHeroStat("Calid", STAT_ATTACK, 16);
		ChangeHeroStat("Calid", STAT_DEFENCE, 16);
		ChangeHeroStat("Calid", STAT_SPELL_POWER, 8);
		ChangeHeroStat("Calid", STAT_KNOWLEDGE, 6);
		AddHeroCreatures( "Jazaz", CREATURE_ARCH_DEMON, 73 );
		AddHeroCreatures( "Jazaz", CREATURE_FIREBREATHER_HOUND, 1000 );
		AddHeroCreatures( "Jazaz", CREATURE_BALOR, 133);
		AddHeroCreatures( "Jazaz", CREATURE_HELLMARE, 165 );
		AddHeroCreatures( "Jazaz", CREATURE_HORNED_LEAPER, 1000 );		
		ChangeHeroStat("Jazaz", STAT_ATTACK, 8);
		ChangeHeroStat("Jazaz", STAT_DEFENCE, 8);
		ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 44);
		ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 8);
        AddHeroCreatures("Marder", CREATURE_ARCHDEVIL, 16);	
        AddHeroCreatures("Marder", CREATURE_INFERNAL_SUCCUBUS, 150);	
        AddHeroCreatures("Marder", CREATURE_CERBERI, 300);		
		AddHeroCreatures("Marder", CREATURE_HORNED_DEMON, 380);
		AddHeroCreatures("Nymus", CREATURE_ARCH_DEMON, 20);
		AddHeroCreatures("Nymus", CREATURE_FIREBREATHER_HOUND, 300);
		AddHeroCreatures("Nymus", CREATURE_SUCCUBUS_SEDUCER, 110);
		AddHeroCreatures("Nymus", CREATURE_QUASIT, 700);
        AddHeroCreatures("Deleb", CREATURE_CERBERI, 200);
        AddHeroCreatures("Deleb", CREATURE_FIRE_ELEMENTAL, 100);	
        AddHeroCreatures("Deleb", CREATURE_HELLMARE, 80);
        AddHeroCreatures("Deleb", CREATURE_BALOR, 40);
        AddHeroCreatures("Deleb", CREATURE_IMP, 300);		
        AddObjectCreatures("mine1", CREATURE_ARCHDEVIL, 28);
        AddObjectCreatures("mine1", CREATURE_ARCH_DEMON, 28);
		AddObjectCreatures("mine2", CREATURE_SUCCUBUS_SEDUCER, 220);
		AddObjectCreatures("mine2", CREATURE_INFERNAL_SUCCUBUS, 220);
		AddObjectCreatures("mine3", CREATURE_HELLMARE, 150);	
		AddObjectCreatures("mine3", CREATURE_FRIGHTFUL_NIGHTMARE, 150);	
        AddObjectCreatures("DT1", CREATURE_HORNED_LEAPER, 400);
        AddObjectCreatures("DT1", CREATURE_SUCCUBUS_SEDUCER, 90);
        AddObjectCreatures("DT1", CREATURE_HORNED_DEMON, 400);
        AddObjectCreatures("DT1", CREATURE_INFERNAL_SUCCUBUS, 90);
        AddObjectCreatures("DT2", CREATURE_FIREBREATHER_HOUND, 170);
        AddObjectCreatures("DT2", CREATURE_QUASIT, 500);
        AddObjectCreatures("DT2", CREATURE_CERBERI, 170);
        AddObjectCreatures("DT2", CREATURE_IMP, 500);
        AddObjectCreatures("SW2", CREATURE_QUASIT, 600);
        AddObjectCreatures("SW2", CREATURE_FRIGHTFUL_NIGHTMARE, 50);
        AddObjectCreatures("SW2", CREATURE_IMP, 600);
        AddObjectCreatures("SW2", CREATURE_HELLMARE, 50);	
        AddObjectCreatures("KG1", CREATURE_FRIGHTFUL_NIGHTMARE, 130);
        AddObjectCreatures("KG1", CREATURE_HELLMARE, 130);
		AddObjectCreatures("KG1", CREATURE_IMP, 520);
		AddObjectCreatures("KG1", CREATURE_FAMILIAR, 520);
		AddObjectCreatures("KG2", CREATURE_HELLMARE, 130);
		AddObjectCreatures("KG2", CREATURE_FRIGHTFUL_NIGHTMARE, 130);		
        AddObjectCreatures("KG2", CREATURE_FIRE_ELEMENTAL, 130);
	elseif GetDifficulty()==DIFFICULTY_HEROIC then
		AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 1400 );
		AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 250 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 310 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 210 );		
		AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 86 );		
		AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 59 );
		AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 140 );
		ChangeHeroStat("Oddrema", STAT_ATTACK, 12);
		ChangeHeroStat("Oddrema", STAT_DEFENCE, 12);
		ChangeHeroStat("Oddrema", STAT_SPELL_POWER, 12);
		ChangeHeroStat("Oddrema", STAT_KNOWLEDGE, 9);		
		AddHeroCreatures( "Efion", CREATURE_FRIGHTFUL_NIGHTMARE, 80 );
		AddHeroCreatures( "Efion", CREATURE_HORNED_LEAPER, 195 );		
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 35 );
		AddHeroCreatures( "Efion", CREATURE_PIT_SPAWN, 65 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 165 );
		ChangeHeroStat("Efion", STAT_ATTACK, 12);
		ChangeHeroStat("Efion", STAT_DEFENCE, 12);
		ChangeHeroStat("Efion", STAT_SPELL_POWER, 12);
		ChangeHeroStat("Efion", STAT_KNOWLEDGE, 9);		
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 50 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 1000 );
		AddHeroCreatures( "Calid", CREATURE_FIREBREATHER_HOUND, 1000 );
		AddHeroCreatures( "Calid", CREATURE_SUCCUBUS_SEDUCER, 350 );
		AddHeroCreatures( "Calid", CREATURE_INFERNAL_SUCCUBUS, 350 );		
		AddHeroCreatures( "Calid", CREATURE_HORNED_LEAPER, 1500 );
		AddHeroCreatures( "Calid", CREATURE_NIGHTMARE, 250 );
		ChangeHeroStat("Calid", STAT_ATTACK, 24);
		ChangeHeroStat("Calid", STAT_DEFENCE, 24);
		ChangeHeroStat("Calid", STAT_SPELL_POWER, 12);
		ChangeHeroStat("Calid", STAT_KNOWLEDGE, 9);	
		AddHeroCreatures( "Jazaz", CREATURE_ARCH_DEMON, 111 );
		AddHeroCreatures( "Jazaz", CREATURE_FIREBREATHER_HOUND, 1000 );
		AddHeroCreatures( "Jazaz", CREATURE_BALOR, 200);
		AddHeroCreatures( "Jazaz", CREATURE_HELLMARE, 250 );
		AddHeroCreatures( "Jazaz", CREATURE_HORNED_LEAPER, 1000 );		
		ChangeHeroStat("Jazaz", STAT_ATTACK, 12);
		ChangeHeroStat("Jazaz", STAT_DEFENCE, 12);
		ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 66);
		ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 12);		
        AddHeroCreatures("Marder", CREATURE_ARCHDEVIL, 24);	
        AddHeroCreatures("Marder", CREATURE_INFERNAL_SUCCUBUS, 225);	
        AddHeroCreatures("Marder", CREATURE_CERBERI, 450);		
		AddHeroCreatures("Marder", CREATURE_HORNED_DEMON, 540);
		GiveHeroSkill("Marder", DEMON_FEAT_CRITICAL_GATING);
		AddHeroCreatures("Nymus", CREATURE_ARCH_DEMON, 30);
		AddHeroCreatures("Nymus", CREATURE_FIREBREATHER_HOUND, 450);
		AddHeroCreatures("Nymus", CREATURE_SUCCUBUS_SEDUCER, 165);
		AddHeroCreatures("Nymus", CREATURE_QUASIT, 1050);
		GiveHeroSkill("Nymus", DEMON_FEAT_CRITICAL_GATING);	
        AddHeroCreatures("Deleb", CREATURE_CERBERI, 300);
        AddHeroCreatures("Deleb", CREATURE_FIRE_ELEMENTAL, 150);	
        AddHeroCreatures("Deleb", CREATURE_HELLMARE, 120);
        AddHeroCreatures("Deleb", CREATURE_BALOR, 60);
        AddHeroCreatures("Deleb", CREATURE_IMP, 450);			
        AddObjectCreatures("mine1", CREATURE_ARCHDEVIL, 42);
        AddObjectCreatures("mine1", CREATURE_ARCH_DEMON, 42);
		AddObjectCreatures("mine2", CREATURE_SUCCUBUS_SEDUCER, 330);
		AddObjectCreatures("mine2", CREATURE_INFERNAL_SUCCUBUS, 330);
		AddObjectCreatures("mine3", CREATURE_HELLMARE, 225);	
		AddObjectCreatures("mine3", CREATURE_FRIGHTFUL_NIGHTMARE, 225);	
        AddObjectCreatures("DT1", CREATURE_HORNED_LEAPER, 600);
        AddObjectCreatures("DT1", CREATURE_SUCCUBUS_SEDUCER, 135);
        AddObjectCreatures("DT1", CREATURE_HORNED_DEMON, 600);
        AddObjectCreatures("DT1", CREATURE_INFERNAL_SUCCUBUS, 135);
        AddObjectCreatures("DT2", CREATURE_FIREBREATHER_HOUND, 255);
        AddObjectCreatures("DT2", CREATURE_QUASIT, 750);
        AddObjectCreatures("DT2", CREATURE_CERBERI, 255);
        AddObjectCreatures("DT2", CREATURE_IMP, 750);	
        AddObjectCreatures("SW2", CREATURE_QUASIT, 800);
        AddObjectCreatures("SW2", CREATURE_FRIGHTFUL_NIGHTMARE, 75);
        AddObjectCreatures("SW2", CREATURE_IMP, 800);
        AddObjectCreatures("SW2", CREATURE_HELLMARE, 75);	
        AddObjectCreatures("KG1", CREATURE_FRIGHTFUL_NIGHTMARE, 195);
        AddObjectCreatures("KG1", CREATURE_HELLMARE, 195);
		AddObjectCreatures("KG1", CREATURE_IMP, 780);
		AddObjectCreatures("KG1", CREATURE_FAMILIAR, 780);
		AddObjectCreatures("KG2", CREATURE_HELLMARE, 195);
		AddObjectCreatures("KG2", CREATURE_FRIGHTFUL_NIGHTMARE, 195);		
        AddObjectCreatures("KG2", CREATURE_FIRE_ELEMENTAL, 195);
	    AddHeroCreatures("Freyda", CREATURE_CLERIC, 5);
	    AddHeroCreatures("Freyda", CREATURE_BATTLE_GRIFFIN, 6);		
	    AddHeroCreatures("Freyda", CREATURE_SWORDSMAN, 5);
	    AddHeroCreatures("Freyda", CREATURE_LONGBOWMAN, 6);		
	    AddHeroCreatures("Freyda", CREATURE_MILITIAMAN, 5);		
	    AddHeroCreatures("Freyda", CREATURE_CHAMPION, 5);
	    AddHeroCreatures("Freyda", CREATURE_ARCHANGEL, 6);
	end
end

function St_1 ( heroname )
	SetObjectPosition( heroname, 129, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_2 ( heroname )
	SetObjectPosition( heroname, 33, 13, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_3 ( heroname )
	SetObjectPosition( heroname, 158, 68, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_4 ( heroname )
	SetObjectPosition( heroname, 28, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function A2C3M4_capture_town( town_name )
	local town = A2C3M4_TOWN_ATTACKS[town_name];
	startThread( loadstring(town.vo .. "()") );
	for i, hero in town.heroes do
		SetObjectOwner( hero, PLAYER_3 );
		sleep(20);
		EnableHeroAI( hero, nil );
	end
	sleep( 10 )
	RazeTown( town_name );
	Inferno_count = Inferno_count + 1;
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 8, 8000);
		RemoveObjectCreatures("Talonguard", CREATURE_ARCHDEVIL, 15); 
		RemoveObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 15);
		GiveExp( "Biara", 3000000 );
		GiveArtefact("Biara", 94); -- book of power
		GiveArtefact("Biara", 6); -- staff of the netherworld = -12% initiative to enemy, +1 spellpower	
		GiveArtefact("Biara", 73); -- ring of the shadowbrand   = -2 luck to enemy		
		GiveArtefact("Biara", 50); -- Helm of Dwarven Kings = immune to blind, 3 knowledge & defence
        GiveArtefact("Biara", 106); -- War drum of the legion = +T4 native units 		
		GiveArtefact("Zehir", 76); -- tome of destruction
		GiveExp("Deleb", 1210000);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Nymus", 492000);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Marder", 492000);
		GiveHeroWarMachine("Marder", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Marder", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Marder", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Dalom", 492000);
		GiveHeroSkill("Dalom", PERK_NO_REST_FOR_THE_WICKED);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Menel", 492000);
		GiveHeroWarMachine("Menel", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Menel", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Menel", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Ferigl", 1210000);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_FIRST_AID_TENT);	
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_FIRST_AID_TENT);	
		GiveHeroWarMachine("Efion", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Efion", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Efion", WAR_MACHINE_FIRST_AID_TENT);
		GiveHeroWarMachine("Calid", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Calid", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Calid", WAR_MACHINE_FIRST_AID_TENT);	
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_FIRST_AID_TENT);			
		SetUpTownFights(1);
		print("Difficulty level is easy.");
	end,
	
	[1] = function()
		diff = 2;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 12, 12000);
		GiveExp(  "Biara",   20000000);
		GiveArtefact("Biara", 94); -- book of power
		GiveArtefact("Biara", 6); -- staff of the netherworld = -12% initiative to enemy +1 spellpower	
		GiveArtefact("Biara", 73); -- ring of the shadowbrand   = -2 luck to enemy		
		GiveArtefact("Biara", 50); -- Helm of Dwarven Kings = immune to blind, 3 knowledge & defence	
        GiveArtefact("Biara", 107); -- Horn of the legion = +T5 native units 		
		GiveArtefact("Zehir", 76); -- tome of destruction
		GiveExp("Deleb", 3000000);
		GiveHeroSkill("Deleb", SKILL_LEARNING);	
		GiveHeroWarMachine("Deleb", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Nymus", 706000);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Marder", 706000);
		GiveHeroWarMachine("Marder", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Marder", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Marder", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Dalom", 846000);
		GiveHeroSkill("Dalom", PERK_NO_REST_FOR_THE_WICKED);
		ChangeHeroStat("Dalom", STAT_ATTACK, 5);
		ChangeHeroStat("Dalom", STAT_DEFENCE, 5);
		ChangeHeroStat("Dalom", STAT_SPELL_POWER, 5);
		ChangeHeroStat("Dalom", STAT_KNOWLEDGE, 5);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Dalom", CREATURE_BLACK_DRAGON, 10);	
        AddHeroCreatures("Dalom", CREATURE_MATRIARCH, 15);
        AddHeroCreatures("Dalom", CREATURE_ASSASSIN, 150);	
        AddHeroCreatures("Dalom", CREATURE_BLOOD_WITCH, 100);		
		GiveExp("Menel", 706000);
		ChangeHeroStat("Menel", STAT_ATTACK, 5);
		ChangeHeroStat("Menel", STAT_DEFENCE, 5);
		ChangeHeroStat("Menel", STAT_SPELL_POWER, 5);
		ChangeHeroStat("Menel", STAT_KNOWLEDGE, 5);	
		GiveHeroWarMachine("Menel", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Menel", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Menel", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Menel", CREATURE_ASSASSIN, 100);	
        AddHeroCreatures("Menel", CREATURE_BLOOD_WITCH, 70);	
        AddHeroCreatures("Menel", CREATURE_MATRIARCH, 15);
        AddHeroCreatures("Menel", CREATURE_MINOTAUR_KING, 50);	
        AddHeroCreatures("Menel", CREATURE_BLACK_RIDER, 30);		
		GiveExp("Ferigl", 3000000);
		ChangeHeroStat("Ferigl", STAT_ATTACK, 5);
		ChangeHeroStat("Ferigl", STAT_DEFENCE, 5);
		ChangeHeroStat("Ferigl", STAT_SPELL_POWER, 5);
		ChangeHeroStat("Ferigl", STAT_KNOWLEDGE, 5);
        GiveHeroSkill("Ferigl", SKILL_LEARNING);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_FIRST_AID_TENT);
		AddHeroCreatures("Ferigl", CREATURE_BLACK_RIDER, 10);
		AddHeroCreatures("Ferigl", CREATURE_BLOOD_WITCH, 120);
		AddHeroCreatures("Ferigl", CREATURE_RED_DRAGON, 15);
		AddHeroCreatures("Ferigl", CREATURE_ASSASSIN, 160);
		AddHeroCreatures("Ferigl", CREATURE_MINOTAUR_CAPTAIN, 80);
		AddHeroCreatures("Ferigl", CREATURE_MATRIARCH, 22);		
        GiveHeroSkill("Oddrema", SKILL_GATING);	
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Efion", SKILL_GATING);
        GiveHeroSkill("Efion", PERK_DEMONIC_FIRE);
		GiveHeroWarMachine("Efion", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Efion", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Efion", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", PERK_DEMONIC_FIRE);
		GiveHeroWarMachine("Calid", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Calid", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Calid", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Jazaz", SKILL_GATING);
		GiveHeroSkill("Jazaz", PERK_DEMONIC_FIRE);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_FIRST_AID_TENT);		
		SetUpTownFights(2);
		print("Difficulty level is normal.");
	end,
	
	[2] = function()
		diff = 3;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 16, 16000);
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 25 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 25 );
		GiveExp( "Biara",   124000000 );
		GiveArtefact("Biara", 94); -- book of power
		GiveArtefact("Biara", 6); -- staff of the netherworld = -12% initiative to enemy +1 spellpower
		GiveArtefact("Biara", 33); -- cloak of death's shadow   = -2 def, -2 morale & luck to enemy		
		GiveArtefact("Biara", 73); -- ring of the shadowbrand   = -2 luck to enemy		
		GiveArtefact("Biara", 50); -- Helm of Dwarven Kings = immune to blind, 3 knowledge & defence		
        GiveArtefact("Biara", 108); -- Mantle of the legion = +T6 native units 		
		GiveArtefact("Zehir", 76); -- tome of destruction
		GiveExp("Deleb", 7640000);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_FIRST_AID_TENT);		
		GiveHeroSkill("Deleb", SKILL_LEARNING);		
		GiveExp("Nymus", 846000);
		GiveHeroSkill("Nymus", SKILL_LEARNING);	
		GiveHeroWarMachine("Nymus", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Marder", 846000);
		GiveHeroSkill("Marder", SKILL_LEARNING);
		GiveHeroSkill("Marder", SKILL_GATING);	
		GiveHeroWarMachine("Marder", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Marder", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Marder", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Dalom", 1450000);
		GiveHeroSkill("Dalom", SKILL_LEARNING);	
        GiveHeroSkill("Dalom", PERK_NO_REST_FOR_THE_WICKED);
		ChangeHeroStat("Dalom", STAT_ATTACK, 10);
		ChangeHeroStat("Dalom", STAT_DEFENCE, 10);
		ChangeHeroStat("Dalom", STAT_SPELL_POWER, 10);
		ChangeHeroStat("Dalom", STAT_KNOWLEDGE, 10);
        GiveArtefact("Dalom", 61); -- +15% earth damage	
		GiveHeroWarMachine("Dalom", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Dalom", CREATURE_BLACK_DRAGON, 20);	
        AddHeroCreatures("Dalom", CREATURE_MATRIARCH, 30);
        AddHeroCreatures("Dalom", CREATURE_ASSASSIN, 300);	
        AddHeroCreatures("Dalom", CREATURE_BLOOD_WITCH, 200);		
		GiveExp("Menel", 846000);	
		ChangeHeroStat("Menel", STAT_ATTACK, 10);
		ChangeHeroStat("Menel", STAT_DEFENCE, 10);
		ChangeHeroStat("Menel", STAT_SPELL_POWER, 10);
		ChangeHeroStat("Menel", STAT_KNOWLEDGE, 10);
		GiveHeroWarMachine("Menel", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Menel", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Menel", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Menel", CREATURE_ASSASSIN, 200);	
        AddHeroCreatures("Menel", CREATURE_BLOOD_WITCH, 140);	
        AddHeroCreatures("Menel", CREATURE_MATRIARCH, 30);
        AddHeroCreatures("Menel", CREATURE_MINOTAUR_KING, 100);	
        AddHeroCreatures("Menel", CREATURE_BLACK_RIDER, 60);		
		GiveExp("Ferigl", 7640000);	
        GiveHeroSkill("Ferigl", SKILL_LEARNING);
		ChangeHeroStat("Ferigl", STAT_ATTACK, 10);
		ChangeHeroStat("Ferigl", STAT_DEFENCE, 10);
		ChangeHeroStat("Ferigl", STAT_SPELL_POWER, 10);
		ChangeHeroStat("Ferigl", STAT_KNOWLEDGE, 10);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_FIRST_AID_TENT);	
		AddHeroCreatures("Ferigl", CREATURE_BLACK_RIDER, 30);
		AddHeroCreatures("Ferigl", CREATURE_BLOOD_WITCH, 240);
		AddHeroCreatures("Ferigl", CREATURE_RED_DRAGON, 30);
		AddHeroCreatures("Ferigl", CREATURE_ASSASSIN, 320);
		AddHeroCreatures("Ferigl", CREATURE_MINOTAUR_CAPTAIN, 160);
		AddHeroCreatures("Ferigl", CREATURE_MATRIARCH, 44);		
        GiveHeroSkill("Oddrema", SKILL_GATING);	
        GiveHeroSkill("Oddrema", SKILL_GATING);	
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Efion", SKILL_GATING);	
        GiveHeroSkill("Efion", SKILL_GATING);
        GiveHeroSkill("Efion", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Efion", DEMON_FEAT_DEMONIC_RETALIATION);
		GiveHeroWarMachine("Efion", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Efion", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Efion", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Calid", DEMON_FEAT_GATING_MASTERY);	
		GiveHeroSkill("Calid", SKILL_WAR_MACHINES);		
		GiveHeroSkill("Calid", PERK_CATAPULT);		
		GiveHeroWarMachine("Calid", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Calid", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Calid", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Jazaz", SKILL_GATING);
        GiveHeroSkill("Jazaz", SKILL_GATING);
		GiveHeroSkill("Jazaz", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Jazaz", DEMON_FEAT_DEMONIC_RETALIATION);	
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_FIRST_AID_TENT);		
		SetUpTownFights(3);	
		print("Difficulty level is hard.");
	end,
		
	[3] = function()
		diff = 4;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 20, 20000);
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 45 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 45 );
		GiveExp(  "Biara",   550000000 );
		GiveArtefact("Biara", 94); -- book of power
		GiveArtefact("Biara", 6); -- staff of the netherworld = -12% initiative to enemy +1 spellpower
		GiveArtefact("Biara", 33); -- cloak of death's shadow   = -2 def, -2 morale & luck to enemy		
		GiveArtefact("Biara", 73); -- ring of the shadowbrand   = -2 luck to enemy		
		GiveArtefact("Biara", 50); -- Helm of Dwarven Kings = immune to blind, 3 knowledge & defence
        GiveArtefact("Biara", 109); -- Banner of the legion = +T7 native units 		
		GiveArtefact("Zehir", 76); -- tome of destruction
		GiveHeroSkill("Biara", SKILL_GATING);
		GiveHeroSkill("Biara", SKILL_GATING);
		GiveHeroSkill("Biara", SKILL_GATING);
		GiveHeroSkill("Biara", PERK_DEMONIC_FIRE);
		GiveHeroSkill("Biara", DEMON_FEAT_GATING_MASTERY);
		GiveHeroSkill("Biara", DEMON_FEAT_CRITICAL_GATING);	
		GiveHeroSkill("Biara", DEMON_FEAT_QUICK_GATING);			
		GiveExp("Deleb", 20000000);
		GiveHeroSkill("Deleb", SKILL_LEARNING);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Deleb", WAR_MACHINE_FIRST_AID_TENT);
		GiveExp("Nymus", 1210000);
		GiveHeroSkill("Nymus", SKILL_LEARNING);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Nymus", WAR_MACHINE_FIRST_AID_TENT);
		GiveExp("Marder", 1210000);
		GiveHeroSkill("Marder", SKILL_LEARNING);
		GiveHeroSkill("Marder", SKILL_GATING);
		GiveHeroWarMachine("Marder", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Marder", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Marder", WAR_MACHINE_FIRST_AID_TENT);		
		GiveExp("Dalom", 3000000);
		GiveHeroSkill("Dalom", SKILL_LEARNING);
		GiveHeroSkill("Dalom", HERO_SKILL_SHRUG_DARKNESS);
        GiveArtefact("Dalom", 193); -- +25% earth damage
        GiveArtefact("Dalom", 61); 	-- +15% earth damage
		ChangeHeroStat("Dalom", STAT_ATTACK, 15);
		ChangeHeroStat("Dalom", STAT_DEFENCE, 15);
		ChangeHeroStat("Dalom", STAT_SPELL_POWER, 15);
		ChangeHeroStat("Dalom", STAT_KNOWLEDGE, 15);	
		GiveHeroWarMachine("Dalom", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Dalom", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Dalom", CREATURE_BLACK_DRAGON, 30);	
        AddHeroCreatures("Dalom", CREATURE_MATRIARCH, 45);
        AddHeroCreatures("Dalom", CREATURE_ASSASSIN, 450);	
        AddHeroCreatures("Dalom", CREATURE_BLOOD_WITCH, 300);		
		GiveExp("Menel", 1210000);
		ChangeHeroStat("Menel", STAT_ATTACK, 15);
		ChangeHeroStat("Menel", STAT_DEFENCE, 15);
		ChangeHeroStat("Menel", STAT_SPELL_POWER, 15);
		ChangeHeroStat("Menel", STAT_KNOWLEDGE, 15);
		GiveArtefact("Menel", 57); -- +1 speed
		GiveHeroWarMachine("Menel", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Menel", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Menel", WAR_MACHINE_FIRST_AID_TENT);	
        AddHeroCreatures("Menel", CREATURE_ASSASSIN, 300);	
        AddHeroCreatures("Menel", CREATURE_BLOOD_WITCH, 210);	
        AddHeroCreatures("Menel", CREATURE_MATRIARCH, 45);
        AddHeroCreatures("Menel", CREATURE_MINOTAUR_KING, 150);	
        AddHeroCreatures("Menel", CREATURE_BLACK_RIDER, 90);		
		GiveExp("Ferigl", 20000000);
        GiveHeroSkill("Ferigl", SKILL_LEARNING);
		ChangeHeroStat("Ferigl", STAT_ATTACK, 15);
		ChangeHeroStat("Ferigl", STAT_DEFENCE, 15);
		ChangeHeroStat("Ferigl", STAT_SPELL_POWER, 15);
		ChangeHeroStat("Ferigl", STAT_KNOWLEDGE, 15);	
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Ferigl", WAR_MACHINE_FIRST_AID_TENT);
        AddHeroCreatures("Ferigl", CREATURE_BLACK_RIDER, 50);
		AddHeroCreatures("Ferigl", CREATURE_BLOOD_WITCH, 360);
		AddHeroCreatures("Ferigl", CREATURE_RED_DRAGON, 45);
		AddHeroCreatures("Ferigl", CREATURE_ASSASSIN, 480);
		AddHeroCreatures("Ferigl", CREATURE_MINOTAUR_CAPTAIN, 240);
		AddHeroCreatures("Ferigl", CREATURE_MATRIARCH, 66);			
        GiveHeroSkill("Oddrema", SKILL_GATING);	
        GiveHeroSkill("Oddrema", SKILL_GATING);	
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Oddrema", WAR_MACHINE_FIRST_AID_TENT);		
        GiveHeroSkill("Efion", SKILL_GATING);
        GiveHeroSkill("Efion", SKILL_GATING);	
        GiveHeroSkill("Efion", SKILL_GATING);
        GiveHeroSkill("Efion", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Efion", DEMON_FEAT_DEMONIC_RETALIATION);	
        GiveHeroSkill("Efion", DEMON_FEAT_CRITICAL_GATING);
		GiveHeroWarMachine("Efion", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Efion", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Efion", WAR_MACHINE_FIRST_AID_TENT);			
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", SKILL_GATING);
        GiveHeroSkill("Calid", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Calid", DEMON_FEAT_GATING_MASTERY);	
        GiveHeroSkill("Calid", DEMON_FEAT_CRITICAL_GATING);	
		GiveHeroSkill("Calid", SKILL_WAR_MACHINES);
		GiveHeroSkill("Calid", SKILL_WAR_MACHINES);		
		GiveHeroSkill("Calid", PERK_CATAPULT);
		GiveHeroWarMachine("Calid", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Calid", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Calid", WAR_MACHINE_FIRST_AID_TENT);			
        GiveHeroSkill("Jazaz", SKILL_GATING);
        GiveHeroSkill("Jazaz", SKILL_GATING);
        GiveHeroSkill("Jazaz", SKILL_GATING);
		GiveHeroSkill("Jazaz", PERK_DEMONIC_FIRE);
        GiveHeroSkill("Jazaz", DEMON_FEAT_DEMONIC_RETALIATION);	
        GiveHeroSkill("Jazaz", DEMON_FEAT_CRITICAL_GATING);	
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_BALLISTA);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_AMMO_CART);
		GiveHeroWarMachine("Jazaz", WAR_MACHINE_FIRST_AID_TENT);			
		SetUpTownFights(4);
		print("Difficulty level is heroic.");
	end,
}

CINEMATICS = {
	showPortal = function()
		BlockGame();
		OpenCircleFog( 159, 99, 0, 8, PLAYER_1 );  
		MoveCamera(159, 99, 0, 50, 1);
		PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
		pcall(RemoveObject, "ef1");
		UnblockGame();
	end,
	
	VO_Duncan = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO11_Duncan_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Shadwyn = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO12_Ylaya_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Gottai = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO13_Orc1_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Wulfstan = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO14_Thorod_01sound.xdb#xpointer(/Sound)" );
	end,
	
	VO_ZehirDefeatsElves = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO9_Zehir_01sound.xdb#xpointer(/Sound)" );
	end
}

OBJECTIVES = {
	state = {
		isAlive  	      = { "prim1", 1 }, -- Ally heroes must survive
		getGoldMines      = { "prim2", 1 }, -- Capture the 3 gold mines
		reachPortal		  = { "prim3", 0 }, -- 
		destroyBarrier    = { "prim4", 0 }, -- Defeat 2 Inferno heroes to destroy the magic barrier
		defeatDarkElves	  = { "prim5", 0 }, -- Defeat Dark Elves
		captureTalonguard = { "prim6", 0 }, -- Capture Talonguard town
		plunderWarrens	  = {  "sec1", 1 }, -- Capture the 2 Dwarven Warrens
		destroyDemon	  = {  "sec2", 0 }, -- Destroy the Demon Leader
		freeMatriarchs	  = {  "sec3", 0 }, -- Free Matriarchs
		learnSpell		  = {  "sec4", 0 }, -- Learn Instant Travel spell
		_checkTowns		  = {     "_", 1 }, -- Events triggered on town capture
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		OpenCircleFog( 91, 86, 0, 16, PLAYER_1 ); ---фог_cо_столицы
		SetObjectEnabled( "f_portal", nil )
		BlockTownGarrisonForAI( "Talonguard", not nil )
		BlockTownGarrisonForAI( "delf", not nil )
		BlockTownGarrisonForAI( "inf1", not nil )
		BlockTownGarrisonForAI( "inf2", not nil )
		BlockTownGarrisonForAI( "inf3", not nil )
		BlockTownGarrisonForAI( "inf4", not nil )
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 10 , 10000 );
		EnableHeroAI(   "Biara", nil );
		EnableHeroAI(  "Ferigl", nil );
		EnableHeroAI(  "Menel", nil ); -- First wave enganging fight with Zehir 
		EnableHeroAI(  "Dalom", nil ); -- Second wave before deal with town garrison 
		EnableHeroAI(   "Efion", nil );
		EnableHeroAI( "Oddrema", nil );
		EnableHeroAI(   "Calid", nil );
		EnableHeroAI(   "Jazaz", nil );
		SetRegionBlocked(         "biara", 1, PLAYER_2 ); 
		SetRegionBlocked( "border_demons", 1, PLAYER_1 ); 
		SetRegionBlocked(     "red_hero1", 1, PLAYER_2 ); 
		SetRegionBlocked(	  "red_hero2", 1, PLAYER_2 );
		SetRegionBlocked(     "red_hero3", 1, PLAYER_2 );  
		SetRegionBlocked(  	    "i_boss1", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	    "i_boss2", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	    "i_boss3", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	      "drag1", 1, PLAYER_2 ); -- Block the Demon leader from collecting the artifact
		SetRegionBlocked(            "DD", 1, PLAYER_4 ); -- Block Dark Elves form defeating the dragons and learning the Instant Travel spell
		SetRegionBlocked(    "final_wey1", 1, PLAYER_4 ); -- Block Dark Elves from accessing the portal
		SetRegionBlocked(    "final_wey2", 1, PLAYER_4 ); -- Block Dark Elves from accessing the portal
		Trigger(OBJECT_TOUCH_TRIGGER, "f_portal", "x_enter" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons",      "_reachPortal", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec2_start",    "_destroyDemons", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec3_start",   "_freeMatriarchs", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec4_start", "_learnTravelSpell", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh1",         "St_1" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh2",         "St_2" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh3",         "St_3" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,          "elf",         "St_4" );
		startThread( DIFFICULTY[GetDifficulty()] );

		if GetGameVar("A2C3M3_Graal") == "1" then
			GiveArtefact("Zehir", ARTIFACT_GRAAL);
		elseif GetGameVar("A2C3M3_Graal") == "2" then
			UpgradeTownBuilding( "z_town", TOWN_BUILDING_GRAIL )	
		end
		startThread(Summon_town);
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim6") == OBJECTIVE_COMPLETED then
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	isAlive_list = { [0] = "Zehir" }, -- the [0] is a fix for H55_Insert to work properly
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 then
			for i, hero in OBJECTIVES.isAlive_list do
				if IsHeroAlive(hero) == nil then
					SetObjectiveState( "prim1", OBJECTIVE_FAILED );
					OBJECTIVES.state.isAlive[2] = 11;
					break
				end
			end
		end
	end,
	
	getGoldMines = function()
		if OBJECTIVES.state.getGoldMines[2] == 1 then
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.getGoldMines[2] = 2;
		elseif OBJECTIVES.state.getGoldMines[2] == 2 and GetObjectOwner("mine1") == PLAYER_1 and GetObjectOwner("mine2") == PLAYER_1 and GetObjectOwner("mine3") == PLAYER_1 then
			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
			SetObjectEnabled( "f_portal", not nil );
			CINEMATICS.showPortal();
			OBJECTIVES.state.reachPortal[2] = 1;
			OBJECTIVES.state.getGoldMines[2] = 10;
		end
	end,
	
	reachPortal = function()
		if OBJECTIVES.state.reachPortal[2] == 1 then
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			sleep(40);
			Start_Wulfstan();
			OBJECTIVES.state.reachPortal[2] = 2;
		elseif OBJECTIVES.state.reachPortal[2] == 3 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.reachPortal[2] = 10;
		end
	end,
	
	destroyBarrier = function()
		if OBJECTIVES.state.destroyBarrier[2] == 1 then
			SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
			sleep(50);
			startThread( Start_Freyda );
			OpenCircleFog( 159, 77, 0, 4, PLAYER_1 );
			OpenCircleFog( 160, 49, 0, 4, PLAYER_1 );
			OBJECTIVES.state.destroyBarrier[2] = 2;			
		elseif OBJECTIVES.state.destroyBarrier[2] == 2 and IsHeroAlive("Marder") == nil and IsHeroAlive("Nymus") == nil then 
			RemoveObject("f1");
			RemoveObject("f2");
			SetRegionBlocked( "border_demons", nil, PLAYER_1 );
			SetObjectiveState( 'prim4', OBJECTIVE_COMPLETED );
			startThread( Start_Kujin );
			OBJECTIVES.state.defeatDarkElves[2] = 1;
			OBJECTIVES.state.destroyBarrier[2] = 10;
		end
	end,

	defeatDarkElves = function()
		if OBJECTIVES.state.defeatDarkElves[2] == 1 then
			SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.defeatDarkElves[2] = 2;
		elseif OBJECTIVES.state.defeatDarkElves[2] == 2 and GetPlayerState(PLAYER_4) == 3 then
			SetObjectiveState( "prim5", OBJECTIVE_COMPLETED );
			SetObjectiveState( "Pri7_FreeLand", OBJECTIVE_COMPLETED ); -- activated by A2C3M4 map.xdb
			RemoveObjectCreatures("x1", CREATURE_ARCH_DEMON, 1000 - GetDifficulty() * 150);
			RemoveObjectCreatures("x2", CREATURE_ARCH_DEMON, 1000 - GetDifficulty() * 150);
			RemoveObject("final_gate1");
			RemoveObject("final_gate2");
			CINEMATICS.VO_ZehirDefeatsElves();
			MessageBox("/Maps/Scenario/a2c3m4/Def_elf.txt");
			OBJECTIVES.state.captureTalonguard[2] = 1;
			OBJECTIVES.state.defeatDarkElves[2] = 10;
		end
	end,
	
	captureTalonguard = function()
		if OBJECTIVES.state.captureTalonguard[2] == 1 then
			SetObjectiveState('prim6', OBJECTIVE_ACTIVE);
			BlockGame();
			sleep(80);
			OpenCircleFog( 28, 150, 1, 10, PLAYER_1 );
			MoveCamera(28, 150, 1, 50, 1);
			sleep(80);
			DeployReserveHero( "Shadwyn", 28, 154, 1 );
			sleep(60);
			ChangeHeroStat( "Shadwyn", STAT_MANA_POINTS, 500 );
			GiveArtefact("Shadwyn", 39);
			GiveArtefact("Shadwyn", 36);
			GiveArtefact("Shadwyn", 40);
			GiveArtefact("Shadwyn", 59);
			GiveArtefact("Shadwyn", 37);
			GiveArtefact("Shadwyn", 43);
			PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO17_Ylaya_01sound.xdb#xpointer(/Sound)" ); 
			ChangeHeroStat( "Shadwyn", STAT_MOVE_POINTS, 30000 );
			MoveHeroRealTime( "Shadwyn", 28, 143, 1 );
			sleep(70);
			H55_Insert(OBJECTIVES.isAlive_list, "Shadwyn" ); 
			UnblockGame();
			OBJECTIVES.state.captureTalonguard[2] = 2;
		elseif OBJECTIVES.state.captureTalonguard[2] == 2 and GetObjectOwner("Talonguard") == PLAYER_1 then
			StartDialogScene("/DialogScenes/A2C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
			StartDialogScene("/DialogScenes/A2C3/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState('prim6', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureTalonguard[2] = 10;
		end
	end,
	
	plunderWarrens = function()
		if OBJECTIVES.state.plunderWarrens[2] == 1 then
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.plunderWarrens[2] = 2;
		elseif OBJECTIVES.state.plunderWarrens[2] == 2 and GetObjectOwner("DT1") == PLAYER_1 and GetObjectOwner("DT2") == PLAYER_1 then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO3_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Захват дварф шахт
			sleep( 10 );
			LevelUpHero( "Zehir" );
			OBJECTIVES.state.plunderWarrens[2] = 10;
		end
	end,
	
	destroyDemon = function()
		if OBJECTIVES.state.destroyDemon[2] == 1 then
			SetObjectiveState('sec2',OBJECTIVE_ACTIVE);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO4_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Демон инферно
			OBJECTIVES.state.destroyDemon[2] = 2;
		elseif OBJECTIVES.state.destroyDemon[2] == 2 and IsHeroAlive("Deleb") == nil then
			SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
			sleep(40);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO5_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили демона
			OBJECTIVES.state.destroyDemon[2] = 10;
		end
	end,
	
	freeMatriarchs = function()
		if OBJECTIVES.state.freeMatriarchs[2] == 1 then
			SetObjectiveState( "sec3", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.freeMatriarchs[2] = 2;
		elseif OBJECTIVES.state.freeMatriarchs[2] == 2 and IsObjectExists ("gvard") == nil then
			SetObjectiveState( "sec3", OBJECTIVE_COMPLETED );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO6_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили охрану матриархов
			OBJECTIVES.state.freeMatriarchs[2] = 10;
		end
	end,
	
	learnSpell = function()
		if OBJECTIVES.state.learnSpell[2] == 1 then
			SetObjectiveState( "sec4", OBJECTIVE_ACTIVE );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO8_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO
			OBJECTIVES.state.learnSpell[2] = 2;
		elseif OBJECTIVES.state.learnSpell[2] == 2 and KnowHeroSpell( "Zehir", 50 ) == not nil then
			SetObjectiveState( "sec4", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.learnSpell[2] = 10;
		end
	end,
	
	_checkTowns_list = { "inf2", "inf4", "inf3", "inf1" },
	_checkTowns_reinforcements = { nil, nil },
	_checkTowns = function()
		if OBJECTIVES.state._checkTowns[2] == 1 then
			if Inferno_count < 4 then
				for i, town in OBJECTIVES._checkTowns_list do
					if GetObjectOwner(town) == PLAYER_1 then
						A2C3M4_capture_town(town);
						RemoveObjectCreatures("x1", CREATURE_FAMILIAR, 100000);
						RemoveObjectCreatures("x2", CREATURE_FAMILIAR, 100000);
						OBJECTIVES._checkTowns_list[i] = nil;
					end
				end
				sleep(50);
			else
				BlockGame();
				MoveCamera(96, 85, GROUND, 25, 3.14/3, 0, 1, 1, 1);
				PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO10_Zehir_01sound.xdb#xpointer(/Sound)" ); -----------VO прибытие кричей
				CreateMonster( "m1",   CREATURE_BLACK_DRAGON, 135 - 25 * GetDifficulty(), 96, 88, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m2",   CREATURE_MAGMA_DRAGON, 135 - 25 * GetDifficulty(), 96, 86, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m3", CREATURE_CYCLOP_UNTAMED, 135 - 25 * GetDifficulty(), 96, 84, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m4", 	  CREATURE_ARCHANGEL, 135 - 25 * GetDifficulty(), 96, 82, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				UnblockGame();
				OBJECTIVES.state._checkTowns[2] = 10;
			end
		end
		
		if GetDate(MONTH) == 4 - GetDifficulty() and GetDate(WEEK) == 1 and GetDate(DAY_OF_WEEK) == 1 and OBJECTIVES._checkTowns_reinforcements[1] == nil then 
			AddObjectCreatures("Talonguard",  CREATURE_ARCHDEVIL, 30); 
			AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 30);
			OBJECTIVES._checkTowns_reinforcements[1] = 1;
		end
		
		if GetDate(MONTH) == 5 - GetDifficulty() and GetDate(WEEK) == 1 and GetDate(DAY_OF_WEEK) == 1 and OBJECTIVES._checkTowns_reinforcements[2] == nil then 
			AddObjectCreatures("Talonguard",  CREATURE_ARCHDEVIL, 75); 
			AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 75); 
			OBJECTIVES._checkTowns_reinforcements[2] = 1;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )

function a2c3m4_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectOwner("DT1", PLAYER_1);
		SetObjectOwner("DT2", PLAYER_1);
	elseif var == 2 then
		SetObjectOwner("mine1", PLAYER_1);
		SetObjectOwner("mine2", PLAYER_1);
		SetObjectOwner("mine3", PLAYER_1);
	elseif var == 3 then
		SetObjectPosition("Zehir", 158, 99, 0);
	elseif var == 33 then
		SetObjectPosition("Zehir",  69, 31, 0);
	elseif var == 333 then
		RemoveObject("Marder");
		RemoveObject("Nymus");
		--SetObjectPosition("Zehir", 161, 46, 0);
		--SetObjectPosition("Zehir", 157, 78, 0);		
	elseif var == 3333 then
		SetObjectPosition("Zehir", 156, 68, 0);
	elseif var == 33333 then
		SetObjectPosition("Zehir", 61, 120, 1);
	elseif var == 4 then
		SetObjectOwner("delf", PLAYER_1);
	end
end
