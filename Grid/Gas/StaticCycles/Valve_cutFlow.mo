within TransiEnt.Grid.Gas.StaticCycles;
model Valve_cutFlow "Valve || yellow | red"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  // yellow input: Values of p, h and xi are unknown and provided BY neighbor component, value of m_flow is set or computed internally and provided FOR neighbor component.
  // red output:   Values of p and m_flow are unknown and provided BY neighbor component, values of h and xi are set or computed internally and provided FOR neighbor component.

  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";

  final parameter SI.MassFlowRate m_flow(fixed=false) "Mass flow rate";

  final parameter SI.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter SI.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter SI.SpecificEnthalpy h_in(fixed=false) "Inlet specific enthalpy";
  final parameter SI.SpecificEnthalpy h_out=h_in "Outlet specific enthalpy";
  final parameter SI.Pressure Delta_p=p_in-p_out "Pressure difference";
  final parameter SI.MassFraction xi_in[medium.nc-1](fixed=false) "Inlet mass specific composition";
  final parameter SI.MassFraction xi_out[medium.nc-1]=xi_in "Outlet mass specific composition";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow inlet(Medium=medium, m_flow=m_flow) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-44,0}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-46,-2})));
  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_red outlet(
    Medium=medium,
    h=h_out,
    xi=xi_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,0}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={54,0})));

initial equation
  inlet.p=p_in;
  inlet.h=h_in;
  inlet.xi=xi_in;
  outlet.m_flow=m_flow;
  outlet.p=p_out;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{-50,-25},{50,25},{50,-25},{-50,25},{-50,-25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Transfering from yellow output to red input.</p>
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
end Valve_cutFlow;
