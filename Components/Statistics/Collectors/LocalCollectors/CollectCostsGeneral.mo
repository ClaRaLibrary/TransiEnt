within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CollectCostsGeneral "Cost collector for general components"

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

  extends TransiEnt.Components.Statistics.Collectors.LocalCollectors.PartialCollectCosts;
  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Power der_E_n(displayUnit="W") = 500e6 "Nominal power of the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Energy E_n(displayUnit="MWh") = 3.6e12 "Nominal energy of the component" annotation(Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.MonetaryUnit C_OM_fix=0 "Fix annual operating and maintenance cost (independent from investment)";

  parameter Boolean produces_P_el=true "true if the component produces electric power" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean consumes_P_el=true "true if the component consumes electric power" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean produces_Q_flow=true "true if the component produces a heat flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean consumes_Q_flow=true "true if the component consumes a heat flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean produces_H_flow=true "true if the component produces an enthalpy flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean consumes_H_flow=true "true if the component consumes an enthalpy flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean produces_other_flow=true "true if the component produces another flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean consumes_other_flow=true "true if the component consumes another flow" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean produces_m_flow_CDE=true "true if the component produces carbon dioxide emissions" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));
  parameter Boolean consumes_m_flow_CDE=true "true if the component consumes carbon dioxide emissions" annotation (Dialog(group="Demand-related Cost"),choices(__Dymola_checkBox=true));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Demand-related Cost"));
  TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_heat=simCenter.Cspec_demAndRev_free "Specific demand-related cost per heating energy in" annotation (Dialog(group="Demand-related Cost"));
  TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cspec_demAndRev_free "Specific demand-related cost per gas energy" annotation (Dialog(group="Demand-related Cost"));
  Real Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free "Specific demand-related cost per other resource, e.g. water" annotation (Dialog(group="Demand-related Cost"));
  Real Cspec_CO2=simCenter.C_CO2 "EUR/kg, specific price of CDE" annotation (Dialog(group="CO2 Certificates"));

  SI.Power P_el=0 "Consumed or produced electric power (target value of plant)" annotation(Dialog(group="Demand-related Cost"));
  SI.Energy W_el_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed electric energy"
                                                                                                                        annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Energy W_el_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced electric energy"
                                                                                                                         annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.HeatFlowRate Q_flow=0 "Consumed heat flow" annotation(Dialog(group="Demand-related Cost"));
  SI.Heat Q_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed heat"
                                                                                                        annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Heat Q_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced heat"
                                                                                                         annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.EnthalpyFlowRate H_flow=0 "Consumed gas enthalpy flow" annotation(Dialog(group="Demand-related Cost"));
  SI.Enthalpy H_demand(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Consumed gas enthalpy"
                                                                                                                    annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Enthalpy H_revenue(fixed=true, start=0, stateSelect=StateSelect.never,displayUnit="MWh") "Produced gas enthalpy"
                                                                                                                     annotation (Dialog(group="Initialization", showStartAttribute=true));
  Real other_flow=0 "Consumed other resource flow" annotation(Dialog(group="Demand-related Cost"));
  Real other_demand(fixed=true, start=0, stateSelect=StateSelect.never) "Consumed other resource"
                                                                                                 annotation (Dialog(group="Initialization", showStartAttribute=true));
  Real other_revenue(fixed=true, start=0, stateSelect=StateSelect.never) "Produced other resource"
                                                                                                  annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.MassFlowRate m_flow_CDE=0 "Produced CDE mass flow" annotation(Dialog(group="CO2 Certificates"));
  SI.Mass m_CDE_produced(fixed=true, start=0, stateSelect=StateSelect.never) "Produced CDE"
                                                                                           annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Mass m_CDE_consumed(fixed=true, start=0, stateSelect=StateSelect.never) "Consumed CDE"
                                                                                           annotation (Dialog(group="Initialization", showStartAttribute=true));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Calculation of consumed/produced electric energy
  if produces_P_el and calculateCost then
    if noEvent(P_el<eps) then
      der(W_el_revenue)=P_el;
    else
      der(W_el_revenue)=0;
    end if;
  else
    W_el_revenue=0;
  end if;
  if consumes_P_el and calculateCost then
    if noEvent(P_el<eps) then
      der(W_el_demand)=0;
    else
      der(W_el_demand)=P_el;
    end if;
  else
    W_el_demand=0;
  end if;

  //Calculation of consumed/produced heat
  if produces_Q_flow and calculateCost then
    if noEvent(Q_flow<eps) then
      der(Q_revenue)=Q_flow;
    else
      der(Q_revenue)=0;
    end if;
  else
    Q_revenue=0;
  end if;
  if consumes_Q_flow and calculateCost then
    if noEvent(Q_flow<eps) then
      der(Q_demand)=0;
    else
      der(Q_demand)=Q_flow;
    end if;
  else
    Q_demand=0;
  end if;

  //Calculation of consumed/produced gas enthalpy
  if produces_H_flow and calculateCost then
    if noEvent(H_flow<eps) then
      der(H_revenue)=H_flow;
    else
      der(H_revenue)=0;
    end if;
  else
    H_revenue=0;
  end if;
  if consumes_H_flow and calculateCost then
    if noEvent(H_flow<eps) then
      der(H_demand)=0;
    else
      der(H_demand)=H_flow;
    end if;
  else
    H_demand=0;
  end if;

  //Calculation of consumed/produced other resource
  if produces_other_flow and calculateCost then
    if noEvent(other_flow<eps) then
      der(other_revenue)=other_flow;
    else
      der(other_revenue)=0;
    end if;
  else
    other_revenue=0;
  end if;
  if consumes_other_flow and calculateCost then
    if noEvent(other_flow<eps) then
      der(other_demand)=0;
    else
      der(other_demand)=other_flow;
    end if;
  else
    other_demand=0;
  end if;

  //Calculation of CDE
  if produces_m_flow_CDE and calculateCost then
    if noEvent(m_flow_CDE<eps) then
      der(m_CDE_produced)=0;
    else
      der(m_CDE_produced)=m_flow_CDE;
    end if;
  else
    m_CDE_produced=0;
  end if;
  if consumes_m_flow_CDE and calculateCost then
    if noEvent(m_flow_CDE<eps) then
      der(m_CDE_consumed)=m_flow_CDE;
    else
      der(m_CDE_consumed)=0;
    end if;
  else
    m_CDE_consumed=0;
  end if;

  //Calculation of investment costs
  C_inv=if calculateCost then Cspec_inv_der_E*der_E_n+Cspec_inv_E*E_n+C_inv_size else 0;

  //Calculation of O&M costs
  dynamic_C_OM=if calculateCost then (C_OM_fix + C_inv*factor_OM/timeYear*time+Cspec_OM_W_el*(W_el_demand-W_el_revenue)+Cspec_OM_Q*(Q_demand-Q_revenue)+Cspec_OM_H*(H_demand-H_revenue)+Cspec_OM_other*(other_demand-other_revenue))*annuityFactor*dynamicPriceFactorOM else 0; //revenue values are <=0

  //Calculation of demand-related Costs
  dynamic_C_demand=(Cspec_demAndRev_el*W_el_demand+Cspec_demAndRev_heat*Q_demand+Cspec_demAndRev_gas_fuel*H_demand+Cspec_demAndRev_other*other_demand)*annuityFactor*dynamicPriceFactorDemand;

  //Calculation of revenue
  dynamic_C_revenue=(Cspec_demAndRev_el*W_el_revenue+Cspec_demAndRev_heat*Q_revenue+Cspec_demAndRev_gas_fuel*H_revenue+Cspec_demAndRev_other*other_revenue)*annuityFactor*dynamicPriceFactorRevenue;

  //Calculation of other costs
  dynamic_C_other=if calculateCost then (C_other_fix/timeYear*time+Cspec_CO2*(m_CDE_consumed+m_CDE_produced))*annuityFactor*dynamicPriceFactorOther else 0;

  annotation (
    defaultConnectionStructurallyInconsistent=true,
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=
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
