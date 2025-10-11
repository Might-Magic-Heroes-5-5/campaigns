--SummonCreature(side, type, number, x = -1, y = -1);

----- Monsters: Infernal Succubus and Imps -----

-- function Prepare()
	-- diff = GetDifficulty();
    -- EnableCinematicCamera(nil);
    -- sleep(10);
    -- SummonCreature(DEFENDER, 16, 47 + diff * 5, 12, 3);
    -- sleep(10);
    -- SummonCreature(DEFENDER, 16, 47 + diff * 5, 12, 10);
    -- sleep(10);
    -- SummonCreature(DEFENDER, 16, 47 + diff * 5, 12, 8);
    -- sleep(10);

-- end;

function Start()
	diff = GetDifficulty();
    EnableAutoFinish(nil);
    SummonCreature(DEFENDER, 16, 15 + diff * 5, 13, 5);
    sleep(2);
    SummonCreature(DEFENDER, 16, 15 + diff * 5, 13, 10);
    sleep(5);
    EnableCinematicCamera(not nil);
end;
GetDiffculty