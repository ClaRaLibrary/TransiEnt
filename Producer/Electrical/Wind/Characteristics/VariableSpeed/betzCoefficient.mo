within TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed;
function betzCoefficient "Approximation function for betz coefficient based on six parameters (see Heier2009, page 39)"

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



  extends TransiEnt.Basics.Icons.Function;
  input TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.BetzCoefficientApproximation param "Coefficients for approximation (turbine characteristic)" annotation (choicesAllMatching=true);
  input Real lambda "Tip speed ratio";
  input Real beta "Pitch angle";
  output Real cp "Betz factor";

protected
  constant Real x = 1.5;
  Real lambda1;

algorithm
  lambda1 := 1 / (1 / (lambda + 0.08*beta) - 0.0225 / (beta^3 + 1));
  cp := max(0, param.c[1] * (param.c[2] / lambda1 - param.c[3] * beta - param.c[4]*beta^x-param.c[5]) * exp(-param.c[6] / lambda1));

end betzCoefficient;
