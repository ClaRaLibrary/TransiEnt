within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CollectCostsGeneral "Cost collector for general components"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Statistics.Collectors.LocalCollectors.PartialCollectCosts;
  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Power der_E_n(displayUnit="W") = 500e6 "Nominal power of the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Energy E_n(displayUnit="MWh") = 3.6e12 "Nominal energy of the component" annotation(Dialog(group="Fundamental Definitions"));

  //replaceable parameter TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.ElectricityCostSpecs.NoCost CostRecordElectricity constrainedby TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.ElectricityCostSpecs.PartialCostElectricity "Electricity Cost record" annotation (Dialog(group="Demand-related Cost", enable=useP_elInput), choicesAllMatching);
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Demand-related Cost"));

  //replaceable parameter TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.HeatCostSpecs.NoCost CostRecordHeat constrainedby TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.HeatCostSpecs.PartialCostHeat "Heat Cost record" annotation (Dialog(group="Demand-related Cost", enable=useQ_flowInput), choicesAllMatching);
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_heat=simCenter.Cspec_demAndRev_free "Specific demand-related cost per heating energy in" annotation (Dialog(group="Demand-related Cost"));

  //replaceable parameter TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.GasAndFuelCostSpecs.NoCost CostRecordGasAndFuel constrainedby TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.GasAndFuelCostSpecs.PartialCostGasAndFuel "Gas And Fuel Cost record" annotation (Dialog(group="Demand-related Cost", enable=useH_flowInput), choicesAllMatching);
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cspec_demAndRev_free "Specific demand-related cost per gas energy" annotation (Dialog(group="Demand-related Cost"));

  //replaceable parameter TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.OtherResourcesCostSpecs.NoCost CostRecordOtherResources constrainedby TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.OtherResourcesCostSpecs.PartialCostOtherResources "Electricity CostSpec record" annotation (Dialog(group="Demand-related Cost", enable=useOther_flowInput), choicesAllMatching);
  parameter Real Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free "Specific demand-related cost per other resource, e.g. water" annotation (Dialog(group="Demand-related Cost"));

  parameter Real Cspec_CO2=simCenter.C_CO2 "EUR/kg, specific price of CDE" annotation (Dialog(group="CO2 Certificates"));

  parameter TransiEnt.Basics.Units.MonetaryUnit C_OM_fix=0 "Fix annual operating and maintenance cost (independent from investment)";

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  SI.Power P_el=0 "Consumed or produced electric power (target value of plant)" annotation(Dialog(group="Demand-related Cost"));
  SI.Energy W_el_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed electric energy";
  SI.Energy W_el_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced electric energy";
  SI.HeatFlowRate Q_flow=0 "Consumed heat flow" annotation(Dialog(group="Demand-related Cost"));
  SI.Heat Q_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed heat";
  SI.Heat Q_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced heat";
  SI.EnthalpyFlowRate H_flow=0 "Consumed gas enthalpy flow" annotation(Dialog(group="Demand-related Cost"));
  SI.Enthalpy H_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed gas enthalpy";
  SI.Enthalpy H_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced gas enthalpy";
  Real other_flow=0 "Consumed other resource flow" annotation(Dialog(group="Demand-related Cost"));
  Real other_demand(fixed=true, start=0, stateSelect=StateSelect.never) "Consumed other resource";
  Real other_revenue(fixed=true, start=0, stateSelect=StateSelect.never) "Produced other resource";
  SI.MassFlowRate m_flow_CDE=0 "Produced CDE mass flow" annotation(Dialog(group="CO2 Certificates"));
  SI.Mass m_CDE(fixed=true, start=0, stateSelect=StateSelect.never) "Produced CDE";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Calculation of consumed electric energy
  if P_el<eps then
    der(W_el_demand)=0;
    der(W_el_revenue)=P_el;
  else
    der(W_el_demand)=P_el;
    der(W_el_revenue)=0;
  end if;

  //Calculation of consumed heat
  if Q_flow<eps then
    der(Q_demand)=0;
    der(Q_revenue)=Q_flow;
  else
    der(Q_demand)=Q_flow;
    der(Q_revenue)=0;
  end if;

  //Calculation of consumed gas enthalpy
  if H_flow<eps then
    der(H_demand)=0;
    der(H_revenue)=H_flow;
  else
    der(H_demand)=H_flow;
    der(H_revenue)=0;
  end if;

  //Calculation of consumed other resource
  if other_flow<eps then
    der(other_demand)=0;
    der(other_revenue)=other_flow;
  else
    der(other_demand)=other_flow;
    der(other_revenue)=0;
  end if;

  //Calculation of CDE
  der(m_CDE)=m_flow_CDE;

  //Calculation of investment costs
  C_inv=Cspec_inv_der_E*der_E_n+Cspec_inv_E*E_n+C_inv_size;

  //Calculation of O&M costs
  dynamic_C_OM=(C_OM_fix + C_inv*factor_OM/timeYear*time+Cspec_OM_W_el*(W_el_demand-W_el_revenue)+Cspec_OM_Q*(Q_demand-Q_revenue)+Cspec_OM_H*(H_demand-H_revenue)+Cspec_OM_other*(other_demand-other_revenue))*annuityFactor*dynamicPriceFactorOM; //revenue values are <=0

  //Calculation of demand-related Costs
  dynamic_C_demand=(Cspec_demAndRev_el*W_el_demand+Cspec_demAndRev_heat*Q_demand+Cspec_demAndRev_gas_fuel*H_demand+Cspec_demAndRev_other*other_demand)*annuityFactor*dynamicPriceFactorDemand;

  //Calculation of revenue
  dynamic_C_revenue=(Cspec_demAndRev_el*W_el_revenue+Cspec_demAndRev_heat*Q_revenue+Cspec_demAndRev_gas_fuel*H_revenue+Cspec_demAndRev_other*other_revenue)*annuityFactor*dynamicPriceFactorRevenue;

  //Calculation of other costs
  dynamic_C_other=(C_other_fix/timeYear*time+Cspec_CO2*m_CDE)*annuityFactor*dynamicPriceFactorOther;

  annotation (
    defaultConnectionStructurallyInconsistent=true,
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}})),
          defaultComponentName="collectCosts",
            Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) Equations from Verein Deutscher Ingenieure e.V.: VDI 2067-1: Wirtschaftlichkeit gebaeudetechnischer
Anlagen. Grundlagen und Kostenberechnung. Berlin, September 2012</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode (c.bode@tuhh.de) on 13.02.2017</span></p>
</html>"));
end CollectCostsGeneral;
