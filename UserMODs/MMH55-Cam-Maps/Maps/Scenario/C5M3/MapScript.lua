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

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/scripts/h55_enum_runtime")
function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M3");
    LoadHeroAllSetArtifacts("Heam", "C5M2" );
end;

startThread(H55_InitSetArtifacts);

obj01 = 0;
obj03 = 0;
obj04 = 0;
newday = 1;
heroarray = {};
enemyhero = {};
attackday = 1;
atk_type = 0;
DayX = 10000;
RND = random(7)+1;
was = 0;
NameH = "Heam";
Defeat = 0;
b = 0;
SetRegionBlocked("prison2", 1, 2);
SetRegionBlocked("prison1", 1, 2);
SetRegionBlocked("block", 1, 1);

for a = 43,54 do
	SetObjectDwellingCreatures("Siris", a , 0);
end;

if GetDifficulty() == DIFFICULTY_EASY then
	dif = 0;
	print ("easy");
	AddObjectCreatures(NameH, CREATURE_SPRITE, 130);
	AddObjectCreatures(NameH, CREATURE_WAR_DANCER, 108);
	AddObjectCreatures(NameH, CREATURE_GRAND_ELF, 86);
	AddObjectCreatures(NameH, CREATURE_DRUID_ELDER, 62);
	AddObjectCreatures(NameH, CREATURE_WAR_UNICORN , 44);
	AddObjectCreatures(NameH, CREATURE_TREANT_GUARDIAN , 21);
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	dif = 1;
	print ("normal");
	AddObjectCreatures(NameH, CREATURE_SPRITE, 100);
	AddObjectCreatures(NameH, CREATURE_WAR_DANCER, 71);
	AddObjectCreatures(NameH, CREATURE_GRAND_ELF, 58);
	AddObjectCreatures(NameH, CREATURE_DRUID_ELDER, 41);
	AddObjectCreatures(NameH, CREATURE_WAR_UNICORN , 29);
end;
if GetDifficulty() == DIFFICULTY_HARD then
	dif = 2;
	print ("hard");
	AddObjectCreatures(NameH, CREATURE_SPRITE, 30);
	AddObjectCreatures(NameH, CREATURE_WAR_DANCER, 25);
	AddObjectCreatures(NameH, CREATURE_GRAND_ELF, 20);
	AddObjectCreatures(NameH, CREATURE_DRUID_ELDER, 15);
	AddObjectCreatures(NameH, CREATURE_WAR_UNICORN , 10);
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	dif = 4;
	print ("heroic");
end;

function SirisCapture( oldOwner, newOwner )
	if ( newOwner == PLAYER_2 or newOwner == PLAYER_3 ) then -- enemy has captured Imarium
		if ( obj01 == 1 ) then
			Loose();
		else
			MoveHeroRealTime("Effig", 80 , 125);
			StartDialogScene("/DialogScenes/C5/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("CaptureImarium", OBJECTIVE_ACTIVE );
		end;
	end;
	if ( newOwner == PLAYER_1 ) then -- player has captured Imarium
		obj01 = 1;
		Save("autosave");
		StartDialogScene("/DialogScenes/C5/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("CaptureImarium", OBJECTIVE_COMPLETED);
		sleep (5);
		Reso = GetPlayerResource(PLAYER_1, GOLD) + 5000;
		SetPlayerResource(PLAYER_1, GOLD, Reso);
		SetObjectiveState("DefendImarium", OBJECTIVE_ACTIVE );
--		SetRegionBlocked("enemy", nil);
		DayX = GetDate(DAY)+3;
		startThread(attack, 0);
    end;
end;

function attack( param )
	week = GetDate(MONTH)*4 - 4 + GetDate(WEEK);
	if param == 0 then
		if IsHeroAlive("Nemor") == nil then
			DeployReserveHero("Nemor", RegionToPoint("Start"));
			sleep ( 1 );
			exp = GetHeroStat("Heam", STAT_EXPERIENCE);
			if GetHeroStat("Nemor", STAT_EXPERIENCE) < GetHeroStat("Heam", STAT_EXPERIENCE) then
				ChangeHeroStat("Nemor", STAT_EXPERIENCE , exp + (1000*week));
				print (exp);
			end;
			AddObjectCreatures("Nemor", CREATURE_SKELETON, (23 + dif)*week);
			AddObjectCreatures("Nemor", CREATURE_ZOMBIE, (16 + dif)*week);
			AddObjectCreatures("Nemor", CREATURE_MANES, (12 + dif)*week);
			AddObjectCreatures("Nemor", CREATURE_VAMPIRE, 7*week  + dif);
			AddObjectCreatures("Nemor", CREATURE_LICH, 5*week + dif);
			SetAIHeroAttractor("Siris",'Nemor',2);
			SetAIPlayerAttractor("Siris",GetObjectOwner('Nemor'),2);				
			EnableHeroAI("Nemor", not nil);	
			sleep( 1 );
			if CanMoveHero("Nemor",80,125,0) == not nil then
				startThread(H55_AttackTown,"Nemor","Siris");
				--MoveHero("Nemor", GetObjectPosition("Siris"));
			end;
		end;
	else
		if IsHeroAlive("Gles") == nil then
			DeployReserveHero("Gles", RegionToPoint("Start"));
			sleep ( 1 );
			exp = GetHeroStat("Heam", STAT_EXPERIENCE);
			if GetHeroStat("Gles", STAT_EXPERIENCE) < GetHeroStat("Heam", STAT_EXPERIENCE) then
				ChangeHeroStat("Gles", STAT_EXPERIENCE , exp + (1000*week));
				print (exp);
			end;
			AddObjectCreatures("Gles", CREATURE_SKELETON, (29 + dif)*week);
			AddObjectCreatures("Gles", CREATURE_SKELETON_ARCHER, (22 + dif)*week);
			AddObjectCreatures("Gles", CREATURE_ZOMBIE, (16 + dif)*week);
			AddObjectCreatures("Gles", CREATURE_GHOST, 10*week + dif);
			AddObjectCreatures("Gles", CREATURE_LICH, 5*week + dif);
			SetAIHeroAttractor("Siris",'Gles',2);
			SetAIPlayerAttractor("Siris",GetObjectOwner('Gles'),2);			
			EnableHeroAI("Gles", not nil);
			sleep( 1 );
			if CanMoveHero("Gles",80,125,0) == not nil then
				startThread(H55_AttackTown,"Gles","Siris");
				--MoveHero("Gles", GetObjectPosition("Siris"));
			end;
		end;
	end;
end;

function NewHero(namename)
	if namename == "Nadaur" or namename == "Diraya" then
		b = b + 1;
	end;
	if b == 2 then
		if ( obj03 == 0 ) then
			StartDialogScene("/DialogScenes/C5/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState( "twoheros", OBJECTIVE_COMPLETED );
			obj03 = 1;
			sleep (5);
			LevelUpHero("Heam");
		end;
	end;
end;

function Garnison()
	while 1 do
		sleep ( 20 );
		NameH = GetTownHero("Siris");
		--print(NameH);
		if NameH == nil then
			townd = GetObjectCreatures("Siris", CREATURE_DRUID_ELDER);
			townu = GetObjectCreatures("Siris", CREATURE_WAR_UNICORN);
			towndr = GetObjectCreatures("Siris", CREATURE_GREEN_DRAGON) + GetObjectCreatures("Siris", CREATURE_GOLD_DRAGON) + GetObjectCreatures("Siris", CREATURE_RAINBOW_DRAGON);
		else
			townd = GetObjectCreatures("Siris", CREATURE_DRUID_ELDER) + GetHeroCreatures(NameH, CREATURE_DRUID_ELDER);
			townu = GetObjectCreatures("Siris", CREATURE_WAR_UNICORN) + GetHeroCreatures(NameH, CREATURE_WAR_UNICORN);
			towndr = GetObjectCreatures("Siris", CREATURE_GREEN_DRAGON) + GetObjectCreatures("Siris", CREATURE_GOLD_DRAGON) + GetObjectCreatures("Siris", CREATURE_RAINBOW_DRAGON);
			towndr = towndr + GetHeroCreatures(NameH, CREATURE_GREEN_DRAGON) + GetHeroCreatures(NameH, CREATURE_GOLD_DRAGON) + GetHeroCreatures(NameH, CREATURE_RAINBOW_DRAGON);
		end;
		if townd >= 50 and townu >= 30 and towndr >= 10 then
			if obj04 == 0 then
				StartDialogScene("/DialogScenes/C5/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
				SetObjectiveState("harrison", OBJECTIVE_COMPLETED);
				sleep (5);
				LevelUpHero("Heam");
				obj04 = 1;
			end;
			if obj04 == 2 then
				SetObjectiveState("harrison", OBJECTIVE_COMPLETED);
				obj04 = 1;
			end;
		else
			if obj04 == 1 then
				SetObjectiveState( "harrison", OBJECTIVE_ACTIVE );
				obj04 = 2;
			end;
		end;
		if obj03 == 1 and obj04 == 1 then
			SaveHeroAllSetArtifactsEquipped("Heam", "C5M3");
			StartDialogScene("/DialogScenes/C5/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
			Win();
			break;
		end;
	end;
end;	

function H55_TriggerDaily()
	if IsHeroAlive("Nemor") == not nil and CanMoveHero("Nemor",80,125,0) == not nil then
		startThread(H55_AttackTown,"Nemor","Siris");
	end;
	if IsHeroAlive("Gles") == not nil and CanMoveHero("Gles",80,125,0) == not nil then
		startThread(H55_AttackTown,"Gles","Siris");
	end;
	
	if GetDate(DAY) == 7 and obj01 == 0 then
		Loose();
	end;
	print ("next" , RND + DayX);
	if GetDate(DAY) == RND + DayX then
		startThread(attack, atk_type);
		atk_type = 1 - atk_type;
		RND = RND + random (8) + 8 - dif;
	end;
end;

function LostHero( HeroName )
	if ( HeroName == "Heam" ) or ( HeroName == "Nadaur" ) or ( HeroName == "Diraya" ) then
		Loose();
	end;
end;

function LostHero2( HeroName2 )
	if ( HeroName2 == "Nemor" ) then
		startThread(attack, 1);
		StartDialogScene("/DialogScenes/C5/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep (1);
		MessageBox ("/Maps/Scenario/C5M3/C5M3_2.txt");
		sleep ( 1 );
		SetObjectiveState("harrison", OBJECTIVE_ACTIVE );
		sleep ( 2 );
		SetObjectiveState("twoheros", OBJECTIVE_ACTIVE );
		startThread(Garnison);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil );
	end;
end;

--------------------
H55_CamFixTooManySkills(PLAYER_1,"Heam");
SetObjectiveState("HeamSurvive", OBJECTIVE_ACTIVE );
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, "LostHero2" );
Trigger( PLAYER_ADD_HERO_TRIGGER, PLAYER_1,"NewHero" );
Trigger( OBJECT_CAPTURE_TRIGGER, "Siris", "SirisCapture" );
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "NewDay" );
MoveHeroRealTime("Effig", 80 , 125);
EnableHeroAI("Effig", nil);
SetPlayerResource(PLAYER_2, GOLD, 30000);

SetPlayerHeroesCountNotForHire (PLAYER_2, 6 );