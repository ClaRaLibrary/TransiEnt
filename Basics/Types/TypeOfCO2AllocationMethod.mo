within TransiEnt.Basics.Types;
type TypeOfCO2AllocationMethod = Integer(min=1, max=3) "Allocation method"
annotation(choices(
    choice=1 "IEA Method",
    choice=2 "Efficiency Method",
    choice=3 "PES Method (Finnish)"));
