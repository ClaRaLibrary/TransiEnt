within TransiEnt.Basics.Media.Solids;
model Basalt "Basalt | data from Nahhas(2019) | temperature dependent cp and lambda"


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


extends TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity(
    final d = 2960.0,
    final cp_nominal = 730.0,
    final lambda_nominal = 2.51,
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);

  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________


 function thermalConductivity "lambdap = (C1 + C2*T)^-1"
     input Real T;
     output Real lambda;

  protected
     constant Real C1 =  0.4;
     constant Real C2 =  -2.68e-5;

 algorithm

     lambda := (C1 + C2*T)^(-1);

 end thermalConductivity;

  function specificHeatCapacity "cp = C1 + C2*T + C3*T^-2"
     input Real T;
     output Real cp;

  protected
     constant Real C1 =  989;
     constant Real C2 =  0.0658;
     constant Real C3 =  -2.74e7;
  algorithm

     cp := C1 + C2*T + C3*T^(-2);

  end specificHeatCapacity;

 function integral_cp_dT "cp = C1 + C2*T + C3*T^-2"
     input Real T;
     output Real Int_cp_T;

  protected
     constant Real C1 =  989;
     constant Real C2 =  0.0658;
     constant Real C3 =  -2.74e7;
 algorithm

     Int_cp_T := C1*T + C2/2*T^2 - C3*T^(-1);

 end integral_cp_dT;

 function integral_cpOverT_dT "cp = C1 + C2*T + C3*T^-2"
     input Real T;
     output Real Int_cpOverT_dT;

  protected
     constant Real C1 =  989;
     constant Real C2 =  0.0658;
     constant Real C3 =  -2.74e7;
 algorithm

     Int_cpOverT_dT := C1*log(T) + C2*T - 1/2 * C3*T^(-2);

 end integral_cpOverT_dT;


equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  cp=specificHeatCapacity(T);
  lambda=thermalConductivity(T);
  nu = nu_nominal;
  E = E_nominal;
  G = G_nominal;
  beta = beta_nominal;
  specificInternalEnergy = integral_cp_dT(T);
  specificEntropy = integral_cpOverT_dT(T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model contains exemplary material data of basalt with temperature variant heat capacity and thermal conductivity. Both properties are approximated as polynomials in temperature.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The properties of natural rock may vary significantly among quaries etc. This media model represent the measured data of the paper cited below.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Data is taken from:</p>
<p><span style=\"font-family: Courier New;\">T.&nbsp;Nahhas,&nbsp;X.&nbsp;Py,&nbsp;N.&nbsp;Sadiki,&nbsp;Experimental&nbsp;investigation&nbsp;of&nbsp;basalt&nbsp;rocks&nbsp;as&nbsp;storage&nbsp;material&nbsp;for&nbsp;high-temperature&nbsp;concentrated&nbsp;solar&nbsp;power&nbsp;plants,&nbsp;Renewable&nbsp;and&nbsp;Sustainable&nbsp;Energy&nbsp;Reviews&nbsp;110&nbsp;(2019)&nbsp;226&ndash;235.</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Michael von der Heyde (heyde@tuhh.de), March 2021, for the FES research project</p>
</html>"));
end Basalt;
