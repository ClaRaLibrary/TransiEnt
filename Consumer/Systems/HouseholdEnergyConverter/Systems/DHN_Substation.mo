within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems;
model DHN_Substation "Substation for district hot water"



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

  extends Base.Systems(
    final DHN=true,
    final el_grid=true,
    final gas_grid=false);

  import TIL = TILMedia.VLEFluidFunctions;
  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter SI.MassFlowRate m_flow_min=0.0001 "Minimum massflow rate";
  parameter SI.Temperature T_start=90 + 273.15 "Temperature at start of the simulation" annotation (Dialog(group="Temperature"));
  parameter Real dT=20 "Constant Temperature Difference between supply and return" annotation (Dialog(group="Temperature"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-76,-30},{-56,-10}})));

  TransiEnt.Producer.Heat.Heat2Heat.Substation_indirect_noStorage_L1 substation_indirect_noStorage_L1_1(
    T_start=T_start,
    dT=dT,
    m_flow_min=m_flow_min) annotation (Placement(transformation(extent={{-14,6},{14,26}})));
equation

  connect(apparentPower.P_el_set, demand.electricPowerDemand) annotation (Line(points={{-72,-8},{-72,81.8},{4.68,81.8},{4.68,100.48}}, color={0,0,127}));
  connect(apparentPower.epp, epp) annotation (Line(
      points={{-76,-20},{-76,-20},{-80,-20},{-80,-98}},
      color={0,127,0},
      thickness=0.5));

  connect(substation_indirect_noStorage_L1_1.waterPortIn, waterPortIn) annotation (Line(
      points={{-6,6},{-20,6},{-20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(substation_indirect_noStorage_L1_1.waterPortOut, waterPortOut) annotation (Line(
      points={{6.1,5.9},{20,5.9},{20,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(demand.heatingPowerDemand, substation_indirect_noStorage_L1_1.Q_demand_RH) annotation (Line(
      points={{0,100.48},{0,62},{-8,62},{-8,34},{-10,34},{-10,30},{-11,30},{-11,25}},
      color={175,0,0},
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(demand.hotWaterPowerDemand, substation_indirect_noStorage_L1_1.Q_demand_DHW) annotation (Line(
      points={{-4.8,100.48},{-4.8,62},{12,62},{12,42},{11,42},{11,25}},
      color={175,0,0},
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Rectangle(
          extent={{-28,4},{24,-68}},
          lineColor={127,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-68},{-28,4},{24,4},{-28,-68}},
          lineColor={127,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,4},{0,58},{28,58}}, color={255,0,0}),
        Line(points={{24,-32},{72,-32},{72,58},{62,58},{58,58}}, color={0,0,255}),
        Ellipse(extent={{28,70},{58,42}}, lineColor={127,0,0}),
        Line(points={{-26,-32},{-54,-32},{-54,-78}}, color={255,0,0}),
        Line(points={{2,-80},{2,-68},{2,-96},{2,-96}}, color={255,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model of a DHN substation to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn <b>waterPortIn</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut <b>waterPortOut - connection to district heating grid</b></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modification by Philipp Huismann, Gas- und W&auml;rme-Institut e.V. in 2020</span></p>
</html>"));
end DHN_Substation;
