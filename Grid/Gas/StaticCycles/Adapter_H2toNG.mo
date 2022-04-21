within TransiEnt.Grid.Gas.StaticCycles;
model Adapter_H2toNG "AdapterH2NG || yellow | red"



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




  // blue input:  Values of m_flow, h and xi are unknown and provided BY neighbor component, value of p is set or computed internally and provided FOR neighbor component.
  // blue output: Value of p is unknown and provided BY beighbor component, values of m_flow, h and xi are set or computed internally and provided FOR neighbor component.

  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumIn = simCenter.gasModel3 "Medium in the component";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumOut = simCenter.gasModel1 "Medium in the component";

  final parameter SI.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter SI.Pressure p(fixed=false) "Pressure";

  final parameter SI.SpecificEnthalpy h_in(fixed=false) "Inlet specific enthalpy";
  final parameter SI.SpecificEnthalpy h_out(fixed=false) "Outlet specific enthalpy";
  final parameter SI.MassFraction xi_in[mediumIn.nc-1](fixed=false) "Inlet mass specific composition";
  final parameter SI.MassFraction xi_out[mediumOut.nc-1](fixed=false) "Outlet mass specific composition";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue inlet(Medium=mediumIn, p=p) annotation (Placement(transformation(
        extent={{-6,-15},{6,15}},
        rotation=90,
        origin={-41,-8.88178e-016}), iconTransformation(
        extent={{-7,-17},{7,17}},
        rotation=90,
        origin={-51,0})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue outlet(
    Medium=mediumOut,
    m_flow=m_flow,
    h=h_out,
    xi=xi_out) annotation (Placement(transformation(
        extent={{-6,-14},{6,14}},
        rotation=90,
        origin={58,-1}), iconTransformation(
        extent={{-7,-18},{7,18}},
        rotation=90,
        origin={66,0})));

  final parameter SI.Temperature T_H2 = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
    vleFluidType=mediumIn,
    p=p,
    h=h_in,
    xi=xi_in) "Temperature of H2";

initial equation
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  inlet.xi=xi_in;
  outlet.p=p;

  xi_out = zeros(mediumOut.nc-1);
  h_out = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
    vleFluidType=mediumOut,
    p=p,
    T=T_H2,
    xi=xi_out);

  annotation (defaultComponentName="h2toNG",Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-60,-60},{60,60}}),
                   graphics={
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={28,108,200}),
        Text(
          extent={{-66,48},{-18,26}},
          lineColor={0,0,0},
          textString="VLE
H2"),   Text(
          extent={{18,-28},{64,-50}},
          lineColor={0,0,0},
          textString="VLE
NG"),   Polygon(points={{-10,-40},{-10,40},{-20,40},{-30,8},{-44,8},{-44,-8},{-30,-8},{-20,-40},{-10,-40}}, lineColor={28,108,200}),
        Polygon(points={{10,-40},{10,40},{20,40},{30,8},{44,8},{44,-8},{30,-8},{20,-40},{10,-40}}, lineColor={28,108,200})}),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adapter from hydrogen to natural gas mixture.</p>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end Adapter_H2toNG;
