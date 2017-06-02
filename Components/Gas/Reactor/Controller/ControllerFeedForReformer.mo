within TransiEnt.Components.Gas.Reactor.Controller;
model ControllerFeedForReformer "Controller to control the feed mass flow rate for the steam methane reformer"

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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation(Dialog(group="Control Definitions"));
  parameter Real k=1e4 "Gain for controller" annotation(Dialog(group="Control Definitions"));
  parameter Real Ti=0.1 "Integrator time constant" annotation(Dialog(group="Control Definitions",enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Td=0.1 "Derivative time constant" annotation(Dialog(group="Control Definitions",enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real t_activation=0.0 "Activation time for the controller" annotation(Dialog(group="Control Definitions"));

  parameter .Modelica.Blocks.Types.InitPID initType= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real xi_start=0 "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0 "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == .Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput m_flow_set_H2(final quantity="MassFlowRate", final unit="kg/s") "Desired hydrogen mass flow rate" annotation (Placement(transformation(extent={{128,-70},{88,-30}}), iconTransformation(extent={{108,-50},{88,-30}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_H2(
    final quantity="MassFlowRate",
    final unit="kg/s") "Actual hydrogen mass flow rate" annotation (Placement(
        transformation(extent={{128,10},{88,50}}), iconTransformation(extent={{108,
            30},{88,50}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_feed(final quantity="MassFlowRate", final unit="kg/s") "Feed mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.Utilities.Blocks.LimPID
                                       limPID(
    k=k,
    controllerType=controllerType,
    y_start=y_start,
    initType=initType,
    xi_start=xi_start,
    xd_start=xd_start,
    y_max=1e15,
    y_min=0,
    Tau_i=Ti,
    Tau_d=Td,
    t_activation=t_activation)
            annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={40,-50})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(limPID.u_s, m_flow_set_H2) annotation (Line(points={{52,-50},{108,-50}}, color={0,0,127}));
  connect(limPID.u_m, m_flow_H2) annotation (Line(points={{39.9,-38},{40,-38},{40,-26},{40,30},{108,30}},
                                                                                                        color={0,0,127}));
  connect(limPID.y, m_flow_feed) annotation (Line(points={{29,-50},{0,-50},{0,-100}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the feed mass flow rate for the steam methane reformer to produce a given hydrogen mass flow rate. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The mass flow rate of the hydrogen at the system outlet is compared to the target value. The feed is controlled using a P, PI, PD or PID controller. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>m_flow_H2: Measured hydrogen mass flow rate </p>
<p>m_flow_set_H2: Targeted hydrogen mass flow rate </p>
<p>m_flow_feed: output for the feed mass flow rate (positive sign) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) on Mon Apr 03 2017 (exchanged P controller for ClaRa LimPID controller)<br> </p>
</html>"));
end ControllerFeedForReformer;
