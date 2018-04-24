within TransiEnt.Storage.Gas;
model GasStorage_varXi_L2 "Model of a simple gas storage volume for variable composition"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends Base.PartialGasStorage_L2;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.MassFraction xi_gas_start[medium.nc-1]=medium.xi_default "Mass composition of gas in storage at t=0" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________                                                                                                                                            "General Storage Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);

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
    consumes_m_flow_CDE=false)
           annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
public
  inner Summary summary(
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
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.CostsStorage costs;
  end Summary;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation

  xi_gas=xi_gas_start;

equation

  //der(m_gas*xi_gas)=gasPortIn.m_flow*actualStream(gasPortIn.xi_outflow)+gasPortOut.m_flow*actualStream(gasPortOut.xi_outflow);
  //der(m_gas)*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*actualStream(gasPortIn.xi_outflow)+gasPortOut.m_flow*actualStream(gasPortOut.xi_outflow);
  V_geo*drhodt*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*actualStream(gasPortIn.xi_outflow)+gasPortOut.m_flow*actualStream(gasPortOut.xi_outflow);

  drhodt = gasBulk.drhodh_pxi*der(h_gas) + gasBulk.drhodp_hxi*der(p_gas) + sum({gasBulk.drhodxi_ph[i] * der(xi_gas[i]) for i in 1:medium.nc-1});

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts_Storage.costsCollector, modelStatistics.costsCollector);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a compressed gas storage for real gases with variable composition. It extends Base.PartialGasStorage_L2.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model consists of a volume, in which the gas located. Pressure losses inside the volume and during charging and discharging are neglected. There is no discretisation of the flow field or the heat transfer. The heat transfer is modelled using a replacable heat transfer model, the default model uses a constant heat transfer coefficient.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models. The gas in the storage is always ideally mixed, there is only one composition in the storage.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p><p>heat: heat port for the heat flow into/out of the storage</p><p>p_storage: signal output of the gas pressure</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Apr 07 2015</p>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end GasStorage_varXi_L2;
