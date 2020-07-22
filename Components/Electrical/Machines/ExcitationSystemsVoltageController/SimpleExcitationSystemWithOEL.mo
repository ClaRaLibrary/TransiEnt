within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController;
model SimpleExcitationSystemWithOEL "Simple Voltage Controller with OEL"

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

  extends TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp1);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Voltage v_n=simCenter.v_n "Nominal Voltage";
  parameter Real KA=70 "Gain of Controller";
  parameter Real KI=0.9 "Time constant of Controller";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-10,56},
            {-30,36}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=v_n) annotation (Placement(transformation(extent={{20,36},
            {0,56}})));

  TransiEnt.Components.Sensors.ElectricVoltageComplex electricVoltageComplex
    annotation (Placement(transformation(extent={{-68,64},{-48,84}})));

  Modelica.Blocks.Continuous.Integrator integrator(k=KI, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                   annotation (Placement(transformation(extent={{-12,-26},
            {8,-6}})));
  Modelica.Blocks.Math.Gain gain(k=KA) annotation (Placement(transformation(extent={{-10,8},
            {10,28}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{24,-10},
            {44,10}})));
  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.OverExcitationLimiter.OverExcitationLimiterSummation oEL_summation annotation (Placement(transformation(extent={{66,38},{88,58}})));
  Modelica.Blocks.Math.Add add1
                               annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=90,
        origin={14,78})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(feedback.u1,realExpression1. y) annotation (Line(points={{-12,46},{-1,
          46}},                                                                      color={0,0,127}));
  connect(y, y) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(electricVoltageComplex.epp, epp1) annotation (Line(
      points={{-68,74.2},{-100,74.2},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(y, add.y) annotation (Line(points={{106,0},{45,0}}, color={0,0,127}));
  connect(add.u1, gain.y) annotation (Line(points={{22,6},{18,6},{18,18},{11,18}}, color={0,0,127}));
  connect(add.u2, integrator.y) annotation (Line(points={{22,-6},{16,-6},{16,-16},
          {9,-16}},                                                                          color={0,0,127}));
  connect(gain.u, integrator.u)
    annotation (Line(points={{-12,18},{-14,18},{-14,-16}}, color={0,0,127}));
  connect(feedback.y, integrator.u) annotation (Line(points={{-29,46},{-56,46},{
          -56,6},{-14,6},{-14,-16}}, color={0,0,127}));
  connect(oEL_summation.Vf, add.y) annotation (Line(points={{66,48},{54,48},{54,0},{45,0}}, color={0,0,127}));
  connect(add1.y, feedback.u2) annotation (Line(points={{14,67},{-4,67},{-4,54},
          {-20,54}}, color={0,0,127}));
  connect(add1.u1, electricVoltageComplex.v) annotation (Line(points={{8,90},{-22,
          90},{-22,80},{-48,80}}, color={0,0,127}));
  connect(oEL_summation.Voel, add1.u2) annotation (Line(points={{88,48},{95.6,48},{95.6,90},{20,90}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Voltage Control for simple calculations with overexcitation limting</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1E Pi-Controller</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>No PSS</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp (ComplexPowerPort) for Voltage measurement and real output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>simplest voltage controler, chgosse KI=0 for no additional dynamics</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] T. Van Cutsem, &ldquo;Excitation systems and automatic voltage regulators&rdquo, lecture material &ldquo;Power system dynamics, control and stability&rdquo;, 2018 </span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Aug 2018</p>
<p>OEL added by Zahra Nadia Faili (zahra.faili@nithh.de), July 2019</p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}})),
                                                   Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-100},{120,100}})));
end SimpleExcitationSystemWithOEL;
