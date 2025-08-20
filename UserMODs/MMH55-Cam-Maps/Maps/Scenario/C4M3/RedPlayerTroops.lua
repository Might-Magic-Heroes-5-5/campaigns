function C4M3_AddTroops1()
  ChangeHeroStat('Calid', STAT_EXPERIENCE , exp);
  X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
  AddObjectCreatures('Calid', CREATURE_IMP , 16*X + 8*X*dif);
  AddObjectCreatures('Calid', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
  AddObjectCreatures('Calid', CREATURE_CERBERI , 8*X + 4*X*dif);
  AddObjectCreatures('Calid', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
  AddObjectCreatures('Calid', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
end;

function C4M3_AddTroops2()
  exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
  ChangeHeroStat('Deleb', STAT_EXPERIENCE , exp/(3-dif));
  X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
  AddObjectCreatures('Deleb', CREATURE_IMP , 16*X + 8*X*dif);
  AddObjectCreatures('Deleb', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
  AddObjectCreatures('Deleb', CREATURE_CERBERI , 8*X + 4*X*dif);
  AddObjectCreatures('Deleb', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
  AddObjectCreatures('Deleb', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
  AddObjectCreatures('Deleb', CREATURE_BALOR , 2*X + 1*X*dif);
end;

function C4M3_AddTroops3()
  exp = GetHeroStat("Raelag", STAT_EXPERIENCE) + GetHeroStat("Kelodin", STAT_EXPERIENCE);
  ChangeHeroStat('Efion', STAT_EXPERIENCE , exp/(3-dif));
  X = (GetDate(MONTH) - 1)*4 + GetDate(WEEK);
  AddObjectCreatures('Efion', CREATURE_IMP , 16*X + 8*X*dif);
  AddObjectCreatures('Efion', CREATURE_HORNED_DEMON , 15*X + 7*X*dif);
  AddObjectCreatures('Efion', CREATURE_CERBERI , 8*X + 4*X*dif);
  AddObjectCreatures('Efion', CREATURE_INFERNAL_SUCCUBUS , 5*X + 2*X*dif);
  AddObjectCreatures('Efion', CREATURE_FRIGHTFUL_NIGHTMARE , 3*X + 1*X*dif);
  AddObjectCreatures('Efion', CREATURE_BALOR , 2*X + 1*X*dif);
  AddObjectCreatures('Efion', CREATURE_ARCHDEVIL , 1*X + 1*X*dif);
end;
