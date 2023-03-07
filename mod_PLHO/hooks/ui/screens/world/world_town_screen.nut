::mods_hookNewObject("ui/screens/world/world_town_screen", function(o)
{
    // Unfortunately the CharacterScreen can be opened almost at any time, even during our RosterScreen.
    // And during that time the CharacterScreen assumes that calling 'showLastActiveDialog' is enough to get back to that screen
    // So for the specific case that someone presses 'C' while inside our RosterScreen we implement this support:
    local oldShowLastActiveDialog = o.showLastActiveDialog;
    o.showLastActiveDialog = function()
    {
		if (this.m.LastActiveModule != null && this.m.LastActiveModule.m.ID == "RosterManagerScreen")
		{
			this.m.LastActiveModule.show();
            return;
		}
        oldShowLastActiveDialog();
    }
});


