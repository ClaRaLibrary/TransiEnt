within TransiEnt.Components.Gas.Reactor.Controller;
model ControllerFeedForReformer "Controller to control the feed mass flow rate for the steam methane reformer"


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

  import      Modelica.Units.SI;
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

  parameter .Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation (Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi_start=0 "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0 "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == .Modelica.Blocks.Types.Init.InitialOutput,    group=
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

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_set_H2 "Desired hydrogen mass flow rate" annotation (Placement(transformation(extent={{128,-70},{88,-30}}), iconTransformation(extent={{108,-50},{88,-30}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_H2 "Actual hydrogen mass flow rate" annotation (Placement(
        transformation(extent={{128,10},{88,50}}), iconTransformation(extent={{108,
            30},{88,50}})));

  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_feed "Feed mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Blocks.LimPID limPID(
    k=k,
    controllerType=controllerType,
    y_start=y_start,
    xi_start=xi_start,
    xd_start=xd_start,
    y_max=1e15,
    y_min=0,
    Tau_i=Ti,
    Tau_d=Td,
    t_activation=t_activation,
    initOption=if ((initType) == Modelica.Blocks.Types.Init.SteadyState) then 798 elseif ((initType) == Modelica.Blocks.Types.Init.InitialOutput) then 796 elseif ((initType) == Modelica.Blocks.Types.Init.InitialState) then 797 elseif ((initType) == Modelica.Blocks.Types.Init.InitialState) then 795 else 501) annotation (Placement(transformation(
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
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                     Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the feed mass flow rate for the steam methane reformer to produce a given hydrogen mass flow rate. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The mass flow rate of the hydrogen at the system outlet is compared to the target value. The feed is controlled using a P, PI, PD or PID controller. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow_H2: Measured hydrogen mass flow rate in [kg/s]</p>
<p>m_flow_set_H2: Targeted hydrogen mass flow rate in [kg/s]</p>
<p>m_flow_feed: output for the feed mass flow rate (positive sign) in [kg/s]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) on Mon Apr 03 2017 (exchanged P controller for ClaRa LimPID controller)</p>
</html>"));
end ControllerFeedForReformer;
