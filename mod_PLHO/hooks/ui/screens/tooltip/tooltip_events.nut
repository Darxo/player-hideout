::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function(o)
{
    local oldGeneral_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
    o.general_queryUIElementTooltipData = function ( _entityId, _elementId, _elementOwner )
    {
        if(_elementId == "world-town-screen.main-dialog-module.HideoutRoster")
        {
            local hideoutCost = ::modPLHO.PlayerHideout.getDailyCost();
			return [
				{
					id = 1,
					type = "title",
					text = "Hideout Roster"
				},
				{
					id = 2,
					type = "description",
					text = "You can station brothers here for reduced pay and retrieve them later. Brothers in your Hideout do not require food."
				},
                {
                    id = 4,
                    type = "text",
					icon = "ui/icons/camp.png",
                    text = "Hideout Roster Wage: " + hideoutCost
                },
				{
					id = 5,
					type = "text",
                    icon = "ui/icons/asset_daily_money.png",
					text = "Wage Multiplier: " + ::modPLHO.PlayerHideout.getWageMultiplier()
				}
			];
        }

        if(_elementId == "world-town-screen.main-dialog-module.HideoutStash")
        {
			return [
				{
					id = 1,
					type = "title",
					text = "Stash"
				},
				{
					id = 2,
					type = "description",
					text = "A secure place that you can use and upgrade to store items indefinitely."
				},
				{
					id = 3,
					type = "text",
                    icon = "ui/icons/asset_food.png",
					text = "Food will still spoil!"
				}
			];
        }

        local ret = oldGeneral_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);

        if (::modPLHO.PlayerHideout != null && _elementId == "assets.Money")
        {
            local hideoutCost = ::modPLHO.PlayerHideout.getDailyCost();
			local mainRosterMoney = ::World.Assets.getMainRosterDailyCost();

            ret.extend([
                {
                    id = 3,
                    type = "text",
					icon = "ui/icons/asset_brothers.png",
                    text = "Main Roster Wage: " + mainRosterMoney
                },
                {
                    id = 4,
                    type = "text",
					icon = "ui/icons/camp.png",
                    text = "Hideout Roster Wage: " + hideoutCost
                }
            ]);
        }

        return ret;
    }
});
