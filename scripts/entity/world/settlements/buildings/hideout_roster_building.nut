this.hideout_roster_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	function create()
	{
		this.building.create();
		this.m.ID = "building.roster";
		this.m.Name = "Stationed Roster";
		this.m.IsClosedAtNight = false;

		this.m.Description = "You can station brothers here for reduced pay and retrieve them later.";
		this.m.UIImage = "ui/settlements/roster_02";
		this.m.UIImageNight = "ui/settlements/roster_02";
		this.m.Tooltip = "world-town-screen.main-dialog-module.HideoutRoster";
		// this.m.TooltipIcon = "ui/icons/buildings/fletcher.png";
	}

	function isClosed()
	{
		return false;
	}

	function getUIImage()
	{
		local stationedBrothers = this.getSettlement().getRoster().getSize();
		local count = ::Math.max(2, ::Math.min(6, ::Math.ceil(stationedBrothers / 2)));
		return "ui/settlements/roster_0" + count;
	}

	function onClicked( _townScreen )
	{
		if (this.isClosed()) return;

		::World.Assets.updateFormation();	// maybe not needed?

		::World.State.m.WorldTownScreen.hideAllDialogs();

		::modPLHO.HideoutRosterScreen.show();
		::World.State.m.MenuStack.push(function ()
		{
			::modPLHO.HideoutRosterScreen.hide();
			::World.State.m.WorldTownScreen.showLastActiveDialog();
		}, function ()
		{
			return !::modPLHO.HideoutRosterScreen.isAnimating();
		});

		// _townScreen.getTroopQuarterDialogModule().init(this.getSettlement());
		// _townScreen.showTroopQuarterDialog();
		// this.pushUIMenuStack();
	}
});

