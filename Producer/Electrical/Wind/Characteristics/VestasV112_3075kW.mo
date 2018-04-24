within TransiEnt.Producer.Electrical.Wind.Characteristics;
record VestasV112_3075kW "Vestas model V112 3075kW"
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
  P_el_n=3.075e6,
    PowerCurve=[
    0,0;
    2.9,0;
    3.0,26000;
3.5,73000;
4.0,133000;
4.5,207000;
5.0,302000;
5.5,416000;
6.0,554000;
6.5,717000;
7.0,907000;
7.5,1126000;
8.0,1375000;
8.5,1652000;
9.0,1958000;
9.5,2282000;
10.0,2585000;
10.5,2821000;
11.0,2997000;
11.5,3050000;
12.0,3067000;
12.5,3074000;
13.0,3075000;
14.0,3075000;
15.0,3075000;
16.0,3075000;
17.0,3075000;
18.0,3075000;
25.0,3075000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end VestasV112_3075kW;
