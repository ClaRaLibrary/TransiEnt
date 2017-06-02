within TransiEnt.Producer.Electrical.Wind.Characteristics;
record VestasV164_8000kW "Vestas model V164 8MW"
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

  //Record containing the data of the Vestas Windturbine model V164 with 8MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=8e6,
    PowerCurve=[
    0, 0;
    1, 0;
    2, 0;
    3, 0;
4.014,        132000;
4.470,        352000;
5.106,        673000;
5.700,        960000;
6.209,        1293000;
6.570,        1529000;
6.952,        1845000;
7.345,        2189000;
7.664,        2533000;
8.036,        2922000;
8.365,        3333000;
8.663,        3683000;
8.939,        4015000;
9.173,        4359000;
9.481,        4816000;
9.758,        5222000;
10.045,        5605000;
10.374,        6124000;
10.608,        6474000;
10.896,        6900000;
11.034,        7151000;
11.183,        7308000;
11.416,        7523000;
11.745,        7737000;
11.978,        7849000;
12.254,        7911000;
12.741,        7956000;
13.313,        7984000;
14.002,        8000000;
15.000,        8000000;
25.000,        8000000;
25.001,        0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">Vestas V164</span></b></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Characteristic values of power curve for the Vestas V164 turbine.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Source:</span></p>
</html>"));
end VestasV164_8000kW;
