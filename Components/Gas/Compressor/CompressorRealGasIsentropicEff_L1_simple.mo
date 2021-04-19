within TransiEnt.Components.Gas.Compressor;
model CompressorRealGasIsentropicEff_L1_simple "Simple compressor or fan for a one phase VLE fluid"

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

  // enthalpy difference is calculated using a fluid model for the isentropic compression //

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialCompressorRealGas_L1_simple(summary(outline(
                                                  eta = eta_is*eta_mech*eta_el)));

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real eta_is = 0.8 "Isentropic efficiency" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real Pi_start = 1.1 "Start value for pressure ratio (is only used for determination of start value for deltah)" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph flueGas_outlet_isentropic(
    h=hOut_is,
    p=gasPortOut.p,
    xi=gasIn.xi,
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{30,-32},{50,-12}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.SpecificEnthalpy deltah(start=-15727*Pi_start^2+140258*Pi_start-124060)  "Specific enthalpy difference between outlet and inlet" annotation (Dialog(showStartAttribute=true));
  SI.SpecificEnthalpy hOut_is "Specific enthalpy after an isentropic compression";
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  hOut =gasIn.h + deltah;
  P_hyd =deltah*gasPortIn.m_flow;
  flueGas_outlet_isentropic.s =gasIn.s;
  eta_is =(hOut_is - gasIn.h)/deltah;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

               annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a compressor for real gases. It is a modified version of the model ClaRa.Components.TurboMachines.Compressors.CompressorGas_L1_simple from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model was changed to work with real gases and mechanical and electrical efficiencies were added. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases and positive pressure differences. Variable efficiencies and time-dependent behavior are not considered.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<p>m_flow_in: input for mass flow rate in [kg/s]</p>
<p>V_flow_in: input for volume flow rate in [m3/s]</p>
<p>P_el_in: input for electrical power in [W]</p>
<p>dp_in: input for pressure difference in [Pa]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The electrical power is determined using the mechanical and electrical efficiencies.</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation_CompressorRealGasesIsentropicEff.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Sep 20 2016</p>
</html>"));
end CompressorRealGasIsentropicEff_L1_simple;
