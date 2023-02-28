this.setup_hideout_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.setup_hideout";
		this.m.Title = "In the ruins of a location...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%randombrother% grumbles.%SPEECH_ON%Giving up is not the way of this company, or at least I didn\'t think it was.%SPEECH_OFF%The men have been moping about today, cursing loudly about nothing and muttering into their drink. They are unhappy about the company not achieving the goal everyone agreed on.%SPEECH_ON%Certainly we could chase this task we set ourselves across the world and back, just as we could spend our days chasing butterflies, but if it cannot be done let\'s put this misfortune behind us and move on to what we do best: fighting, drinking, and spending our hard-earned coin!%SPEECH_OFF%%highestexperience_brother% encourages his brothers-in-arms. These words placate the men somewhat and you are relieved not to have a revolt on your hands. | As you walk around the tents of the camp, %randombrother% approaches to complain.%SPEECH_ON%I seem to recall signing up with a band of merciless fighting men. Men who let nothing stand in their path. Now the %companyname% feels more like a squad of tired children than an unstoppable force.%SPEECH_OFF%He pauses, bites his lips.%SPEECH_ON%Captain, sir, I mean.%SPEECH_OFF%You nod and continue on your way. Clearly, the man is upset about the company\'s inability to fulfill the goal you announced to the men not long ago. | Despite your best efforts, you failed in fulfilling your latest ambition on the company\'s path to greatness. Worse, the men are all keenly aware of it, and seem more put out by this failure than you are. Feet are dragging, heads hanging, and griping and discontent louder than usual.\n\nStill, the sun rises just the same, and to worry over one\'s failures is to waste time better spent on new opportunities. You know that the men of the %companyname% will ride out this setback and march on to greater glories. Or die in the attempt. | After much striving and effort, you are finally forced to give up on the ambition you chose for the %companyname% to pursue. A mercenary company must face many setbacks on the road to greatness, but this latest failure to follow through has been especially bitter for the men. It would be wise to secure a lucrative contract or provide some other distraction, perhaps the threat of imminent death, to distract them from their unhappiness. | After you tell the men that the company isn\'t going to be able to do what you so proudly announced it would accomplish, the men grow standoffish and moody. Like sulky children they turn away when you come near and whisper their complaints whenever your back is turned.%SPEECH_ON%How are we ever going to be famous if we don\'t finish what we started? I want to be known wherever we go, and have our drinks poured before we walk in the door.%SPEECH_OFF%}",
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
                if (::modPLHO.PlayerHideout == null)
                {
                    this.Options.insert(0, {
                        Text = "Create your Player Hideout here",
                        function getResult( _event )
                        {
                            ::modPLHO.spawnHideout(::World.State.getLastLocation());
                            ::World.State.getLastLocation().die();  // idk what die() exactly does. I just hope it removes the battlesite
                            return 0;
                        }
                    });
                }
                else
                {
                    this.Options.insert(0, {
                        Text = "Relocate your Player Hideout here",
                        function getResult( _event )
                        {
                            ::modPLHO.moveHideout(::World.State.getLastLocation());
                            ::World.State.getLastLocation().die();  // idk what die() exactly does. I just hope it removes the battlesite
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

