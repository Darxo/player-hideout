::modPLHO.spawnHideout(::World.getPlayerEntity().getTile());
::modPLHO.PlayerHideout.migrateTo(::World.getPlayerEntity().getTile());


::World.Combat.abortAll();
::MSU.Log.printData(::World.Combat.m.Combats);
foreach(combat  in ::World.Combat.m.Combats) ::MSU.Log.printData(combat);
foreach(combat  in ::World.Combat.m.Combats) ::MSU.Log.printData(combat.Combatants, 2);
foreach(combat  in ::World.Combat.m.Combats) ::MSU.Log.printData(combat.Stats.Dead, 2);
foreach(combat  in ::World.Combat.m.Combats) ::MSU.Log.printData(combat.Factions, 2);

foreach(combat  in ::World.Combat.m.Combats) ::MSU.Log.printData(combat.IsResolved, 2);

abortAll()



::getBro("Helmo").m.Attributes = [];
::getBro("Helmo").fillAttributeLevelUpValues(0);
