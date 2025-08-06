print("sovereign vs raelag");
d = GetDifficulty() - 1;

-- looking for dead catapult --

function FindAttackerCatapult()
            local machines = GetAttackerWarMachines()
            for index,machine in machines do
                        if GetWarMachineType(machine) == WAR_MACHINE_CATAPULT then
                                   return machine
                        end
            end
            return nil
end

catapult = FindAttackerCatapult()

function AttackerWarMachineDeath(unitName)
            if unitName == catapult then
                        Finish(DEFENDER)
            end
end

-- looking for dead shield --

shield = GetDefenderBuilding(BUILDING_MAGIC_WALL)

function DefenderBuildingDeath(buildingName)
            if buildingName == shield then
                        sleep(10);
                        Finish(ATTACKER)
            end
end


-- monsters: death knights, archdevils and infernal succubus


function Start()
    EnableCinematicCamera(nil);
    EnableAutoFinish(nil);
    sleep(20);
    SummonCreature(DEFENDER, 28, 7 + d * 5, 12, 3);
    sleep(10);
    SummonCreature(DEFENDER, 28, 7 + d * 5, 12, 12);
    sleep(10);
    SummonCreature(DEFENDER, 28, 7 + d * 5, 12, 8);
    sleep(10);


    SummonCreature(DEFENDER, 22, 35 + d * 5, 13, 5);
    sleep(10);
    SummonCreature(DEFENDER, 23, 25 + d * 5, 13, 10);
    sleep(10);
    EnableCinematicCamera(not nil);
end

sovereign = 0
function DefenderHeroMove(heroName)
    UnitCastGlobalSpell(GetDefenderHero(), 239);
    SummonCreature(DEFENDER, 23, 10 + d * 5, 13, 8);
    return not nil
end

function AttackerCreatureDeath()
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end

