within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCycSourcePipeSink

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.ModelStaticCycle;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used";

  parameter SI.Pressure p_source=simCenter.p_eff_2+simCenter.p_amb_const;
  parameter SI.SpecificEnthalpy h_source=785411;
  parameter SI.MassFraction xi_source[:]=medium.xi_default;
  parameter SI.MassFlowRate m_flow_sink=141;
  parameter SI.PressureDifference Delta_p_nom_pipe=0.8e5;
  parameter SI.MassFlowRate m_flow_nom_pipe=141;

  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe(
    medium=medium,
    Delta_p_nom=Delta_p_nom_pipe,
    m_flow_nom=m_flow_nom_pipe) annotation (Placement(transformation(
        extent={{-21,-9.5},{21,9.5}},
        rotation=0,
        origin={-1,0.5})));

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source(
    p=p_source,
    h=h_source,
    xi=xi_source) annotation (Placement(transformation(extent={{-98,-27},{-40,27}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink_mflow(m_flow=m_flow_sink) annotation (Placement(transformation(extent={{46,-27},{100,27}})));

equation
  connect(source.outlet, pipe.inlet) annotation (Line(points={{-48.99,0},{-32,0.5},{-18.43,0.5}},          color={0,131,169}));
  connect(pipe.outlet, sink_mflow.inlet) annotation (Line(points={{20.42,0.5},{20.42,0},{58.42,0}},
                                                                                                 color={0,131,169}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle.</p>
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
end StatCycSourcePipeSink;
