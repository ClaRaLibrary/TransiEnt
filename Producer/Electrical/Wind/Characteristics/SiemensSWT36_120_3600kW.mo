within TransiEnt.Producer.Electrical.Wind.Characteristics;
record SiemensSWT36_120_3600kW "Siemens model SWT120 3600MW"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
    //Record containing the data of the Siemens Windturbine model SWT-3.6-120 with 3,6MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

    extends GenericPowerCurve(
  P_el_n=3.6e6,
    PowerCurve=[
    0,      0;
  3,        0;
4,        174000;
5,   379000;
6,        686000;
7,        1108000;
8,        1667000;
9,        2378000;
10,        3094000;
11,        3487000;
12,        3588000;
13,        3599000;
14,        3600000;
15,        3600000;
16,        3600000;
16.5,        3600000;
17,              3600000;
17.5,              3600000;
18,              3600000;
18.5,              3600000;
19,              3600000;
19.5,              3600000;
20,              3600000;
20.5,              3600000;
21,              3600000;
22,              3600000;
23,              3600000;
24,              3600000;
25,              3600000;
25.001,           0;
30,              0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Siemens Windturbine model SWT-3.6-120 with 3,6MW</p>
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
end SiemensSWT36_120_3600kW;
