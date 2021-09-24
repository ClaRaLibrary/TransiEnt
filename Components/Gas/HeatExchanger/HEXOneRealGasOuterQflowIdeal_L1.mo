within TransiEnt.Components.Gas.HeatExchanger;
model HEXOneRealGasOuterQflowIdeal_L1 "Ideal heat exchanger for one real gas with heat port for heat flow"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.Heat_Exchanger;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the heat exchanger" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter SI.PressureDifference Delta_p=0 "Pressure loss in the medium" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_heat=293.15 "Average temperature of heat transfer" annotation(Dialog(group="Heat Transfer"));

  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary"));
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
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    vleFluidType=medium,
    p=gasPortOut.p,
    h=gasPortOut.h_outflow,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    vleFluidType=medium,
    p=gasPortIn.p,
    h=inStream(gasPortIn.h_outflow),
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
public
  inner Summary summary(
    gasPortIn(
      mediumModel=medium,
      xi=inStream(gasPortIn.xi_outflow),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=inStream(gasPortIn.h_outflow),
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasPortOut.xi_outflow,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasPortOut.h_outflow,
      rho=gasOut.d),
    heat(Q_flow=heat.Q_flow, T=heat.T)) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeHeat heat;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  heat.T=T_heat;

  //mass balances
  gasPortIn.m_flow + gasPortOut.m_flow = 0;

  //pressure
  gasPortIn.p = gasPortOut.p + Delta_p;

  //energy balances
  -heat.Q_flow =gasPortIn.m_flow*inStream(gasPortIn.h_outflow) + gasPortOut.m_flow*gasPortOut.h_outflow;
  //reverse flow
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);

  //compositions
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);
  //reverse flow
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a simple model of a heat exchanger with one real gas and a heat port. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The detailed heat transfer is not modeled, just the heat flow through the heat port is given. There are no heat losses, no limitations for heat transfer and no changes in composition of the medium. The model only works in the design flow direction. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases and it has to be checked that the temperatures at the inlet and outlet are physically plausible (see 7.).</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the medium</p>
<p>gasPortOut: Outlet of the medium</p>
<p>heat: Heat port</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids1.png\" alt=\"\"/>: Heat flow transfered from the medium to the heat port</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Energy balance:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXOneFluidOuterT.png\" alt=\"\"/></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The plausability of the temperatures at inlet and outlet of the gas and the temperature of the heat port has to be checked. They have to fit to the chosen type of heat exchanger (e.g. concurrent or countercurrent). </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end HEXOneRealGasOuterQflowIdeal_L1;
