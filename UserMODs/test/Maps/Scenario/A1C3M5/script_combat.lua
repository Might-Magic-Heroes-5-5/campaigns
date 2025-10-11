function Start()
	diff = GetGameVar( "temp.difficulty" );
	diff = diff + 0;
	if diff == 2 then
		num = 1000;
	elseif diff == 3;
		num = 2000;
	end;
	if diff >= 2 then
		for i = 1, 10 do
			AddCreature( DEFENDER, CREATURE_LANDLORD, num, 10, i );
		end;
	end;
end;