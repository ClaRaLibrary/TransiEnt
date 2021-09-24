within TransiEnt.Components.Heat.ThermalInsulation;
model ThermalInsulation_static_1way_1layer "Thermal Insulation - static - one way - one layer"


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

  parameter SI.CoefficientOfHeatTransfer alpha_iso2ambient = 20 "Insulation Surface to Air Heat Transfer Coefficient" annotation (Dialog(group="Heat Transfer"));

  parameter SI.Length thickness = 1 "Thickness" annotation (Dialog(group="Geometry"));


  //___________________________________________
  //
  //                 Outer Models
  // _____________________________________________


     outer ClaRa.SimCenter simCenter;


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________



  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature environment annotation (Placement(transformation(extent={{-24,-6},{-12,6}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=T_outer)
    annotation (Placement(transformation(extent={{-52,-10},{-36,10}})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=N_cv)
    annotation (Placement(transformation(extent={{-4,-6},{8,6}})));

  Summary summary(Q_flow_loss = environment.port.Q_flow) annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));


    replaceable model medium = TransiEnt.Basics.Media.Solids.AeratedConcrete
                                                                 constrainedby TILMedia.SolidTypes.BaseSolid
                                                         "Insulation Medium"           annotation (choicesAllMatching, Dialog(group="
Fundamental Definitions"));


  TransiEnt.Components.Heat.ThermalInsulation.Basics.Conduction_L4 conduction(
    length=length,
    width=circumference,
    N_ax=N_cv,
    redeclare model Material = medium,
    d=thickness) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={64,0})));

  TransiEnt.Components.Heat.ThermalInsulation.Basics.Convection_L4 convection(
    alpha=alpha_iso2ambient,
    length=length,
    N_ax=N_cv,
    width=circumference) annotation (Placement(transformation(extent={{36,-6},{22,8}})));


  //_____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input SI.Temperature T_outer = simCenter.T_amb annotation (Dialog(group="Variables"));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  connect(environment.T, realExpression.y) annotation (Line(points={{-25.2,0},{-35.2,0}}, color={0,0,127}));
  connect(scalar2VectorHeatPort.heatScalar,environment. port) annotation (Line(
      points={{-4,0},{-12,0}},
      color={167,25,48},
      thickness=0.5));

  connect(conduction.solid_2, heat) annotation (Line(
      points={{70,0},{88,0},{88,0},{100,0}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort.heatVector, convection.fluid) annotation (Line(
      points={{8,0},{16,0},{16,1},{22,1}},
      color={167,25,48},
      thickness=0.5));
  connect(convection.solid, conduction.solid_1) annotation (Line(
      points={{36,1},{52,1},{52,0},{58,0}},
      color={167,25,48},
      thickness=0.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for thermal insulation to the environment if static heat transfer, 1 heat flow path and 1 material layer is considered</p>
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
end ThermalInsulation_static_1way_1layer;
