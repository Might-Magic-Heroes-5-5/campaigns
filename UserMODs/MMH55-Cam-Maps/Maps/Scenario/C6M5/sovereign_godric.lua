print("sovereign vs godric");
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


-- monsters: summon 2 arch devils near player, infernal succubes and alot of imps far

function Prepare()
    EnableCinematicCamera(nil);
    sleep(15);
end

function Start()
    EnableAutoFinish(nil);
    sleep(20);
    SummonCreature(DEFENDER, 28, 2 + d * 5, 12, 3);
    sleep(20);
    SummonCreature(DEFENDER, 28, 2 + d * 5, 12, 12);
    sleep(20);
    SummonCreature(DEFENDER, 28, 2 + d * 5, 12, 8);
    sleep(20);


    SummonCreature(DEFENDER, 23, 35 + d * 5, 13, 5);
    sleep(20);
    SummonCreature(DEFENDER, 22, 25 + d * 5, 13, 10);
    sleep(20);
    EnableCinematicCamera(not nil);
end

sovereign = 0
function DefenderHeroMove(heroName)
    UnitCastGlobalSpell(GetDefenderHero(), 239);
    SummonCreature(DEFENDER, 23, 10 + d * 5, 13, 8);
    return not nil
end

function ms(heroName)
    UnitCastGlobalSpell(GetDefenderHero(), 239);
    --return not nil
end

function AttackerCreatureDeath()
    local attackers = GetAttackerCreatures();
    if (table.length(attackers) == 0) then Finish(DEFENDER) end;
end
