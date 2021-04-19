within TransiEnt.Producer.Heat.SolarThermal.Base;
model ScaleMassFlow "Scaling mass flow up or down or leave it"
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

  extends TransiEnt.Basics.Icons.Model;
  import SI = Modelica.SIunits;
  import Const = Modelica.Constants;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  //General
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 annotation (Dialog(tab="General", group="General"));
  parameter Integer n_parallel=1 "Number of parallel collector rows" annotation (Dialog(tab="General", group="General"));
  parameter Boolean downscale=true "true, if massflow shall be scaled down" annotation (Dialog(tab="General", group="General"));
  parameter Boolean upscale=false "true, if massflow shall be scaled up" annotation (Dialog(tab="General", group="General"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),iconTransformation(extent={{-100,-4},{-80,16}})));
  ClaRa.Basics.Interfaces.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{80,-10},{100,10}}),iconTransformation(extent={{80,-4},{100,16}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluidIn(
    vleFluidType=medium,
    p=fluidPortIn.p,
    h=h_in) annotation (Placement(transformation(extent={{-84,16},{-64,36}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph vleFluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    h=h_out) annotation (Placement(transformation(extent={{62,12},{82,32}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  h_in= if simCenter.useHomotopy then homotopy(actualStream(fluidPortIn.h_outflow), inStream(fluidPortIn.h_outflow)) else actualStream(fluidPortIn.h_outflow);
  h_out= if simCenter.useHomotopy then homotopy(actualStream(fluidPortOut.h_outflow), inStream(fluidPortOut.h_outflow)) else actualStream(fluidPortOut.h_outflow);

  if downscale and not upscale then
    fluidPortIn.m_flow + fluidPortOut.m_flow * n_parallel = 0;
  elseif upscale and not downscale then
    fluidPortIn.m_flow + fluidPortOut.m_flow / n_parallel = 0;
  else
    fluidPortIn.m_flow + fluidPortOut.m_flow = 0;
  end if;

  fluidPortIn.p = fluidPortOut.p;

  fluidPortIn.h_outflow = inStream(fluidPortOut.h_outflow);
  fluidPortIn.xi_outflow = inStream(fluidPortOut.xi_outflow);

  fluidPortOut.h_outflow = inStream(fluidPortIn.h_outflow);
  fluidPortOut.xi_outflow = inStream(fluidPortIn.xi_outflow);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculating the mass flow through one collector in the collector field.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>fluidPortIn: inlet for fluid</p>
<p>fluidPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"), Diagram(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ScaleMassFlow;
