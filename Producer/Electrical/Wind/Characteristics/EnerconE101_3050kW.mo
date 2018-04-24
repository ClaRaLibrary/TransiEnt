within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE101_3050kW "Enercon model E101 3050kW"
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
  P_el_n=3.05e6,
    PowerCurve=[
0,0;
1,0;
2,3000;
3,37000;
4,118000;
5,258000;
6,479000;
7,790000;
8,1200000;
9,1710000;
10,2340000;
11,2867000;
12,3034000;
13,3050000;
13.5,3050000;
14,3050000;
14.5,3050000;
15,3050000;
15.5,3050000;
16,3050000;
16.5,3050000;
17,3050000;
17.5,3050000;
18,3050000;
18.5,3050000;
19,3050000;
19.5,3050000;
20,3050000;
25,3050000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end EnerconE101_3050kW;
