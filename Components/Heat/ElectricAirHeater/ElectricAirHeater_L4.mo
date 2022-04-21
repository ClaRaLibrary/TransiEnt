within TransiEnt.Components.Heat.ElectricAirHeater;
model ElectricAirHeater_L4 "Model for air flown resistance heater"



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer N_cv "Number of finite volumes" annotation(Dialog(group="Discretisation"));
    input ClaRa.Basics.Units.HeatFlowRate E_flow "Enthalpy flow difference";
    input ClaRa.Basics.Units.HeatFlowRate Ex_flow "Enthalpy flow difference";
    input ClaRa.Basics.Units.HeatFlowRate Q_flow_loss "Heat flow rate to environment";
    input ClaRa.Basics.Units.Pressure Delta_p "Pressure Loss";
    input ClaRa.Basics.Units.Power P_el "Electric Power";
    input ClaRa.Basics.Units.Power P_el_loss "Electric Power lost at conversion";
    input ClaRa.Basics.Units.Power P_el_set "Electric Power Setpoint";
    input ClaRa.Basics.Units.Temperature[N_cv] T_air "Air Side Temperature";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas inlet;
    ClaRa.Basics.Records.FlangeGas outlet;
  end Summary;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.Length z_in=height/2 "Inlet position from bottom" annotation (Dialog(group="Geometry"));
  final parameter SI.Length z_out=height/2 "Outlet position from bottom" annotation (Dialog(group="Geometry"));


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation"), choicesAllMatching);

  parameter SI.Length length=10 "Length (flow direction)" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/figures/ParameterDialog/HEX_ParameterDialog_BUshellgas2.png"));
  parameter SI.Length height=3 "Height" annotation (Dialog(group="Geometry"));
  parameter SI.Length width=3 "Width" annotation (Dialog(group="Geometry"));
  parameter SI.Length wall_thickness = 0.005 "wall thickness" annotation (Dialog(group="Geometry"));

  parameter SI.Time timeConstant_air = 1 "Time constant for model wire dynamics" annotation (Dialog(group="Time Response Definition"));

  parameter Real eta = 0.98 "Efficiency of electric air heater" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer N_cv=3 "Number of control volumes" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Power P_el_max = 7.5e6 "Maximum power" annotation (Dialog(group="Fundamental Definitions"));

  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom= simCenter.p_amb_start "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_nom = simCenter.T_amb_start "Nominal temperature" annotation (Dialog(group="Nominal Values"));
  parameter SI.Pressure Delta_p_nom=1e3 "Nominal pressure loss" annotation (Dialog(group="Nominal Values"));

  parameter SI.Temperature T_start[N_cv]=fill(simCenter.T_amb_start,N_cv) "Start value of Temperature" annotation (Dialog(tab="Initialisation"),Hideresult = true);
  parameter SI.Pressure p_start[N_cv]=fill(simCenter.p_amb_start, N_cv) "Start value of pressure" annotation (Dialog(tab="Initialisation"),Hideresult = true);
  parameter SI.MassFraction xi_shell_start[medium1.nc - 1]= simCenter.airModel.xi_default "start value of mass fraction" annotation (Dialog(tab="Initialisation"),Hideresult = true);
  inner parameter Integer initOptionShell=0 "Type of shell initialisation" annotation (Dialog(tab="Initialisation"), choices(
       choice=0 "Use guess values",
       choice=1 "Steady state",
       choice=201 "Steady pressure",
       choice=202 "Steady enthalpy",
       choice=208 "Steady pressure and enthalpy",
       choice=210 "Steady density"));

  parameter Boolean showData=false "True if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"  annotation(Dialog(tab="Summary and Visualisation"));

  parameter TILMedia.GasTypes.BaseGas medium1=simCenter.airModel "Medium to be used for gas flow"
    annotation (Dialog(        group="Fundamental Definitions"), choicesAllMatching);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium1) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})), HideResult=true);
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium1) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})), HideResult=true);

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,102})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "Pressure loss model"  annotation (Dialog(
        group="Mass Transfer"), choicesAllMatching);

  replaceable model HeatTransferExternal = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4
                                                                                                     "Heat transfer air to wall"  annotation (Dialog(group="Heat Transfer"), choicesAllMatching);

  replaceable model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                       constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
                                                                                                                 "Insulation model"                             annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4_advanced airVolume(
    medium=medium1,
    use2HeatPorts=true,
    m_flow_nom=m_flow_nom,
    useHomotopy=useHomotopy,
    Delta_p_nom=Delta_p_nom,
    m_flow_start=zeros(N_cv + 1),
    initOption=0,
    T_start=T_start,
    p_start=p_start,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=simCenter.airModel.xi_default,
    redeclare model HeatTransferInner = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    xi_start=simCenter.airModel.xi_default,
    p_nom=p_nom*ones(N_cv),
    T_nom=T_nom*ones(N_cv),
    redeclare model HeatTransferOuter = HeatTransferExternal,
    redeclare model Geometry = TransiEnt.Components.Heat.ElectricAirHeater.Basics.ElectricHeater_N_cv (
        N_cv=N_cv,
        height=height,
        width=width,
        length=length,
        z_in=z_in,
        z_out=z_out)) annotation (Placement(transformation(
        extent={{14,5},{-14,-5}},
        rotation=180,
        origin={0,0})));

    Modelica.Blocks.Math.Gain gain(k=eta) annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

public
  Summary summary(
    outline(
      N_cv=N_cv,
      E_flow=-airVolume.inlet.m_flow*airVolume.fluidInlet.h - airVolume.outlet.m_flow*airVolume.fluidOutlet.h,
      Ex_flow=summary.outline.E_flow - simCenter.T_amb*(-airVolume.inlet.m_flow*airVolume.fluidInlet.s - airVolume.outlet.m_flow*airVolume.fluidOutlet.s),
      Q_flow_loss=insulation.summary.Q_flow_loss,
      Delta_p=airVolume.fluidInlet.p - airVolume.fluidOutlet.p,
      P_el=epp.P,
      P_el_loss=(1 - eta)*epp.P,
      P_el_set=P_el_set,
      T_air=airVolume.T),
    inlet(
      mediumModel=medium1,
      m_flow=inlet.m_flow,
      T=airVolume.fluidInlet.T,
      p=airVolume.fluidInlet.p,
      h=airVolume.fluidInlet.h,
      xi=airVolume.fluidInlet.xi,
      H_flow=inlet.m_flow*airVolume.fluidInlet.h),
    outlet(
      mediumModel=medium1,
      m_flow=outlet.m_flow,
      T=airVolume.fluidOutlet.T,
      p=airVolume.fluidOutlet.p,
      h=airVolume.fluidOutlet.h,
      xi=airVolume.fluidOutlet.xi,
      H_flow=outlet.m_flow*airVolume.fluidOutlet.h)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-74})));


  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow   prescribedHeatFlow(
    length=length,
    N_axial=N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid({0}, length, N_cv))
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power Power annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=timeConstant_air) annotation (Placement(transformation(extent={{-28,40},{-8,60}})));

  Insulation insulation(
    final N_cv=N_cv,
    final length=length,
    final circumference=2*width + 2*height) annotation (Placement(transformation(extent={{60,-48},{40,-32}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    thickness_wall=wall_thickness,
    length=length,
    width=2*height + 2*width,
    T_start=T_start,
    N_ax=N_cv) annotation (Placement(transformation(extent={{12,-26},{32,-16}})));

  Modelica.Blocks.Nonlinear.VariableLimiter
                                    PowerLimit(strict=true)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=P_el_max)
    annotation (Placement(transformation(extent={{-138,48},{-118,68}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-130,28},{-118,40}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________


  SI.Power P_check "For verification purpose";
  SI.Energy E_check "For verification purpose";



equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   P_check = summary.inlet.H_flow + summary.outlet.H_flow  + gain.y - summary.outline.Q_flow_loss;
   der(E_check) = P_check;

for i in 1:N_cv loop
  assert(prescribedHeatFlow.port[i].Q_flow < 1e-1,  "electrically generated heat must be positive in every cell");
end for;


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(airVolume.outlet, outlet) annotation (Line(
      points={{14,-1.11022e-15},{14,0},{100,0}},
      color={118,106,98},
      thickness=0.5));
  connect(airVolume.inlet, inlet) annotation (Line(
      points={{-14,2.22045e-15},{-14,0},{-100,0}},
      color={118,106,98},
      thickness=0.5));
  connect(Power.epp, epp) annotation (Line(
      points={{-10,-50},{-18,-50},{-18,-80},{0,-80},{0,-100}},
      color={0,135,135},
      thickness=0.5));
  connect(gain.y, firstOrder.u) annotation (Line(points={{-39,50},{-30,50}}, color={0,0,127}));
  connect(firstOrder.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-7,50},{0,50}},  color={0,0,127}));
  connect(wall.innerPhase, insulation.heat) annotation (Line(
      points={{22,-26},{22,-40},{40,-40}},
      color={167,25,48},
      thickness=0.5));
  connect(P_el_set, PowerLimit.u) annotation (Line(points={{0,102},{0,70},{-108,70},{-108,50},{-102,50}}, color={0,0,127}));
  connect(PowerLimit.y, gain.u) annotation (Line(points={{-79,50},{-62,50}}, color={0,0,127}));
  connect(PowerLimit.y, Power.P_el_set) annotation (Line(points={{-79,50},{-70,50},{-70,-30},{-6,-30},{-6,-38}}, color={0,0,127}));
  connect(realExpression1.y, PowerLimit.limit1) annotation (Line(points={{-117,58},{-102,58}}, color={0,0,127}));
  connect(const.y, PowerLimit.limit2) annotation (Line(points={{-117.4,34},{-110,34},{-110,42},{-102,42}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, airVolume.heatInner) annotation (Line(
      points={{20,50},{30,50},{30,22},{-8,22},{-8,4}},
      color={167,25,48},
      thickness=0.5));
  connect(airVolume.heatOuter, wall.outerPhase) annotation (Line(
      points={{0,4},{0,12},{22,12},{22,-16}},
      color={167,25,48},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Line(
          points={{-60,100},{-60,-20}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-60,-42},{-36,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-44,-42},{-20,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-28,-42},{-4,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-12,-42},{12,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{60,100},{60,-20}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{4,-42},{28,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{20,-42},{44,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{36,-42},{60,0}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple model for electric resistance heater. It determines the outlet temperature and electric power intake as well as heat and pressure losses according to the electric power set point and inlet air conditions. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<ul>
<li>The thermal dynamics are simplified with PT1 for heat release time delay due to thermal capacity of wire.</li>
<li>Constant efficiency is assumed (for losses in transformer, power electronics etc.)</li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ol>
<li>Air Inlet</li>
<li>Air Outlet</li>
<li>Electric Power setpoint</li>
<li>Physical active power port</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>The model has been validated with the electric heater unit of the Electric Thermal Energy Storage demonstration plant of Siemens Gamesa Renewable Energy in Hamburg-Bergedorf, Germany.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] M. von der Heyde, Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES), BMWI 03ET6072C, 2021</p>
<p>[2] M. von der Heyde, Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, 2021</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>"));
end ElectricAirHeater_L4;
