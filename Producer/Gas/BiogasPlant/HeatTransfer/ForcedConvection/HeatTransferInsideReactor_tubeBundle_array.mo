within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.ForcedConvection;
model HeatTransferInsideReactor_tubeBundle_array "Model calculating the heat transfered between fluid and heating system"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Area A=Modelica.Constants.pi*d*l "Area through which heat is transported by Convection";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Diameter D=1 "inner Diameter of reactor";
  parameter Modelica.SIunits.Diameter d=0.1 "tube diameter";
  parameter Modelica.SIunits.Length l=Modelica.Constants.pi * (D-d);
  parameter Real n = 8 "number of turns of tube";
  parameter Integer N_cv = 8 "Number of control volumes";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.Producer.Gas.BiogasPlant.MaterialValues.SuspensionProperties_pT fluidProperties;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.HeatPort_a heat_solid[N_cv] annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  ClaRa.Basics.Interfaces.HeatPort_b heat_fluid annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluidWall(
    T=sum(heat_solid.T)/N_cv,
    computeTransportProperties=true,
    deactivateTwoPhaseRegion=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    p=101300) annotation (Placement(transformation(extent={{44,-10},{64,10}})));

  Modelica.SIunits.NusseltNumber Nu=
      TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.ForcedConvection.NusseltCSTR_Coil(
          Re=Re,
          Pr=fluidProperties.Pr,
          eta=fluidProperties.eta,
          eta_w=eta_w,
          C2=C2,
          D=D,
          d=d) "Nusselt Number ";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input Modelica.SIunits.ReynoldsNumber Re annotation(Dialog(group="Variables"));
  input Real C2 annotation(Dialog(group="Variables"));

  Modelica.SIunits.HeatFlowRate Q_flow[N_cv] "Heat flow rate from solid -> fluid";
  Modelica.SIunits.TemperatureDifference dT[N_cv] "= solid.T - fluid.T";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha = Nu * fluidProperties.lambda / D  "heat transfer coefficient of convection";

  Modelica.SIunits.DynamicViscosity eta_w "Dynamic Viscosity of fluid at wall temperature";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  dT =heat_solid.T .- heat_fluid.T;
  heat_solid.Q_flow = Q_flow;
  heat_fluid.Q_flow = -sum(Q_flow);
  Q_flow = A*alpha*dT;

  eta_w = fluidProperties.eta; // no temperature influence on viscosity implemented
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-76,20},{76,20}}, color={191,0,0}),
        Line(points={{-56,30},{-76,20}},
                                       color={191,0,0}),
        Line(points={{-56,10},{-76,20}},
                                       color={191,0,0}),
        Line(points={{-56,-10},{-76,-20}},
                                         color={191,0,0}),
        Line(points={{-76,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-56,-30},{-76,-20}},
                                         color={191,0,0}),
        Rectangle(
          extent={{80,80},{100,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),                   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>HeatPort_a: heat_solid</p>
<p>HeatPort_b: heat_fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Kim, Y., &amp; Parker, W. (2008). A technical and economic evaluation of the pyrolysis of sewage sludge for the production of bio-oil. Bioresource technology, 99(5), 1409-1416.</p>
<p>[2] Vesilind, P. A., &amp; Martel, C. J. (1989). Thermal conductivity of sludges. Water research, 23(2), 241-245.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end HeatTransferInsideReactor_tubeBundle_array;
