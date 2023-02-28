this.player_hideout <- this.inherit("scripts/entity/world/settlement", {
    m = {
        WageMultiplier = 0.5,
        RosterSlots = 27
    }
    function create()
    {
        this.settlement.create();
        this.m.Name = ::modPLHO.Mod.ModSettings.getSetting("HideoutName").getValue();
		this.m.UIDescription = "This is your personal hideout where you can store items and station brothers.";
		this.m.Description = "This is your personal hideout where you can store items and station brothers.";
		this.m.IsVisited = true;    // May help prevent accidental counting for certain events

		this.m.Buildings.resize(6, null);
		this.addBuilding(::new("scripts/entity/world/settlements/buildings/hideout_roster_building"), 2);   // 5 is the default Crowd Building spot
		this.addBuilding(::new("scripts/entity/world/settlements/buildings/hideout_storage_building"), 0);
    }

    function getTooltip()
    {
        local ret = this.world_entity.getTooltip();
        ret.extend([
			{
				id = 3,
				type = "text",
                icon = "ui/icons/asset_brothers.png",
				text = "Stationed Brothers: " + this.getRoster().getSize()
			},
			{
				id = 4,
				type = "text",
                icon = "ui/icons/asset_daily_money.png",
				text = "Daily Wage: " + this.getDailyCost()
			},
			{
				id = 5,
				type = "text",
                icon = "ui/icons/bag.png",
				text = "Stored Items: " + this.getStoredItemsString()
			}
        ])
        return ret;
    }

    function onAfterInit()  // The banner is only added during onAfterInit. So we can only adjust it here
    {
        this.settlement.onAfterInit();
        ::modPLHO.HideoutRosterScreen.m.TroopManager.registerTownRoster( "PLHO_Roster", "Hideout Roster", this.getID(), this.m.RosterSlots );
		this.getSprite("location_banner").setBrush(::World.Assets.getBanner());    // Similar to how player party receives their banner
    }

	function isEnterable()  // temporary overwrite
	{
        return true;
	}

	function getFactionOfType(_type)
	{
        if ("FactionManager" in ::World) return ::World.FactionManager.getFactionOfType(::Const.FactionType.Player);
        return null;
	}

    // overwrite because we don't want things like  port or attached buildings
    function build()
    {
        this.m.IsCoastal = false;

		local myTile = this.getTile();
        for( local i = 0; i < 6; i = ++i )
        {
            if (!myTile.hasNextTile(i)) continue;
            if (myTile.getNextTile(i).Type == ::Const.World.TerrainType.Ocean || myTile.getNextTile(i).Type == ::Const.World.TerrainType.Shore)
            {
                this.m.IsCoastal = true;
                break;
            }
        }

        if (!this.m.IsCoastal) return;

        this.m.UIBackgroundLeft = "ui/settlements/water_01";
    }

    // Changes the appearance of this hideout to match that of the location you are taking over
    function takeOver( _location )
    {
        this.assimilateTileProperties();
        if (this.hasLabel("name")) this.getLabel("name").Visible = true; // This will make sure the name is shown after moving the Hideout. Because for some reason the Visible of the label is turned off then
        if (_location.getFlags().has("PreviousLocationSprite") == false) return;
        this.getSprite("body").setBrush(_location.getFlags().get("PreviousLocationSprite"));    // We chance the appearance of this Hideout to that of the previous Location
    }

    function updateBrothers()   // This is only supposed to be called once per day on pay-time
    {
        foreach( bro in this.getRoster().getAll() )
        {
            bro.getSkills().onNewDay();     // This is mainly for injuries so they heal also while in the hideout
            bro.updateInjuryVisuals();
        }
        ::World.Assets.addMoney(-this.getDailyCost());
    }

	function getRoster()
	{
		return ::World.getRoster(this.getID());
	}

    function getStoredItemsString()
    {
        local vault = this.getBuilding("building.vault")
        if (vault == null) return "0";
        return "" + vault.getStash().getNumberOfFilledSlots() + " / " + vault.getStash().getCapacity();
    }

    function getWageMultiplier()
    {
        return this.m.WageMultiplier;
    }

    function getDailyCost()
    {
        local combinedWage = 0;
        foreach (brother in this.getRoster().getAll())
        {
            combinedWage += (brother.getDailyCost() * this.getWageMultiplier());
        }
        return ::Math.ceil(combinedWage);
    }

    function assimilateTileProperties()     // Changes this towns background appearance to match that of the tiles its currently placed at
    {
        // All this is a copy of how vanilla does it:
        local tile = this.getTile();
		local terrain = [];
		terrain.resize(::Const.World.TerrainType.COUNT, 0);
		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i)) continue;
			++terrain[tile.getNextTile(i).Type];
		}

		terrain[::Const.World.TerrainType.Plains] = ::Math.max(0, terrain[::Const.World.TerrainType.Plains] - 1);

		if (terrain[::Const.World.TerrainType.Steppe] != 0 && ::Math.abs(terrain[::Const.World.TerrainType.Steppe] - terrain[::Const.World.TerrainType.Hills]) <= 2) terrain[::Const.World.TerrainType.Steppe] += 2;
		if (terrain[::Const.World.TerrainType.Snow] != 0 && ::Math.abs(terrain[::Const.World.TerrainType.Snow] - terrain[::Const.World.TerrainType.Hills]) <= 2) terrain[::Const.World.TerrainType.Snow] += 2;

		local highest = 0;
		for( local i = 0; i < ::Const.World.TerrainType.COUNT; i = ++i )
		{
			if (i == ::Const.World.TerrainType.Ocean || i == ::Const.World.TerrainType.Shore) continue;
			if (terrain[i] >= terrain[highest]) highest = i;
		}

		this.m.UIBackground = ::Const.World.TerrainSettlementImages[highest].Background;
		this.m.UIRamp = ::Const.World.TerrainSettlementImages[highest].Ramp;
		this.m.UIForeground = this.m.HousesMax < 5 || this.isSouthern() ? ::Const.World.TerrainSettlementImages[highest].Foreground : "ui/settlements/foreground_04";
		this.m.UIMood = ::Const.World.TerrainSettlementImages[highest].Mood;
    }

	function onSerialize( _out )
	{
        // this.getFlags().set("LocationSprite", this.getSprite("body").getBrush().Name);   // This is probably not needed. I think BB serializes the Sprite by itself
        this.settlement.onSerialize(_out);
        _out.writeU16(this.m.RosterSlots);
		_out.writeF32(this.getWageMultiplier());
    }

	function onDeserialize( _in )
	{
        ::logWarning("onDeserialize");
        this.settlement.onDeserialize(_in);
        this.m.RosterSlots = _in.readU16();
		this.m.WageMultiplier = (this.Math.maxf(0.0, _in.readF32()));
        // this.getSprite("body").setBrush(this.getFlags().get("LocationSprite"));
        ::modPLHO.PlayerHideout = this;
    }

    // "Deleted" base functions. We never want nor need this functionality
	function hasAttachedLocation( _id )                 {return false;}
	function hasContract( _id )                         {return false;}
	function hasSituation( _id )                        {return false;}
    function getSellPriceMult()                         {return 0.0}

	function getActiveAttachedLocations()               {return [];}
	function getContracts()                             {return [];}
	function getSituations()                            {return [];}

    function getSituationByID( _id )                    {return null;}
    function getSituationByInstance( _instanceID )      {return null;}
    function getUIContractInformation()
	{
		return {
			Contracts = [],
			IsContractActive = this.World.Contracts.getActiveContract() != null,
			IsContractsLocked = false
		};
    }
    function addSituation( _s, _validForDays = 0 ) {}
    function removeSituationByID( _id ) {}
    function removeSituationByInstance( _instanceID ) {}

    function updateSituations() {}
    function updateProduce() {}
    function updateRoster(_force = false) {}    // We never want this. We use this towns Roster for storing brothers, not for some hiring process
    function updateImportedProduce() {}
    function updateShop(_force = false) {}
    function onUpdateShopList(_id, _list) {}

    function resetRoster(_soft = false) {}
    function resetShop() {}

    function findAccessibleOceanEdge( _minX, _maxX, _minY, _maxY ) {return null;}
});
