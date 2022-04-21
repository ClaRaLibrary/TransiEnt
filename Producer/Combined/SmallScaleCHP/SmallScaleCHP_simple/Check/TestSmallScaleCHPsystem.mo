within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Check;
model TestSmallScaleCHPsystem


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




  extends TransiEnt.Basics.Icons.Checkmodel;

  Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage grid1(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-62,-60},{-88,-34}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi Gas_Source1(p_const=simCenter.p_amb_const + simCenter.p_eff_1) annotation (Placement(transformation(extent={{88,-48},{58,-18}})));
  SmallScaleCHPsystem smallScaleCHPsystem(redeclare connector PowerPortModel = Basics.Interfaces.Electrical.ApparentPowerPort, redeclare model PowerBoundaryModel = Components.Boundaries.Electrical.ApparentPower.ApparentPower (useInputConnectorQ=false, useCosPhi=false))
                                                                                                             annotation (Placement(transformation(extent={{-46,-4},{-2,30}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=8*3600,
    startTime=3600,
    height=5000,
    offset=5000) annotation (Placement(transformation(extent={{42,52},{22,72}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-80,78},{-60,98}})));

equation

  connect(grid1.epp, smallScaleCHPsystem.epp) annotation (Line(
      points={{-62,-47},{-26,-47},{-26,-48},{14,-48},{14,-0.6},{-2,-0.6}},
      color={0,127,0},
      thickness=0.5));
  connect(smallScaleCHPsystem.gasPortIn, Gas_Source1.gasPort) annotation (Line(
      points={{-7.06,-5.19},{-7.06,-33},{58,-33}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, smallScaleCHPsystem.Q_Demand) annotation (Line(points={{21,62},{-23.78,62},{-23.78,29.49}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=432000, Interval=900),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for model SmallScaleCHPsystem</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4.Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestSmallScaleCHPsystem;
