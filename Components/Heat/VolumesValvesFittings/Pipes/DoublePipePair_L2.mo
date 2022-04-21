within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes;
model DoublePipePair_L2 "Model of two parallel district heating pipes at same length and depth"



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
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Initialization
  parameter Modelica.Units.SI.Pressure p_start_supply=10e5 "Pressure at start of Simulation for the supply pipe" annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_supply=120 + 273.1 "Temperature at start of Simulation for the supply pipe" annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Pressure p_start_return=3e5 "Pressure at start of Simulation for the return pipe" annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_return=70 + 273.1 "Temperature at start of Simulation for the return pipe" annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=1 annotation (Dialog(group="Initialization"));
  parameter SI.Velocity v_nom = simCenter.v_nom "Design velocity of pipe."
                                                                          annotation(Dialog(group="Initialization"));

  // Geometric data
  parameter Modelica.Units.SI.Length length=10 "Length of the pipes" annotation (Dialog(group="Geometry"));

  parameter Integer DN = 20 "Nominal Diameter of the Pipes" annotation (Dialog(group="Geometry"));

  parameter Modelica.Units.SI.Length diameter_i=simCenter.DNmat[TransiEnt.Basics.Functions.getIndex(
      DN,
      simCenter.DHN_Pipe_Manufacturer.rowAmount,
      simCenter.DNmat), 2] "Inner Diameter of the pipe" annotation (Dialog(group="Geometry", enable=no_DN_Table));
  parameter Modelica.Units.SI.Length diameter_o=simCenter.DNmat[TransiEnt.Basics.Functions.getIndex(
      DN,
      simCenter.DHN_Pipe_Manufacturer.rowAmount,
      simCenter.DNmat), 3] "Outer Diameter of the pipe" annotation (Dialog(group="Geometry", enable=no_DN_Table));
  parameter Modelica.Units.SI.Length pipe_wall_thickness=simCenter.DNmat[TransiEnt.Basics.Functions.getIndex(
      DN,
      simCenter.DHN_Pipe_Manufacturer.rowAmount,
      simCenter.DNmat), 4] "Pipe Wall Thickness" annotation (Dialog(group="Geometry", enable=no_DN_Table));
  parameter Modelica.Units.SI.Length K=simCenter.K "average height of surface asperities" annotation (Dialog(group="Geometry", enable=no_DN_Table));

  // HeatTransfer
  parameter Modelica.Units.SI.ThermalConductivity lambda_insulation=0.024 " Heattransfercoefficient of the insulation" annotation (Dialog(group="HeatTransfer"));
  parameter Boolean calc_initial_dstrb = simCenter.calc_initial_dstrb "Activates the calculation of a initial temperature distribution inside the pipes" annotation(Dialog(group="HeatTransfer"));
  parameter Boolean activate_volumes= simCenter.activate_volumes "Activate / Deactivate volumes to better represent delayed temperatrue changes due to heat capacity effects"
                                                                                                                                                                             annotation(Dialog(group="HeatTransfer"));
  parameter SI.SpecificHeatCapacity pipe_wall_capacity = simCenter.pipe_wall_capacity "HeatCapacity of the pipe wall material"
                                                                                                                              annotation(Dialog(group="HeatTransfer"));
  parameter SI.Density pipe_wall_d = simCenter.pipe_wall_d "Density of the pipe wall material"
                                                                                              annotation(Dialog(group="HeatTransfer"));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Real Q_loss_specific_supply = heat_supply.Q_flow / length "Specif heat loss per meter of the supply pipe";
  Real Q_loss_specific_return = heat_return.Q_flow / length "Specif heat loss per meter of the return pipe";
  Real dp_m_supply = abs(singlePipe_LX_supply.dp_residencetime.dp/length) "Specif pressure loss per meter of the supply pipe";
  Real dp_m_return = abs(singlePipe_LX_return.dp_residencetime.dp/length) "Specif pressure loss per meter of the return pipe";
  Real v = singlePipe_LX_supply.dp_residencetime.v_water "Velocity of the heat carrier";
  Real avrg_dp_m = (dp_m_supply + dp_m_return) / 2 "Average Specific pressure loss per meter";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_supply(Medium=simCenter.fluid1) "Inlet port"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(extent={{-110,30},{-90,50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_return(Medium=simCenter.fluid1) "Outlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-50},{-90,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_return(Medium=simCenter.fluid1) "Inlet port"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}), iconTransformation(extent={{92,-50},{112,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_supply(Medium=simCenter.fluid1) "Outlet port"
    annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,30},{110,50}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat_supply annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat_return annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  SinglePipe_L2 singlePipe_LX_supply(
    v_nom=v_nom,
    calc_initial_dstrb=calc_initial_dstrb,
    activate_volumes=activate_volumes,
    pipe_wall_capacity=pipe_wall_capacity,
    pipe_wall_d=pipe_wall_d,
    redeclare model HeatTransfer = HeatTransfer,
    length=length,
    diameter_i=diameter_i,
    diameter_o=diameter_o,
    pipe_wall_thickness=pipe_wall_thickness,
    K=K,
    p_start=p_start_supply,
    T_start=T_start_supply,
    m_flow_start=m_flow_start,
    lambda_insulation=lambda_insulation) annotation (Placement(transformation(extent={{-28,13},{28,67}})));
  SinglePipe_L2 singlePipe_LX_return(
    v_nom=v_nom,
    calc_initial_dstrb=calc_initial_dstrb,
    activate_volumes=activate_volumes,
    pipe_wall_capacity=pipe_wall_capacity,
    pipe_wall_d=pipe_wall_d,
    redeclare model HeatTransfer = HeatTransfer,
    length=length,
    diameter_i=diameter_i,
    diameter_o=diameter_o,
    pipe_wall_thickness=pipe_wall_thickness,
    K=K,
    p_start=p_start_return,
    T_start=T_start_return,
    m_flow_start=m_flow_start,
    lambda_insulation=lambda_insulation) annotation (Placement(transformation(extent={{29,-15},{-29,-65}})));
  replaceable model HeatTransfer =
      Base.HT_Single_Buried_L2 constrainedby Base.HT_PlugFlow_Base_L2
  "HeatTransfer-Model choice for district heating" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-8,12},{12,32}})));

equation
  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(singlePipe_LX_return.waterPortIn, waterPortIn_return) annotation (Line(
      points={{29,-40},{100,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortIn_supply, singlePipe_LX_supply.waterPortIn) annotation (Line(
      points={{-100,40},{-28,40}},
      color={175,0,0},
      thickness=0.5));

  connect(waterPortOut_return, singlePipe_LX_return.waterPortOut) annotation (Line(
      points={{-100,-40},{-29,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(singlePipe_LX_supply.waterPortOut, waterPortOut_supply) annotation (Line(
      points={{28,40},{64,40},{64,40},{100,40}},
      color={175,0,0},
      thickness=0.5));
  connect(heat_supply, singlePipe_LX_supply.heat)
    annotation (Line(
      points={{0,100},{0,67}},
      color={167,25,48},
      thickness=0.5));
  connect(heat_return, singlePipe_LX_return.heat) annotation (Line(
      points={{0,-100},{0,-65}},
      color={167,25,48},
      thickness=0.5));
  annotation (Icon(graphics={
        Ellipse(extent={{61,60},{79,20}}, pattern=LinePattern.None),
        Rectangle(
          extent={{-70,60},{70,20}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-79,60},{-61,20}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{61,60},{79,20}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-70,-20},{70,-60}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-79,-20},{-61,-60}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{61,-20},{79,-60}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-62,56},{60,86}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="%name
"),     Polygon(
          points={{-10,-7},{0,7},{10,-7},{-10,-7}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-8,40},
          rotation=-90),
        Rectangle(
          extent={{-4,8},{4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-22,40},
          rotation=-90),
        Polygon(
          points={{-10,-7},{0,7},{10,-7},{-10,-7}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={28,40},
          rotation=-90),
        Rectangle(
          extent={{-4,8},{4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={14,40},
          rotation=-90),
        Polygon(
          points={{-7,-10},{7,0},{-7,10},{-7,-10}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-26,-38},
          rotation=180),
        Rectangle(
          extent={{4,8},{-4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-12,-38},
          rotation=-90),
        Polygon(
          points={{-7,-10},{7,0},{-7,10},{-7,-10}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={12,-38},
          rotation=180),
        Rectangle(
          extent={{4,8},{-4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={26,-38},
          rotation=-90)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Usage in simulation of district heating networks with the traditional parallel supply return layout</p>
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
<p>For bigger simulations deactivate volume - underestimates the thermal delay by heating / cooling of the steel pipes.</p>
<p>Residence time is limited to 10h to improve initialisation with no mass flow present in the system at time = 0. </p>
<p>Pressure loss is linearized for mass flow rates with 5&percnt; of the nominal velocity.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Heat transfer based on: B. van der Heijde, M. Fuchs, C. Ribas Tugores &quot;Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems&quot;, 2017</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Philipp Huismann (huismann@gwi-essen.de) on 07.04.2022 | Pressure Loss linearisation for small mass flow rates, Residence Time limitation</span></p>
</html>"));
end DoublePipePair_L2;
