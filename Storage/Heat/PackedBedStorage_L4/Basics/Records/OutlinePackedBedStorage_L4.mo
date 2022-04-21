within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records;
model OutlinePackedBedStorage_L4



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

  extends ClaRa.Basics.Icons.RecordIcon;

  import SI = ClaRa.Basics.Units;


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

    parameter Integer N_cv = 10 "|Discretisation|Number of finite volumes";

    input SI.Temperature T_bed[N_cv] "Packed-bed temperature";
    input SI.Temperature T_air_hot "Hot air temperature";
    input SI.Temperature T_air_cold "Cold air temperature";
    input SI.Temperature T_air_bed_hot "Temperatur at packed bed inlet, hot side";
    input SI.Temperature T_air_bed_cold "Temperatur at packed bed inlet, cold side";
    input SI.Temperature T_start_bed[N_cv] "Packed-bed initial temperatures";
    input SI.Temperature T_c "Nominal charge temperature";
    input SI.Temperature T_d "Nominal discharge temperature";
    input SI.Temperature T_stop_c "Stop Temperature Charge (for calculation of UCR)";
    input SI.Temperature T_stop_d "Stop Temperature Discharge (for calculation of UCR)";
    input SI.Temperature T_ref "Reference temperature";
    input SI.Power E_flow "Enthalpy flux difference of storage";
    input SI.Power E_flow_nom "nominal enthalpy flux difference";
    input SI.Power Ex_flow "Exergy part of enthalpy flux difference of storage";
    input SI.Power P_isentropicCompression "Power to compensate pressure loss in packed bed by isentropic compression";
    input SI.Pressure Delta_p_hot "Pressure loss across hot side air volume";
    input SI.Pressure Delta_p_cold "Pressure loss across cold side air volume";
    input SI.Pressure Delta_p_bed "Pressure loss across packed bed";
    input SI.HeatFlowRate Q_flow_loss_Iso_bed "Transmission heat loss through thermal insulation around packed bed";
    input SI.HeatFlowRate Q_flow_loss_Iso_hot "Transmission heat loss through thermal insulation around hot air side";
    input SI.HeatFlowRate Q_flow_loss_Iso_cold "Transmission heat loss through thermal insulation around cold air side";
    input SI.HeatFlowRate Q_flow_loss_PB2hotAir "Heat loss through packed bed inlet at hot side";
    input SI.HeatFlowRate Q_flow_loss_PB2coldAir "Heat loss through packed bed inlet at cold side";
    input SI.Volume volume_rock[N_cv] "Rock volume in each control volume" annotation(HideResult = true);
    parameter SI.Volume volume_tot "Total packed bed volume";
    input SI.DensityVolumeSpecific d[N_cv] "Rock density in each control volume" annotation(HideResult = true);
    input SI.Length x_abs[N_cv] "Center position of each finite control volume";
    parameter SI.Length length "Length of packed bed";
    input Real Re[N_cv+1] "Reynolds number in packed bed";
    input SI.ThermalConductivity lambda_eff_ax[N_cv] "Effective thermal conductivity of packed bed";
    input SI.CoefficientOfHeatTransfer alpha_PB2Wall[N_cv] "Heat transfer coefficient packed bed 2 wall";
    input SI.CoefficientOfHeatTransfer alpha_PB2Air_hot "Heat transfer coefficient packed bed 2 air hot side";
    input SI.CoefficientOfHeatTransfer alpha_PB2Air_cold "Heat transfer coefficient packed bed 2 air cold side";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
    outer ClaRa.SimCenter simCenter;



  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

      replaceable model medium_rock = TransiEnt.Basics.Media.Solids.Basalt       constrainedby TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity
                                                         "Rock Medium"           annotation (choicesAllMatching, Dialog(group="Medium Definition"));


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.Energy U_start "Internal energy at start" annotation(HideResult = true);
  SI.Energy Ex_start "Exergy part of internal energy at start" annotation(HideResult = true);
  SI.Energy U_stored "Currently stored internal energy" annotation(HideResult = true);
  SI.Energy Ex_stored "Currently stored exergy part of internal energy" annotation(HideResult = true);
  SI.Energy U_theo "Nominal/theoretical thermal storage capacity";
  SI.Power Q_flow_loss_Iso_tot "Total Heat Loss of Storage Through Insulation";
  SI.Pressure Delta_p_tot "Total Pressure Loss of Storage";

protected
  Boolean reachStopTemp_c "Indicator for full storage" annotation (Dialog(group="Variables"));
  Boolean reachStopTemp_d "Indicator for empty storage" annotation (Dialog(group="Variables"));
  Integer counter_ReachStopTemp_c(final  start=0,fixed=true) "counter";
  Integer counter_ReachStopTemp_d(final  start=0,fixed=true) "counter";

public
  SI.Energy E_to_storage(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_from_storage(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy Ex_to_storage(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy Ex_from_storage(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy W_isentropicCompression(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy Q_loss_Iso_tot(final start = 0,fixed = true, stateSelect=StateSelect.never);

  Real SOC "State of charge";
  SI.Mass m_rock_tot "total storage material mass";
  SI.EnthalpyVolumeSpecific energyDensity "volumetric energy density of storage";
  Real DoC(start=1, fixed = true) "current depth of charge (changes when charge stop criterium is violated)";
  Real DoD(start=0, fixed = true) "current depth of discharge (changes when discharge stop criterium is violated)";
  Real UCR "Usable capacity ratio";
  Real DoC_mean(start=1, fixed = true) "mean depth of charge when reaching Charging Temperature stopping criteria";
  Real DoD_mean(start=0, fixed = true) "mean depth of discharge when reaching Discharging Temperature stopping criteria";
  Real UCR_mean "Mean usable capacity ratio in observation time period";
  Real equivalentFullCycles "number of equivalent full cycles";
  Real load "load of storage, relataive to the nominal load";
  Real relHeatLoss "relative transmission heat loss of storage unit";
  Real relExergyLoss "relative exergy loss of storage unit";
  Real relIsentropicCompressionWork "relative isentropic compression work to compensate pressure loss in storage";
  Real storedEnergyDeviation "difference in stored energy in storage unit over observation period";
  Real storedExergyDeviation "difference in stored exergy in storage unit over observation period";

  SI.Energy E_check "energy residuum to verify energy balance";

protected
  TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock_T_ref(redeclare model SolidType = medium_rock, T=T_ref) annotation (Placement(transformation(extent={{-56,-44},{-36,-24}})));
  TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock_T_c(redeclare model SolidType = medium_rock, T=T_c) annotation (Placement(transformation(extent={{-84,-44},{-64,-24}})));
  TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock_T_d(redeclare model SolidType = medium_rock, T=T_d) annotation (Placement(transformation(extent={{-28,-44},{-8,-24}})));
  TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock_T_start[N_cv](redeclare each model SolidType = medium_rock, T=T_start_bed) annotation (Placement(transformation(extent={{6,-46},{26,-26}})));
  TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock_T[N_cv](redeclare each model SolidType = medium_rock, T=T_bed) annotation (Placement(transformation(extent={{40,-44},{60,-24}})));


  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________

algorithm

  when edge(reachStopTemp_c) then

    if noEvent(E_flow < 0) then
  counter_ReachStopTemp_c := counter_ReachStopTemp_c +1;

  DoC := SOC;
  DoC_mean := if counter_ReachStopTemp_c == 1 then SOC else (DoC_mean + SOC/(counter_ReachStopTemp_c-1))/(counter_ReachStopTemp_c/(counter_ReachStopTemp_c-1));
    end if;
  end when;

  when edge(reachStopTemp_d) then
    if noEvent(E_flow > 0) then
  counter_ReachStopTemp_d := counter_ReachStopTemp_d +1;

  DoD := SOC;
  DoD_mean := if counter_ReachStopTemp_d == 1 then SOC else (DoD_mean + SOC/(counter_ReachStopTemp_d-1))/(counter_ReachStopTemp_d/(counter_ReachStopTemp_d-1));

  end if;
  end when;

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  reachStopTemp_c = T_bed[N_cv] > T_stop_c;
  reachStopTemp_d = T_bed[1] < T_stop_d;

  load = E_flow/E_flow_nom;

  U_start =sum(volume_rock .* d .* (rock_T_start.specificInternalEnergy .- rock_T_ref.specificInternalEnergy));
  U_stored =sum(volume_rock .* d .* (rock_T.specificInternalEnergy .- rock_T_ref.specificInternalEnergy));
  Ex_start = U_start - simCenter.T_amb_start*sum(volume_rock .* d .* (rock_T_start.specificEntropy .- rock_T_ref.specificEntropy));
  Ex_stored = U_stored - simCenter.T_amb*sum(volume_rock .* d .* (rock_T.specificEntropy .- rock_T_ref.specificEntropy));
  U_theo =sum(volume_rock .* d .* (rock_T_c.specificInternalEnergy .- rock_T_ref.specificInternalEnergy));

  Q_flow_loss_Iso_tot = Q_flow_loss_Iso_bed + Q_flow_loss_Iso_hot + Q_flow_loss_Iso_cold;
  Delta_p_tot = Delta_p_bed+Delta_p_hot+Delta_p_cold;

  //Integration
  der(Q_loss_Iso_tot) = Q_flow_loss_Iso_tot;
  der(E_to_storage) = noEvent(if E_flow<0 then -E_flow else 0);
  der(E_from_storage) = noEvent(if E_flow>0 then E_flow else 0);
  der(Ex_to_storage) = noEvent(if Ex_flow<0 then -Ex_flow else 0);
  der(Ex_from_storage) = noEvent(if Ex_flow>0 then Ex_flow else 0);
  der(W_isentropicCompression) = P_isentropicCompression;

  // KPI
  SOC = U_stored/U_theo;
  m_rock_tot = sum(volume_rock.*d);
  energyDensity = U_theo/volume_tot;
  UCR = DoC-DoD;
  UCR_mean = DoC_mean-DoD_mean;

  // Used for comparison to other models
  equivalentFullCycles = E_to_storage/U_theo;
  relExergyLoss = min(1,max(0,(Ex_to_storage -(Ex_stored-Ex_start)- Ex_from_storage)/max(1,(Ex_to_storage))));
  relHeatLoss = min(1,max(0,(E_to_storage-(U_stored-U_start)- E_from_storage)/max(1,(E_to_storage))));
  relIsentropicCompressionWork = min(1,max(0,W_isentropicCompression/max(1,(E_to_storage))));

  storedEnergyDeviation = min(1,max(0,(U_stored-U_start)/max(1,(E_to_storage))));
  storedExergyDeviation = min(1,max(0,(Ex_stored-Ex_start)/max(1,(Ex_to_storage))));

  // Verification of energy balance
  E_check = E_to_storage-(U_stored-U_start)- E_from_storage - Q_loss_Iso_tot;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Outline of packed-bed thermal energy storage model. Includes the integration of power variables for energy-based analysis.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end OutlinePackedBedStorage_L4;
