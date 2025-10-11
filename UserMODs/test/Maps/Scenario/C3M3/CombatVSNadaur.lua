if IsHuman(ATTACKER) == not nil then
	print("Dinamic battle has been enabled. Human is Attacker.");
	EnableDynamicBattleMode(1);
else
	if IsHuman(DEFENDER) == not nil then
		print("Dinamic battle has been enabled. Human is Defender.");
		EnableDynamicBattleMode(1);
		else
		print("Nadaur fight vs not player hero or monster");
	end;
end;