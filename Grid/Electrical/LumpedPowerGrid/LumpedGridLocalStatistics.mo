within TransiEnt.Grid.Electrical.LumpedPowerGrid;
model LumpedGridLocalStatistics "Model of generation and load in a lumped grid including load forecast errors (providing realistic frequency series)"

 //___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.IndustryPlant;

  import TransiEnt;

  // _____________________________________________
  //
  //                   inner / outer models
  // _____________________________________________

  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));   // this one catches the statistics data from ucte component

  outer TransiEnt.SimCenter simCenter;
  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // **** Physical Constraints and Inititalization
  parameter SI.Power P_el_n=300e6 "Nominal power of all generators in lumped grid";
  parameter Real P_L=simCenter.P_n_low "Load in lumped grid (constant)";
  parameter SI.Time T_tc = 12 "Average time constant of plants";
  parameter Integer nSubgrid=2 "Subgrid assignment for statistics";

  // **** Primary Frequency Control
  parameter Real delta_pr=0.2 "Value used if plantType is set to 'Provided'" annotation(Dialog(group="Primary Frequency Control"));

  parameter Real P_pr_grad_max_star=0.02/30 "Two percent of design case power in 30s" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real P_pr_max_star=0.2 "Two percent of design case power" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real k_pr=1 "Participation factor primary control"   annotation(Dialog(group="Primary Frequency Control"));

  // **** Secondary Frequency Control
  parameter Boolean isSecondaryControlActive = false annotation ( choices(__Dymola_checkBox=true), Dialog(group="Frequency Control", tab="Block control"));
  parameter Real P_sec_grad_max_star=0.12/60 "Maximum secondary power gradient (= 12% in five Minutes)"  annotation(Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));
  parameter Real beta=1 "Gain of secondary balancing power"  annotation(Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));
  parameter Real T_r=20 "Time constant of secondary balancing power"    annotation(Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));
  parameter Real lambda_sec=1 "Sub grid participation factor"    annotation(Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Producer.Electrical.Conventional.LumpedGridGenerators PowerPlants(
    P_el_n=P_el_n,
    delta_pr=delta_pr,
    final J=T_tc*P_el_n/(100*3.14)^2,
    T_tc=T_tc,
    nSubgrid=nSubgrid,
    P_pr_grad_max_star=P_pr_grad_max_star,
    P_pr_max_star=P_pr_max_star,
    P_sec_grad_max_star=P_sec_grad_max_star,
    k_pr=k_pr,
    lambda_sec=lambda_sec,
    T_r=T_r,
    beta=if isSecondaryControlActive then beta else 0,
    fixedStartValue_w=false) annotation (Placement(transformation(extent={{-82,-76},{-18,-18}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Demand(kpf=kpf) annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=0,
        origin={59,-46})));
  Modelica.Blocks.Sources.Constant Load(k=P_L) annotation (Placement(transformation(extent={{92,8},{72,28}})));

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealOutput E_kin annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,98}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,90})));
  Modelica.Blocks.Interfaces.RealInput P_tie_set annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-58,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,90})));
  Modelica.Blocks.Interfaces.RealInput P_tie_is annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-38,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,90})));
  Modelica.Blocks.Math.Gain PowerPlantsSchedule(k=-1) annotation (Placement(transformation(extent={{48,8},{28,28}})));
  Modelica.Blocks.Math.Sum PowerPlantsGen(nin=2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-14,18})));
  Modelica.Blocks.Interfaces.RealInput P_Z "Grid error" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));

  parameter Real kpf=0.5 "Frequency dependence of load";
  Modelica.Blocks.Interfaces.RealOutput P_load
                                              annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={82,98}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-58,90})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  E_kin=-modelStatistics.kineticEnergyCollector[simCenter.iSurroundingGrid].E_kin;
  P_load=modelStatistics.electricPower.P_demand;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(PowerPlants.epp, Demand.epp) annotation (Line(
      points={{-19.6,-30.76},{10.2,-30.76},{10.2,-46},{40.38,-46}},
      color={0,135,135},
      thickness=0.5));
  connect(Demand.epp, epp) annotation (Line(
      points={{40.38,-46},{10,-46},{10,76},{100,76},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(PowerPlantsSchedule.u, Load.y) annotation (Line(points={{50,18},{71,18}}, color={0,0,127}));
  connect(PowerPlantsSchedule.y, PowerPlantsGen.u[1]) annotation (Line(points={{27,18},{-2,18},{-2,17}}, color={0,0,127}));
  connect(PowerPlantsGen.u[2], P_Z) annotation (Line(points={{-2,19},{2,19},{2,40},{-100,40}}, color={0,0,127}));
  connect(P_tie_set, PowerPlants.P_tie_set) annotation (Line(points={{-58,100},{-58,30},{-45.2,30},{-45.2,-21.19}}, color={0,0,127}));
  connect(P_tie_is, PowerPlants.P_tie_is) annotation (Line(points={{-38,100},{-38,2},{-32.4,2},{-32.4,-21.19}}, color={0,0,127}));
  connect(Load.y, Demand.P_el_set) annotation (Line(points={{71,18},{59,18},{59,-23.96}},       color={0,0,127}));
  connect(PowerPlants.P_el_set, PowerPlantsGen.y) annotation (Line(points={{-54.8,-18.29},{-54.8,18},{-25,18}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
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
        Text(
          extent={{-48,-26},{52,-74}},
          lineColor={255,255,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,213},
          textString="IntegratedGrid"),
        Polygon(
          points={{-40,40},{-36,40},{-34,40},{-28,40},{-26,42},{-16,48},{-14,48},
              {-2,56},{2,58},{6,60},{8,62},{12,64},{14,66},{20,70},{22,70},{24,
              72},{26,76},{24,76},{18,78},{14,78},{8,80},{6,78},{4,76},{4,72},{
              2,68},{-2,66},{-10,62},{-16,60},{-18,56},{-22,54},{-24,52},{-28,
              50},{-30,48},{-32,46},{-34,44},{-36,44},{-40,44},{-40,40}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={107,107,107},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,4},{18,4},{38,2},{50,2},{54,2},{72,14},{72,22},{70,30},{
              70,32},{72,40},{72,42},{68,42},{58,40},{58,38},{54,36},{52,34},{
              42,28},{40,26},{38,26},{36,22},{32,18},{30,18},{26,14},{22,12},{
              16,10},{16,8},{12,8},{12,4}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={74,74,74},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,-2},{20,-22}},
          fillColor={0,0,213},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LumpedGridLocalStatistics;
