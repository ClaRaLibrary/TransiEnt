within TransiEnt.Basics.Types;
type ThermalPlantStatus
               extends Integer;
annotation(choices(
choice=TransiEnt.Basics.Types.off "Off",
choice=TransiEnt.Basics.Types.on1 "Operating",
choice=TransiEnt.Basics.Types.on2 "Off (ready to start)"));
end ThermalPlantStatus;
