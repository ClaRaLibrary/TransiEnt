within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base;
partial model PartialHeatPumpSystemDSM "Partial model of a controlled heat pump model useable for large pool simulations in demand side management scenarios"

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

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

extends TransiEnt.Producer.Heat.Power2Heat.Base.PartialHeatPumpSystemModel(       redeclare HeatPumpSystemPropertiesMatrix params(A=A));

  parameter Real[params.nPar] A "Input matrix full of real values";

    Modelica.Blocks.Interfaces.BooleanInput isLoadShedding annotation (Placement(transformation(extent={{-112,-10},{-94,8}})));
  annotation (defaultComponentName="HeatPumpSystem", Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),  Polygon(
          origin={24,14},
          lineColor={78,138,73},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}}),
        Text(
          extent={{-150,-103},{150,-143}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-40,44},{40,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-50,12},{-46,12},{-32,12},{-40,0},{-32,-10},{-50,-10},{-40,0},{-50,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,52},{18,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-36},{20,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,14},{54,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-6},{40,14},{50,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,26},{-22,-20},{26,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-18},{-18,-10},{-6,8},{-4,10},{4,16},{14,20},{22,20}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialHeatPumpSystemDSM;
