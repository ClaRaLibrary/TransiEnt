within TransiEnt.Components.Electrical.FuelCellSystems.Base;
model SyngasSensor "Sensor measuring fuel cell performance (including a simple gas burner model for burning of remainding H2 in flue gas)"

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

  extends TransiEnt.Basics.Icons.Sensor;
  import TransiEnt;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);
  parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir Air=TransiEnt.Basics.Media.Gases.Gas_MoistAir() "Medium model of Air_AmbientCondition" annotation (choicesAllMatching);

  parameter Real eta_preheater = 1 "Efficiency of pre heater";
  parameter Modelica.SIunits.Temperature T_ambient = simCenter.T_amb_const "Ambient temperature";
  parameter Modelica.SIunits.SpecificEnthalpy H_UCH4 = 50.013e6 "Heating value of methane";
    parameter Modelica.SIunits.SpecificEnthalpy H_UH2 = 120.9e6 "Heating value of hydrogen";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn gasPortIn(Medium=Syngas) annotation (Placement(transformation(extent={{-108,-10},{-88,10}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut gasPortOut(Medium=Syngas) annotation (Placement(transformation(extent={{88,-10},{108,10}}), iconTransformation(extent={{88,-10},{108,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    TILMedia.Gas_pT Air_AmbientCondition(
    T=T_ambient,
    xi={0.001,0.7},
    gasType = Air,
    p=100000)      "Moist air is used which consists of N2, H2O and O2. This is why the component O2 can be used from it!"
    annotation (Placement(transformation(extent={{-32,62},{-8,92}})));

    TILMedia.Gas_pT Syngas_InputCondition(
    T=inStream(gasPortIn.T_outflow),
    xi= inStream(gasPortIn.xi_outflow),
    gasType=Syngas,
    p=100000)
    annotation (Placement(transformation(extent={{-80,-12},{-56,12}})));

    TILMedia.Gas_pT Syngas_AmbientCondition(
    T=T_ambient,
    xi=inStream(gasPortIn.xi_outflow),
    gasType=Syngas,
    p=100000) annotation (Placement(transformation(extent={{6,64},{32,90}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_in_CH4  "CH4 heat flow rate";
  Modelica.SIunits.HeatFlowRate Q_flow_exhaustGasChemical "Heat flow rate of the exhaust (GasChemical)";
  Modelica.SIunits.HeatFlowRate Q_flow_in_evaporator "Heat flow rate of the evaporator";
  Modelica.SIunits.HeatFlowRate Q_flow_exhaustGasLatent "Heat flow rate of the exhaust (GasLatent)";
  Modelica.SIunits.HeatFlowRate Q_flow_in_preheater "Heat flow rate of the preheater";
  Modelica.SIunits.HeatFlowRate Q_flow_in_CH4_preheat "Heat flow rate of the preheated CH4";
  Modelica.SIunits.HeatFlowRate Q_flow_in_air_preheat "Heat flow rate of the preheated air";
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

    -Q_flow_in_CH4 = -gasPortIn.m_flow*Syngas_InputCondition.xi[1]*H_UCH4;
    -Q_flow_exhaustGasLatent = gasPortIn.m_flow*Syngas_InputCondition.cp*(T_ambient+55 - Syngas_InputCondition.T) "Heating power relative to the reference condition";
    -Q_flow_in_evaporator = gasPortIn.m_flow*Syngas_InputCondition.xi[4] *( 104.93 - 3488.7)   * 1000 "Heating power to evaporate the water and heat it to 500 °C, values from the VDI-Waermeatlas";
    -Q_flow_in_air_preheat = gasPortIn.m_flow*Syngas_InputCondition.xi[2]*Air_AmbientCondition.cp*( Air_AmbientCondition.T - inStream(gasPortIn.T_outflow))  /eta_preheater "Heating power for preheating the air";
    -Q_flow_in_CH4_preheat = gasPortIn.m_flow*Syngas_InputCondition.xi[1]*2210*( Air_AmbientCondition.T - inStream(gasPortIn.T_outflow))  /eta_preheater "Heating power for preheating the CH4";
    Q_flow_in_preheater = Q_flow_in_air_preheat+ Q_flow_in_CH4_preheat;
    -Q_flow_exhaustGasChemical = -gasPortIn.m_flow*Syngas_InputCondition.xi[5]*H_UH2 "Heating power for preheating the air";

      // impulse equation
      gasPortIn.p = gasPortOut.p;

      // mass balance (total mass)
      gasPortIn.m_flow + gasPortOut.m_flow = 0;

      // enthalpy (considered no dynamic heat transfers between reformer and gas"
     gasPortOut.T_outflow = inStream(gasPortIn.T_outflow);
     gasPortIn.T_outflow = Syngas_InputCondition.T;

      // mass fractions
      gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
      gasPortOut.xi_outflow = Syngas_InputCondition.xi;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Sensor measuring fuel cell performance (including a simple gas burner model for burning of remainding H2 in flue gas)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn gasPortIn(Medium=Syngas)</p>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut gasPortOut(Medium=Syngas)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Q_flow_in_CH4 <span style=\"color: #006400;\"> &quot;CH4 heat flow rate&quot;</span></p>
<p>Q_flow_exhaustGasChemical <span style=\"color: #006400;\">&quot;Heat flow rate of the exhaust (GasChemical)&quot;</span></p>
<p>Q_flow_in_evaporator <span style=\"color: #006400;\">&quot;Heat flow rate of the evaporator&quot;</span></p>
<p>Q_flow_exhaustGasLatent <span style=\"color: #006400;\">&quot;Heat flow rate of the exhaust (GasLatent)&quot;</span></p>
<p>Q_flow_in_preheater <span style=\"color: #006400;\">&quot;Heat flow rate of the preheater&quot;</span>;</p>
<p>Q_flow_in_CH4_preheat <span style=\"color: #006400;\">&quot;Heat flow rate of the preheated CH4&quot;</span></p>
<p>Q_flow_in_air_preheat <span style=\"color: #006400;\">&quot;Heat flow rate of the preheated air&quot;</span></p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SyngasSensor;
