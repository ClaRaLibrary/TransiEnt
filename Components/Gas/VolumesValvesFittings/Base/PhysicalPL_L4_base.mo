within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
partial model PhysicalPL_L4_base "VLE|| Physical pressure loss|| base"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L4;

  import Modelica.Constants.R;
  import Modelica.Constants.pi;
  import Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Diameter diameter_FM[geo.N_cv+1]=sqrt(4*(geo.A_cross_FM/geo.N_tubes)/pi) "Diameter";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Height k=simCenter.roughnessGasPipes "Absolute roughness" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real MIN=Modelica.Constants.eps "Limiter" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_con IN_con[geo.N_cv + 1](
    each roughness=Modelica.Fluid.Dissipation.Utilities.Types.Roughness.Considered,
    each d_hyd=geo.diameter_hyd[1],
    L=if not frictionAtInlet and not frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[1] - geo.Delta_x_FM[geo.N_cv + 1])
      elseif not frictionAtInlet and frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[1])
      elseif frictionAtInlet and not frictionAtOutlet then geo.Delta_x_FM*geo.length/(geo.length - geo.Delta_x_FM[geo.N_cv + 1])
      else geo.Delta_x_FM,
    each K=k);

  Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_IN_var IN_var[geo.N_cv + 1](eta=eta, rho=rho);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.Velocity velocity[geo.N_cv + 1] "Velocity, just for information";
  Real Re[geo.N_cv + 1] "Reynolds number, just for information";
  Modelica.SIunits.Density rho[geo.N_cv + 1] "Density";
  Modelica.SIunits.DynamicViscosity eta[geo.N_cv + 1] "Dynamic Viscosity";
  Modelica.SIunits.MassFlowRate m_flow_1[geo.N_cv + 1] "Mass flow rate in one tube";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  rho[2:geo.N_cv] = {smooth(1, noEvent(max(1e-6, if m_flow[i] > 0 then density_phxi(
    iCom.p[i - 1],
    iCom.h[i - 1],
    iCom.xi[i - 1, :],
    iCom.fluidPointer[i - 1]) else density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i])))) for i in 2:geo.N_cv};
  rho[1] = smooth(1, noEvent(max(1e-6, if m_flow[1] > 0 then density_phxi(
    iCom.p_in[1],
    iCom.h_in[1],
    iCom.xi_in[1, :],
    iCom.fluidPointer_in[1]) else density_phxi(
    iCom.p[1],
    iCom.h[1],
    iCom.xi[1, :],
    iCom.fluidPointer[1]))));
  rho[geo.N_cv + 1] = smooth(1, noEvent(max(1e-6, if m_flow[geo.N_cv + 1] > 0 then density_phxi(
    iCom.p[end],
    iCom.h[end],
    iCom.xi[end, :],
    iCom.fluidPointer_in[end]) else density_phxi(
    iCom.p_out[1],
    iCom.h_out[1],
    iCom.xi_out[1, :],
    iCom.fluidPointer_out[1]))));

  if not frictionAtInlet and not frictionAtOutlet then
    m_flow_1[2:geo.N_cv] = dp_overall_MFLOW(
      IN_con=IN_con[2:geo.N_cv],
      IN_var=IN_var[2:geo.N_cv],
      dp=Delta_p[2:geo.N_cv]);
    Delta_p[1]=0;
    Delta_p[geo.N_cv+1]=0;
  elseif not frictionAtInlet and frictionAtOutlet then
    m_flow_1[2:geo.N_cv+1] = dp_overall_MFLOW(
      IN_con=IN_con[2:geo.N_cv+1],
      IN_var=IN_var[2:geo.N_cv+1],
      dp=Delta_p[2:geo.N_cv+1]);
    Delta_p[1]=0;
  elseif frictionAtInlet and not frictionAtOutlet then
    m_flow_1[1:geo.N_cv] = dp_overall_MFLOW(
      IN_con=IN_con[1:geo.N_cv],
      IN_var=IN_var[1:geo.N_cv],
      dp=Delta_p[1:geo.N_cv]);
    Delta_p[geo.N_cv+1]=0;
  else
    m_flow_1 = dp_overall_MFLOW(
      IN_con=IN_con,
      IN_var=IN_var,
      dp=Delta_p);
  end if;
  m_flow=geo.N_tubes*m_flow_1;
  for i in 1:geo.N_cv + 1 loop
    velocity[i] = m_flow[i] ./ max(MIN, rho[i]*geo.A_cross_FM[i]) "Mean velocity";
    Re[i] = (rho[i]*abs(velocity[i])*diameter_FM[i]/max(MIN, eta[i])) "Reynolds number";
  end for;

  annotation (defaultConnectionStructurallyInconsistent=true,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a base class for physical pressure loss model. The structure is based on ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4 version 1.3.0.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model considers the actual pressure loss of a one-phase fluid in a pipe. The physics are implemented in Modelica.Fluid.Dissipation.PressureLoss.StraightPipe.dp_overall_MFLOW. Viscosity has to be given in extended classes.</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Sep 2019</p>
</html>"));
end PhysicalPL_L4_base;
