within TransiEnt.Producer.Combined.SmallScaleCHP.Check;
model TestSmallScaleCHP_simple
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,50})));
  SmallScaleCHP_simple_fluidPorts smallScaleCHP_simple annotation (Placement(transformation(extent={{-50,20},{10,80}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-74,46},{-66,54}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_m_flow=false, boundaryConditions(m_flow_const=-1)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,50})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi(boundaryConditions(p_const(displayUnit="bar") = 100000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,72})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{88,28},{68,48}})));
  Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(gain.y, smallScaleCHP_simple.Q_flow_set) annotation (Line(points={{-65.6,50},{-50,50}}, color={0,0,127}));
  connect(sine.y, gain.u) annotation (Line(points={{-79,50},{-74.8,50}},
                                                                       color={0,0,127}));
  connect(smallScaleCHP_simple.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{10,38},{68,38}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryVLE_Txim_flow.fluidPortOut, smallScaleCHP_simple.waterPortIn) annotation (Line(
      points={{40,50},{26,50},{26,44},{10,44}},
      color={175,0,0},
      thickness=0.5));
  connect(smallScaleCHP_simple.waterPortOut, boundaryVLE_pTxi.fluidPortIn) annotation (Line(
      points={{10,56},{26,56},{26,72},{40,72}},
      color={175,0,0},
      thickness=0.5));
  connect(ElectricGrid.epp, smallScaleCHP_simple.epp) annotation (Line(
      points={{40,10},{26,10},{26,26},{10,26}},
      color={0,135,135},
      thickness=0.5));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=432000, Interval=900),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for HeatPumpGasCharline</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
</html>"));
end TestSmallScaleCHP_simple;