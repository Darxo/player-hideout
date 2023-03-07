this.setup_hideout_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.setup_hideout";
		this.m.Title = "In the ruins of a location...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]This location is ideal for a Hideout.\nBuilding your first Hideout is instant, but moving it to a new location will always take roughly as much time as walking there from the old location would take.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Return",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
                if (::World.Flags.has("modPLHO_HasPlayerHideout") == false)
                {
                    this.Options.insert(0, {
                        Text = "Create your Player Hideout here",
                        function getResult( _event )
                        {
                            ::modPLHO.spawnHideout(::World.State.getLastLocation());
                            ::World.State.getLastLocation().die();  // idk what die() exactly does. I just hope it removes the battlesite cleanly
                            return 0;
                        }
                    });
                }
                else
                {
					this.Text += "\n\nMigrating your old hideout to this new location will take some time depending on the distance between the two spots."
					this.Text += "\nYou can [u]not[/u] access your stationed brothers or stored items during this time!"

                    this.Options.insert(0, {
                        Text = "Relocate your Player Hideout here (" + ::modPLHO.getMigrationString(::World.State.getPlayer()) + ")"
                        function getResult( _event )
                        {
                            ::modPLHO.PlayerHideout.migrateTo(::World.State.getLastLocation());
                            ::World.State.getLastLocation().die();  // idk what die() exactly does. I just hope it removes the battlesite cleanly
                            return 0;
                        }
                    });
                }

			}

		});
	}

	function onUpdateScore() {}
	function onClear() {}

});

