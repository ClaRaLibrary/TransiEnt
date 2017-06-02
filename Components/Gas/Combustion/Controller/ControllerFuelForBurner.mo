within TransiEnt.Components.Gas.Combustion.Controller;
model ControllerFuelForBurner "Controller to control the fuel mass flow rate for the burner"

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

  parameter SI.Temperature T_flueGasDes=403.15 "Desired flue gas outlet temperature" annotation(Dialog(group="Fundamental Definitions"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation(Dialog(group="Control Definitions"));
  parameter Real k=1 "Gain for controller" annotation(Dialog(group="Control Definitions"));
  parameter Real Ti=0.1 "Integrator time constant" annotation(Dialog(group="Control Definitions",enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Td=0.1 "Derivative time constant" annotation(Dialog(group="Control Definitions",enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or controllerType==Modelica.Blocks.Types.SimpleController.PID));

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

  Modelica.Blocks.Interfaces.RealInput T_flueGas(
    final quantity="Temperature",
    displayUnit="degC",
    final unit="K") "Flue gas outlet temperature" annotation (Placement(transformation(extent={{120,-20},{80,20}}), iconTransformation(extent={{120,-20},{80,20}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_fuel(final quantity="MassFlowRate", final unit="kg/s") "Fuel mass flow rate entering the burner system" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.Utilities.Blocks.LimPID limPID(
    k=k,
    controllerType=controllerType,
    y_start=y_start,
    initType=initType,
    xi_start=xi_start,
    xd_start=xd_start,
    y_max=1e15,
    Tau_i=Ti,
    Tau_d=Td,
    y_min=0)
            annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={40,-50})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Blocks.Sources.Constant const(k=T_flueGasDes) annotation (Placement(transformation(extent={{88,-60},{68,-40}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(limPID.u_m, T_flueGas) annotation (Line(points={{39.9,-38},{39.9,0},{100,0}}, color={0,0,127}));
  connect(limPID.y, m_flow_fuel) annotation (Line(points={{29,-50},{0,-50},{0,-100}}, color={0,0,127}));
  connect(limPID.u_s, const.y) annotation (Line(points={{52,-50},{67,-50}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the fuel mass flow rate for the burner for a target system outlet temperature. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The temperature at the system outlet is measured and compared to the target value. The fuel is controlled using a P, PI, PD or PID controller. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>T_flueGas: Measured flue gas outlet temperature </p>
<p>m_flow_fuel: output for the fuel mass flow rate (positive sign) </p>
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
end ControllerFuelForBurner;
