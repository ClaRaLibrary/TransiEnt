within TransiEnt.Basics.Types;
type TypeOfResource = enumeration(
    Consumer "Consumer",
    Conventional "Conventional producer",
    Cogeneration "Generator in cogeneration or district heating grid",
    Renewable "Renewable producer",
    Storage "Storage",
    Generic "E.g. UCTE Grid will not be summed in statistisc!");
