within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE92_2350kW "Enercon model E92 2350kW"
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
  P_el_n=2.35e6,
    PowerCurve=[
0,0;
1,0;
2,3600;
3,29900;
4,98200;
5,208300;
6,384300;
7,637000;
8,975800;
9,1403600;
10,1817800;
11,2088700;
12,2237000;
13,2300000;
14,2350000;
14.2,2350000;
14.3,2350000;
14.5,2350000;
15,2350000;
15.5,2350000;
16,2350000;
16.5,2350000;
17,2350000;
17.5,2350000;
18,2350000;
18.5,2350000;
19,2350000;
20,2350000;
25,2350000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end EnerconE92_2350kW;
