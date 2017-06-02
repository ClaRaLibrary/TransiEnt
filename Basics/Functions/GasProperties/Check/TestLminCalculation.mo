within TransiEnt.Basics.Functions.GasProperties.Check;
model TestLminCalculation "tester for minimum air mass calculation"
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  //import gasModel from modelproterties
  parameter TILMedia.GasTypes.BaseGas FuelMedium_gas = simCenter.gasModel2;

  //calculated minimum air mass needed per kg fuel
  Real L_min_gas=L_idealGas(
      FuelMedium_gas,
      1,
      FuelMedium_gas.xi_default);

  inner TransiEnt.SimCenter simCenter(redeclare Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2)                  annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

end TestLminCalculation;
