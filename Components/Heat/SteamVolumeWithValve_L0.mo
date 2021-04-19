within TransiEnt.Components.Heat;
model SteamVolumeWithValve_L0 "A steam volume unit following VDI3508"
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
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Time T=100 "Integrator time constant";
  parameter Real y_start=0 "Initial or guess value of output (= state)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_steam_in "Inflowing steam with setpoint enthalpy" annotation (Placement(transformation(extent={{-124,-20},{-84,20}}, rotation=0)));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_steam_out "Connector of Real output signal" annotation (Placement(transformation(extent={{98,-10},{118,10}}, rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Continuous.Integrator SteamStorage(k=1/T, y_start=y_start) annotation (Placement(transformation(extent={{-22,-22},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput opening "Valve opening" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,84})));
  Modelica.Blocks.Math.Product Valve annotation (Placement(transformation(extent={{38,-12},{70,20}})));
  Modelica.Blocks.Math.MultiSum massBalance(nu=2, k={1,-1})
                                                  annotation (Placement(transformation(extent={{-74,-22},{-42,10}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(massBalance.u[1], m_flow_steam_in) annotation (Line(points={{-74,-0.4},{-90,-0.4},{-90,0},{-104,0}}, color={0,0,127}));
  connect(massBalance.y, SteamStorage.u) annotation (Line(points={{-39.28,-6},{-32,-6},{-25.2,-6}}, color={0,0,127}));
  connect(SteamStorage.y, Valve.u2) annotation (Line(points={{11.6,-6},{34.8,-6},{34.8,-5.6}}, color={0,0,127}));
  connect(Valve.y, m_flow_steam_out) annotation (Line(points={{71.6,4},{84,4},{84,0},{108,0}}, color={0,0,127}));
  connect(Valve.y, massBalance.u[2]) annotation (Line(points={{71.6,4},{84,4},{84,-74},{-88,-74},{-88,-11.6},{-74,-11.6}}, color={0,0,127}));
  connect(opening, Valve.u1) annotation (Line(points={{0,100},{0,56},{20,56},{20,13.6},{34.8,13.6}}, color={0,0,127}));
  annotation (defaultComponentName="SteamVolume", Diagram(graphics,
                                                          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,92},{92,-92}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,64},{-56,64},{8,0},{0,-6},{-70,64}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,-64},{-56,-64},{8,0},{0,6},{-70,-64}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,64},{96,56}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-56},{94,-64}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for a steam volume unit with valve.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>RealInput: m_flow_steam_in (inflowing steam with enthalpy setpoint)</p>
<p>RealOutput: m_flow_steam_out (Real Output signal)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>T is the time</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>VDI 3508</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end SteamVolumeWithValve_L0;
