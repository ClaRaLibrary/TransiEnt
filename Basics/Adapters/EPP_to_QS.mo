within TransiEnt.Basics.Adapters;
model EPP_to_QS "Adapter to MSL Quasistationary interface"

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
  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VariableVoltageSource
    VariableVoltageSource annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={38,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{28,-102},{48,-82}})));
  TransiEnt.Components.Sensors.ElectricFrequencyVoltage electricFrequencyAndVoltage_L2_1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-34})));
  Modelica.ComplexBlocks.ComplexMath.PolarToComplex polarToComplex
    annotation (Placement(transformation(
        origin={-10,-58},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant phi(k=0) annotation (Placement(
        transformation(
        origin={-78,-64},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
    powerSensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={38,4})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower terminal(useInputConnectorP=true, useCosPhi=false) annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal
    annotation (Placement(transformation(extent={{-12,14},{-32,34}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(rotation=0, extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin voltageP
    annotation (Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(polarToComplex.y, VariableVoltageSource.V) annotation (Line(points={{1,-58},{8,-58},{8,-26},{28,-26}},
                                              color={85,170,255}));
  connect(phi.y, polarToComplex.phi) annotation (Line(points={{-67,-64},{-58,-64},{-22,-64}},
                                     color={0,0,127}));
  connect(complexToReal.re, terminal.P_el_set) annotation (Line(points={{-34,30},{-34,30},{-58,30},{-58,12}}, color={0,0,127}));
  connect(complexToReal.im, terminal.Q_el_set) annotation (Line(points={{-34,18},{-46,18},{-46,12}}, color={0,0,127}));
  connect(epp, terminal.epp) annotation (Line(points={{-100,0},{-100,-0.1},{-62.1,-0.1}}, color={0,127,0}));
  connect(voltageP, powerSensor.voltageP)
    annotation (Line(points={{100,0},{28,0},{28,4}},   color={85,170,255}));
  connect(VariableVoltageSource.pin_n, ground.pin)
    annotation (Line(points={{38,-40},{38,-82}}, color={85,170,255}));
  connect(electricFrequencyAndVoltage_L2_1.f, VariableVoltageSource.f)
    annotation (Line(points={{-39.6,-34},{-40,-34},{-6,-34},{28,-34}},
                                                            color={0,0,127}));
  connect(electricFrequencyAndVoltage_L2_1.epp, terminal.epp) annotation (Line(points={{-60,-33.8},{-68,-33.8},{-68,-34},{-80,-34},{-80,-0.1},{-62.1,-0.1}}, color={0,127,0}));
  connect(electricFrequencyAndVoltage_L2_1.v, polarToComplex.len) annotation (
     Line(points={{-40,-28},{-40,-28},{-32,-28},{-32,-52},{-22,-52}}, color={
          0,0,127}));
  connect(powerSensor.voltageN, ground.pin) annotation (Line(points={{48,4},{
          48,4},{62,4},{62,-82},{38,-82}},        color={85,170,255}));
  connect(powerSensor.y, complexToReal.u) annotation (Line(points={{49,-4},{56,-4},{56,24},{-10,24}},
                                  color={85,170,255}));
  connect(VariableVoltageSource.pin_p, powerSensor.currentP) annotation (Line(points={{38,-20},{38,-20},{38,-6}}, color={85,170,255}));
  connect(powerSensor.currentN, voltageP) annotation (Line(points={{38,14},{38,14},{38,42},{100,42},{100,0}},  color={85,170,255}));
  connect(voltageP, voltageP)
    annotation (Line(points={{100,0},{100,0}}, color={85,170,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{94,0},{90,0}}, color={28,108,200}), Line(points={{-96,0},{-8,0}}, color={0,127,0})}),
    Documentation(info="<html>
<h4>Adapter for switching from Transient electric power port to quasi stationary pin</h4>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adapter from Transient electric power port (EPP) to quasi stationary pin (QS). Defines active and reactive power on transient electric power port. Therefore it must be connected to Transient components defining frequency and voltage. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: Transient electric power port with active and reactive power, frequency and voltage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">voltageP: MSL quasistationary pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations, see diagram view for connections)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The transient side must be connected to a model which defines frequency and voltage (e.g. a grid) and the quasistationary side of the adapter must be connected to a model which defines power (e.g. a consumer).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See <a href=\"TransiEnt.Basics.Adapters.Check.TestEPP_to_QS\">this</a> tester to learn more about how to use this model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Basics.Adapters.Check.TestEPP_to_QS&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 20.04.2017</span></p>
</html>"));
end EPP_to_QS;
