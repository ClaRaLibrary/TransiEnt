within TransiEnt.Grid.Heat.HeatGridControl.Check;
model Test_HeatDemandPrediction "Heat production prediction of units feeding into a district heating grid"
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.WeeklyHeatProfile weeklyHeatProfile annotation (Placement(transformation(extent={{24,30},{44,50}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_OffsetOn_WeekendOff_SummerDayOff(
    offsetOn=true,
    weekendOn=false,
    SummerDayTypicalHeatLoadCharLine=false,
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{-8,11},{6,25}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_OffsetOff_WeekendOff_SummerDayOff(
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(),
    offsetOn=false,
    weekendOn=false,
    SummerDayTypicalHeatLoadCharLine=false) annotation (Placement(transformation(extent={{-8,30},{6,44}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_OffsetOff_WeekendOn_SummerDayOff(
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(a=100e6),
    weekendOn=true,
    SummerDayTypicalHeatLoadCharLine=false,
    offsetOn=false,
    Damping_Weekend=0.75) annotation (Placement(transformation(extent={{-8,-9},{6,5}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_172800s_2012 temperature)) annotation (Placement(transformation(extent={{-88,80},{-68,100}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_OffsetOff_WeekendOff_SummerDayOn(
    offsetOn=false,
    weekendOn=false,
    SummerDayTypicalHeatLoadCharLine=true,
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{-6,-29},{8,-15}})));
equation
  connect(heatingLoadCharline_OffsetOn_WeekendOff_SummerDayOff.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-8.7,18.7},{-26,18.7},{-26,0},{-39,0}}, color={0,0,127}));
  connect(heatingLoadCharline_OffsetOff_WeekendOff_SummerDayOff.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-8.7,37.7},{-26,37.7},{-26,0},{-39,0}}, color={0,0,127}));
  connect(weeklyHeatProfile.Q_flow_raw, heatingLoadCharline_OffsetOff_WeekendOff_SummerDayOff.Q_flow) annotation (Line(points={{22,40},{6.7,40},{6.7,37}}, color={0,0,127}));
  connect(heatingLoadCharline_OffsetOff_WeekendOn_SummerDayOff.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-8.7,-1.3},{-26,-1.3},{-26,0},{-39,0}}, color={0,0,127}));
  connect(heatingLoadCharline_OffsetOff_WeekendOff_SummerDayOn.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-6.7,-21.3},{-26,-21.3},{-26,0},{-39,0}}, color={0,0,127}));
 annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3.16224e+007,
      Interval=900,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(events=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false),
                    graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for the heat demand prediction models</p>
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
end Test_HeatDemandPrediction;
