within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestSolarThermal_L0 "Tester for a solar collector using fluid boundaries"

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

  extends Basics.Icons.Checkmodel;
  SolarThermal.SolarThermal_L0 solarThermal annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.HeatingCurveEONHanse heatingCurve) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  inner ModelStatistics           modelStatistics
     annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    m_flow_nom=0,
    p_nom=1000,
    variable_m_flow=false,
    variable_h=false,
    h_const=400e3) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=100000,
    variable_p=false,
    h_const=400e3) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={52,0})));
equation
  connect(solarThermal.waterPortOut, massFlowSource.steam_a) annotation (Line(
      points={{-12,0},{-40,0}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(solarThermal.waterPortIn, massFlowSink.steam_a) annotation (Line(
      points={{8,0},{42,0}},
      color={175,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for SolarThermal_L0</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"),
    experiment(
      StopTime=2592000,
      Interval=311040000,
      __Dymola_Algorithm="Dassl"));
end TestSolarThermal_L0;
