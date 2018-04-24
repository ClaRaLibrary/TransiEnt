within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SiemensSWT36_120_3600kW "Siemens model SWT120 3600MW"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
    //Record containing the data of the Siemens Windturbine model SWT-3.6-120 with 3,6MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

    extends GenericPowerCurve(
  P_el_n=3.6e6,
    PowerCurve=[
    0,      0;
  3,        0;
4,        174000;
5,   379000;
6,        686000;
7,        1108000;
8,        1667000;
9,        2378000;
10,        3094000;
11,        3487000;
12,        3588000;
13,        3599000;
14,        3600000;
15,        3600000;
16,        3600000;
16.5,        3600000;
17,              3600000;
17.5,              3600000;
18,              3600000;
18.5,              3600000;
19,              3600000;
19.5,              3600000;
20,              3600000;
20.5,              3600000;
21,              3600000;
22,              3600000;
23,              3600000;
24,              3600000;
25,              3600000;
25.001,           0;
30,              0],
cut_out=25,
cut_backin=22);

end SiemensSWT36_120_3600kW;
