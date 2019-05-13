within TransiEnt.Grid.Electrical.LumpedPowerGrid;
model LumpedGrid
  import TransiEnt;
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

  // **** Primary Frequency Control
  parameter Real delta_pr=0.2/50/0.1 "Value used if plantType is set to 'Provided'" annotation(Dialog(group="Primary Frequency Control"));

  parameter Real P_pr_grad_max_star=0.996/100/30 "Two percent of design case power in 30s" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real P_pr_max_star=0.996/100 "Two percent of design case power" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real k_pr=1 "Participation factor primary control"   annotation(Dialog(group="Primary Frequency Control"));

  // **** Secondary Frequency Control
  parameter Boolean isSecondaryControlActive=false;
  parameter Real P_sec_grad_max_star=0.12/60 "Maximum secondary power gradient (= 12% in five Minutes)"  annotation(Dialog(enable=false, group="Secondary Frequency Control"));
  parameter Real beta=0.5 "Gain of secondary balancing power"  annotation(Dialog(enable=false, group="Secondary Frequency Control"));
  parameter Real T_r=150 "Time constant of secondary balancing power"    annotation(Dialog(enable=false, group="Secondary Frequency Control"));
  parameter Real lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2 "Sub grid participation factor"    annotation(Dialog(enable=false,group="Secondary Frequency Control"));

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

  replaceable LumpedGridLocalStatistics LumpedGrid(
    T_tc=T_tc,
    P_el_n=P_el_n,
    P_L=P_L,
    nSubgrid=nSubgrid,
    delta_pr=delta_pr,
    P_pr_grad_max_star=P_pr_grad_max_star,
    P_pr_max_star=P_pr_max_star,
    k_pr=k_pr,
    P_sec_grad_max_star=P_sec_grad_max_star,
    beta=beta,
    T_r=T_r,
    lambda_sec=lambda_sec,
    kpf=kpf,
    isSecondaryControlActive=isSecondaryControlActive)
             annotation (Placement(transformation(extent={{-38,-36},{40,36}})));

  Components.GlobalStatisticsAdapter LocalStatisticsAdapter annotation (Placement(transformation(extent={{-100,60},{-58,100}})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (choicesAllMatching=true,Dialog(group="Replaceable Components"),Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));

  replaceable TransiEnt.Components.Sensors.ElectricActivePower line_L1_1 constrainedby TransiEnt.Components.Sensors.ElectricPowerComplex annotation (choicesAllMatching=true,Dialog(group="Replaceable Components"),Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,0})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) "Setpoint of power transfers to neighbor grid" annotation (Placement(transformation(extent={{44,70},{24,90}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  parameter Real kpf=0.5 "Frequency dependence of load";
equation
  connect(line_L1_1.epp_OUT, epp) annotation (Line(
      points={{73.4,0},{86.7,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(LumpedGrid.epp, line_L1_1.epp_IN) annotation (Line(
      points={{40,0},{54.8,0}},
      color={0,135,135},
      thickness=0.5));
  connect(LumpedGrid.P_tie_is, line_L1_1.P) annotation (Line(points={{32.2,32.4},{32.2,40},{60.2,40},{60.2,7.8}}, color={0,0,127}));
  connect(P_tie_set.y, LumpedGrid.P_tie_set) annotation (Line(points={{23,80},{16.6,80},{16.6,32.4}}, color={0,0,127}));
  connect(genericGridError.y, LumpedGrid.P_Z) annotation (Line(points={{-5,80},{1,80},{1,32.4}}, color={0,0,127}));
  connect(LumpedGrid.E_kin, LocalStatisticsAdapter.E_kin) annotation (Line(points={{-34.1,32.4},{-34.1,72.4},{-60.52,72.4}}, color={0,0,127}));
  connect(LumpedGrid.P_load, LocalStatisticsAdapter.P_load) annotation (Line(points={{-21.62,32.4},{-21.62,54},{-42,54},{-42,72.4},{-60.52,72.4}}, color={0,0,127}));
  annotation (Icon(graphics={
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
          textString="IntegratedGrid")}),
                                Diagram(graphics,
                                        coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Non-detailled grid model electric grid model (including primary and secondary control models) witch a lumped generator model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"></span>Level of detail depends on the used submodels</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">checked in TransiEnt.Grid.Electrical.LumpedPowerGrid.Check)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LumpedGrid;
