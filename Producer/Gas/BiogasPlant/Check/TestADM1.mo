within TransiEnt.Producer.Gas.BiogasPlant.Check;
model TestADM1 "Test model for adm1"



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

  extends TransiEnt.Basics.Icons.Checkmodel;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Pressure p_atm=101300 "Pressure of gas after leaving the CSTR through port";
  parameter SI.Temperature T=273.15 + 35 "Temperature inside CSTR";
  parameter SI.Density rho=1000 "Density of substrate ";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_CSTR aDM1_CSTR_BSM2(
    T=T,
    p_atm=p_atm,
    rho=rho,
    V_gas=300,
    V_liquid=3400) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Base.ADM1.ADM1_CSTR aDM1_CSTR_manure_bulkowska(
    V_liquid=0.100,
    V_gas=0.010,
    t_res=45*86400,
    S_su_in=0.24,
    S_aa_in=0.0011,
    S_fa_in=0.0010,
    S_va_in=0.1680,
    S_bu_in=0.39,
    S_pro_in=0.7454,
    S_ac_in=2.3467,
    S_h2_in=0,
    S_ch4_in=0,
    S_IC_in=32.3,
    S_IN_in=18.57,
    S_I_in=8.49,
    X_c_in=0,
    X_ch_in=59.0555,
    X_pr_in=13.1103,
    X_li_in=5.6693,
    X_su_in=0.0855,
    X_aa_in=0.0637,
    X_fa_in=0.0670,
    X_c4_in=0.028,
    X_pro_in=0.0135,
    X_ac_in=0.09,
    X_h2_in=0.0430,
    X_I_in=40.2759,
    T=T,
    rho=rho,
    PetersenMatrix(redeclare Base.ADM1.Records.ADM1_parameters_manure_bulkowska Parameters),
    useBSM2=false) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  annotation (
    experiment(
      StopTime=17280000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Diagram(graphics={Text(
          extent={{-60,-18},{-2,-44}},
          lineColor={28,108,200},
          textString="Adm1 model within the bsm2 framework"), Text(
          extent={{6,-16},{82,-46}},
          lineColor={28,108,200},
          textString="Adm1 model within the  manure bulkowska framework")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check model for testing the adm1 model. The model is tetsted with the parameters within the bsm2 framework and the parameters of Bulkowska. It can be seen that the steady state output values of the adm1 model have a </p>
<p>high accordance with the output values from Ros&eacute;n, C., &amp; Jeppsson, U. (2006). &quot;Aspects on ADM1 Implementation within the BSM2 Framework&quot; if the same input parameters are used. Moreover several output variables of the simulation result like the pH-value, the gas volume flow and different soluble </p>
<p>components have been compared with Bułkowska, K., et al. (2015). ADM1-based modeling of anaerobic codigestion of maize silage and cattle manure&ndash;calibration of parameters and model verification (part II).</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Philip Jahneke,&quot;Modellierung einer Biogasanalge und Untersuchung der energetischen Kopplung mit einer Power-to-Gas Anlage in Modelica&quot;,master thesis, Hamburg 2018</p>
<p>[2] Bułkowska,&nbsp;K.,&nbsp;et&nbsp;al.&nbsp;(2015).&nbsp;ADM1-based&nbsp;modeling&nbsp;of&nbsp;anaerobic&nbsp;codigestion&nbsp;of&nbsp;maize&nbsp;silage&nbsp;and&nbsp;cattle&nbsp;manure&ndash;calibration&nbsp;of&nbsp;parameters&nbsp;and&nbsp;model&nbsp;verification&nbsp;(part&nbsp;II)</p>
<p>[3] Ros&eacute;n, C., &amp; Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jan Westphal (j.westphal@tuhh.de) in jan 2020</p>
</html>"));
end TestADM1;
