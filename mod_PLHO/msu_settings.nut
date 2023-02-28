// General Page
local page = ::modPLHO.Mod.ModSettings.addPage("General");
local hideoutNameSetting = page.addStringSetting("HideoutName", "Player Hideout", "Hideout Name:")
hideoutNameSetting.addAfterChangeCallback(function (_oldValue)
{
    if (::MSU.Utils.getActiveState() == null) return;
    if (::MSU.Utils.getActiveState().ClassName == "main_menu_state") return;	// otherwise the game crashes when changing settings in main menu
    if (this.Value == _oldValue) return;    // Value didn't change. We don't need an update
    if (::modPLHO.PlayerHideout == null) return;
    ::modPLHO.PlayerHideout.setName(this.Value);
});


