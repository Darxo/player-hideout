
::mods_hookExactClass("entity/world/settlement", function(o) {
    // Vanilla doesn't set these values to null correctly so js will throw console errors
	local oldGetUIInformation = o.getUIInformation;
	o.getUIInformation = function()
	{
        local ret = oldGetUIInformation();
        if (this.m.UIBackgroundCenter == null) ret.BackgroundCenter <- null;
        if (this.m.UIBackgroundLeft == null) ret.BackgroundLeft <- null;
        if (this.m.UIBackgroundRight == null) ret.BackgroundRight <- null;
        return ret;
    }
});
