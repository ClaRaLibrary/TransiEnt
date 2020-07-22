within TransiEnt.Components.Gas.Combustion;
model FullConversion_idealGas "Full conversion, fuel type independent combustion model for emission calculation purpose"

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

  extends TransiEnt.Basics.Icons.FullConversion;
  extends TransiEnt.Components.Gas.Combustion.Basics.CombustionBaseClass_idealGas;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  //Air
  final parameter SI.MolarMass M_i_air[airType.nc_propertyCalculation]=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_idealGas(airType, airType.nc_propertyCalculation) "[O2, N2] Air molar masses";
  //Fuel
  final parameter SI.MolarMass M_i_fuel[FuelMedium.nc_propertyCalculation]=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_idealGas(FuelMedium, FuelMedium.nc_propertyCalculation) "Fuel molar masses";
  //Exhaust
  final parameter SI.MolarMass M_i_exh[ExhaustGas.nc_propertyCalculation]=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_idealGas(ExhaustGas, ExhaustGas.nc_propertyCalculation) "[H2O, CO2, CO, H2, O2, NO, NO2, SO2, N2] Exhaust molar masses";

  parameter TransiEnt.Basics.Records.GasProperties.OxygenDemandCombustion oxygenDemand;

  final parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir airType "Air medium type";
  final parameter SI.MassFraction[airType.nc-1] xi_air = airType.xi_default "[H2O, N2, O2] Air components mass fraction";
  parameter Real lambda = 1.2 "Air ratio"  annotation (Dialog(enable=false));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  //Flow composition
protected
  SI.MassFraction xi_fuel[FuelMedium.nc-1](start=FuelMedium.xi_default) "Mass fraction of fuel components";
  SI.MassFraction xi_exh[ExhaustGas.nc-1](start=zeros(ExhaustGas.nc-1)) "[H2O, CO2, CO, H2, O2, NO, NO2, SO2, N2] Mass fraction of flue components";

  Modelica.SIunits.MolarFlowRate[5] n_flow_fuel_elements "Molar flow rate of the fuel containing elements [C,H,O,N,S]";

  Modelica.SIunits.MolarFlowRate n_flow_flue_H2O;
  Modelica.SIunits.MolarFlowRate n_flow_flue_CO2;
  Modelica.SIunits.MolarFlowRate n_flow_flue_O2;
  Modelica.SIunits.MolarFlowRate n_flow_flue_N2;

public
  Modelica.SIunits.MassFlowRate m_flow_air;
protected
  Modelica.SIunits.MolarFlowRate n_flow_air_H2O;
  Modelica.SIunits.MolarFlowRate n_flow_air_N2;
  Modelica.SIunits.MolarFlowRate n_flow_air_O2;

  //Required flow rates for stochiometric combustion
  Modelica.SIunits.MolarFlowRate n_flow_O2_req;
  Modelica.SIunits.MassFlowRate m_flow_O2_req;
  Modelica.SIunits.MassFlowRate m_flow_air_req;

equation
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  //Mass balance
  gasPortIn.m_flow + m_flow_air + gasPortOut.m_flow = 0;

  gasPortOut.xi_outflow = xi_exh;
  xi_fuel = inStream(gasPortIn.xi_outflow);
  xi_fuel = gasPortIn.xi_outflow;

  //Energy balance
  inStream(gasPortIn.h_outflow) = gasPortOut.h_outflow "Dummy!";
  inStream(gasPortOut.h_outflow) = gasPortIn.h_outflow "Dummy!";

  //Chemical reaction
  n_flow_fuel_elements =TransiEnt.Basics.Functions.GasProperties.comps2Elements_idealGas(
    FuelMedium,
    inStream(gasPortIn.xi_outflow),
    gasPortIn.m_flow);
  n_flow_O2_req = (oxygenDemand.ominsVector[1]*n_flow_fuel_elements[1]+oxygenDemand.ominsVector[2]*n_flow_fuel_elements[2]+oxygenDemand.ominsVector[3]*n_flow_fuel_elements[3])/2 "Only C and H are considered combustible";

  //Required mass flow rates for stochiometric combustion
  m_flow_O2_req = n_flow_O2_req*M_i_air[3] "Oxygen flow required for stochiometrical combustion";
  m_flow_air_req = m_flow_O2_req/(1-sum(xi_air)) "Air flow required for stochiometrical combustion";
  m_flow_air=lambda*m_flow_air_req "Actual air inlet";

  //Calculate molar inflow of air components
  n_flow_air_H2O = xi_air[1]*m_flow_air/M_i_air[1];
  n_flow_air_N2 = xi_air[2]*m_flow_air/M_i_air[2];
  n_flow_air_O2 = (1-sum(xi_air))*m_flow_air/M_i_air[3];

  //Molar flow rates of products
  n_flow_flue_H2O = 0.5*n_flow_fuel_elements[2] + n_flow_air_H2O;
  n_flow_flue_CO2 = n_flow_fuel_elements[1] "Full conversion!";
  n_flow_flue_O2 = n_flow_air_O2 - n_flow_O2_req;
  n_flow_flue_N2 = 0.5*n_flow_fuel_elements[4] + n_flow_air_N2;

  xi_exh[1]*gasPortOut.m_flow = -n_flow_flue_H2O*M_i_exh[1];
  xi_exh[2]*gasPortOut.m_flow = -n_flow_flue_CO2*M_i_exh[2];
  xi_exh[3] = 0;
  xi_exh[4] = 0;
  xi_exh[5]*gasPortOut.m_flow = -n_flow_flue_O2*M_i_exh[5];
  xi_exh[6] = 0;
  xi_exh[7] = 0;
  xi_exh[8] = 0;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),     Diagram(graphics,
                                            coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>Simple and effective (no TILMedia-Objects) model for an ideal chemical combustion of natural gas to calculate the exhaust mass flow and gas composition for the default gastype gasModel2 as defined in the simCenter repository at a given lambda. </p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b> </p>
<p>Full conversion of all combustibles. Air inflow calculated internally for (super)stoichiometric combustion (lambda).</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Generation of CO, NO<sub>x</sub>, SO<sub>2</sub> is neglected.</p>
<p>Air and flue gasTypes are final.</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b> </p>
<p>gasPortIn/Out - port for fuelgas at the inlet and exhaustgas at the outlet </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b> </p>
<p>(no elements) </p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b> </p>
<p>The exhaust gas composition is calculated by a simple set of balance equations for the chemical elements in the molecules of fuelgas and air.</p>
<p>The flow of the fuel gas components is tranlsated into a flow of chemical elements by the external function <i>Comps2ElementsGas</i>, wherein combustible (not fully oxidized) and non-combustible (from CO<sub>2</sub>, H<sub>2</sub>O) C and H are fully considered.</p>
<p>The air gasType is fixed with the components:</p>
<ol>
<li>Water </li>
<li>Nitrogen </li>
<li>Oxygen </li>
</ol>
<p>Required oxigen/air for stoichiometric combustion are then read out by the external function <i>OxygenDemand</i> and calculated:</p>
<p><i>m</i><sub>air,req</sub> = <i>n</i><sub>O2,req</sub> &middot; <i>M</i><sub>O2</sub> / <i>&xi;</i><sub>O2,air</sub></p>
<p>and</p>
<p><i>m</i><sub>air</sub> = <i>m</i><sub>air,req</sub> &middot; <i>&lambda;</i></p>
<p>With the air composition and inflow the component outflow of the flue gas is calculated. It is assumed to be composed of (in the shown order) </p>
<ol>
<li>Water </li>
<li>Carbon dioxide </li>
<li>Carbon monoxide </li>
<li>Hydrogen </li>
<li>Oxygen </li>
<li>Nitric oxide </li>
<li>Nitric dioxide </li>
<li>Sulfur dioxide </li>
<li>Nitrogen </li>
</ol>
<p>This yields with CO, NO<sub>x</sub>, SO<sub>x</sub> neglected:</p>
<p><i>n</i><sub>H2O,flue</sub> = 0.5<i>n</i><sub>H,fuel</sub> + <i>n</i><sub>H2O,air</sub></p>
<p><i>n</i><sub>CO2,flue</sub> = <i>n</i><sub>C,fuel</sub></p>
<p><i>n</i><sub>O2,flue</sub> = <i>n</i><sub>O2,air</sub> - <i>n</i><sub>O2,req</sub></p>
<p><i>n</i><sub>N2,flue</sub> = <i>n</i><sub>N2,fuel</sub> + <i>n</i><sub>N2,air</sub></p>
<p>The mass flow rate is calculated by a simple mass balance equation, which yields </p>
<p><i>m</i><sub>fuel,in</sub> + <i>m</i><sub>air,in</sub> + <i>m</i><sub>flue,out</sub> = 0, where <i>m</i><sub>air,in</sub> is calculated internally. </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no elements) </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b> </p>
<p>Tested in check model &quot;TransiEnt.Components.Gas.Combustion.Check.TestCombustion&quot;</p>
<p><b><span style=\"color: #008000;\">9. References</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b> </p>
<p>Created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Edited by Paul Kernstock (paul.kernstock@tuhh.de), Aug 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end FullConversion_idealGas;
