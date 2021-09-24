within TransiEnt.Basics.Adapters.Gas;
model RealNG7_to_RealNG7_SG_O2 "Adapter that switches from real ng7 to real ng7_sg_o2 fluid models"


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
  import Modelica.Constants.eps;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var medium_ng7 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable parameter Media.Gases.VLE_VDIWA_NG7_SG_O2_var medium_ng7_sg_o2 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_ng7) "Input for NG7" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium_ng7_sg_o2) "Output for NG7_SG_02" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium_ng7,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium_ng7_sg_o2,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
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

  gasPortIn.p=gasPortOut.p;
  gasPortIn.m_flow+gasPortOut.m_flow=0;

  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow=zeros(medium_ng7.nc-1);

  gasPortOut.xi_outflow[1:6]=inStream(gasPortIn.xi_outflow[1:6]); //CH4,C2H6,C3H8,C4H10,N2,CO2
  gasPortOut.xi_outflow[7:9]=zeros(3); //H2O,CO,O2

  gasIn.T=gasOut.T;

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
NG7_H2"),
        Text(
          extent={{0,-20},{100,-80}},
          lineColor={0,0,0},
          textString="Real
NG7_SG_O2")}),
Documentation(info="<html>
<h4>Adapter for switching from real gas NG7 to real gas NG7_SG_O2 fluid models</h4>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an adapter to switch from real gas NG7 to real gas NG7_SG_O2 fluid models. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>OTemperature, pressure and mass flow stay the same. The model only works in the design flow direction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gas NG7 and real gas NG7_SG_O2 fluid models. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet port for real gas NG7 </p>
<p>gasPortOut: outlet port for real gas NG7_SG_O2 </p>
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
end RealNG7_to_RealNG7_SG_O2;
