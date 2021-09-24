within TransiEnt.Storage.Gas;
model GasStorage_constXi_L2 "L2: Model of a simple gas storage volume for constant composition"


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

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean useXiConstParameter = false "true if parameter xi_const shall be used, false if actualStream(gasPortIn.xi_outflow) shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_const[medium.nc-1] = medium.xi_default "Constant composition" annotation(Dialog(group="Fundamental Definitions"),enable=useXiConstParameter);
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific cost per electric energy for start gas generation" annotation (Dialog(group="Statistics"));
  parameter SI.Efficiency eta_ely=0.75 "Electrolyzer efficiency with which the start gas is produced" annotation(Dialog(group="Statistics"));
  parameter SI.Pressure p_max=200e5 "Maximum pressure in storage" annotation(Dialog(group="Statistics"));

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
    der_E_n=0,
    E_n=0,
    redeclare model CostRecordGeneral = CostSpecsStorage (size1=V_geo, size2=p_max),
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
    calculateCost=calculateCost)                                                     annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCosts_HydrogenStorageStartGas collectCosts_StartGas(
    Cspec_demAndRev_el=Cspec_demAndRev_el,
    eta_ely=eta_ely,
    mass_H2=m_gas,
    calculateCost=calculateCost)
                   annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
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
      costs=collectCosts_Storage.costsCollector.Costs+collectCosts_StartGas.costsCollector.Costs,
      investCosts=collectCosts_Storage.costsCollector.InvestCosts,
      investCostsStartGas=collectCosts_StartGas.costsCollector.InvestCosts,
      demandCosts=collectCosts_Storage.costsCollector.DemandCosts,
      oMCosts=collectCosts_Storage.costsCollector.OMCosts,
      otherCosts=collectCosts_Storage.costsCollector.OtherCosts,
      revenues=collectCosts_Storage.costsCollector.Revenues))
         annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

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

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation

  drhodt = gasBulk.drhodh_pxi*der(h_gas) + gasBulk.drhodp_hxi*der(p_gas);

  xi_gas=if useXiConstParameter then xi_const else inStream(gasPortIn.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts_Storage.costsCollector, modelStatistics.costsCollector);
  connect(collectCosts_StartGas.costsCollector, modelStatistics.costsCollector);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a compressed gas storage for real gases with constant composition. It extends Base.PartialGasStorage_L2.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model consists of a volume, in which the gas located. Pressure losses inside the volume and during charging and discharging are neglected. There is no discretisation of the flow field or the heat transfer. The heat transfer is modelled using a replacable heat transfer model, the default model uses a constant heat transfer coefficient.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used) as well as constant compositions. For high pressures there are errors due to errors in the gas models.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<p>heat: heat port for the heat flow into/out of the storage</p>
<p>p_storage: signal output of the gas pressure</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple mass and energy balances are used.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p><span style=\"font-family: Courier New;\">useXiConstParameter</span> can be used to either use the <span style=\"font-family: Courier New;\">inStream</span> value of <span style=\"font-family: Courier New;\">gasPortIn</span> or <span style=\"font-family: Courier New;\">xi_const</span> for the composition.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Validated because this model including heat transfer (UndergroundGasStorageHeatTransfer_L2) is validated.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2016</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p>Modeli modified by Carsten Bode (c.bode@tuhh.de) in Apr 2021 (added simplifications for composition)</p>
</html>"),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L2")},
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end GasStorage_constXi_L2;
