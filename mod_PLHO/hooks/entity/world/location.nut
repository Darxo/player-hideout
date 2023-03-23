::mods_hookExactClass("entity/world/location", function(o) {
	local oldOnCombatLost = o.onCombatLost;
	o.onCombatLost = function()
	{
		oldOnCombatLost();
		if (!this.m.IsDestructible) return;
        if (this.m.IsBattlesite) return;

        local tile = this.getTile();
        local entities = ::World.getAllEntitiesAtPos(tile.Pos, 1);
        foreach (entity in entities)
        {
            if (entity.isLocation() == false) continue;     // Only Locations have 'TypeID'
            if (entity.m.TypeID != "location.battlefield") continue;

            entity.m.OnEnter = "event.PLHO_setup_hideout";   // OnEnter is only called when you enter an unVisited location. So we need this but it is also not enough for our purpose
            entity.setOnEnterCallback(function( _location ) {
                ::World.Events.fire("event.PLHO_setup_hideout");
            });     // We also have to define this OnEnterCallback so that you keep having the option to enter this Hideout even later on

            entity.getFlags().set("PreviousLocationSprite", this.getSprite("body").getBrush().Name);
            break;
        }
	}
});
