within TransiEnt.Grid.Heat.HeatGridControl.Check;
model TestDemandInDifferentCities "Test to check resulting heating demand profiles in different cities"
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.Heat Q_BER;
  Modelica.SIunits.Heat Q_HH;
  Modelica.SIunits.Energy E_BER;
  Modelica.SIunits.Energy E_HH;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 Electricity_Demand_HH annotation (Placement(transformation(extent={{-14,72},{6,92}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345 annotation (Placement(transformation(extent={{-14,32},{6,52}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_Berlin_900s_2012 Electricity_Demand_BER annotation (Placement(transformation(extent={{-16,-66},{4,-46}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature_BER_3600s_01012012_31122012 annotation (Placement(transformation(extent={{-14,-108},{6,-88}})));
  HeatDemandPrediction.HeatingGenerationCharline CharLineHeatHamburg(CharLine=HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{24,32},{44,52}})));
  HeatDemandPrediction.HeatingGenerationCharline CharLineHeatBerlin(CharLine=HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandBER()) annotation (Placement(transformation(extent={{24,-108},{44,-88}})));
  // _____________________________________________
  //
  //           Functions
  // _____________________________________________
     function plotResult
     constant String resultFileName = "TestDemandInDifferentCities.mat";
     algorithm
    TransiEnt.Basics.Functions.plotResult(resultFileName);
        createPlot(id=1, position={759, 0, 741, 908}, y={"der(E_BER)", "der(E_HH)"}, range={0.0, 32000000.0, 800.0, 2600.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFileName);
        createPlot(id=1, position={759, 0, 741, 451}, y={"E_BER", "E_HH"}, range={0.0, 32000000.0, -2.0, 16.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
        createPlot(id=2, position={0, 0, 743, 908}, y={"der(Q_BER)", "der(Q_HH)"}, range={0.0, 32000000.0, 0.0, 4500.0}, grid=true, colors={{28,108,200}, {238,46,47}});
        createPlot(id=2, position={0, 0, 743, 451}, y={"Q_BER", "Q_HH"}, range={0.0, 32000000.0, -1.0, 9.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
     end plotResult;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  der(Q_BER)=CharLineHeatBerlin.Q_flow;
  der(Q_HH)=CharLineHeatHamburg.Q_flow;
  der(E_BER)=Electricity_Demand_BER.value;
  der(E_HH)=Electricity_Demand_HH.value;

  connect(CharLineHeatHamburg.T_amb, temperatureHH_900s_01012012_0000_31122012_2345.y1) annotation (Line(points={{23,43},{12,43},{12,42},{7,42}}, color={0,0,127}));
  connect(CharLineHeatBerlin.T_amb, temperature_BER_3600s_01012012_31122012.y1) annotation (Line(points={{23,-97},{7,-97},{7,-98}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -140},{200,140}}), graphics={
        Text(
          extent={{-46,70},{-28,48}},
          lineColor={0,140,72},
          textString="HH"),
        Text(
          extent={{-50,-64},{-24,-94}},
          lineColor={0,140,72},
          textString="BER")}),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-140},{200,140}})),
    experiment(StopTime=3.16224e+007, Interval=900),
    __Dymola_experimentSetupOutput);
end TestDemandInDifferentCities;
