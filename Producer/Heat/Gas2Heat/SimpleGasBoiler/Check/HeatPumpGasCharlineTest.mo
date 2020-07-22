within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.Check;
model HeatPumpGasCharlineTest
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15)
                                                                                    annotation (Placement(transformation(extent={{-68,-46},{-48,-26}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GasGrid annotation (Placement(transformation(extent={{-34,-42},{-14,-22}})));
  Modelica.Blocks.Math.Gain gain1(
                                 k=-1) annotation (Placement(transformation(extent={{-34,-4},{-26,4}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15)
                 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-20,40})));
  HeatPumpGasCharline heatPump(use_T_source_input_K=true, useFluidPorts=false) annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(heatPump.heat, fixedTemperature1.port) annotation (Line(points={{2,-10},{-40,-10},{-40,-36},{-48,-36}},
                                                                                          color={191,0,0}));
  connect(gain1.y, heatPump.Q_flow_set) annotation (Line(points={{-25.6,0},{-8,0}},    color={0,0,127}));
  connect(GasGrid.gasPort, heatPump.gasPortIn) annotation (Line(
      points={{-14,-32},{12,-32},{12,-4}},
      color={255,255,0},
      thickness=1.5));
  connect(sine1.y, gain1.u) annotation (Line(points={{-59,0},{-34.8,0}}, color={0,0,127}));
  connect(gain1.y, heatPump.Q_flow_set) annotation (Line(points={{-25.6,0},{-8,0}}, color={0,0,127}));
  connect(sine2.y, heatPump.T_source_input_K) annotation (Line(points={{-9,40},{2,40},{2,10}}, color={0,0,127}));
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
end HeatPumpGasCharlineTest;
