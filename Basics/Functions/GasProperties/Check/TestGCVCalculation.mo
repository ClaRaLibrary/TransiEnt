within TransiEnt.Basics.Functions.GasProperties.Check;
model TestGCVCalculation "Tester for adaptive gross calorific value calculation"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2)
                                                                                                    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  parameter SI.Temperature T=273.15 "Temperature of the gas";
  parameter SI.Pressure p=101325 "Pressure of the gas";

  SI.SpecificEnthalpy GCVreal_x "Net calorific value calculated from molar fractions for real gases";
  SI.SpecificEnthalpy GCVreal_xi "Net calorific value calculated from mass fractions for real gases";

  SI.SpecificEnthalpy GCVideal_x "Net calorific value calculated from molar fractions for real gases";
  SI.SpecificEnthalpy GCVideal_xi "Net calorific value calculated from mass fractions for real gases";

    //table for discrete raise of hydrogen content
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation gasCompositionByWtFractions_linearVariation(xi_start=simCenter.gasModel1.xi_default) annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));
protected
  TILMedia.VLEFluid_pT realGas(
    p=p,
    T=T,
    xi=gasCompositionByWtFractions_linearVariation.xi,
    vleFluidType=simCenter.gasModel1)                  annotation (Placement(transformation(extent={{-96,-18},{-76,2}})));
protected
  TILMedia.Gas_pT idealGas(
    p=p,
    T=T,
    xi=gasCompositionByWtFractions_linearVariation.xi,
    gasType=simCenter.gasModel2) annotation (Placement(transformation(extent={{-96,-44},{-76,-24}})));
public
  TransiEnt.Basics.Media.RealGasGCV_xi realGasGCV_xi(
    xi_in=realGas.xi,
    GCVIn=0,
    realGasType=simCenter.gasModel1) annotation (Placement(transformation(extent={{-36,-46},{-16,-26}})));
equation

  //function call
  GCVreal_x =TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xM(
    realGasType=simCenter.gasModel1,
    x_in=realGas.x,
    M_in=realGas.M,
    GCVIn=0);

  GCVreal_xi =TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
    realGasType=simCenter.gasModel1,
    xi_in=realGas.xi,
    GCVIn=0);

  //function call
  GCVideal_x =TransiEnt.Basics.Functions.GasProperties.getIdealGasGCV_xM(
    idealGasType=simCenter.gasModel2,
    x_in=idealGas.x,
    M_in=idealGas.M,
    GCVIn=0);

  GCVideal_xi =TransiEnt.Basics.Functions.GasProperties.getIdealGasGCV_xi(
    idealGasType=simCenter.gasModel2,
    xi_in=idealGas.xi,
    GCVIn=0);

  annotation (experiment(StopTime=1e+006), __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),                                                                  graphics));
end TestGCVCalculation;
