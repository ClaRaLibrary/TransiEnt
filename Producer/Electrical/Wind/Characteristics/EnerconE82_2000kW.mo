within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE82_2000kW "Enercon model E82 2MW"
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

  //Record containing the data of the Enercon Windturbine model E82 with 2MW source:http://www.enercon.de/produkte/ep-2/e-82/

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=2e6,
    PowerCurve=[
    0,0;
    1.95, 0;
2, 4160.8877;
3.0125086, 23300.97;
4.0618486, 66574.2;
4.979152, 171428.57;
5.972898, 324549.22;
6.980542, 477669.9;
7.932592, 787239.9;
8.961084, 1175034.7;
9.982627, 1506241.3;
10.990271, 1812482.7;
12.067408, 2000554.8;
13.005559, 2052150;
14, 2100000;
15, 2100000;
25, 2100000;
25.001, 0;
30,0],
cut_out=25,
cut_backin=22);

end EnerconE82_2000kW;
