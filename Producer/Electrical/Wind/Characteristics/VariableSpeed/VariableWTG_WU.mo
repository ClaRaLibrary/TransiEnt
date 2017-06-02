within TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed;
record VariableWTG_WU
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

//Variable Speed according to data used in: Wu, Lei: "Towards an Assessment of Power System Frequency Support From Wind Pland - Modeling Aggregate Inertial Response"

  extends BetzCoefficientApproximation(c={0.54,116,0.4,0,5,20.2,0.0225}, lambdaOpt=
[
0.0000,8.4500;
1.0000,9.1000;
2.0000,9.6000;
3.0000,9.4000;
4.0000,9.0500;
5.0000,8.7000;
6.0000,8.3500;
7.0000,8.0000;
8.0000,7.6500;
9.0000,7.3500;
10.0000,7.0500;
11.0000,6.7500;
12.0000,6.5000;
13.0000,6.2500;
14.0000,5.9500;
15.0000,5.7000;
16.0000,5.5000;
17.0000,5.2500;
18.0000,5.0000;
19.0000,4.8000;
20.0000,4.6000;
21.0000,4.4000;
22.0000,4.1500;
23.0000,3.9500;
24.0000,3.8000;
25.0000,3.6000;
26.0000,3.4000;
27.0000,3.2000;
28.0000,3.0500;
29.0000,2.8500;
30.0000,2.7000;
31.0000,2.5500;
32.0000,2.3500;
33.0000,2.2000;
34.0000,2.0500;
35.0000,1.9000;
36.0000,1.7500;
37.0000,1.6000;
38.0000,1.4500;
39.0000,1.3000;
40.0000,1.1500;
41.0000,1.0000;
42.0000,0.8500;
43.0000,0.7000;
44.0000,0.5500;
45.0000,0.4500;
46.0000,0.3000;
47.0000,0.1500;
48.0000,0.0500;
49.0000,0.0000;
50.0000,0.0000;
51.0000,0.0000;
52.0000,0.0000;
53.0000,0.0000;
54.0000,0.0000;
55.0000,0.0000;
56.0000,0.0000;
57.0000,0.0000;
58.0000,0.0000;
59.0000,0.0000;
60.0000,0.0000;
61.0000,0.0000;
62.0000,0.0000;
63.0000,0.0000;
64.0000,0.0000;
65.0000,0.0000;
66.0000,0.0000;
67.0000,0.0000;
68.0000,0.0000;
69.0000,0.0000;
70.0000,0.0000;
71.0000,0.0000;
72.0000,0.0000;
73.0000,0.0000;
74.0000,0.0000;
75.0000,0.0000;
76.0000,0.0000;
77.0000,0.0000;
78.0000,0.0000;
79.0000,0.0000;
80.0000,0.0000;
81.0000,0.0000;
82.0000,0.0000;
83.0000,0.0000;
84.0000,0.0000;
85.0000,0.0000;
86.0000,0.0000;
87.0000,0.0000;
88.0000,0.0000;
89.0000,0.0000;
90.0000,0.0000],
    P_el_n=3000000);
// script for generation can be found in \\transientee-sources\matlab\pd\Wind\cpopt.m
end VariableWTG_WU;
