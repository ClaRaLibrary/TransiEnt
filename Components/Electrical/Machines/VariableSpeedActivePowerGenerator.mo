within TransiEnt.Components.Electrical.Machines;
model VariableSpeedActivePowerGenerator "ActicePowerPort: Static machine model with torque control for the shaft speed"


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

  import TransiEnt;
  extends TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Efficiency eta=1;
  parameter Boolean changeSign = false "True, input is decelerating torque";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput tau_set(final quantity= "Torque", final unit="Nm", displayUnit="Nm") "Generator Torque setpoint" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,104}),
                        iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-93,-65})));

  // _____________________________________________
  //
  //                   Components
  // _____________________________________________

  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(transformation(extent={{-16,-10},{-36,10}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power terminal(change_sign=true) constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choices(
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power terminal(change_sign=true) "P-Boundary for ActivePowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower terminal(
          change_sign=true,
          useInputConnectorP=true,
          useInputConnectorQ=false,
          useCosPhi=true,
          cosphi_boundary=1) "PQ-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary terminal(
          change_sign=true,
          useInputConnectorQ=false,
          cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage terminal(Use_input_connector_v=false, v_boundary=simCenter.v_n) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary terminal(v_gen=simCenter.v_n, useInputConnectorP=true, change_sign=true) "PV-Boundary for ComplexPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.InverterQcurve terminal(v_n=simCenter.v_n,change_sign=true))),
    Placement(transformation(extent={{68,-10},{48,10}})));
   Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor   annotation (Placement(transformation(extent={{-74,-10},
            {-54,10}})));
  Modelica.Blocks.Math.Gain sign(k=if changeSign then -1 else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,36})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(terminal.epp, epp) annotation (Line(
      points={{68,0},{74,0},{74,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(mpp, powerSensor.flange_a) annotation (Line(points={{-100,0},{-74,0}},         color={95,95,95}));
  connect(powerSensor.flange_b, torque.flange) annotation (Line(points={{-54,0},
          {-54,0},{-36,0}},                                                                       color={0,0,0}));
  connect(sign.y, torque.tau)
    annotation (Line(points={{-2.22045e-015,25},{-2.22045e-015,0},{-14,0}},
                                                    color={0,0,127}));
  connect(powerSensor.power, terminal.P_el_set) annotation (Line(points={{-72,-11},{-72,-26},{34,-26},{34,32},{64,32},{64,12}}, color={0,0,127}));
  connect(tau_set, sign.u) annotation (Line(points={{80,104},{80,54},{0,54},{0,48}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a synchronous machine with constant efficiency. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L1E (defined in the CodingConventions)</p>
<p>- only active power flow and frequency</p>
<p>- Constant efficiency </p>
<p>- Mechanical connection is stiff</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Mechanical power port mpp</p>
<p>Modelica RealInput: temperature in [K]</p>
<p>Modelica RealInput: electric potential in [V]</p>
<p>Active power port epp</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckVariableSpeedActivePowerGenerator&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end VariableSpeedActivePowerGenerator;
