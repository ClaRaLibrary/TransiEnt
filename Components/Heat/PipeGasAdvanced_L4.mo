within TransiEnt.Components.Heat;
model PipeGasAdvanced_L4 "Pipe for gaseous media with dynamic mass balance and thermal insulation"


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

  extends ClaRa.Basics.Icons.Pipe_L4;

  import ClaRa.Basics;


  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Integer N_cv "Number of finite volumes" annotation(Dialog(group="Discretisation"));
  input ClaRa.Basics.Units.HeatFlowRate Q_flow_loss "Heat flow rate to environment";
  input ClaRa.Basics.Units.Pressure Delta_p "Pressure Drop in pipe";
  input ClaRa.Basics.Units.Temperature[N_cv] T_air "Air Temperature";
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeGas inlet;
  ClaRa.Basics.Records.FlangeGas outlet;
end Summary;






  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation"), choicesAllMatching);

parameter TILMedia.GasTypes.BaseGas medium_fluid=simCenter.airModel "Medium to be used for gas flow"
  annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

parameter ClaRa.Basics.Units.Length length = 10 "Pipe Length" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/figures/ParameterDialog/HEX_ParameterDialog_BUshellgas2.png"));
parameter ClaRa.Basics.Units.Length diameter = 1 "Pipe Diameter" annotation (Dialog(group="Geometry"));
parameter ClaRa.Basics.Units.Length wall_thickness = 0.005 "Pipe Wall Thickness" annotation (Dialog(group="Geometry"));
parameter Integer N_cv=3 "Number of control volumes" annotation (Dialog(group="Fundamental Definitions"));
parameter Integer N_pipes=1 "Number of Pipes in parallel" annotation (Dialog(group="Geometry"));

parameter Boolean frictionAtInlet=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Geometry"));
parameter Boolean frictionAtOutlet=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Geometry"));

parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(group="Nominal Values"));
parameter ClaRa.Basics.Units.Pressure p_nom = simCenter.p_amb_start "Nominal pressure" annotation (Dialog(group="Nominal Values"));
parameter Basics.Units.Pressure Delta_p_nom= 100 "Nominal pressure loss" annotation (Dialog(group="Nominal Values"));
parameter Basics.Units.Temperature T_nom = simCenter.T_amb_start "Nominal temperature" annotation (Dialog(group="Nominal Values"));

parameter ClaRa.Basics.Units.Temperature T_start[N_cv]=fill(simCenter.T_amb_start,N_cv) "Start value of system Temperature" annotation (Dialog(tab="Initialisation"),HideResult = true);
parameter ClaRa.Basics.Units.Pressure p_start[N_cv]=fill(simCenter.p_amb_start, N_cv) "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"),HideResult = true);
parameter ClaRa.Basics.Units.MassFraction xi_start[medium_fluid.nc - 1]=simCenter.airModel.xi_default "Start value of shell mass fraction" annotation (Dialog(tab="Initialisation"),HideResult = true);
inner parameter Integer initOption=0 "Type of shell initialisation" annotation (Dialog(tab="Initialisation"), choices(
     choice=0 "Use guess values",
     choice=1 "Steady state",
     choice=201 "Steady pressure",
     choice=202 "Steady enthalpy",
     choice=208 "Steady pressure and enthalpy",
     choice=210 "Steady density"));

parameter Boolean showData=false "True if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"  annotation(Dialog(tab="Summary and Visualisation"));

parameter ClaRa.Basics.Units.Length z_in=1 "Inlet position from bottom" annotation (Dialog(group="Geometry"));
parameter ClaRa.Basics.Units.Length z_out=1 "Outlet position from bottom" annotation (Dialog(group="Geometry"));


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

outer TransiEnt.SimCenter simCenter;



  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

ClaRa.Basics.Interfaces.GasPortIn inlet(
    Medium=medium_fluid,
    p(min=0.5e5, max=1.5e5),
    T_outflow(min=200, max=1200)) annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})), HideResult=true);
ClaRa.Basics.Interfaces.GasPortOut outlet(
    Medium=medium_fluid,
    p(min=0.5e5, max=1.5e5),
    T_outflow(min=200, max=1200)) annotation (Placement(transformation(extent={{-148,-10},{-128,10}}), iconTransformation(extent={{-148,-10},{-128,10}})), HideResult=true);


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "Pressure loss model"  annotation (Dialog(
      group="Mass Transfer"), choicesAllMatching);

replaceable model HeatTransfer =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
   constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4 "Heat transfer model"  annotation (Dialog(
       group="Heat Transfer"), choicesAllMatching);

replaceable model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                     constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
                                                                                                                         "Thermal Insulation model"                  annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

 replaceable model medium_wall = TILMedia.SolidTypes.TILMedia_Steel constrainedby TILMedia.SolidTypes.BaseSolid "Medium model for pipe wall" annotation (Dialog(group="Fundamental Definitions"),__Dymola_choicesAllMatching=true);




ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4_advanced airVolume(
  medium=medium_fluid,
  m_flow_nom=m_flow_nom,
  useHomotopy=useHomotopy,
  p_start=p_start,
  frictionAtInlet=frictionAtInlet,
  frictionAtOutlet=frictionAtOutlet,
  Delta_p_nom=Delta_p_nom,
  m_flow_start=zeros(N_cv + 1),
  initOption=0,
  xi_start={0,0,0,0,0.7812,0.2096,0,0,0},
  T_start=T_start,
  redeclare model PressureLoss = PressureLoss,
  xi_nom=simCenter.airModel.xi_default,
  T_nom=T_nom*ones(N_cv),
  redeclare model HeatTransferOuter = HeatTransfer,
  p_nom=p_nom*ones(N_cv),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        z_in=z_in,
        z_out=z_out,
        N_cv=N_cv,
        diameter=diameter,
        length=length,
        N_tubes=N_pipes))
                        annotation (Placement(transformation(
      extent={{-14,6},{14,-6}},
      rotation=180,
      origin={0,8.88178e-16})));

   ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 cylindricalThinWall_L4_1(
  CF_lambda=1,
  N_ax=N_cv,
  diameter_o=diameter + 2*wall_thickness,
  diameter_i=diameter,
  length=length,
  T_start=T_start,
  redeclare model Material = medium_wall,
  N_tubes=N_pipes)                                                      annotation (Placement(transformation(extent={{-14,14},{14,24}})));

Insulation insulation(
  final N_cv=N_cv,
  final length=length,
  final circumference=N_pipes*Modelica.Constants.pi*(diameter + 2*wall_thickness)) annotation (Placement(transformation(extent={{52,20},{32,36}})));

public
  Summary summary(
    outline(
      N_cv=N_cv,
      Q_flow_loss=insulation.summary.Q_flow_loss,
      Delta_p=airVolume.fluidInlet.p - airVolume.fluidOutlet.p,
      T_air=airVolume.T),
    inlet(
      mediumModel=medium_fluid,
      m_flow=inlet.m_flow,
      T=airVolume.fluidInlet.T,
      p=airVolume.fluidInlet.p,
      h=airVolume.fluidInlet.h,
      xi=airVolume.fluidInlet.xi,
      H_flow=inlet.m_flow*airVolume.fluidInlet.h),
    outlet(
      mediumModel=medium_fluid,
      m_flow=outlet.m_flow,
      T=airVolume.fluidOutlet.T,
      p=airVolume.fluidOutlet.p,
      h=airVolume.fluidOutlet.h,
      xi=airVolume.fluidOutlet.xi,
      H_flow=outlet.m_flow*airVolume.fluidOutlet.h)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-30})));




equation


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(airVolume.outlet, outlet) annotation (Line(
      points={{-14,8.88178e-16},{-44,8.88178e-16},{-44,0},{-138,0}},
      color={118,106,98},
      thickness=0.5));
  connect(airVolume.inlet, inlet) annotation (Line(
      points={{14,-2.22045e-15},{14,0},{140,0}},
      color={118,106,98},
      thickness=0.5));

connect(cylindricalThinWall_L4_1.outerPhase, insulation.heat) annotation (Line(
    points={{0,24},{0,28},{32,28}},
    color={167,25,48},
    thickness=0.5));
  connect(cylindricalThinWall_L4_1.innerPhase, airVolume.heatOuter) annotation (Line(
      points={{0,14},{2.77556e-16,4.8}},
      color={167,25,48},
      thickness=0.5));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-40},{140,40}}),graphics={
      Polygon(
        points={{-132,34},{-114,34},{-114,-34},{-132,-34}},
        pattern=LinePattern.None,
        smooth=Smooth.None,
        fillColor= {118,106,98},
        fillPattern=FillPattern.Solid,
        visible=frictionAtOutlet),
      Polygon(
        points={{132,34},{114,34},{114,-34},{132,-34}},
        pattern=LinePattern.None,
        smooth=Smooth.None,
        fillColor= {118,106,98},
        fillPattern=FillPattern.Solid,
        visible=frictionAtInlet)}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
                 extent={{-140,-40},{140,40}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Pipe model using the advanced gas control volumes with dynamic momentum balance from the ClaRa and a thermal insulation model.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ol>
<li>Fluid Inlet</li>
<li>Fluidr Outlet</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>"));
end PipeGasAdvanced_L4;
