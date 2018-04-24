within TransiEnt.Components.Gas.Engines.Mechanics;
partial model BasicEngineMechanics "Partial model for mechanical behavior of a gas engine"

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
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Mechanics;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification Specification "Record containing specific chp parameters";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(extent={{-128,-30},{-88,10}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,0})));
  Modelica.Blocks.Interfaces.BooleanInput switch annotation (Placement(transformation(extent={{-128,-80},{-88,-40}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,-50})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{86,-16},{114,12}}), iconTransformation(extent={{88,-13},{114,12}})));
  Modelica.Blocks.Interfaces.RealOutput[2] efficienciesOut= {eta_el, eta_h} "[1] = eta_el, [2] = eta_h"  annotation (Placement(
        transformation(
        extent={{14,-14},{-14,14}},
        rotation=-90,
        origin={-40,108}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={-41,-101})));
  Modelica.Blocks.Interfaces.RealInput[2] TemperaturesIn annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={36,106}), iconTransformation(
        extent={{11,-11},{-11,11}},
        rotation=-90,
        origin={37,-99})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  SI.Efficiency eta_el "Electrical efficiency";
  SI.Efficiency eta_h "Overall efficiency";

  // _____________________________________________
  //
  //        Instances of other classes
  // _____________________________________________
 replaceable function efficiencyFunction =
  TransiEnt.Basics.Functions.efficiency_linear constrainedby TransiEnt.Basics.Functions.efficiency_base "Efficiency of the heater"
                                                                                      annotation (choices(choice=TransiEnt.Basics.Functions.efficiency_constant "Constant efficiency",
                                                  choice=TransiEnt.Basics.Functions.efficiency_linear "Linear efficiency interpolation"));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end BasicEngineMechanics;
