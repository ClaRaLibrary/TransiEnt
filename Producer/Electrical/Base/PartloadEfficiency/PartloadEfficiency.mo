within TransiEnt.Producer.Electrical.Base.PartloadEfficiency;
model PartloadEfficiency "Block that calculates the partload efficiency from a charline, the actual power output and the nominal output"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Efficiency eta_n "Nominal total plant efficiency";
  parameter TransiEnt.Producer.Electrical.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() annotation (Dialog(group="Physical Constraints"), choicesAllMatching=true);
  parameter TransiEnt.Producer.Electrical.Base.CCS.NoCCS CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.NoCCS() annotation (Dialog(group="Physical Constraints"), __Dymola_choicesAllMatching=true);
  parameter Real CO2_Deposition_Rate=0 "Fraction of CO2 that is deposited via CCS";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_is "Actual electric power output in p.u." annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  TransiEnt.Basics.Interfaces.General.EfficiencyOut eta_is "Output for efficiency" annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.BooleanInput UseCCS if CO2_Deposition_Rate>0 "true, if CCS is used" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-106,-60}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-111,-61})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Product product1 if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-94,14},{-74,34}})));
  Modelica.Blocks.Math.Division division if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-68,8},{-48,28}})));
  Modelica.Blocks.Tables.CombiTable1Ds eta_rel(
    u(start=0),
    columns={2},
    table=EfficiencyCharLine.CL_eta_P,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-14,5},{12,31}})));
  Modelica.Blocks.Math.Gain nominal(k=eta_n,y(start=0)) "Nominal point efficiency" annotation (Placement(transformation(extent={{20,8},{40,28}})));
  Modelica.Blocks.Tables.CombiTable1Ds CCS_Efficiency_Losses(
    columns={2},
    table=CCS_Characteristics.CCS_Absolute_Efficiency_Loss,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-14,-32},{12,-6}})));
  Modelica.Blocks.Math.Add add(k2=-1) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter_TheoreticalRelativeLoadWithoutCCS(uMax=1, uMin=0) if
                                                               CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-42,8},{-22,28}})));
  Modelica.Blocks.Tables.CombiTable1Ds CCS_Efficiency_Losses_Scaling(
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    table=CCS_Characteristics.Deviation_CO2_Absolute_Efficiency_Loss)  annotation (Placement(transformation(extent={{-42,-56},{-18,-32}})));
  Modelica.Blocks.Math.Product product if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=CO2_Deposition_Rate)  annotation (Placement(transformation(extent={{-78,-54},{-54,-34}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=1, uMin=0) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{74,-10},{94,10}})));
  Modelica.Blocks.Logical.Switch switch1 if  CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-4,-62},{16,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0) if                  CO2_Deposition_Rate>0  annotation (Placement(transformation(extent={{-38,-82},{-16,-60}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if CO2_Deposition_Rate>0 then
    connect(P_el_is, product1.u2) annotation (Line(points={{-106,0},{-100,0},{-100,18},{-96,18}}, color={0,127,127}));
    connect(product1.y, division.u1) annotation (Line(points={{-73,24},{-70,24}}, color={0,0,127}));
    connect(eta_rel.y[1], nominal.u) annotation (Line(points={{13.3,18},{18,18}}, color={0,0,127}));
    connect(add.u1, nominal.y) annotation (Line(points={{46,6},{46,18},{41,18}}, color={0,0,127}));
    connect(nominal.y, product1.u1) annotation (Line(points={{41,18},{56,18},{56,56},{-100,56},{-100,30},{-96,30}}, color={0,0,127}));
    connect(division.y, limiter_TheoreticalRelativeLoadWithoutCCS.u) annotation (Line(points={{-47,18},{-44,18}}, color={0,0,127}));
    connect(limiter_TheoreticalRelativeLoadWithoutCCS.y, eta_rel.u) annotation (Line(points={{-21,18},{-16.6,18}}, color={0,0,127}));
    connect(CCS_Efficiency_Losses.u, limiter_TheoreticalRelativeLoadWithoutCCS.y) annotation (Line(points={{-16.6,-19},{-21,-19},{-21,18}}, color={0,0,127}));
    connect(CCS_Efficiency_Losses.y[1], product.u1) annotation (Line(points={{13.3,-19},{18,-19},{18,-24}}, color={0,0,127}));
    connect(product.y, add.u2) annotation (Line(points={{41,-30},{46,-30},{46,-6}}, color={0,0,127}));
    connect(eta_is, limiter1.y) annotation (Line(points={{106,0},{95,0}}, color={0,0,127}));
    connect(add.y, limiter1.u) annotation (Line(points={{69,0},{72,0}}, color={0,0,127}));
    connect(limiter1.y, division.u2) annotation (Line(points={{95,0},{96,0},{96,-78},{-78,-78},{-78,12},{-70,12}}, color={0,0,127}));
    connect(switch1.y, product.u2) annotation (Line(points={{17,-52},{18,-52},{18,-36}}, color={0,0,127}));
    connect(switch1.u2, UseCCS) annotation (Line(points={{-6,-52},{-12,-52},{-12,-60},{-106,-60}},                     color={255,0,255}));
    connect(realExpression1.y, switch1.u3) annotation (Line(points={{-14.9,-71},{-10,-71},{-10,-60},{-6,-60}}, color={0,0,127}));
  else
    connect(eta_rel.u, P_el_is);
    connect(nominal.y, eta_is);
    connect(eta_rel.y[1], nominal.u);
  end if;

    connect(CCS_Efficiency_Losses_Scaling.y[1], switch1.u1) annotation (Line(points={{-16.8,-44},{-6,-44}}, color={0,0,127}));
    connect(CCS_Efficiency_Losses_Scaling.u,realExpression. y) annotation (Line(points={{-44.4,-44},{-52.8,-44}}, color={0,0,127}));


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model block calculates partload efficiency from the efficiency line chart, the nominal total plant efficiency and the actual electric power output. </p>
<p>If CCS is used the efficiency losses due to CCS are calculated.</p>
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
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Dez 2018: added CCS</p>
</html>"));
end PartloadEfficiency;
