within TransiEnt.Components.Heat.ThermalInsulation;
model ThermalInsulation_dynamic_3ways_2layer "Thermal Insulation - dynamic - 3 ways - 2 layer"



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


   import SI = ClaRa.Basics.Units;

   extends ClaRa.Basics.Icons.WallThick;

   extends TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

    parameter SI.CoefficientOfHeatTransfer alpha_iso2ambient_top = 20 "Top Insulation Surface to Air Heat Transfer Coefficient" annotation (Dialog(group="Heat Transfer"));

  parameter SI.CoefficientOfHeatTransfer alpha_iso2ambient_sides = 20 "Sides Insulation Surface to Air Heat Transfer Coefficient" annotation (Dialog(group="Heat Transfer"));

  parameter SI.Temperature[2*N_iso] T_start_top = ones(2*N_iso)*simCenter.T_amb_start  annotation (Dialog(group="Initialization"));
  parameter SI.Temperature[2*N_iso] T_start_sides = ones(2*N_iso)*simCenter.T_amb_start  annotation (Dialog(group="Initialization"));
  parameter SI.Temperature[2*N_iso] T_start_bottom = ones(2*N_iso)*simCenter.T_amb_start  annotation (Dialog(group="Initialization"));

   parameter SI.Temperature T_earth = simCenter.T_amb_start "Bottom Temperature"  annotation (Dialog(group="Initialization"));

  parameter SI.Length thickness_top_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_top_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_sides_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

    parameter SI.Length thickness_sides_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_bottom_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_bottom_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter Real topPart = 1/3 "Relative partition of top Insulation" annotation (Dialog(group="Geometry"));
  parameter Real sidesPart = 1/3 "Relative partition of sides Insulation" annotation (Dialog(group="Geometry"));
  parameter Real bottomPart = 1/3 "Relative partition of bottom Insulation" annotation (Dialog(group="Geometry"));

    parameter Boolean useAxialHeatConduction=false "True, if axial heat conduction through a wall shall be considered"
                                                                                                                      annotation (Dialog(group="Heat Transfer"));


  //___________________________________________
  //
  //                 Outer Models
  // _____________________________________________


     outer ClaRa.SimCenter simCenter;


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


  replaceable model medium_top_L1 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                    constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium Top inner layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_top_L2 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                    constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium Top outer layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_sides_L1 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                      constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium Sides inner layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_sides_L2 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                      constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium sides outer layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_bottom_L1 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                       constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium bottom inner layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_bottom_L2 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                       constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium bottom outer layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));




  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment annotation (Placement(transformation(extent={{-24,-6},{-12,6}})));



  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=N_cv)
    annotation (Placement(transformation(extent={{-4,-6},{8,6}})));

  Basics.Convection_L4 convection(
    length=length,
    N_ax=N_cv,
    alpha=alpha_iso2ambient_sides,
    width=sidesPart .* circumference) annotation (Placement(transformation(extent={{32,-6},{18,8}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] sides_L2(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    redeclare each model Material = medium_sides_L2,
    each thickness_wall=thickness_sides_L2/N_iso,
    T_start={ones(N_cv)*T_start_sides[N_iso + i] for i in 1:N_iso},
    each width=sidesPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={50,0})));

   Summary summary(Q_flow_loss = environment.port.Q_flow+environment1.port.Q_flow+environment2.port.Q_flow) annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment1
                                                                          annotation (Placement(transformation(extent={{-24,-50},{-12,-38}})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(N=N_cv)
    annotation (Placement(transformation(extent={{-4,-50},{8,-38}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] bottom_L2(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    redeclare each model Material = medium_bottom_L2,
    each thickness_wall=thickness_bottom_L2/N_iso,
    T_start={ones(N_cv)*T_start_bottom[N_iso + i] for i in 1:N_iso},
    each width=bottomPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={50,-44})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment2
                                                                          annotation (Placement(transformation(extent={{-24,34},{-12,46}})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(N=N_cv)
    annotation (Placement(transformation(extent={{-4,34},{8,46}})));
  Basics.Convection_L4 convection2(
    length=length,
    N_ax=N_cv,
    alpha=alpha_iso2ambient_top,
    width=topPart .* circumference) annotation (Placement(transformation(extent={{32,34},{18,48}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] top_L2(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    redeclare each model Material = medium_top_L2,
    each thickness_wall=thickness_top_L2/N_iso,
    T_start={ones(N_cv)*T_start_top[N_iso + i] for i in 1:N_iso},
    each width=topPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={48,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] top_L1(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    each thickness_wall=thickness_top_L1/N_iso,
    redeclare each model Material = medium_top_L1,
    T_start={ones(N_cv)*T_start_top[i] for i in 1:N_iso},
    each width=topPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={66,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] sides_L1(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    redeclare each model Material = medium_sides_L1,
    each thickness_wall=thickness_sides_L1/N_iso,
    T_start={ones(N_cv)*T_start_sides[i] for i in 1:N_iso},
    each width=sidesPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={66,0})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4[N_iso] bottom_L1(
    each useAxialHeatConduction=useAxialHeatConduction,
    each length=length,
    each N_ax=N_cv,
    redeclare each model Material = medium_bottom_L1,
    each thickness_wall=thickness_bottom_L1/N_iso,
    T_start={ones(N_cv)*T_start_bottom[i] for i in 1:N_iso},
    each width=bottomPart .* circumference) annotation (Placement(transformation(
        extent={{-8,4},{8,-4}},
        rotation=-90,
        origin={66,-44})));

   Modelica.Blocks.Sources.RealExpression realExpression1(y=T_outer_bottom)          annotation (Placement(transformation(extent={{-52,-54},{-36,-34}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_outer_sidesAndTop)
    annotation (Placement(transformation(extent={{-74,10},{-58,30}})));

  //_____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input SI.Temperature T_outer_sidesAndTop = simCenter.T_amb annotation (Dialog(group="Variables"));
  input SI.Temperature T_outer_bottom = simCenter.T_amb annotation (Dialog(group="Variables"));


equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  connect(environment.T, realExpression.y) annotation (Line(points={{-25.2,0},{-40,0},{-40,20},{-57.2,20}},
                                                                                          color={0,0,127}));
  connect(scalar2VectorHeatPort.heatScalar,environment. port) annotation (Line(
      points={{-4,0},{-12,0}},
      color={167,25,48},
      thickness=0.5));
  connect(convection.fluid,scalar2VectorHeatPort. heatVector) annotation (Line(
      points={{18,1},{12,1},{12,0},{8,0}},
      color={167,25,48},
      thickness=0.5));

  for i in 2:N_iso loop

    connect(top_L1[i - 1].outerPhase, top_L1[i].innerPhase);
    connect(sides_L1[i - 1].outerPhase, sides_L1[i].innerPhase);
    connect(bottom_L1[i - 1].outerPhase, bottom_L1[i].innerPhase);

    connect(top_L2[i - 1].outerPhase, top_L2[i].innerPhase);
    connect(sides_L2[i - 1].outerPhase, sides_L2[i].innerPhase);
    connect(bottom_L2[i - 1].outerPhase, bottom_L2[i].innerPhase);

  end for;

  connect(sides_L2[N_iso].outerPhase, convection.solid) annotation (Line(
      points={{46,0},{42,0},{42,1},{32,1}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort1.heatScalar,environment1. port) annotation (Line(
      points={{-4,-44},{-12,-44}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort2.heatScalar,environment2. port) annotation (Line(
      points={{-4,40},{-12,40}},
      color={167,25,48},
      thickness=0.5));
  connect(convection2.fluid, scalar2VectorHeatPort2.heatVector) annotation (Line(
      points={{18,41},{12,41},{12,40},{8,40}},
      color={167,25,48},
      thickness=0.5));
  connect(top_L2[N_iso].outerPhase, convection2.solid) annotation (Line(
      points={{44,40},{34,40},{34,41},{32,41}},
      color={167,25,48},
      thickness=0.5));
  connect(realExpression.y,environment2. T) annotation (Line(points={{-57.2,20},{-40,20},{-40,40},{-25.2,40}},
                                                                                                             color={0,0,127}));
  connect(bottom_L2[1].innerPhase, bottom_L1[N_iso].outerPhase) annotation (Line(
      points={{54,-44},{62,-44}},
      color={167,25,48},
      thickness=0.5));
  connect(sides_L2[1].innerPhase, sides_L1[N_iso].outerPhase) annotation (Line(
      points={{54,0},{62,0}},
      color={167,25,48},
      thickness=0.5));
  connect(top_L2[1].innerPhase, top_L1[N_iso].outerPhase) annotation (Line(
      points={{52,40},{62,40}},
      color={167,25,48},
      thickness=0.5));
  connect(top_L1[1].innerPhase, heat) annotation (Line(
      points={{70,40},{90,40},{90,0},{96,0},{96,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(sides_L1[1].innerPhase, heat) annotation (Line(
      points={{70,-6.66134e-16},{100,-6.66134e-16},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(bottom_L1[1].innerPhase, heat) annotation (Line(
      points={{70,-44},{90,-44},{90,0},{96,0},{96,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(bottom_L2[N_iso].outerPhase, scalar2VectorHeatPort1.heatVector) annotation (Line(
      points={{46,-44},{8,-44}},
      color={167,25,48},
      thickness=0.5));
  connect(realExpression1.y, environment1.T) annotation (Line(points={{-35.2,-44},{-25.2,-44}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for thermal insulation to the environment with dynamic heat transfer, 3 heat flow path(top, sides and bottom) and 2 material layer are considered. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<ul>
<li>L4 discretization in axial direction</li>
<li>lateral dynamic heat transfer</li>
<li>axial heat conduction inside thermal insulation</li>
</ul>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<ul>
<li>constant thickness in axial direction</li>
<li>constant insulation surface in lateral direction</li>
<li>constant temperature at start in axial direction, but can depend on lateral position</li>
</ul>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the Research Project &quot;Future Energy Solution&quot; (FES), 2020</p>
</html>"));
end ThermalInsulation_dynamic_3ways_2layer;
