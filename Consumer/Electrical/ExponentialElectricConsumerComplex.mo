within TransiEnt.Consumer.Electrical;
model ExponentialElectricConsumerComplex "Exponential frequency and voltage dependency, based on ComplexPowerPort"

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

  parameter SI.Frequency f_n=simCenter.f_n "Nominal frequency";
  parameter SI.Voltage v_n=exponentialStaticConsumerModel.simCenter.v_n "Nominal voltage";
  parameter SI.Angle delta_load_start=-0.08726646259971647;
  parameter SI.ActivePower P_n=50 "Nominal Active Power, use 50 (Hz) for not normalized variabilities Use P_el_set_const for normalized values.";
  parameter SI.ReactivePower Q_n=50 "Nominal Reactive Power, use 50 (Hz) for not normalized variabilities. Use Q_el_set for normalized values.";
  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation (Dialog(group="Statistics"));
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
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{-106,-10},{-86,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary boundary(v_n=v_n, delta_cp(start=delta_load_start)) annotation (choicesAllMatching=true, Placement(transformation(extent={{42,-64},{62,-44}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer,integrateElPower=integrateElPower) annotation (Placement(transformation(extent={{-98,100},{-78,80}})));

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  SI.PowerFactor cosphi_is = cos(epp.P/sqrt(max(1.0*simCenter.P_el_small, epp.Q^2+epp.P^2)));
  //outer Modelica.SIunits.Frequency f_global;
//   Modelica.SIunits.Angle delta_load(start=-1);
   //Modelica.SIunits.Voltage v_grid(start=v_n)=epp.v;


  Modelica.Blocks.Sources.RealExpression P_set(y=P_internal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,4})));
  Modelica.Blocks.Sources.RealExpression Q_set(y=if not useCosPhi then Q_el_set else P_internal/cosphi_set*sin(acos(cosphi_set))) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={86,8})));
  TransiEnt.Components.Sensors.ElectricVoltageComplex electricVoltageComplex annotation (Placement(transformation(extent={{-76,16},{-56,36}})));
  Modelica.Blocks.Sources.RealExpression f_grid(y=epp.f) annotation (Placement(transformation(extent={{-92,44},{-72,64}}, rotation=0)));
  Modelica.Blocks.Math.Product ActivePower annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={2,36})));
  Modelica.Blocks.Sources.RealExpression P_el_n(y=P_n)   annotation (Placement(transformation(extent={{-66,-26},{-46,-6}}, rotation=0)));
  Modelica.Blocks.Math.Product ReactivePower annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={2,64})));
  Modelica.Blocks.Sources.RealExpression Q_el_n(y=Q_n)   annotation (Placement(transformation(extent={{-60,66},{-40,86}}, rotation=0)));
  Modelica.Blocks.Math.Add ActiveSum annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={48,-10})));
  Modelica.Blocks.Math.Add ReactiveSum annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={68,-10})));
equation

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnectorP then
    P_internal = P_el_set_const;
  end if;

//   epp.delta=delta_load;
//   epp.v=v_load*(simCenter.v_n/v_n);

  collectElectricPower.powerCollector.P=epp.P;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);

    connect(modelStatistics.powerCollector[EnergyResource.Consumer],collectElectricPower.powerCollector);

  connect(boundary.epp, epp) annotation (Line(
      points={{42,-54},{42,-54},{-96,-54},{-96,0}},
      color={0,127,0},
      thickness=0.5));
  connect(epp, electricVoltageComplex.epp) annotation (Line(
      points={{-96,0},{-76,0},{-76,26.2}},
      color={28,108,200},
      thickness=0.5));
  connect(electricVoltageComplex.v, exponentialStaticConsumerModel.v) annotation (Line(points={{-56,32},{-50,32},{-50,43.2},{-42.24,43.2}}, color={0,0,127}));
  connect(exponentialStaticConsumerModel.f, f_grid.y) annotation (Line(points={{-42.24,54},{-71,54}}, color={0,0,127}));
  connect(exponentialStaticConsumerModel.Delta_P_star, ActivePower.u1) annotation (Line(points={{-21.78,42.8},{-15.89,42.8},{-15.89,39.6},{-5.2,39.6}}, color={0,0,127}));
  connect(P_el_n.y, ActivePower.u2) annotation (Line(points={{-45,-16},{-14,-16},{-14,32.4},{-5.2,32.4}}, color={0,0,127}));
  connect(exponentialStaticConsumerModel.Delta_Q_star, ReactivePower.u2) annotation (Line(points={{-21.78,54},{-12,54},{-12,60.4},{-5.2,60.4}}, color={0,0,127}));
  connect(ReactivePower.u1, Q_el_n.y) annotation (Line(points={{-5.2,67.6},{-12,67.6},{-12,76},{-39,76}}, color={0,0,127}));
  connect(P_set.y, ActiveSum.u2) annotation (Line(points={{35,4},{44,4},{44,-2.8},{44.4,-2.8}}, color={0,0,127}));
  connect(ActivePower.y, ActiveSum.u1) annotation (Line(points={{8.6,36},{51.3,36},{51.3,-2.8},{51.6,-2.8}}, color={0,0,127}));
  connect(Q_set.y, ReactiveSum.u1) annotation (Line(points={{75,8},{72,8},{72,-2.8},{71.6,-2.8}}, color={0,0,127}));
  connect(ReactiveSum.u2, ReactivePower.y) annotation (Line(points={{64.4,-2.8},{64.4,64.6},{8.6,64.6},{8.6,64}}, color={0,0,127}));
  connect(ActiveSum.y, boundary.P_el_set) annotation (Line(points={{48,-16.6},{48,-42},{46,-42}}, color={0,0,127}));
  connect(ReactiveSum.y, boundary.Q_el_set) annotation (Line(points={{68,-16.6},{64,-16.6},{64,-42},{58,-42}}, color={0,0,127}));
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
<p>Exponential frequency and voltage dependency.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: complex power port</p>
<p>P_el_set: input for electric power in [W] (active power at nominal frequency)</p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Adjusted to new interface ComplexPowerPort by Jan-Peter Heckel (jan.heckel@tuhh.de) on 31.01.2018</span></p>
</html>"));
end ExponentialElectricConsumerComplex;
