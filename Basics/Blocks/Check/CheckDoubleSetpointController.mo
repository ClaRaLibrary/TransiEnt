within TransiEnt.Basics.Blocks.Check;
model CheckDoubleSetpointController
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  Modelica.Blocks.Sources.Cosine cosine(
    amplitude=3,
    freqHz=1/3600,
    phase=3.1415926535898,
    startTime=0,
    offset=3) annotation (Placement(transformation(extent={{-44,44},{-24,64}})));
  TransiEnt.Basics.Blocks.DoubleSetpointController ctrl1(
    uLow1=1,
    uHigh1=2,
    uLow2=4,
    uHigh2=5) annotation (Placement(transformation(extent={{-6,44},{14,64}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor FreshBeer(C=100*4.2e3, T(start=273.15 + 9, fixed=true)) annotation (Placement(transformation(extent={{2,-34},{22,-14}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature T_amb(T=30)
                                                               annotation (Placement(transformation(extent={{82,-28},{62,-8}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss(G=500) annotation (Placement(transformation(extent={{36,-28},{56,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow cooler annotation (Placement(transformation(extent={{-28,-44},{-8,-24}})));
  TransiEnt.Basics.Blocks.DoubleSetpointController ctrl2(
    uLow1=9,
    uHigh1=16,
    y0=0,
    y1=-5e3,
    y2=-10e3,
    uLow2=16,
    uHigh2=18) annotation (Placement(transformation(extent={{-56,-44},{-36,-24}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor T annotation (Placement(transformation(extent={{-6,-74},{-26,-54}})));
equation
  connect(cosine.y, ctrl1.u) annotation (Line(points={{-23,54},{-6,54},{-6.6,54}}, color={0,0,127}));
  connect(FreshBeer.port, loss.port_a) annotation (Line(points={{12,-34},{12,-34},{32,-34},{32,-18},{36,-18}}, color={191,0,0}));
  connect(cooler.port, FreshBeer.port) annotation (Line(points={{-8,-34},{2,-34},{12,-34}}, color={191,0,0}));
  connect(ctrl2.y, cooler.Q_flow) annotation (Line(points={{-35.4,-34},{-28,-34}}, color={0,0,127}));
  connect(T.port, FreshBeer.port) annotation (Line(points={{-6,-64},{12,-64},{12,-34}}, color={191,0,0}));
  connect(T.T, ctrl2.u) annotation (Line(points={{-26,-64},{-70,-64},{-70,-34},{-56.6,-34}}, color={0,0,127}));
  connect(T_amb.port, loss.port_b) annotation (Line(points={{62,-18},{59,-18},{56,-18}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{40,36},{78,72}},
          lineColor={0,0,0},
          textString="Look at:
cosine.y
ctrl1.uLow1
ctrl1.uHigh1
ctrl1.uLow2
ctrl1.uHigh2
ctrl1.y"), Text(
          extent={{42,-88},{80,-52}},
          lineColor={0,0,0},
          textString="Look at:
FreshBeer.T
ctrl2.uLow1
ctrl2.uLow2
ctrl2.uHigh1
ctrl2.uHigh2
ctrl2.y
")}),
    experiment(
      StopTime=3600,
      __Dymola_fixedstepsize=5,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end CheckDoubleSetpointController;
