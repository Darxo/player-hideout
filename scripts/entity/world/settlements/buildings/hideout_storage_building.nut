this.hideout_storage_building <- this.inherit("scripts/entity/world/settlements/buildings/vabu_vault_building", {
	function create()
	{
		this.vabu_vault_building.create();
		this.m.Name = "Hideout Storage";
		this.m.Description = "A secure place that you can use and upgrade to store items indefinitely.";
		this.m.IsClosedAtNight = false;

		this.m.UIImage = "ui/settlements/tent_stash";
		this.m.UIImageNight = "ui/settlements/tent_stash";
		this.m.Tooltip = "world-town-screen.main-dialog-module.HideoutStash";
		this.m.TooltipIcon = "ui/icons/bag.png";
	}

	function isClosed()
	{
		return false;
	}
});

