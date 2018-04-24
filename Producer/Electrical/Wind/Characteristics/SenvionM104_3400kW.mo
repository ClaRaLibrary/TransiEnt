within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SenvionM104_3400kW "Senvion model M104 3,4MW"
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

  //Record containing the data of the Senvion Windturbine model M104 with 3,4MW
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // ____________________________________________

  extends GenericPowerCurve(
    P_el_n=3.4e6,
    PowerCurve=[
0,0;
3.5,  0;
4.17835,  115543;
5.40476,  369944;
5.90334,  514456;
6.14203,  613424;
6.73295,  942331;
7.72789,  1538600;
8.65063,  2044010;
9.22087,  2354200;
9.88485,  2656420;
10.5594,  2934610;
11.0993,  3124560;
11.5459,  3255690;
12.0554,  3338750;
12.3467,  3380000;
12.5,     3400000;
13,     3400000;
13.5,     3400000;
14,     3400000;
14.5,     3400000;
15,     3400000;
15.5,     3400000;
16,     3400000;
16.5,     3400000;
17,     3400000;
17.5,     3400000;
18,     3400000;
25,  3400000;
25.001,  0;
30, 0],
cut_out=25,
cut_backin=22);

end SenvionM104_3400kW;
