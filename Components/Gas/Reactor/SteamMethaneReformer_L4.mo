within TransiEnt.Components.Gas.Reactor;
model SteamMethaneReformer_L4 "Discretized pseudohomogeneous PFR model of a fixed-bed steam methane reformer"

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

  // all values and formulas (except otherwise stated) are taken from Nandasana, A. D., Ray, A. K., & Gupta, S. K. (2003). Dynamic model of an industrial steam reformer and its use for multiobjective optimization. Industrial & engineering chemistry research, 42(17), 4028-4042.
  // Xu, Froment 1989 Part II: Xu, J., & Froment, G. F. (1989). Methane steam reforming: II. Diffusional limitations and reactor simulation. AIChE Journal, 35(1), 97-103.
  // Pantoleontos 2012: Pantoleontos, G., Kikkinides, E. S., & Georgiadis, M. C. (2012). A heterogeneous dynamic model for the simulation and optimisation of the steam methane reforming reactor. international journal of hydrogen energy, 37(21), 16346-16358.

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialFixedbedReactorIdealGas_L4(
    final medium=gas_sg6,
    final N_reac=3,
    N_cv=1,
    eps_bed=0.605,
    d_cat=2396.965,
    d_bed=946.8,
    cp_cat=949.72,
    eps_cat=0.51963,
    dia_tube_i=0.0795,
    dia_part=0.0174131,
    N_tube=176,
    l=11.95,
    final dH_R_i={206100,-41150,164900},
    final E_i={240100,67130,243900},
    Delta_p=2.3e5,
    eff=fill({0.019,0.015,0.021}, N_cv),
    final nu=[-1,0,-1,3,1; 0,1,-1,1,-1; -1,1,-2,4,0],
    T_start=(820.574 + 273.15)*ones(N_cv),
    p_start=24.338e5*ones(N_cv),
    xi_start=fill({0.0319,0.1893,0.6089,0.0575,0.1073}, N_cv),
    T_nom=(820.574 + 273.15)*ones(N_cv),
    p_nom=24.338e5*ones(N_cv),
    xi_nom=fill({0.0319,0.1893,0.6089,0.0575,0.1073}, N_cv));
    // effectiveness factors taken from Xu, Froment 1989 Part II (roughly same values as Pantoleontos 2012)

  import TransiEnt;
  import Modelica.Constants.R;
  import Modelica.Constants.pi;
  import Modelica.Constants.sigma;
  import Modelica.Constants.eps;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var gas_sg6 "Medium used in the steam methane reformer";

  final parameter SI.Area A_tube_o = N_tube*pi*dia_tube_o*l "Outer surface of all tubes";

  final parameter Real AK_j[4] = {6.65e-4, 8.23e-5, 6.12e-9, 1.77e5} "Pre-exponential factors for adsorption energies {CH4, CO, H2, H2O}";
  final parameter SI.MolarEnthalpy dH_j[4] = {-38280, -70650, -82900, 88680} "Adsorption enthalpies for components j {CH4, CO, H2, H2O}";
  final parameter Real Ak_i[N_reac] = 1/3.6*{4.225e15, 1.955e6, 1.02e15} "Pre-exponential factors for activation energies"; // 1/3.6 for unit conversion from kmol/h to mol/s
  final parameter Real AK_i[N_reac] = {4.707e12, 1.142e-2, 5.375e10} "Pre-exponential factors for enthalpy changes of reactions";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Diameter dia_tube_o = 0.1020 "Outer tube diameter" annotation(Dialog(group="Geometry"));
  parameter SI.Area A_refractor = 1164*N_tube/176 "Surface area of refractor" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Area A_flame = 0.01 "Surface area of a flame of one burner" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Emissivity em_gas = 0.1 "Emissivity of furnace gas" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Emissivity em_flame = 0.1 "Emissivity of flames" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Emissivity em_tube = 0.95 "Emissivity of reformer tubes" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_adi = 2200 "Adiabatic flame temperature" annotation(Dialog(group="Heat Transfer"));
  parameter Real N_burner = 112*N_tube/176 "Number of burners" annotation(Dialog(group="Heat Transfer"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
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
      T_flueGas=heat.T,
      T_wall_o=T_wall_o,
      T_wall_i=T_wall_i))
         annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Heat
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
    input SI.Temperature T_wall_o[N_cv] "Outer wall temperature";
    input SI.Temperature T_wall_i[N_cv] "Inner wall temperature";
  end Heat;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeIdealGas gasPortOut;
    TransiEnt.Basics.Records.IdealGasBulk_L4 gasBulk;
    Heat heat;
  end Summary;

  Real DEN[N_cv] "Denominator for reaction rates";

  Real K_j[N_cv,4] "Adsorption constant of components j {CH4, CO, H2, H2O}";

  SI.CoefficientOfHeatTransfer U[N_cv] "Heat transfer coefficient from gas and bed to the outer reactor wall";
  SI.ThermalConductivity lambda_wall[N_cv] "Thermal conductivity of tube wall material";

  SI.Conversions.NonSIunits.Pressure_bar p_CH4[N_cv] "Partial pressure CH4";
  SI.Conversions.NonSIunits.Pressure_bar p_CO2[N_cv] "Partial pressure CO2";
  SI.Conversions.NonSIunits.Pressure_bar p_H2O[N_cv] "Partial pressure H2O";
  SI.Conversions.NonSIunits.Pressure_bar p_H2[N_cv] "Partial pressure H2";
  SI.Conversions.NonSIunits.Pressure_bar p_CO[N_cv] "Partial pressure CO";

  SI.Temperature T_wall_i[N_cv] "Temperature on the inside of reactor wall";
  SI.Temperature T_wall_o[N_cv] "Temperature on the outside of reactor wall";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  for n in 1:N_cv loop

    for i in 1:N_reac loop
      k_i[n,i] = Ak_i[i] * exp(- E_i[i] /(R*T[n]));
    end for;

    for j in 1:4 loop
      K_j[n,j] = AK_j[j] * exp(- dH_j[j] /(R*T[n]));
    end for;

    for i in 1:N_reac loop
      K_i[n,i] = AK_i[i] * exp(- dH_R_i[i] /(R*T[n]));
    end for;

    p_CH4[n] = SI.Conversions.to_bar(gasBulk[n].p_i[1]);
    p_CO2[n] = SI.Conversions.to_bar(gasBulk[n].p_i[2]);
    p_H2O[n] = SI.Conversions.to_bar(gasBulk[n].p_i[3]);
    p_H2[n] = SI.Conversions.to_bar(gasBulk[n].p_i[4]);
    p_CO[n] = SI.Conversions.to_bar(gasBulk[n].p_i[5]);

    DEN[n] = 1 + K_j[n,2]*p_CO[n] + K_j[n,3]*p_H2[n] + K_j[n,1]*p_CH4[n] + K_j[n,4]*p_H2O[n]/max(eps,p_H2[n]);

    RR[n,1] = ((k_i[n,1]/(p_H2[n]^2.5)) * (p_CH4[n]*p_H2O[n] - (p_H2[n]*p_CO[n]/K_i[n,1]))) / DEN[n]^2;

    RR[n,2] = ((k_i[n,2]/p_H2[n]) * (p_CO[n]*p_H2O[n] - (p_H2[n]*p_CO2[n]/K_i[n,2]))) / DEN[n]^2;

    RR[n,3] = ((k_i[n,3]/(p_H2[n]^3.5)) * (p_CH4[n]*(p_H2O[n]^2) - ((p_H2[n]^4)*p_CO2[n]/K_i[n,3]))) / DEN[n]^2;

    lambda_wall[n] = 10.738+0.0242*(T_wall_i[n]+T_wall_o[n])/2;
    heat[n].Q_flow = N_tube*2*pi*Delta_x*lambda_wall[n]*(T_wall_o[n]-T_wall_i[n])/log(dia_tube_o/dia_tube_i);
    heat[n].Q_flow = N_tube*pi*dia_tube_o*Delta_x * (sigma*(A_tube_o+A_refractor)*em_gas*em_tube/((A_tube_o+A_refractor)*em_gas+A_tube_o*(1-em_gas)*em_tube)*(heat[n].T^4-T_wall_o[n]^4) + sigma*N_burner*A_flame*em_flame*em_tube*(1-em_gas)/A_tube_o*T_adi^4);
    heat[n].Q_flow = N_tube*pi*dia_tube_i*Delta_x*U[n]*(T_wall_i[n]-T[n]);
    U[n] = 0.4*gasBulk[n].transp.lambda/dia_part*(2.58*(dia_part*m_flow*gasBulk[n].cp/(A_c*gasBulk[n].transp.lambda))^(1/3) + 0.094*(dia_part*m_flow/A_c)^0.8*(gasBulk[n].cp/(gasBulk[n].transp.lambda*gasBulk[n].transp.eta))^0.4); //for constant m_flow through the reformer

  end for;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          textString="SMR")}),                  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a discretized fixed bed steam methane reformer with reaction kinetics with constant effectiveness factors. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The reactor is discretized and in each volume mass, impulse and energy balances as well as heat transfer between furnace gas and synthesis gas in the tubes and reaction rate equations are solved. These equations are taken from Nandasana et al. [1] except that the pressure loss is assumed to be constant and the effective reaction rates are calculated using constant effectiveness factors. Also the mass balances are stationary so changes in density are neglected. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>The model is valid if the changes of the effectiveness factors and the pressure loss are negligible. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: ideal gas inlet </p>
<p>gasPortOut: ideal gas outlet </p>
<p>heat: heat port </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The used equations are described in [1] except for the changes described in 2. The pressure calculation for each volume can be done either using the pressure in the middle or at the end of the volume. </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>The results of the model were compared to results from Rajesh et al. [2] and the outlet variables fit the results satisfyingly. </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>[1] Nandasana, Anjana D.; Ray, Ajay K.; Gupta, Santosh K. (2003): Dynamic Model of an Industrial Steam Reformer and Its Use for Multiobjective Optimization. In: Ind. Eng. Chem. Res. 42 (17), S. 4028–4042. DOI: 10.1021/ie0209576. </p>
<p>[2] Rajesh, J. K.; Gupta, Santosh K.; Rangaiah, G. P.; Ray, Ajay K. (2000): Multiobjective Optimization of Steam Reformer Performance Using Genetic Algorithm. In: Ind. Eng. Chem. Res. 39 (3), S. 706–717. DOI: 10.1021/ie9905409. </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end SteamMethaneReformer_L4;
