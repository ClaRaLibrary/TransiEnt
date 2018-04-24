within TransiEnt.Producer.Electrical.Wind.Characteristics;
record NordexN100_2500kW "Nordex model N100 2500kW"
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
    3,0;
3.5,34000;
4.0,88000;
4.5,155000;
5.0,237000;
5.5,333000;
6.0,448000;
6.5,582000;
7.0,738000;
7.5,919000;
8.0,1123000;
8.5,1351000;
9.0,1604000;
9.5,1845000;
10.0,2043000;
10.5,2200000;
11.0,2321000;
11.5,2409000;
12.0,2467000;
12.5,2495000;
13.0,2500000;
14.0,2500000;
15.0,2500000;
16.0,2500000;
17.0,2500000;
18.0,2500000;
19.0,2500000;
25.0,2500000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end NordexN100_2500kW;
