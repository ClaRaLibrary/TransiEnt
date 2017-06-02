within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SiemensSWT36_120_3600kW
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
    //Record containing the data of the Siemens Windturbine model SWT-3.6-120 with 3,6MW source:http://www.energy.siemens.com/hq/pool/hq/power-generation/wind-power/E50001-W310-A169-X-4A00_WS_SWT_3-6_120_US.pdf

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

    extends GenericPowerCurve(
  P_el_n=3.6e6,
    PowerCurve=[
    0,      0;
  3,        0;
4.0470934,        135.74661;
4.838116,   256.41025;
5.647535,        413.273;
6.291391,        600.30164;
7.284768,        883.86127;
8.222958,        1233.7858;
9.142752,        1653.092;
9.896983,        2054.2986;
10.688005,        2536.9531;
11.000736,        2820.513;
11.479029,        3079.9397;
11.846947,        3248.869;
12.325239,        3375.5657;
12.821928,        3444.9473;
13,              3600;
15.48933,        3600;
25,              3600;
25.001,           0;
30,              0],
cut_out=25,
cut_backin=22);

end SiemensSWT36_120_3600kW;
