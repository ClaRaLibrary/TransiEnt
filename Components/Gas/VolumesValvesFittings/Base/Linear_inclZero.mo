within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
model Linear_inclZero
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp(hasPressureLoss=true);

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.MassFlowRate m_flow_nom=10;
  parameter SI.PressureDifference dp_nom=1000 "Nominal pressure loss";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.PressureDifference dp;
  SI.MassFlowRate m_flow;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  if noEvent(dp_nom == 0) then
    dp = 0;
  else
    m_flow = m_flow_nom*dp/dp_nom;
  end if;
  annotation (defaultConnectionStructurallyInconsistent=true,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">A linear pressure loss model for junctions which works for dp_nom=0 as well. This model is a modified version of ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (version 1.3.0).</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Copied and changed from ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (version 1.3.0).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode (c.bode@tuhh.de), Sep 2019</span></p>
</html>"));
end Linear_inclZero;
