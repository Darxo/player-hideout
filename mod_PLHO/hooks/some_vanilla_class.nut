::mods_hookNewObject("vanilla/path/to/class/and/classname", function(o)
{
    ::logWarning("classname hooked successfully");
    local oldVanillaFunction = o.vanillaFunction;
    o.vanillaFunction = function( _argument1, _argument2 )
    {
        ::logWarning("vanillaFunction hooked");
        oldVanillaFunction( _argument1, _argument2 );
    }

    // When we can't guarantee that the target class has this function (but know for sure its base class has) we need to use getMember and mod_override
    local oldVanillaBaseFunction = ::mods_getMember(o, "vanillaBaseFunction");
    ::mods_override(o, "vanillaBaseFunction", function( _argument1 )
    {
        ::logWarning("vanillaBaseFunction hooked");
        oldVanillaBaseFunction(_argument1);
    });
});
