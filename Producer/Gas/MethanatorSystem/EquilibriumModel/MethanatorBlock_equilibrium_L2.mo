within TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel;
model MethanatorBlock_equilibrium_L2 "model of a methanation block"


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

  extends TransiEnt.Basics.Icons.Reactor;
  inner TransiEnt.SimCenter simCenter                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter Boolean SteadyState=false "if '=true' no heating up/cooling down of reactor considered";

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer alpha_o=25.73 "outer coefficent of heat transfer" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.ThermalConductivity lambda=50 "thermal conductivity of reactor wall" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.ThermalConductivity lambda_insulation=0.04 "thermal condructivity of insulation layer" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.HeatCapacity mCp_Nenn=15E6 "nominal heat capacity for nominal mass flow 1kg/s" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.Length delta_insulation=0.1 "thickness of insulation layer" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.Temperature T_ambient=283.15 "constant ambient temperature" annotation (Dialog(group="Parameteres for heat transfer"));
  parameter Modelica.Units.SI.Temperature T_reactor_start=T_ambient "average start temperature for reactor mass" annotation (Dialog(group="Parameteres for heat transfer"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=12 "nominal mass flow";
  parameter Modelica.Units.SI.AbsolutePressure Delta_p_nominal=0.5e5 "pressure loss for nominal mass flow";

  parameter Boolean useHomotopy=true "True, if homotopy method is used during initialisation";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-6},{-90,14}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-8},{110,12}})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn_properties(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortIn.p,
    xi=wt_0_5,
    h=inStream(gasPortIn.h_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-86,-4},{-66,-24}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasOut_properties(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=ptotal_1,
    T=T_out,
    xi=wt_1_5,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{66,-28},{86,-8}})));
  // _____________________________________________
  //
  //                Medium declaration
  // _____________________________________________

  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var medium;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

 Real kp1 "equilibrium constant of methanation reaction";
 Real kp2 "equilibrium constant of CO-shift reaction";
  Modelica.Units.SI.Length delta;
  Modelica.Units.SI.AbsolutePressure ptotal_0 "total pressure";
  Modelica.Units.SI.AbsolutePressure ptotal_1 "total pressure";
  Modelica.Units.SI.AbsolutePressure Delta_p;
  Modelica.Units.SI.MolarFlowRate Ftotal_1(start=1) "output total molar flow";
  Modelica.Units.SI.MolarFlowRate Ftotal_0 "input total molar flow";
  Modelica.Units.SI.MolarFlowRate F_0[6](min=0, start={100,100,100,100,100,100}) "input molar flow";
  Modelica.Units.SI.MolarFlowRate F_1[6](min=0, start={100,100,100,100,100,100}) "output molar flow";
  Modelica.Units.SI.MolarMass M[6] "vector of molar masses";
  Modelica.Units.SI.MassFraction wt_1[6](
    min=0,
    max=1,
    start={0.1,0.1,0.1,0.1,0.1,0.1}) "weight fraction of output";                                               //1:H2,2:CO,3:CO2,4:H2O,5:CH4,5:N2
  Modelica.Units.SI.MassFraction wt_0[6] "weight fraction of input";
  Modelica.Units.SI.MassFraction wt_0_5[5];
  Modelica.Units.SI.MassFraction wt_1_5[5];
  Modelica.Units.SI.MassFlowRate m_flow_total "total input mass flow";
  Modelica.Units.SI.MolarEnergy Enthalpy1 "enthalpy of methanation reaction 1";
  Modelica.Units.SI.MolarEnergy Enthalpy2;
  Modelica.Units.SI.MolarEnergy Enthalpy3;
  Modelica.Units.SI.Energy Q_flow_reaction "energy of complete reaction";
  Modelica.Units.SI.Temperature T_out(start=600) "output Temperature";
  Modelica.Units.SI.Temperature T_in(start=300, min=273.15) "input Temperature";
  Modelica.Units.SI.Temperature T_average(start=650) "average Temperature";
  Modelica.Units.SI.Temperature T_reactor(min=0);
  Modelica.Units.SI.Temperature T_outer;
  Modelica.Units.SI.Temperature T_out_min=200 "minimum outlet temperature";
                                                                          //T_min=220degC! Deactivation on methanation catalysts Javier Barrientos Brotons
  Modelica.Units.SI.HeatCapacity mCp;
 Real A2[4,6]=[
 {1.925E1,5.213E-2,1.197E-5,-1.132E-8},
 {1.980E1,7.344E-2,-5.602E-5,1.715E-8},
 {3.224E1,1.924E-3,1.055E-5,-3.596E-9},
 {2.714E1,9.274E-3,-1.381E-5,7.645E-9},
 {3.087E1,-1.285E-2,2.789E-5,-1.272E-8},
  {28.3,2.537/1000,0.5443/1000^2,0}] "coefficient for calculation of heat capacities";//Methanation catalytic reactor Bouallou
  Modelica.Units.SI.MolarHeatCapacity Cp_average(start=32) "average overall heat capacity";
  Modelica.Units.SI.MolarHeatCapacity Cp_average_2(start=32);
  Modelica.Units.SI.MolarHeatCapacity Cp_0[6];
  Modelica.Units.SI.HeatFlowRate Q_flow_transfer(start=0);
  Modelica.Units.SI.HeatFlowRate Q_flow_loss(start=0);
  Modelica.Units.SI.HeatFlowRate Q_flow_loss_convection(start=0);
  Modelica.Units.SI.HeatFlowRate Q_flow_loss_radiation(start=0);
  Modelica.Units.SI.HeatFlowRate Q_flow_inner(start=0);
  Modelica.Units.SI.Heat Q_stored(start=0);
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha_i;
  Modelica.Units.SI.Length d_i_ref=2.686;
  Modelica.Units.SI.Length d_i;
  Modelica.Units.SI.Length d_o;
  Modelica.Units.SI.Length d_average;
  Modelica.Units.SI.Length L_ref=4.8;
  Modelica.Units.SI.Length L;
  Modelica.Units.SI.Length s_min;
  Modelica.Units.SI.Area A_o;
  Modelica.Units.SI.Area A_i;
  Modelica.Units.SI.MoleFraction Fshare_1[6];
  Modelica.Units.SI.MoleFraction Fshare_0[6];
 Boolean On;
 Real s1;
 Real s2;
  Modelica.Units.SI.Stress sigma_zul;
initial equation
 if (not SteadyState) then
 // T_out=T_in+1;
  T_reactor=T_reactor_start;
 end if;

equation
  gasPortIn.m_flow + gasPortOut.m_flow = 0;
  On=gasPortIn.m_flow > 0.01;

  // _____________________________________________
  //
  //               Connection Statements
  // _____________________________________________

//pressure
  ptotal_1=gasPortOut.p;
  ptotal_0=gasPortIn.p;
//Temperature
  gasPortIn.h_outflow = 0;
  gasPortOut.h_outflow = gasOut_properties.h;
  T_in=gasIn_properties.T;
//mass fraction
  gasPortIn.xi_outflow = inStream(gasPortIn.xi_outflow);
  wt_0_5=inStream(gasPortIn.xi_outflow);
  wt_0={wt_0_5[1],wt_0_5[2],wt_0_5[3],wt_0_5[4],wt_0_5[5],1 - sum(gasPortIn.xi_outflow)};
  wt_1_5={wt_1[1],wt_1[2],wt_1[3],wt_1[4],wt_1[5]};

  gasPortOut.xi_outflow = wt_1_5;
  m_flow_total=max(gasPortIn.m_flow, 0.01);
  M=gasIn_properties.M_i;

  // _____________________________________________
  //
  //              Equilibrium Constants
  // _____________________________________________

 // if noEvent(T_out<=T_out_min) then
 if noEvent(T_out<=T_out_min) then
   kp1= 10266.76 * exp((-26830 / (T_out_min)) + 30.11);
   kp2=exp(4400 / (T_out_min) - 4.063);
  else
   kp1 = 10266.76 * exp((-26830 / (T_out)) + 30.11);//for methanation reaction
   kp2=exp(4400 / (T_out) - 4.063);
  end if;

  // _____________________________________________
  //
  //                   Molar Balance
  // _____________________________________________

 if (not On) then
   for i in 1:6 loop
     F_1[i]=F_0[i];
   end for;
  else
   if (useHomotopy) then
    F_1[1]=homotopy(F_0[2] + F_0[5] + F_0[1]-F_1[2]- F_1[5],F_0[1]);
   else
    F_0[2] + F_0[5] + F_0[1] = F_1[2] + F_1[5] + F_1[1]; //C balance
   end if;
    2 * F_0[2] + F_0[3] + F_0[5] = 2 * F_1[2] + F_1[3] + F_1[5]; //O balance
    F_0[6] = F_1[6];//N balance
     2 * F_0[4] + 2 * F_0[3] + 4 * F_0[1] = 2 * F_1[4] + 2 * F_1[3] + 4 * F_1[1]; //H balance
    //equilibrium constant:
   ((F_1[1]*ptotal_1 /1000) * (F_1[3]*ptotal_1 /1000))*kp1*Ftotal_1*Ftotal_1 =  (F_1[5]*ptotal_1 /1000) * (F_1[4]*ptotal_1/1000)*(F_1[4]*ptotal_1/1000) *(F_1[4]*ptotal_1/1000);
    (F_1[5] * F_1[3])*kp2 = F_1[2] * F_1[4];
 end if;
    Ftotal_0 = F_0[3] + F_0[1] + F_0[2] + F_0[4] + F_0[5] + F_0[6];
    Ftotal_1 = F_1[3] + F_1[1] + F_1[2] + F_1[4] + F_1[5] + F_1[6];

  // _____________________________________________
  //
  //               Gas properties
  // _____________________________________________

//calculation of pressure drop Delta_p
  gasPortIn.m_flow*Delta_p_nominal = m_flow_nominal*Delta_p;
 ptotal_0=ptotal_1+Delta_p;

 for i in 1:6 loop
  wt_0[i]*m_flow_total=F_0[i]*M[i];
  F_1[i] * M[i] = wt_1[i] * m_flow_total;
  Fshare_0[i]=F_0[i]/Ftotal_0;
  Fshare_1[i]=F_1[i]/Ftotal_1;
//heat capacities:
  Cp_0[i]=A2[1,i] + A2[2,i] * T_in + A2[3,i] * T_in ^ 2 + A2[4,i] * T_in ^ 3;
 end for;

//average temperature
 if noEvent(Modelica.Math.log(T_out)==Modelica.Math.log(T_in)) then
  T_average=T_in;
 else
  T_average=(T_out - T_in)/(Modelica.Math.log(T_out)-Modelica.Math.log(T_in));
 end if;

 //average specific heat capacity
// Cp_average=gasIn_properties.cp*m_flow_total/Ftotal_0;
 Cp_average_2*(Ftotal_0)=sum(Cp_0*(F_0));
 Cp_average=homotopy(gasIn_properties.cp*m_flow_total/Ftotal_0,sum(Cp_0*(F_0))/Ftotal_0);

  // _____________________________________________
  //
  //                   Reaction Heat
  // _____________________________________________

  d_i=d_i_ref*(m_flow_nominal/8.16525597)^(1/3);
  L=L_ref*d_i/d_i_ref;
  mCp=mCp_Nenn*m_flow_nominal;

  //total energy flow released during reaction
  Q_flow_reaction=(Enthalpy2*(F_0[2]-F_1[2])+Enthalpy1*(F_1[1]-F_0[1]));

  //reaction enthalphies
  Enthalpy1=0.0266*T_in^2-47.7331*T_in-205094.5788;
  Enthalpy2=-(0.0026*T_in^2-7.4437*T_in-41557.3842);
  Enthalpy3=+Enthalpy2+Enthalpy1;

  // _____________________________________________
  //
  //                   Heat Transfer
  // _____________________________________________
  if (SteadyState) then
    Q_flow_inner=0;
    Q_stored=mCp*(T_reactor-T_ambient);
    T_reactor=T_average;
  else
    Q_stored=mCp*(T_reactor-T_ambient);
    Q_flow_inner= alpha_i*A_i*(T_average-T_reactor);
    der(Q_stored)=Q_flow_transfer;
  end if;

  Q_flow_transfer=Q_flow_loss+Q_flow_inner;
  Q_flow_loss=Q_flow_loss_convection+Q_flow_loss_radiation;
  Q_flow_loss_convection=1/((Modelica.Math.log((d_i/2+delta+delta_insulation)/(d_i/2+delta))/(2*Modelica.Constants.pi*L*lambda_insulation))+1/alpha_o)*(T_ambient-T_reactor);
  Q_flow_loss_radiation=Modelica.Constants.sigma*A_o*(T_ambient^4-T_outer^4);

 if (useHomotopy) then
   T_out=homotopy((-Q_flow_inner-Q_flow_reaction)/(Ftotal_0*Cp_average)+T_in,T_in+400);
 else
   -Q_flow_reaction+(Ftotal_0)*Cp_average*(T_in-T_out)-Q_flow_inner=0;
 end if;

  T_outer=T_ambient-Q_flow_loss/(alpha_o*A_o);

  d_o=d_i+2*delta;  //outer diameter of reactor
  A_o=2*Modelica.Constants.pi*(d_o/2)*L+Modelica.Constants.pi*(d_o/2)^2;  //outer area

  A_i=(2*Modelica.Constants.pi*(d_i/2)*L+Modelica.Constants.pi*(d_i/2)^2)*1.5;
   if (not On) then
     alpha_i=0.001;
   else
     alpha_i=(57.92316*m_flow_total/(m_flow_nominal)+0.22344)*(-0.0007*T_in+1.3734);
   end if;

  //Kesselformel:
  d_average=(d_i+(d_i+2*s_min))/2;
  s_min=(30e6*d_average/(2*sigma_zul)+s1+s2);
  sigma_zul=370E6;
  s1=0.0005;
  s2=0;
  delta=2*s_min;

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Equilibrium model of reactor block for methanation of hydrogen.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is based on the equilibrium constants for the reaction equations of CO2-methanation, CO-methanation und CO-Shift. The gas components in the output are in an equilibrium. The model considers the heat of the exothermal reaction and therewith the temperature increase of the product gas and of the temperature increase of the reactor. A detailed description is found in [1].</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>The calculation of the equilibrium is validated in [1].</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortIn: Input port for methanation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortOut: Output port of product gas</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The chemical balance considers the equilibrium constants. These are calculated via the following formulas:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1. equilibrium constant of CO-methanation: </span><img src=\"modelica://TransiEnt/Images/equations/equation-zuNCA2Z1.png\" alt=\"p_CH4*p_H2O/(p_CO*p_H2^3)=9.74*10^(-11)*exp(26830/T_1-30.11)\"/> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">2. equilibirum constant for CO-shift: </span><img src=\"modelica://TransiEnt/Images/equations/equation-uQplxM2p.png\" alt=\"p_H2*p_CO2/(p_CO*p_H2O)=exp(4400/T_1-4.063)\"/></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The equilibrium constant for CO2-methanation is lineraly dependent on those two equilibrium constants such that the equation can be omited.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Moreover a substance balance and an thermal balance govern the calculation. The substance balance ensures that the amount of subtance of each element entering the reactor block equals the amount of substance leaving the reactor block.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For the thermal balance a simplified model of a fixed-bed reactor is considered with the lenght L, the inner diameter di, a thickness of the reactor wall of delta_wall and an isolation layer with the thickness delta_iso. The cross section of the reactor block is shown in graphic 1.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The following differential equation is needed for the calculation of the temperature of the reactor mass T_reactor:</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-MB8Uy99J.png\" alt=\"C* (d/dt *T_reactor)=Q_flow_loss+Q_flow_inner\"/></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Here Q_flow_loss describes the heat losses towards the environment and Q_flow_inner is the heat transfer from the process gas onto the reactor mass. Q_flow_loss consists of the heat loss through radiation and convection whereby the necessary values for thermal conductivities and the heat-transfer coefficient can be defined as parameters. The formula for heat-transfer coefficient alpha_i for the heat transfer from the process gas onto the reactor mass (Q_flow_inner) is a simplified correlation which results from a more complex correlation:</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-5iJV2t0u.png\" alt=\"alpha_i=[54.2853*(m_flow_total/m_flow_nom)+0.209407]*[-0.000747*T_0+1.465437]\"/></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The temperature increase of the process gas is calculated via the following formula:</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-Y2w7r207.png\" alt=\"F_average*c_pgas*(T_in-T_out)=O_flow_inner+Q_flow_reaction\"/></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Here F_average is the averaged molar flow between output and input, c_p,gas is the specific heat capacity of the gas, T_out and T_in are the input, respectively the output temperature of the process gas and Q_flow_reaction is the reaction heat that is released during the reaction.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_reaction is calculated via the specific molar reaction heat:</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-Qcf4gT7E.png\" alt=\"Q_flow_reaction=(F_out_CO2-F_in_CO2)*h_3+(F_out_CH4-F_0_CH4)*h_1\"/></p>
<p>Here F_i stands for the molar flow of the respective substance and h1 and h3 stand for the specific molar reaction heat. These specifc molar reaction heat depend on the temperature. As a simplification the reaction heat are calculated with the input temperature T_in:</p>
<p>specific molar reaction heat for CO-methanation: <img src=\"modelica://TransiEnt/Images/equations/equation-vJ5LGwLp.png\" alt=\"h_1=0.0266*T_0^2-47.7331*T_0-205094.5788\"/></p>
<p>specific molar reaction heat for CO-shift: <img src=\"modelica://TransiEnt/Images/equations/equation-dYCn7Miq.png\" alt=\"h_3=0.0026*T_0^2-7.4437*T_0-41557.3842\"/></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Validated in [1].</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Sch&uuml;lting, Oliver - Vergleich von Power-to-Gas-Speichern mit Ziel der R&uuml;ckverstromung unter derzeit g&uuml;ltigen technischen Restriktionen (Masterarbeit), Technische Universit&auml;t Hamburg - Institut f&uuml;r Energietechnik, 2016</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2019</span></p>
</html>"));
end MethanatorBlock_equilibrium_L2;
