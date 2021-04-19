within TransiEnt.Components.Gas.Reactor.Base;
partial model PartialFixedBedReactorRealGas_L1 "Partial model for L1 reactor models using real gases"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.FixedBedReactor_L2;
  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_var medium "Medium in the reactor" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer N_reac "Number of reactions" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MolarEnthalpy Delta_H[N_reac] "Reaction enthalpy for the reactions in J/mol" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference pressureLoss "Pressure loss over the reactor" annotation(Dialog(group="Fundamental Definitions"));
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

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    xi=noEvent(actualStream(gasPortIn.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=noEvent(actualStream(gasPortOut.h_outflow)),
    xi=noEvent(actualStream(gasPortOut.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{70,-12},{90,8}})));
public
  inner Summary summary(
    outline(Q_reac=Q_reac),
    gasPortIn(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortIn.xi_outflow)),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=noEvent(actualStream(gasPortIn.h_outflow)),
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortOut.xi_outflow)),
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=noEvent(actualStream(gasPortOut.h_outflow)),
      rho=gasOut.d)) annotation (Placement(transformation(extent={{-100,-114},{-80,-94}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________


protected
  SI.HeatFlowRate Q_reac "Heat flow rate because of reactions (negative for exothermic reactions)";

  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.HeatFlowRate Q_reac "Heat flow rate created by reactions";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //no changes for reverse flow
  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow=inStream(gasPortOut.xi_outflow);

  //pressure loss
  gasPortIn.p=gasPortOut.p+pressureLoss;

  //no mass storage
  gasPortIn.m_flow+gasPortOut.m_flow=0;

  //energy balance
  gasPortIn.m_flow*inStream(gasPortIn.h_outflow)+gasPortOut.m_flow*gasPortOut.h_outflow=Q_reac;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This partial model represents an adiabatic simple fixed bed reactor without a volume. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model only works in design flow direction and a constant pressure loss is assumed. The heat of reaction is considered in the energy balances and there is no volume. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Stationary mass and energy balances considering the heat of reactions are used.</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The model only works in design flow direction. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Diagram(graphics,
                                                                                           coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialFixedBedReactorRealGas_L1;
