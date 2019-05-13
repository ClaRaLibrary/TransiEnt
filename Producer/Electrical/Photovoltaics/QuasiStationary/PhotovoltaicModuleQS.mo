within TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary;
model PhotovoltaicModuleQS "PV Module for quasi stationary boundaries with constant efficiency"

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

  extends TransiEnt.Basics.Icons.SolarElectricalModel;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter SI.Area A_module=1 "PV Module surface";
  parameter SI.Efficiency eta=0.2 "Total efficiency from radiation to power output";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Math.Gain PVPower(k=-A_module*eta)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.VariableConductor
    variableConductor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-8})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
    PowerSensorPVPanel annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,16})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-36,-10},{-16,-30}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal
    annotation (Placement(transformation(extent={{14,14},{-6,34}})));
  Modelica.Blocks.Continuous.PI         integrator(k=10, T=1/230/230/1e-6)
    annotation (Placement(transformation(extent={{-4,-30},{16,-10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{40,-48},{60,-28}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{-114,-10},{-94,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    currentP annotation (Placement(transformation(rotation=0, extent={{90,-10},{
            110,10}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(complexToReal.u,PowerSensorPVPanel. y) annotation (Line(points={{16,24},{16,24},{39,24}},    color={85,170,255}));
  connect(complexToReal.re,feedback. u2) annotation(Line(points={{-8,30},{-26,30},{-26,-12}},       color = {0, 0, 127}));
  connect(feedback.y,integrator. u) annotation(Line(points={{-17,-20},{-6,-20}},   color = {0, 0, 127}));
  connect(PVPower.y,feedback. u1) annotation (Line(points={{-49,0},{-42,0},{-42,-20},{-34,-20}}, color={0,0,127}));
  connect(variableConductor.pin_n,PowerSensorPVPanel. currentN) annotation (Line(points={{50,2},{50,6}},     color={85,170,255}));
  connect(ground.pin,variableConductor. pin_p) annotation (Line(points={{50,-28},{50,-28},{50,-18}}, color={85,170,255}));
  connect(variableConductor.pin_p,PowerSensorPVPanel. voltageN) annotation (Line(points={{50,-18},{50,-18},{34,-18},{34,16},{40,16}},   color={85,170,255}));
  connect(integrator.y,variableConductor. G_ref) annotation (Line(points={{17,-20},{24,-20},{24,-8},{39,-8}},   color={0,0,127}));
  connect(u, PVPower.u) annotation (Line(points={{-104,0},{-104,0},{-72,0}},
                 color={0,0,127}));
  connect(currentP, PowerSensorPVPanel.currentP)
    annotation (Line(points={{100,0},{100,26},{50,26}},   color={85,170,255}));
  connect(currentP, PowerSensorPVPanel.voltageP) annotation (Line(points={{100,0},{100,16},{60,16}},
                                     color={85,170,255}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics,
                                     coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Power generation of PV modules based on ambient conditions for quasi stationary. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: ambient condition.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) and Rebekka Denninger (rebekka.denninger@tuhh.de) on Thu March 24 2016</span></p>
</html>"));
end PhotovoltaicModuleQS;
