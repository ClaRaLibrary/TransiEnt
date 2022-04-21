within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes;
model DN_IsoPlus



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





  extends TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes.DN_table_base;
  constant Integer rowAmount = 25;
  constant Real DNmat[rowAmount,4] = [
750,0.746,1,0.008;
750,0.746,1,0.008;
700, 0.695, 1, 0.008;
650, 0.6458, 0.9, 0.0071;
600, 0.5958, 0.9, 0.0071;
550, 0.5462, 0.8, 0.0063;
500, 0.4954, 0.71, 0.0063;
450, 0.4444, 0.67, 0.0063;
400, 0.3938, 0.63, 0.0063;
350, 0.3444, 0.56, 0.0056;
300, 0.3127, 0.5, 0.0056;
250, 0.263, 0.45, 0.005;
225, 0.2345, 0.4, 0.005;
200, 0.2101, 0.355, 0.0045;
175, 0.1847, 0.315, 0.0045;
150, 0.1603, 0.28, 0.004;
125, 0.1325, 0.25, 0.0036;
100, 0.1071, 0.225, 0.0036;
80, 0.0825, 0.2, 0.0032;
65, 0.0697, 0.16, 0.0032;
50, 0.0539, 0.14, 0.0032;
40, 0.0419, 0.125, 0.0032;
32, 0.036, 0.11, 0.0032;
25, 0.0273, 0.09, 0.0032;
20, 0.0217, 0.09, 0.0026];

  // 1 - RowId, 2 - diameter_i, 3 - diameter_o, 4 - pipe_wall_thickness//
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Table of disctrict heating pipe specifications from IsoPlus </p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">https://www.isoplus-pipes.com/fileadmin/data/downloads/documents/germany/products/Kontirohr-8-Seiten_ENGLISCH_Web.pdf</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end DN_IsoPlus;
