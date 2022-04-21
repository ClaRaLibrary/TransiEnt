within TransiEnt.Basics.Media.Gases.Check;
model TestMediaRecords


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




  extends TransiEnt.Basics.Icons.Checkmodel;
  parameter Modelica.Units.SI.Temperature T_start=283.15;
  parameter Modelica.Units.SI.Pressure p_start=1.014e5 + 120e5;
  Modelica.Units.SI.Temperature T;
  Modelica.Units.SI.Pressure p;
  Modelica.Units.SI.Temperature T_ph_H2_SRK=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleFluid_H2SRK_pT.vleFluidType,
      1e5,
      vleFluid_H2SRK_pT.h);

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

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_H2_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_H2 vleFluidType) annotation (Placement(transformation(extent={{-84,36},{-64,56}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_NG7_pT(
    p=p,
    T=T,
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_NG7_H2_var vleFluidType) annotation (Placement(transformation(extent={{-54,36},{-34,56}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_H2SRK_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_H2_SRK vleFluidType) annotation (Placement(transformation(extent={{-26,36},{-6,56}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_NG7SRK_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_NG7_H2_SRK_var vleFluidType) annotation (Placement(transformation(extent={{-84,12},{-64,32}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_CH4_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_CH4 vleFluidType) annotation (Placement(transformation(extent={{-56,12},{-36,32}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_CH4SRK_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_CH4_SRK vleFluidType) annotation (Placement(transformation(extent={{-26,12},{-6,32}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_CH4_H2_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_CH4_H2_var vleFluidType) annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_NG7_SG_O2_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_NG7_SG_O2_var vleFluidType) annotation (Placement(transformation(extent={{-54,-12},{-34,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_NG7_SG_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_NG7_SG_var vleFluidType) annotation (Placement(transformation(extent={{-26,-12},{-6,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_SG4_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_SG4_var vleFluidType) annotation (Placement(transformation(extent={{-84,-40},{-64,-20}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid_SG6_pT(
    deactivateTwoPhaseRegion=true,
    p=p,
    T=T,
    redeclare VLE_VDIWA_SG6_var vleFluidType) annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));

   TILMedia.Gas_pT gas_H2_pT(
         p=p,
         T=T,
         redeclare Gas_VDIWA_NG7_H2_var gasType,
      xi=zeros(gas_H2_pT.gasType.nc - 1))   annotation (Placement(transformation(extent={{20,38},{40,58}})));

   TILMedia.Gas_pT gas_NG7_pT(
       p=p,
       T=T,
     redeclare Gas_VDIWA_NG7_H2_var gasType)
            annotation (Placement(transformation(extent={{46,38},{66,58}})));

   TILMedia.Gas_pT gas_Air_pT(
      p=p,
      T=T,
     redeclare Gas_Air gasType)
          annotation (Placement(transformation(extent={{20,16},{40,36}})));
   TILMedia.Gas_pT gas_MoistAir_pT(
      p=p,
      T=T,
     redeclare Gas_MoistAir gasType)
           annotation (Placement(transformation(extent={{46,16},{66,36}})));
   TILMedia.Gas_pT gas_ExhaustGas_pT(
      p=p,
      T=T,
     redeclare Gas_ExhaustGas gasType)
           annotation (Placement(transformation(extent={{20,-8},{40,12}})));
   TILMedia.Gas_pT gas_SG4_pT(
      p=p,
      T=T,
     redeclare Gas_VDIWA_SG4_var gasType)
           annotation (Placement(transformation(extent={{46,-8},{66,12}})));
   TILMedia.Gas_pT gas_SG6_pT(
      p=p,
      T=T,
     redeclare Gas_VDIWA_SG6_var gasType)
           annotation (Placement(transformation(extent={{20,-32},{40,-12}})));
   TILMedia.Gas_pT gas_SG7_pT(
      p=p,
      T=T,
     redeclare Gas_VDIWA_SG7_var gasType)
           annotation (Placement(transformation(extent={{46,-32},{66,-12}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluid_H2SRK_ph(
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_H2_SRK vleFluidType,
    h=vleFluid_H2SRK_pT.h,
    p=100000) annotation (Placement(transformation(extent={{2,-76},{22,-56}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluid_H2_ph(
    deactivateTwoPhaseRegion=true,
    redeclare VLE_VDIWA_H2 vleFluidType,
    h=vleFluid_H2_pT.h,
    p=100000) annotation (Placement(transformation(extent={{2,-100},{22,-80}})));
equation
  p=p_ramp.y;
  T=T_ramp.y;

    annotation (Icon(graphics,
                     coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-98,96},{94,50}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Note that enthalpies are zero at reference state (STP: 273.15 K, 1e5 Pa)"),                                 Text(
          extent={{28,-70},{98,-86}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Same enthalpy as vleFluid_H2SRK_pT
Look at change in temperature due to pressure drop:
- Joule-Thomson-Effect increases temperature of H2
- SRK EOS gives realistic temperature increase

Same enthalpy as vleFluid_H2_pT
Look at change in temperature due to pressure drop:
- Joule-Thomson-Effect increases temperature of H2
- PR EOS gives too small temperature increase
")}),
    experiment(StopTime=130),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for the media records</span></p>
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
end TestMediaRecords;
