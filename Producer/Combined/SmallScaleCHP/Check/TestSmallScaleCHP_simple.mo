within TransiEnt.Producer.Combined.SmallScaleCHP.Check;
model TestSmallScaleCHP_simple
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
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,60})));
  SmallScaleCHP_simple smallScaleCHP_simple(useGasPort=true) annotation (Placement(transformation(extent={{-50,30},{10,90}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-74,56},{-66,64}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_m_flow=false, boundaryConditions(m_flow_const=-1)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,60})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi(boundaryConditions(p_const(displayUnit="bar") = 100000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,82})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{88,38},{68,58}})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-44})));
  SmallScaleCHP_simple smallScaleCHP_simple1(useGasPort=true, useFluidPorts=false)
                                                             annotation (Placement(transformation(extent={{-50,-78},{10,-18}})));
  Modelica.Blocks.Math.Gain gain1(k=-1)
                                       annotation (Placement(transformation(extent={{-74,-48},{-66,-40}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1
                                                               annotation (Placement(transformation(extent={{86,-70},{66,-50}})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(extent={{40,-94},{60,-74}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15)
                                                                                    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-2})));
equation
  connect(gain.y, smallScaleCHP_simple.Q_flow_set) annotation (Line(points={{-65.6,60},{-50,60}}, color={0,0,127}));
  connect(sine.y, gain.u) annotation (Line(points={{-79,60},{-74.8,60}},
                                                                       color={0,0,127}));
  connect(smallScaleCHP_simple.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{10,48},{68,48}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryVLE_Txim_flow.fluidPortOut, smallScaleCHP_simple.waterPortIn) annotation (Line(
      points={{40,60},{26,60},{26,54},{10,54}},
      color={175,0,0},
      thickness=0.5));
  connect(smallScaleCHP_simple.waterPortOut, boundaryVLE_pTxi.fluidPortIn) annotation (Line(
      points={{10,72},{26,72},{26,82},{40,82}},
      color={175,0,0},
      thickness=0.5));
  connect(ElectricGrid.epp, smallScaleCHP_simple.epp) annotation (Line(
      points={{40,20},{26,20},{26,36},{10,36}},
      color={0,135,135},
      thickness=0.5));
  connect(gain1.y, smallScaleCHP_simple1.Q_flow_set) annotation (Line(points={{-65.6,-44},{-58,-44},{-58,-48},{-50,-48}}, color={0,0,127}));
  connect(sine1.y, gain1.u) annotation (Line(points={{-79,-44},{-74.8,-44}}, color={0,0,127}));
  connect(smallScaleCHP_simple1.gasPortIn, boundary_pTxi1.gasPort) annotation (Line(
      points={{10,-60},{66,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid1.epp, smallScaleCHP_simple1.epp) annotation (Line(
      points={{40,-84},{26,-84},{26,-72},{10,-72}},
      color={0,135,135},
      thickness=0.5));
  connect(smallScaleCHP_simple1.heatPort, fixedTemperature1.port) annotation (Line(points={{10,-29.4},{10,-12}}, color={191,0,0}));
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
