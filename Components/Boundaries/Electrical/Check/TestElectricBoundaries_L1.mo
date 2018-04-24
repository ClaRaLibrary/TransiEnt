within TransiEnt.Components.Boundaries.Electrical.Check;
model TestElectricBoundaries_L1 "Minimal example for electric boundaries with interface L1"
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  Power Consumer(useInputConnectorP=false, P_el_set_const=3e3) annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Frequency ElectricGrid annotation (Placement(transformation(extent={{-36,-10},{-56,10}})));
equation
  connect(ElectricGrid.epp, Consumer.epp) annotation (Line(
      points={{-35.9,-0.1},{-1.95,-0.1},{27.9,-0.1}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{22,78},{96,66}},
          lineColor={28,108,200},
          textString="Look at:
ElectricGrid.epp.P
ElectricGrid.epp.f")}));
end TestElectricBoundaries_L1;
