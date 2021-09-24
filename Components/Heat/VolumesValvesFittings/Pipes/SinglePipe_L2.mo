within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes;
model SinglePipe_L2 "Model of a pipe for use in district heating networks"


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

  import      Modelica.Units.SI;
  outer TransiEnt.SimCenter simCenter;

 // _____________________________________________
 //
 //                   Parameters
 // _____________________________________________

 // Initialization
  parameter SI.Pressure p_start = 10e5 "Pressure at start of Simulation" annotation(Dialog(group="Initialization"));
  parameter SI.Temperature T_start = 90+273.1 "Temperature at start of Simulation" annotation(Dialog(group="Initialization"));
  parameter SI.MassFlowRate m_flow_start = 1 "Mass flow at start of simulation - not used" annotation(Dialog(group="Initialization"));
  parameter SI.Velocity v_nom = simCenter.v_nom "Design velocity of pipe."
                                                                          annotation(Dialog(group="Initialization"));
  final parameter SI.SpecificEnthalpy h_start = pipe_parameter.h_start;
  parameter Boolean calc_initial_dstrb = true "Activates the calculation of a initial temperature distribution inside the pipes"
                                                                                                                                annotation(Dialog(group="HeatTransfer"));
  parameter Boolean activate_volumes= simCenter.activate_volumes "Activate / Deactivate volumes to better represent delayed temperatrue changes due to heat capacity effects"
                                                                                                                                                                             annotation(Dialog(group="HeatTransfer"));

 // Geometric data
  parameter SI.Length length = 10 "Length of the pipe" annotation(Dialog(group="Geometry"));
  parameter SI.Length depth = 1 "Buried depth of the pipe"
                                                          annotation(Dialog(group="Geometry"));
  parameter SI.Length distance = 0.4 "Buried distance between pipe_pair - not used"
                                                                                   annotation(Dialog(group="Geometry"));
  parameter SI.Length diameter_i = 0.0217 "Inner Diameter of the pipe"
                                                                      annotation(Dialog(group="Geometry"));
  parameter SI.Length diameter_o = 0.09 "Outer Diameter of the pipe"
                                                                    annotation(Dialog(group="Geometry"));
  parameter SI.Height z_in = 1 "Inlet Height of the pipe";
  parameter SI.Height z_out = 1 "Outlet Height of the pipe";
  parameter SI.Length pipe_wall_thickness = 0.0026 "Pipe Wall Thickness"
                                                                        annotation(Dialog(group="Geometry"));
  parameter SI.Length K = simCenter.K "average height of surface asperities"
                                                                            annotation(Dialog(group="Geometry"));

 // HeatTransfer
  parameter SI.ThermalConductivity lambda_insulation = 0.024 " Heattransfercoefficient of the insulation"
                                                                                                         annotation(Dialog(group="HeatTransfer"));
  parameter SI.SpecificHeatCapacity pipe_wall_capacity = pipe_parameter.pipe_wall_capacity "HeatCapacity of the pipe wall material"
                                                                                                                                   annotation(Dialog(group="HeatTransfer"));
  parameter SI.Density pipe_wall_d = pipe_parameter.pipe_wall_d "Density of the pipe wall material"
                                                                                                   annotation(Dialog(group="HeatTransfer"));

 // _____________________________________________
 //
 //                   Variables
 // _____________________________________________

  Real Q_loss = heat.Q_flow / length "Specif heat loss per meter";
  Real dp_m = dp_residencetime.dp/length "Specif pressure loss per meter";
  Real v = dp_residencetime.v_water "Velocity of the heat carrier";

 // _____________________________________________
 //
 //           Instances of other Classes
 // _____________________________________________

  replaceable model HeatTransfer =
      TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2              constrainedby TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_PlugFlow_Base_L2
                                                                                                                                                                                      annotation (choicesAllMatching=true,Dialog(group="HeatTransfer"));
  inner TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.pipe_parameters pipe_parameter(
    calc_initial_dstrb=calc_initial_dstrb,
    diameter_i=diameter_i,
    p_start=p_start,
    T_start=T_start,
    m_flow_start=m_flow_start,
    diameter_o=diameter_o,
    length=length,
    z_in=z_in,
    z_out=z_out,
    pipe_wall_thickness=pipe_wall_thickness,
    K=K,
    v_nom=v_nom,
    lambda_insulation=lambda_insulation) annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1)
    "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(each Medium=
        simCenter.fluid1) "Outlet port" annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));
  Pipes.Base.dp_residencetime dp_residencetime(calc_initial_dstrb=calc_initial_dstrb) annotation (Placement(transformation(extent={{-78,-16},{-42,16}})));
  HeatTransfer hT_PlugFlow_LX_nom annotation (Placement(transformation(extent={{20,-15},
            {52,15}})));
  HeatTransfer hT_PlugFlow_LX_rev annotation (Placement(transformation(extent={{2,-15},
            {-30,15}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_flex volume(
    useHomotopy=false,
    volume=pipe_parameter.carrier_pipe_capacity/(pipe_parameter.rho*pipe_parameter.cp_w),
    p_nom=p_start,
    h_nom=pipe_parameter.h_start,
    h_start=pipe_parameter.h_start_out,
    p_start=p_start,
    initOption=208) if  activate_volumes annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(waterPortIn, dp_residencetime.waterPortIn) annotation (Line(
      points={{-100,0},{-78,0}},
      color={175,0,0},
      thickness=0.5));
  connect(hT_PlugFlow_LX_rev.waterPortIn, hT_PlugFlow_LX_nom.waterPortIn) annotation (Line(
      points={{2,0},{20,0}},
      color={175,0,0},
      thickness=0.5));
  connect(dp_residencetime.waterPortOut, hT_PlugFlow_LX_rev.waterPortOut) annotation (Line(
      points={{-42,0},{-30,0}},
      color={175,0,0},
      thickness=0.5));
  connect(dp_residencetime.residence_time_reversed, hT_PlugFlow_LX_rev.residence_time) annotation (Line(points={{-40.2,
          -14.4},{-34,-14.4},{-34,-32},{-14,-32},{-14,-12}},                                                                                                            color={0,0,127}));
  connect(dp_residencetime.residence_time_nom, hT_PlugFlow_LX_nom.residence_time) annotation (Line(points={{-40.2,14.4},{-28,14.4},{-28,-40},{36,-40},{36,-12}}, color={0,0,127}));

  connect(heat, heat)
    annotation (Line(points={{0,100},{0,100}}, color={191,0,0}));
  connect(hT_PlugFlow_LX_rev.heat, heat) annotation (Line(points={{-14,15},{-14,52},{0,52},{0,100}},
                                        color={191,0,0}));
  connect(heat, hT_PlugFlow_LX_nom.heat) annotation (Line(points={{0,100},{0,52},{36,52},{36,15}},
                            color={191,0,0}));
  connect(hT_PlugFlow_LX_nom.waterPortOut, volume.inlet) annotation (Line(
      points={{52,0},{60,0}},
      color={175,0,0},
      thickness=0.5));

  if activate_volumes then
    connect(volume.outlet[1], waterPortOut) annotation (Line(
      points={{80,0},{100,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  else
    connect(hT_PlugFlow_LX_nom.waterPortOut, waterPortOut);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-78,24},{74,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-86,24},{-68,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{62,24},{86,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,20},{76,-20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{68,20},{82,-20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-84,20},{-68,-20}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-4,38},{-4,56},{-10,56},{0,70},{10,56},{4,56},{4,38},{-4,38}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-10,-7},{0,7},{10,-7},{-10,-7}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-16,0},
          rotation=-90),
        Rectangle(
          extent={{-4,8},{4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-30,0},
          rotation=-90),
        Rectangle(
          extent={{-4,8},{4,-8}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={26,0},
          rotation=-90),
        Polygon(
          points={{-10,-7},{0,7},{10,-7},{-10,-7}},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={40,0},
          rotation=-90)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Usage in simulation of district heating networks</p>
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
<p>For bigger simulations deactivate volume - underestimates the thermal delay by heating / cooling of the steel pipes </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Heat transfer based on: B. van der Heijde, M. Fuchs, C. Ribas Tugores &quot;Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems&quot;, 2017</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end SinglePipe_L2;
