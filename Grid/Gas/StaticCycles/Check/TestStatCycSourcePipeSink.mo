within TransiEnt.Grid.Gas.StaticCycles.Check;
model TestStatCycSourcePipeSink

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
  extends TransiEnt.Basics.Icons.Checkmodel;

  Components.Boundaries.Gas.BoundaryRealGas_phxi boundaryRealGas_pTxi(
    p_const=Init.p_source,
    xi_const=Init.xi_source,
    h_const=Init.h_source) annotation (Placement(transformation(extent={{-86,-10},{-66,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow boundaryRealGas_hxim_flow(
    m_flow_const=Init.m_flow_sink,
    h_const=Init.source.h,
    xi_const=Init.source.xi,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,0})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1)                  annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  StatCycSourcePipeSink Init(
    Delta_p_nom_pipe=100000,
    m_flow_nom_pipe=10,
    m_flow_sink=-10)         annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP naturalGasVolumeFlowInNorm_HH_Reitbrook(constantfactor=2.710602*0.844499954) annotation (Placement(transformation(extent={{86,-16},{66,4}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe(
    Delta_p_nom=Init.Delta_p_nom_pipe,
    h_start=ones(pipe.N_cv)*Init.pipe.h_in,
    m_flow_start=ones(pipe.N_cv + 1)*Init.pipe.m_flow,
    xi_start=Init.pipe.xi_in,
    p_nom=ones(pipe.N_cv)*(simCenter.p_eff_2),
    h_nom=ones(pipe.N_cv)*8e5,
    diameter_i=0.9,
    p_start=linspace(
        Init.pipe.p_in,
        Init.pipe.p_out,
        pipe.N_cv),
    m_flow_nom=Init.m_flow_nom_pipe,
    length=40,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    N_cv=2,
    massBalance=1,
    frictionAtInlet=true,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-34,-5},{-6,5}})));
  Modelica.Blocks.Sources.Step step(
    startTime=1,
    height=-2,
    offset=-10) annotation (Placement(transformation(extent={{84,12},{64,32}})));
equation
  connect(pipe.gasPortOut, boundaryRealGas_hxim_flow.gasPort) annotation (Line(
      points={{-6,0},{12,0},{30,0}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_pTxi.gasPort, pipe.gasPortIn) annotation (Line(
      points={{-66,0},{-50,0},{-34,0}},
      color={255,255,0},
      thickness=1.5));
  connect(step.y, boundaryRealGas_hxim_flow.m_flow) annotation (Line(points={{63,22},{58,22},{58,-6},{52,-6}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=10, Interval=0.001),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
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
end TestStatCycSourcePipeSink;
