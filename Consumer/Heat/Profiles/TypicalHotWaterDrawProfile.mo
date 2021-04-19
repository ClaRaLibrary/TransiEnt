within TransiEnt.Consumer.Heat.Profiles;
model TypicalHotWaterDrawProfile "Model of three typical hot water draw profiles taken from EN 15450. Output is in the thermal heat flow rate in W at a mass flow rate of the hydraulic system of 5.5 l/min (see Table E.1 in reference)."
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
import TransiEnt;

extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Types.HotWaterProfile profile "Choose from three typical profiles from EN 15450" annotation (__Dymola_editText=false);

parameter Real gain = 1;

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

final parameter Real[3] switch={if profile == 1 then 1 else 0,if profile == 2 then 1 else 0,if profile == 3 then 1 else 0};

Modelica.Blocks.Sources.SawTooth second_of_day(amplitude=86400, period=86400) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
Modelica.Blocks.Tables.CombiTable1Ds drawProfile_3p_bath(
tableOnFile=false,
smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
table=[0,0; 25200,11550; 25232.72727,0; 25500,11550; 25936.36364,0; 27000,11550; 27032.72727,0; 27900,11550; 27932.72727,0; 29100,11550; 30223.63636,0; 30300,11550; 30332.72727,0; 30600,11550; 30632.72727,0; 31500,11550; 31532.72727,0; 32400,11550; 32432.72727,0; 34200,11550; 34232.72727,0; 37800,11550; 37832.72727,0; 41400,11550; 41432.72727,0; 42300,11550; 42332.72727,0; 45900,17325; 45965.45455,0; 52200,11550; 52232.72727,0; 55800,11550; 55832.72727,0; 59400,11550; 59432.72727,0; 64800,11550; 64832.72727,0; 65700,17325; 65721.81818,0; 66600,17325; 66621.81818,0; 68400,11550; 68432.72727,0; 73800,17325; 73952.72727,0; 75600,11550; 76723.63636,0; 77400,11550; 77432.72727,0; 77433,0])
                                                              annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
Modelica.Blocks.Continuous.Integrator kWh(k=1e-3/3600) annotation (Placement(transformation(extent={{72,42},{92,62}})));
Modelica.Blocks.Tables.CombiTable1Ds drawProfile_1p(
tableOnFile=false,
smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
table=[0,0; 25200,11550; 25233,0; 27000,11550; 27033,0; 30600,11550; 30633,0; 34200,11550; 34233,0; 41400,11550; 41433,0; 42300,11550; 42333,0; 45900,17325; 45965,0; 64800,11550; 64833,0; 65700,17325; 65722,0; 73800,17325; 73887,0; 77400,11550; 77564,0; 77565,0])
                                                                                              annotation (Placement(transformation(extent={{-10,52},{10,72}})));
Modelica.Blocks.Tables.CombiTable1Ds drawProfile_3p(
tableOnFile=false,
smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
table=[0,0; 25200,11550; 25233,0; 26100,11550; 26536,0; 27000,11550; 27033,0; 28860,11550; 28893,0; 29700,11550; 29733,0; 30600,11550; 30633,0; 31500,11550; 31533,0; 32400,11550; 32433,0; 34200,11550; 34233,0; 37800,11550; 37833,0; 41400,11550; 41433,0; 42300,11550; 42333,0; 45900,17325; 45965,0; 52200,11550; 52233,0; 55800,11550; 55833,0; 59400,11550; 59433,0; 64800,11550; 64833,0; 65700,17325; 65722,0; 66600,17325; 66622,0; 68400,11550; 68433,0; 73800,17325; 73953,0; 76500,11550; 76533,0; 77400,11550; 77836,0; 77867,0])
                                                                                              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
Modelica.Blocks.Math.Sum switchProfile(k=switch, nin=3) annotation (Placement(transformation(extent={{40,-10},{60,10}})));

TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_draw "Hot water draw at 60C" annotation (Placement(transformation(extent={{96,-10},{116,10}})));
Modelica.Blocks.Math.Gain sign(k=gain) annotation (Placement(transformation(extent={{72,-8},{88,8}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
connect(second_of_day.y, drawProfile_3p_bath.u) annotation (Line(points={{-39,0},{-20,0},{-20,-60},{-12,-60}}, color={0,0,127}));
connect(second_of_day.y, drawProfile_1p.u) annotation (Line(points={{-39,0},{-20,0},{-20,62},{-12,62}}, color={0,0,127}));
connect(second_of_day.y, drawProfile_3p.u) annotation (Line(points={{-39,0},{-20,0},{-20,-36},{-20,0},{-12,0}}, color={0,0,127}));
connect(drawProfile_1p.y[1], switchProfile.u[1]) annotation (Line(points={{11,62},{28,62},{28,-1.33333},{38,-1.33333}}, color={0,0,127}));
connect(drawProfile_3p.y[1], switchProfile.u[2]) annotation (Line(points={{11,0},{11,0},{38,0}}, color={0,0,127}));
connect(drawProfile_3p_bath.y[1], switchProfile.u[3]) annotation (Line(points={{11,-60},{28,-60},{28,-42},{28,1.33333},{38,1.33333}}, color={0,0,127}));
connect(switchProfile.y, kWh.u) annotation (Line(points={{61,0},{62,0},{62,52},{70,52}}, color={0,0,127}));
connect(switchProfile.y, sign.u) annotation (Line(points={{61,0},{70.4,0}}, color={0,0,127}));
connect(sign.y, Q_flow_draw) annotation (Line(points={{88.8,0},{106,0}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Rectangle(
      extent={{-34,64},{16,-56}},
      lineColor={255,255,255},
      fillColor={0,134,134},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-100,48},{-100,42},{-66,42},{-60,40},{-56,36},{-56,36},{-48,36},{-48,40},{-50,44},{-58,48},{-100,48}},
      fillColor={135,135,135},
      fillPattern=FillPattern.Solid,
      lineColor={0,0,0}),
    Polygon(
      points={{-64,48},{-58,48},{-58,58},{-44,58},{-44,62},{-64,62},{-64,48}},
      fillColor={135,135,135},
      fillPattern=FillPattern.Solid,
      lineColor={0,0,0}),
    Rectangle(
      extent={{-56,34},{-50,-40}},
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      lineColor={0,0,0}),
    Line(points={{-34,-56},{-34,64},{66,64},{66,-56},{-34,-56},{-34,-26},{66,-26},{66,4},{-34,4},{-34,34},{66,34},{66,64},{16,64},{16,-57}},
        color={0,0,0})}),                                    Diagram(graphics,
                                                                     coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of three typical hot water draw profiles taken from EN 15450. Output is in the thermal heat flow rate in W at a mass flow rate of the hydraulic system of 5.5 l/min (see Table E.1 in reference).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_draw - Hot water draw at 60&deg;C</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>EN 15450</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end TypicalHotWaterDrawProfile;
