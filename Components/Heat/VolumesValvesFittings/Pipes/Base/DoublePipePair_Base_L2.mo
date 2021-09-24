within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base;
model DoublePipePair_Base_L2 "Base model of a pair of district heating pipes"


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




  import      Modelica.Units.SI;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Length length= 5 "Length of the Pipe" annotation(Dialog(group="Pipe Data"));
  parameter SI.Length distance = 0.35 "Distance of the pipes" annotation(Dialog(group="Pipe Data"));
  parameter Integer DN = 20 "Nominal Diameter of the pipes" annotation(Dialog(group="Pipe Data"));
  parameter SI.Length diameter_i = simCenter.DNmat[Basics.Functions.getIndex(DN,simCenter.DHN_Pipe_Manufacturer.rowAmount,simCenter.DNmat),2] "Inner diameter of the carrier pipe";
  parameter SI.Length diameter_o = simCenter.DNmat[Basics.Functions.getIndex(DN,simCenter.DHN_Pipe_Manufacturer.rowAmount,simCenter.DNmat),3] "Outer diameter of the insulation including casing";
  parameter SI.Length pipe_wall_thickness = simCenter.DNmat[Basics.Functions.getIndex(DN,simCenter.DHN_Pipe_Manufacturer.rowAmount,simCenter.DNmat),4] "Pipe wall thickness of the carrier pipe";
  parameter SI.Length depth = 1 "Depth of the pipes - not used in the Version";
  parameter SI.ThermalConductivity lambda_insulation = 0.0024 "Thermal conductivity of the insulation";
  parameter SI.ThermalConductivity lambda_ground = 1.2 "Thermal conductivity of the ground";
  parameter SI.Length K = 0.000045 "Surface roughness";
  parameter SI.Pressure p_start_supply = simCenter.p_nom[2] "Pressure in supply pipe at start of the simulation";
  parameter SI.Pressure p_start_return = simCenter.p_nom[1] "Pressure in return pipe at start of the simulation";
  parameter SI.Temperature T_start_supply = 120+273.15 "Temperature in supply pipe at start of the simulation";
  parameter SI.Temperature T_start_return = 70+273.15 "Temperature in return pipe at start of the simulation";
  parameter SI.MassFlowRate m_flow_start = 0.001 "Starting mass flow";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_supply(Medium=
        simCenter.fluid1) "Inlet port" annotation (Placement(transformation(
          extent={{-110,30},{-90,50}}), iconTransformation(extent={{-110,30},{-90,
            50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_return(
      Medium=simCenter.fluid1) "Outlet port" annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_supply(
      Medium=simCenter.fluid1) "Outlet port" annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,
            30},{110,50}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_return(
      Medium=simCenter.fluid1) "Inlet port" annotation (Placement(
        transformation(extent={{90,-50},{110,-30}}), iconTransformation(extent={
            {92,-50},{112,-30}})));

  ClaRa.Basics.Interfaces.HeatPort_a heat_return
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  ClaRa.Basics.Interfaces.HeatPort_a heat_supply
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));

equation

     annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-104}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-20},{82,-60}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-94,60},{-94,60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,80},{-26,80}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-82,58},{80,18}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-4,-24},{-4,2},{-14,2},{-4.57818e-015,24},{14,2},{4,2},{4,-24},
              {-4,-24}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={2,38},
          rotation=270,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{24,4},{-2,4},{-2,14},{-24,0},{-2,-14},{-2,-4},{24,-4},{24,4}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={4,-40},
          rotation=360,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-90,58},{-74,18}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{72,58},{88,18}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-88,-20},{-72,-60}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{74,-20},{90,-60}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-4,58},{-4,76},{-10,76},{0,90},{10,76},{4,76},{4,58},{
              -4,58}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-4,-16},{-4,2},{-10,2},{0,16},{10,2},{4,2},{4,-16},{-4,
              -16}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={0,-76},
          rotation=180)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base class of parallel district heating pipe pairs</p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end DoublePipePair_Base_L2;
