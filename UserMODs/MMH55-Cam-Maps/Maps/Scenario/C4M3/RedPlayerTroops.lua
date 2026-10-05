function C4M3_AddTroops1()
	local X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Calid', CREATURE_IMP , 16*X + 8*X*dif + 25 * GetDifficulty() );
	AddObjectCreatures('Calid', CREATURE_HORNED_DEMON , 15*X + 7*X*dif + 20 * GetDifficulty() );
	AddObjectCreatures('Calid', CREATURE_CERBERI , 8*X + 4*X*dif + 15 * GetDifficulty());
	AddObjectCreatures('Calid', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif + 10 * GetDifficulty());
	AddObjectCreatures('Calid', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif + 7 * GetDifficulty() );
	AddObjectCreatures('Calid', CREATURE_ARCHDEVIL, 3 * GetDifficulty());
	local gra = GetDifficulty() + 1
	if gra > 1 then
		GiveExp("Calid", 85300); -- from 20 to 24
		ChangeHeroStat("Calid", STAT_ATTACK, GetDifficulty() * 4);
		ChangeHeroStat("Calid", STAT_DEFENCE, GetDifficulty() * 4);
		ChangeHeroStat("Calid", STAT_SPELL_POWER, GetDifficulty() * 4);
		ChangeHeroStat("Calid", STAT_KNOWLEDGE, GetDifficulty() * 4);
		GiveHeroSkill("Calid", SKILL_LUCK);
		GiveHeroSkill("Calid", SKILL_LEADERSHIP); 
		GiveHeroSkill("Calid", PERK_RESISTANCE);
		GiveHeroSkill("Calid", PERK_PRAYER); 
		sleep(10)	
		ChangeHeroStat("Calid", STAT_MANA_POINTS, 500);	
		sleep(10)	
	 end
	if gra > 2 then
		GiveExp("Calid", 176000); -- from 24 to 28
		GiveHeroSkill("Calid", DEMON_FEAT_CRITICAL_STRIKE);
		GiveHeroSkill("Calid", HERO_SKILL_STUNNING_BLOW); 
		GiveHeroSkill("Calid", KNIGHT_FEAT_STUDENT_AWARD);
		GiveHeroSkill("Calid", WARLOCK_FEAT_CHAOTIC_SPELLS);	
		sleep(10)	
		ChangeHeroStat("Calid", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
	if gra > 3 then
		GiveExp("Calid", 363000); -- from 28 to 32
		GiveHeroSkill("Calid", NECROMANCER_FEAT_DEATH_TREAD);
		GiveHeroSkill("Calid", WARLOCK_FEAT_FAST_AND_FURIOUS); 
		GiveHeroSkill("Calid", HERO_SKILL_QUICKNESS_OF_MIND);
		GiveHeroSkill("Calid", WARLOCK_FEAT_POWER_OF_HASTE);	
		sleep(10)	
		ChangeHeroStat("Calid", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
end

function C4M3_AddTroops2()
	local X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Deleb', CREATURE_IMP , 16*X + 8*X*dif + 60 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_HORNED_DEMON , 15*X + 7*X*dif + 50 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_CERBERI , 8*X + 4*X*dif + 40 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif + 30 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif + 20 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_BALOR , 2*X + 1*X*dif + 12 * GetDifficulty());
	AddObjectCreatures('Deleb', CREATURE_ARCHDEVIL, 8 * GetDifficulty());	
	local del = GetDifficulty() + 1
	if del > 1 then
		GiveExp("Deleb", 176000); -- from 24 to 28
		ChangeHeroStat("Deleb", STAT_ATTACK, GetDifficulty() * 4);
		ChangeHeroStat("Deleb", STAT_DEFENCE, GetDifficulty() * 4);
		ChangeHeroStat("Deleb", STAT_SPELL_POWER, GetDifficulty() * 4);
		ChangeHeroStat("Deleb", STAT_KNOWLEDGE, GetDifficulty() * 4);
		GiveHeroSkill("Deleb", SKILL_LUCK);
		GiveHeroSkill("Deleb", SKILL_SORCERY); 
		GiveHeroSkill("Deleb", SKILL_DEFENCE);
		GiveHeroSkill("Deleb", PERK_PROTECTION); 
		sleep(10)	
		ChangeHeroStat("Deleb", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
	if del > 2 then
		GiveExp("Deleb", 363000); -- from 28 to 32
		GiveHeroSkill("Deleb", HERO_SKILL_DWARVEN_LUCK);
		GiveHeroSkill("Deleb", RANGER_FEAT_INSIGHTS); 
		GiveHeroSkill("Deleb", PERK_EVASION);
		GiveHeroSkill("Deleb", WARLOCK_FEAT_CHAOTIC_SPELLS);	
		sleep(10)	
		ChangeHeroStat("Deleb", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
	if del > 3 then
		GiveExp("Deleb", 744000); -- from 32 to 36
		GiveHeroSkill("Deleb", RANGER_FEAT_SOIL_BURN);
		GiveHeroSkill("Deleb", HERO_SKILL_QUICKNESS_OF_MIND); 
		GiveHeroSkill("Deleb", PERK_INTELLIGENCE);
		GiveHeroSkill("Deleb", RANGER_FEAT_ELVEN_LUCK);	
		sleep(10)	
		ChangeHeroStat("Deleb", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
end

function C4M3_AddTroops3()
	local X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
	AddObjectCreatures('Efion', CREATURE_IMP , 16*X + 8*X*dif + 150 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_HORNED_DEMON , 15*X + 7*X*dif + 125 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_CERBERI , 8*X + 4*X*dif + 100 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif + 75 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif + 50 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_BALOR , 2*X + 1*X*dif + 30 * GetDifficulty());
	AddObjectCreatures('Efion', CREATURE_ARCHDEVIL , 1*X + 1*X*dif + 18 * GetDifficulty());
	local efi = GetDifficulty() + 1
	if efi > 1 then
		GiveExp("Efion", 363000); -- from 28 to 32
		ChangeHeroStat("Efion", STAT_ATTACK, GetDifficulty() * 4);
		ChangeHeroStat("Efion", STAT_DEFENCE, GetDifficulty() * 4);
		ChangeHeroStat("Efion", STAT_SPELL_POWER, GetDifficulty() * 4);
		ChangeHeroStat("Efion", STAT_KNOWLEDGE, GetDifficulty() * 4);
		GiveHeroSkill("Efion", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC);
		GiveHeroSkill("Efion", HERO_SKILL_CORRUPT_DESTRUCTIVE); 
		GiveHeroSkill("Efion", HERO_SKILL_SHATTER_DARK_MAGIC);
		GiveHeroSkill("Efion", HERO_SKILL_CORRUPT_DARK); 
		sleep(10)	
		ChangeHeroStat("Efion", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
	if efi > 2 then
		GiveExp("Efion", 744000); -- from 32 to 36
		GiveHeroSkill("Efion", RANGER_FEAT_SUN_FIRE);
		GiveHeroSkill("Efion", WIZARD_FEAT_SEAL_OF_PROTECTION); -- vial of lifeblood
		GiveHeroSkill("Efion", PERK_INTELLIGENCE);
		GiveHeroSkill("Efion", WARLOCK_FEAT_CHAOTIC_SPELLS);	
		sleep(10)	
		ChangeHeroStat("Efion", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end
	if efi > 3 then
		GiveExp("Efion", 1550000); -- from 36 to 40
		GiveHeroSkill("Efion", KNIGHT_FEAT_ANCIENT_SMITHY);
		GiveHeroSkill("Efion", WIZARD_FEAT_MAGIC_CUSHION); -- protection - shatter dark magic
		GiveHeroSkill("Efion", HERO_SKILL_QUICKNESS_OF_MIND);
		GiveHeroSkill("Efion", KNIGHT_FEAT_STUDENT_AWARD);	
		sleep(10)	
		ChangeHeroStat("Efion", STAT_MANA_POINTS, 500);	
		sleep(10)	
	end  
end
