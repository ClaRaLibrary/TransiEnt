within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.OverExcitationLimiter;
model OverExcitationLimiterSummation "Over Excitation Limiter acting on the summation point of voltage regulator"
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
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Voltage v_n=simCenter.v_n;
  parameter Modelica.SIunits.Voltage VfLimit=1.1*v_n;
  parameter Real L1=-20 "lower bound of OEL timer";
  parameter Real L2=5  "upper bound of OEL timer";
  parameter Real L3=1 "upper limit of integrator";
  parameter Real K2=-1 "reset constant of OEL";
  parameter Real K1=2 "";
  parameter Real K3=4 "feedback gain of OEL";
  parameter Real D= 2 "normal condition";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    Modelica.Blocks.Interfaces.RealOutput Voel
    annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Vf
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-120,-20},{-80,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Switch switchingTime
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Modelica.Blocks.Math.Feedback Feedback annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-68,0})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=VfLimit)
                                                                annotation (Placement(transformation(extent={{-20,-42},{-40,-22}})));

   Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThresholdDown(threshold=
       0)                                                                                     annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=K2)
    annotation (Placement(transformation(extent={{-8,-42},{16,-22}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(
    k=1,
    outMax=L3,
    outMin=0,
    use_reset=false,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{64,-10},{84,10}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(
    k=K1,
    outMax=L2,
    outMin=L1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=L1)
               annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  Modelica.Blocks.Math.Gain gain(k=K3) annotation (Placement(transformation(extent={{-28,30},{-8,50}})));
  TransiEnt.Basics.Blocks.UserDefinedFunction OELBlock(y=if (OELBlock.u <= D and OELBlock.u < 0) then -1 elseif (D < OELBlock.u and OELBlock.u <= 0) then 0 else OELBlock.u) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(realExpression1.y,Feedback. u2) annotation (Line(points={{-41,-32},{-68,-32},{-68,-6.4}},
                                     color={0,0,127}));
  connect(Feedback.u1,Vf)
    annotation (Line(points={{-74.4,0},{-100,0}}, color={0,0,127}));
  connect(greaterEqualThresholdDown.y,switchingTime. u2) annotation (Line(
        points={{27,0},{34,0}},                 color={255,0,255}));
  connect(realExpression.y,switchingTime. u3) annotation (Line(points={{17.2,-32},{28,-32},{28,-8},{34,-8}},
                                           color={0,0,127}));
  connect(limIntegrator1.y,greaterEqualThresholdDown. u)
    annotation (Line(points={{-1,0},{4,0}},                color={0,0,127}));
  connect(switchingTime.y, limIntegrator.u) annotation (Line(points={{57,0},{62,0}},
                                  color={0,0,127}));
  connect(gain.u, Feedback.y) annotation (Line(points={{-30,40},{-58,40},{-58,0},{-60.8,0}},
                      color={0,0,127}));
  connect(gain.y, switchingTime.u1) annotation (Line(points={{-7,40},{28,40},{28,8},{34,8}},
                            color={0,0,127}));
  connect(OELBlock.u, Feedback.y) annotation (Line(points={{-52,0},{-60.8,0}}, color={0,0,127}));
  connect(OELBlock.y, limIntegrator1.u) annotation (Line(points={{-29,0},{-24,0}}, color={0,0,127}));
  connect(limIntegrator.y, Voel) annotation (Line(points={{85,0},{100,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Overexcitation Limiter action on summation point of voltage regulator</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2E only transfer functions with PT1-elements</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(only OEL)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>real input (Vf- field voltage) and output (limiting voltage for voltage regulator)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>use in excitation systems</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] T. Van Cutsem, &ldquo;Excitation systems and automatic voltage regulators&rdquo, lecture material &ldquo;Power system dynamics, control and stability&rdquo;, 2018 </span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Zahra Nadia Faili (zahra.faili@nithh.de), Aug 2019</p>
<p>Revised and added to the TransiEnt Library by Jan-Peter Heckel (jan.heckel@tuhh.de), Dec 2019</p>
</html>"));
end OverExcitationLimiterSummation;
