within TransiEnt.Components.Electrical.FuelCellSystems.Base;
model SyngasSensor "Sensor measuring fuel cell performance (including a simple gas burner model for burning of remainding H2 in flue gas)"

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
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);
  parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir Air=TransiEnt.Basics.Media.Gases.Gas_MoistAir() "Medium model of Air_AmbientCondition" annotation (choicesAllMatching);

  parameter Real eta_preheater = 1 "Efficiency of pre heater";
  parameter Modelica.SIunits.Temperature T_ambient = simCenter.T_amb_const "Ambient temperature";
  parameter Modelica.SIunits.SpecificEnthalpy H_UCH4 = 50.013e6 "Heating value of methane";
    parameter Modelica.SIunits.SpecificEnthalpy H_UH2 = 120.9e6 "Heating value of hydrogen";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn gasPortIn(Medium=Syngas) annotation (Placement(transformation(extent={{-108,-10},{-88,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut gasPortOut(Medium=Syngas) annotation (Placement(transformation(extent={{88,-10},{108,10}}), iconTransformation(extent={{88,-10},{108,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    TILMedia.Gas_pT Air_AmbientCondition(
    T=T_ambient,
    xi={0.001,0.7},
    gasType = Air,
    p=100000)      "Hier wird feuchte Luft verwendet, die aus N H2O und O besteht, deshalb kann die Komponente O hieraus verwendet werden!"
    annotation (Placement(transformation(extent={{-32,62},{-8,92}})));

    TILMedia.Gas_pT Syngas_InputCondition(
    T=inStream(gasPortIn.T_outflow),
    xi= inStream(gasPortIn.xi_outflow),
    gasType=Syngas,
    p=100000)
    annotation (extent=[-20,20; 0,40], Placement(transformation(extent={{-80,-12},{-56,12}})));

    TILMedia.Gas_pT Syngas_AmbientCondition(
    T=T_ambient,
    xi=inStream(gasPortIn.xi_outflow),
    gasType=Syngas,
    p=100000) annotation (extent=[-20,20; 0,40], Placement(transformation(extent={{6,64},{32,90}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_in_CH4;
  Modelica.SIunits.HeatFlowRate Q_flow_exhaustGasChemical;
  Modelica.SIunits.HeatFlowRate Q_flow_in_evaporator;
  Modelica.SIunits.HeatFlowRate Q_flow_exhaustGasLatent;
  Modelica.SIunits.HeatFlowRate Q_flow_in_preheater;
  Modelica.SIunits.HeatFlowRate Q_flow_in_CH4_preheat;
  Modelica.SIunits.HeatFlowRate Q_flow_in_air_preheat;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

    -Q_flow_in_CH4 = -gasPortIn.m_flow*Syngas_InputCondition.xi[1]*H_UCH4;
    -Q_flow_exhaustGasLatent = gasPortIn.m_flow*Syngas_InputCondition.cp*(T_ambient+55 - Syngas_InputCondition.T) "Wrmeleistung gegenber Referenzbedingung";
    -Q_flow_in_evaporator = gasPortIn.m_flow*Syngas_InputCondition.xi[4] *( 104.93 - 3488.7)   * 1000 "Verdampfungswrmeleistung um das Wasser zu Verdampfen und auf 500C zu bringen, Werte gasPortOut dem VDI-Wrmeatlas";
    -Q_flow_in_air_preheat = gasPortIn.m_flow*Syngas_InputCondition.xi[2]*Air_AmbientCondition.cp*( Air_AmbientCondition.T - inStream(gasPortIn.T_outflow))  /eta_preheater "Wrmeleistung um die Luft vorzuwrmen";
    -Q_flow_in_CH4_preheat = gasPortIn.m_flow*Syngas_InputCondition.xi[1]*2210*( Air_AmbientCondition.T - inStream(gasPortIn.T_outflow))  /eta_preheater "Wrmeleistung um CH4 vorzuwrmen";
    Q_flow_in_preheater = Q_flow_in_air_preheat+ Q_flow_in_CH4_preheat;
    -Q_flow_exhaustGasChemical = -gasPortIn.m_flow*Syngas_InputCondition.xi[5]*H_UH2 "Wrmeleistung um die Luft vorzuwrmen";

      // impulse equation
      gasPortIn.p = gasPortOut.p;

      // mass balance (total mass)
      gasPortIn.m_flow + gasPortOut.m_flow = 0;

      // enthalpy (kgasPortIne Wrmebergange (dynamisch) zwischen Reformer und Gas betrachtet"
     gasPortOut.T_outflow = inStream(gasPortIn.T_outflow);
     gasPortIn.T_outflow = Syngas_InputCondition.T;

      // mass fractions
      gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
      gasPortOut.xi_outflow = Syngas_InputCondition.xi;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Sensor&nbsp;measuring&nbsp;fuel&nbsp;cell&nbsp;performance&nbsp;(including&nbsp;a&nbsp;simple&nbsp;gas&nbsp;burner&nbsp;model&nbsp;for&nbsp;burning&nbsp;of&nbsp;remainding&nbsp;H2&nbsp;in&nbsp;flue&nbsp;gas)</p>
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
end SyngasSensor;