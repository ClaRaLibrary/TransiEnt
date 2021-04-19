within TransiEnt.Producer.Heat.SolarThermal.Control;
model ControllerPumpSolarCollectorTandG "Model for controlling the pump drive supplying of the collector field"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
import SI = Modelica.SIunits;

// _____________________________________________
//
//        Constants and Parameters
// _____________________________________________

//General
parameter SI.Irradiance G_min=0 "minimum Irradiance before collector is working" annotation (Dialog(tab="General", group="General"));
parameter SI.Temperature T_set=323.15 "Temperature set point for controller" annotation (Dialog(tab="General", group="General"));
parameter SI.MassFlowRate m_flow_min=0.01 "minimum massflow" annotation (Dialog(tab="General", group="General"));
parameter SI.Pressure Delta_p=0 "Pressure loss of the system at minimum massflow" annotation (Dialog(tab="General", group="General"));
parameter SI.Efficiency eta_mech=0.98 "mechanic efficiency of the drive" annotation (Dialog(tab="General", group="General"));
parameter SI.Density rho_m=1000 "Fluid Density - mean value" annotation (Dialog(tab="General", group="General"));
parameter SI.Temperature T_stor_max= 273.15+90 "Maximum Temperature at which collector is turned off" annotation (Dialog(tab="General", group="General"));
parameter SI.Temperature T_min= 273.15 "MinimumTemperature at which collector is turned off" annotation (Dialog(tab="General", group="General"));

//first Order transfer function
parameter Real k_first(unit="1")=1 "Gain" annotation (Dialog(tab="General", group="first order transfer function"));
parameter SI.Time T(start=1) "Time Constant" annotation (Dialog(tab="General", group="first order transfer function"));
parameter Modelica.Blocks.Types.Init initType_first=Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3/4: initial output)"   annotation (Dialog(tab="General", group="first order transfer function"));
parameter Real y_start_first=0 "Initial or guess value of output (= state)" annotation (Dialog(tab="General", group="first order transfer function"));

//PID
parameter Modelica.Blocks.Types.SimpleController controllerType= Modelica.Blocks.Types.SimpleController.PID "Type of controller" annotation (Dialog(tab="PID", group="Parameters"));
parameter Real k_PID(min=0, unit="1") = 1 "Gain of controller" annotation (Dialog(tab="PID", group="Parameters"));
parameter SI.Time Ti(min=Modelica.Constants.small)=0.5 "Time constant of Integrator block" annotation(Dialog(tab="PID", group="Parameters",enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter SI.Time Td(min=0)= 0.1 "Time constant of Derivative block" annotation(Dialog(tab="PID", group="Parameters", enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter Real yMax(start=1) "Upper limit of output"
                                                    annotation (Dialog(tab="PID", group="Parameters"));
parameter Real yMin=0 "Lower limit of output" annotation (Dialog(tab="PID", group="Parameters"));
parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)"
                                                                             annotation (Dialog(tab="PID", group="Parameters"));
parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)" annotation(Dialog(tab="PID", group="Parameters", enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9 "Ni*Ti is time constant of anti-windup compensation" annotation(Dialog(tab="PID", group="Parameters", enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter Real Nd(min=100*Modelica.Constants.eps) = 10 "The higher Nd, the more ideal the derivative block" annotation (Dialog(tab="PID", group="Parameters"));

//PID Initialization
parameter Modelica.Blocks.Types.InitPID initType_PID= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation(Evaluate=true, Dialog(tab="PID", group="Initialization"));
parameter Boolean limitsAtInit = true "= false, if limits are ignored during initialization" annotation(Evaluate=true, Dialog(tab="PID",group="Initialization"));
parameter Real xi_start=0 "Initial or guess value value for integrator output (= integrator state)" annotation (Dialog(tab="PID", group="Initialization", enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter Real xd_start=0 "Initial or guess value for state of derivative block" annotation (Dialog(tab="PID", group="Initialization", enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or controllerType==Modelica.Blocks.Types.SimpleController.PID));
parameter Real y_start_PID=0 "Initial value of output" annotation(Dialog(tab="PID", enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, group= "Initialization"));
parameter Boolean strict=false "= true, if strict limits with noEvent(..)" annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="PID", group="Advanced"));

//numerical stablity
parameter Real eps=1e-6 "smallest output" annotation (Dialog(tab="Expert Settings"));

// _____________________________________________
//
//           Instances of other Classes
// _____________________________________________

  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=controllerType,
    k=k_PID,
    Ti=Ti,
    Td=Td,
    wp=wp,
    wd=wd,
    Ni=Ni,
    Nd=Nd,
    yMax=yMax,
    yMin=yMin,
    initType=initType_PID,
    limitsAtInit=limitsAtInit,
    xi_start=xi_start,
    xd_start=xd_start,
    y_start=y_start_PID,
    strict=strict)
           annotation (Placement(transformation(extent={{30,-2},{50,18}})));
  Modelica.Blocks.Sources.Constant set_point_temp(k=T_set) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-34,-26})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=T,
    y_start=y_start_first,
    k=k_first,
    initType=initType_first)                            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-34,8})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation (Placement(transformation(extent={{-44,-64},{-24,-44}})));
  Modelica.Blocks.Sources.Constant min_irradiance(k=G_min) annotation (Placement(transformation(extent={{12,-88},{-8,-68}})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-74,76})));
  Modelica.Blocks.Sources.Constant zero(k=eps)
                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-20,94})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_out annotation (Placement(transformation(extent={{-148,-28},{-120,0}}), iconTransformation(extent={{-160,-40},{-120,0}})));
  Modelica.Blocks.Interfaces.RealInput G_total annotation (Placement(transformation(extent={{-148,-78},{-120,-50}}), iconTransformation(extent={{-160,-90},{-120,-50}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_drive annotation (Placement(transformation(extent={{-120,16},{-148,44}}), iconTransformation(extent={{-120,40},{-160,80}})));
  Modelica.Blocks.Sources.Constant P_drive_min(k=m_flow_min*Delta_p/(eta_mech*rho_m)) annotation (Placement(transformation(extent={{112,48},{92,68}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-16,42},{-36,62}})));

  Modelica.Blocks.Logical.LessThreshold Lesshreshold_T_stor(threshold=T_stor_max) annotation (Placement(transformation(extent={{-68,-120},{-48,-100}})));

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_stor
                                             annotation (Placement(transformation(extent={{-148,-122},{-120,-94}}),
                                                                                                                 iconTransformation(extent={{-160,-140},{-120,-100}})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(extent={{84,-70},{104,-50}})));

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_in annotation (Placement(transformation(extent={{-154,76},{-126,104}}), iconTransformation(extent={{-160,4},{-120,44}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold_freezingPoint(threshold=T_min)  annotation (Placement(transformation(extent={{-112,100},{-92,120}})));
  Modelica.Blocks.Logical.And and2 annotation (Placement(transformation(extent={{70,76},{50,96}})));
equation
// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(PID.u_m, set_point_temp.y) annotation (Line(points={{40,-4},{40,-26},{-23,-26}},color={0,0,127}));
  connect(firstOrder.y,PID. u_s) annotation (Line(points={{-23,8},{-23,8},{28,8}},                       color={0,0,127}));
  connect(T_out, firstOrder.u) annotation (Line(points={{-134,-14},{-66,-14},{-66,8},{-46,8}},color={0,0,127}));
  connect(min_irradiance.y, greaterEqual.u2) annotation (Line(points={{-9,-78},{-56,-78},{-56,-62},{-46,-62}}, color={0,0,127}));
  connect(add.u1, P_drive_min.y) annotation (Line(points={{-14,58},{-14,58},{91,58}}, color={0,0,127}));
  connect(add.u2, PID.y) annotation (Line(points={{-14,46},{-14,46},{72,46},{72,8},{51,8}}, color={0,0,127}));
  connect(switch2.u1, add.y) annotation (Line(points={{-62,68},{-44,68},{-44,52},{-37,52}}, color={0,0,127}));
  connect(switch2.u3, zero.y) annotation (Line(points={{-62,84},{-42,84},{-42,94},{-31,94}},        color={0,0,127}));
  connect(switch2.y, P_drive) annotation (Line(points={{-85,76},{-100,76},{-100,30},{-134,30}}, color={0,0,127}));
  connect(greaterEqual.u1, G_total) annotation (Line(points={{-46,-54},{-84,-54},{-84,-64},{-134,-64}}, color={0,0,127}));
  connect(T_stor, Lesshreshold_T_stor.u) annotation (Line(points={{-134,-108},{-70,-108},{-70,-110}}, color={0,0,127}));
  connect(Lesshreshold_T_stor.y, and1.u2) annotation (Line(points={{-47,-110},{82,-110},{82,-68}}, color={255,0,255}));
  connect(greaterEqual.y, and1.u1) annotation (Line(points={{-23,-54},{0,-54},{0,-56},{82,-56},{82,-60}}, color={255,0,255}));
  connect(T_in, greaterThreshold_freezingPoint.u) annotation (Line(points={{-140,90},{-126,90},{-126,110},{-114,110}}, color={0,0,127}));
  connect(greaterThreshold_freezingPoint.y, and2.u1) annotation (Line(points={{-91,110},{-80,110},{-80,110},{-56,110},{-56,110},{76,110},{76,86},{72,86}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{105,-60},{132,-60},{132,78},{72,78}}, color={255,0,255}));
  connect(and2.y, switch2.u2) annotation (Line(points={{49,86},{28,86},{28,76},{-62,76},{-62,76}}, color={255,0,255}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{140,120}})),Icon(graphics,
                                                                                                        coordinateSystem(extent={{-160,-120},{140,120}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller model to control the pump drive supplying of the collector field according to collector temperature and total irradiance</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in TransiEnt.Producer.Heat.SolarThermal.Check.TestCollectorFluidCycle_constProp.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
</html>"));
end ControllerPumpSolarCollectorTandG;
