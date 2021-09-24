within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes;
model DN_Rehau "\"Table for the used Polyethylen pipes from Rehau\""


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




  extends TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes.DN_table_base;
  constant Integer rowAmount = 20;
  constant Real DNmat[rowAmount,4] = [400, 0.3274, 0.4, 0;
355, 0.2906, 0.355, 0;
315, 0.2578, 0.315, 0;
280, 0.2292, 0.28, 0;
250, 0.2046, 0.25, 0;
225, 0.184, 0.225, 0;
200, 0.1636, 0.2, 0;
180, 0.1472, 0.18, 0;
160, 0.1308, 0.16, 0;
140, 0.1146, 0.14, 0;
125, 0.1022, 0.125, 0;
110, 0.09, 0.11, 0;
90, 0.0736, 0.09, 0;
75, 0.0614, 0.075, 0;
63, 0.0514, 0.063, 0;
50, 0.0408, 0.05, 0;
40, 0.0326, 0.04, 0;
32, 0.026, 0.032, 0;
25, 0.0204, 0.025, 0;
20, 0.016, 0.02, 0]
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  // 1 - RowId, 2 - diameter_i, 3 - diameter_o, 4 - pipe_wall_thickness//
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Table of disctrict heating pipe specifications from Rehau </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">https://www.rehau.com/uk-en/rehau-district-heating</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end DN_Rehau;
