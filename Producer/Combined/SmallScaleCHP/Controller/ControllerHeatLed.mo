within TransiEnt.Producer.Combined.SmallScaleCHP.Controller;
model ControllerHeatLed "Controller that gets target temperatures from simCenter and has an input for storage Temperature"


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
  import TransiEnt;
  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartialCHPController;

  // _____________________________________________
  //
  //           Constants and Parameters
  // _____________________________________________
  parameter Integer nDevices=1 "Number of CHP Units";
  parameter Modelica.Units.SI.Temperature T_turnOn=333.15 "Minimal allowed return/storage temperature";
  //   parameter SI.Temperature softlimitTemperature = T_turnOff-10
  //     "Temperature at which CHP will stop charging storage";
  parameter Modelica.Units.SI.Temperature T_turnOff=363.15 "Maximum allowed Storage temperature";

  parameter Boolean useT_stor=false "if false T_return will be used";
  parameter Modelica.Units.SI.Temperature T_stor_target=363.15 "Target Storage Temperature" annotation (Dialog(enable=useT_stor));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID "Type of controller" annotation(Dialog(tab="Controller"));
  parameter Real k(
    min=0,
    unit="1") = 1 "Gain of controller" annotation(Dialog(tab="Controller"));
  parameter Modelica.Units.SI.Time Ti(
    min=Modelica.Constants.small,
    start=0.5) = 0.1 "Time constant of Integrator block" annotation (Dialog(tab="Controller", enable=controllerType == Modelica.Blocks.Types.SimpleController.PI or controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    min=0,
    start=0.1) = 0 "Time constant of Derivative block" annotation (Dialog(tab="Controller", enable=controllerType == Modelica.Blocks.Types.SimpleController.PD or controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1) = nDevices*Specification.P_el_max "Upper limit of output"
                                                                                        annotation(Dialog(tab="Controller"));
  parameter Real yMin=Specification.P_el_min "Lower limit of output" annotation(Dialog(tab="Controller"));
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)" annotation(Dialog(tab="Controller"));
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)" annotation(Dialog(tab="Controller",enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9 "Ni*Ti is time constant of anti-windup compensation"  annotation(Dialog(tab="Controller",enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10 "The higher Nd, the more ideal the derivative block" annotation(Dialog(tab="Controller",enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation (Evaluate=true, Dialog(tab="Controller", group="Initialization"));
  parameter Boolean limitsAtInit=true "= false, if limits are ignored during initializiation" annotation(Evaluate=true, Dialog(tab="Controller",group="Initialization",
                       enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xi_start=0 "Initial or guess value value for integrator output (= integrator state)" annotation (Dialog(tab="Controller",group="Initialization",
                enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0 "Initial or guess value for state of derivative block" annotation (Dialog(tab="Controller",group="Initialization",
                         enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=Specification.P_el_max "Initial value of output" annotation(Dialog(tab="Controller",enable=initType == Modelica.Blocks.Types.Init.InitialOutput,    group=
          "Initialization"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
  Boolean offCondition;
  Boolean onCondition;
  Modelica.Units.SI.Temperature T_return_target;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Blocks.Continuous.LimPID PID(
    Ti=Ti,
    Td=Td,
    k=k,
    xi_start=xi_start,
    y_start=y_start,
    initType=initType,
    wp=wp,
    Nd=Nd,
    wd=wd,
    yMax=yMax,
    yMin=yMin) annotation (Placement(transformation(extent={{-12,20},{8,0}})));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_stor_in if useT_stor annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,100}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={60,-80})));
protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_meas "Internal connector for T_stor";

  // _____________________________________________
  //
  //         Instances of other classes
  // _____________________________________________
public
  Modelica.Blocks.Math.Gain signChanger(k=1) annotation (Placement(transformation(extent={{56,6},{64,14}})));

equation
  onCondition = (not switch) and ((T_return < T_turnOn) and PID.u_m <
    T_turnOn and (time - stopTime) > t_OnOff);
  offCondition = (T_return > T_return_max) or T_meas>T_turnOff
     and (timer.y) > t_OnOff;
  //Power off if T_return too high:
  if ((pre(switch) == true) and pre(offCondition)) then
    switch = false;
    //Power on if T_return too low:
  elseif ((pre(switch) == false) and pre(onCondition)) then
    switch = true;
    //else: keep doing whatever you where doing
  else
    switch = pre(switch);
  end if;

  T_return_target = simCenter.heatingCurve.T_return;
  if useGridTemperatures then
    PID.u_s=simCenter.heatingCurve.T_return;
  else
    PID.u_s = T_stor_target;
  end if;
  if useT_stor then
    connect(PID.u_m, T_stor_in)  annotation (Line(
      points={{-2,22},{-2,100}},
      color={0,0,127},
      smooth=Smooth.None));

    //Emergency Shutdown when return Temperature too high
  else
    connect(PID.u_m, T_return)  annotation (Line(
      points={{-2,22},{-2,50},{80,50}},
      color={0,0,127},
      smooth=Smooth.None));

  end if;

  if (not useT_stor) then
    T_meas = T_stor_target;
  end if;

  connect(T_stor_in, T_meas);
  connect(PID.y, signChanger.u) annotation (Line(points={{9,10},{55.2,10}}, color={0,0,127}));
  connect(signChanger.y, P_el_set) annotation (Line(points={{64.4,10},{64.4,10},{80,10}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for heat-led control of CHP.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>controlBus</p>
<p>T_stor_in: input for temperature in [K]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end ControllerHeatLed;
