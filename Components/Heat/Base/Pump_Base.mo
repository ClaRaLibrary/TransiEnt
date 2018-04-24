within TransiEnt.Components.Heat.Base;
partial model Pump_Base "Base class for pumps"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

//copied from ClaRa.Components.TurboMachines.Pumps.Pump_Base, version 1.3.0
//exchanged ports and SimCenter

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;
  extends ClaRa.Basics.Icons.Pump;
  //extends Modelica.Icons.UnderConstruction;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                         annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{45,-61},{47,-59}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=fluidPortIn.p,
    h=homotopy(actualStream(fluidPortIn.h_outflow), inStream(fluidPortIn.h_outflow))) annotation (Placement(transformation(extent={{-88,-12},{-68,8}})));
  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    h=homotopy(actualStream(fluidPortOut.h_outflow), fluidPortOut.h_outflow)) annotation (Placement(transformation(extent={{66,-10},{86,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.Pressure Delta_p "Pressure difference between pressure side and suction side";
  SI.VolumeFlowRate V_flow "Volume flow rate";
  SI.Power P_hyd;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  eye_int[1].m_flow =-fluidPortOut.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p =fluidPortOut.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-60},{46,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(graphics));
end Pump_Base;
