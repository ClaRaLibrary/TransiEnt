within TransiEnt.Components.Gas.Engines.Mechanics;
partial model BasicEngineMechanics "Partial model for mechanical behavior of a gas engine"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set annotation (Placement(transformation(extent={{-128,-30},{-88,10}}),
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
  Modelica.Blocks.Interfaces.RealOutput[2] efficienciesOut={eta_el,eta_h} "[1] = eta_el, [2] = eta_h" annotation (Placement(transformation(
        extent={{14,-14},{-14,14}},
        rotation=-90,
        origin={-40,108}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={-41,-101})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn[2] TemperaturesIn annotation (Placement(
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

//
//  replaceable function efficiencyFunction =
//   TransiEnt.Basics.Functions.efficiency_linear constrainedby TransiEnt.Basics.Functions.efficiency_base "Efficiency of the heater"
//                                                                                       annotation (choices(choice=TransiEnt.Basics.Functions.efficiency_constant "Constant efficiency",
//                                                   choice=TransiEnt.Basics.Functions.efficiency_linear "Linear efficiency interpolation"));
// parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.ConstantEfficiency() "choose characteristic efficiency line" annotation(Dialog(group="Physical Constraints"), choicesAllMatching=true);
  PartloadEfficiency partloadEfficiency(eta_th_n=Specification.eta_h_max, eta_el_n=Specification.eta_el_max) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el_set/Specification.P_el_max) annotation (Placement(transformation(extent={{6,-100},{26,-80}})));
equation
  connect(realExpression.y, partloadEfficiency.P_el_is) annotation (Line(points={{27,-90},{34.5,-90},{34.5,-90},{39.4,-90}}, color={0,0,127}));
 annotation (Line(points={{27,-90},{39.4,-90}}, color={0,0,127}),
             Diagram( coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end BasicEngineMechanics;
