::modPLHO <- {
	ID = "mod_PLHO",
	Name = "Player Hideout",
	Version = "0.1.0",

	// Global variables
	PlayerHideout = null,	// This is not reset in between different savegames! That's why we use an additional global Flag
	RosterScreen = null
}

::mods_registerMod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

::mods_queue(::modPLHO.ID, "mod_msu, mod_TQUA, mod_VABU", function()
{
	::modPLHO.Mod <- ::MSU.Class.Mod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

	::modPLHO.RosterScreen = ::new("scripts/mods/mod_TQUA/troop_manager_screen");
	::modPLHO.RosterScreen.onCloseButtonClicked = function()	// Overwrite because we spawn that screen from within a settlement
	{
		::World.State.m.MenuStack.pop();
	}
	::MSU.UI.registerConnection(::modPLHO.RosterScreen);

	::include("mod_PLHO/msu_settings");
	foreach (file in ::IO.enumerateFiles("mod_PLHO/hooks"))
	{
		::include(file);
	}

	::modPLHO.getMigrationString <- function( _target )
	{
		local seconds = ::modPLHO.PlayerHideout.calculateMigrationTimeTo(_target);
		local previousMigrationDuration = ::modPLHO.PlayerHideout.getCurrentMigrationHours() * ::World.getTime().SecondsPerHour;
		seconds += previousMigrationDuration;
		return "Days: " + ::Math.max(0, ::Math.floor(seconds / ::World.getTime().SecondsPerDay)) + " - Hours: " + ::Math.max(0, ::Math.floor(seconds / ::World.getTime().SecondsPerHour)) % 24;
	}

	::modPLHO.spawnHideout <- function( _location )
	{
		// ::logWarning("creating Hideout");
		local hideout = ::World.spawnLocation("scripts/entity/world/settlements/player_hideout", _location.getTile().Coords);
		hideout.takeOver(_location);
	}

	::modPLHO.spawnHideoutAtTile <- function( _tile )
	{
		if (_tile.IsOccupied) return;
		// ::logWarning("creating Hideout");
		local hideout = ::World.spawnLocation("scripts/entity/world/settlements/player_hideout", _tile.Coords);
		::modPLHO.PlayerHideout = hideout;
	}
});
