within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer;
model SteamReformer_NaturalGas_to_H2 "SteamReformer with calculation of reaction kinetics depending on input gascomposition, including mass fraction balance and reaction volume (input natural gas, output H2 rich syngas)"

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

  extends TransiEnt.Basics.Icons.Model;
  import TransiEnt;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Pressure p_reformer = 1.013e5 "Pressure in the reformer";
  parameter Modelica.SIunits.Density d_kat = 1900 "Density of catalyst";
  parameter Real scale_kat = 1 "Influencing factor of the reaction heat under the assumption that more reactions occur than through concentration changes observed";
  parameter Real eps = 1e-6 "Accuracy of the calculation";
  parameter Modelica.SIunits.Volume V_reac = 0.001 "Volume of the reactor";
  parameter Real eps_kat = 0.4 "Porosity of the catalyst";

  // === Order of components in vectors: {CH4 , CO , H2 , H2O} ===

  parameter Real K_oi[4] = {6.65e-4, 8.23e-5, 6.12e-9, 1.77e5} "Adsorption coefficient constant of the component i {CH4, CO, H2, H2O}";
  parameter Real dH_i[4] = {-38280, -70650, -82900, 88680} "Vector with the enthalpies of the component i {CH4, CO, H2, H2O}";

  // === Order of components: {CH4 , O2}

  parameter Real K_oiC[2] = {1.26e-1, 7.78e-7} "Adsorption coefficient constant of the combusted component i {CH4-c, O2-c}";
  parameter Real dH_iC[2] = {-27300, -92800} "Vector with the enthalpies of the combusted component i {CH4-c, O2-c}";

 // === Order of components: Reaction {1  ,  2  ,  3  ,  4a  ,  4b}

  parameter Real k_oi[5] = {1.17e15, 2.83e14, 5.43e5, 8.11e5, 6.82e5} "k_oi";
  parameter Real E_j[5] = {240100, 243900, 67130, 86000, 86000} "Activation energy";
  parameter Real Delta_H_R[4] = {206.2*1000, 164.9*1000, -41.1*1000, -802.7*1000} "Reaction heat of the reactions 1 to 4 in J/mol";

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);

  // parameters
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 850;
  parameter Modelica.SIunits.Mass m = V_reac*d_kat*(1-eps_kat);

  parameter Modelica.SIunits.Temperature T_reformer_min = 500+273.15;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feed(Medium=Syngas) annotation (Placement(transformation(extent={{-110,-12},{-88,10}}), iconTransformation(extent={{-112,-18},{-84,12}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut drain(Medium=Syngas) annotation (Placement(transformation(extent={{90,-10},{112,12}}), iconTransformation(extent={{86,-18},{114,12}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport      annotation (Placement(transformation(
          extent={{-6,90},{8,104}},   rotation=0)));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real k_i[5] "Reaction coefficient of the reaction i";
  Real K_I = exp(-26830/T_reformer + 30.114) "Equilibrium constant of the first equation in [bar]";
  Real K_III = exp(4400/T_reformer - 4.036) "Equilibrium constant of the third equation in [-]";
  Real K_II = K_I * K_III "Equilibrium constant of the second equation in [bar]";
  Real r_i[6] "Reaction rate of the components  {CH4, O2, CO2, H2O, H2, CO}";
  Real A[6,4] = [-1, -1, 0, -1; 0, 0, 0, -2; 0, 1, 1, 1; -1, -2, -1, 2; 3, 4, 1, 0; 1, 0, -1, 0] "Matrix for calculating the reaction rates";
  Real b_running[4] = {0.07*R1, 0.06*R2, 0.7*R3, 0.05*R4};
  Real b_preheat[4] = {0, 0, 0, 0};
  Real b[4];
  Real K_iC[2] "Adsorption coefficient constant of the combusted component i {CH4-c, O2-c}";
  Real OMEGA "Term in the reaction rate equations";
  Real R1 "Reaction rate 1";
  Real R2 "Reaction rate 2";
  Real R3 "Reaction rate 3";
  Real R4 "Reaction rate 4";
  Real K_i[4] "Adsorption coefficient constant of the component i {CH4, CO, H2, H2O}";
  Real x_i[7]( start= {0.35,0.1,0,0.45,0.00001,0,0.1}) "Mole fraction of the gas mixture in the reformer during the reaction "
                                                                                                                              annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.MassFraction xi_ch4 "Mass fraction CH4";
  Modelica.SIunits.MassFraction xi_o2 "Mass fraction O2";
  Modelica.SIunits.MassFraction xi_co2 "Mass fraction CO2";
  Modelica.SIunits.MassFraction xi_h2o "Mass fraction H2O";
  Modelica.SIunits.MassFraction xi_h2 "Mass fraction H2";
  Modelica.SIunits.MassFraction xi_co "Mass fraction CO";
  Modelica.SIunits.MoleFraction x_n2 "Mole fraction N2";
  Modelica.SIunits.Pressure p_ch4 = sg.p_i[1]/1e5 "Mass fraction CH4";
  Modelica.SIunits.Pressure p_o2 = sg.p_i[2]/1e5 "Mass fraction 02";
  Modelica.SIunits.Pressure p_co2 = sg.p_i[3]/1e5 "Mass fraction CO2";
  Modelica.SIunits.Pressure p_h2o = sg.p_i[4]/1e5 "Mass fraction H2O";
  Modelica.SIunits.Pressure p_h2 = sg.p_i[5]/1e5 "Mass fraction H2";
  Modelica.SIunits.Pressure p_co = sg.p_i[6]/1e5 "Mass fraction CO";
  Real m_ges;
  Modelica.SIunits.Temperature T_reformer(start = simCenter.T_amb_const) "Temperature of the reformer section" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Temperature T_gas = (T_reformer + START.T)/2 "Assumption of the average temperature between reformer temperature and inlet temperature";
  Modelica.SIunits.MassFlowRate m_flow = feed.m_flow "Mass flow rate of the gas mixture through the reformer";
  SI.HeatFlowRate Q_flow_reac "Heat flow due to reactions";

  TILMedia.Gas_pT sg(
    p=p_reformer,
    T=T_gas,
    xi= {xi_ch4,xi_o2,xi_co2,xi_h2o,xi_h2,xi_co},
    gasType=Syngas)
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));

            TILMedia.Gas_pT START(
    p=p_reformer,
    T= inStream(feed.T_outflow),
    xi= inStream(feed.xi_outflow),
    gasType=Syngas)
    annotation (Placement(transformation(extent={{-86,-12},{-66,8}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

      for i in 1:5 loop
      k_i[i] = k_oi[i] * exp(- E_j[i] /(Modelica.Constants.R*T_gas));
      end for;

      for i in 1:4 loop
      K_i[i] = K_oi[i] * exp(- dH_i[i] /(Modelica.Constants.R*T_gas));
      end for;

      for i in 1:2 loop
      K_iC[i] = K_oiC[i] * exp(- dH_iC[i] /(Modelica.Constants.R*T_gas));
      end for;

      OMEGA = 1 + K_i[2]*p_co + K_i[3]*p_h2 + K_i[1]*p_ch4 + K_i[4]*p_h2o/max(eps,p_h2);

      R1 = min(0.1,((k_i[1]/(p_h2^2.5)) * (p_ch4*p_h2o - (p_h2*p_co/K_I))) / OMEGA^2);

      R2 = min(0.1,((k_i[2]/(p_h2^3.5)) * (p_ch4*(p_h2o^2) - ((p_h2^4)*p_co2/K_II))) / OMEGA^2);

      R3 = ((k_i[3]/p_h2) * (p_co*p_h2o - (p_h2*p_co2/K_III))) / OMEGA^2;

      R4 = k_i[4]*p_ch4*p_o2/((1+K_iC[1]*p_ch4+K_iC[2]*p_o2)^2) + k_i[5]*p_ch4*p_o2/(1+K_iC[1]*p_ch4+K_iC[2]*p_o2);

      b = b_running * Modelica.Fluid.Utilities.regStep(T_reformer-T_reformer_min, 1,  0, 5);

      r_i = A*b;

      //mass balance including reactive term

       for i in 1:6 loop

          der(x_i[i]) = m_flow*inStream(feed.xi_outflow[i])/sg.M_i[i] - m_flow*sg.xi[i]/sg.M_i[i] + V_reac*r_i[i]*d_kat; // *(1-eps_kat) optional

       end for;

      // x_i[10] = 1-sum(x_i[1:9]);
      x_i[7] = 1-sum(x_i[1:6]);

      //Term for converting the new concentrations in a mass fraction, which is influencing TTLMedia

      m_ges = sum(x_i*sg.M_i)+x_i[7]*sg.M_i[7];

      xi_ch4 = max((x_i[1]*sg.M_i[1]/m_ges),eps);

      xi_o2 = x_i[2]*sg.M_i[2]/m_ges;

      xi_co2 = x_i[3]*sg.M_i[3]/m_ges;

      xi_h2o = max(x_i[4]*sg.M_i[4]/m_ges,eps);

      xi_h2 = max(x_i[5]*sg.M_i[5]/m_ges,eps);

      xi_co = max(x_i[6]*sg.M_i[6]/m_ges,eps);

      x_n2 = 1-sum(sg.x);

      // Interface equations
      T_reformer = heatport.T;

      // condition

      // der(T_reformer) = 1/(m * cp) * ( heatport.Q_flow - feed.m_flow * ( START.h - sg.h)   + Q_reac);
      der(T_reformer) =1/(m*cp)*(heatport.Q_flow - m_flow*(sg.h - START.h) + Q_flow_reac);    //

      // Reaction heat
  Q_flow_reac = -(b[1]*Delta_H_R[1] + b[2]*Delta_H_R[2] + b[3]*Delta_H_R[3] + b[4]*Delta_H_R[4])*d_kat*V_reac*scale_kat;

      // impulse equation
      feed.p = drain.p;

      // mass balance (total mass)
      feed.m_flow + drain.m_flow = 0;

      // enthalpy (no heat transfers considered between reformer and gas)"
      feed.T_outflow = inStream(drain.T_outflow);
      drain.T_outflow = min(T_reformer, sg.T);

      // mass fractions
      feed.xi_outflow = inStream(drain.xi_outflow);
      drain.xi_outflow = sg.xi;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,20},{100,-28}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-44,20},{48,-28}},
          lineColor={0,0,0},
          fillColor={127,190,190},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-44,12},{48,-20}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag)}), Diagram(graphics,
                                                        coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Steam Reformer&nbsp;with&nbsp;calculation&nbsp;of&nbsp;reaction&nbsp;kinetics&nbsp;depending&nbsp;on&nbsp;input&nbsp;gas composition,&nbsp;including&nbsp;mass&nbsp;fraction&nbsp;balance&nbsp;and&nbsp;reaction&nbsp;volume&nbsp;(input&nbsp;natural&nbsp;gas,&nbsp;output&nbsp;H2&nbsp;rich&nbsp;syngas).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn&nbsp;feed(Medium=Syngas)&nbsp;</p>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut&nbsp;drain(Medium=Syngas)&nbsp;</p>
<p>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a&nbsp;heatport&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validation has been done as part of the master thesis [1] </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SteamReformer_NaturalGas_to_H2;
