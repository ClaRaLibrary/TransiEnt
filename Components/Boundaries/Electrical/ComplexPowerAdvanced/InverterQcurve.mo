within TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced;
model InverterQcurve "Steady-sate inverter model with Q(v)-curve"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  extends TransiEnt.Basics.Icons.ElectricSource;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.ActivePower P_n=500e6 "nominal active power";
  parameter SI.Voltage v_n=simCenter.v_n;
  parameter Boolean change_sign=false "Change sign on input value";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{92,-10},{112,10}})));
  Basics.Interfaces.Electrical.ElectricPowerIn P_el_set                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary(v_n=v_n) annotation (Placement(transformation(extent={{10,-10},{-10,10}})));

  Modelica.Blocks.Math.Gain gain(k=P_n) annotation (Placement(transformation(extent={{-44,24},{-24,44}})));
  replaceable Characteristics.Qcurve_generic qcurve_generic(v_n=v_n) constrainedby Characteristics.Qcurve_empty annotation (choicesAllMatching=true, Placement(transformation(extent={{-74,24},{-54,44}})));
  TransiEnt.Components.Sensors.ElectricVoltageComplex electricVoltageComplex annotation (Placement(transformation(extent={{-44,-50},{-64,-30}})));

  Modelica.Blocks.Math.Gain gain1(k=if change_sign then -1 else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,72})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(pQBoundary.epp, epp) annotation (Line(
      points={{10,0},{102,0}},
      color={28,108,200},
      thickness=0.5));
  connect(gain.y, pQBoundary.Q_el_set) annotation (Line(points={{-23,34},{-6,34},{-6,12}}, color={0,0,127}));
  connect(qcurve_generic.reactivePowerOut, gain.u) annotation (Line(
      points={{-54.2,34},{-46,34}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricVoltageComplex.epp, epp) annotation (Line(
      points={{-44,-39.8},{28,-39.8},{28,-40},{40,-40},{40,0},{102,0}},
      color={28,108,200},
      thickness=0.5));
  connect(electricVoltageComplex.v,qcurve_generic. voltageIn) annotation (Line(
      points={{-64,-34},{-76,-34},{-76,-32},{-86,-32},{-86,34},{-74,34}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(P_el_set, gain1.u) annotation (Line(points={{0,100},{0,84},{2.22045e-15,84}}, color={0,127,127}));
  connect(gain1.y, pQBoundary.P_el_set) annotation (Line(points={{0,61},{0,54},{4,54},{4,12},{6,12}}, color={0,0,127}));
  connect(qcurve_generic.electricPowerIn, pQBoundary.P_el_set) annotation (Line(points={{-64,44.4},{-64,54},{4,54},{4,12},{6,12}}, color={0,127,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for voltage- or active-power-dependent reactive power feed in</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1E</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>check model TransiEnt.Components.Boundaries.Electrical.Check.CheckInverterQcurve</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jan-Peter Heckel (jan.heckel@tuhh.de), Feb 2019</p>
</html>"));
end InverterQcurve;
