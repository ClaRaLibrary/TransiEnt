within TransiEnt.Storage.Heat;
package ElectricWaterHeater_constProp_L4
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
extends TransiEnt.Basics.Icons.Package;

extends TransiEnt.Basics.Icons.ThermalStoragePackage;









annotation (Icon(graphics={
        Line(
          points={{2,92},{2,-4}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,-4},{22,-12},{-16,-26},{20,-40},{2,-44},{2,-54}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134}),                           Ellipse(
          extent={{12,96},{-10,76}},
          fillColor={0,134,134},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          lineColor={0,135,135})}));
end ElectricWaterHeater_constProp_L4;
