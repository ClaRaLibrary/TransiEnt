within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base;
partial model HT_PlugFlow_Base_L2 "Base class for PlugFlow Heat Transfer Models"


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

  //Geometricdata
  final parameter SI.Length diameter_i =  pipe_parameter.diameter_i "Inner Diameter of the Pipe";
  final parameter SI.Length diameter_o = pipe_parameter.diameter_o "Outer Diameter of the Pipe";
  final parameter SI.Length pipe_wall_thickness = pipe_parameter.pipe_wall_thickness "Pipe Wall Thickness";
  final parameter SI.Length length = pipe_parameter.length "Length of the pipe";
  final parameter SI.ThermalConductivity lambda_insulation = pipe_parameter.lambda_insulation " Thermal Conductivity of the Insulation";

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  //HeatTransfer
  Real R(unit="(m.K)/W") "Thermal Resistance of the Pipe per meter";
  Real C(unit="J/(K.m)")  "Heat Capacity per meter";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1)
    "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=
        simCenter.fluid1) "Outlet port" annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Modelica.Blocks.Interfaces.RealInput residence_time
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-100}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-80})));

 annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,40},{40,-40}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{30,40},{50,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-16,40},{4,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,40},{-6,-40}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-50,40},{-30,-40}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-6,40},{-6,58},{-12,58},{-2,72},{8,58},{2,58},{2,40},{-6,
              40}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-4,-16},{-4,2},{-10,2},{0,16},{10,2},{4,2},{4,-16},{-4,-16}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={-70,0},
          rotation=270)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base class of the heat loss models for a district heating pipe </p>
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
end HT_PlugFlow_Base_L2;
