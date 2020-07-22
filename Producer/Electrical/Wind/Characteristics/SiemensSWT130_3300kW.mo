within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SiemensSWT130_3300kW "Siemens model SWT130 3300kW"
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
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Siemens model SWT130 3300kW</p>
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
end SiemensSWT130_3300kW;
