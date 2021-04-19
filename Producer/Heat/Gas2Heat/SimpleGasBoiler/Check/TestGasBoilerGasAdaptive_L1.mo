within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.Check;
model TestGasBoilerGasAdaptive_L1
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
  extends Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,0})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-68,0})));
  SimpleBoiler gasBoilerGasAdaptive(integrateHeatFlow=false) annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-50e6,
    offset=-100e6,
    duration=0.6,
    startTime=0.2)
    annotation (Placement(transformation(extent={{-100,16},{-80,36}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource(variable_xi=true) annotation (Placement(transformation(extent={{-56,-60},{-36,-40}})));
  inner ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=-100e6)
    annotation (Placement(transformation(extent={{-100,48},{-80,68}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation(stepsize=0.1, period=0.2) annotation (Placement(transformation(extent={{-92,-66},{-72,-46}})));
  SimpleBoiler gasBoilerGasAdaptive1(useFluidPorts=false, integrateHeatFlow=false) annotation (Placement(transformation(extent={{46,-12},{66,8}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource1(variable_xi=true)
                                                                             annotation (Placement(transformation(extent={{36,-62},{56,-42}})));
  Modelica.Blocks.Sources.Constant
                               ramp3(k=-100e6)
    annotation (Placement(transformation(extent={{-8,46},{12,66}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation1(stepsize=0.1, period=0.2)
                                                                                                                                annotation (Placement(transformation(extent={{0,-68},{20,-48}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15)
                                                                                    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,35})));
equation
  connect(composition_linearVariation.xi, gasSource.xi) annotation (Line(points={{-72,-56},{-58,-56}}, color={0,0,127}));
  connect(gasBoilerGasAdaptive.outlet, sink.steam_a) annotation (Line(
      points={{-26,0},{-8,0}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoilerGasAdaptive.inlet, source.steam_a) annotation (Line(
      points={{-45.8,0},{-58,0}},
      color={175,0,0},
      thickness=0.5));
  connect(gasSource.gasPort, gasBoilerGasAdaptive.gasIn) annotation (Line(
      points={{-36,-50},{-36,-10},{-35.8,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, gasBoilerGasAdaptive.Q_flow_set) annotation (Line(points={{-79,58},{-36,58},{-36,10}},        color={0,0,127}));
  connect(composition_linearVariation1.xi, gasSource1.xi) annotation (Line(points={{20,-58},{34,-58}}, color={0,0,127}));
  connect(gasSource1.gasPort, gasBoilerGasAdaptive1.gasIn) annotation (Line(
      points={{56,-52},{56,-12},{56.2,-12}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp3.y, gasBoilerGasAdaptive1.Q_flow_set) annotation (Line(points={{13,56},{26,56},{26,16},{56,16},{56,8}}, color={0,0,127}));
  connect(gasBoilerGasAdaptive1.heatPort, fixedTemperature1.port) annotation (Line(points={{66,6.6},{66,25}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for GasBoilerGasAdaptive_L1</p>
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
</html>"),
    experiment(StopTime=300));
end TestGasBoilerGasAdaptive_L1;
