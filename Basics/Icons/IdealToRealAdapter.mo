within TransiEnt.Basics.Icons;
partial model IdealToRealAdapter "Icon for ideal to real adapters"
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

extends TransiEnt.Basics.Icons.Model;

annotation (Icon(graphics={
      Polygon(
          origin={20,0},
          lineColor={150,150,150},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{70.0,20.0},{70.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}),
      Polygon(
          lineColor={150,150,150},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          points={{-90,20},{-60,20},{-30,70},{-10,70},{-10,-70},{-30,-70},{-60,-20},{-90,-20}})}),
                            Documentation(info="<html>
            <p>This icon indicates ideal to real adapter models.</p>
            </html>"));

end IdealToRealAdapter;
