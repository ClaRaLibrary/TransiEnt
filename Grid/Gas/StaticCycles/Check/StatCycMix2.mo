within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCycMix2

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";
   parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";

   parameter SI.Pressure p_source1=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute pressure";
   parameter SI.SpecificEnthalpy h_source1=785411 "|Sources|Specific enthalp";
   parameter SI.MassFraction xi_source1[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition";
   parameter SI.Pressure p_source2=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute pressure";
   parameter SI.SpecificEnthalpy h_source2=785411 "|Sources|Specific enthalpy";
   parameter SI.MassFraction xi_source2[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition";
   parameter SI.MassFlowRate m_flow_sink=1 "|Sinks|Mass flow in sink";
   parameter SI.PressureDifference Delta_p_nom_pipe1=0.1e5 "|Pipes|Nominal pressure drop in pipe 1";
   parameter SI.PressureDifference Delta_p_nom_pipe2=0.1e5 "|Pipes|Nominal pressure drop in pipe 2";
   parameter SI.PressureDifference Delta_p_nom_pipe3=0.1e5 "|Pipes|Nominal pressure drop in pipe 3";
   parameter SI.MassFlowRate m_flow_nom_pipe1=1 "|Pipes|Nominal mass flow rate in pipe 1";
   parameter SI.MassFlowRate m_flow_nom_pipe2=1 "|Pipes|Nominal mass flow rate in pipe 2";
   parameter SI.MassFlowRate m_flow_nom_pipe3=1 "|Pipes|Nominal mass flow rate in pipe 3";

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source(
    medium=medium,
    p=p_source1,
    h=h_source1,
    xi=xi_source1) annotation (Placement(transformation(extent={{-98,-16},{-62,16}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink(medium=medium, m_flow=m_flow_sink) annotation (Placement(transformation(
        extent={{-23,-22},{23,22}},
        rotation=270,
        origin={0,-74})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 split(medium=medium) annotation (Placement(transformation(
        extent={{-12,-8},{12,8}},
        rotation=0,
        origin={0,-5})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe1(
    Delta_p_nom=Delta_p_nom_pipe1,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe1,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-48,-4},{-28,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe3(
    Delta_p_nom=Delta_p_nom_pipe3,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe3,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{56,-4},{36,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe2(
    Delta_p_nom=Delta_p_nom_pipe2,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe2,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={0,-36})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow1(medium=medium) annotation (Placement(transformation(extent={{30,-4},{16,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source2(
    p=p_source2,
    medium=medium,
    h=h_source2,
    xi=xi_source2) annotation (Placement(transformation(
        extent={{17,-16},{-17,16}},
        rotation=0,
        origin={81,0})));
equation
  connect(source.outlet, pipe1.inlet) annotation (Line(points={{-67.58,0},{-67.58,0},{-46.3,0}}, color={0,131,169}));
  connect(pipe2.outlet, sink.inlet) annotation (Line(points={{-1.77636e-015,-46.2},{-1.77636e-015,-61.58},{2.66454e-015,-61.58}}, color={0,131,169}));
  connect(pipe3.outlet, valve_cutFlow1.inlet) annotation (Line(points={{35.8,0},{32,0},{32,-0.32},{29.44,-0.32}}, color={0,0,0}));
  connect(split.outlet, pipe2.inlet) annotation (Line(points={{0,-14.0667},{0,-27.7}}, color={0,0,0}));
  connect(valve_cutFlow1.outlet, split.inlet2) annotation (Line(points={{15.44,0},{11.04,0},{11.04,0.333333}}, color={0,0,0}));
  connect(pipe1.outlet, split.inlet1) annotation (Line(points={{-27.8,0},{-11.04,0},{-11.04,0.333333}}, color={0,0,0}));
  connect(pipe3.inlet, source2.outlet) annotation (Line(points={{54.3,0},{69.27,0}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle mixer 2.</p>
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
end StatCycMix2;
