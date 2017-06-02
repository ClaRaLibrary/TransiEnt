within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump_fluidport
  import TransiEnt;
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
  extends PartialHeatPump;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterIn(Medium=medium) annotation (Placement(transformation(extent={{90,-68},{110,-48}}), iconTransformation(extent={{92,-68},{110,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterOut(Medium=medium) annotation (Placement(transformation(extent={{92,30},{112,50}}), iconTransformation(extent={{92,30},{112,50}})));
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatFlowBoundary constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={78,6})));
  parameter SI.Pressure delta_p=0;
equation
  connect(heatFlowBoundary.fluidPortOut, waterOut) annotation (Line(
      points={{85.84,12.88},{85.84,40},{102,40}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, waterIn) annotation (Line(
      points={{85.84,0.08},{85.84,-58},{100,-58}},
      color={175,0,0},
      thickness=0.5));
end PartialHeatPump_fluidport;
