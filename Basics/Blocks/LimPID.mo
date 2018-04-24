within TransiEnt.Basics.Blocks;
block LimPID "P, PI, PD, and PID controller with limited output, anti-windup compensation"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  import Modelica.Blocks.Types.InitPID;
  import Modelica.Blocks.Types.SimpleController;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  parameter Boolean with_I = controllerType==Modelica.Blocks.Types.SimpleController.PI or
                             controllerType==Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate=true, HideResult=true);
  parameter Boolean with_D = controllerType==Modelica.Blocks.Types.SimpleController.PD or
                             controllerType==Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate=true, HideResult=true);

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  //General Design of the Controller ------

public
  parameter Modelica.Blocks.Types.SimpleController controllerType=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller" annotation(Dialog(group="General Design of Controller"));
  parameter Real sign= 1 "set to 1 if a positive control error leads to a positive control output, else -1"
                                                                                       annotation(Dialog(group="General Design of Controller"));
  parameter Boolean perUnitConversion= true "True, if input and output values should be normalised with respect to reference values"
                                                                                            annotation(Dialog(group="Normalisation of I/O Signals"));
  parameter Real u_ref = 1 "Reference value for controlled variable"
                                                                    annotation(Dialog(enable=perUnitConversion, group="Normalisation of I/O Signals"));
  parameter Real y_ref = 1 "Reference value for actuated variable"
                                                                  annotation(Dialog(enable=perUnitConversion, group="Normalisation of I/O Signals"));
  parameter Real yMax=1 "Upper limit of output"
                                               annotation(Dialog(group="Limiter for Controller Output"));
  parameter Real yMin=-yMax "Lower limit of output"
                                                   annotation(Dialog(group="Limiter for Controller Output"));



  //Time Resononse of the Controller -------

  parameter Real k = 1 "Gain of Proportional block"
                                                   annotation(Dialog(group="Time Response of the Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5 "1/Ti is gain of integrator block"
                                      annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID,group="Time Response of the Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1 "Gain of derivative block"
                              annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID,group="Time Response of the Controller"));

  parameter Modelica.SIunits.Time Ni(min=100*Modelica.Constants.eps) = 0.9 "1/Ni is gain of anti-windup compensation"
                                              annotation (Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID, group="Anti-Windup Compensation"));
  parameter Real Nd = 1 "The smaller Nd, the more ideal the derivative block, setting Nd=0 introduces ideal derivative"
       annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID,group="Derivative Filtering"));

  //------------------- Controller activation --------------------

parameter Boolean use_activateInput = false "Provide Boolean input to switch controller on/off."
                                                    annotation(Dialog(tab="Controller activation"));
parameter ClaRa.Basics.Units.Time activationTime=0.0 "Time when controller is switched on. For use_activateInput==true the controller is switched on if (time>activationTime AND activateController=true)."
    annotation (Dialog(tab="Controller activation"));
parameter ClaRa.Basics.Units.Time Tau_lag_I=0.0 "Time lag for activation of integral part AFTER controller is being switched on "
    annotation (Dialog(tab="Controller activation"));

parameter Real output_inactive = 1 "Controller output if controller is not active" annotation(Dialog(tab="Controller activation"));

  //Signal Smoothening---------------------------

public
  parameter Real Tau_in(min=0)=0 "Time constant for input smoothening, Tau_in=0 refers to signal no smoothening"
      annotation(Evaluate=true,Dialog(tab="I/O Filters"));
  parameter Real Tau_out(min=0)=0 "time constant for output smoothening, Tau_out=0 refers to signal no smoothening"
           annotation(Evaluate=true, Dialog(tab="I/O Filters"));

  //Initialisation--------------------------
public
  parameter InitPID initType=Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState "Type of initialization"
                                     annotation(Evaluate=true,
      Dialog(tab="Initialization"));
  parameter Boolean limitsAtInit = true "= false, if limits are ignored during initializiation"
    annotation(Evaluate=true, Dialog(tab="Initialization",
                       enable=controllerType==SimpleController.PI or
                              controllerType==SimpleController.PID));
  parameter Real xi_start=0 "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(tab="Initialization",
                enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0 "Initial or guess value for state of derivative block"
    annotation (Dialog(tab="Initialization",
                         enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, tab=
          "Initialization"));

  //Expert Settings---------------------------------------------------------------
  parameter Real Tau_add(min=0)=0 "Set to >0 for additional state after add block in controller, if DAE-index reduction fails."
    annotation(Dialog(tab="Expert Settings", group="DAE Index Reduction"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u_s "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-200.5,-20},{-160.5,20}},
          rotation=0), iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanInput activateInput if use_activateInput "true, if controller is on"
                                annotation (Placement(transformation(extent={{-200.5,
            -100},{-160.5,-60}}), iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealOutput y "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{130,-10},{150,10}}, rotation=0),
        iconTransformation(extent={{99,-10},{119,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain P(k=k)
                     annotation (Placement(transformation(extent={{-30,90},{-11,
            109}},rotation=0)));
  Modelica.Blocks.Continuous.Integrator I(
    k=1/Ti,
    initType =    if initType == InitPID.SteadyState then
Modelica.Blocks.Types.Init.SteadyState
 else
     if initType == InitPID.InitialOutput then
Modelica.Blocks.Types.Init.InitialOutput
 else
     if initType == InitPID.InitialState then
Modelica.Blocks.Types.Init.InitialState
 else
Modelica.Blocks.Types.Init.NoInit,
    y_start=y_start/y_ref) if  with_I
    annotation (Placement(transformation(extent={{-30,10},{-10,30}},   rotation=
           0)));
  ClaRa.Components.Utilities.Blocks.DerivativeClaRa D_approx(
    k=Td,
    x_start=xd_start,
    Tau=Nd,
    initOption=if ((if initType == InitPID.SteadyState then Modelica.Blocks.Types.Init.SteadyState else if initType == InitPID.InitialOutput then Modelica.Blocks.Types.Init.InitialOutput else if initType == InitPID.InitialState then Modelica.Blocks.Types.Init.InitialState else Modelica.Blocks.Types.Init.NoInit) == Modelica.Blocks.Types.Init.SteadyState) then 502 elseif ((if initType == InitPID.SteadyState then Modelica.Blocks.Types.Init.SteadyState else if initType == InitPID.InitialOutput then Modelica.Blocks.Types.Init.InitialOutput else if initType == InitPID.InitialState then Modelica.Blocks.Types.Init.InitialState else Modelica.Blocks.Types.Init.NoInit) == Modelica.Blocks.Types.Init.InitialState) then 799 elseif ((if initType == InitPID.SteadyState then Modelica.Blocks.Types.Init.SteadyState else if initType == InitPID.InitialOutput then Modelica.Blocks.Types.Init.InitialOutput else if initType == InitPID.InitialState then Modelica.Blocks.Types.Init.InitialState else Modelica.Blocks.Types.Init.NoInit)
         == Modelica.Blocks.Types.Init.InitialOutput) then 504 elseif ((if initType == InitPID.SteadyState then Modelica.Blocks.Types.Init.SteadyState else if initType == InitPID.InitialOutput then Modelica.Blocks.Types.Init.InitialOutput else if initType == InitPID.InitialState then Modelica.Blocks.Types.Init.InitialState else Modelica.Blocks.Types.Init.NoInit) == Modelica.Blocks.Types.Init.NoInit) then 501 else 0) if with_D annotation (Placement(transformation(extent={{-30,50},{-10,69.5}}, rotation=0)));

  Modelica.Blocks.Math.Add3 addPID(
    k1=1,
    k2=1,
    k3=1)                 annotation (Evaluate=true, Placement(transformation(
          extent={{10.5,54.5},{20.5,64.5}},
                                    rotation=0)));
  Modelica.Blocks.Math.Add addI if with_I annotation (Evaluate=true, Placement(
        transformation(extent={{-5,-5},{5,5}},       rotation=0,
        origin={-60,-3.5})));
  Modelica.Blocks.Math.Gain gainTrack(k=1/Ni) if   with_I
    annotation (Placement(transformation(extent={{3,-17},{-10,-30}}, rotation=0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    limitsAtInit=limitsAtInit,
    uMax=if perUnitConversion then yMax/y_ref else yMax,
    uMin=if perUnitConversion then yMin/y_ref else yMin)
    annotation (Placement(transformation(extent={{69,57},{82,70}},  rotation=0)));

public
  Modelica.Blocks.Sources.Constant Dzero(k=0) if not with_D
    annotation (Placement(transformation(extent={{-17,36.5},{-10,43.5}},
                                                                     rotation=0)));
  Modelica.Blocks.Sources.Constant Izero(k=0) if not with_I
    annotation (Placement(transformation(extent={{-3.5,-3.75},{3.5,3.75}},
                                                                    rotation=0,
        origin={-12.5,0.25})));
  Modelica.Blocks.Math.Gain toPU(k=if perUnitConversion then sign/u_ref else
        sign) "convert input values to \"per unit\""
                                           annotation (Placement(transformation(
          extent={{-95,-5.5},{-85,5}},
                                     rotation=0)));
  Modelica.Blocks.Math.Gain fromPU(k=if perUnitConversion then y_ref else 1) "convert output values to \"Real\""
                                           annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},  rotation=0,
        origin={104,0})));

  Modelica.Blocks.Logical.Switch switch_OnOff_I if  with_I
    annotation (Placement(transformation(extent={{-49,25.5},{-38,15}})));
public
  Modelica.Blocks.Sources.Constant I_off_zero(k=0) if
                                                  with_I
    annotation (Placement(transformation(extent={{4.25,-4.5},{-4.25,4.5}},
                                                                     rotation=180,
        origin={-64.75,35})));

  Modelica.Blocks.Logical.Switch switch_OnOff
    annotation (Placement(transformation(extent={{36,72},{50,58.5}})));
  Modelica.Blocks.Sources.RealExpression y_unlocked(y=if perUnitConversion
         then output_inactive/y_ref else output_inactive)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
                                                                   rotation=180,
        origin={41,87})));
  Modelica.Blocks.Sources.BooleanExpression activation2(y=activate.y) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={41,100})));
  Modelica.Blocks.Sources.BooleanExpression I_activation(y=time_lag_I_activation.y
         > Tau_lag_I)                                                   annotation (
      Placement(transformation(
        extent={{-9,7.75},{9,-7.75}},
        rotation=0,
        origin={-67.5,20.25})));
  ClaRa.Components.Utilities.Blocks.FirstOrderClaRa smoothPIDInput(Tau=Tau_in) annotation (Placement(transformation(extent={{-110,-3.5},{-104,3}})));
  ClaRa.Components.Utilities.Blocks.FirstOrderClaRa smoothPIDOutput(Tau=Tau_out) annotation (Placement(transformation(extent={{115,-3.5},{122,3.5}})));
  Modelica.Blocks.Math.Feedback addSat
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},  rotation=180,
        origin={57.5,0})));
  Modelica.Blocks.Logical.Timer time_lag_I_activation
    annotation (Placement(transformation(extent={{-85,-63},{-72,-50}})));
  Modelica.Blocks.Routing.BooleanPassThrough activate
    annotation (Placement(transformation(extent={{-50,-78.5},{-30,-58.5}})));
  Modelica.Blocks.Sources.BooleanExpression activate_(y=time >= activationTime)
    annotation (Placement(transformation(extent={{-159,-105},{-139,-85}})));
  Modelica.Blocks.Logical.And controllerActive if
                                                 use_activateInput
    annotation (Placement(transformation(extent={{-128,-76},{-113,-61}})));
  Modelica.Blocks.Routing.BooleanPassThrough activateIfNoSwitch if not use_activateInput
    annotation (Placement(transformation(extent={{-109,-98.5},{-102,-91.5}})));
  ClaRa.Components.Utilities.Blocks.FirstOrderClaRa smoothPIDOutput1(Tau=Tau_add) annotation (Placement(transformation(extent={{56,61.5},{63,68.5}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" + String(yMax) +
                       ") < yMin (=" + String(yMin) + ")");
  if initType == InitPID.InitialOutput and (y_start < yMin or y_start > yMax) then
      Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
  end if;
  assert(limitsAtInit or not limitsAtInit and y >= yMin and y <= yMax,
         "LimPID: During initialization the limits have been switched off.\n" +
         "After initialization, the output y (=" + String(y) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P.y, addPID.u1) annotation (Line(points={{-10.05,99.5},{5,99.5},{5,63.5},
          {9.5,63.5}},
               color={0,0,127}));
  connect(D_approx.y, addPID.u2)
    annotation (Line(points={{-9,59.75},{-4.5,59.75},{-4.5,59.5},{9.5,59.5}},
                                              color={0,0,127}));
  connect(toPU.y, D_approx.u)
                       annotation (Line(points={{-84.5,-0.25},{-79.5,-0.25},{-79.5,
          59.75},{-32,59.75}},                                      color={0,0,127}));
  connect(toPU.y, P.u) annotation (Line(points={{-84.5,-0.25},{-79.5,-0.25},{-79.5,
          99.5},{-31.9,99.5}},
                color={0,0,127}));
  connect(gainTrack.y, addI.u2) annotation (Line(points={{-10.65,-23.5},{-10.65,
          -23.5},{-71,-23.5},{-71,-6.5},{-66,-6.5}},
                           color={0,0,127}));

  connect(switch_OnOff_I.y, I.u) annotation (Line(
      points={{-37.45,20.25},{-37.45,20},{-32,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(I_off_zero.y, switch_OnOff_I.u3) annotation (Line(
      points={{-60.075,35},{-55,35},{-55,24.45},{-50.1,24.45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(I.y, addPID.u3) annotation (Line(
      points={{-9,20},{5,20},{5,55.5},{9.5,55.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toPU.y, addI.u1) annotation (Line(
      points={{-84.5,-0.25},{-84.5,-0.5},{-66,-0.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addI.y, switch_OnOff_I.u1) annotation (Line(
      points={{-54.5,-3.5},{-54.5,16.05},{-50.1,16.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{140,0},{140,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, fromPU.u) annotation (Line(
      points={{82.65,63.5},{90,63.5},{90,0},{98,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(activation2.y, switch_OnOff.u2)       annotation (Line(
      points={{30,100},{23,100},{23,65.25},{34.6,65.25}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(I_activation.y, switch_OnOff_I.u2) annotation (Line(
      points={{-57.6,20.25},{-50.1,20.25}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch_OnOff.u1, addPID.y) annotation (Line(
      points={{34.6,59.85},{21,59.85},{21,59.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch_OnOff.u3, y_unlocked.y) annotation (Line(
      points={{34.6,70.65},{27,70.65},{27,87},{30,87}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothPIDInput.y, toPU.u) annotation (Line(
      points={{-103.7,-0.25},{-96,-0.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fromPU.y, smoothPIDOutput.u) annotation (Line(
      points={{109.5,0},{112,4.44089e-016},{114.3,4.44089e-016}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothPIDOutput.y, y) annotation (Line(
      points={{122.35,4.44089e-016},{129,4.44089e-016},{129,0},{140,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fromPU.u, addSat.u1) annotation (Line(
      points={{98,0},{79,0},{79,-9.79717e-016},{65.5,-9.79717e-016}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addSat.y, gainTrack.u) annotation (Line(
      points={{48.5,1.10218e-015},{27,1.10218e-015},{27,-23.5},{4.3,-23.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controllerActive.y, activate.u) annotation (Line(
      points={{-112.25,-68.5},{-52,-68.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(activateInput, controllerActive.u1) annotation (Line(
      points={{-180.5,-80},{-154,-80},{-154,-68.5},{-129.5,-68.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(activate_.y, controllerActive.u2) annotation (Line(
      points={{-138,-95},{-134,-95},{-134,-74.5},{-129.5,-74.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(controllerActive.y, time_lag_I_activation.u) annotation (Line(
      points={{-112.25,-68.5},{-103,-68.5},{-103,-56.5},{-86.3,-56.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(activate_.y, activateIfNoSwitch.u) annotation (Line(
      points={{-138,-95},{-109.7,-95}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(activateIfNoSwitch.y, time_lag_I_activation.u) annotation (Line(
      points={{-101.65,-95},{-92,-95},{-92,-56.5},{-86.3,-56.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(activateIfNoSwitch.y, activate.u) annotation (Line(
      points={{-101.65,-95},{-52,-95},{-52,-68.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(addPID.u2, Dzero.y) annotation (Line(
      points={{9.5,59.5},{-4,59.5},{-4,40},{-9.65,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Izero.y, addPID.u3) annotation (Line(
      points={{-8.65,0.25},{5,0.25},{5,55.5},{9.5,55.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch_OnOff.y, smoothPIDOutput1.u) annotation (Line(
      points={{50.7,65.25},{52.85,65.25},{52.85,65},{55.3,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothPIDOutput1.y, limiter.u) annotation (Line(
      points={{63.35,65},{65,65},{65,63.5},{67.7,63.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothPIDOutput1.y, addSat.u2) annotation (Line(
      points={{63.35,65},{64,65},{64,8},{57.5,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothPIDInput.u, u_s) annotation (Line(
      points={{-110.6,-0.25},{-135.8,-0.25},{-135.8,0},{-180.5,0}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (defaultComponentName="PID",
  Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This component was created automatically from a previous version of the model <b>ClaRa.Components.Utilities.Blocks.LimPID</b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model revised by Boris Michaelsen (XRG Simulation GmbH), Apr 2009</p>
<p>Model modified by Friedrich Gottelt (XRG Simulation GmbH), Nov 2009 : Update to independently set the gain and time constants of the PID, added a new parameter \\&quot;sign\\&quot; for case dependent control error evaluation</p>
<p>Model modified by Pascal Dubucq (dubucq@tuhh.de), Apr 2017 : Added Transient license header</p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-80,-80},{-80,50},{-80,-20},{30,60},{80,60}}, color={0,
              0,127}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,-20},{80,-60}},
          lineColor={192,192,192},
          textString="PID"),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
                                Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={27,36,42},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={0,131,169}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={0,131,169}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,50},{-80,-20},{30,60},{80,60}}, color={27,36,
              42}),
        Text(
          extent={{-20,-20},{80,-60}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          textString="PID"),
        Text(
          extent={{-100,130},{100,100}},
          lineColor={27,36,42},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-100},{130,120}},
        grid={1,1}), graphics));
end LimPID;
