within TransiEnt.Consumer.Electrical;
model ExponentialElectricConsumer "Exponential frequency and voltage dependency"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Consumer;

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

  Modelica.Blocks.Interfaces.RealInput P_el_set if              useInputConnectorP "active power input at nominal frequency" annotation (Placement(transformation(extent={{-140,60},{-100,100}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,116})));
protected
  Modelica.Blocks.Interfaces.RealInput P_internal "Needed to connect to conditional connector for active power";

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

  Modelica.Blocks.Sources.Constant const(k=1) annotation (Placement(transformation(extent={{-12,70},{8,90}})));
  Modelica.Blocks.Math.Sum P_el_star(nin=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,26})));
  Modelica.Blocks.Math.Sum Q_el_star(nin=2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={32,58})));
  Modelica.Blocks.Math.Product  ActiveSum       annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={46,-10})));
  Modelica.Blocks.Sources.RealExpression
                                   P_el_nom(y=P_internal)
                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,4})));
  Modelica.Blocks.Sources.RealExpression
                                   Q_el_nom(y=if not useCosPhi then Q_el_set else P_internal/cosphi_set*sin(acos(cosphi_set)))
                                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={86,8})));
  Modelica.Blocks.Math.Product  ReactiveSum      annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={68,-10})));
  Modelica.Blocks.Sources.Constant const1(
                                         k=1) annotation (Placement(transformation(extent={{-20,-4},{0,16}})));
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
  connect(P_el_nom.y, ActiveSum.u2) annotation (Line(points={{35,4},{42.4,4},{42.4,-2.8}}, color={0,0,127}));
  connect(P_el_star.y, ActiveSum.u1) annotation (Line(points={{41,26},{49.6,26},{49.6,-2.8}}, color={0,0,127}));
  connect(ActiveSum.y, boundary.P_el_set) annotation (Line(points={{46,-16.6},{46,-42}},                   color={0,0,127}));
  connect(Q_el_star.y, ReactiveSum.u2) annotation (Line(points={{43,58},{64.4,58},{64.4,-2.8}}, color={0,0,127}));
  connect(Q_el_nom.y, ReactiveSum.u1) annotation (Line(points={{75,8},{71.6,8},{71.6,-2.8}},   color={0,0,127}));
  connect(ReactiveSum.y, boundary.Q_el_set) annotation (Line(points={{68,-16.6},{70,-16.6},{70,-26},{70,-32},{58,-32},{58,-42}}, color={0,0,127}));
  connect(epp, electricFrequency_L1_1.epp) annotation (Line(
      points={{-96,0},{-80,0},{-80,-0.2}},
      color={0,127,0},
      thickness=0.5));
  connect(boundary.epp, epp) annotation (Line(
      points={{41.9,-54.1},{41.9,-54.1},{-96,-54.1},{-96,0}},
      color={0,127,0},
      thickness=0.5));
  connect(exponentialStaticConsumerModel.Delta_P_star, P_el_star.u[1]) annotation (Line(points={{-21.78,42.8},{-6,42.8},{-6,25},{18,25}}, color={0,0,127}));
  connect(const1.y, P_el_star.u[2]) annotation (Line(points={{1,6},{6,6},{6,27},{18,27}}, color={0,0,127}));
  connect(exponentialStaticConsumerModel.Delta_Q_star, Q_el_star.u[1]) annotation (Line(points={{-21.78,54},{-10,54},{-10,52},{20,52},{20,59}}, color={0,0,127}));
  connect(const.y, Q_el_star.u[2]) annotation (Line(points={{9,80},{14,80},{14,57},{20,57}}, color={0,0,127}));
  annotation (defaultComponentName="load", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end ExponentialElectricConsumer;
