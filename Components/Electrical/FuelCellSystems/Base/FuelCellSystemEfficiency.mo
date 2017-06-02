within TransiEnt.Components.Electrical.FuelCellSystems.Base;
model FuelCellSystemEfficiency "Tool to calculate the thermal and electric effiency of fuel cell system including steam reformer"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Sensor;
  import TransiEnt;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  // ingoing energy streams

  Modelica.Blocks.Interfaces.RealInput Q_flow_in_CH4 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,36})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_in_evaporator annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-4})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_in_preheater annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-46})));

  // outgoing energy streams

  Modelica.Blocks.Interfaces.RealInput Q_flow_out_exhaustGasChemical annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={68,100})));

  Modelica.Blocks.Interfaces.RealInput Q_flow_out_exhaustGasLatent annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={20,100})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_out_cooling annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-22,100})));
  Modelica.Blocks.Interfaces.RealInput P_el annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  Modelica.SIunits.Efficiency eta_th = if Q_flow_in_CH4 <= 0 then 0 else Q_gen_total/(Q_flow_in_CH4+Q_flow_in_evaporator+Q_flow_in_preheater);
  Modelica.SIunits.Efficiency eta_el = if Q_flow_in_CH4 <= 0 then 0 else P_el/(Q_flow_in_CH4+Q_flow_in_evaporator+Q_flow_in_preheater);
  Modelica.SIunits.Efficiency eta_total = eta_th + eta_el;
  Modelica.SIunits.HeatFlowRate Q_gen_total = Q_flow_out_cooling+Q_flow_out_exhaustGasLatent+Q_flow_out_exhaustGasChemical;
  Modelica.SIunits.HeatFlowRate P_gen_total = P_el;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tool&nbsp;to&nbsp;calculate&nbsp;the&nbsp;thermal&nbsp;and&nbsp;electric&nbsp;effiency&nbsp;of&nbsp;fuel&nbsp;cell&nbsp;system&nbsp;including&nbsp;steam&nbsp;reformer</p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end FuelCellSystemEfficiency;
