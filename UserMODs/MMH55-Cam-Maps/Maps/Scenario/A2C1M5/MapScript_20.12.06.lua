sleep (40)
OpenCircleFog(158, 156, 0, 15, 1);
sleep(2);
MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);
sleep(2);
PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
sleep(16);
SetAmbientLight(0, "Daylight", not nil, 1);
