within TransiEnt.Producer.Gas.BiogasPlant.Base;
model Control_m_flow "Mass flow controller model"


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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real m_flow_max=1 "maximum mass flow through the heating system";
  parameter Real m_flow_min=0 "minimum mass flow through the heating system";

  parameter Real k_P "proportional gain";
  parameter Real k_I "integral gain";
  parameter Real k_D "derivative gain";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput T_reac_target "Input for target temperature of the reaction" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput T_reac "Input for temperature of the reaction" annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow "Input for mass flow rate" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID(
    k=k_P,
    Tau_d=k_D/k_P,
    y_max=m_flow_max,
    y_min=m_flow_min,
    Tau_i=k_P/k_I,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{12,-10},{32,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(PID.y, m_flow) annotation (Line(points={{33,0},{110,0}}, color={0,0,127}));
  connect(T_reac, PID.u_m) annotation (Line(points={{-120,60},{-50,60},{-50,-12},{22.1,-12}}, color={0,0,127}));
  connect(T_reac_target, PID.u_s) annotation (Line(points={{-120,-60},{-56,-60},{-56,0},{10,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for controlling the mass flow of the heat exchanger in the reactor using a PID controller</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TemperatureInput&nbsp;T_reac_target</p>
<p>TemperatureInput&nbsp;T_reac</p>
<p>Input for mass flow rate&nbsp;m_flow</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end Control_m_flow;
