within TransiEnt.Basics.Adapters.Gas;
model RealNG7_to_RealSG4 "Adapter that switches from real NG7 to real SG4 fluid models"


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

  extends TransiEnt.Basics.Icons.RealToRealAdapter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter Media.Gases.VLE_VDIWA_SG4_var medium_sg4                   constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid
                                                                 "SG4 fluid model"                                                   annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
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

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_ng7_H2) "Input for ng7_H2_var" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium_sg4) "Output for SG4_var" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium_ng7_H2,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium_sg4,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    h=gasPortOut.h_outflow,
    p=gasPortOut.p,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{50,-12},{70,8}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  gasPortIn.p=gasPortOut.p;
  gasPortIn.m_flow+gasPortOut.m_flow=0;

  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow=ones(medium_ng7_H2.nc - 1);

  gasPortOut.xi_outflow[1]=inStream(gasPortIn.xi_outflow[1]);
  gasPortOut.xi_outflow[2]=inStream(gasPortIn.xi_outflow[6]);
  gasPortOut.xi_outflow[3]=0;

  gasIn.T = gasOut.T;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,80},{0,20}},
          lineColor={0,0,0},
          textString="Real
NG7_H2"),
        Text(
          extent={{0,-20},{100,-80}},
          lineColor={0,0,0},
          textString="Real
SG4")}),
Documentation(info="<html>
<h4>Adapter for switching from real gas NG7_H2_var to real gas SG4_var fluid models</h4>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an adapter to switch from NG7_H2_var to real gas SG4_var fluid models. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Temperature, pressure and mass flow stay the same. The model only works in the design flow direction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for one-phase real gas NG7_H2_var and real gas SG4_var fluid models. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet port for real gas NG7_H2_var </p>
<p>gasPortOut: outlet port for real gas SG4_var</p>
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
end RealNG7_to_RealSG4;
