within TransiEnt.Grid.Heat.HeatGridControl.Controllers;
model DHNControlLumpedGrid "DHN Control model (provides setpoint values) for a lumped grid model (total mass flow, total heat flow rate...)"
  import TransiEnt;

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

  extends TransiEnt.Basics.Icons.Controller;
  // _____________________________________________
  //
  //          Components
  // _____________________________________________

  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 tamb(datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic, relativepath="ambient/Temperature_Hamburg-Fuhlsbuettel_3600s_01012012_31122012.txt") annotation (Placement(transformation(extent={{-109,6},{-89,26}})));
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG T_supply_return_target annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Math.Feedback delta_T_target
    annotation (Placement(transformation(extent={{-10,47},{10,67}})));
  Modelica.Blocks.Math.Gain cp(k=4186)
    annotation (Placement(transformation(extent={{16,51},{28,63}})));
  Modelica.Blocks.Math.Division m_flow_target
    annotation (Placement(transformation(extent={{56,55},{66,65}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_set "Setpoint for total mass flow"
                                   annotation (Placement(transformation(
          rotation=0, extent={{90,50},{110,70}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set "Setpoint for total heat production"
                                         annotation (Placement(transformation(
          rotation=0, extent={{90,-70},{110,-50}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_feed_set "Setpoint for feed flow temperature"
                                         annotation (Placement(transformation(
          rotation=0, extent={{90,10},{110,30}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_return_set "Setpoint for return flow temperature"
                                           annotation (Placement(transformation(
          rotation=0, extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Math.Gain sign_changer(k=-1) annotation (Placement(transformation(extent={{46,-70},{66,-50}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(
    offsetOn=false,
    weekendOn=false,
    SummerDayTypicalHeatLoadCharLine=false,
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(delta_T_target.y,cp. u) annotation (Line(
      points={{9,57},{14.8,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cp.y,m_flow_target. u2) annotation (Line(
      points={{28.6,57},{55,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_target.y, m_flow_set) annotation (Line(
      points={{66.5,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_feed_set, delta_T_target.u1) annotation (Line(
      points={{100,20},{-20,20},{-20,57},{-8,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_return_set, delta_T_target.u2) annotation (Line(
      points={{100,-20},{72,-20},{72,36},{0,36},{0,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign_changer.y, Q_flow_set) annotation (Line(
      points={{67,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_supply_return_target.T_set[1], T_feed_set) annotation (Line(points={{13,0},{54,0},{54,20},{100,20}}, color={0,0,127}));
  connect(T_supply_return_target.T_set[2], T_return_set) annotation (Line(points={{13,0},{54,0},{54,-20},{100,-20}}, color={0,0,127}));
  connect(sign_changer.u, heatingLoadCharline.Q_flow) annotation (Line(points={{44,-60},{-40,-60},{-40,0},{-45,0}}, color={0,0,127}));
  connect(tamb.y1, heatingLoadCharline.T_amb) annotation (Line(points={{-88,16},{-78,16},{-78,1},{-67,1}},
                                                                                                         color={0,0,127}));
  connect(tamb.value, T_supply_return_target.T_amb) annotation (Line(points={{-90.2,16},{-10,16},{-10,0}}, color={0,0,127}));
  connect(m_flow_target.u1, heatingLoadCharline.Q_flow) annotation (Line(points={{55,63},{52,63},{52,78},{-40,78},{-40,0},{-45,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-110,-100},{90,100}},
          preserveAspectRatio=false)),           Icon(coordinateSystem(extent={{-110,
            -100},{90,100}}, preserveAspectRatio=false), graphics={
        Text(
          extent={{-84,86},{68,62}},
          lineColor={0,0,255},
          textString="m_flow_set"),
        Text(
          extent={{-82,18},{76,-2}},
          lineColor={0,0,255},
          textString="T_feed_set"),
        Text(
          extent={{-84,-20},{72,-38}},
          lineColor={0,0,255},
          textString="T_return_set"),
        Text(
          extent={{-84,-66},{84,-82}},
          lineColor={0,0,255},
          textString="Q_flow_set")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Returns required heat and mass flow as well as supply and return temperature of a chosen city using charlines depending on the ambient temperature.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_set: output for mass flow rate in kg/s]- setpoint for total mass flow</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_set: output for heat flow rate in [W]- setpoint for total heat production</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_feed_set: output for temperature in [K]- setpoint for feed flow temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_return_set: output for temperature in [K]- setpoint for return flow temperature</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end DHNControlLumpedGrid;
