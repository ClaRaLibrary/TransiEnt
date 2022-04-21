within TransiEnt.Grid.Electrical.EconomicDispatch;
model DiscretizePrediction "Produces short time predictions by linear interpolation between present value (P_is) and base prediction (P_prediction)"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




  extends TransiEnt.Basics.Icons.Block;

  parameter SI.Time t_pred = 3600 "Time horizon of prediction input";
  parameter SI.Time t_shift(min=0.0) = 0 "Time shift (0 means first output is equal to P_is)";
  parameter SI.Time samplePeriod = 60 "Period of one cycle (must be equal to period in MeritOrderDispatcher)";
  final parameter Integer ntime = integer(t_pred/samplePeriod + 1);
  final parameter SI.Time t[ntime] = linspace(t_shift,t_pred+t_shift, ntime);

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut[ntime] P_predictions annotation (Placement(transformation(rotation=0, extent={{100,-10},{120,10}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_is annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_prediction annotation (Placement(transformation(
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
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model produces short time prediction by interpolating between the present value and the base prediction.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_predictions[ntime]: Output for electric power in [W] (predicted value)</p>
<p>P_is: input for electric power in [W] (present value)</p>
<p>P_prediction: input for electric power in [W] (base prediction)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.EconomicDispatch.Check.TestDiscretizePrediction&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end DiscretizePrediction;
