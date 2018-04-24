within TransiEnt.Basics.Blocks.Check;
model TestDiscretizePrediction
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
    extends Icons.Checkmodel;

  Modelica.Blocks.Sources.Cosine P_load(
    freqHz=1/86400,
    startTime=0,
    amplitude=400e6,
    offset=1.8e9,
    phase(displayUnit="rad") = Modelica.Constants.pi) annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Modelica.Blocks.Sources.Cosine P_pred_1h(
    freqHz=1/86400,
    startTime=0,
    amplitude=400e6,
    offset=1.8e9,
    phase=2*Modelica.Constants.pi*(0.5 + 1/24)) "1 hour ahead"
                                                           annotation (Placement(transformation(extent={{-30,22},{-10,42}})));
  Grid.Electrical.EconomicDispatch.DiscretizePrediction discretizePrediction annotation (Placement(transformation(extent={{0,-16},{20,4}})));
equation
  connect(discretizePrediction.P_is, P_load.y) annotation (Line(points={{0,-6},{-15,-6}}, color={0,0,127}));
  connect(discretizePrediction.P_prediction, P_pred_1h.y) annotation (Line(points={{10,4},{12,4},{12,32},{-9,32}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=900),
    __Dymola_experimentSetupOutput);
end TestDiscretizePrediction;
