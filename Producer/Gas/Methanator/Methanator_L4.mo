within TransiEnt.Producer.Gas.Methanator;
model Methanator_L4 "Discretized pseudohomogeneous PFR model of a fixed-bed methanator"
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

  // all equations and values taken from Schlereth, D., Kinetic and Reactor Modeling for the Methanation of Carbon Dioxide, TU Muenchen, PhD thesis, 2015
  // mass and energy balances taken from Nandasana, A. D., Ray, A. K., & Gupta, S. K. (2003). Dynamic model of an industrial steam reformer and its use for multiobjective optimization. Industrial & engineering chemistry research, 42(17), 4028-4042.

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Gas.Reactor.Base.PartialFixedbedReactorIdealGas_L4(
    final medium=gas_sg4,
    final N_reac=1,
    N_cv = 3,
    eps_bed = 0.4,
    d_cat = 2350,
    cp_cat = 850,
    eps_cat = 0,
    dia_tube_i = 0.02,
    dia_part = 3e-3,
    N_tube = 1,
    l = 5,
    final dH_R_i = {-165e3},
    final E_i = {77.5e3},
    Delta_p = 0,
    eff = fill({1},N_cv),
    final nu = [1, -1, 2],
    T_nom=603.15*ones(N_cv),
    p_nom=6e6*ones(N_cv),
    xi_nom=fill({0.296831,0.0304503,0.666944}, N_cv),
    T_start=603.15*ones(N_cv),
    p_start=6e6*ones(N_cv),
    xi_start=fill({0.296831,0.0304503,0.666944}, N_cv));

  import SI = Modelica.SIunits;
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

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  //properties of the catalyst and fixed-bed
  parameter SI.ThermalConductivity lambda_p=30 "|properties of the catalyst and fixed-bed|Particle conductivity";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

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
    heat(
      N_cv=N_cv,
      Q_flow=heat.Q_flow,
      T_flueGas=heat.T))
         annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real K_j[N_cv,3] "adsorption constant. (K_OH, K_H2, K_mix)";

  //Partial pressures of components in gasBulk
  SI.Conversions.NonSIunits.Pressure_bar p_H2[N_cv] "Partial Pressure H2";
  SI.Conversions.NonSIunits.Pressure_bar p_CO2[N_cv] "Partial Pressure CO2";
  SI.Conversions.NonSIunits.Pressure_bar p_CH4[N_cv] "Partial Pressure CH4";
  SI.Conversions.NonSIunits.Pressure_bar p_H2O[N_cv] "Partial Pressure H2O";

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

  model Heat
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
  end Heat;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortOut;
    TransiEnt.Basics.Records.IdealGasBulk_L4 gasBulk;
    Heat heat;
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
    p_CH4[n]=SI.Conversions.to_bar(gasBulk[n].p_i[1]);
    p_CO2[n]=max(eps, SI.Conversions.to_bar(gasBulk[n].p_i[2]));
    p_H2O[n]=SI.Conversions.to_bar(gasBulk[n].p_i[3]);
    p_H2[n]=max(eps, SI.Conversions.to_bar(gasBulk[n].p_i[4]));

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

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
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
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>The results of the model were compared to results from Schlereth [1] and the outlet variables fit the results very well. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] David, Schlereth (2015): Kinetic and Reactor Modeling for the Methanation of Carbon Dioxide. Ph. D. Thesis. Technische Universitaet Muenchen, Muenchen. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tom Lindemann (tom.lindemann@tuhh.de) in Mar 2016</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p><br>Model modified by Carsten Bode (c.bode@tuhh.de) in Jul 2016</p>
</html>"));
end Methanator_L4;
