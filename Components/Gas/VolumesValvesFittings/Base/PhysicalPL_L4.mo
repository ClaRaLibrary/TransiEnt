within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
model PhysicalPL_L4 "Physical pressure loss model"

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

  extends TransiEnt.Components.Gas.VolumesValvesFittings.Base.PressureLoss_L4_extICom;

  import Modelica.Constants.pi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;
  import TransiEnt.Basics.Functions.findSetDifference;

  type TYP1 = Modelica.Fluid.Dissipation.Utilities.Types.Roughness;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer loopStart=if frictionAtInlet then 1 else 2 "First index of loop";
  final parameter Integer loopEnd=if frictionAtOutlet then iCom.N_cv + 1 else iCom.N_cv "Last index of loop";
  final parameter Integer[:] loopIdx=loopStart:loopEnd "All loop indices";
  final parameter Integer[:] notLoopIdx=if frictionAtInlet and frictionAtOutlet then fill(1, 0) elseif frictionAtInlet and not frictionAtOutlet then {iCom.N_cv + 1} elseif not frictionAtInlet and frictionAtOutlet then {1} else {1,iCom.N_cv + 1} "All indices that do not appear in the loop";

  final parameter Modelica.Units.SI.Length d_hyd=geo.diameter_hyd[1] "Hydraulic diameter";
  final parameter Real kD=k/d_hyd "Relative roughness";
  final parameter Modelica.Units.SI.Area A_cross=Modelica.Constants.pi*d_hyd^2/4 "Circular cross sectional area";
  final parameter Modelica.Units.SI.Length Li[geo.N_cv + 1]=if not frictionAtInlet and not frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]) elseif not frictionAtInlet and frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[1]) elseif frictionAtInlet and not frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[iCom.N_cv + 1]) else geo.Delta_x_FM "Length";

  final parameter Integer numberOfMFlowNoDist[:]=if numberOfMFlowDist[1]==0 then 1:iCom.N_cv+1 else findSetDifference(1:iCom.N_cv+1, numberOfMFlowDist) "numbers of mass flows which will be undisturbed";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Height k=simCenter.roughnessGasPipes "Absolute roughness" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real MIN=Modelica.Constants.eps "Limiter" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real factor=1 "Factor to modify pressure loss" annotation (Dialog(group="Fundamental Definitions"));
  parameter Modelica.Units.SI.PressureDifference dp_switch=1000 "Pressure difference at which function is linearized" annotation (Dialog(group="Fundamental Definitions"));
  parameter Modelica.Fluid.Dissipation.Utilities.Types.Roughness roughness=Modelica.Fluid.Dissipation.Utilities.Types.Roughness.Considered annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean useViscCorr=false "true if viscosity correlation shall be used, false for constant viscosity" annotation (Dialog(group="Viscosity"));
  parameter Real coeff_visc[iCom.mediumModel.nc-1+3]=if iCom.mediumModel.nc == 1 then {2.77160904091864e-06,1.37797594879264e-14,2.05004849130428e-08} elseif iCom.mediumModel.nc == 2 then {3.49826606827002e-07,1.04303247526047e-13,2.71567407127824e-08,2.80651000814681e-06} else {-1.43911039529083e-05,3.75699281723867e-13,1.96789492178842e-08,1.89714979419216e-05,2.93055875111180e-05,-1.78595469221118e-06,-1.29406293799004e-05,1.02682267821617e-05,4.15851977756051e-05} "Coefficients for viscosity calculation (1st for constant part, 2nd for pressure, 3rd for temperature, rest for n-1 composition entries (vector must have nine entries, no matter how many components the gas consists of; the remaining entries will be ignored))" annotation (Dialog(group="Viscosity", enable=useViscCorr));
  parameter Modelica.Units.SI.Temperature T_const=simCenter.T_ground "Constant temperature for viscosity calculation" annotation (Dialog(group="Viscosity", enable=useViscCorr));
  parameter Modelica.Units.SI.Pressure p_nom=iCom.p_nom "Nominal pressure for viscosity calculation" annotation (Dialog(group="Viscosity"));
  parameter Modelica.Units.SI.MassFraction xi_nom[iCom.mediumModel.nc - 1]=iCom.xi_nom "Nominal composition for viscosity calculation" annotation (Dialog(group="Viscosity"));
  parameter Modelica.Units.SI.DynamicViscosity eta_const=coeff_visc[1] + coeff_visc[2]*p_nom + coeff_visc[3]*T_const + sum({coeff_visc[3 + j]*xi_nom for j in 1:iCom.mediumModel.nc - 1}) "Constant dynamic viscosity" annotation (Dialog(group="Viscosity", enable=not useViscCorr));

  parameter Integer numberOfMFlowDist[:](min=0,max=iCom.N_cv+1)={0} "0 for no disturbance, otherwise give number (1...N_cv+1)" annotation(Dialog(group="Disturbance"));
  parameter Modelica.Units.SI.Time t_dist_start = 1e10 "Start time of disturbance" annotation(Dialog(group="Disturbance",enable=numberOfMFlowDist[1]<>0));
  parameter Modelica.Units.SI.Time t_dist_end = t_dist_start+1 "End time of disturbance" annotation(Dialog(group="Disturbance",enable=numberOfMFlowDist[1]<>0));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.Density rho[iCom.N_cv + 1] "Density";
  Modelica.Units.SI.DynamicViscosity eta[iCom.N_cv + 1] "Dynamic Viscosity";
  Modelica.Units.SI.MassFlowRate m_flow_1[iCom.N_cv + 1](stateSelect=StateSelect.avoid) "Mass flow rate in one tube";

  Modelica.Fluid.Dissipation.Utilities.Types.DarcyFrictionFactor lambda_FRI_calc_switch[iCom.N_cv + 1] "Adapted Darcy friction factor";
  SI.ReynoldsNumber Re_switch[iCom.N_cv + 1] "Reynolds number assuming turbulent regime";
  SI.MassFlowRate m_flow_switch[iCom.N_cv + 1];
  Modelica.Fluid.Dissipation.Utilities.Types.DarcyFrictionFactor lambda_FRI_calc[iCom.N_cv + 1] "Adapted Darcy friction factor";
  SI.ReynoldsNumber Re_turb[iCom.N_cv + 1] "Reynolds number assuming turbulent regime";
  SI.Velocity velocity[iCom.N_cv + 1] "Mean velocity";
  Real m_flow_rel_dist[iCom.N_cv + 1] "Relative mass flow due to the disturbance, 1 if no disturbance, 0 if disturbance";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation
  if useViscCorr then
    eta[1] = coeff_visc[1] + coeff_visc[2]*(iCom.p_in[1] + iCom.p[1])/2 + coeff_visc[3]*T_const + sum({coeff_visc[3 + j]*(iCom.xi_in_inflow[1, j] + iCom.xi[1, j])/2 for j in 1:iCom.mediumModel.nc-1});
    eta[2:geo.N_cv] = {coeff_visc[1] + coeff_visc[2]*(iCom.p[i - 1] + iCom.p[i])/2 + coeff_visc[3]*T_const + sum({coeff_visc[3 + j]*(iCom.xi[i - 1, j] + iCom.xi[i, j])/2 for j in 1:iCom.mediumModel.nc-1}) for i in 2:geo.N_cv};
    eta[geo.N_cv + 1] = coeff_visc[1] + coeff_visc[2]*(iCom.p[end] + iCom.p_out[1])/2 + coeff_visc[3]*T_const + sum({coeff_visc[3 + j]*(iCom.xi[end, j] + iCom.xi_out_inflow[1, j])/2 for j in 1:iCom.mediumModel.nc-1});
  else
    eta = ones(geo.N_cv+1)*eta_const;
  end if;

  assert(min(numberOfMFlowDist) == 0 and size(numberOfMFlowDist,1) == 1 or min(numberOfMFlowDist) > 0,"numberOfMFlowDist contains zero but does not have length 1 in " + getInstanceName(),AssertionLevel.error);
  assert(numberOfMFlowDist[1] == 0 or not
                                         (not frictionAtInlet and min(numberOfMFlowDist) == 1),"frictionAtInlet and min(numberOfMFlowDist) == 1 in " + getInstanceName() + " which means that no disturbance will happen",AssertionLevel.error);
  assert(numberOfMFlowDist[1] == 0 or not
                                         (not frictionAtOutlet and max(numberOfMFlowDist) == iCom.N_cv+1),"frictionAtOutlet and max(numberOfMFlowDist) == iCom.N_cv+1 in " + getInstanceName() + " which means that no disturbance will happen",AssertionLevel.error);
  if numberOfMFlowDist[1] == 0 then
    m_flow_rel_dist = ones(iCom.N_cv+1);
  else
    if time < t_dist_start or time > t_dist_end then
      m_flow_rel_dist = ones(iCom.N_cv+1);
    else
      m_flow_rel_dist[numberOfMFlowNoDist] = ones(size(numberOfMFlowNoDist,1));
      m_flow_rel_dist[numberOfMFlowDist] = zeros(size(numberOfMFlowDist,1));
    end if;
  end if;

  for i in loopIdx loop
    m_flow_1[i] = m_flow_rel_dist[i]*sign(factor)/sqrt(abs(factor))*(if noEvent(abs(Delta_p[i]) < dp_switch) then m_flow_switch[i]/dp_switch*Delta_p[i] else rho[i]*A_cross*velocity[i]);
    lambda_FRI_calc_switch[i] = 2*abs(dp_switch)*d_hyd^3*rho[i]/(Li[i]*eta[i]^2);
    Re_switch[i] = if roughness == TYP1.Neglected then (lambda_FRI_calc_switch[i]/0.3164)^(1/1.75) else -2*sqrt(max(MIN, lambda_FRI_calc_switch[i]))*Modelica.Math.log10(2.51/sqrt(max(MIN, lambda_FRI_calc_switch[i])) + kD/3.7);
    m_flow_switch[i] = A_cross*(Re_switch[i]*eta[i]/d_hyd);
    lambda_FRI_calc[i] = 2*abs(Delta_p[i])*d_hyd^3*rho[i]/(Li[i]*eta[i]^2);
    Re_turb[i] = if roughness == TYP1.Neglected then (lambda_FRI_calc[i]/0.3164)^(1/1.75) else -2*sqrt(max(MIN, lambda_FRI_calc[i]))*Modelica.Math.log10(2.51/sqrt(max(MIN, lambda_FRI_calc[i])) + kD/3.7);
    velocity[i] = noEvent(if Delta_p[i] >= 0 then Re_turb[i] else -Re_turb[i])*eta[i]/(rho[i]*d_hyd);
  end for;

  Delta_p[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  lambda_FRI_calc_switch[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  Re_switch[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  m_flow_switch[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  lambda_FRI_calc[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  Re_turb[notLoopIdx] = fill(0, size(notLoopIdx, 1));
  velocity[notLoopIdx] = fill(0, size(notLoopIdx, 1));

  rho[2:iCom.N_cv] = {density_phxi(
    (iCom.p[i - 1] + iCom.p[i])/2,
    (iCom.h[i - 1] + iCom.h[i])/2,
    (iCom.xi[i - 1, :] + iCom.xi[i, :])/2,
    iCom.fluidPointer[i - 1]) for i in 2:iCom.N_cv};
  rho[1] = density_phxi(
    (iCom.p_in[1] + iCom.p[1])/2,
    (iCom.h_in_inflow[1] + iCom.h[1])/2,
    (iCom.xi_in_inflow[1, :] + iCom.xi[1, :])/2,
    iCom.fluidPointer_in[1]);
  rho[iCom.N_cv + 1] = density_phxi(
    (iCom.p[end] + iCom.p_out[1])/2,
    (iCom.h[end] + iCom.h_out_inflow[1])/2,
    (iCom.xi[end, :] + iCom.xi_out_inflow[1, :])/2,
    iCom.fluidPointer_in[end]);

  m_flow = geo.N_tubes*m_flow_1;

  annotation (experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model is a physical pressure loss model, which can also model disturbances.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>The model considers the actual pressure loss of a one-phase fluid in a pipe in the turbulent regime. The calculation of the Darcy friction factor has been copied from Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW since it is numerically more efficient to integrate the equations directly in the model and it gives more insight.</p>
<p>Viscosity can be chosen to be constant or a correlation can be used. </p>
<p>Linearization can be used to achieve better numerical efficiency and stability.</p>
<p><span style=\"font-family: Courier New;\">numberOfMFlowNoDist</span> is used to apply disturbances at the indices of <span style=\"font-family: Courier New;\">m_flow</span>. From <span style=\"font-family: Courier New;\">t_dist_start</span> until <span style=\"font-family: Courier New;\">t_dist_end</span> the corresponding mass flow rates are set to zero.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity</span></b></p>
<p>This model is only valid in the turbulent regime. The linearization should be adjusted according to the application.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>The correlation for the viscosity is:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-3gmGOo3T.png\" alt=\"eta = coeff_visc[1]+ coeff_visc[2]*p+ coeff_visc[3]*T+ sum(coeff_visc[4:end]*xi)\"/> with T=T_const</p>
<p>The pressure loss can be calculated according to [1]:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_PhysicalPL1.png\"/></p>
<p>which can be transformed into </p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_PhysicalPL2.png\"/></p>
<p>which can be simplified to </p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_PhysicalPL3.png\"/></p>
<p>using the arithmetic mean of the density of inlet and outlet of each control volume. For the Reynolds number also the arithmetic mean of the viscosity is used.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>The default viscosity correlation coefficients for natural gas have been curve fitted for pressures of 1,10,20...100 bar, temperatures of 5,10,15 &deg;C for the compositions of natural gas &quot;Russland&quot;, &quot;Verbundgas&quot;, &quot;Nordsee I&quot; and &quot;Nordsee II&quot; from [1] p.51 and hydrogen shares of 0,10...100 mole-&percnt; with a goodness of fit of 0.8013. The usual viscosity changes in natural gas pipelines have no big impact on the pressure loss so a linear correlation should be sufficient. The same was done for methane-hydrogen mixtures.</p>
<p>For pure hydrogen, the default setting is that another correlation for pure hydrogen is used which was determinded for pressures of 1,10,20...100 bar and temperatures of 5,10,15 &deg;C with a goodness of fit of 0.9958.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>The model has been validated against the compressible pressure loss calculation.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] G. Cerbe, B. Lendt, K. Br&uuml;ggemann, M. Dehli, F. Gr&ouml;schl, K. Heikrodt, T. Kleiber, J. Kuck, J. Mischner, T. Schmidt, A. Seemann, and W. Thielen, Grundlagen der Gastechnik. Gasbeschaffung - Gasverteilung - Gasverwendung, 8th ed. M&uuml;nchen: Carl Hanser Verlag, 2017.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Sep 2019</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), Aug 2020 (viscosity correlation, more exact calculation, elimination of FluidDissipation function)</p>
<p>Modified by Robert Flesch (flesch@xrg-simulation.de), Sep 2020 (linearization, new iCom)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), Apr 2021 (added disturbance)</p>
</html>"));
end PhysicalPL_L4;
