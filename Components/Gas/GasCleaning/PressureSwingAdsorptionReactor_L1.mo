within TransiEnt.Components.Gas.GasCleaning;
model PressureSwingAdsorptionReactor_L1 "Pressure swing adsorption reactor with constant efficiency of hydrogen separation"



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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.PSA;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Basics.Media.Gases.VLE_VDIWA_SG6_var medium "Medium in the pressure swing adsorber";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.PressureDifference pressureLoss=0.2e5 "Pressure loss in H2 flow direction" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_h2 = 0.8 "Efficiency of hydrogen separation" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_hydrogen(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_offGas(Medium=medium) annotation (Placement(transformation(extent={{50,60},{70,80}}), iconTransformation(extent={{50,60},{70,80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    vleFluidType=medium,
    p=gasPortIn.p,
    h=inStream(gasPortIn.h_outflow),
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut_hydrogen(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    vleFluidType=medium,
    p=gasPortOut_hydrogen.p,
    h=gasPortOut_hydrogen.h_outflow,
    xi=gasPortOut_hydrogen.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut_offGas(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    vleFluidType=medium,
    p=gasPortOut_offGas.p,
    h=gasPortOut_offGas.h_outflow,
    xi=gasPortOut_offGas.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,58},{10,78}})));
public
  inner Summary summary(
    outline(pressureLoss=pressureLoss, eta_h2=eta_h2),
    gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut_hydrogen(
      mediumModel=medium,
      xi=gasOut_hydrogen.xi,
      x=gasOut_hydrogen.x,
      m_flow=-gasPortOut_hydrogen.m_flow,
      T=gasOut_hydrogen.T,
      p=gasPortOut_hydrogen.p,
      h=gasOut_hydrogen.h,
      rho=gasOut_hydrogen.d),
    gasPortOut_offGas(
      mediumModel=medium,
      xi=gasOut_offGas.xi,
      x=gasOut_offGas.x,
      m_flow=-gasPortOut_offGas.m_flow,
      T=gasOut_offGas.T,
      p=gasPortOut_offGas.p,
      h=gasOut_offGas.h,
      rho=gasOut_offGas.d)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.MassFraction sum_xi_offGas "Sum of the off gas components' xi's in gasIn";

  model Outline
    input SI.PressureDifference pressureLoss "Pressure loss in hydrogen flow direction";
    input SI.Efficiency eta_h2 "Efficiency of hydrogen separation";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut_hydrogen;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut_offGas;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //mass balance
  gasPortIn.m_flow + gasPortOut_hydrogen.m_flow + gasPortOut_offGas.m_flow = 0;
  gasPortOut_hydrogen.m_flow = -eta_h2*gasIn.xi[4]*gasPortIn.m_flow;

  //pressure
  gasPortOut_hydrogen.p = gasPortIn.p - pressureLoss;

  //adiabatic
  gasOut_hydrogen.T = gasIn.T;
  gasOut_offGas.T = gasIn.T;

  //components
  //gasOut_hydrogen
  gasOut_hydrogen.xi[1:3] = zeros(3);
  gasOut_hydrogen.xi[4] = 1; //only hydrogen
  gasOut_hydrogen.xi[5] = 0;
  //gasOut_offGas
  sum_xi_offGas = 1-eta_h2*gasIn.xi[4];
  for i in {1,2,3,5} loop
    gasOut_offGas.xi[i] = gasIn.xi[i]/sum_xi_offGas;
  end for;
  gasOut_offGas.xi[4] = (1 - eta_h2)*gasIn.xi[4]/sum_xi_offGas;

  //reverse flow
  gasPortIn.h_outflow = inStream(gasPortOut_hydrogen.h_outflow);
  gasPortIn.xi_outflow = inStream(gasPortOut_hydrogen.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a simple model for a pressure swing adsorption reactor which separates hydrogen out of a stream. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The process is modeled continuously so the continuous stream is separated into hydrogen and the off-gas. A constant hydrogen recovery rate is given by a parameter. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The model is only valid if several actual pressure swing adsorption reactors are combined and operated in a way that the overall process is continuous. Also the hydrogen recovery rate has to be almost constant and independent of pressure, temperature, composition etc. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut_hydrogen: real gas outlet of the hydrogen</p>
<p>gasPortOut_offGas: real gas outlet of the off gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The outgoing hydrogen mass flow is calculated using the incoming mass flow, composition and recovery rate. The remaining mass fractions and the mass flow rate are scaled under consideration of the separated hydrogen mass flow rate. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The model only works in design flow direction. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in the check model &quot;TestPressureSwingAdsorptionReactor_L1&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
</html>"));
end PressureSwingAdsorptionReactor_L1;
