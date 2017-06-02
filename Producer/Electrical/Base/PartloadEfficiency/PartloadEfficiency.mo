within TransiEnt.Producer.Electrical.Base.PartloadEfficiency;
block PartloadEfficiency "Block that calculates the partload efficiency from a charline, the actual power output and the nominal output"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Efficiency eta_n "Nominal total plant efficiency";
  parameter TransiEnt.Producer.Electrical.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() annotation (Dialog(group="Physical Constraints"), choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput p_el_is "Actual electric power output in p.u." annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));

  Modelica.Blocks.Interfaces.RealOutput eta_is annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds eta_rel(
    columns={2},
    table=EfficiencyCharLine.CL_eta_P,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-14,-13},{12,13}})));
  Modelica.Blocks.Math.Gain nominal(k=eta_n) "Nominal point efficiency" annotation (Placement(transformation(extent={{30,-10},{50,10}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p_el_is, eta_rel.u) annotation (Line(points={{-106,0},{-16.6,0}}, color={0,0,127}));
  connect(eta_rel.y[1], nominal.u) annotation (Line(points={{13.3,0},{28,0}}, color={0,0,127}));
  connect(nominal.y, eta_is) annotation (Line(points={{51,0},{58,0},{106,0}}, color={0,0,127}));
end PartloadEfficiency;
