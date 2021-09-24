within TransiEnt.Consumer.Gas.Control;
model NCVController "Gas adaptive controller with demanded enthalpy flow rate and net calorific value as inputs and desired mass flow rate as output"

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter String mode="Consumer" annotation (Dialog(tab="General", group="Controller"), choices(choice="Consumer" "Consumer",choice="Producer" "Producer",choice="Both" "Both",__Dymola_radioButtons=true));
  parameter Boolean usePIDcontroller=true "if 'true' m_flow_desired' is calculated by PID" annotation (Dialog(tab="General", group="Controller"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation (Dialog(tab="General",group="Controller",enable=usePIDcontroller));
  parameter Real k=1 "Gain for controller" annotation (Dialog(tab="General",group="Controller",enable=usePIDcontroller));
  parameter Real Ti=0.1 "Integrator time constant" annotation (Dialog(tab="General",group="Controller",enable=usePIDcontroller));
  parameter Real Td=0.1 "Derivative time constant" annotation (Dialog(tab="General",group="Controller",enable=usePIDcontroller));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_is "Current mass flow in kg/s" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,106})));
  TransiEnt.Basics.Interfaces.General.SpecificEnthalpyIn NCV_is_sink "Actual net calorific value in sink in J/kg" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,106})));
  TransiEnt.Basics.Interfaces.General.SpecificEnthalpyIn NCV_is_source "Actual net calorific value in source in J/kg" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,106})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_desired "Desired mass flow" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow_set "Desired thermal power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

  TransiEnt.Basics.Blocks.LimPID LimPID(
    k=k,
    Tau_i=Ti,
    Tau_d=Td,
    controllerType=controllerType,
    y_max=if mode == "Consumer" or mode == "Both" then Modelica.Constants.inf else 0,
    xi_start=30,
    y_min=if mode == "Producer" or mode == "Both" then -Modelica.Constants.inf else 0) if usePIDcontroller annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,0})));
  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-26,10},{-6,-10}})));
  Basics.Blocks.SwitchLessThresholdNoEvent switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-32,44})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //             Connect Statements
  // _____________________________________________

  connect(H_flow_set, division.u1) annotation (Line(points={{-110,0},{-82,0},{-82,-6},{-28,-6}}, color={0,0,127}));
  connect(switch1.u1, NCV_is_source) annotation (Line(points={{-24,56},{-24,90},{0,90},{0,106}}, color={0,0,127}));
  connect(switch1.u3, NCV_is_sink) annotation (Line(points={{-40,56},{-40,106}}, color={0,0,127}));
  connect(switch1.y, division.u2) annotation (Line(points={{-32,33},{-32,6},{-28,6}}, color={0,0,127}));
  if not usePIDcontroller then
    connect(m_flow_desired, division.y) annotation (Line(points={{110,0},{-5,0}}, color={0,0,127}));
  else
    connect(m_flow_is, LimPID.u_m) annotation (Line(points={{40,106},{40,-18},{20.1,-18},{20.1,-12}}, color={0,0,127}));
    connect(LimPID.y, m_flow_desired) annotation (Line(points={{31,0},{110,0}}, color={0,0,127}));
    connect(division.y, LimPID.u_s) annotation (Line(points={{-5,0},{8,0}}, color={0,0,127}));
  end if;
  connect(switch1.u2, H_flow_set) annotation (Line(points={{-32,56},{-32,68},{-82,68},{-82,0},{-110,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model to control mass flow rate by measured net calorific value and given enthalpy flow rate input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>If usePIDcontroller, a LimPID controller will be used. The limits are set according to the mode (Producer, Consumer, both).</p>
<p>If not usePIDcontroller, the mass flow rate is calculated.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow_is - Current hydrogen mass flow in kg/s</p>
<p>NCV_is_sink - actual net calorific value in sink in J/kg</p>
<p>NCV_is_source - actual net calorific value in source in J/kg</p>
<p>m_flow_desired - desired mass flow in kg/s</p>
<p>H_flow_set - Desired thermal power in W</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p>Model modified by Robert Flesch (flesch@xrg-simulation.de), Nov 2020: added NCV in different flow directions </p>
</html>"));
end NCVController;
