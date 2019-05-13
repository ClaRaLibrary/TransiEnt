within TransiEnt.Grid.Gas.StaticCycles;
model Consumer "Gas consumer || yellow"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Consumer;
  outer TransiEnt.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1;

  parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";
  parameter SI.MassFlowRate m_flow "Mass flow rate in sink";
  parameter SI.Pressure Delta_p_nom "Nominal pressure loss of pipe network";
  parameter SI.MassFlowRate m_flow_nom "Nominal mass flow rate of pipe network";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow steamSignal_yellow(Medium=medium) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-96,0}), iconTransformation(
        extent={{-8,-20},{8,20}},
        rotation=90,
        origin={-90,0})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe(
    Delta_p_nom=Delta_p_nom,
    medium=medium,
    m_flow_nom=m_flow_nom,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-28,-4},{-8,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink_mflow(m_flow=m_flow) annotation (Placement(transformation(extent={{32,-20},{72,20}})));
equation
  connect(pipe.outlet, sink_mflow.inlet) annotation (Line(points={{-7.8,0},{41.2,0},{41.2,3.33067e-016}},   color={0,0,0}));
  connect(pipe.inlet, steamSignal_yellow) annotation (Line(points={{-26.3,0},{-66.15,0},{-96,0}},                 color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Gas consumer with pipe.</p>
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
end Consumer;
