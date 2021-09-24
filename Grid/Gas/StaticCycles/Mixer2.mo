within TransiEnt.Grid.Gas.StaticCycles;
model Mixer2 "Split || yellow | blue | yellow"


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



  // yellow input: Values of p, h and xi are unknown and provided BY neighbor component, value of m_flow is set or computed internally and provided FOR neighbor component.
  // blue input:   Values of m_flow, h and xi are unknown and provided BY neighbor component, value of p is set or computed internally and provided FOR neighbor component.
  // yellow output: Value m_flow is unknown and provided BY neighbor component, values of p, h and xi are set or computed internally and provided FOR neighbor component.

  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";

  final parameter SI.MassFlowRate m_flow_in1(fixed=false) "Inlet 1 mass flow rate";
  final parameter SI.MassFlowRate m_flow_in2(fixed=false) "Inlet 1 mass flow rate";
  final parameter SI.MassFlowRate m_flow_out(fixed=false) "Outlet mass flow rate";

  final parameter SI.SpecificEnthalpy h_in1(fixed=false) "Inlet 1 specific enthalpy";
  final parameter SI.SpecificEnthalpy h_in2(fixed=false) "Inlet 2 specific enthalpy";
  final parameter SI.SpecificEnthalpy h_out(fixed=false) "Outlet specific enthalpy";

  final parameter SI.MassFraction xi_in1[medium.nc-1]( fixed=false) "Inlet 1 mass specific composition";
  final parameter SI.MassFraction xi_in2[medium.nc-1]( fixed=false) "Inlet 2 mass specific composition";
  final parameter SI.MassFraction xi_out[medium.nc-1]( fixed=false) "Outlet mass specific composition";

  final parameter SI.Pressure p(fixed=false) "Mixer pressure";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow outlet(
    Medium=medium,
    h=h_out,
    p=p,
    xi=xi_out) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={54,20}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={54,20})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow inlet1(Medium=medium, m_flow=m_flow_in1) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-46,20}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-46,20})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue inlet2(Medium=medium, p=p) annotation (Placement(transformation(
        extent={{-4,10},{4,-10}},
        rotation=0,
        origin={-2,-26}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=180,
        origin={0,-26})));

initial equation

  m_flow_in1 = m_flow_out - m_flow_in2;
  h_out=(h_in1*m_flow_in1+h_in2*m_flow_in2)/m_flow_out;
  xi_out = (m_flow_in1*xi_in1+m_flow_in2*xi_in2)/m_flow_out;

  outlet.m_flow = m_flow_out;
  inlet1.p = p;
  inlet1.h=h_in1;
  inlet1.xi=xi_in1;
  inlet2.m_flow = m_flow_in2;
  inlet2.h=h_in2;
  inlet2.xi=xi_in2;

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
<p>Mixing junction.</p>
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
end Mixer2;
