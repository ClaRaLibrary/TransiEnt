within TransiEnt.Components.Gas.Reactor.Base;
partial model PartialFixedbedReactorIdealGas_L4 "Discretized model of a fixed-bed reactor using ideal gas models"



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





// all values and formulas (except otherwise stated) are taken from Nandasana, A. D., Ray, A. K., & Gupta, S. K. (2003). Dynamic model of an industrial steam reformer and its use for multiobjective optimization. Industrial & engineering chemistry research, 42(17), 4028-4042.
  // Pantoleontos 2012: G. Pantoleontos, E.S. Kikkinides, M.C. Georgiadis. A heterogeneous dynamic model for the simulation and optimisation of the steam methane reforming reactor. Int. J. Hydrog. Energy (Mar. 2012), pp. 1–13

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.FixedBedReactor_L4;
  import TransiEnt;
  import Modelica.Constants.pi;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer N_comp=medium.nc "number of components";
  final parameter SI.CrossSection A_c = N_tube*pi/4*dia_tube_i^2 "total crosssectional area of all reactor tubes";
  final parameter SI.Length Delta_x=l/N_cv "Length of one control volume";
  //final parameter SI.Density rho_nom[N_cv]=TILMedia.GasFunctions.density_pTxi(medium,p_nom,T_nom,xi_nom) "Nominal density in the control volumes";
  //final parameter SI.Density rho_start[N_cv]=TILMedia.GasFunctions.density_pTxi(medium,p_start,T_start,xi_start) "Initial density in the control volumes";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TILMedia.GasTypes.BaseGas medium=simCenter.gasModel2 "Medium model" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "true if homotopy should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer N_cv=1 "Number of control volumes" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer N_reac "Number of reactions" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer nu[N_reac,N_comp-1] "Matrix with stochiometric coefficients of all components-1 in all reactions"
                                                                                                    annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MolarEnergy E_i[N_reac] "Activation energies" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MolarEnthalpy dH_R_i[N_reac] "Reaction enthalpies" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eff[N_cv,N_reac] "Effectiveness factors for the reactions" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p "Total pressure loss over the reactor" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer pressureCalculation=1 "Method of pressure calculation" annotation(Dialog(group="Fundamental Definitions"), choices(__Dymola_radioButtons=true,choice=1 "Averaged pressure over the fluid volume",
                                                                                                    choice=2 "Outlet pressure of the fluid volume"));

  parameter Real N_tube "Number of tubes" annotation(Dialog(group="Geometry"));
  parameter SI.Diameter dia_tube_i "Inner tube diameter" annotation(Dialog(group="Geometry"));
  parameter SI.Length l "Length of reactor" annotation(Dialog(group="Geometry"));

  parameter SI.Diameter dia_part "Equivalent pellet diameter" annotation(Dialog(group="Catalyst"));
  parameter SI.VolumeFraction eps_bed "Bed porosity" annotation(Dialog(group="Catalyst"));
  parameter SI.VolumeFraction eps_cat "Catalyst porosity" annotation(Dialog(group="Catalyst"));
  parameter SI.Density d_cat "Density of catalyst particle" annotation(Dialog(group="Catalyst"));
  parameter SI.Density d_bed = d_cat*(1-eps_bed) "Density of fixed-bed" annotation(Dialog(group="Catalyst")); //Pantoleontos 2012
  parameter SI.SpecificHeatCapacity cp_cat "Specific heat capacity of catalyst" annotation(Dialog(group="Catalyst"));

  parameter SI.Temperature T_nom[N_cv] "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv] "Nominal pressure in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,N_comp-1] "Nominal values for mass fractions" annotation(Dialog(group="Nominal Values"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));

  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{110,-10},{90,10}}), iconTransformation(extent={{110,-10},{90,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat[N_cv]      annotation (Placement(transformation(
          extent={{-10,90},{10,110}},   rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Gas_pT gasBulk[N_cv](
    p=if useHomotopy then homotopy(p,p_nom) else p,
    T=if useHomotopy then homotopy(T,T_nom) else T,
    xi= if useHomotopy then homotopy(xi,xi_nom) else xi,
    each gasType=medium,
    each computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  TILMedia.Gas_ph gasIn(
    p=gasPortIn.p,
    h= inStream(gasPortIn.h_outflow),
    xi= inStream(gasPortIn.xi_outflow),
    gasType=medium,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real k_i[N_cv,N_reac] "Rate constants for reactions N_reac";
  Real K_i[N_cv,N_reac] "Equilibrium constants for reactions N_reac";
  Real r_i_eff[N_cv,N_comp-1] "Effective reaction rate of components in mol/(kg cat s)";
  Real RR_eff[N_cv,N_reac] "Effective reaction rates of reactions N_reac in mol/(kg cat s)";
  Real RR[N_cv,N_reac] "Reaction rates of reactions N_reac in mol/(kg cat s)";
  SI.MassFlowRate m_flow = max(gasPortIn.m_flow,0) "Mass flow through the reactor";
public
  SI.Temperature T[N_cv] "Gas and catalyst temperature in the control volumes" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Pressure p[N_cv] "Pressure in the control volumes" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.MassFraction xi[N_cv,N_comp-1] "Mass fraction in the control volumes" annotation (Dialog(group="Initialization", showStartAttribute=true));
  //SI.Density rho[N_cv](start = rho_start) "Density in the control volumes";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  for n in 1:N_cv loop

    RR_eff[n,:] = RR[n,:] .* eff[n,:];

    r_i_eff[n,:] = RR_eff[n,:] * nu[:,:];
    //r_i_eff[n,:] = transpose(nu) * RR_eff[n,:];

    if n == 1 then

      for i in 1:N_comp-1 loop

        eps_bed*der(xi[1,i])*gasBulk[1].d = 1/(Delta_x*A_c)*m_flow*(gasIn.xi[i] - xi[1,i]) + gasBulk[1].M_i[i]*d_bed*r_i_eff[1,i]; //mass balance, changes in gasBulk.d neglected, otherwise problems with DAE index reduction

      end for;

      (d_bed*cp_cat+(eps_bed+(1-eps_bed)*eps_cat)*gasBulk[1].d*gasBulk[1].cp)*A_c*der(T[1]) = 1/Delta_x*m_flow*(gasIn.cp*gasIn.T-gasBulk[1].cp*T[1]) + heat[1].Q_flow/Delta_x - A_c*d_bed*RR_eff[1,:]*dH_R_i;

    else

      for i in 1:N_comp-1 loop

        eps_bed*der(xi[n,i])*gasBulk[n].d = 1/(Delta_x*A_c)*m_flow*(xi[n-1,i] - xi[n,i]) + gasBulk[n].M_i[i]*d_bed*r_i_eff[n,i]; //mass balance, changes in gasBulk.d neglected, otherwise problems with DAE index reduction

      end for;

      (d_bed*cp_cat+(eps_bed+(1-eps_bed)*eps_cat)*gasBulk[n].d*gasBulk[n].cp)*A_c*der(T[n]) = 1/Delta_x*m_flow*(gasBulk[n-1].cp*T[n-1]-gasBulk[n].cp*T[n]) + heat[n].Q_flow/Delta_x - A_c*d_bed*RR_eff[n,:]*dH_R_i;

    end if;

    //pressures for linear pressure drop
    if pressureCalculation==1 then
      p[n] = gasPortIn.p - Delta_p*(2*n-1)/(2*N_cv); //averaged pressure over one control volume
    else
      p[n] = gasPortIn.p - Delta_p*n/N_cv; //pressure of the control volume equals to the pressure of its end
    end if;

    //rho[n]=if useHomotopy then homotopy(gasBulk[n].d,rho_nom[n]) else gasBulk[n].d;

  end for;

  gasPortIn.p = gasPortOut.p + Delta_p;
  gasPortIn.m_flow + gasPortOut.m_flow = 0;

  gasPortOut.h_outflow = gasBulk[N_cv].h;
  gasPortOut.xi_outflow = xi[N_cv,:];

  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Diagram(graphics,
                                                                                                         coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This partial model represents a discretized fixed bed reactor with reaction kinetics with constant effectiveness factors. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The reactor is discretized and in each volume mass, impulse and energy balances are solved. These equations are taken from Nandasana et al. [1] except that the pressure loss is assumed to be constant and the effective reaction rates are calculated using constant effectiveness factors. Also the mass balances are stationary</p>
<p> so changes in density are neglected. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The model is valid if the changes of the effectiveness factors and the pressure loss are negligible. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: ideal gas inlet </p>
<p>gasPortOut: ideal gas outlet </p>
<p>heat: heat port </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>T[N_cv] &quot;Gas and catalyst temperature in the control volumes&quot;   </p>
<p>p[N_cv] &quot;Pressure in the control volumes&quot;</p>
<p>xi[N_cv,N_comp-1] &quot;Mass fraction in the control volumes&quot;</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The used equations are described in [1] except for the changes described in 2. The pressure calculation for each volume can be done either using the pressure in the middle or at the end of the volume. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Nandasana, Anjana D.; Ray, Ajay K.; Gupta, Santosh K. (2003): Dynamic Model of an Industrial Steam Reformer and Its Use for Multiobjective Optimization. In: Ind. Eng. Chem. Res. 42 (17), S. 4028&ndash;4042. DOI: 10.1021/ie0209576. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
</html>"));
end PartialFixedbedReactorIdealGas_L4;
