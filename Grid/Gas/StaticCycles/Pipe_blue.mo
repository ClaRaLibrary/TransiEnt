within TransiEnt.Grid.Gas.StaticCycles;
model Pipe_blue " Pipe || blue | blue"

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
  // Blue input:  Value of p is known  in component and provided FOR neighbor component, values of m_flow, h and xi are unknown and provided BY neighbor component.
  // Blue output: Values of m_flow, h and xi are known in component and provided FOR neighbor component, value of p is unknown and provided BY beighbor component.

  import TransiEnt;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component"  annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";

  parameter SI.Pressure Delta_p_nom "|Fundamental Definitions|Nominal pressure loss";
  parameter SI.MassFlowRate m_flow_nom "|Fundamental Definitions|Nominal mass flow rate";
  parameter SI.Length z_in = 0.0 "|Fundamental Definitions|Geodetic height at inlet";
  parameter SI.Length z_out = 0.0 "|Fundamental Definitions|Geodetic height at outlet";

  final parameter SI.MassFlowRate m_flow(fixed=false);
  final parameter SI.Pressure p_in( fixed=false) "Inlet pressure";
  final parameter SI.Pressure p_out( fixed=false) "pressure at tube inlet";
  final parameter SI.SpecificEnthalpy h_in(fixed=false) "enthalpy at tube inlet";
  final parameter SI.MassFraction xi_in[medium.nc-1](fixed=false) "Inlet Mass Fraction";

  final parameter Real zeta_tot = if quadraticPressureLoss then Delta_p_nom/m_flow_nom^2 else 1.0*Delta_p_nom/m_flow_nom "Linear/quadratic pressure loss coefficient";
  final parameter SI.PressureDifference Delta_p_tot = if quadraticPressureLoss then zeta_tot*m_flow^2 else zeta_tot*m_flow "Pressure drop by quadratic/linear coefficient";
  final parameter SI.Pressure Delta_p_geo=TILMedia.VLEFluidFunctions.density_phxi(medium, p_in, h_in, xi_in) * Modelica.Constants.g_n * (z_out - z_in) "Geostatic pressure difference";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue inlet(Medium=medium, p=p_in) annotation (Placement(transformation(
        extent={{-11,-23},{11,23}},
        rotation=90,
        origin={-87,-1}), iconTransformation(
        extent={{-7,-17},{7,17}},
        rotation=90,
        origin={-83,1})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue outlet(
    Medium=medium,
    m_flow=m_flow,
    h=h_in,
    xi=xi_in) annotation (Placement(transformation(
        extent={{-10,-20},{10,20}},
        rotation=90,
        origin={112,0}), iconTransformation(
        extent={{-7,-18},{7,18}},
        rotation=90,
        origin={102,1})));
initial equation
  p_in = p_out + Delta_p_tot + Delta_p_geo;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  inlet.xi=xi_in;
  outlet.p=p_out;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-100,-40},{100,40}}),
                   graphics={
        Text(
          extent={{-100,0},{102,-20}},
          lineColor={0,131,169},
          textString="%name%",
          fontSize=8), Polygon(
          points={{-92,40},{-72,40},{-52,30},{52,30},{72,40},{92,40},{92,-40},{72,-40},{52,-30},{-52,-30},{-72,-40},{-92,-40},{-92,40}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-75},{100,75}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Pipe with blue inputs and outputs and choosable linear or quadratic nominal pressure loss.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end Pipe_blue;
