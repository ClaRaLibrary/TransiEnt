within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss;
partial model PressureLossBasePackedBed "Base model for pressure loss in packed beds"


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

  import SI = ClaRa.Basics.Units;
  import TILMedia.GasObjectFunctions.density_phxi;
  import Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;

  extends ClaRa.Basics.Icons.Delta_p;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

  final parameter ClaRa.Basics.Units.Length Delta_x[iCom.N_cv]=geo.Delta_x;
  final parameter ClaRa.Basics.Units.Length Delta_x_FM[iCom.N_cv + 1]=geo.Delta_x_FM "flowModel grid";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=iCom.m_flow_nom "Nominal mass flow rate";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=iCom.Delta_p_nom "Nominal pressure loss wrt. all parallel tubes";
  final parameter ClaRa.Basics.Units.Area[iCom.N_cv+1] A_cross_bed_FM = geo.A_cross_bed_FM "Cross Area of Packed Bed";

  outer parameter Boolean frictionAtInlet;
  outer parameter Boolean frictionAtOutlet;


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

 outer TILMedia.Gas_ph fluid[iCom.N_cv];
 outer TILMedia.Gas_ph fluidInlet;
 outer TILMedia.Gas_ph fluidOutlet;

 outer TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records.IComPackedBedControlVolume_L4 iCom;

 outer parameter Boolean useHomotopy;

 outer TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.PackedBedGeometry_N_cv geo;



  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  ClaRa.Basics.Units.PressureDifference Delta_p[iCom.N_cv + 1] "Pressure difference";
  ClaRa.Basics.Units.MassFlowRate m_flow[iCom.N_cv + 1] "Massflow in FlowModel cells";

  SI.PressureDifference dp_pb_V[geo.N_cv + 1] "Part of Pressure Difference caused by Viscosity";
  SI.PressureDifference dp_pb_I[geo.N_cv + 1] "Part of Pressure Difference caused by Inertia";

  SI.DensityMassSpecific rho_FM[iCom.N_cv + 1] "Density in FlowModel cells";
  SI.Velocity v_FM[geo.N_cv+1] "Superficial Velocity at cell boundary";
  SI.DynamicViscosity eta_FM[geo.N_cv+1] "Dynamic Viscosity at cell boundary";

  Real Re[geo.N_cv+1] "Reynolds Number";

equation

  /////// Calculate required media data  //////////////////
  rho_FM[2:geo.N_cv] = {smooth(1, noEvent(max(1e-6, if m_flow[i] > 0 then density_phxi(
    iCom.p[i - 1],
    iCom.h[i - 1],
    iCom.xi[i - 1, :],
    iCom.fluidPointer[i - 1]) else density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i])))) for i in 2:iCom.N_cv};
  rho_FM[1] = smooth(1, noEvent(max(1e-6, if m_flow[1] > 0 then density_phxi(
    iCom.p_in[1],
    iCom.h_in[1],
    iCom.xi_in[1, :],
    iCom.fluidPointer_in[1]) else density_phxi(
    iCom.p[1],
    iCom.h[1],
    iCom.xi[1, :],
    iCom.fluidPointer[1]))));
  rho_FM[geo.N_cv + 1] = smooth(1, noEvent(max(1e-6, if m_flow[geo.N_cv + 1] > 0 then density_phxi(
    iCom.p[end],
    iCom.h[end],
    iCom.xi[end, :],
    iCom.fluidPointer[end]) else density_phxi(
    iCom.p_out[1],
    iCom.h_out[1],
    iCom.xi_out[1, :],
    iCom.fluidPointer_out[1]))));

  for i in 2:geo.N_cv loop
 eta_FM[i] = (fluid[i-1].transp.eta + fluid[i].transp.eta)/2;
  end for;

 eta_FM[1] = (fluidInlet.transp.eta+fluid[1].transp.eta)/2;
 eta_FM[geo.N_cv+1] = (fluidOutlet.transp.eta+fluid[geo.N_cv].transp.eta)/2;

 for i in 1:geo.N_cv+1 loop

 v_FM[i] = m_flow[i]/(rho_FM[i].*A_cross_bed_FM[i]); //superficial velocity
 Delta_p[i] = dp_pb_V[i] + dp_pb_I[i];
 Re[i] = noEvent(abs(v_FM[i])) .* iCom.d_h .* rho_FM[i] ./ (iCom.porosity .* eta_FM[i]);

 end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>basic model for pressure loss in packed beds</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><br>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end PressureLossBasePackedBed;
