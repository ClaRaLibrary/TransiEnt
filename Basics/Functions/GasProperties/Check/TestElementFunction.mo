within TransiEnt.Basics.Functions.GasProperties.Check;
model TestElementFunction
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

  parameter TILMedia.GasTypes.BaseGas gasType = simCenter.exhaustGasModel;
  parameter Real[:] xi = gasType.xi_default;

  Modelica.SIunits.MassFlowRate m_flow=1;
  Real[:] n_flow=Basics.Functions.GasProperties.comps2Elements_idealGas(
      gasType,
      xi,
      m_flow) "[C,H,O,N,S,Ar]";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestElementFunction;
