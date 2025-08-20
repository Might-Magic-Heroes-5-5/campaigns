function SetMissionDifficulty()
    state = GetDifficulty();

   if state == DIFFICULTY_EASY then
    print("easy");
    dif = 0;
    exp = GetHeroStat("Raelag", STAT_EXPERIENCE)/4;
    for i,h in dang_array do
      ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
    end;
    for a = 0,6 do
      SetPlayerResource(PLAYER_2, a, 0);
      SetPlayerResource(PLAYER_3, a, 0);
    end;
    AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 50);
    AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 30);
    AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 5);
  end;

  if state == DIFFICULTY_NORMAL then
    print("normal");
    dif = 0;
    exp = GetHeroStat("Raelag", STAT_EXPERIENCE)/2;
    for i,h in dang_array do
      ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
    end;
    for a = 0,6 do
      SetPlayerResource(PLAYER_2, a, 0);
      SetPlayerResource(PLAYER_3, a, 0);
    end;
  end;

  if state == DIFFICULTY_HARD then
    print("Hard");
    dif = 1;
    exp = GetHeroStat("Raelag", STAT_EXPERIENCE);
    for i,h in dang_array do
      ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
      AddObjectCreatures(dang_array[i], CREATURE_ASSASSIN , 30);
      AddObjectCreatures(dang_array[i], CREATURE_BLOOD_WITCH , 20);
      SetTownBuildingLimitLevel('Town3', 13, 1);
    end;
  end;

  if state == DIFFICULTY_HEROIC then
    print("Impossible");
    dif = 2;
    exp = GetHeroStat("Raelag", STAT_EXPERIENCE) + GetHeroStat("Kelodin", STAT_EXPERIENCE);
    for i,h in dang_array do
      ChangeHeroStat(dang_array[i], STAT_EXPERIENCE , exp);
      AddObjectCreatures(dang_array[i], CREATURE_ASSASSIN , 45);
      AddObjectCreatures(dang_array[i], CREATURE_BLOOD_WITCH , 30);
      AddObjectCreatures(dang_array[i], CREATURE_MINOTAUR_KING , 37);
      SetTownBuildingLimitLevel('Town3', 13, 1);
      SetTownBuildingLimitLevel('Town4', 13, 1);
    end;
  end;
  return dif;
end
