within TransiEnt.Storage.Electrical.Base;
model StoragePBPPotential "Calculates primary balancing power potential using a zero order hold"
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

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  parameter Real t_pbp_interval;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Modelica.Blocks.Math.Abs abs_P_pot_discharge "Potential discharging power"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Abs abs_P_pot_charge "Potential charging power"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_potential_charge "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_potential_discharge "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_potential_PBP "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Discrete.ZeroOrderHold holdPBPIntervall(samplePeriod=t_pbp_interval) "Potential must be present for time x" annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(abs_P_pot_charge.u, P_potential_charge) annotation (Line(
      points={{-62,-50},{-100,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs_P_pot_discharge.u, P_potential_discharge) annotation (Line(
      points={{-62,50},{-100,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs_P_pot_discharge.y, min.u1) annotation (Line(
      points={{-39,50},{-22,50},{-22,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs_P_pot_charge.y, min.u2) annotation (Line(
      points={{-39,-50},{-22,-50},{-22,-6},{-2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.y, holdPBPIntervall.u) annotation (Line(
      points={{21,0},{38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_potential_PBP, holdPBPIntervall.y) annotation (Line(
      points={{110,0},{61,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-52,22},{84,-20}},
          lineColor={0,0,0},
          textString="P_potential_PBP")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculates primary balancing power potential using a zero order hold.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_potential_charge: input for electric power in [W]- Connector of Real input signal [W]</p>
<p>P_potential_discharge: input for electric power in [W]- Connector of Real input signal [W]</p>
<p>P_potential_PBP: output for electric power in [W]- Connector of Real output signal [W]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end StoragePBPPotential;
