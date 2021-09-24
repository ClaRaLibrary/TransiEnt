within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Controller;
model LambdaController "Controller for Lambda in Fuel Cell Applications"


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
  //             Visible Parameters
  // _____________________________________________

  parameter Real Lambda_H_target=1.5 "Constant output value";
  parameter Modelica.Units.SI.MassFlowRate m_flow_rampup=2e-5 "Constant output value";
  parameter Real k=2e-5 "Proportional gain of controller";
  parameter Modelica.Units.SI.Time T=0.01 "Time Constant of PI control (T>0 required)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u1 annotation (Placement(transformation(
          rotation=0, extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          rotation=0, extent={{98,-10},{118,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{36,10},{56,-10}})));
  Modelica.Blocks.Sources.Constant m_flow_rampup_source(k=m_flow_rampup)
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));

  Modelica.Blocks.Logical.GreaterThreshold
                                 switch2
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Modelica.Blocks.Sources.Constant const(k=-Lambda_H_target) annotation (Placement(transformation(extent={{-80,-66},{-60,-46}})));
  Modelica.Blocks.Math.Sum sum1(nin=2, k=-k*ones(sum1.nin)) annotation (Placement(transformation(extent={{-38,-50},{-18,-30}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(switch2.y, switch1.u2) annotation (Line(
      points={{-9,0},{34,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(u1, switch2.u) annotation (Line(
      points={{-100,60},{-54,60},{-54,0},{-32,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, y) annotation (Line(
      points={{57,0},{108,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_rampup_source.y, switch1.u3) annotation (Line(
      points={{-11,30},{10,30},{10,8},{34,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, sum1.u[1]) annotation (Line(points={{-59,-56},{-56,-56},{-56,-48},{-56,-41},{-40,-41}}, color={0,0,127}));
  connect(u1, sum1.u[2]) annotation (Line(points={{-100,60},{-78,60},{-54,60},{-54,-39},{-40,-39}}, color={0,0,127}));
  connect(sum1.y, switch1.u1) annotation (Line(points={{-17,-40},{10,-40},{10,-44},{10,-4},{10,-8},{34,-8}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for Lambda in Fuel Cell Applications.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: u1</p>
<p>Modelica RealOutput: y</p>
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
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) on 01.10.2014</p>
<p>Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</p>
<p>Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</p>
</html>"));
end LambdaController;
