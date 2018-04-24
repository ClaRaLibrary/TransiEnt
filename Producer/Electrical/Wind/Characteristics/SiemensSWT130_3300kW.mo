within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SiemensSWT130_3300kW "Siemens model SWT130 3300kW"
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
  P_el_n=3.3e6,
    PowerCurve=[
    0,0;
    2.9,0;
    3.0,42000;
4.0,180000;
5.0,412000;
6.0,760000;
7.0,1241000;
8.0,1864000;
9.0,2588000;
10.0,3122000;
11.0,3278000;
12.0,3298000;
13.0,3300000;
13.5,3300000;
14.0,3300000;
14.5,3300000;
15.0,3300000;
15.5,3300000;
16.0,3300000;
16.5,3300000;
17.0,3300000;
17.5,3300000;
18.0,3300000;
18.5,3300000;
19.0,3300000;
19.5,3300000;
20.0,3300000;
21.0,3300000;
25,3300000;
25.001,0;
50, 0],
cut_out=22.5,
cut_backin=20);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end SiemensSWT130_3300kW;
