within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SenvionM104_3400kW "Senvion model M104 3,4MW"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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




  //Record containing the data of the Senvion Windturbine model M104 with 3,4MW
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // ____________________________________________

  extends GenericPowerCurve(
    P_el_n=3.4e6,
    PowerCurve=[
0,0;
3.5,  0;
4.17835,  115543;
5.40476,  369944;
5.90334,  514456;
6.14203,  613424;
6.73295,  942331;
7.72789,  1538600;
8.65063,  2044010;
9.22087,  2354200;
9.88485,  2656420;
10.5594,  2934610;
11.0993,  3124560;
11.5459,  3255690;
12.0554,  3338750;
12.3467,  3380000;
12.5,     3400000;
13,     3400000;
13.5,     3400000;
14,     3400000;
14.5,     3400000;
15,     3400000;
15.5,     3400000;
16,     3400000;
16.5,     3400000;
17,     3400000;
17.5,     3400000;
18,     3400000;
25,  3400000;
25.001,  0;
30, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Senvion Windturbine model M104 with 3,4MW</p>
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
<p>[1]  Senvion S.A., URL: https://www.senvion.com/global/de/produkte-services/windenergieanlagen/3xm/34m104/</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end SenvionM104_3400kW;
