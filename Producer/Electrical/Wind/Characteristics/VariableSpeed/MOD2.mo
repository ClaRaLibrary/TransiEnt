within TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed;
record MOD2
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends BetzCoefficientApproximation(c={0.5,116,0.4,0,5,21,0.035}, lambdaOpt=
[
0,8.0000;
1.0000,8.8000;
2.0000,9.6000;
3.0000,9.6000;
4.0000,9.2000;
5.0000,8.8000;
6.0000,8.4000;
7.0000,8.2000;
8.0000,7.8000;
9.0000,7.4000;
10.0000,7.2000;
11.0000,6.8000;
12.0000,6.6000;
13.0000,6.4000;
14.0000,6.0000;
15.0000,5.8000;
16.0000,5.6000;
17.0000,5.4000;
18.0000,5.2000;
19.0000,4.8000;
20.0000,4.6000;
21.0000,4.4000;
22.0000,4.2000;
23.0000,4.0000;
24.0000,3.8000;
25.0000,3.6000;
26.0000,3.4000;
27.0000,3.2000;
28.0000,3.0000;
29.0000,3.0000;
30.0000,2.8000;
31.0000,2.6000;
32.0000,2.4000;
33.0000,2.2000;
34.0000,2.0000;
35.0000,2.0000;
36.0000,1.8000;
37.0000,1.6000;
38.0000,1.4000;
39.0000,1.4000;
40.0000,1.2000;
41.0000,1.0000;
42.0000,0.8000;
43.0000,0.8000;
44.0000,0.6000;
45.0000,0.4000],
    P_el_n=3500000);
// script for generation can be found in \\transientee-sources\matlab\pd\Wind\cpopt.m
end MOD2;
