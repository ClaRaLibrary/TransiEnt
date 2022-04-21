﻿within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity;
model ZehnerBauerSchluender "Zehner/Bauer/Schluender Correlation"



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


  extends TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.ThermalConductivityBasePackedBed;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________


  outer TILMedia.Gas_ph fluid[iCom.N_cv];
  outer TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock[iCom.N_cv];

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real epsilon = 0.85 "Long wave emission factor";
  parameter Real CF = 1.4 "Additional form factor";
  parameter Real Phi = 0.001 "Form Coefficient Phi";

  final parameter Real B = CF*((1-iCom.porosity)/iCom.porosity)^(10/9);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  ClaRa.Basics.Units.ThermalConductivity[iCom.N_cv] lambda_eff_0 "Effective Thermal Conductivity of Packed Bed at stagnant fluid";


protected
  Real k_c[iCom.N_cv];
  Real k_p[iCom.N_cv];
  Real N[iCom.N_cv];
  Real k_bed[iCom.N_cv];
  Real k_rad[iCom.N_cv];
  Real k_G[iCom.N_cv] = ones(iCom.N_cv) "Minor influence";




equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // ______________________________________________

  for i in 1:iCom.N_cv loop

  k_p[i] = rock[i].lambda/fluid[i].transp.lambda;

  N[i] = 1/k_G[i]*(1+(k_rad[i]-B*k_G[i])/k_p[i]) - B*(1/k_G[i]-1)*(1+k_rad[i]/k_p[i]);

  k_c[i] = 2/N[i]*(B*(k_p[i]+k_rad[i]-1)/(N[i]^2*k_G[i]*k_p[i])*Modelica.Math.log((k_p[i]+k_rad[i])/(B*(k_G[i]+(1-k_G[i])*(k_p[i]+k_rad[i]))))
           + (B+1)/(2*B)*(k_rad[i]/k_G[i] - B*(1+(1-k_G[i])/k_G[i]*k_rad[i]))
           - (B-1)/(N[i]*k_G[i]));

  k_rad[i] = 4*Modelica.Constants.sigma/(2/epsilon - 1)*iCom.T[i]^3*iCom.d_v_m/fluid[i].transp.lambda;

  k_bed[i] = (1-sqrt(1-iCom.porosity))*iCom.porosity*(1/(iCom.porosity-1+1/k_G[i]) + k_rad[i])+ sqrt(1-iCom.porosity)*(Phi*k_p[i]+(1-Phi)*k_c[i]);

  lambda_eff_0[i] = k_bed[i]*fluid[i].transp.lambda;

  end for;

  lambda_eff_axial = lambda_eff_0;

  lambda_eff_radial = lambda_eff_0;


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>effective thermal conductivity of packed bed at stagnant fluid according to model by Zehner/Bauer/Schl&uuml;nder</p>
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
<p>German Association of Engineers, Heat Atlas, 11th ed., 2013., section Dee</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end ZehnerBauerSchluender;
