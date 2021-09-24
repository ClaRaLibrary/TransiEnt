within TransiEnt.Consumer.Systems.FridgePoolControl.Components;
model SmartFridge

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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Temperature T_amb = 295.65 "ambient temperature";
  parameter SI.Mass m=8 "Mass of fridge content";
  parameter SI.SpecificHeatCapacity cp=3000 "Specific heat capacity of fridge content";
  parameter SI.Temperature T0=281.45 "Temperature at init";
  parameter Real P_over_m=13.125 "Fraction of power over mass";
  parameter Real COP=1.216 "Expected value of cooling units COP";
  parameter SI.CoefficientOfHeatTransfer k=0.527 "heat transfer to ambient";
  parameter Real A_over_m=0.2991 "Fraction of surface over mass";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                ambient annotation (Placement(transformation(extent={{-55,-5},{-41,8}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
                     controlVolumeFridge(C=cp*m, T(fixed=true, start=T0))
               annotation (Placement(transformation(extent={{7,0},{26,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatconductionAmbient(G=0.7137*2.17) annotation (Placement(transformation(extent={{-34,-6},{-19,8}})));
  Base.CoolingUnit coolingUnit(P_el_n=P_over_m*m, COP=COP) annotation (Placement(transformation(extent={{53,-13},{83,13}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{-6,52},{10,68}})));
  replaceable Controller.ENTSOEThermostat thermostat(
    q0=false,
    delta=2.7,
    T_set=281.4,
    delta_f_db=0.4,
    alpha=-10) constrainedby Controller.PartialThermostat annotation (choicesAllMatching=true, Placement(transformation(extent={{26,45},{58,76}})));
  Modelica.Blocks.Sources.Constant Tu(k=T_amb)
    annotation (Placement(transformation(extent={{-78,-6},{-62,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{97,-3},{104,3}}), iconTransformation(extent={{88,-13},{104,3}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(temperatureSensor.T, thermostat.T_is) annotation (Line(points={{10,60},{10,60.5},{26.64,60.5}}, color={0,0,127}));
  connect(thermostat.epp, epp) annotation (Line(
      points={{42.4,75.69},{42,75.69},{42,80},{92,80},{92,0},{100.5,0}},
      color={0,135,135},
      thickness=0.5));
  connect(ambient.port, heatconductionAmbient.port_a) annotation (Line(points={{-41,1.5},{-38,1.5},{-38,2},{-36,2},{-36,1},{-34,1}},
                                                                                                                         color={191,0,0}));
  connect(controlVolumeFridge.port, coolingUnit.port_a) annotation (Line(points={{16.5,0},{26,0},{52.7,0}}, color={191,0,0}));
  connect(controlVolumeFridge.port, heatconductionAmbient.port_b) annotation (Line(points={{16.5,0},{-14,0},{-14,1},{-19,1}},
                                                                                                                          color={191,0,0}));
  connect(controlVolumeFridge.port, temperatureSensor.port) annotation (Line(points={{16.5,0},{-14,0},{-14,44},{-14,60},{-6,60}},
                                                                                                                    color={191,0,0}));
  connect(Tu.y, ambient.T) annotation (Line(points={{-61.2,2},{-56.4,2},{-56.4,1.5}},    color={0,0,127}));
  connect(thermostat.q, coolingUnit.q) annotation (Line(points={{58.32,60.5},{62,60.5},{62,60},{68,60},{68,13.26}}, color={255,0,255}));
  connect(coolingUnit.epp, epp) annotation (Line(
      points={{82.85,-0.195},{100.5,-0.195},{100.5,0}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                        Icon(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-44,60},{48,-56}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}), Rectangle(
          extent={{30,20},{36,-14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a smart controlled fridge. Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp - Electric Power Port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SmartFridge;
