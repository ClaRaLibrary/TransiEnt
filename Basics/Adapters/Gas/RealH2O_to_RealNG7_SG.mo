within TransiEnt.Basics.Adapters.Gas;
model RealH2O_to_RealNG7_SG "Adapter that switches from real H2O to real NG7_SG fluid models"

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

  extends TransiEnt.Basics.Icons.FluidToRealAdapter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TILMedia.VLEFluidTypes.TILMedia_Water medium_water constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "H2O fluid model" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable parameter Media.Gases.VLE_VDIWA_NG7_SG_var medium_ng7_sg constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "NG7 SG fluid model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=medium_water) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium_ng7_sg) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph waterIn(
  vleFluidType=medium_water,
  h=inStream(waterPortIn.h_outflow),
  p=waterPortIn.p,
  xi=inStream(waterPortIn.xi_outflow)) annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));

  TILMedia.VLEFluid_ph gasOut(
  vleFluidType=medium_ng7_sg,
  h=gasPortOut.h_outflow,
  p=gasPortOut.p,
  xi=gasPortOut.xi_outflow,
  deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{50,-12},{70,8}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  waterPortIn.p=gasPortOut.p;
  waterPortIn.m_flow+gasPortOut.m_flow=0;

  waterPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  waterPortIn.xi_outflow=ones(medium_water.nc-1);

  gasPortOut.xi_outflow[1:6]=zeros(6);
  gasPortOut.xi_outflow[7]=1;
  gasPortOut.xi_outflow[8]=0;

  waterIn.T=gasOut.T;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,80},{0,20}},
          lineColor={0,0,0},
          textString="Real
H2O"),  Text(
          extent={{0,-20},{100,-80}},
          lineColor={0,0,0},
          textString="Real
NG7_SG")}),
Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents an adapter to switch from VLE H2O to real gas NG7_SG fluid models. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Temperature, pressure and mass flow stay the same. The model only works in the design flow direction. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Only valid for one-phase real gas H2O and real gas NG7_SG fluid models. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>WaterPortIn: inlet port for real gas H2O </p>
<p>gasPortOut: outlet port for real gas NG7_SG </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>It is important to ensure that the flow is always in the design flow direction.</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016 </p>
</html>"));
end RealH2O_to_RealNG7_SG;