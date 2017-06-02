within TransiEnt.Basics.Media.Gases.Check;
model TestMediaRecords
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
  parameter Modelica.SIunits.Pressure p_start=1.014e5+16e5;
  Modelica.SIunits.Temperature T;
  Modelica.SIunits.Pressure p;

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

  TILMedia.VLEFluid_pT vleFluid_H2_pT(
      deactivateTwoPhaseRegion=true,
      p=p,
      T=T,
    redeclare VLE_VDIWA_H2 vleFluidType)
                       annotation (Placement(transformation(extent={{-84,36},{-64,56}})));

   TILMedia.VLEFluid_pT vleFluid_NG7_pT(
       p=p,
       T=T,
       deactivateTwoPhaseRegion=true,
      redeclare VLE_VDIWA_NG7_H2_var vleFluidType)
             annotation (Placement(transformation(extent={{-54,36},{-34,56}})));

   TILMedia.VLEFluid_pT vleFluid_H2SRK_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_H2_SRK vleFluidType)
                        annotation (Placement(transformation(extent={{-26,36},{-6,56}})));

   TILMedia.VLEFluid_pT vleFluid_NG7SRK_pT(
         deactivateTwoPhaseRegion=true,
         p=p,
         T=T,
       redeclare VLE_VDIWA_NG7_H2_SRK_var vleFluidType)
                          annotation (Placement(transformation(extent={{-84,12},{-64,32}})));
   TILMedia.VLEFluid_pT vleFluid_CH4_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_CH4 vleFluidType)
                        annotation (Placement(transformation(extent={{-56,12},{-36,32}})));
   TILMedia.VLEFluid_pT vleFluid_CH4SRK_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_CH4_SRK vleFluidType)
                        annotation (Placement(transformation(extent={{-26,12},{-6,32}})));
   TILMedia.VLEFluid_pT vleFluid_CH4_H2_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_CH4_H2_var vleFluidType)
                        annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
   TILMedia.VLEFluid_pT vleFluid_NG7_SG_O2_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_NG7_SG_O2_var vleFluidType)
                        annotation (Placement(transformation(extent={{-54,-12},{-34,8}})));
   TILMedia.VLEFluid_pT vleFluid_NG7_SG_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_NG7_SG_var vleFluidType)
                        annotation (Placement(transformation(extent={{-26,-12},{-6,8}})));
   TILMedia.VLEFluid_pT vleFluid_SG4_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_SG4_var vleFluidType)
                        annotation (Placement(transformation(extent={{-84,-40},{-64,-20}})));
   TILMedia.VLEFluid_pT vleFluid_SG6_pT(
       deactivateTwoPhaseRegion=true,
       p=p,
       T=T,
     redeclare VLE_VDIWA_SG6_var vleFluidType)
                        annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));

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
equation
  p=p_ramp.y;
  T=T_ramp.y;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-98,96},{94,50}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Note that enthalpies are zero at reference state (STP: 273.15 K, 1e5 Pa)")}),
    experiment(StopTime=130));
end TestMediaRecords;