within TransiEnt.Components.Electrical.FuelCellSystems.Base;
model FuelCellSystemEfficiency "Tool to calculate the thermal and electric effiency of fuel cell system including steam reformer"



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

  extends TransiEnt.Basics.Icons.Sensor;
  import TransiEnt;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  // ingoing energy streams

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_CH4 "Input for CH4 heat flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,36})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_evaporator "Input for heat flow rate of the evaporator" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-4})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_preheater "Input for the heat flow rate of the preheater" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-46})));

  // outgoing energy streams

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_exhaustGasChemical "Input for heat flow rate of the exhaust (GasChemical)"   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={68,100})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_exhaustGasLatent "Input for heat flow rate of the exhaust (GasLatent)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={20,100})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_cooling "Input for heat flow rate of the cooling" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-22,100})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el "Input for electric power" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  Modelica.Units.SI.Efficiency eta_th=if Q_flow_in_CH4 <= 0 then 0 else Q_gen_total/(Q_flow_in_CH4 + Q_flow_in_evaporator + Q_flow_in_preheater);
  Modelica.Units.SI.Efficiency eta_el=if Q_flow_in_CH4 <= 0 then 0 else P_el/(Q_flow_in_CH4 + Q_flow_in_evaporator + Q_flow_in_preheater);
  Modelica.Units.SI.Efficiency eta_total=eta_th + eta_el;
  Modelica.Units.SI.HeatFlowRate Q_gen_total=Q_flow_out_cooling + Q_flow_out_exhaustGasLatent + Q_flow_out_exhaustGasChemical;
  Modelica.Units.SI.Power P_gen_total=P_el;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tool to calculate the thermal and electric effiency of fuel cell system including steam reformer</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_CH4 <span style=\"color: #006400;\">&quot;Input for CH4 heat flow rate&quot;</span> ;</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_evaporator <span style=\"color: #006400;\">&quot;Input for heat flow rate of the evaporator&quot;</span> ;</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in_preheater <span style=\"color: #006400;\">&quot;Input for the heat flow rate of the preheater&quot;</span> ;</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_exhaustGasChemical <span style=\"color: #006400;\">&quot;Input for heat flow rate of the exhaust (GasChemical)&quot;</span>  ;</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_exhaustGasLatent <span style=\"color: #006400;\">&quot;Input for heat flow rate of the exhaust (GasLatent)&quot;</span>;</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_out_cooling <span style=\"color: #006400;\">&quot;Input for heat flow rate of the cooling&quot;</span> ;</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el <span style=\"color: #006400;\">&quot;Input for electric power&quot;</span> ;</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>eta_th is the thermal efficiency</p>
<p>eta_el is the electric efficiency</p>
<p>eta_total is the total efficiency</p>
<p>Q_gen_total is the total generated heat flow rate</p>
<p>P_gen_total is the total generated power</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Components.Electrical.FuelCellSystems.Check.TestFuelCellSystem_SOFC&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end FuelCellSystemEfficiency;
