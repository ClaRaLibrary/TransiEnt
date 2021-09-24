within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
partial model PressureLoss_L4_extICom "VLE || PL Base Class with extended iCom"


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



  extends ClaRa.Basics.Icons.Delta_p;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4;
  outer parameter Boolean frictionAtInlet;
  outer parameter Boolean frictionAtOutlet;
  import SI = ClaRa.Basics.Units;
  outer TransiEnt.Components.Gas.VolumesValvesFittings.Base.IComVLE_L3_OnePort_extended iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  final parameter SI.MassFlowRate m_flow_nom=iCom.m_flow_nom "Nominal mass flow rate";

  final parameter SI.PressureDifference Delta_p_nom=iCom.Delta_p_nom "Nominal pressure loss wrt. all parallel tubes";

  SI.PressureDifference Delta_p[geo.N_cv + 1] "Pressure difference";
  SI.MassFlowRate m_flow[geo.N_cv + 1];

  annotation (Icon(graphics), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L4 but with extended iCom.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Copied and changed fromClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L4 (version 1.5.1).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Robert Flesch (flesch@xrg-simulation.de), Sep 2020</span></p>
</html>"));
end PressureLoss_L4_extICom;
