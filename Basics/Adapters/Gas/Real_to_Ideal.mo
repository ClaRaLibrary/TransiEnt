within TransiEnt.Basics.Adapters.Gas;
model Real_to_Ideal "Adapter that switches from real to ideal fluid models"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.RealToIdealAdapter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter Media.Gases.VLE_VDIWA_SG6_var real constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Medium name of real gas model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable parameter Media.Gases.Gas_VDIWA_SG6_var ideal constrainedby TILMedia.GasTypes.BaseGas "Medium name of ideal gas model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=real) "Input for real gas" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=ideal) "Output for ideal gas" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=real,
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));

  TILMedia.Gas_ph gasOut(
    gasType=ideal,
    h=gasPortOut.h_outflow,
    p=gasPortOut.p,
    xi=gasPortOut.xi_outflow) annotation (Placement(transformation(extent={{50,-12},{70,8}})));

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

  //if noEvent(gasPortIn.m_flow>0) then
    gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  //else
    //gasPortOut.h_outflow=inStream(gasPortIn.h_outflow);
  //end if;

  gasPortIn.xi_outflow=inStream(gasPortOut.xi_outflow);

  gasPortOut.xi_outflow=inStream(gasPortIn.xi_outflow);

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
          textString="Real"),
        Text(
          extent={{0,-20},{100,-80}},
          lineColor={0,0,0},
          textString="Ideal")}),
Documentation(info="<html>
<h4>Adapter for switching from real to ideal gas fluid models</h4>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an adapter to switch from real to ideal gas fluid models. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Temperature, pressure and mass flow stay the same. The model only works in the design flow direction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real and ideal gas fluid models. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet port for real gas </p>
<p>gasPortOut: outlet port for ideal gas </p>
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
end Real_to_Ideal;
