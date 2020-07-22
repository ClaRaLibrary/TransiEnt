within TransiEnt.Components.Gas.Engines.Mechanics;
model PartloadEfficiency "Block that calculates the partload efficiency from a charline, the actual power output and the nominal output"

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

  extends TransiEnt.Basics.Icons.Block;
  outer parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification Specification "Record containing specific chp parameters";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter SI.Efficiency eta_th_n=1 "Nominal total plant efficiency";
  parameter SI.Efficiency eta_el_n=1 "Nominal total plant efficiency";
//  parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.ConstantEfficiency() "choose characteristic efficiency line" annotation(Dialog(group="Physical Constraints"), choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_is "Actual electric power output in p.u." annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  TransiEnt.Basics.Interfaces.General.EfficiencyOut eta_is[2]
                                                          "Output for efficiency" annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds eta_rel_el(
    u(start=0),
    columns={2},
    table=Specification.EfficiencyCharLine.CL_eta_el,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-30,-13},{-4,13}})));

  Modelica.Blocks.Tables.CombiTable1Ds eta_rel_th(
    u(start=0),
    columns={2},
    table=Specification.EfficiencyCharLine.CL_eta_th,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-30,-53},{-4,-27}})));
  Modelica.Blocks.Math.Gain gain(k=eta_el_n) annotation (Placement(transformation(extent={{58,-8},{78,12}})));
  Modelica.Blocks.Math.Gain gain1(k=eta_th_n) annotation (Placement(transformation(extent={{58,-48},{78,-28}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_el_is, eta_rel_el.u) annotation (Line(points={{-106,0},{-32.6,0}}, color={0,127,127}));
  connect(P_el_is, eta_rel_th.u) annotation (Line(points={{-106,0},{-84,0},{-84,2},{-46,2},{-46,-40},{-32.6,-40}}, color={0,127,127}));
  connect(eta_rel_el.y[1], gain.u) annotation (Line(points={{-2.7,0},{26,0},{26,2},{56,2}}, color={0,0,127}));
  connect(gain.y, eta_is[1]) annotation (Line(points={{79,2},{88,2},{88,-5},{106,-5}}, color={0,0,127}));
  connect(eta_rel_th.y[1], gain1.u) annotation (Line(points={{-2.7,-40},{26,-40},{26,-38},{56,-38}}, color={0,0,127}));
  connect(gain1.y, eta_is[2]) annotation (Line(points={{79,-38},{90,-38},{90,-36},{102,-36},{102,5},{106,5}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model block calculates partload efficiency from the efficiency line chart.</p>
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
<p>Model created by Anne Senkel (anne.senkel@tuhh.de), Feb 2019</p>
</html>"));
end PartloadEfficiency;
