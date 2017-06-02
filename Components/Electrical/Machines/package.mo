within TransiEnt.Components.Electrical;
package Machines "Eletric Machines (asynchronous and synchronous generators and motors)"
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
                  extends TransiEnt.Basics.Icons.Package;























annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
        Polygon(
          origin={14.835,58},
          fillPattern=FillPattern.Solid,
          points={{-70,-90},{-60,-90},{-26.835,-66},{9.165,-66},{35.165,-90},{
              49.165,-90},{49.165,-100},{-70,-100},{-70,-90}}),
        Rectangle(
          origin={113,26},
          fillColor={128,128,128},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-68,-36},{-51,36}}),
        Rectangle(
          origin={-4.0825,26},
          fillColor={0,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-50.0825,-36},{50.0825,36}},
          lineColor={0,0,0}),
        Rectangle(
          origin={-134.165,26},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{60,-10},{80,10}})}));
end Machines;