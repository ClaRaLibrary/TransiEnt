within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SenvionM104_3400kW "Senvion model M104 3,4MW"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

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
25,  3400000;
25.001,  0;
30, 0],
cut_out=25,
cut_backin=22);

end SenvionM104_3400kW;
