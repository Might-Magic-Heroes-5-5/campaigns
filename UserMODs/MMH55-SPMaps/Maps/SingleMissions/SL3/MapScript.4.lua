HERO_NAME = "Ossir";
CurrentSign = 2;
NumberOfLastSign = 10;
BaseSignPath = "Maps/SingleMissions/SL3/Text/not nilsign";
FinalMessage = "/Maps/SingleMissions/SL3/Text/finalsign1.txt";
BaseDialogFull = "/DialogScenes/Single/SL3/R3/DialogScene.xdb#xpointer(/DialogScene)";
BaseDialogPart1 = "/DialogScenes/Single/SL3/R"
BaseDialogPart2 = "/DialogScene.xdb#xpointer(/DialogScene)"
FinalDialog = "/DialogScenes/Single/SL3/R12/DialogScene.xdb#xpointer(/DialogScene)";
FinalProgressMdf = -1;
NotReadEndSign = not nil;
NotReadFirstSign = not nil;

StartDialogScene("/DialogScenes/Single/SL3/R1/DialogScene.xdb#xpointer(/DialogScene)")  ----Сцена стартовая

Trigger (OBJECT_TOUCH_TRIGGER, 'sign1','FirstSign');
SetObjectEnabled('sign1', nil);

function FirstSign (ReadingHero)
 if NotReadFirstSign then
	MessageBox ("/Maps/SingleMissions/SL3/Text/not nilsign1.txt");
	print ('there will be a message box with hero replic');
	Trigger (OBJECT_TOUCH_TRIGGER, 'sign2','TrueSign');
	SetObjectEnabled('sign2', nil);
	ChangeHeroStat(HERO_NAME, STAT_EXPERIENCE, 500);

	-- Trigger (OBJECT_TOUCH_TRIGGER, 'sign1',nil);

	sleep (4);
	SetObjectiveState('Sec1', OBJECTIVE_ACTIVE);
	StartDialogScene("/DialogScenes/Single/SL3/R3/DialogScene.xdb#xpointer(/DialogScene)")  ----1 подсказка!!!!!!!
	NotReadFirstSign = nil;
 else MessageBox ("/Maps/SingleMissions/SL3/Text/not nilsign1.txt"); end;
end;

function TrueSign (ReadingHero)
  print ("Current Sign - ", CurrentSign);

  CURRENTREGION = "Sign_Region_"..CurrentSign;

  if IsObjectInRegion (ReadingHero, CURRENTREGION) then
	print ('New sign - ', CurrentSign);
    -- HERO ACTIVATE TRUE SIGN THAT WAS NOT ACTIVE BEFORE
	SIGNPATH = BaseSignPath..CurrentSign..".txt";
	LASTSIGN = "sign"..(CurrentSign-1);
	NEWSIGN = "sign"..(CurrentSign+1);
	SIGN = "sign"..CurrentSign;

	--ShowFlyMessage(SIGNPATH, SIGN, PLAYER_1, 1,5);
	SetObjectiveProgress('Sec1', CurrentSign-1, PLAYER_1);
	ChangeHeroStat(HERO_NAME, STAT_EXPERIENCE, 500*CurrentSign);

	MessageBox (SIGNPATH);
	if (CurrentSign < NumberOfLastSign-1) then
	    Trigger (OBJECT_TOUCH_TRIGGER, NEWSIGN, 'TrueSign');
	    SetObjectEnabled(NEWSIGN, nil);
	
	else
	    Trigger (OBJECT_TOUCH_TRIGGER, NEWSIGN, 'EndSign');
            SetObjectEnabled(NEWSIGN, nil);
	end;
	if ReadingHero == HERO_NAME then
		BaseDialogFull = BaseDialogPart1..CurrentSign+2
		BaseDialogFull = BaseDialogFull..BaseDialogPart2
		StartDialogScene(BaseDialogFull);
	end;
	
	Trigger (OBJECT_TOUCH_TRIGGER, LASTSIGN, nil);
	SetObjectEnabled(LASTSIGN, not nil);

	CurrentSign = CurrentSign+1;
			
	sleep (9);
	
  else
	-- HERO ACTIVATE TRUE SIGN THAT WAS ALREADY ACTIVE
      	print ('This sign have alredy been activated');
	SIGN = "sign"..(CurrentSign-1);
	--ShowFlyMessage(SIGNPATH, SIGN, PLAYER_1, 1.5);
	MessageBox (SIGNPATH);
  end;

end;

function EndSign (ReadingHero)
	print ('Youve found a Hollly Grreyl..');
	if NotReadEndSign then
--		SetObjectiveState('Sec1', OBJECTIVE_COMPLETED);   ----------!!!!!!!!!!TEST
		print ('Sec1 OBJECTIVE_COMPLETED!!!!');
		MessageBox (FinalMessage);
		CurrentProgress = CurrentSign+FinalProgressMdf;
		SetObjectiveProgress('Sec1', CurrentProgress , PLAYER_1);
		NotReadEndSign = nil;
		if ReadingHero == HERO_NAME then StartDialogScene(FinalDialog); end;
	else
		print ('Youve found a Hollly Grreyl.. -- and already read about it');
		MessageBox (FinalMessage);
	end;
end;
--------------------------------------test!!!
---StoreTheGraal ();
function StoreTheGraal ()
	print ('Store the Grail');
	local x1,y1,l1 = 35,20,0
	local x2,y2,l2 = 60,82,1
	local x3,y3,l3 = 106,101,0
	local x,y,l = GetObjectPosition("grail");
	if x == x1 and y == y1 and l == l1 then
		print ('Check graal_....1');
		FinalMessage = "/Maps/SingleMissions/SL3/Text/finalsign1.txt";		
		FinalProgressMdf = -1;
	elseif x == x2 and y == y2 and l == l2 then
		print ('Check graal_....2');
		FinalMessage = "/Maps/SingleMissions/SL3/Text/finalsign2.txt";
		FinalProgressMdf = 0;
		FinalDialog = "/DialogScenes/Single/SL3/R13/DialogScene.xdb#xpointer(/DialogScene)";
	else
		print ('Check graal_....3');
		FinalMessage = "/Maps/SingleMissions/SL3/Text/finalsign3.txt";
		FinalProgressMdf = 1;
		FinalDialog = "/DialogScenes/Single/SL3/R14/DialogScene.xdb#xpointer(/DialogScene)";
	end;
end;

startThread(StoreTheGraal );
----------------------------------/////////
function Prim1_complit()
	while 1 do
		sleep(10);
		if IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) then
			StartDialogScene("/DialogScenes/Single/SL3/R2/DialogScene.xdb#xpointer(/DialogScene)")  ----Сцена финальная
			SetObjectiveState('Prim1',OBJECTIVE_COMPLETED);
			sleep(10);
			Win();
			break;
		end;
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
----------------------------------///Предупреждение игроку о первом сигнпосте
function stopss()
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Warning", nil );
MessageBox ("/Maps/SingleMissions/SL3/Text/stops.txt");
end;
----------------------------------///
startThread(Prim1_complit );


Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Warning","stopss", nil );