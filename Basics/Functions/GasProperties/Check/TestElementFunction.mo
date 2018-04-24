within TransiEnt.Basics.Functions.GasProperties.Check;
model TestElementFunction
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
