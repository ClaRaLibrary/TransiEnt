within TransiEnt.Basics.Adapters;
model QS_to_EPP

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Block;
// _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.VariableConductor variableConductor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,22})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,22})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/230/230/1e-6)
                                                             annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={12,22})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Sensors.PowerSensor PowerSensorPVPanel annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-84,32})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,62})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Frequency_Voltage(Use_input_connector_f=true, Use_input_connector_v=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,46})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Sensors.FrequencySensor FrequencySensor annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,76})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Sensors.VoltageSensor VoltageSensor annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,-8})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-2,-8})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.VariableCapacitor VariableCapacitor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-44,2})));
  Modelica.Blocks.Math.Feedback feedback1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-60})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=1/230/230/50/2/Modelica.Constants.pi
        /1e-6)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={14,-60})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground ground1 annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.PositivePin currentP annotation (Placement(transformation(rotation=0, extent={{-122.5,44},{-93.5,64}}), iconTransformation(extent={{-110.5,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_IN annotation (Placement(transformation(rotation=0, extent={{103.5,39},{118,53}}), iconTransformation(extent={{89.5,-10},{114,12}})));

   // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  Components.Sensors.ElectricReactivePower electricFrequencyAndVoltage_L2_1 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={90,46})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(integrator.u, feedback.y)
    annotation (Line(points={{24,22},{24,22},{33,22}},    color={0,0,127}));
  connect(PowerSensorPVPanel.currentN, variableConductor.pin_p) annotation (
      Line(points={{-74,32},{-74,30},{-20,30},{-20,32}},  color={85,170,255}));
  connect(PowerSensorPVPanel.voltageP, PowerSensorPVPanel.currentP) annotation (
     Line(points={{-84,42},{-84,54},{-94,54},{-94,32}},
        color={85,170,255}));
  connect(PowerSensorPVPanel.apparentPower, complexToReal.u) annotation (Line(points={{-92,21},{-92,21},{-92,16},{-56,16},{-56,62},{-22,62}}, color={85,170,255}));
  connect(complexToReal.re, feedback.u2) annotation (Line(points={{2,56},{16,56},{42,56},{42,30}},
                                  color={0,0,127}));
  connect(FrequencySensor.pin, PowerSensorPVPanel.currentP) annotation (Line(
        points={{-80,76},{-94,76},{-94,32}},                color={85,170,255}));
  connect(FrequencySensor.f, Frequency_Voltage.f_set)
    annotation (Line(points={{-59,76},{-59,76},{71.4,76},{71.4,34}},
                 color={0,0,127}));
  connect(VoltageSensor.pin_p, variableConductor.pin_p) annotation (Line(points={{-70,2},{-70,2},{-70,44},{-20,44},{-20,32}},
                                                            color={85,170,255}));
  connect(VoltageSensor.v, complexToReal1.u) annotation (Line(points={{-59,-8},{-56,-8},{-56,-6},{-56,-8},{-14,-8}},
                                                              color={85,170,255}));
  connect(complexToReal1.re, Frequency_Voltage.v_set)
    annotation (Line(points={{10,-14},{10,-14},{60,-14},{60,34}},  color={0,0,127}));
  connect(VariableCapacitor.pin_p, variableConductor.pin_p) annotation (Line(
        points={{-44,12},{-44,44},{-20,44},{-20,32}},   color={85,170,255}));
  connect(integrator1.u, feedback1.y)
    annotation (Line(points={{26,-60},{64,-60},{41,-60}},
                                                   color={0,0,127}));
  connect(complexToReal.im, feedback1.u2) annotation (Line(points={{2,68},{2,70},{10,70},{50,70},{50,-52}},
                              color={0,0,127}));
  connect(PowerSensorPVPanel.voltageN, VariableCapacitor.pin_n) annotation (
      Line(points={{-84,22},{-84,-28},{-44,-28},{-44,-8}},   color={85,170,255}));
  connect(VoltageSensor.pin_n, VariableCapacitor.pin_n) annotation (Line(points={{-70,-18},{-70,-28},{-44,-28},{-44,-8}},
                                                    color={85,170,255}));
  connect(ground1.pin, VariableCapacitor.pin_n) annotation (Line(points={{-70,-42},{-70,-28},{-44,-28},{-44,-8}},
                                          color={85,170,255}));
  connect(currentP, PowerSensorPVPanel.currentP) annotation (Line(points={{-108,54},{-94,54},{-94,32}},
                                              color={85,170,255}));
  connect(variableConductor.pin_n, VariableCapacitor.pin_n) annotation (Line(
        points={{-20,12},{-20,-28},{-44,-28},{-44,-8}},   color={85,170,255}));
  connect(integrator.y, variableConductor.G_ref)
    annotation (Line(points={{1,22},{-9,22}},               color={0,0,127}));
  connect(integrator1.y, VariableCapacitor.C) annotation (Line(points={{3,-60},{6,-60},{-26,-60},{-26,2},{-33,2}},
                                                               color={0,0,127}));
  connect(feedback.u1, electricFrequencyAndVoltage_L2_1.P) annotation (Line(
        points={{50,22},{94,22},{94,26},{93.8,26},{93.8,38.2}},      color={0,0,
          127}));
  connect(electricFrequencyAndVoltage_L2_1.Q, feedback1.u1) annotation (Line(
        points={{86.6,38.2},{86.6,14},{86,14},{86,-60},{58,-60}},        color=
          {0,0,127}));
  connect(electricFrequencyAndVoltage_L2_1.epp_OUT, Frequency_Voltage.epp)
    annotation (Line(points={{80.6,46},{76.1,46},{76.1,46.1}},       color={0,
          127,0}));
  connect(electricFrequencyAndVoltage_L2_1.epp_IN, epp_IN) annotation (Line(
        points={{99.2,46},{108,46},{110.75,46}},       color={0,127,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false)), Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                       preserveAspectRatio=false), graphics={Line(points={{-98,0},{96,0},{92,0}}, color={28,108,200}), Line(points={{12,0},{100,0}}, color={0,127,0}),Line(points={{-100,0},{94,0},{90,0}}, color={28,108,200}), Line(points={{-96,0},{-8,0}}, color={0,127,0})}),
    Documentation(info="<html>
<h4>Adapter for switching from quasi stationary pin to Transient electric power port (EPP)</h4>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adapter from MSL quasis stationary pin (QS) to Transient electric power port (EPP). Defines frequency and voltage on transient electric power port. Therefore it must be connected to Transient components defining power flows.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp_IN: Transient electric power port with active and reactive power, frequency and voltage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">currentP: MSL quasistationary pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations, see diagram view for connections)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The transient side must be connected to a model which defines power flows (e.g. a consumer) and the quasistationary side of the adapter must be connected to a model which defines frequency and voltage (e.g. a generator).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See <a href=\"TransiEnt.Basics.Adapters.Check.Test_QS_to_EPP_with_PiModel\">this</a> tester to learn more about how to use this model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Basics.Adapters.Check.Test_QS_to_EPP_with_PiModel&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 20.04.2017</span></p>
</html>"));
end QS_to_EPP;
