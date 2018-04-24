within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE115_2500kW "Enercon model E115 2500kW"
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
  P_el_n=2.5e6,
    PowerCurve=[
0,0;
1,0;
2,3000;
3,48500;
4,155000;
5,339000;
6,627500;
7,1035500;
8,1549000;
9,2040000;
10,2382000;
11,2490000;
12,2500000;
12.5,2500000;
13,2500000;
13.5,2500000;
14,2500000;
14.5,2500000;
15,2500000;
15.5,2500000;
16,2500000;
16.5,2500000;
17,2500000;
17.5,2500000;
18,2500000;
18.5,2500000;
19,2500000;
20,2500000;
25,2500000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end EnerconE115_2500kW;
