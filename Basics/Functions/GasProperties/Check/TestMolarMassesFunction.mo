within TransiEnt.Basics.Functions.GasProperties.Check;
model TestMolarMassesFunction
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

  inner TransiEnt.SimCenter simCenter(                             redeclare TILMedia.GasTypes.MoistAirMixture
                                           airModel, redeclare Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  parameter TILMedia.GasTypes.BaseGas gasType = simCenter.airModel;
  parameter Real[:] xi = gasType.xi_default;

  Real[:] M_i=Basics.Functions.GasProperties.getMolarMasses_idealGas(gasType, gasType.nc_propertyCalculation);
//  Real M_i = TILMedia.GasFunctions.molarMass_n(gasType, 0);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestMolarMassesFunction;
