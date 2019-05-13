within TransiEnt.Producer.Electrical.Conventional;
model Gasturbine_with_Gasport
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant(
                                                                                isSecondaryControlActive=true,
    P_min_star=simCenter.generationPark.P_min_star_GT,
    P_grad_max_star=simCenter.generationPark.P_grad_max_star_GT,
    H =  simCenter.generationPark.H_gen_GT,
    eta_total=simCenter.generationPark.eta_el_n_GT,
    t_startup=120,
    m_flow_CDE=m_flow_CDE_calculatedByInput,
    P_el_n= simCenter.generationPark.P_el_n_GT,
    isPrimaryControlActive=true,
    final typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional,
    final typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasTurbine);


  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit;
  extends TransiEnt.Producer.Electrical.Base.PartialCDEUnit(m_flow_gas_CDE_deposited_gasPort=m_flow_gas_CDE_deposited);
  extends TransiEnt.Basics.Icons.GasTurbine;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Boolean useConstantHoC = false "if ticked, a constant heat of combustion for the fuel can be defined" annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Fuel properties"));
  parameter Modelica.SIunits.SpecificEnthalpy HoC_gas=40e6 "heat of combustion of natural gas"  annotation(Dialog(enable = if useConstantHoC== false then false else true,group="Fuel properties"));
  parameter Boolean useLeakageMassFlow=false "Constant leakage gas mass flow of 'm_flow_small' to avoid zero mass flow"  annotation(Dialog(group="Numerical Stability"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small=simCenter.m_flow_small "leakage mass flow if useLeakageMassFlow=true" annotation(Dialog(group="Numerical Stability",enable=useLeackageMassFlow));
  // _____________________________________________
  //
  //                Variables
  // _____________________________________________

  Modelica.SIunits.MassFlowRate m_flow_CDE_calculatedByInput;
  Modelica.SIunits.MassFlowRate m_flow_small_intern;
protected
  Modelica.SIunits.MolarFlowRate[5] ElementCompositionFuel;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateOut enthalpyFlowRateOut "enthalpy flow of fuel" annotation (Placement(transformation(extent={{100,-100},{140,-60}}), iconTransformation(extent={{100,-100},{140,-60}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  ElementCompositionFuel=TransiEnt.Basics.Functions.GasProperties.comps2Elements_realGas(
    vleNCVSensor.medium,
    vleNCVSensor.xi,
    gasPortIn.m_flow);
  m_flow_CDE_calculatedByInput=ElementCompositionFuel[1]*44.0095/1000-m_flow_gas_CDE_deposited;

  if useLeakageMassFlow==true then
    m_flow_small_intern=m_flow_small;
  else
    m_flow_small_intern=0;
  end if;

  // === energy balance ===
  if epp.P>=0 then
    m_flow_gas=m_flow_small_intern;
    enthalpyFlowRateOut=0;
  elseif useConstantHoC==true then
    m_flow_gas * HoC_gas * eta = -epp.P + m_flow_small_intern * HoC_gas * eta;
    enthalpyFlowRateOut=-epp.P/HoC_gas;
  else
    m_flow_gas *vleNCVSensor.NCV  * eta = -epp.P + m_flow_small_intern * vleNCVSensor.NCV * eta;
    enthalpyFlowRateOut=m_flow_gas/vleNCVSensor.NCV;
  end if;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________





annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-44,-82},{16,-22}},
          textString="NLTI")}),  Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Combined Cycle Gas turbine model with startup time and setpoint limits. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Preconfigured combined cycle gas plant model with gas port.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for electric power in [W] (setpoint for electric power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for electric power in [W] (secondary balancing setpoint)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port (choice of power port)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortIn: inlet for real gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortOut_CDE: outlet port for CDE. only active if &apos;useCDEPort=true&apos;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Nov 2018</span></p>
</html>"));
end Gasturbine_with_Gasport;
