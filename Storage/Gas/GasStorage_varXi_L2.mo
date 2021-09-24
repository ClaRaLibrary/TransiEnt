within TransiEnt.Storage.Gas;
model GasStorage_varXi_L2 "L2: Model of a simple gas storage volume for variable composition"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends Base.PartialGasStorage_L2;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else TransiEnt.Basics.Functions.findSetDifference(1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition or variableCompositionEntries[1] <> 0));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter SI.MassFraction xi_gas_start[medium.nc-1]=medium.xi_default "Mass composition of gas in storage at t=0" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts_Storage(
    redeclare model CostRecordGeneral = CostSpecsStorage (size1=V_geo),
    der_E_n=0,
    E_n=0,
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false,
    calculateCost=calculateCost) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
public
  inner Summary summary(
    outline(
      H_flow_in_NCV=H_flow_in_NCV,
      H_flow_out_NCV=H_flow_out_NCV,
      H_gas_NCV=H_gas_NCV,
      H_flow_in_GCV=H_flow_in_GCV,
      H_flow_out_GCV=H_flow_out_GCV,
      H_gas_GCV=H_gas_GCV),
    gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    gasBulk(
      mediumModel=medium,
      mass=m_gas,
      T=gasBulk.T,
      p=p_gas,
      h=h_gas,
      xi=xi_gas,
      x=gasBulk.x,
      rho=gasBulk.d),
    costs(
      costs=collectCosts_Storage.costsCollector.Costs,
      investCosts=collectCosts_Storage.costsCollector.InvestCosts,
      investCostsStartGas=0,
      demandCosts=collectCosts_Storage.costsCollector.DemandCosts,
      oMCosts=collectCosts_Storage.costsCollector.OMCosts,
      otherCosts=collectCosts_Storage.costsCollector.OtherCosts,
      revenues=collectCosts_Storage.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Outline
    input SI.EnergyFlowRate H_flow_in_NCV "Inflowing enthalpy flow based on NCV";
    input SI.EnergyFlowRate H_flow_out_NCV "Inflowing enthalpy flow based on NCV";
    input SI.Enthalpy H_gas_NCV "Enthalpy of the gas bulk based on NCV";
    input SI.EnergyFlowRate H_flow_in_GCV "Inflowing enthalpy flow based on GCV";
    input SI.EnergyFlowRate H_flow_out_GCV "Inflowing enthalpy flow based on GCV";
    input SI.Enthalpy H_gas_GCV "Enthalpy of the gas bulk based on GCV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.CostsStorage costs;
  end Summary;

  Modelica.Units.SI.MassFraction xi_end=1 - sum(xi_gas) "Last entry of mass fraction";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation

  if variableCompositionEntries[1] <> 0 then
    for j in variableCompositionEntries loop
      if j <> medium.nc then
        xi_gas[j] = xi_gas_start[j];
      else
        xi_end = 1 - sum(xi_gas_start);
      end if;
    end for;
  else
    xi_gas = xi_gas_start;
  end if;

equation

  //der(m_gas*xi_gas)=gasPortIn.m_flow*actualStream(gasPortIn.xi_outflow)+gasPortOut.m_flow*actualStream(gasPortOut.xi_outflow);
  //der(m_gas)*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*actualStream(gasPortIn.xi_outflow)+gasPortOut.m_flow*actualStream(gasPortOut.xi_outflow);
  //V_geo*drhodt*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow));

  drhodt = gasBulk.drhodh_pxi*der(h_gas) + gasBulk.drhodp_hxi*der(p_gas) + sum({gasBulk.drhodxi_ph[i] * der(xi_gas[i]) for i in 1:medium.nc-1});

  if variableCompositionEntries[1] == 0 then //all components are considered fully variable
    V_geo*drhodt*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow));
  else
    if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
      for j in variableCompositionEntries[1:end - 1] loop
        V_geo*drhodt*xi_gas[j]+m_gas*der(xi_gas[j])=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow[j]))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow[j]));
      end for;
      V_geo*drhodt*xi_end+m_gas*der(xi_end)=gasPortIn.m_flow*(1-sum(noEvent(actualStream(gasPortIn.xi_outflow))))+gasPortOut.m_flow*(1-sum(noEvent(actualStream(gasPortOut.xi_outflow))));
      for j in dependentCompositionEntries[1:end - 1] loop
        xi_gas[j] = (1 - (sum(xi_gas[k] for k in variableCompositionEntries[1:end - 1]) + xi_end))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
      end for;
    else //the last component is calculated from the sum of the remaining
      for j in variableCompositionEntries loop
        V_geo*drhodt*xi_gas[j]+m_gas*der(xi_gas[j])=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow[j]))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow[j]));
      end for;
      for j in dependentCompositionEntries[1:end - 1] loop
        xi_gas[j] = (1 - sum(xi_gas[k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
      end for;
    end if;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts_Storage.costsCollector, modelStatistics.costsCollector);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a compressed gas storage for real gases with variable composition. It extends Base.PartialGasStorage_L2.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model consists of a volume, in which the gas located. Pressure losses inside the volume and during charging and discharging are neglected. There is no discretisation of the flow field or the heat transfer. The heat transfer is modelled using a replacable heat transfer model, the default model uses a constant heat transfer coefficient. The parameter <span style=\"font-family: Courier New;\">variableCompositionEntries</span> can be used in case that not all components are freely variable, e.g. when hydrogen is fed into natural gas. This reduces the number of states.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models. The gas in the storage is always ideally mixed, there is only one composition in the storage.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<p>heat: heat port for the heat flow into/out of the storage</p>
<p>p_storage: signal output of the gas pressure</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple mass and energy balances are used. For the compositions, component mass balances are added.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>This model is not validated and might produce different results depending on the energy balance equation used in the base model.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2017</p>
<p>Modeli modified by Carsten Bode (c.bode@tuhh.de) in Apr 2021 (added simplifications for composition)</p>
</html>"),Diagram(graphics,
                  coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L2")},
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end GasStorage_varXi_L2;
