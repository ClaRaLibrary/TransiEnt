within TransiEnt.Consumer.Electrical;
model ExponentialElectricConsumer "Exponential frequency and voltage dependency"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.ElectricalConsumer;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter Boolean useInputConnectorP = false "Gets parameter from input connector"
  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter SI.Power P_el_set_const=0 "Used, if not useInputConnectorP" annotation(Dialog(enable = not useInputConnectorP));
  parameter Boolean useCosPhi=true
    annotation (choices(__Dymola_checkBox=true));
  parameter SI.ReactivePower Q_el_set=0
    annotation (Dialog(enable = not useCosPhi));
  parameter SI.PowerFactor cosphi_set=1
    annotation (Dialog(enable = useCosPhi));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if              useInputConnectorP "active power input at nominal frequency" annotation (Placement(transformation(extent={{-140,60},{-100,100}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,116})));
protected
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_internal "Needed to connect to conditional connector for active power";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real f_n=simCenter.f_n "Nominal frequency";
  parameter Real v_n=exponentialStaticConsumerModel.simCenter.v_n "Nominal voltage";
  parameter SI.ActivePower P_n=50 "Nominal Active Power, use 50 (Hz) for not normalized variabilities Use P_el_set_const for normalized values.";
  parameter SI.ReactivePower Q_n=50 "Nominal Reactive Power, use 50 (Hz) for not normalized variabilities. Use Q_el_set for normalized values.";
  replaceable TransiEnt.Consumer.Electrical.Characteristics.Constant variability constrainedby TransiEnt.Consumer.Electrical.Characteristics.PartialConsumerData "Consumer characteristic" annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Consumer.Electrical.Base.ExponentialStatic exponentialStaticConsumerModel(
    data=variability,
    f_n=f_n,
    v_n=v_n) annotation (Placement(transformation(
        extent={{-11,-10},{11,10}},
        rotation=0,
        origin={-33,48})));
  TransiEnt.Components.Sensors.ElectricFrequencyVoltage electricFrequency_L1_1(isDeltaMeasurement=false) annotation (Placement(transformation(extent={{-80,10},{-60,-10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{-106,-10},{-86,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower boundary annotation (choicesAllMatching=true, Placement(transformation(extent={{42,-64},{62,-44}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-98,100},{-78,80}})));

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  SI.PowerFactor cosphi_is = cos(epp.P/sqrt(max(1.0*simCenter.P_el_small, epp.Q^2+epp.P^2)));

  Modelica.Blocks.Sources.RealExpression P_set(y=P_internal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={22,-8})));
  Modelica.Blocks.Sources.RealExpression Q_set(y=if not useCosPhi then Q_el_set else P_internal/cosphi_set*sin(acos(cosphi_set))) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={84,-4})));
  Modelica.Blocks.Math.Product ActivePower annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-2,24})));
  Modelica.Blocks.Math.Product ReactivePower annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-2,60})));
  Modelica.Blocks.Math.Add ActiveSum1
                                     annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={46,-22})));
  Modelica.Blocks.Math.Add ReactiveSum1
                                       annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={66,-22})));
  Modelica.Blocks.Sources.RealExpression Q_el_n(y=Q_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,80})));
  Modelica.Blocks.Sources.RealExpression P_el_n(y=P_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,16})));
equation

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnectorP then
    P_internal = P_el_set_const;
  end if;

  collectElectricPower.powerCollector.P=epp.P;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);

  connect(electricFrequency_L1_1.f, exponentialStaticConsumerModel.f) annotation (Line(points={{-59.6,0},{-53.6,0},{-53.6,54},{-42.24,54}},
                                                                                                    color={0,0,127}));

    connect(modelStatistics.powerCollector[EnergyResource.Consumer],collectElectricPower.powerCollector);

  connect(electricFrequency_L1_1.v, exponentialStaticConsumerModel.v) annotation (Line(points={{-60,-6},{-60,-6},{-50,-6},{-50,44},{-48,44},{-42.24,44},{-42.24,43.2}},
                                                                                                                                          color={0,0,127}));
  connect(epp, electricFrequency_L1_1.epp) annotation (Line(
      points={{-96,0},{-80,0},{-80,-0.2}},
      color={0,127,0},
      thickness=0.5));
  connect(boundary.epp, epp) annotation (Line(
      points={{42,-54},{42,-54},{-96,-54},{-96,0}},
      color={0,127,0},
      thickness=0.5));
  connect(P_set.y, ActiveSum1.u2) annotation (Line(points={{33,-8},{42,-8},{42,-14.8},{42.4,-14.8}}, color={0,0,127}));
  connect(ActivePower.y, ActiveSum1.u1) annotation (Line(points={{4.6,24},{49.3,24},{49.3,-14.8},{49.6,-14.8}}, color={0,0,127}));
  connect(Q_set.y, ReactiveSum1.u1) annotation (Line(points={{73,-4},{70,-4},{70,-14.8},{69.6,-14.8}}, color={0,0,127}));
  connect(ReactiveSum1.u2, ReactivePower.y) annotation (Line(points={{62.4,-14.8},{62.4,52.6},{4.6,52.6},{4.6,60}}, color={0,0,127}));
  connect(ActiveSum1.y, boundary.P_el_set) annotation (Line(points={{46,-28.6},{46,-42}}, color={0,0,127}));
  connect(ReactiveSum1.y, boundary.Q_el_set) annotation (Line(points={{66,-28.6},{62,-28.6},{62,-42},{58,-42}}, color={0,0,127}));
  connect(ReactivePower.u2, exponentialStaticConsumerModel.Delta_Q_star) annotation (Line(points={{-9.2,56.4},{-15.6,56.4},{-15.6,54},{-21.78,54}}, color={0,0,127}));
  connect(ActivePower.u1, exponentialStaticConsumerModel.Delta_P_star) annotation (Line(points={{-9.2,27.6},{-9.2,34.8},{-21.78,34.8},{-21.78,42.8}}, color={0,0,127}));
  connect(ReactivePower.u1, Q_el_n.y) annotation (Line(points={{-9.2,63.6},{-12,63.6},{-12,80},{-15,80}}, color={0,0,127}));
  connect(P_el_n.y, ActivePower.u2) annotation (Line(points={{-15,16},{-12,16},{-12,20.4},{-9.2,20.4}}, color={0,0,127}));
  annotation (defaultComponentName="load", Diagram(graphics,
                                                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                       graphics={
    Line(points={{-44,-30},{38,-30}},
                                  color={192,192,192}),
    Polygon(
      points={{60,-30},{38,-38},{38,-22},{60,-30}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-2,54},{-10,32},{6,32},{-2,54}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-44},{-2,32}},
                                  color={192,192,192}),
        Line(
          points={{48,36},{46,28},{42,20},{38,12},{30,0},{22,-8},{16,-14},{8,-22},{0,-26},{-4,-28},{-14,-30},{
              -26,-30},{-46,-30}},
          color={0,134,134},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Exponential&nbsp;frequency&nbsp;and&nbsp;voltage&nbsp;dependency.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for active power in [W] (active power input at nominal frequency)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: apparent power port</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Consumer.Electrical.Check.CheckExponentialElectricConsumer&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end ExponentialElectricConsumer;
