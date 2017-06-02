within TransiEnt.Grid.Electrical.EconomicDispatch;
model DiscretizePrediction "Produces short time predictions by linear interpolation between present value (P_is) and base prediction (P_prediction)"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Block;

  parameter SI.Time t_pred = 3600 "Time horizon of prediction input";
  parameter SI.Time t_shift(min=0.0) = 0 "Time shift (0 means first output is equal to P_is)";
  parameter SI.Time samplePeriod = 60 "Period of one cycle (must be equal to period in MeritOrderDispatcher)";
  final parameter Integer ntime = integer((t_pred-t_shift)/samplePeriod + 1);
  final parameter SI.Time t[ntime] = linspace(t_shift,t_pred, ntime);

  Modelica.Blocks.Interfaces.RealOutput[ntime] P_predictions annotation (Placement(transformation(rotation=0, extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealInput P_is annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput P_prediction annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

equation
  for i in 1:ntime loop
    P_predictions[i] = P_is + (P_prediction - P_is) * t[i] / t_pred;
  end for;

  annotation (Icon(graphics={
        Line(points={{-84,0},{-72.7,34.2},{-65.5,53.1},{-59.1,66.4},{-53.4,74.6},{-47.8,79.1},{-42.2,79.8},{-36.6,76.6},{-30.9,69.7},{-25.3,59.4},{-18.9,44.1},{-10.83,21.2},{6.1,-30.8},{13.3,-50.2},{19.7,-64.2},{25.3,-73.1},{31,-78.4},{36.6,-80},{42.2,-77.6},{47.9,-71.5},{53.5,-61.9},{59.9,-47.2},{68,-24.8},{76,0}},
                                                            color={0,0,127},
              smooth=Smooth.Bezier),
        Line(points={{-68,0},{-56.7,34.2},{-49.5,53.1},{-43.1,66.4},{-37.4,74.6},{-31.8,79.1},{-26.2,79.8},{-20.6,76.6},{-14.9,69.7},{-9.3,59.4},{-2.9,44.1},{5.17,21.2},{22.1,-30.8},{29.3,-50.2},{35.7,-64.2},{41.3,-73.1},{47,-78.4},{52.6,-80},{58.2,-77.6},{63.9,-71.5},{69.5,-61.9},{75.9,-47.2},{84,-24.8},{92,0}},
                                                           color={0,0,0},
              smooth=Smooth.Bezier),
        Line(points={{-104,0},{80,0}}, color={192,192,192}),
        Polygon(
          points={{96,0},{80,6},{80,-6},{96,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,96},{-90,80},{-78,80},{-84,96}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-84,-88},{-84,86}}, color={192,192,192}),
        Polygon(
          points={{-84,-22},{-92,-20},{-92,-24},{-84,-22}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-68,-26},{-68,4}}, color={192,192,192}),
        Polygon(
          points={{-60,-20},{-68,-22},{-60,-24},{-60,-20}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DiscretizePrediction;
