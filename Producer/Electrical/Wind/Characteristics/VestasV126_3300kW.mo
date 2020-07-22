within TransiEnt.Producer.Electrical.Wind.Characteristics;
record VestasV126_3300kW "Vestas model V126 3300kW"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=3.3e6,
    PowerCurve=[
    0,0;
    2.9,0;
    3.0,30000;
3.5,97000;
4.0,179000;
4.5,278000;
5.0,397000;
5.5,539000;
6.0,711000;
6.5,913000;
7.0,1150000;
7.5,1420000;
8.0,1723000;
8.5,2060000;
9.0,2434000;
9.5,2804000;
10.0,3090000;
10.5,3238000;
11.0,3290000;
11.5,3299000;
12.0,3300000;
13.0,3300000;
14.0,3300000;
15.0,3300000;
16.0,3300000;
17.0,3300000;
18.0,3300000;
19.0,3300000;
22.5,3300000;
22.501,0;
50, 0],
cut_out=22.5,
cut_backin=20);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Vestas model V126 with 3300 kW</p>
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
<p>[1] https://www.thewindpower.net/turbine_de_603_vestas_v126-3300.php</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end VestasV126_3300kW;
