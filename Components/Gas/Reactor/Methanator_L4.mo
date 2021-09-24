within TransiEnt.Components.Gas.Reactor;
model Methanator_L4 "Discretized pseudohomogeneous PFR model of a fixed-bed methanator"

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




  // all equations and values taken from Schlereth, D., Kinetic and Reactor Modeling for the Methanation of Carbon Dioxide, TU Muenchen, PhD thesis, 2015
  // mass and energy balances taken from Nandasana, A. D., Ray, A. K., & Gupta, S. K. (2003). Dynamic model of an industrial steam reformer and its use for multiobjective optimization. Industrial & engineering chemistry research, 42(17), 4028-4042.

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Gas.Reactor.Base.PartialFixedbedReactorIdealGas_L4(
    final medium=gas_sg4,
    final N_reac=1,
    N_cv = 5,
    eps_bed = 0.4,
    d_cat = 2350,
    cp_cat = 789.52,
    eps_cat = 0,
    dia_tube_i = 0.02,
    dia_part = 0.003,
    N_tube=
    if ScalingOfReactor==1 then m_flow_n_Methane/(2.17734e-4/0.155116*(9.7016e-48*p_nom[N_cv]^7-1.7481e-40*p_nom[N_cv]^6+1.3068e-33*p_nom[N_cv]^5-5.2559e-27*p_nom[N_cv]^4+1.2361e-20*p_nom[N_cv]^3-1.7407e-14*p_nom[N_cv]^2+1.4806e-8*p_nom[N_cv]+0.2984))
    elseif ScalingOfReactor==2 then m_flow_n_Hydrogen/(2.17734e-4)
    elseif ScalingOfReactor==3 then H_flow_n_Methane/(50.013e6*2.17734e-4/0.155116*(9.7016e-48*p_nom[N_cv]^7-1.7481e-40*p_nom[N_cv]^6+1.3068e-33*p_nom[N_cv]^5-5.2559e-27*p_nom[N_cv]^4+1.2361e-20*p_nom[N_cv]^3-1.7407e-14*p_nom[N_cv]^2+1.4806e-8*p_nom[N_cv]+0.2984))
    else H_flow_n_Hydrogen/(119.972e6*2.17734e-4),
    l = 6.94,
    final dH_R_i = {-165e3},
    final E_i = {77.5e3},
    Delta_p = 1.38e5,
    eff = fill({1},N_cv),
    final nu = [1, -1, 2],
    T_nom=503.15*ones(N_cv),
    p_nom=17e5*ones(N_cv),
    xi_nom=fill({0.296831,0.0304503,0.666944}, N_cv),
    T(
    start = 503.15*ones(N_cv)),
    p(
    start = 17e5*ones(N_cv)),
    xi(
    start =  fill({0.296831,0.0304503,0.666944}, N_cv)));

  import      Modelica.Units.SI;
  import Modelica.Constants.R "universal gas constant 8.413";
  import Modelica.Constants.pi;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant Real eps=1e-10;

  constant SI.Temperature T_ref=555 "reference Temperature for rate constants";

  final parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;

  //Parameters and coefficients for calculation of reaction rate
  final parameter Real Ak_i[1]={3.46e-1} "rate constant at reference Temperature"; //3.46e-4 --> 3.46e-1 change of unit from 1/g_cat to 1/kg_cat
  final parameter SI.Enthalpy dH_j[3]={22.4e3, -6.2e3, -10e3} "Adsorption enthalpy for OH, H2, mix";
  final parameter Real AK_j[3] = {0.5, 0.44, 0.88} "Pre-exponential factor for the calculation of the adsorption constant for OH, H2, mix";

  final parameter SI.CoefficientOfHeatTransfer alpha_out = 2000 "Heat transfer coefficient on the outside of the tube";

  //Geometry of reactor
  final parameter SI.Area A_tube_i=N_tube*pi*dia_tube_i*Delta_x "surface of control volume for heat transfer";

  //GCV+NCV
  final parameter SI.SpecificEnthalpy[gas_sg4.nc] NCV=TransiEnt.Basics.Functions.GasProperties.getIdealGasNCVVector(gas_sg4, gas_sg4.nc) "NCV of gas components";
  final parameter SI.SpecificEnthalpy[gas_sg4.nc] GCV=TransiEnt.Basics.Functions.GasProperties.getIdealGasGCVVector(gas_sg4, gas_sg4.nc) "GCV of gas component";

  final parameter SI.EnthalpyFlowRate H_flow_n_methanation_H2= if ScalingOfReactor==1 then m_flow_n_Methane*NCV[1]/0.83 elseif ScalingOfReactor==2 then m_flow_n_Hydrogen*NCV[4] elseif ScalingOfReactor==3 then H_flow_n_Methane/0.83 else H_flow_n_Hydrogen "Approximated nominal power of reactor based on NCV of hydrogen input";
  final parameter SI.EnthalpyFlowRate H_flow_n_methanation_CH4=H_flow_n_methanation_H2*0.83 "Approximated nominal power of reactor based on NCV of methane output";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated" annotation(Dialog(group="Statistics"));

  //properties of the catalyst and fixed-bed
  parameter SI.ThermalConductivity lambda_p=50 "Particle conductivity" annotation(Dialog(group="Catalyst"));

  parameter Integer ScalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined"
   annotation(Dialog(group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));

  parameter SI.MassFlowRate m_flow_n_Methane=0.2 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.2 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=1 "Nominal enthalpy flow rate of methane at the output based on NCV" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=1 "Nominal enthalpy flow rate of hydrogen at the input based on NCV" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 4 then true else false));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                      constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                             "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

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
      xi=gasBulk[N_cv].xi,
      x=gasBulk[N_cv].x,
      m_flow=-gasPortOut.m_flow,
      T=gasBulk[N_cv].T,
      p=gasPortOut.p,
      h=gasBulk[N_cv].h,
      rho=gasBulk[N_cv].d),
    gasBulk(
      mediumModel=medium,
      N_cv=N_cv,
      mass=gasBulk.d*Delta_x*A_c,
      T=gasBulk.T,
      p=gasBulk.p,
      h=gasBulk.h,
      xi=gasBulk.xi,
      x=gasBulk.x,
      rho=gasBulk.d),
    outline(
      N_cv=N_cv,
      Q_flow=heat.Q_flow,
      T_flueGas=heat.T,
      H_flow_n_methanation_CH4=H_flow_n_methanation_CH4,
      H_flow_n_methanation_H2=H_flow_n_methanation_H2,
      eta_NCV=eta_NCV,
      H_flow_in_NCV=H_flow_in_NCV,
      H_flow_out_NCV=H_flow_out_NCV,
      eta_GCV=eta_GCV,
      H_flow_in_GCV=H_flow_in_GCV,
      H_flow_out_GCV=H_flow_out_GCV,
      eta_GCV_woWater=eta_GCV_woWater,
      H_flow_out_GCV_woWater=H_flow_out_GCV_woWater),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues))
         annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=if ScalingOfReactor== 1 then m_flow_n_Methane*50.013e6 elseif ScalingOfReactor==2 then m_flow_n_Hydrogen*119.972e6*0.83 elseif ScalingOfReactor==3 then H_flow_n_Methane else H_flow_n_Hydrogen*0.83,
    redeclare model CostRecordGeneral = CostSpecsGeneral,
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
protected
  SI.Efficiency eta_NCV "overall efficiency of reactor based on NCV";
  SI.Power H_flow_in_NCV "inflowing enthalpy flow based on NCV";
  SI.Power H_flow_out_NCV "outflowing enthalpy flow based on NCV";
  SI.Efficiency eta_GCV "overall efficiency of reactor based on GCV";
  SI.Power H_flow_in_GCV "inflowing enthalpy flow based on GCV";
  SI.Power H_flow_out_GCV "outflowing enthalpy flow based on GCV";
  SI.Efficiency eta_GCV_woWater "overall efficiency of reactor based on GCV without water";
  SI.Power H_flow_out_GCV_woWater "outflowing enthalpy flow based on GCV without water";
  Real xi_in[4];
  Real xi_out[4];

  Real K_j[N_cv,3] "adsorption constant. (K_OH, K_H2, K_mix)";

  //Partial pressures of components in gasBulk
  Modelica.Units.NonSI.Pressure_bar p_H2[N_cv] "Partial Pressure H2";
  Modelica.Units.NonSI.Pressure_bar p_CO2[N_cv] "Partial Pressure CO2";
  Modelica.Units.NonSI.Pressure_bar p_CH4[N_cv] "Partial Pressure CH4";
  Modelica.Units.NonSI.Pressure_bar p_H2O[N_cv] "Partial Pressure H2O";

  SI.CoefficientOfHeatTransfer U_A[N_cv] "Heat transfer coefficient through the tube wall";
  SI.CoefficientOfHeatTransfer alpha_eff[N_cv] "Effective heat transfer coefficient inside the tube including heat transfer through the catalyst bed";
  SI.CoefficientOfHeatTransfer alpha_w[N_cv] "Heat transfer coefficient at the inner tube wall";
  Real lambda_r_eff[N_cv] "Effective radial dispersion coefficient [m^2 s^-1]";
  Real k_bed[N_cv] "Dimensionless bed conductivity (lambda_bed/lambda_fluid)";
  Real k_c[N_cv] "Dimensionless core conductivity";
  Real k_p[N_cv] "Dimensionless particle conductivity";
  Real N[N_cv] "Dimensionless factor in the model for the dimensionless core conductivity";
  Real B "Deformation parameter";
  Real Pe[N_cv] "Peclet number";
  SI.Velocity u_0[N_cv] "Fluid velocity for an empty tube";
  Real Re[N_cv] "Reynolds number";
  Real Nu_w[N_cv] "Nusselt number for the heat transfer at the inner tube wall";

  model Outline
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
    input SI.Power H_flow_n_methanation_H2 "approximated nominal power of reactor based on NCV of hydrogen input";
    input SI.Power H_flow_n_methanation_CH4 "approximated nominal power of reactor based on NCV of methane output";
    input SI.Efficiency eta_NCV "overall efficiency of reactor based on NCV";
    input SI.Power H_flow_in_NCV "inflowing enthalpy flow based on NCV";
    input SI.Power H_flow_out_NCV "outflowing enthalpy flow based on NCV";
    input SI.Efficiency eta_GCV "overall efficiency of reactor based on GCV";
    input SI.Power H_flow_in_GCV "inflowing enthalpy flow based on GCV";
    input SI.Power H_flow_out_GCV "outflowing enthalpy flow based on GCV";
    input SI.Efficiency eta_GCV_woWater "overall efficiency of reactor based on GCV without water";
    input SI.Power H_flow_out_GCV_woWater "outflowing enthalpy flow based on GCV without water";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortOut;
    TransiEnt.Basics.Records.IdealGasBulk_L4 gasBulk;
    Outline outline;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  for n in 1:N_cv loop

    k_i[n,1]=Ak_i * exp((E_i/R)*(1/T_ref - 1/T[n]));

    //calculating adsorption constant for OH, H2, mix
    for j in 1:3 loop
      K_j[n,j] = AK_j[j] * exp(dH_j[j]/R*(1/T_ref - 1/T[n]));
    end for;

    //calculating equilibrium constant
    K_i[n,1]=137*T[n]^(-3.998)*exp(158.7e3/(R*T[n]));

    //calculating partial pressures
    p_CH4[n]=Modelica.Units.Conversions.to_bar(gasBulk[n].p_i[1]);
    p_CO2[n]=max(eps, Modelica.Units.Conversions.to_bar(gasBulk[n].p_i[2]));
    p_H2O[n]=Modelica.Units.Conversions.to_bar(gasBulk[n].p_i[3]);
    p_H2[n]=max(eps, Modelica.Units.Conversions.to_bar(gasBulk[n].p_i[4]));

    //calculating reaction rate
    RR[n,1] = (k_i[n,1] * (p_H2[n]^0.5)*(p_CO2[n]^0.5)*(1-(p_CH4[n]*p_H2O[n]^2)/(p_H2[n]^4*p_CO2[n]*K_i[n,1])))/(1 + K_j[n,1]*p_H2O[n]/p_H2[n]^0.5 + K_j[n,2]*p_H2[n]^0.5 + K_j[n,3]*p_CO2[n]^0.5)^2;

    //Heat transfer
    heat[n].Q_flow = U_A[n] * A_tube_i * (heat[n].T - T[n]);
    U_A[n] = (1/alpha_eff[n] + 1/alpha_out)^(-1);
    1/alpha_eff[n] = 1/alpha_w[n] + dia_tube_i/(8*lambda_r_eff[n]);
    lambda_r_eff[n]/gasBulk[n].transp.lambda = k_bed[n] + Pe[n]/8;
    k_bed[n] = 1-sqrt(1-eps_bed)+sqrt(1-eps_bed)*k_c[n];
    k_c[n] = 2/N[n]*(B/N[n]^2*(k_p[n]-1)/k_p[n]*log(max(eps,k_p[n]/B))-(B+1)/2-(B-1)/N[n]);
    k_p[n] = lambda_p/gasBulk[n].transp.lambda;
    N[n] = 1-B/k_p[n];
    Pe[n] = u_0[n]*gasBulk[n].d*gasBulk[n].cp*dia_part/gasBulk[n].transp.lambda;
    u_0[n] = m_flow/(gasBulk[n].d*A_c);
    Re[n] = u_0[n]*gasBulk[n].d*dia_part/gasBulk[n].transp.eta;
    Nu_w[n] = alpha_w[n]*dia_part/gasBulk[n].transp.lambda;
    Nu_w[n] = (1.3+5/(dia_tube_i/dia_part))*k_bed[n]+0.19*max(eps,Re[n])^0.75*max(eps,gasBulk[n].transp.Pr)^0.33;

  end for;

  B = 1.25*((1-eps_bed)/eps_bed)^(10/9);
  xi_out=cat(1,xi[N_cv,:],{1-sum(xi[N_cv,:])});
  xi_in=cat(1,gasIn.xi,{1-sum(gasIn.xi)});

  H_flow_in_NCV=gasPortIn.m_flow*sum(NCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_NCV=gasPortOut.m_flow*sum(NCV*cat(1,xi[N_cv,:],{1-sum(xi[N_cv,:])}));
  eta_NCV=-H_flow_out_NCV/(max(0.001,H_flow_in_NCV));

  H_flow_in_GCV=gasPortIn.m_flow*sum(GCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_GCV=gasPortOut.m_flow*sum(GCV*cat(1,xi[N_cv,:],{1-sum(xi[N_cv,:])}));
  eta_GCV=-H_flow_out_GCV/(max(0.001,H_flow_in_GCV));

  H_flow_out_GCV_woWater=gasPortOut.m_flow*sum({GCV[1],GCV[2],0,GCV[4]}*cat(1,xi[N_cv,:],{1-sum(xi[N_cv,:])}));
  eta_GCV_woWater=-H_flow_out_GCV_woWater/(max(0.001,H_flow_in_GCV));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts.costsCollector, modelStatistics.costsCollector);

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          textString="Methanator")}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a discretized fixed bed methanator with reaction kinetics with constant effectiveness factors. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The reactor is discretized and in each volume mass, impulse and energy balances as well as heat transfer between tube wall and synthesis gas in the tubes and reaction rate equations are solved. These equations are taken from Schlereth [1] except that the pressure loss is assumed to be constant and the effective reaction rates are calculated using constant effectiveness factors. Also the mass balances are stationary so changes in density are neglected. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The model is valid if the changes of the effectiveness factors and the pressure loss are negligible. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: ideal gas inlet </p>
<p>gasPortOut: ideal gas outlet </p>
<p>heat: heat port </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The used equations are described in [1] except for the changes described in 2. The pressure calculation for each volume can be done either using the pressure in the middle or at the end of the volume. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The nominal value for the reactor&apos;s power can either be defines by the nominal mass flows or the respective nominal enthalpy flows of the mass flows. The scaling factors are always adjusted for an input of H2 and CH4 with a molar ratio of 4:1. Therefore the parameter &QUOT;ScalingOfReactor&QUOT; needs to and the corresponding nominal value needs to be set. Consider that scaling by the nominal mass flow of methane may leed to inaccuracies since the product of the reactor depends on the operating temperature and pressure.</p>
<p>ScalingOfReactor=1: The reactor is scaled by the nominal methane mass flow m_flow_Methane.</p>
<p>ScalingOfReactor=2: The reactor is scaled by the nominal hydrogen mass flow m_flow_Hydrogen.</p>
<p>ScalingOfReactor=3: The reactor is scaled by the nominal enthalpy flow of methane (H_flow_methane) defined by the product of methane mass flow and NCV of methane.</p>
<p>ScalingOfReactor=4: The reactor is scaled by the nominal enthalpy flow of hydrogen (H_flow_hydrogen) defined by the product of hydrogen mass flow and NCV of hydrogen.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>The results of the model were compared to results from Schlereth (Figure 6.10) [1] and the outlet variables fit the results very well. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] David, Schlereth (2015): Kinetic and Reactor Modeling for the Methanation of Carbon Dioxide. Ph. D. Thesis. Technische Universitaet Muenchen, Muenchen. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tom Lindemann (tom.lindemann@tuhh.de) in Mar 2016</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p><br>Model modified by Carsten Bode (c.bode@tuhh.de) in Jul 2016</p>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) in Feb 2018</p>
</html>"));
end Methanator_L4;
