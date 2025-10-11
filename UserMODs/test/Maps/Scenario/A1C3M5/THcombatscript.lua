EnableDynamicBattleMode( 1 );

function DefenderHeroMove( heroName )
	SetUnitManaPoints( heroName, GetUnitMaxManaPoints( heroName ) );
end;

function DefenderCreatureMove( creatureName )
	if GetCreatureType( creatureName ) == CREATURE_FLAME_MAGE then
		SetUnitManaPoints( creatureName, GetUnitMaxManaPoints( creatureName ) );
	end;
end;