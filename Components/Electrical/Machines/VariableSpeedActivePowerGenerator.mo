within TransiEnt.Components.Electrical.Machines;
model VariableSpeedActivePowerGenerator "Active power generator with torque control allowing to control the shaft speed without influence of grid frequency (synchronous machine + ideal frequency drive)"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  import TransiEnt;
  extends TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Efficiency eta=1;
  parameter Boolean changeSign = false "True, input is decelerating torque";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput T_set "Generator Torque setpoint"
                                                                      annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104}),iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-3,99})));

  // _____________________________________________
  //
  //                   Components
  // _____________________________________________

  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(transformation(extent={{-16,-10},{-36,10}})));
  TransiEnt.Components.Boundaries.Electrical.Power terminal(change_sign=true) annotation (Placement(transformation(extent={{68,-10},{48,10}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor annotation (Placement(transformation(extent={{-74,-10},
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
      points={{68.1,-0.1},{74,-0.1},{74,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(mpp, powerSensor.flange_a) annotation (Line(points={{-100,0},{-74,0}},         color={95,95,95}));
  connect(powerSensor.flange_b, torque.flange) annotation (Line(points={{-54,0},
          {-54,0},{-36,0}},                                                                       color={0,0,0}));
  connect(sign.y, torque.tau)
    annotation (Line(points={{-2.22045e-015,25},{-2.22045e-015,0},{-14,0}},
                                                    color={0,0,127}));
  connect(T_set, sign.u)
    annotation (Line(points={{0,104},{2.22045e-015,104},{2.22045e-015,48}},
                                                    color={0,0,127}));
  connect(powerSensor.power, terminal.P_el_set) annotation (Line(points={{-72,-11},{-72,-26},{34,-26},{34,32},{64,32},{64,12}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a synchronous machine with constant efficiency. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">LoD1 - only active power flow and frequency</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant efficiency </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end VariableSpeedActivePowerGenerator;
