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

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C5M2");
    LoadHeroAllSetArtifacts("Heam", "C5M1" );
end;

startThread(H55_InitSetArtifacts);

obelisks={'o1','o2','o3','o4','o5','o6','o7'} --������ ���� ��������� ������������ �������������� ��������
xregions={88,114,76,86,46,16,28}
yregions={87,70,105,57,82,69,111}
blocked_regions={'rb1','rb2','rb3','rb4','rb5','rb6','rb7'}
dragons={'d1','d2','d3','d4','d5','d6','d7'}
inferno_towns={'1','2','3'}
message11='/Maps/Scenario/C5M2/objectives/messages/message11.txt'
message12='/Maps/Scenario/C5M2/objectives/messages/message12.txt'
message13='/Maps/Scenario/C5M2/objectives/messages/message13.txt'
message21='/Maps/Scenario/C5M2/objectives/messages/message21.txt'
a={} --��������� ������
b={} --��������� ������
c={} --��������� ������
knowlege=0 --������ ������� �������� ������ ���������, 1 -��, 0-���.
n = 7;
m = 1;
weekun = 28;
IsDragonsAssemled = 0;
IsTownCaptured = 0;

if GetDifficulty() == DIFFICULTY_EASY then
	weekun = 36;
	print (weekun);
	AddObjectCreatures("Heam", CREATURE_GRAND_ELF, 20);
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	weekun = 28;
	print (weekun);
end;
if GetDifficulty() == DIFFICULTY_HARD then
	weekun = 14;
	print (weekun);
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	weekun = 2;
	print (weekun);
end;

function block() ---������� ������� ��� ������ �� ������ ���� ��� ����������� ������� 
	SetRegionBlocked("block", 1, 2);
	for i,h in blocked_regions do
		SetRegionBlocked(blocked_regions[i], 1, 2);
		print('region ',blocked_regions[i],' blocked')
	end
end	

function obelisks_upgrade() --�������� �����-������� ���������������� ��������� � ��������� �������
	for i,h in obelisks do
		SetObjectEnabled(obelisks[i], nil);
		Trigger(OBJECT_TOUCH_TRIGGER,obelisks[i], 'new_obelisks_mechanic')
		print('obelisk ',obelisks[i],' upgraded')
	end
end

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == "Heam" ) then
		SetObjectiveState("prim3", OBJECTIVE_FAILED);
		sleep (15);
		Loose();
	end;
end;

function new_obelisks_mechanic(hero_name)
	local d_name --
	local x,y,z --���������� ����� � ������� ����������� ����
	local obelisk --��� ����������� ��������
	local j=1
	local region
	print("hero_name=",hero_name);
	print('knowlege=',knowlege)
	if knowlege==0 --����� �� ����� ��� �������� ��������
		then
			MessageBox(message11) --��� ��� ��� ������ �� ���������� ������ ��� �� �� ������ ��� ��� �� �����
			return --������ ��� �� ���������� � ��� ��� ������� �������� ��������
		else
			obelisk=obelisk_touch(hero_name) --����� ������� ��������
			for i,h in obelisks do
				if obelisk==obelisks[i] 
					then
						MessageBox(message12) --��� ��� ��� ��� ��������� �������������� ����� ������ ��������
						MarkObjectAsVisited (obelisk, hero_name);
						d_name=random(n)+1;n=n-1;print('d_name=',d_name); x=xregions[d_name]; y=yregions[d_name]; z=0; --� ����� ������� ������� ��������
						CreateMob(dragons[j], 56, 3, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --������� 3 �������� � ��������� �������
						MoveCamera(x, y, z, 50, 1.57);
						xregions=remove_element(x,xregions);
						yregions=remove_element(y,yregions);
						obelisks=remove_element(obelisk,obelisks)
						OpenCircleFog(x,y,z,7,1)
						--JoinMob(dragons[1],1)
						dragons=remove_element(dragons[j],dragons)
						--dragons[j]=nil
						--regions[i]=nil
						--obelisks[i]=nil
						return
					else
				end
			end
	end
	MessageBox(message13) --��� ��� ��� ������ �� ���������� ������ ��� �� ����� ����
end;

function remove_element(element_name,array_name) --������� ��� �������� �������� �� ������� (array_name-��� �������,element_name-��� ��������)
	local j=1 --������ ���������� �������
	local a={}
	for i, h in array_name do
		print(array_name[i],'',element_name)
		if array_name[i] ~= element_name
			then
				a[j]=array_name[i];
				j=j+1;
				print('a[j]=',array_name[i])
			else
				print('removed element=',array_name[i])
		end;
	end;
	array_name={}
	array_name=a
	return array_name
end

function obelisk_touch(toucher)
	local x,y,z --���������� ��������
	local xh,yh,zh --���������� ����� ��������������� �������
	local m
	xh,yh,zh=GetObjectPos(toucher);
	print('x=',xh,'y=',yh,'z=',zh)
	for i,h in obelisks do
		x,y,z=GetObjectPos(obelisks[i]);
		if zh==z and xh>=x-1 and xh<=x+1 and yh>=y-1 and yh<=y+1 --���������� ������� ����� � ������� ����� �����
			then 
				print('active obelisk=',obelisks[i]) --��� ��������
				return obelisks[i]
			else
				print('this obelisk was used before')
		end
	end
end
	
function town_capture(p1,p2,hero) --����������� ��� ������� ������ ������������� ������
	StartDialogScene('/DialogScenes/C5/M2/R1/DialogScene.xdb#xpointer(/DialogScene)');
	AddHeroCreatures(hero, 56 , 1);
	knowlege=1 --����� ������ �� ������� ��� ����� ��������
	print('knowlege=',knowlege)
	SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
	for i,h in inferno_towns do --������� �������� �� ���� ������������ �������
		Trigger(OBJECT_CAPTURE_TRIGGER, inferno_towns[i], nil)
	end 
end

function objective_2()
	for i,h in inferno_towns do
		Trigger(OBJECT_CAPTURE_TRIGGER, inferno_towns[i], 'town_capture')
	end
end 

function objective_3() 
	local prim1, prim2
	while 1 do
		sleep ( 10 );
		prim1=GetObjectiveState('prim1');
		prim2=GetObjectiveState('prim2');
		if prim1==OBJECTIVE_COMPLETED and prim2==OBJECTIVE_COMPLETED and IsDragonsAssemled == 1 and IsTownCaptured == 1 then
			SaveHeroAllSetArtifactsEquipped("Heam", "C5M2");
			SetObjectiveState('prim3', OBJECTIVE_COMPLETED);
			sleep ( 20 );
			Win();
			break;
		end;
	end	
end

function dragons_assembled()
	local prim1
	prim1=GetObjectiveState('prim1');
	if prim1==OBJECTIVE_COMPLETED	then
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER,'prim1', nil);
		StartDialogScene('/DialogScenes/C5/M2/R2/DialogScene.xdb#xpointer(/DialogScene)', "video_dragons_assembled");
		sleep (2);
		LevelUpHero("Heam");
	end	
end

function video_dragons_assembled()
	IsDragonsAssemled = 1;
end;

function towns_captured()
	local prim2
	prim2=GetObjectiveState('prim2');
	if prim2==OBJECTIVE_COMPLETED then
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER,'prim2', nil);
		StartDialogScene('/DialogScenes/C5/M2/R3/DialogScene.xdb#xpointer(/DialogScene)', "video_towns_captured");
		SetTownBuildingLimitLevel('player_town', 13, 2);
		AddHeroCreatures("Heam", 56 ,5);
	end;
end;

function video_towns_captured()
	IsTownCaptured = 1;
end;

function H55_TriggerDaily()
	if GetDate(DAY)>weekun then
		H55_NewDayTrigger = 0;
		SetRegionBlocked("block", nil, 2);
		print ("unblock");
	end;
end;

---script---
H55_CamFixTooManySkills(PLAYER_1,"Heam");
startThread(block)
StartDialogScene('/DialogScenes/C5/M2/D1/DialogScene.xdb#xpointer(/DialogScene)');
objective_2()
obelisks_upgrade()
startThread(objective_3)
Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER,'prim1', 'dragons_assembled');
Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER,'prim2', 'towns_captured');
H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER,'unblock');
SetTownBuildingLimitLevel('player_town', 13, 0);
sleep(5);
SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
SetObjectiveState('prim3', OBJECTIVE_ACTIVE);