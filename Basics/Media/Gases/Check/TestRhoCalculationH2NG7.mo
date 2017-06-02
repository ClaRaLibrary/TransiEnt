within TransiEnt.Basics.Media.Gases.Check;
model TestRhoCalculationH2NG7
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
  parameter Modelica.SIunits.Temperature T_start=283.15;
  parameter Modelica.SIunits.Pressure p_start=1.013e5+16e5;
  Modelica.SIunits.Temperature T;
  Modelica.SIunits.Pressure p;

  TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 H2;
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var NG7;

  parameter Modelica.SIunits.Density rho_H2_ph=TILMedia.VLEFluidFunctions.density_phxi(H2,p_start,0,H2.xi_default);
  parameter Modelica.SIunits.Temperature T_H2_ph=TILMedia.VLEFluidFunctions.temperature_phxi(H2,p_start,0,H2.xi_default);
  Modelica.SIunits.Density rho_H2_ph_var=TILMedia.VLEFluidFunctions.density_phxi(H2,p,vleFluid_H2_pT.h,H2.xi_default);
  parameter Modelica.SIunits.Density rho_H2_pT=TILMedia.VLEFluidFunctions.density_pTxi(H2,p_start,T_start,H2.xi_default);
  parameter Modelica.SIunits.SpecificEnthalpy h_H2_pT=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(H2,p_start,T_start,H2.xi_default);
  parameter Modelica.SIunits.Density rho_NG7_ph=TILMedia.VLEFluidFunctions.density_phxi(NG7,p_start,0,NG7.xi_default);
  parameter Modelica.SIunits.Temperature T_NG7_ph=TILMedia.VLEFluidFunctions.temperature_phxi(NG7,p_start,0,NG7.xi_default);
  Modelica.SIunits.Density rho_NG7_ph_var=TILMedia.VLEFluidFunctions.density_phxi(NG7,p,vleFluid_NG7_pT.h,NG7.xi_default);
  parameter Modelica.SIunits.Density rho_NG7_pT=TILMedia.VLEFluidFunctions.density_pTxi(NG7,p_start,T_start,NG7.xi_default);
  parameter Modelica.SIunits.SpecificEnthalpy h_NG7_pT=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(NG7,p_start,T_start,NG7.xi_default);

  TILMedia.VLEFluid_ph vleFluid_H2_ph(
      deactivateTwoPhaseRegion=true,
      redeclare VLE_VDIWA_H2                              vleFluidType,
      h=vleFluid_H2_pT.h,
      p=p) annotation (Placement(transformation(extent={{-86,10},{-66,30}})));

  TILMedia.VLEFluid_pT vleFluid_H2_pT(
      deactivateTwoPhaseRegion=true,
      redeclare VLE_VDIWA_H2                              vleFluidType,
      p=p,
      T=T)             annotation (Placement(transformation(extent={{-46,10},{-26,30}})));

  TILMedia.VLEFluid_ph vleFluid_NG7_ph(
     h=vleFluid_NG7_pT.h,
     vleFluidType=NG7,
     p=p,
     deactivateTwoPhaseRegion=true,
     xi=NG7.xi_default)
          annotation (Placement(transformation(extent={{-86,-32},{-66,-12}})));
  TILMedia.VLEFluid_pT vleFluid_NG7_pT(
     vleFluidType=NG7,
     p=p,
     T=T,
     deactivateTwoPhaseRegion=true,
     xi=NG7.xi_default)
           annotation (Placement(transformation(extent={{-46,-32},{-26,-12}})));

  TILMedia.Gas_ph gas_H2_ph(
       h=gas_H2_pT.h,
       p=p,
       xi=zeros(gas_H2_ph.gasType.nc - 1),
       redeclare Gas_VDIWA_NG7_H2_var gasType)
                                          annotation (Placement(transformation(extent={{4,8},{24,28}})));
  TILMedia.Gas_pT gas_H2_pT(
       p=p,
       T=T,
       xi=zeros(gas_H2_ph.gasType.nc - 1),
       redeclare Gas_VDIWA_NG7_H2_var gasType)
                                          annotation (Placement(transformation(extent={{40,8},{60,28}})));

   TILMedia.Gas_ph gas_NG7_ph(
     redeclare Gas_VDIWA_NG7_H2_var gasType,
     h=gas_NG7_pT.h,
     p=p) annotation (Placement(transformation(extent={{4,-30},{24,-10}})));
   TILMedia.Gas_pT gas_NG7_pT(
     redeclare Gas_VDIWA_NG7_H2_var gasType,
     p=p,
     T=T) annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Modelica.Blocks.Sources.Ramp T_ramp(
    height=50,
    duration=50,
    offset=T_start,
    startTime=70) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp p_ramp(
    height=80e5,
    duration=50,
    offset=p_start,
    startTime=10) annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  TILMedia.VLEFluid_pT vleFluid_H2_pT1(
      deactivateTwoPhaseRegion=true,
      redeclare VLE_VDIWA_H2                              vleFluidType,
    p=1701300,
    T=282.48)          annotation (Placement(transformation(extent={{-46,36},{-26,56}})));
equation
  p=p_ramp.y;
  T=T_ramp.y;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-98,96},{94,50}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Note that enthalpies are zero at reference state (STP: 273.15 K, 1e5 Pa)")}),
    experiment(StopTime=130));
end TestRhoCalculationH2NG7;
