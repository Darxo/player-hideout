this.player_hideout <- this.inherit("scripts/entity/world/settlement", {

    // Locations are only spawned with this .exe function
    // this.World.spawnLocation(type.Script, tile.Coords);

	//custom player base settlement type. spawns custom storage building, modified marketplace that allows for both selling of trash and food and for storing items
	//many of the stronghold features are handled here
	m = {
        StationedBrothers = [],     // Array of all brothers stationed here
		isPlayerBase = true,
		IsUpgrading = false
	},

    function create()
    {
        this.settlement.create();
        this.m.Name = "Player Hideout";

		this.m.UIDescription = "This is your personal hideout where you can store items and station brothers.";
		this.m.Description = "This is your personal hideout where you can store items and station brothers.";
		this.m.UIBackgroundCenter = "";     // We have no structure on the hill
		this.m.UIBackgroundLeft = "";       // The left side is empty unless we add water there later
		this.m.UIBackgroundRight = "";      // The right side is empty
		this.m.UIRampPathway = "";          // We have no path. I would use a dirt variant if there was one

		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";    // Placeholder. We need a custom one for this
		this.m.Sprite = "world_stronghold_01";      // Placeholder. This gets replaced onInit

		this.m.Lighting = "world_stronghold_01_light";

        // Just copied for now
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 1;

        // I'm sure about these
		this.m.HousesMin = 0;
		this.m.HousesMax = 0;
		this.m.AttachedLocationsMax = 0;
		this.m.IsVisited = true;

		this.m.Banner = this.World.Assets.getBannerID();
		this.m.Buildings.resize(6, null);
        // this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_storage_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"), 5);
		// this.addBuilding(this.new("scripts/entity/world/settlements/buildings/stronghold_management_building"), 6);
    }

    function onInit()
    {
        /* This sets up:
        UIBackground, UIRamp, UIForeground, Mood depending on the tile it was build on

        */
        this.settlement.onInit();

        // Maybe place water


    }

    // overwrite because we don't want things like  port or attached buildings
    function build()
    {
        this.m.IsCoastal = false;

        for( local i = 0; i < 6; i = ++i )
        {
            if (!myTile.hasNextTile(i))
            {
            }
            else if (myTile.getNextTile(i).Type == this.Const.World.TerrainType.Ocean || myTile.getNextTile(i).Type == this.Const.World.TerrainType.Shore)
            {
                this.m.IsCoastal = true;
                break;
            }
        }

        if (this.m.IsCoastal)
        {
            this.m.UIBackgroundLeft = "ui/settlements/water_01";
        }
    }

	function onBuild()
	{
		this.getFlags().set("CustomSprite", "Default")
		this.getFlags().set("IsSouthern", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Desert, this.Const.World.TerrainType.Oasis]) ||  this.getTile().TacticalType == this.Const.World.TerrainTacticalType.DesertHills) // why is desertHills not just a terrain type wtf
		this.getFlags().set("IsOnSnow", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Snow]));
		this.getFlags().set("IsOnDesert", this.Stronghold.isOnTile(this.getTile(), [this.Const.World.TerrainType.Desert]));
		this.getFlags().set("isPlayerBase", true);
		this.getFlags().set("IsMainBase", true);
		this.getFlags().set("TimeUntilNextMercs", -1);
		this.getFlags().set("TimeUntilNextCaravan", -1);
		this.getFlags().set("TimeUntilNextPatrol", -1);
		this.getFlags().set("RosterSeed", this.toHash(this));
		this.getFlags().set("LastProduceUpdate", this.Time.getVirtualTimeF());
		this.World.createRoster(this.toHash(this));
		this.updateProperties();
		this.updateTown();
	}

    // New Functions
    function setWorldSprite( _sprite )
    {
        this.m.Sprite = _sprite;
    }

    function getStationed()
    {
        return this.m.StationedBrothers;
    }

    function getDailyCost()
    {
        local combinedWage = 0;
        foreach( brother in this.getStationed() )
        {
            combinedWage += (brother.getDailyCost() * 2);
        }
        return combinedWage;
    }


    // "Deleted" base functions. We never want nor need this functionality
	function hasAttachedLocation( _id )     {return false;}
	function hasContract( _id )             {return false;}
	function hasSituation( _id )            {return false;}

	function getActiveAttachedLocations()   {return [];}
	function getContracts()                 {return [];}
	function getSituations()                {return [];}

    function getSituationByID( _id )        {return null;}
    function getSituationByInstance( _instanceID )        {return null;}
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
    function updateRoster(_force = false) {}
    function updateImportedProduce() {}
    function updateShop(_force = false) {}
    function onUpdateShopList(_id, _list) {}

    function resetRoster(_soft = false) {}
    function resetShop() {}

    function findAccessibleOceanEdge( _minX, _maxX, _minY, _maxY ) {return null;}

    function updateProperties()
    {
        this.m.IsCoastal = false;

        for( local i = 0; i < 6; i = ++i )
        {
            if (!myTile.hasNextTile(i))
            {
            }
            else if (myTile.getNextTile(i).Type == this.Const.World.TerrainType.Ocean || myTile.getNextTile(i).Type == this.Const.World.TerrainType.Shore)
            {
                this.m.IsCoastal = true;
                break;
            }
        }
    }

});
