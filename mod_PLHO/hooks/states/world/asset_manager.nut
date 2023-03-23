::mods_hookNewObject("states/world/asset_manager", function (o)
{
    o.getMainRosterDailyCost <- o.getDailyMoneyCost;    // We save this functions because we are interested in displaying this to the player

    local oldGetDailyMoneyCost = o.getDailyMoneyCost;
    o.getDailyMoneyCost = function()
    {
        if (::World.Flags.has("modPLHO_HasPlayerHideout") == false) return oldGetDailyMoneyCost();
        return oldGetDailyMoneyCost() + ::modPLHO.PlayerHideout.getDailyCost();
    }

    local oldUpdate = o.update;
    o.update = function( _world_state )
    {
		if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8)
        {
            if (::World.Flags.has("modPLHO_HasPlayerHideout")) ::modPLHO.PlayerHideout.updateBrothers();       // This is only called once per day
        }
        oldUpdate(_world_state);
    }
});
