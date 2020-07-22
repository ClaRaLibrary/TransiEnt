within TransiEnt.Basics.Adapters.Gas;
model RealSG4_to_RealNG7 "Adapter that switches from real SG4 to real NG7 fluid models"

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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.RealToRealAdapter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  replaceable parameter Media.Gases.VLE_VDIWA_SG4_var medium_sg4                       constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid
                                                                 "SG4_var fluid model"                                                   annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable parameter Media.Gases.VLE_VDIWA_NG7_H2_var medium_ng7_H2                          constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid
                                                                       "NG7_H2_var fluid model"                                                   annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_sg4) "Input for SG4" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium_ng7_H2) "Output for NG7_H2" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  gasPortIn.p=gasPortOut.p;
  gasPortIn.m_flow+gasPortOut.m_flow=0;

  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow=ones(medium_sg4.nc - 1);

  gasPortOut.xi_outflow[1]=inStream(gasPortIn.xi_outflow[1]);
  gasPortOut.xi_outflow[6]=inStream(gasPortIn.xi_outflow[2]);
  gasPortOut.xi_outflow[2:5]=zeros(4);

  gasPortOut.h_outflow=inStream(gasPortIn.h_outflow);
//  gasIn.T = gasOut.T;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,80},{0,20}},
          lineColor={0,0,0},
          textString="Real
SG4"),  Text(
          extent={{0,-20},{100,-80}},
          lineColor={0,0,0},
          textString="Real
NG7_H2")}),
Documentation(info="<html>
<h4>Adapter for switching from real gas SG4_var to real gas NG7_H2_var fluid models</h4>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an adapter to switch from real gas SG4_var to real gas NG7_H2_var fluid models. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Temperature, pressure and mass flow stay the same. The model only works in the design flow direction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for one-phase real gas SG4_var and real gas NG7_H2_var fluid models. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet port for real gas SG4_var</p>
<p>gasPortOut: outlet port for real gas NG7_H2_var</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>It is important to ensure that the flow is always in the design flow direction.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TestRealGasAdapters&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016 </p>
</html>"));
end RealSG4_to_RealNG7;
