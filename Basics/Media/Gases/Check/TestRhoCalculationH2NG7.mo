within TransiEnt.Basics.Media.Gases.Check;
model TestRhoCalculationH2NG7

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  parameter Modelica.Units.SI.Temperature T_start=283.15;
  parameter Modelica.Units.SI.Pressure p_start=1.013e5 + 16e5;
  Modelica.Units.SI.Temperature T;
  Modelica.Units.SI.Pressure p;

  TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 H2;
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var NG7;

  parameter Modelica.Units.SI.Density rho_H2_ph=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      H2,
      p_start,
      0,
      H2.xi_default);
  parameter Modelica.Units.SI.Temperature T_H2_ph=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      H2,
      p_start,
      0,
      H2.xi_default);
  Modelica.Units.SI.Density rho_H2_ph_var=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      H2,
      p,
      vleFluid_H2_pT.h,
      H2.xi_default);
  parameter Modelica.Units.SI.Density rho_H2_pT=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi(
      H2,
      p_start,
      T_start,
      H2.xi_default);
  parameter Modelica.Units.SI.SpecificEnthalpy h_H2_pT=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      H2,
      p_start,
      T_start,
      H2.xi_default);
  parameter Modelica.Units.SI.Density rho_NG7_ph=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      NG7,
      p_start,
      0,
      NG7.xi_default);
  parameter Modelica.Units.SI.Temperature T_NG7_ph=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      NG7,
      p_start,
      0,
      NG7.xi_default);
  Modelica.Units.SI.Density rho_NG7_ph_var=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      NG7,
      p,
      vleFluid_NG7_pT.h,
      NG7.xi_default);
  parameter Modelica.Units.SI.Density rho_NG7_pT=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi(
      NG7,
      p_start,
      T_start,
      NG7.xi_default);
  parameter Modelica.Units.SI.SpecificEnthalpy h_NG7_pT=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      NG7,
      p_start,
      T_start,
      NG7.xi_default);

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluid_H2_ph(
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_H2 vleFluidType,
    h=vleFluid_H2_pT.h,
    p=p) annotation (Placement(transformation(extent={{-86,10},{-66,30}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_H2_pT(
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_H2 vleFluidType,
    p=p,
    T=T) annotation (Placement(transformation(extent={{-46,10},{-26,30}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluid_NG7_ph(
    h=vleFluid_NG7_pT.h,
    vleFluidType=NG7,
    p=p,
    deactivateTwoPhaseRegion=true,
    xi=NG7.xi_default) annotation (Placement(transformation(extent={{-86,-32},{-66,-12}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_NG7_pT(
    vleFluidType=NG7,
    p=p,
    T=T,
    deactivateTwoPhaseRegion=true,
    xi=NG7.xi_default) annotation (Placement(transformation(extent={{-46,-32},{-26,-12}})));

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

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_H2_pT1(
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_H2 vleFluidType,
    p=1701300,
    T=282.48) annotation (Placement(transformation(extent={{-46,36},{-26,56}})));
equation
  p=p_ramp.y;
  T=T_ramp.y;

    annotation (Icon(graphics,
                     coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-98,96},{94,50}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Note that enthalpies are zero at reference state (STP: 273.15 K, 1e5 Pa)")}),
    experiment(StopTime=130),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for Rho Calculation of H2NG7 </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestRhoCalculationH2NG7;
