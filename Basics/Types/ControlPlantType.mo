within TransiEnt.Basics.Types;
type ControlPlantType = enumeration(
    PeakLoad "Peak load plant, small droop (2.5%)",
    MidLoad "Mid load plant, medium droop (4%)",
    BaseLoad "Base Load plant, high droop (6%)",
    Provided "Provide specific value");
