within TransiEnt.Consumer.Electrical;
model AverageLoadConsumer "Constant current for active power and constant impedance for reactive power"

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
  import Modelica.Fluid.Utilities.regPow;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

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

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

public
  parameter Real f_n=simCenter.f_n "Nominal frequency";
  parameter Real v_n=simCenter.v_n "Nominal voltage";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Sensors.ElectricFrequencyVoltage electricFrequency_L1_1(isDeltaMeasurement=false) annotation (Placement(transformation(extent={{-80,10},{-60,-10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{-106,-10},{-86,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower boundary annotation (choicesAllMatching=true, Placement(transformation(extent={{42,-64},{62,-44}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-98,100},{-78,80}})));

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  SI.PowerFactor cosphi_is = cos(epp.P/sqrt(max(1.0*simCenter.P_el_small, epp.Q^2+epp.P^2)));

  Modelica.Blocks.Math.Product  ActiveSum       annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={46,-28})));
  Modelica.Blocks.Sources.RealExpression P_el_n(y=P_internal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,-16})));
  Modelica.Blocks.Sources.RealExpression Q_el_n(y=if not useCosPhi then Q_el_set else P_internal/cosphi_set*sin(acos(cosphi_set))) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={86,8})));
  Modelica.Blocks.Math.Product  ReactiveSum      annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={68,-10})));
  Modelica.Blocks.Sources.RealExpression
                                   v_star_square(y=regPow(v_star.y, 2))
                                                     annotation (Placement(
        transformation(
        extent={{-16,-12},{16,12}},
        rotation=0,
        origin={36,10})));
  Modelica.Blocks.Math.Gain        v_star(k=1/v_n)   annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-39,-5})));
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

    connect(modelStatistics.powerCollector[EnergyResource.Consumer],collectElectricPower.powerCollector);

  connect(P_el_n.y, ActiveSum.u2) annotation (Line(points={{35,-16},{42.4,-16},{42.4,-20.8}}, color={0,0,127}));
  connect(ActiveSum.y, boundary.P_el_set) annotation (Line(points={{46,-34.6},{46,-42}},                   color={0,0,127}));
  connect(Q_el_n.y, ReactiveSum.u1) annotation (Line(points={{75,8},{71.6,8},{71.6,-2.8}}, color={0,0,127}));
  connect(ReactiveSum.y, boundary.Q_el_set) annotation (Line(points={{68,-16.6},{70,-16.6},{70,-26},{70,-32},{58,-32},{58,-42}}, color={0,0,127}));
  connect(epp, electricFrequency_L1_1.epp) annotation (Line(
      points={{-96,0},{-80,0},{-80,-0.2}},
      color={0,127,0},
      thickness=0.5));
  connect(boundary.epp, epp) annotation (Line(
      points={{42,-54},{42,-54},{-96,-54},{-96,0}},
      color={0,127,0},
      thickness=0.5));
  connect(electricFrequency_L1_1.v, v_star.u) annotation (Line(points={{-60,-6},{-47.4,-6},{-47.4,-5}}, color={0,0,127}));
  connect(v_star.y, ActiveSum.u1) annotation (Line(points={{-31.3,-5},{49.6,-5},{49.6,-20.8}}, color={0,0,127}));
  connect(v_star_square.y, ReactiveSum.u2) annotation (Line(points={{53.6,10},{58,10},{64.4,10},{64.4,-2.8}}, color={0,0,127}));
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
<p>Static load model with representation of active power as constant current and reactive power as constant impedance. This model can be used in the absence of any further information on the load composition [1].</p>
<p>The constant current active power represents a mix of resistive and motor (nearly const. MVA) devices. </p>
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
<p>Tested in check model &quot;TransiEnt.Consumer.Electrical.Check.CheckAverageLoadConsumer&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>IEEE Task Force on Load Representation for Dynamic Performance: Load representation for dynamic performance analysis (of power systems). In: <i>IEEE Transactions on Power Systems</i> Bd. 8 (1993), Nr.&nbsp;2, S.&nbsp;472&ndash;482</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end AverageLoadConsumer;
