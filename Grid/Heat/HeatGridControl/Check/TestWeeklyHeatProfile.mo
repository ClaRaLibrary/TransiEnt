within TransiEnt.Grid.Heat.HeatGridControl.Check;
model TestWeeklyHeatProfile
  import TransiEnt;
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  HeatDemandPrediction.WeeklyHeatProfile weeklyHeatProfile annotation (Placement(transformation(extent={{26,-22},{46,-2}})));
  Modelica.Blocks.Continuous.Integrator E_raw annotation (Placement(transformation(extent={{18,-86},{38,-66}})));
  Modelica.Blocks.Continuous.Integrator E annotation (Placement(transformation(extent={{64,-86},{84,-66}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-76,-16},{-56,4}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(),
    offsetOn=false,
    weekendOn=false,
    SummerDayTypicalHeatLoadCharLine=false) annotation (Placement(transformation(extent={{-28,-20},{-8,0}})));
equation

  connect(weeklyHeatProfile.Q_flow, E.u) annotation (Line(points={{48,-12},{48,-76},{62,-76}}, color={0,0,127}));
  connect(heatingLoadCharline.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-29,-9},{-50,-9},{-50,-6},{-55,-6}}, color={0,0,127}));
  connect(heatingLoadCharline.Q_flow, weeklyHeatProfile.Q_flow_raw) annotation (Line(
      points={{-7,-10},{8,-10},{8,-12},{24,-12}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatingLoadCharline.Q_flow, E_raw.u) annotation (Line(
      points={{-7,-10},{6,-10},{6,-76},{16,-76}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={Text(
          extent={{-52,76},{60,30}},
          lineColor={28,108,200},
          textString="Look at:
heatingLoadCharline.Q_flow
dailyHeatProfileQ_flow

E_raw.y
E.y")}),                                                                           Icon(graphics,
                                                                                        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=604800, Interval=30),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for the WeeklyHeatProfile model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
</html>"));
end TestWeeklyHeatProfile;
