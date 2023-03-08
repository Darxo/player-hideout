this.hideout_roster_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {
		TroopManager = null
	}
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
		local count = ::Math.max(2, ::Math.min(8, ::Math.ceil(stationedBrothers / 2)));
		return "ui/settlements/roster_0" + count;
	}

	function onClicked( _townScreen )
	{
		if (this.isClosed()) return;

		::World.Assets.updateFormation();	// maybe not needed?

		::World.State.m.WorldTownScreen.hideAllDialogs();

		::modPLHO.RosterScreen.show();
		::World.State.getTownScreen().m.LastActiveModule = ::modPLHO.RosterScreen;
		::World.State.m.MenuStack.push(function ()
		{
			::modPLHO.RosterScreen.hide();
			::World.State.getTownScreen().showMainDialog();
		}, function ()
		{
			return !::modPLHO.RosterScreen.isAnimating();
		});

		// _townScreen.getTroopQuarterDialogModule().init(this.getSettlement());
		// _townScreen.showTroopQuarterDialog();
		// this.pushUIMenuStack();
	}

	// New Functions
	function onAfterInit()	// similar to that of a settlement
	{
		this.m.TroopManager = ::new("scripts/mods/mod_TQUA/troop_manager");
		::modPLHO.RosterScreen.init(this.m.TroopManager);
		// The Settlement does not have an ID during the function create. That'y why we need to register the town later in the RosterScreen
        this.m.TroopManager.registerRoster("PLHO_Roster", "Hideout Roster", this.getSettlement().getID(), this.getSettlement().m.RosterSlots);
	}
});

