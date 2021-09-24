within TransiEnt.Components.Heat.ThermalInsulation;
model ThermalInsulation_static_3ways_2layer "Thermal Insulation - static - 3 ways - 2 layer"


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


   import SI = ClaRa.Basics.Units;

   extends ClaRa.Basics.Icons.WallThick;

   extends TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base(final N_iso=1);

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________


  parameter SI.CoefficientOfHeatTransfer alpha_iso2ambient_top = 20 "Isolation Surface to Air Heat Transfer Coefficient at top" annotation (Dialog(group="Heat Transfer"));

  parameter SI.CoefficientOfHeatTransfer alpha_iso2ambient_sides = 20 "Isolation Surface to Air Heat Transfer Coefficient at sides" annotation (Dialog(group="Heat Transfer"));

  parameter SI.Length thickness_top_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_top_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_sides_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_sides_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_bottom_L1 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter SI.Length thickness_bottom_L2 = 1 "Thickness of Insulation" annotation (Dialog(group="Geometry"));

  parameter Real topPart = 1/3 "Relative partition of top Insulation on Circumference" annotation (Dialog(group="Geometry"));
  parameter Real sidesPart = 1/3 "Relative partition of sides Insulation on Circumference" annotation (Dialog(group="Geometry"));
  parameter Real bottomPart = 1/3 "Relative partition of bottom Insulation on Circumference" annotation (Dialog(group="Geometry"));

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
                                                         "Insulation Medium Sides outer layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_bottom_L1 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                       constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium bottom inner layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_bottom_L2 = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                       constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium bottom outer layer"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));



  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment annotation (Placement(transformation(extent={{-24,-6},{-12,6}})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=N_cv)
    annotation (Placement(transformation(extent={{-4,-6},{8,6}})));

 Summary summary(Q_flow_loss = environment.port.Q_flow+environment1.port.Q_flow+environment2.port.Q_flow) annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment1
                                                                          annotation (Placement(transformation(extent={{-24,-50},{-12,-38}})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(N=N_cv)
    annotation (Placement(transformation(extent={{-4,-50},{8,-38}})));

  TransiEnt.Components.Heat.ThermalInsulation.Basics.Convection_L4 convection(
    length=length,
    N_ax=N_cv,
    alpha=alpha_iso2ambient_sides,
    width=sidesPart .* circumference) annotation (Placement(transformation(extent={{32,-6},{18,8}})));

  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 sides_L2(
    length=length,
    N_ax=N_cv,
    redeclare model Material = medium_sides_L2,
    d=thickness_sides_L2,
    width=sidesPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={50,2})));

  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 bottom_L2(
    length=length,
    N_ax=N_cv,
    redeclare model Material = medium_bottom_L2,
    d=thickness_bottom_L2,
    width=bottomPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={46,-44})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(N=N_cv)
    annotation (Placement(transformation(extent={{-4,34},{8,46}})));
  TransiEnt.Components.Heat.ThermalInsulation.Basics.Convection_L4 convection2(
    length=length,
    N_ax=N_cv,
    alpha=alpha_iso2ambient_top,
    width=topPart .* circumference) annotation (Placement(transformation(extent={{32,34},{18,48}})));
  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 top_L2(
    length=length,
    N_ax=N_cv,
    redeclare model Material = medium_top_L2,
    d=thickness_top_L2,
    width=topPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={46,42})));
  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 top_L1(
    length=length,
    N_ax=N_cv,
    d=thickness_top_L1,
    redeclare model Material = medium_top_L1,
    width=topPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={68,42})));
  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 sides_L1(
    length=length,
    N_ax=N_cv,
    redeclare model Material = medium_sides_L1,
    d=thickness_sides_L1,
    width=sidesPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={68,2})));

  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 bottom_L1(
    length=length,
    N_ax=N_cv,
    redeclare model Material = medium_bottom_L1,
    d=thickness_bottom_L1,
    width=bottomPart .* circumference) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={68,-44})));

          Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment2
                                                                          annotation (Placement(transformation(extent={{-24,34},{-12,46}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_outer_bottom)
    annotation (Placement(transformation(extent={{-50,-54},{-34,-34}})));

      Modelica.Blocks.Sources.RealExpression realExpression(y=T_outer_sidesAndTop)
    annotation (Placement(transformation(extent={{-78,10},{-62,30}})));


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


  connect(environment.T, realExpression.y) annotation (Line(points={{-25.2,0},{-40,0},{-40,20},{-61.2,20}},
                                                                                          color={0,0,127}));
  connect(scalar2VectorHeatPort.heatScalar,environment. port) annotation (Line(
      points={{-4,0},{-12,0}},
      color={167,25,48},
      thickness=0.5));
  connect(convection.fluid,scalar2VectorHeatPort. heatVector) annotation (Line(
      points={{18,1},{12,1},{12,0},{8,0}},
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
  connect(realExpression.y,environment2. T) annotation (Line(points={{-61.2,20},{-40,20},{-40,40},{-25.2,40}},
                                                                                                             color={0,0,127}));
  connect(convection2.solid, top_L2.solid_1) annotation (Line(
      points={{32,41},{36,41},{36,42},{40,42}},
      color={167,25,48},
      thickness=0.5));
  connect(top_L2.solid_2, top_L1.solid_1) annotation (Line(
      points={{52,42},{62,42}},
      color={167,25,48},
      thickness=0.5));
  connect(convection.solid, sides_L2.solid_1) annotation (Line(
      points={{32,1},{38,1},{38,2},{44,2}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort1.heatVector, bottom_L2.solid_1) annotation (Line(
      points={{8,-44},{40,-44}},
      color={167,25,48},
      thickness=0.5));
  connect(sides_L2.solid_2, sides_L1.solid_1) annotation (Line(
      points={{56,2},{62,2}},
      color={167,25,48},
      thickness=0.5));
  connect(bottom_L2.solid_2, bottom_L1.solid_1) annotation (Line(
      points={{52,-44},{62,-44}},
      color={167,25,48},
      thickness=0.5));
  connect(top_L1.solid_2, heat) annotation (Line(
      points={{74,42},{86,42},{86,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(sides_L1.solid_2, heat) annotation (Line(
      points={{74,2},{86,2},{86,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(bottom_L1.solid_2, heat) annotation (Line(
      points={{74,-44},{86,-44},{86,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(realExpression1.y, environment1.T) annotation (Line(points={{-33.2,-44},{-25.2,-44}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for thermal insulation to the environment with static heat transfer, 3 heat flow paths (top, sides and bottom) and 2 material layers. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<ul>
<li>L4 discretization in axial direction</li>
<li>lateral static heat transfer</li>
</ul>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<ul>
<li>constant insulation thickness in axial direction</li>
<li>constant insulation surface in lateral direction</li>
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
end ThermalInsulation_static_3ways_2layer;
