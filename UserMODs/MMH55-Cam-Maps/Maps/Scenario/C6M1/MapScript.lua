H55_PlayerStatus = {0,1,2,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M1");
	ChangeHeroStat("Zehir",STAT_SPELL_POWER,2);
end;

startThread(H55_InitSetArtifacts);

C6M1_R1 = 0;

function messages( dialog )
	if dialog == 1 then
		C6M1_R1 = 1;
		sleep();
		StartDialogScene("/DialogScenes/C6/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
end;

function ZehirGettingLevel()
	while 1 do
			if GetHeroLevel("Zehir") == 10 then
			SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
			StartDialogScene("/DialogScenes/C6/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
			break;
			end
		sleep (10);
	end
end

function InsariusCaptured()
	if GetObjectOwner("insarius") == PLAYER_1 then
		ChangeHeroStat("Zehir", STAT_EXPERIENCE, 546);
		SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
		SetRegionBlocked('exit', true, PLAYER_2)		
	end
	if C6M1_R1 == 0 then
		messages( 1 );
	end;
	if GetObjectOwner("insarius") == PLAYER_2 then
		SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
	end
	
end
	
function Insarius()
		if GetObjectiveState("prim1") == OBJECTIVE_UNKNOWN then
                SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
        else
                print("Warning!!! prim1 is not UNKNOWN");
        end;
end


function prim2()
	while 1 do
	        if IsHeroAlive("Zehir")==nil then
	            SetObjectiveState("prim2",OBJECTIVE_FAILED);
	            return 1;
	        end;
	sleep();
	end;
end

	
function WinLoose()
	while 1 do
		if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Zehir", "C6M1");
			sleep(5);
			Win();
			return
		end;
		if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED or
			GetObjectiveState("prim3") == OBJECTIVE_FAILED then
			sleep(40);
			Loose();
			return
		end;
		sleep();
	end;
end;

function stat()
ChangeHeroStat("Zehir", STAT_EXPERIENCE, 7000);
end

------
--ChangeHeroStat("Zehir",STAT_SPELL_POWER,2);
StartDialogScene("/DialogScenes/C6/M1/D1/DialogScene.xdb#xpointer(/DialogScene)")
SetRegionBlocked('noway1', true, PLAYER_2);
SetRegionBlocked('noway2', true, PLAYER_2);
SetRegionBlocked('block', true, PLAYER_2);
--EnableHeroAI("Pelt", nil);
--Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "prim3", "ZehirGotLevel")
Trigger(OBJECT_CAPTURE_TRIGGER, "insarius", "InsariusCaptured")
startThread( prim2 );
startThread( WinLoose );
startThread( ZehirGettingLevel );
