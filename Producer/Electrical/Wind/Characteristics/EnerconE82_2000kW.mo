within TransiEnt.Producer.Electrical.Wind.Characteristics;
record EnerconE82_2000kW "Enercon model E82 2MW"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//





  //Record containing the data of the Enercon Windturbine model E82 with 2MW source:http://www.enercon.de/produkte/ep-2/e-82/

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=2e6,
    PowerCurve=[
    0,0;
    1.95, 0;
2, 4160.8877;
3.0125086, 23300.97;
4.0618486, 66574.2;
4.979152, 171428.57;
5.972898, 324549.22;
6.980542, 477669.9;
7.932592, 787239.9;
8.961084, 1175034.7;
9.982627, 1506241.3;
10.990271, 1812482.7;
12.067408, 2000554.8;
13.005559, 2052150;
14, 2100000;
15, 2100000;
16, 2100000;
17, 2100000;
18, 2100000;
19, 2100000;
20, 2100000;
21, 2100000;
22, 2100000;
23, 2100000;
24, 2100000;
24.1, 2100000;
24.2, 2100000;
24.3, 2100000;
25, 2100000;
25.001, 0;
30,0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Enercon Windturbine model E82 with 2MW</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Enercon GmbH, URL: https://www.enercon.de/produkte/ep-2/e-82/</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end EnerconE82_2000kW;
