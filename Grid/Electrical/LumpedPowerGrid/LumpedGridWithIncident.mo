within TransiEnt.Grid.Electrical.LumpedPowerGrid;
model LumpedGridWithIncident
  import TransiEnt;


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

  extends TransiEnt.Basics.Icons.IndustryPlant;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // **** Physical Constraints and Inititalization
  parameter SI.Power P_el_n=simCenter.P_n_ref_2 "Nominal power of all generators in lumped grid";
  parameter Real P_L=simCenter.P_n_low "Load in lumped grid (constant)";
  parameter SI.Time T_tc = simCenter.T_grid "Average time constant of plants";
  parameter Integer nSubgrid=2 "Subgrid assignment for statistics";
  parameter Real kpf=0.5 "Frequency dependence of load";
  parameter SI.Power P_Z=-3e9 "Power of incident";
  parameter SI.Time t_incident=3600 "Time of incident";

  // **** Primary Frequency Control
  parameter SI.Frequency Df_stat_ref = -0.18 "Stationary frequency deviation after reference incident";
  parameter Real delta_pr=Df_stat_ref*P_el_n/(P_Z*simCenter.f_n-Df_stat_ref*P_L*kpf) "Value used if plantType is set to 'Provided'" annotation(Dialog(group="Primary Frequency Control"));

  parameter Real P_pr_grad_max_star=P_pr_max_star/30 "Two percent of design case power in 30s" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real P_pr_max_star=-P_Z/P_el_n "Two percent of design case power" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real k_pr=1 "Participation factor primary control"   annotation(Dialog(group="Primary Frequency Control"));

  // **** Secondary Frequency Control
  parameter Real P_sec_grad_max_star=0.12/60 "Maximum secondary power gradient (= 12% in five Minutes)"  annotation(Dialog(group="Secondary Frequency Control"));
  parameter Real beta=1 "Gain of secondary balancing power"  annotation(Dialog(group="Secondary Frequency Control"));
  parameter Real T_r=20 "Time constant of secondary balancing power"    annotation(Dialog(group="Secondary Frequency Control"));
  parameter Real lambda_sec=1 "Sub grid participation factor"    annotation(Dialog(group="Secondary Frequency Control"));

  replaceable Noise.ZeroError genericGridError constrainedby Noise.Base.PartialGridError "Error of prediction model" annotation (choicesAllMatching=true, Placement(transformation(extent={{-26,70},{-6,90}})));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  LumpedGridLocalStatistics LumpedGrid(
    T_tc=T_tc,
    nSubgrid=nSubgrid,
    delta_pr=delta_pr,
    P_pr_grad_max_star=P_pr_grad_max_star,
    P_pr_max_star=P_pr_max_star,
    P_sec_grad_max_star=P_sec_grad_max_star,
    beta=beta,
    T_r=T_r,
    lambda_sec=lambda_sec,
    kpf=kpf,
    isSecondaryControlActive=true,
    P_el_n=P_el_n,
    P_L=P_L + P_Z,
    k_pr=1)  annotation (Placement(transformation(extent={{-40,-36},{38,36}})));

  Components.GlobalStatisticsAdapter LocalStatisticsAdapter annotation (Placement(transformation(extent={{-100,60},{-58,100}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));

  TransiEnt.Components.Sensors.ElectricActivePower line_L1_1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,0})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) "Setpoint of power transfers to neighbor grid" annotation (Placement(transformation(extent={{44,70},{24,90}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  TransiEnt.Producer.Electrical.Conventional.Components.SimplePowerPlant FailingGen(P_el_n=-P_Z)
                                                                                                annotation (Placement(transformation(extent={{-86,-91},{-66,-71}})));
  Modelica.Blocks.Sources.Constant FailingGen_Set(k=P_Z)  annotation (Placement(transformation(extent={{-96,-71},{-86,-61}})));
  TransiEnt.Components.Electrical.Grid.SeparableLine FailingLine annotation (Placement(transformation(extent={{-54,-85},{-34,-65}})));
  Modelica.Blocks.Sources.BooleanStep Incident(startValue=true, startTime=t_incident) annotation (Placement(transformation(extent={{-74,-61},{-54,-41}})));
  replaceable TransiEnt.Consumer.Electrical.LinearElectricConsumer DemandUncovered(kpf=kpf) constrainedby TransiEnt.Basics.Icons.ElectricalConsumer "Choice of power boundary model. The power boundary model must match the power port." annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true,Placement(transformation(
        extent={{-12,-10},{12,10}},
        rotation=0,
        origin={78,-75})));
  Modelica.Blocks.Sources.Constant LoadUncovered(k=-P_Z) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={94,-59})));

equation
  connect(line_L1_1.epp_OUT, epp) annotation (Line(
      points={{73.4,0},{86.7,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(LumpedGrid.epp, line_L1_1.epp_IN) annotation (Line(
      points={{38,0},{38,0},{54.8,0}},
      color={0,135,135},
      thickness=0.5));
  connect(LumpedGrid.P_tie_is, line_L1_1.P) annotation (Line(points={{30.2,32.4},{30.2,40},{60.2,40},{60.2,7.8}}, color={0,0,127}));
  connect(P_tie_set.y, LumpedGrid.P_tie_set) annotation (Line(points={{23,80},{14.6,80},{14.6,32.4}}, color={0,0,127}));
  connect(genericGridError.y, LumpedGrid.P_Z) annotation (Line(points={{-5,80},{-1,80},{-1,32.4}},
                                                                                                 color={0,0,127}));
  connect(FailingGen.epp, FailingLine.epp_1) annotation (Line(
      points={{-67,-74},{-53.25,-74},{-53.25,-75.1},{-53.9,-75.1}},
      color={0,135,135},
      thickness=0.5));
  connect(FailingLine.isConnected, Incident.y) annotation (Line(points={{-44,-65},{-44,-65},{-44,-51},{-53,-51}}, color={255,0,255}));
  connect(FailingLine.epp_2, DemandUncovered.epp) annotation (Line(
      points={{-34.1,-75},{-34.1,-75},{66.24,-75}},
      color={0,135,135},
      thickness=0.5));
  connect(LumpedGrid.epp, DemandUncovered.epp) annotation (Line(
      points={{38,0},{50,0},{50,-75},{66.24,-75}},
      color={0,135,135},
      thickness=0.5));
  connect(LoadUncovered.y, DemandUncovered.P_el_set) annotation (Line(points={{87.4,-59},{78,-59},{78,-63.4}},       color={0,0,127}));
  connect(FailingGen_Set.y, FailingGen.P_el_set) annotation (Line(points={{-85.5,-66},{-77.5,-66},{-77.5,-71.1}}, color={0,0,127}));
  connect(LumpedGrid.E_kin, LocalStatisticsAdapter.E_kin) annotation (Line(points={{-36.1,32.4},{-36.1,72.4},{-60.52,72.4}}, color={0,0,127}));
  connect(LumpedGrid.P_load, LocalStatisticsAdapter.P_load) annotation (Line(points={{-23.62,32.4},{-23.62,72.4},{-60.52,72.4}},
                                                                                                                               color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{20,-2},{58,-72}},
          fillColor={0,0,213},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,36},{-30,-22}},
          lineColor={95,95,95},
          fillColor={0,0,213},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{8,-2},{20,-22}},
          fillColor={0,0,213},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-48,-24},{52,-72}},
          lineColor={255,255,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,213},
          textString="IntegratedGrid"),
        Text(
          extent={{26,118},{102,46}},
          lineColor={255,0,0},
          textString="P_Z"),
        Line(
          points={{70,60},{96,10}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled})}),
                                Diagram(graphics,
                                        coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Non-detailled grid model electric grid model (including primary and secondary control models) witch a lumped generator model and failure of components</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Level of detail depends on the used submodels</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: active power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">checked in TransiEnt.Grid.Electrical.LumpedPowerGrid.Check.LocalPlantInteractingWithUCTE_withIncident</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LumpedGridWithIncident;
