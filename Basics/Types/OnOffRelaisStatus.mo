within TransiEnt.Basics.Types;
type OnOffRelaisStatus
                            extends Integer;
  annotation (choices(
      choice=1 "On and ready to switch",
      choice=2 "Off and ready to switch",
      choice=3 "On and blocked by minimum up-time",
      choice=4 "Off and blocked by minimum downtime"));

end OnOffRelaisStatus;
