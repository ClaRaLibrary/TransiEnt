within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE53_800kW "Enercon model E53 800kW"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=0.8e6,
    PowerCurve=[
0,0;
1,0;
2,2000;
3,14000;
4,38000;
5,77000;
6,141000;
7,228000;
8,336000;
9,480000;
10,645000;
11,744000;
12,780000;
13,810000;
13.1,810000;
13.2,810000;
13.3,810000;
13.4,810000;
13.5,810000;
13.6,810000;
13.7,810000;
13.8,810000;
13.9,810000;
14,810000;
15,810000;
16,810000;
17,810000;
18,810000;
25,810000;
25.001,0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end EnerconE53_800kW;
