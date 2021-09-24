within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base;
model dp_residencetime "Calculates the residence time as well as the pressure loss and delays enthalpy changes according to it"


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
  outer TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.pipe_parameters pipe_parameter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean calc_initial_dstrb = true "Activates the calculation of a initial temperature distribution inside the pipes"
                                                                                                                                annotation(Dialog(group="HeatTransfer"));
  final parameter SI.Pressure p_start = pipe_parameter.p_start "Pressure at start of simulation";
  final parameter SI.Temperature T_start = pipe_parameter.T_start "Temperature at start of simulation";
  final parameter SI.Temperature T_start_out = pipe_parameter.T_start_out;
  final parameter SI.MassFlowRate m_flow_start= 0.005 "Start Massflow";
  final parameter SI.Length diameter_i = pipe_parameter.diameter_i "Inner Diameter of the Pipe";
  final parameter SI.Height z_in = pipe_parameter.z_in "Inlet Height of the pipe";
  final parameter SI.Height z_out = pipe_parameter.z_out "Outlet Height of the pipe";
  final parameter SI.Height dz = z_in - z_out "Height difference between inlet and outlet";
  final parameter SI.Length length = pipe_parameter.length "Length of the pipe";
  final parameter SI.Length K = pipe_parameter.K "average height of surface asperities";
  final parameter SI.Velocity v_nom= simCenter.v_nom "Design Velocity of the pipe. Typically smaller than 2 m/s";

    //  Media Data
  final parameter SI.SpecificEnthalpy h_start = pipe_parameter.h_start;
  final parameter SI.SpecificEnthalpy h_start_out = pipe_parameter.h_start_out;
  final parameter SI.SpecificHeatCapacity cp_w = pipe_parameter.cp_w;
  final parameter SI.Density rho =  pipe_parameter.rho;
  final parameter SI.DynamicViscosity dyn_vis =  pipe_parameter.dyn_vis;
  final SI.SpecificEnthalpy h_in(start=h_start) = waterPortIn.h_outflow "Inlet enthalpy";
  final SI.SpecificEnthalpy h_out(start=h_start_out) = waterPortOut.h_outflow "Outlet enthalpy";

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Pressure dp(start= 0.005) "Pressure difference between inlet and outlet by friction";
  SI.Pressure dp_h(start = 0) "Pressure difference between inlet and outlet due to geostatic height difference";

  Real time_flow;
  Real time_reversed;
  SI.Velocity v_water "Velocity of the fluid";
  Real x "Coordinate for spatialDistribution";

  // _____________________________________________
  //
  //            Interfaces and Components
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_con inCon(
    d_hyd=diameter_i,
    L=length,
    roughness=Modelica.Fluid.Dissipation.Utilities.Types.Roughness.Considered,
    K=K)
    annotation (Placement(transformation(extent={{-28,-60},{-8,-40}})));
  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_var inVar(
      rho=rho, eta=dyn_vis)
               annotation (Placement(transformation(extent={{4,-60},{24,-40}})));
  Modelica.Blocks.Interfaces.RealOutput residence_time_nom
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput residence_time_reversed
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
initial equation

  x = 0;

equation
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  // Transport time calculation
  v_water =waterPortIn.m_flow/(rho*(1/4)*Modelica.Constants.pi*diameter_i^2);
  der(x) = v_water;
  (time_reversed,time_flow) = spatialDistribution(time,time,x/length,noEvent(v_water>=0), {1/v_nom,1.0},{ if calc_initial_dstrb then -((Modelica.Constants.pi*(1/4))*diameter_i^2*rho*cp_w) else 0, if calc_initial_dstrb then -((Modelica.Constants.pi*(1/4))*diameter_i^2*rho*cp_w) else 0});
  residence_time_nom = time - time_flow;
  residence_time_reversed = time - time_reversed;

  // Delayed flow calculation
  (waterPortIn.h_outflow,waterPortOut.h_outflow) = spatialDistribution(
    inStream(waterPortIn.h_outflow),
    inStream(waterPortOut.h_outflow),
    x/length,
    v_water >= 0,
     {1/v_nom,1.0},
    {h_start_out,h_start_out});

  // Conservation equations
  waterPortIn.m_flow + waterPortOut.m_flow = 0;
  waterPortIn.xi_outflow = inStream(waterPortOut.xi_outflow);
  waterPortOut.xi_outflow = inStream(waterPortIn.xi_outflow);

  // PressureLoss with Darcy-Weißbach-Equation
  waterPortIn.m_flow = Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
    inCon,
    inVar,
    dp);

  if dz == 0 then
    dp_h = 0;
  else
    dp_h = ((1.2041 - rho)/dz)*Modelica.Constants.g_n;
  end if;

  waterPortOut.p = waterPortIn.p - (dp+dp_h);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-64,40},{-36,-40}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-74,40},{-54,-40}},
          fillColor={212,212,212},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-46,40},{-26,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,40},{12,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-18,40},{2,-40}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{2,40},{22,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{38,40},{66,-40}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{28,40},{48,-40}},
          fillColor={212,212,212},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{56,40},{76,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-4,-16},{-4,2},{-10,2},{0,16},{10,2},{4,2},{4,-16},{-4,-16}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={2,-62},
          rotation=270)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Calculates pressure drop and thermal delay of temperature changes with respect to flow velocity and pipe length </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See Reference</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>B. van der Heijde, M. Fuchs, C. Ribas Tugores &quot;Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems&quot;, 2017</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end dp_residencetime;
