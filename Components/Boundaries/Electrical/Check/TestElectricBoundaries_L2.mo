within TransiEnt.Components.Boundaries.Electrical.Check;
model TestElectricBoundaries_L2 "Minimal example for electric boundaries with interface L2"
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  ApparentPower.ApparentPower Consumer(
    useInputConnectorP=false,
    P_el_set_const=3e3,
    useInputConnectorQ=false,
    cosphi_boundary=0.8) annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  ApparentPower.FrequencyVoltage ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=400) annotation (Placement(transformation(extent={{-36,-10},{-56,10}})));
equation
  connect(ElectricGrid.epp, Consumer.epp) annotation (Line(points={{-35.9,-0.1},{-2.95,-0.1},{27.9,-0.1}}, color={0,127,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{18,76},{92,64}},
          lineColor={28,108,200},
          textString="Look at:
ElectricGrid.epp.P
ElectricGrid.epp.Q")}));
end TestElectricBoundaries_L2;
