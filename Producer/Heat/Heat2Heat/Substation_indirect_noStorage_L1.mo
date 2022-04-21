within TransiEnt.Producer.Heat.Heat2Heat;
model Substation_indirect_noStorage_L1 "Simple model of a substation with indirect connection."



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

 import      Modelica.Units.SI;
 outer TransiEnt.SimCenter simCenter;
 outer TransiEnt.ModelStatistics modelStatistics;

 // _____________________________________________
 //
 //                   Parameters
 // _____________________________________________

 parameter SI.Temperature T_start = simCenter.T_supply "Temperature at start of the simulation";
 parameter SI.MassFlowRate m_flow_min = simCenter.m_flow_min "Minimum mass flow rate to counteract possible zero massflow sitations, equals a simplified bypass";
 replaceable model room_heating_hex_model = TransiEnt.Producer.Heat.Heat2Heat.Indirect_HEX_const_T_out_L1  constrainedby  TransiEnt.Producer.Heat.Base.PartialHEX           annotation (Dialog(group="Heat Exchanger"), __Dymola_choicesAllMatching=true);
 replaceable model dhw_heating_hex_model = TransiEnt.Producer.Heat.Heat2Heat.Indirect_HEX_const_T_out_L1  constrainedby  TransiEnt.Producer.Heat.Base.PartialHEX           annotation (Dialog(group="Heat Exchanger"), __Dymola_choicesAllMatching=true);
 SI.Temperature T_mix "Mixing temperature from room and domestic hot water";

 room_heating_hex_model room_heating_hex(
    T_start=T_start,
    m_flow_min=m_flow_min)
                          annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

 dhw_heating_hex_model domestic_hot_water_hex(
    T_start=T_start,
    m_flow_min=m_flow_min)
                          annotation (Placement(transformation(extent={{-10,30},{10,50}})));

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{96,-105},{106,-95}}), iconTransformation(extent={{44,-118},{78,-84}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{-104,-105},{-94,-95}}), iconTransformation(extent={{-76,-116},{-44,-84}})));

  Modelica.Blocks.Math.Gain signChanger_2(k=-1) annotation (Placement(transformation(
        extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=0,
        origin={-27.5,45.5})));
  Modelica.Blocks.Interfaces.RealInput Q_demand_RH annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-90,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,90})));
  Modelica.Blocks.Interfaces.RealInput Q_demand_DHW annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={90,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,90})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_in_sub(unitOption=1) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-60})));
  Modelica.Blocks.Math.Add add_supply annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-104,-30})));
  Modelica.Blocks.Math.Add add_return annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={106,-30})));

 // _____________________________________________
 //
 //                   Complex Components
 // _____________________________________________

   ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow m_flow_in(
    m_flow_const=-0.048,
    variable_m_flow=true,
    T_const(displayUnit="degC") = T_start,
    p_nom=simCenter.p_nom[2]) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-98,-70})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow m_flow_out(
    T_const(displayUnit="degC") = 363.15,
    m_flow_const=0.048,
    variable_T=true,
    variable_m_flow=true,
    p_nom=simCenter.p_nom[1]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-70})));

  Modelica.Blocks.Math.Gain signChanger_1(k=-1) annotation (Placement(transformation(
        extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=0,
        origin={-27.5,-4.5})));

  ClaRa.Components.Sensors.SensorVLE_L1_T T_out_sub(unitOption=1)
                                                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,-60})));

equation

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________


 T_mix = (domestic_hot_water_hex.m_flow *  domestic_hot_water_hex.T_out_calc +  room_heating_hex.m_flow * room_heating_hex.T_out_calc)/(domestic_hot_water_hex.m_flow+room_heating_hex.m_flow) "Richmann Mixing Rule with same material";

 m_flow_out.T = T_mix;

  connect(m_flow_out.steam_a, waterPortOut) annotation (Line(
      points={{100,-80},{101,-80},{101,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(room_heating_hex.m_flow, signChanger_1.u) annotation (Line(points={{0,-21.4},{0,-34},{-18,-34},{-18,-4.5},{-22.1,-4.5}}, color={0,0,127}));
  connect(domestic_hot_water_hex.m_flow, signChanger_2.u) annotation (Line(points={{0,28.6},{0,16},{-18,16},{-18,45.5},{-22.1,45.5}},     color={0,0,127}));
  connect(Q_demand_RH, room_heating_hex.Q_demand) annotation (Line(points={{-90,100},{-90,8},{-7.2,8},{-7.2,-2}}, color={0,0,127}));
  connect(Q_demand_DHW, domestic_hot_water_hex.Q_demand) annotation (Line(points={{90,100},{90,68},{-7.2,68},{-7.2,48}}, color={0,0,127}));
  connect(T_in_sub.port, waterPortIn) annotation (Line(
      points={{-60,-70},{-60,-100},{-99,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_in_sub.T, room_heating_hex.T_in) annotation (Line(points={{-49,-60},{30,-60},{30,6},{6.8,6},{6.8,-2}}, color={0,0,127}));
  connect(T_in_sub.T, domestic_hot_water_hex.T_in) annotation (Line(points={{-49,-60},{30,-60},{30,62},{6.8,62},{6.8,48}}, color={0,0,127}));
  connect(m_flow_in.steam_a, waterPortIn) annotation (Line(
      points={{-98,-80},{-98,-100},{-99,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(m_flow_in.m_flow, add_supply.y) annotation (Line(points={{-104,-58},{-104,-41}}, color={0,0,127}));
  connect(signChanger_2.y, add_supply.u2) annotation (Line(points={{-32.45,45.5},{-110,45.5},{-110,-18}}, color={0,0,127}));
  connect(signChanger_1.y, add_supply.u1) annotation (Line(points={{-32.45,-4.5},{-98,-4.5},{-98,-18}}, color={0,0,127}));
  connect(add_return.y, m_flow_out.m_flow) annotation (Line(points={{106,-41},{106,-58}}, color={0,0,127}));
  connect(room_heating_hex.m_flow, add_return.u2) annotation (Line(points={{0,-21.4},{0,-34},{82,-34},{82,-6},{100,-6},{100,-18}}, color={0,0,127}));
  connect(domestic_hot_water_hex.m_flow, add_return.u1) annotation (Line(points={{0,28.6},{0,16},{112,16},{112,-18}}, color={0,0,127}));
  connect(T_out_sub.port, waterPortOut) annotation (Line(
      points={{66,-70},{66,-100},{101,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}}),
        graphics={                 Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),
        Line(
          points={{-60,-100},{-60,60},{60,60},{60,-100}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-26,70},{26,50}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,0},{60,0}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-26,10},{26,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-18,74},{20,86}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="DHW"),
        Text(
          extent={{-18,14},{20,26}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="RH")}),
                            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {140,100}}), graphics={
        Rectangle(extent={{-16,86},{18,-30}}, lineColor={28,108,200}),
        Text(
          extent={{-30,86},{36,92}},
          lineColor={0,0,0},
          textString="calculates necessary mass flow
for given dT
")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>District heating Substation model without a storage based on mass flow calculation for constant dT. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ideal temperature difference assumed.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>Based upon the calculation of necessary mass flow for a given temperature difference at heat demand.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>Due to the simple nature of the model, it is important to have a realistic supply temperature to avoid the return temperature to fall below possible values. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de), Oct 2018</span></p>
</html>"));
end Substation_indirect_noStorage_L1;
