::mods_hookExactClass("entity/world/locations/battlefield_location", function(o) {
    local oldOnDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		oldOnDeserialize(_in);
        if (this.getFlags().has("PreviousLocationSprite"))
        {
            this.m.OnEnter = "event.setup_hideout";   // OnEnter is only called when you enter an unVisited location. So we need this but it is also not enough for our purpose
            this.setOnEnterCallback(function( _location ) {
                ::World.Events.fire("event.setup_hideout");
            });     // We also have to define this OnEnterCallback so that you keep having the option to enter this Hideout even later on
        }
	}
});
