within TransiEnt.Basics.Types;
type OnOffPumpstorageStatus
                            extends Integer;
  annotation (choices(
      choice=TransiEnt.Basics.Types.off "Off",
      choice=TransiEnt.Basics.Types.on1 "Operating as pump",
      choice=TransiEnt.Basics.Types.on2 "Operating as turbine"));

end OnOffPumpstorageStatus;
