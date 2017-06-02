within TransiEnt.Basics.Types;
type DoubleSetpointControllerStatus
                                    extends Integer;

  annotation(choices(
      choice=off "Off",
      choice=on1 "On Statge 1",
      choice=on2 "On, Stage 2"));
end DoubleSetpointControllerStatus;
