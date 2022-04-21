within TransiEnt.Producer.Gas.BiogasPlant.Check;
model Check_StirredTankReactor "Model for testing the stirred tank reactor"




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

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=1.1e5, T_const(displayUnit="degC") = 343.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,-46})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=1e5, T_const(displayUnit="degC") = 343.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={34,-46})));
  StirredTankReactor stirredTankReactor_withPorts(
    t_res=40*24*3600,
    T_target=310.15,
    T_in=278.15) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration(displayUnit="d") = 8640000,
    offset=273,
    height=10) annotation (Placement(transformation(extent={{66,-10},{46,10}})));
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var gasModel1) annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,72},{-40,92}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi(p_const=100000) annotation (Placement(transformation(extent={{54,40},{34,60}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={26,0})));
equation
  connect(boundaryVLE_pTxi.steam_a, stirredTankReactor_withPorts.WaterIn) annotation (Line(
      points={{-32,-46},{-20,-46},{-20,-7.8},{-8.4,-7.8}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_pTxi1.steam_a, stirredTankReactor_withPorts.WaterOut) annotation (Line(
      points={{24,-46},{16,-46},{16,-7.8},{9,-7.8}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(ElectricGrid.epp, stirredTankReactor_withPorts.epp) annotation (Line(
      points={{-60,0},{-9,0}},
      color={0,135,135},
      thickness=0.5));
  connect(boundary_pTxi.gasPort, stirredTankReactor_withPorts.gasPortOut) annotation (Line(
      points={{34,50},{22,50},{22,8},{7.2,8}},
      color={255,255,0},
      thickness=1.5));
  connect(stirredTankReactor_withPorts.ambientTemperature, realExpression.y) annotation (Line(points={{9.3,0.1},{16,0.1},{16,0},{15,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check model for testing a continous stirred tank reactor. This model is used for comparing the power of the impeller with literature values.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
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
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</p>
</html>"),
    experiment(
      StopTime=86400000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Check_StirredTankReactor;
