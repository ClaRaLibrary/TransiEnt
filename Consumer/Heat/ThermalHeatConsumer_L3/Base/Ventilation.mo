within TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base;
model Ventilation
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

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Area A=1 "Area of Room";
  parameter Modelica.SIunits.Length h "Height of Room";
  parameter Modelica.SIunits.SpecificHeatCapacity c_p=1008 "Heat Capacity of Air";
  parameter SI.Frequency AXR "Air Exchange Rate";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput T_outside "Outside Temperature" annotation (Placement(transformation(extent={{-128,4},{-88,44}})));
  Modelica.Blocks.Interfaces.RealInput T_room "Room Temperature"  annotation (Placement(transformation(extent={{-128,-42},{-88,-2}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable package Medium =Modelica.Media.Interfaces.PartialMedium;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.VolumeFlowRate V_flow "Volume Flow Rate due to Ventilation";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  V_flow=AXR*A*h;
  port_a.Q_flow=-V_flow*1.2*c_p*(T_outside - T_room);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(extent={{-80,78},{88,-78}}, lineColor={28,108,200}),
        Polygon(points={{-38,68},{4,0},{46,68},{-38,68}}, lineColor={28,108,200}),
        Polygon(points={{78,-34},{78,34},{4,0},{78,-34}}, lineColor={28,108,200}),
        Polygon(points={{46,-68},{4,0},{-38,-68},{46,-68}}, lineColor={28,108,200}),
        Polygon(points={{-72,-34},{-72,34},{4,0},{-72,-34}}, lineColor={28,108,200})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008c48\">1. Purpose of model</span></h4>
<p>Calculation of heat losses due to ventilation.</p>
<h4><span style=\"color: #008c48\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Refer to DIN 12831 for minimal air exchange rates for different usages.</p>
<h4><span style=\"color: #008c48\">3. Limits of validity </span></h4>
<p>No heat regeneration considered.</p>
<h4><span style=\"color: #008c48\">4. Interfaces</span></h4>
<p>HeatPort to air volume.</p>
<h4><span style=\"color: #008c48\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">6. Governing Equations</span></h4>
<p>V_flow=V*AXR</p>
<p>Q_flow=V_flow**c_p&lowast;∆T</p>
<h4><span style=\"color: #008c48\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">8. Validation</span></h4>
<h4><span style=\"color: #008c48\">9. References</span></h4>
<p>DIN 12831-1:2017 - Heizungsanlagen in Geb&auml;uden, Beuth Verlag, Berlin, 2003.</p>
<p>Senkel, A. (2017) Vergleich verschiedener Arten der W&auml;rmeverbrauchsmodellierung in Modelica. Master Thesis. Hamburg University of Technology.</p>
<h4><span style=\"color: #008c48\">10. Version History</span></h4>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de) September 2017</p>
</html>"));
end Ventilation;
