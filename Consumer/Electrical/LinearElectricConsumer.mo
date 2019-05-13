within TransiEnt.Consumer.Electrical;
model LinearElectricConsumer "Linearized frequency dependency"
  import TransiEnt;

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

  extends TransiEnt.Consumer.Electrical.Base.PartialElectricConsumer_L1(collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean useInputConnectorP = true "Gets parameter from input connector"
  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));
  parameter SI.Power P_el=0 "Used if useInputConnectorP is false";
  parameter Real kpf = 1.5 "Percent load reduction per percent frequency deviation (1%/Hz = 0.5%/%)";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer replaceable TransiEnt.SimCenter simCenter;

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
  //           Instances of other Classes
  // _____________________________________________

public
  Modelica.Blocks.Sources.RealExpression P_n(y=P_internal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={82,-28})));
  Modelica.Blocks.Math.Gain
                       linearStaticConsumerModel(k=kpf/simCenter.f_n)
                                                                     annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={10,40})));
  Modelica.Blocks.Math.Product  ActiveSum       annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={60,-42})));

  TransiEnt.Components.Sensors.ElectricFrequency electricFrequency_L1_1(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{-54,-80},{-34,-60}})));

  SI.ActivePower P_el_n=P_internal "Power demand at nominal frequency";

  Modelica.SIunits.ActivePower delta_P_el = epp.P - P_internal "Power demand at nominal frequency";
  Modelica.SIunits.ActivePower P_el_is = epp.P "Actual load";

  Modelica.Blocks.Sources.Constant const(k=1) annotation (Placement(transformation(extent={{2,62},{22,82}})));
  Modelica.Blocks.Math.Sum sum1(nin=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,2})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnectorP then
    P_internal = P_el;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);

  connect(ActiveSum.y, partialElectricBoundary.P_el_set)
    annotation (Line(
      points={{60,-48.6},{60,-68},{61,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(epp, epp) annotation (Line(
      points={{-98,0},{-98,0},{-98,0}},
      color={0,135,135},
      thickness=0.5));
  connect(epp, electricFrequency_L1_1.epp) annotation (Line(
      points={{-98,0},{-98,-70},{-54,-70}},
      color={0,135,135},
      thickness=0.5));
  connect(electricFrequency_L1_1.f, linearStaticConsumerModel.u) annotation (Line(points={{-33.6,-70},{-33.6,-70},{-33.6,40},{-4.4,40}},
                                                                                                    color={0,0,127}));
  connect(linearStaticConsumerModel.y, sum1.u[1]) annotation (Line(points={{23.2,40},{59,40},{59,14}}, color={0,0,127}));
  connect(const.y, sum1.u[2]) annotation (Line(points={{23,72},{38,72},{61,72},{61,14}}, color={0,0,127}));
  connect(P_n.y, ActiveSum.u1) annotation (Line(points={{71,-28},{68,-28},{63.6,-28},{63.6,-34.8}}, color={0,0,127}));
  connect(ActiveSum.u2, sum1.y) annotation (Line(points={{56.4,-34.8},{56.4,-18},{60,-18},{60,-9}}, color={0,0,127}));
  annotation (defaultComponentName="load", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
    Line( points={{30,44},{-32,-40}},
          color={0,134,134},
          smooth=Smooth.None),
    Line(points={{-50,0},{32,0}}, color={192,192,192}),
    Polygon(
      points={{54,0},{32,-8},{32,8},{54,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-2,54},{-10,32},{6,32},{-2,54}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-44},{-2,32}},
                                  color={192,192,192})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Linearized&nbsp;frequency&nbsp;dependency.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for active power in [W] (active power input at nominal frequency)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in  check model &quot;TransiEnt.Consumer.Electrical.Check.CheckLinearElectricConsumer&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LinearElectricConsumer;
