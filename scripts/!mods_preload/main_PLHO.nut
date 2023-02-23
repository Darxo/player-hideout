::modPLHO <- {
	ID = "mod_PLHO",
	Name = "Player Hitout",
	Version = "0.1.0",
	Const = {
		// Write your Const-Variables in here.
		// These variables are not supposed to be tweaked by users.
		// They are often carefully chosen and changing them likely breaks the mod
	},
	Config = {
		// Write your Configurable Variables in here.
		// These variables are there to be tweaked by the modder or users to their liking.
		// Changing them within boundaries is usually encouraged.
	}
}

::mods_registerMod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

::mods_queue(::modPLHO.ID, "mod_msu", function()
{
	::modPLHO.Mod <- ::MSU.Class.Mod(::modPLHO.ID, ::modPLHO.Version, ::modPLHO.Name);

	::includeFiles(::IO.enumerateFiles("mod_PLHO/hooks"));		// This will load and execute all hooks that you created



	::modPHLO.spawnHideout <- function( _tile )
	{

	}
});

// Checklist:
// - replace all instances of "MODID" with your modid in uppercase letter. Within all files, aswell as for folder/file naming
// - replace the value of 'Name' with your written out mod name separated with spacebars
// - 'Version' can probably stay at 0.1.0 for your first version/release
// - if you don't use hooks, remove the hooks folder and the above ::includeFiles line
