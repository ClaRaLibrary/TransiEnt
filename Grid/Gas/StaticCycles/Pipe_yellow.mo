within TransiEnt.Grid.Gas.StaticCycles;
model Pipe_yellow " Pipe || yellow | yellow"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  // yellow input: Values of p, h and xi are unknown and provided BY neighbor component, value of m_flow is set or computed internally and provided FOR neighbor component.
  // yellow output: Value m_flow is unknown and provided BY neighbor component, values of p, h and xi are set or computed internally and provided FOR neighbor component.

  import TransiEnt;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";

  parameter SI.Pressure Delta_p_nom "|Fundamental Definitions|Nominal pressure loss";
  parameter SI.MassFlowRate m_flow_nom "|Fundamental Definitions|Nominal mass flow rate";
  parameter SI.Length z_in = 0.0 "|Fundamental Definitions|Geodetic height at inlet";
  parameter SI.Length z_out = 0.0 "|Fundamental Definitions|Geodetic height at outlet";

  final parameter SI.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter SI.SpecificEnthalpy h_in(fixed=false) "Inlet specific enthalpy";
  final parameter SI.MassFraction xi_in[medium.nc-1](fixed=false) "Inlet mass specific composition";

  final parameter SI.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter Real zeta_tot = if quadraticPressureLoss then Delta_p_nom/m_flow_nom^2 else 1.0*Delta_p_nom/m_flow_nom "Linear/quadratic pressure loss coefficient";
  final parameter SI.PressureDifference Delta_p_tot = if quadraticPressureLoss then zeta_tot*m_flow^2 else zeta_tot*m_flow "Pressure drop by quadratic/linear coefficient";
  final parameter SI.Pressure p_out = p_in - Delta_p_tot - Delta_p_grav "Outlet pressure";
  final parameter SI.Pressure Delta_p_grav=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(medium, p_in, h_in, xi_in) * Modelica.Constants.g_n * (z_out - z_in) "Geostatic pressure difference";

public
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow inlet(Medium=medium, m_flow=m_flow) annotation (Placement(transformation(
        extent={{-11,-23},{11,23}},
        rotation=90,
        origin={-86,0}), iconTransformation(
        extent={{-7,-17},{7,17}},
        rotation=90,
        origin={-83,0})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow outlet(
    Medium=medium,
    h=h_in,
    p=p_out,
    xi=xi_in) annotation (Placement(transformation(
        extent={{-10,-20},{10,20}},
        rotation=90,
        origin={92,0}), iconTransformation(
        extent={{-7,-18},{7,18}},
        rotation=90,
        origin={102,0})));

initial equation
  inlet.p=p_in;
  outlet.m_flow=m_flow;
  inlet.h=h_in;
  inlet.xi=xi_in;
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
<p>Pipe with yellow inputs and outputs and choosable linear or quadratic nominal pressure loss.</p>
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
end Pipe_yellow;
