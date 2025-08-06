Great_Army = 150 + GetDifficulty()*100;
--print (Great_Army);

SetGameVar('WasMageCombat', 'nil');


BorderNotSeen = not nil;
Hero_at_the_Gate_of_Utopia = nil;


function SetWizCombatScript (newHero)
	SetHeroCombatScript (newHero, "/Maps/SingleMissions/SM3/WizardHeroScript.xdb#xpointer(/Script)");
	print ("Hero script added to", newHero);
end;

function CheckWizardCombat1( loser, winner )
	if loser == "Godric" then return end
	if IsObjectExists( winner ) and GetObjectOwner( winner ) == PLAYER_2 then
		sleep(5);
		StartDialogScene("/DialogScenes/Single/SM3/R3/DialogScene.xdb#xpointer(/DialogScene)", "LooseOnWizardCombat" );
	end
end

function CheckWizardCombat2( loser, winner )
	if IsObjectExists( winner ) and GetObjectOwner( winner ) == PLAYER_1 then
		sleep(5);
		StartDialogScene("/DialogScenes/Single/SM3/R3/DialogScene.xdb#xpointer(/DialogScene)", "LooseOnWizardCombat" );
	end
end

function LooseOnWizardCombat()
	SetObjectiveState('Prim2',OBJECTIVE_FAILED);
	Loose();
end	

----------------------------------------BORDER SCRIPT -----------------
function See_Border ()
while 1 do
	if (IsObjectVisible(PLAYER_1, 'CentralBorder')) and BorderNotSeen then
		StartDialogScene("/DialogScenes/Single/SM3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState('Sec1',OBJECTIVE_ACTIVE);
		BorderNotSeen = nil;
		break;
	end;	
sleep();
end
end;

Trigger (OBJECT_CAPTURE_TRIGGER,'CentralBorder', 'BorderCaptured');
function BorderCaptured (OldOwner, NewOwner)
	if OldOwner == PLAYER_2 and NewOwner == PLAYER_1 then SetGameVar('WasMageCombat', 'true'); end;
end;

Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Central_Border_Left', 'ScareThem');

--GetPlayerHeroes(playerID);


function ScareThem (Hero_at_the_Gate)
 local TotalArmy=0;
 for i = CREATURE_PEASANT,(CREATURES_COUNT-1),1 do
    TotalArmy = TotalArmy +  GetHeroCreatures (Hero_at_the_Gate, i);
 end

 if TotalArmy > Great_Army  then
	RemoveObjectCreatures('CentralBorder', CREATURE_GREMLIN, 1000);
	RemoveObjectCreatures('CentralBorder', CREATURE_MASTER_GREMLIN, 1000);
	RemoveObjectCreatures('CentralBorder', CREATURE_MAGI, 1000);
	SetObjectOwner('CentralBorder', PLAYER_NONE);
	sleep (4);
	MessageBox ("/Maps/SingleMissions/SM3/Garnison_in_fear.txt");
	ChangeHeroStat("Godric", STAT_EXPERIENCE, 1546);
	SetObjectiveState('Sec1',OBJECTIVE_COMPLETED);
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'Central_Border_Left', nil);
   else MessageBox ("/Maps/SingleMissions/SM3/Garnison_no_fear.txt"); end;

end;


---- TOWN CAPTURING TRIGGERS ----
Trigger(OBJECT_CAPTURE_TRIGGER, 'Town1Human', 'Town1Captured');
Trigger(OBJECT_CAPTURE_TRIGGER, 'Town2Wizard', 'Town2Captured');
Trigger(OBJECT_CAPTURE_TRIGGER, 'Town3Wizard', 'Town3Captured');
Trigger(OBJECT_CAPTURE_TRIGGER, 'Town4Random', 'Town4Captured');

function Town1Captured (oldOwner, newOwner)
	if (oldOwner == PLAYER_2)	and (newOwner == PLAYER_1) then SetGameVar('WasMageCombat', 'true'); end;
end;
function Town2Captured ()
	SetGameVar('WasMageCombat', 'not nil');
end;
function Town3Captured (oldOwner, newOwner)
	if (oldOwner == PLAYER_2) and (newOwner == PLAYER_1) then SetGameVar('WasMageCombat', 'true'); end;
end;
function Town4Captured (oldOwner, newOwner)
	if (oldOwner == PLAYER_2)	and (newOwner == PLAYER_1) then SetGameVar('WasMageCombat', 'true'); end;
end;

--------------------------ARTIFACT FOUND--------------------------------------
Trigger (OBJECT_TOUCH_TRIGGER, 'Utopia', 'UtopiaVisit');
SetObjectEnabled ('Utopia', nil);

function UtopiaVisit (heroname)
	Hero_at_the_Gate_of_Utopia = heroname;
	QuestionBox("/Maps/SingleMissions/SM3/Utopia.txt", 'DragonCombat');
end;


function DragonCombat ()
	DragonNumber = 6+6*GetDifficulty();
	StartCombat (Hero_at_the_Gate_of_Utopia, nil, 3, CREATURE_BLACK_DRAGON, DragonNumber, CREATURE_BLACK_DRAGON,DragonNumber*3, CREATURE_BLACK_DRAGON, DragonNumber);
	sleep (4);
	if IsHeroAlive (Hero_at_the_Gate_of_Utopia) then
        GiveArtefact (Hero_at_the_Gate_of_Utopia, ARTIFACT_PEDANT_OF_MASTERY);
--		SetObjectiveState ('Prim1Artifact', OBJECTIVE_COMPLETED);
		print("we got artifact, wee");
		StartDialogScene("/DialogScenes/Single/SM3/R4/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState ('Prim1', OBJECTIVE_COMPLETED);
		Trigger (OBJECT_TOUCH_TRIGGER, 'Utopia', nil);
	end;
	
end;


----is hero alive----


function objective3()
        if GetObjectiveState("Prim3") == OBJECTIVE_UNKNOWN then
                SetObjectiveState('Prim3',OBJECTIVE_ACTIVE);
        else
                print("Warning!!! prim3 is not UNKNOWN");
        end;
while 1 do
        if IsHeroAlive("Godric")==nil then
                print("Godric is dead!!!");
                if GetObjectiveState("Prim3") == OBJECTIVE_ACTIVE or GetObjectiveState("Prim3") == OBJECTIVE_COMPLETED then
                        SetObjectiveState("Prim3",OBJECTIVE_FAILED);
                else
                        print("Warning!!! prim3 is not ACTIVE or COMPLETED");
                end;
                return 1;
        end;
        if GetObjectiveState("Prim1") == OBJECTIVE_COMPLETED then
                if GetObjectiveState("Prim3") == OBJECTIVE_ACTIVE  then
                        SetObjectiveState('Prim3',OBJECTIVE_COMPLETED);
                else
                        print("Warning!!! prim3 is not ACTIVE");
                end;
                return 1;
        end;
sleep();
end;
end;

function Seer()
--MoveCamera(86, 20, 1);
OpenCircleFog(86, 20, 1, 15, PLAYER_1);
end


-----------------------------------------------------------------------------
--------------------------MAIN PHASE---------------------------

--SetObjectiveState('Prim1',OBJECTIVE_ACTIVE);
StartDialogScene("/DialogScenes/Single/SM3/R1/DialogScene.xdb#xpointer(/DialogScene)");
SetRegionBlocked("Central_Border_Right", not nil, PLAYER_2);
SetRegionBlocked("Central_Border_Left_Block", not nil, PLAYER_3);
SetRegionBlocked("TeleportGuards",not nil,PLAYER_3);
SetRegionBlocked("TeleportGuards",not nil,PLAYER_2);
--Trigger (PLAYER_ADD_HERO_TRIGGER, PLAYER_2, "SetWizCombatScript");
Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "CheckWizardCombat1");
Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "CheckWizardCombat2");
startThread( objective3 );
startThread( See_Border );
--startThread( Check_AttackWizard );


-- while 1 do
 -- See_Border ();
 -- Check_AttackWizard ();
 -- print (GetGameVar('WasMageCombat'));
 -- sleep (5);
-- end;