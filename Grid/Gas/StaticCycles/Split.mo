within TransiEnt.Grid.Gas.StaticCycles;
model Split "Split || yellow | yellow | yellow"

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
  // yellow input: Values of p, h and xi are unknown and provided BY neighbor component, value of m_flow is set or computed internally and provided FOR neighbor component.
  // yellow output: Value m_flow is unknown and provided BY neighbor component, values of p, h and xi are set or computed internally and provided FOR neighbor component.
  // yellow output: Value m_flow is unknown and provided BY neighbor component, values of p, h and xi are set or computed internally and provided FOR neighbor component.

  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";

  final parameter SI.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow rate";
  final parameter SI.MassFlowRate m_flow_out1(fixed=false) "Outlet 1 mass flow rate";
  final parameter SI.MassFlowRate m_flow_out2(fixed=false) "Outlet 2 mass flow rate";

  final parameter SI.SpecificEnthalpy h_in(fixed=false) "Inlet specific enthalpy";
  final parameter SI.Pressure p(fixed=false) "Mixer pressure";
  final parameter SI.MassFraction xi_in[medium.nc-1](fixed=false) "Inlet mass specific composition";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow inlet(Medium=medium, m_flow=m_flow_in) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={46,20}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={46,20})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow outlet1(
    Medium=medium,
    h=h_in,
    p=p,
    xi=xi_in) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={-54,20}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={-54,20})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow outlet2(
    Medium=medium,
    h=h_in,
    p=p,
    xi=xi_in) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={0,-34}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={0,-34})));

initial equation
  m_flow_in = m_flow_out1 + m_flow_out2;

  inlet.p=p;
  inlet.h=h_in;
  inlet.xi=xi_in;
  outlet1.m_flow = m_flow_out1;
  outlet2.m_flow = m_flow_out2;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false,extent={{-50,-30},{50,30}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Splitting junction.</p>
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
<p>Revised by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end Split;
