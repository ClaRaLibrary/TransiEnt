within TransiEnt.Grid.Heat.HeatGridControl.Base.T_set_DHG;
record Sample_T_set_DHG "record for sample temperature characteristic line"


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





  extends Generic_T_set_DHG(T_set_DHG=[
-15,136,52.6;
-14,135,52.8;
-13,134,53.1;
-12,133,53.1;
-11,132,53.0;
-10,130,53.0;
-9,129,52.9;
-8,127,52.8;
-7,126,52.3;
-6,123,51.8;
-5,122,51.4;
-4,120,50.8;
-3,117,50.6;
-2,115,50.1;
-1,113,49.8;
0,110,49.6;
1,107,48.9;
2,104,48.5;
3,101,48.3;
4,98,47.9;
5,95,47.8;
6,93,47.7;
7,91,47.7;
8,90,47.4;
9,90,47.3;
10,90,47.2;
11,90,47.1;
12,90,47.1;
13,90,47.0;
14,90,46.8;
15,90,46.9;
16,90,46.9;
17,90,46.9;
18,90,46.9;
19,90,46.9;
20,90,46.9]);

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for sample temperature characteristic line</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Sample_T_set_DHG;
