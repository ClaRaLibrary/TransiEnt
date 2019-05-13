within TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine;
model CharLineInductionMachineBlock
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine.CharLineInductionMachine_empty CharLineAsychronousMachine_parameter=TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine.CharLineInductionMachine_ieet() annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput slip_in "Slip, normalized with slip_bd" annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau_out "Torque, normalized with tau_bd" annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds CharLineTable_asy(
    columns={2},
    table=CharLineAsychronousMachine_parameter.CL_ays,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-14,-13},{12,13}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(slip_in, CharLineTable_asy.u) annotation (Line(points={{-106,0},{-16.6,0}}, color={0,0,127}));
  connect(CharLineTable_asy.y[1], tau_out) annotation (Line(points={{13.3,0},{106,0}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model block calculates normalized torque in relation to normalized slip of induction machines  </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de) in August 2018</p>
</html>"));
end CharLineInductionMachineBlock;
