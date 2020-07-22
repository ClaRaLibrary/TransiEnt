within TransiEnt.Producer.Electrical.Base.PartloadEfficiency;
model PartloadEfficiency "Block that calculates the partload efficiency from a charline, the actual power output and the nominal output"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Efficiency eta_n "Nominal total plant efficiency" annotation (Dialog(group="Physical Constraints"));
  parameter TransiEnt.Producer.Electrical.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() annotation (Dialog(group="Physical Constraints"), choicesAllMatching=true);
  parameter TransiEnt.Producer.Electrical.Base.CCS.NoCCS CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.NoCCS() annotation (Dialog(group="Physical Constraints"), __Dymola_choicesAllMatching=true);
  parameter Real CO2_Deposition_Rate=0 "Fraction of CO2 that is deposited via CCS";
  parameter Integer quantity=1 "amount of power plant blocks into which nominal power is split" annotation (Dialog(group="Physical Constraints"));
  parameter Real P_min_star=0.2 "Fraction of nominal power (=20% of nominal power)" annotation(Dialog(group="Physical Constraints"));
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_is "Actual electric power output in p.u." annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  TransiEnt.Basics.Interfaces.General.EfficiencyOut eta_is "Output for efficiency" annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.BooleanInput UseCCS if CO2_Deposition_Rate>0  "true, if CCS is used" annotation (Placement(transformation(
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

  Modelica.Blocks.Math.Product product1 if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-88,20},{-74,34}})));
  Modelica.Blocks.Math.Division division if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-68,10},{-52,26}})));
  Modelica.Blocks.Tables.CombiTable1Ds eta_rel(
    u(start=0),
    columns={2},
    table=EfficiencyCharLine.CL_eta_P,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-18,10},{0,27}})));
  Modelica.Blocks.Math.Gain nominal(k=eta_n,y(start=0)) "Nominal point efficiency" annotation (Placement(transformation(extent={{12,8},{32,28}})));
  Modelica.Blocks.Tables.CombiTable1Ds CCS_Efficiency_Losses(
    columns={2},
    table=CCS_Characteristics.CCS_Absolute_Efficiency_Loss,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-18,-18},{0,0}})));
  Modelica.Blocks.Math.Add add(k2=-1) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter_TheoreticalRelativeLoadWithoutCCS(uMax=1, uMin=0) if
                                                               CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-46,10},{-30,26}})));
  Modelica.Blocks.Tables.CombiTable1Ds CCS_Efficiency_Losses_Scaling(
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    table=CCS_Characteristics.Deviation_CO2_Absolute_Efficiency_Loss) if CO2_Deposition_Rate>0  annotation (Placement(transformation(extent={{-52,-56},{-28,-32}})));
  Modelica.Blocks.Math.Product product if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{12,-40},{32,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=CO2_Deposition_Rate) if CO2_Deposition_Rate>0  annotation (Placement(transformation(extent={{-88,-54},{-64,-34}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=1, uMin=0) if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  Modelica.Blocks.Logical.Switch switch1 if  CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-22,-62},{-2,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0) if                  CO2_Deposition_Rate>0  annotation (Placement(transformation(extent={{-48,-82},{-26,-60}})));
  Modelica.Blocks.Sources.RealExpression P_el_is_array_lastPowerPlant(y=max(P_min_star, P_needed_lastPowerPlant)) if          quantity>1 annotation (Placement(transformation(extent={{-132,8},{-112,28}})));
  Modelica.Blocks.Sources.RealExpression eta_is_array_withCCS(y=if UseCCS then (limiter1.y + integer(max(Modelica.Constants.eps, min(1, P_el_is))*quantity)*(eta_n - CCS_Characteristics.CCS_Absolute_Efficiency_Loss[end, 2]*CCS_Efficiency_Losses_Scaling.y[1]))/(max(0, integer(max(Modelica.Constants.eps, min(1, P_el_is))*quantity)) + 1) else (limiter1.y + integer(max(Modelica.Constants.eps, min(1, P_el_is))*quantity)*(eta_n))/(max(0, integer(max(Modelica.Constants.eps, min(1, P_el_is))*quantity)) + 1)) if
                                                                                                                                                                                                        CO2_Deposition_Rate>0 and quantity>1 annotation (Placement(transformation(extent={{72,36},{92,56}})));
  Modelica.Blocks.Sources.RealExpression eta_is_array_withoutCCS(y=(nominal.y + (integer(max(Modelica.Constants.eps, min(1,P_el_is))*quantity))*(eta_n))/(max(0, integer(max(Modelica.Constants.eps, min(1,P_el_is))*quantity)) + 1)) if
                                                                                                                                                                   CO2_Deposition_Rate<=0 and quantity>1 annotation (Placement(transformation(extent={{72,22},{92,42}})));
  Modelica.SIunits.Power P_needed_lastPowerPlant=(max(Modelica.Constants.eps, min(1,P_el_is)) - integer(max(Modelica.Constants.eps, min(1,P_el_is))*quantity)*(1/quantity))*quantity;
  TransiEnt.Basics.Blocks.FirstOrder firstOrder(Tau=10) if quantity>1 annotation (Placement(transformation(extent={{90,8},{96,14}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if CO2_Deposition_Rate>0 then
    connect(product1.y, division.u1) annotation (Line(points={{-73.3,27},{-70,27},{-70,22.8},{-69.6,22.8}},
                                                                                  color={0,0,127}));
    connect(eta_rel.y[1], nominal.u) annotation (Line(points={{0.9,18.5},{8,18.5},{8,18},{10,18}},
                                                                                  color={0,0,127}));
    connect(add.u1, nominal.y) annotation (Line(points={{34,6},{34,18},{33,18}}, color={0,0,127}));
    connect(nominal.y, product1.u1) annotation (Line(points={{33,18},{48,18},{48,56},{-108,56},{-108,31.2},{-89.4,31.2}},
                                                                                                                    color={0,0,127}));
    connect(division.y, limiter_TheoreticalRelativeLoadWithoutCCS.u) annotation (Line(points={{-51.2,18},{-47.6,18}},
                                                                                                                  color={0,0,127}));
    connect(limiter_TheoreticalRelativeLoadWithoutCCS.y, eta_rel.u) annotation (Line(points={{-29.2,18},{-19.8,18},{-19.8,18.5}},
                                                                                                                   color={0,0,127}));
    connect(CCS_Efficiency_Losses.u, limiter_TheoreticalRelativeLoadWithoutCCS.y) annotation (Line(points={{-19.8,-9},{-29.2,-9},{-29.2,18}},
                                                                                                                                            color={0,0,127}));
    connect(CCS_Efficiency_Losses.y[1], product.u1) annotation (Line(points={{0.9,-9},{10,-9},{10,-24}},    color={0,0,127}));
    connect(product.y, add.u2) annotation (Line(points={{33,-30},{34,-30},{34,-6}}, color={0,0,127}));
    connect(add.y, limiter1.u) annotation (Line(points={{57,0},{60,0}}, color={0,0,127}));
    connect(limiter1.y, division.u2) annotation (Line(points={{83,0},{86,0},{86,-78},{-78,-78},{-78,14},{-74,14},{-74,13.2},{-69.6,13.2}},
                                                                                                                   color={0,0,127}));
    connect(switch1.y, product.u2) annotation (Line(points={{-1,-52},{10,-52},{10,-36}}, color={0,0,127}));
    connect(switch1.u2, UseCCS) annotation (Line(points={{-24,-52},{-22,-52},{-22,-60},{-106,-60}},                    color={255,0,255}));
    connect(realExpression1.y, switch1.u3) annotation (Line(points={{-24.9,-71},{-20,-71},{-20,-60},{-24,-60}},color={0,0,127}));
    connect(CCS_Efficiency_Losses_Scaling.y[1], switch1.u1) annotation (Line(points={{-26.8,-44},{-24,-44}},color={0,0,127}));
    connect(CCS_Efficiency_Losses_Scaling.u,realExpression. y) annotation (Line(points={{-54.4,-44},{-62.8,-44}}, color={0,0,127}));
  else
    //connect(nominal.y, eta_is);
    connect(eta_rel.y[1], nominal.u);
  end if;

  if quantity==1 and CO2_Deposition_Rate<=0 then
    connect(nominal.y, eta_is) annotation (Line(points={{33,18},{86,18},{86,0},{106,0}},   color={0,0,127}));
  elseif quantity==1 and CO2_Deposition_Rate>0 then
    connect(limiter1.y,eta_is) annotation (Line(points={{83,0},{106,0}},                   color={0,0,127}));
  elseif quantity>1 and CO2_Deposition_Rate>0 then
    connect(firstOrder.y, eta_is);
    connect(eta_is_array_withCCS.y, firstOrder.u);
  else
    connect(firstOrder.y, eta_is);
    connect(eta_is_array_withoutCCS.y, firstOrder.u);
  end if;

  if quantity==1 then
    if CO2_Deposition_Rate>0 then
      connect(P_el_is, product1.u2) annotation (Line(points={{-106,0},{-100,0},{-100,22.8},{-89.4,22.8}},
                                                                                                    color={0,127,127}));
    else
      connect(eta_rel.u, P_el_is);
    end if;
  else
    if CO2_Deposition_Rate>0 then
      connect(P_el_is_array_lastPowerPlant.y, product1.u2) annotation (Line(points={{-111,18},{-100,18},{-100,22.8},{-89.4,22.8}},
                                                                                                                           color={0,127,127}));
    else
      connect(eta_rel.u, P_el_is_array_lastPowerPlant.y);
    end if;
  end if;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model block calculates partload efficiency from the efficiency line chart, the nominal total plant efficiency and the actual electric power output. </p>
<p>If CCS is used the efficiency losses due to CCS are calculated.</p>
<p>If power plant consists of more than one block (parameter quantity&gt;1) the efficiency is calculated assuming that power plant blocks are turned on one after the other.</p>
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
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Jun 2019: added possibilty to calculate array-efficiencies via parameter &apos;quantity&apos;</p>
</html>"));
end PartloadEfficiency;
