::modPLHO <- {
	ID = "mod_PLHO",
	Name = "Player Hideout",
	Version = "0.1.0",

	// Global variables
	PlayerHideout = null,	// This is not reset in between different savegames! That's why we use an additional global Flag
	RosterScreen = ::new("scripts/ui/screens/world/troop_manager_screen")
}

::mods_registerMod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

::mods_queue(::modPLHO.ID, "mod_msu, mod_TQUA, mod_VABU", function()
{
	::modPLHO.Mod <- ::MSU.Class.Mod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

	::MSU.UI.registerConnection(::modPLHO.RosterScreen);

	::include("mod_PLHO/msu_settings");
	::includeFiles(::IO.enumerateFiles("mod_PLHO/hooks"));		// This will load and execute all hooks that you created

	::modPLHO.getMigrationString <- function( _target )
	{
		local seconds = ::modPLHO.getMigrateDuration(_target);
		return "Days: " + ::Math.max(0, ::Math.floor(seconds / ::World.getTime().SecondsPerDay)) + " - Hours: " + ::Math.max(0, ::Math.floor(seconds / ::World.getTime().SecondsPerHour)) % 24;
	}

	::modPLHO.getMigrateDuration <- function( _target )
	{
		local distance = ::modPLHO.PlayerHideout.getTile().getDistanceTo(_target.getTile());
		local speed = ::Const.World.MovementSettings.GlobalMult * ::Const.World.MovementSettings.Speed;
		return (distance * 170.0 / speed);
	}

	::modPLHO.spawnHideout <- function( _location )
	{
		::logWarning("creating Hideout");
		local hideout = ::World.spawnLocation("scripts/entity/world/settlements/player_hideout", _location.getTile().Coords);
		hideout.takeOver(_location);
	}

	::modPLHO.spawnHideoutAtTile <- function( _tile )
	{
		if (_tile.IsOccupied) return;
		::logWarning("creating Hideout");
		local hideout = ::World.spawnLocation("scripts/entity/world/settlements/player_hideout", _tile.Coords);
		::modPLHO.PlayerHideout = hideout;
	}
});

// Checklist:
// - replace all instances of "MODID" with your modid in uppercase letter. Within all files, aswell as for folder/file naming
// - replace the value of 'Name' with your written out mod name separated with spacebars
// - 'Version' can probably stay at 0.1.0 for your first version/release
// - if you don't use hooks, remove the hooks folder and the above ::includeFiles line
