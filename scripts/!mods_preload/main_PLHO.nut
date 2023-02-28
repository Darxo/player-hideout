::modPLHO <- {
	ID = "mod_PLHO",
	Name = "Player Hideout",
	Version = "0.1.0",

	// Global variables
	PlayerHideout = null,
	HideoutRosterScreen = null
}

::mods_registerMod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

::mods_queue(::modPLHO.ID, "mod_msu, mod_TQUA, mod_VABU", function()
{
	::modPLHO.Mod <- ::MSU.Class.Mod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

	::include("mod_PLHO/msu_settings");
	::includeFiles(::IO.enumerateFiles("mod_PLHO/hooks"));		// This will load and execute all hooks that you created

	::modPLHO.HideoutRosterScreen <- ::new("scripts/ui/screens/world/troop_manager_screen");
	::MSU.UI.registerConnection(::modPLHO.HideoutRosterScreen);


	::modPLHO.moveHideout <- function( _location )
	{
		if (::modPLHO.PlayerHideout == null) return;
		::logWarning("moving Hideout");
		::modPLHO.PlayerHideout.setPos(_location.getTile().Pos);
		::modPLHO.PlayerHideout.takeOver(_location);
	}

	::modPLHO.spawnHideout <- function( _location )
	{
		::logWarning("creating Hideout");
		local hideout = ::World.spawnLocation("scripts/entity/world/settlements/player_hideout", _location.getTile().Coords);
		hideout.takeOver(_location);
		::modPLHO.PlayerHideout = hideout;
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
