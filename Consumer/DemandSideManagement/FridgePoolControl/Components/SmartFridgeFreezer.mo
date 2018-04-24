within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components;
model SmartFridgeFreezer "Modell mit festem Verhltnis einiger Parameter"
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

  extends TransiEnt.Basics.Icons.Model;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Temperature T_amb = 295.65 "Ambient temperature";

  parameter SI.Mass m_fridge=8 "Mass of fridge (used as scaling parameter)" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));
  parameter Real m_freezer_over_m_fridge=1 "Mass of freezer (including content) over mass of fridge (including content)" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));

  parameter SI.SpecificHeatCapacity cp_fridge=3000 "Specific heat capacity of fridge (including content)" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));
  parameter SI.SpecificHeatCapacity cp_freezer=2500 "Specific heat capacity of freezer (including content)" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));
  parameter Real COP=1.216 "Expected value of coefficient of performance of cooling unit" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));
  parameter SI.Temperature T_fridge_start=281.45 "Temperature of fridge at init" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));
  parameter SI.CoefficientOfHeatTransfer k_fridge2ambient=0.527 "Coefficient of heat transfer between fridge and ambient" annotation(Dialog(group="Varying parameters typically depending on fridge freezer model and content"));

  parameter Real P_over_m_fridge=13.125 "Nominal electric power of cooling unit over mass of fridge(including content)" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real x_fridge=0.3862 "Fraction of electric demand caused by fridge over total electric demand" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real A_fridge_over_m_fridge=0.2991 "Fraction of heat transfer surface of fridge to ambient over mass of fridge" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real A_freezer_over_m_fridge=0.2441  "Fraction of heat transfer surface of freezer to ambient over mass of fridge" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real A_fridgefreezer_over_m_fridge=0.0379 "Fraction of heat transfer surface between fridge and freezer to ambient over mass of fridge" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real k_freezer2ambient_over_k_fridge2ambient=0.4469 "Coefficient of heat transfer between freezer and ambient divided by Coefficient of heat transfer between fridge and ambient" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));
  parameter Real k_fridge2freezer_over_k_fridge2ambient=1.0560 "Coefficient of heat transfer between fridge and freezer divided by Coefficient of heat transfer between fridge and ambient" annotation(Dialog(group="Typical fractions (can be assumed constant for most residential fridge/freezers)"));

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.Mass mG=m_freezer_over_m_fridge*m_fridge;
  final parameter SI.Temperature T_freezer_start=T_fridge_start-25;
  final parameter SI.Power P_el_n=P_over_m_fridge*m_fridge;
  final parameter SI.Area A_fridge=A_fridge_over_m_fridge*m_fridge;
  final parameter SI.Area A_freezer=A_freezer_over_m_fridge*m_fridge;
  final parameter SI.Area A_fridge2freezer=A_fridgefreezer_over_m_fridge*m_fridge;
  final parameter SI.CoefficientOfHeatTransfer k_freezer2ambient=k_freezer2ambient_over_k_fridge2ambient*k_fridge2ambient;
  final parameter SI.CoefficientOfHeatTransfer k_fridge2freezer=k_fridge2freezer_over_k_fridge2ambient*k_fridge2ambient;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                ambient annotation (Placement(transformation(extent={{-76,6},{-62,19}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
                     controlVolumeFridge(C=m_fridge*cp_fridge, T(fixed=true, start=T_fridge_start))
            annotation (Placement(transformation(extent={{-21,27},{2,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatconductionAmbientFridge(G=k_fridge2ambient*A_fridge) annotation (Placement(transformation(extent={{-50,19},{-33,35}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{-20,55},{-6,70}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
                     controlVolumeFreezer(C=mG*cp_freezer, T(fixed=true, start=T_freezer_start))
            annotation (Placement(transformation(extent={{-20,-8},{-2,-25}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatconductionAmbientFreezer(G=A_freezer*k_freezer2ambient) annotation (Placement(transformation(extent={{-50,-15},{-38,-2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatconductionFridgeToFreezer(G=A_fridge2freezer*k_fridge2freezer) annotation (Placement(transformation(
        extent={{-5.75,-7.25},{5.75,7.25}},
        rotation=90,
        origin={-8.75,8.25})));
  replaceable Controller.ENTSOEThermostat thermostat(
    q0=false,
    delta=2.7,
    T_set=281.4,
    delta_f_db=0.4,
    alpha=-10) constrainedby Controller.PartialThermostat annotation (Dialog(group="Varying parameters typically depending on fridge freezer model and content"),choicesAllMatching=true, Placement(transformation(extent={{10,50},{42,76}})));
  Base.CoolingUnit2ports heatpump(
    P_el_n=P_el_n,
    COP=COP,
    x_fridge=x_fridge) annotation (Placement(transformation(extent={{29,-20},{70,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{91,-10},{111,10}}), iconTransformation(extent={{91,-10},{111,10}})));
  Modelica.Blocks.Sources.Constant Tu(k=T_amb)
     annotation (Placement(transformation(extent={{-94,8},{-84,18}})));

  // Diagnostic variables
  Modelica.SIunits.Temperature T = temperatureSensor.T;
  Real T_star = (T-(thermostat.T_set-thermostat.delta/2))./thermostat.delta;
  Real SOC = 1-T_star;

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(thermostat.T_is, temperatureSensor.T) annotation (Line(points={{10.64,63},{10,63},{10,62.5},{-6,62.5}}, color={0,0,127}));
  connect(thermostat.q, heatpump.q) annotation (Line(points={{42.32,63},{49.5,63},{49.5,19.6}}, color={255,0,255}));
  connect(thermostat.epp, epp) annotation (Line(
      points={{26.4,75.74},{28,75.74},{28,86},{76,86},{76,1},{90,1},{90,0},{101,0}},
      color={0,135,135},
      thickness=0.5));
  connect(heatpump.epp, epp) annotation (Line(
      points={{69.8975,4.44089e-016},{69.8975,0.5},{101,0.5},{101,0}},
      color={0,135,135},
      thickness=0.5));
  connect(heatconductionAmbientFridge.port_b, controlVolumeFridge.port) annotation (Line(points={{-33,27},{-24,27},{-9.5,27}},          color={191,0,0}));
  connect(controlVolumeFridge.port, heatconductionFridgeToFreezer.port_b) annotation (Line(points={{-9.5,27},{-8.75,27},{-8.75,14}}, color={191,0,0}));
  connect(controlVolumeFridge.port, heatpump.port_a) annotation (Line(points={{-9.5,27},{29.615,27},{29.615,12}},
                                                                                                               color={191,0,0}));
  connect(controlVolumeFreezer.port, heatconductionFridgeToFreezer.port_a) annotation (Line(points={{-11,-8},{-8.75,-8},{-8.75,2.5}},  color={191,0,0}));
  connect(controlVolumeFreezer.port, heatpump.port_b) annotation (Line(points={{-11,-8},{29.205,-8},{29.205,-8.4}},
                                                                                                                  color={191,0,0}));
  connect(controlVolumeFreezer.port, heatconductionAmbientFreezer.port_b) annotation (Line(points={{-11,-8},{-38,-8},{-38,-8.5}},  color={191,0,0}));
  connect(controlVolumeFridge.port, temperatureSensor.port) annotation (Line(points={{-9.5,27},{-26,27},{-26,62.5},{-20,62.5}}, color={191,0,0}));
  connect(ambient.port, heatconductionAmbientFreezer.port_a) annotation (Line(points={{-62,12.5},{-60,12.5},{-60,12},{-58,12},{-58,-8.5},{-50,-8.5}}, color={191,0,0}));
  connect(ambient.port, heatconductionAmbientFridge.port_a) annotation (Line(points={{-62,12.5},{-58,12.5},{-58,28},{-56,28},{-56,28},{-54,28},{-54,27},{-50,27}},
                                                                                                                                                 color={191,0,0}));
  connect(Tu.y, ambient.T) annotation (Line(points={{-83.5,13},{-80.75,13},{-80.75,12.5},{-77.4,12.5}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                        Icon(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-46,60},{46,-56}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{28,50},{34,26}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,10},{34,-46}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{46,18},{36,18},{-46,18}}, color={0,0,0})}),
    experiment(StopTime=26455, Interval=5),
    __Dymola_experimentSetupOutput(events=false),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SmartFridgeFreezer;
