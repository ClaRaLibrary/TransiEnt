within TransiEnt.Components.Sensors.RealGas;
model WobbeGCVSensor "Sensor calculating the Wobbe-Index and gross calorific value for for real gas mixtures"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Components.Sensors.RealGas.Base.RealGas_SensorBase;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  constant Modelica.SIunits.Density rho_air_stp=1.2931 "Density of ambient air at T=273.15 K, p=1 bar";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_start[medium.nc-1]= medium.xi_default "Initial composition";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  SI.EnergyDensity GCV_stp(displayUnit="kWh/m3") "Gross calorific value in J/m3 at STP";
  SI.MassFraction[medium.nc-1] xi(start=xi_start) "Mass fraction vector";
  Real d_stp "Relative density of fluid at STP";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealOutput W_S_stp(
     final quantity="EnergyDensity",
    displayUnit="kWh/m3",
    final unit="J/m3") "Wobbe Index of composition at STP" annotation (Placement(transformation(extent={{-100,-10},{-120,10}})));

  Modelica.Blocks.Interfaces.RealOutput GCV(
     final quantity="SpecificEnthalpy",
    displayUnit="kWh/kg",
    final unit="J/kg") "Gross calorific value" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
    TILMedia.VLEFluid_pT fluid_stp(
     p = 1.01325e5,
     T = 273.15,
     xi = xi,
     vleFluidType=medium,
     computeSurfaceTension=false,
     deactivateTwoPhaseRegion=true);

  TransiEnt.Basics.Media.RealGasGCV_xi realGasGCV_xi(realGasType=medium, xi_in=xi) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  xi = actualStream(gasPortIn.xi_outflow);

  d_stp = fluid_stp.d/rho_air_stp;

  GCV = realGasGCV_xi.GCV;

  W_S_stp = fluid_stp.d*GCV / sqrt(d_stp);
  GCV_stp = fluid_stp.d*GCV;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
       Polygon(
         points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
         lineColor={27,36,42},
         smooth=Smooth.Bezier,
         lineThickness=0.5),
       Line(
         points={{0,-40},{0,-100}},
         color={27,36,42},
         thickness=0.5,
         smooth=Smooth.None),
       Text(
         extent={{-100,24},{100,-16}},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
         textString="%name"),
       Line(
         points={{-96,-100},{98,-100}},
         color={255,255,0},
         thickness=0.5),
        Text(
          extent={{-100,44},{100,74}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if W_S_stp > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" W_S_stp ", realString(W_S_stp/3.6e6, 1,1)+" kWh/m3 i.N.")),
        Text(
          extent={{-102,76},{98,106}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if GCV_stp > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" GCV_stp ", realString(GCV_stp/3.6e6, 1,1)+" kWh/m3 i.N.")),
       Line(
         points={{0,30},{-3.06156e-015,10}},
         color={27,36,42},
          origin={110,0},
          rotation=90)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gross Wobbe index and gross calorific value sensor for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Can only be used for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>GasPortIn, GasPortOut and RealOutputs for Wobbe index and GCV.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>Gross Wobbe index in J/m3 stp</p>
<p>GCV in J/kg</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>GCV = sum(xi_i*GCV_i)</p>
<p>W_S_stp = GCV*rho_stp/sqrt(rho_stp/rho_air_stp)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Gross calorific values of the pure components are defined in the record TransiEnt.Basics.Records.GasProperties.GrossCalorificValues.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Lisa Andresen (andresen@tuhh.de) in Jun 2016</span></p>
</html>"));
end WobbeGCVSensor;