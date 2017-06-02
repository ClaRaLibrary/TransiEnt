within TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed;
function betzCoefficient "Approximation function for betz coefficient based on six parameters (see Heier2009, page 39)"
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