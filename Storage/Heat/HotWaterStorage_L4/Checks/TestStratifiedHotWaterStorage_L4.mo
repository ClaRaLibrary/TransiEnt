within TransiEnt.Storage.Heat.HotWaterStorage_L4.Checks;
model TestStratifiedHotWaterStorage_L4
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant(
    m_flow_nom=0,
    T_const=360,
    m_flow_const=2,
    variable_m_flow=true,
    variable_T=true)      annotation (Placement(transformation(extent={{-48,-6},{-28,14}})));
  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi heat_toCHP(
    p_const(displayUnit="bar") = 100000,
    T_const=293,
    variable_T=true)
                 annotation (Placement(transformation(extent={{-50,-32},{-30,-12}})));
  Modelica.Blocks.Sources.Constant m_flow(k=750) annotation (Placement(transformation(extent={{-100,52},{-80,72}})));
  Modelica.Blocks.Sources.Constant T_feed_CHP_degC(k=85) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin T_feed_CHP annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-68,16})));
  Modelica.Blocks.Sources.Constant T_return(k=65 + 273.15) annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow noLoss(Q_flow=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={22,40})));
  TransiEnt.Storage.Heat.HotWaterStorage_L4.HotWaterStorage_L4 HeatStorage(
    Use_Solar=false,
    Use_HeatPorts=false,
    Geometry(height=50, volume=30e3),
    nSeg=2) annotation (Placement(transformation(extent={{-8,-24},{28,14}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant1(
    m_flow_nom=0,
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=m_flow.k,
    T_const=T_return.k)   annotation (Placement(transformation(extent={{82,-26},{62,-6}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant2(
    m_flow_nom=0,
    variable_T=false,
    T_const=T_return.k,
    m_flow_const=50)      annotation (Placement(transformation(extent={{80,2},{60,22}})));
equation
  connect(m_flow.y, HeatFromPowerPlant.m_flow) annotation (Line(points={{-79,62},{-58,62},{-58,10},{-50,10}}, color={0,0,127}));
  connect(T_feed_CHP.Kelvin, HeatFromPowerPlant.T) annotation (Line(points={{-68,9.4},{-68,9.4},{-68,4},{-50,4}}, color={0,0,127}));
  connect(T_feed_CHP_degC.y, T_feed_CHP.Celsius) annotation (Line(points={{-79,30},{-68,30},{-68,28},{-68,23.2}}, color={0,0,127}));
  connect(noLoss.port, HeatStorage.heatLosses) annotation (Line(points={{22,30},{22,30},{22,11.15},{20.8,11.15}}, color={191,0,0}));
  connect(HeatStorage.inletCHP, HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-8,6.4},{-14,6.4},{-14,6},{-28,6},{-28,4}},
      color={175,0,0},
      thickness=0.5));
  connect(heat_toCHP.steam_a, HeatStorage.outletCHP) annotation (Line(
      points={{-30,-22},{-24,-22},{-24,-14},{-18,-14},{-18,-6.9},{-8,-6.9}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatFromPowerPlant1.steam_a, HeatStorage.inletGrid) annotation (Line(
      points={{62,-16},{28,-16},{28,-14.5}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatStorage.outletGrid, HeatFromPowerPlant2.steam_a) annotation (Line(
      points={{28,2.6},{36,2.6},{36,2},{42,2},{42,12},{60,12}},
      color={175,0,0},
      thickness=0.5));
  connect(T_return.y, heat_toCHP.T) annotation (Line(points={{-79,-20},{-50,-20},{-50,-22}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{30,84},{70,62}},
          lineColor={8,175,0},
          lineThickness=0.5,
          textString="3 fluid ports have to have
a given mass flow, the last
one results from a mass 
balance")}),                                  experiment(StopTime=86400),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for HotwaterStorage_L4</p>
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
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestStratifiedHotWaterStorage_L4;
