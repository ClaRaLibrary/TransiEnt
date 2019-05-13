within TransiEnt.Producer.Electrical.Wind.Characteristics;
record NordexN117_2400kW "Nordex model N117 2400kW"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  P_el_n=2.4e6,
    PowerCurve=[
    0,0;
    2.9,0;
3.0,23000;
3.5,81000;
4.0,154000;
4.5,245000;
5.0,356000;
5.5,488000;
6.0,644000;
6.5,826000;
7.0,1037000;
7.5,1273000;
8.0,1528000;
8.5,1797000;
9.0,2039000;
9.5,2212000;
10.0,2325000;
10.5,2385000;
11.0,2400000;
12.0,2400000;
13.0,2400000;
14.0,2400000;
15.0,2400000;
16.0,2400000;
17.0,2400000;
18.0,2400000;
19.0,2400000;
20.0,2400000;
20.001,0;
25.001, 0;
50, 0],
cut_out=20,
cut_backin=18);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Nordex model N117 with 2400 kW</p>
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
<p>[1] http://www.windenergie-im-binnenland.de/powercurve.php</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end NordexN117_2400kW;
