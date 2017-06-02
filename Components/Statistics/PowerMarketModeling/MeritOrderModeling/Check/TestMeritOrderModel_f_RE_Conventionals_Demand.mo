within TransiEnt.Components.Statistics.PowerMarketModeling.MeritOrderModeling.Check;
model TestMeritOrderModel_f_RE_Conventionals_Demand "With real genration and demand data"
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

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  MeritOrderModel_f_RE_Conventionals_Demand meritOrderModel(nuclearOffer=0, LigniteOffer=0) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Producer.Electrical.Wind.WindProfiles.WindProfileLoader windproduction_HH_900s_2012_1(REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2012_Gesamt_900s, P_el_n=4e9) annotation (Placement(transformation(extent={{-88,48},{-68,68}})));
  Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 electricityDemandHH_900s_010120120_010120130_1 annotation (Placement(transformation(extent={{-86,-44},{-66,-24}})));
  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-94,-90},{-81,-77}})));
  Grid.Heat.HeatGridControl.Controllers.DHG_FeedForward_Controller dhnControl annotation (Placement(transformation(extent={{-76,-90},{-58,-77}})));
  Basics.Blocks.HoldBlock holdBlock annotation (Placement(transformation(extent={{-50,-63},{-46,-57}})));
  Basics.Tables.ElectricGrid.SpotPriceElectricity_Phelix_3600s_2012 spotPriceElectricity_Phelix_3600s_2012_2 annotation (Placement(transformation(extent={{-74,-62},{-68,-56}})));
  Grid.Heat.HeatGridControl.Controllers.DHNPowerScheduler_L0 dHNPowerScheduler_L0_1(MarginalCost_Coal=29) annotation (Placement(transformation(extent={{-46,-84},{-37,-77}})));
  Basics.Blocks.Sources.PowerExpression powerExpression(y=dHNPowerScheduler_L0_1.P_out_WW1 + dHNPowerScheduler_L0_1.P_out_WW2 + dHNPowerScheduler_L0_1.P_out_WT) annotation (Placement(transformation(extent={{-86,16},{-66,36}})));
  Basics.Blocks.Sources.PowerExpression powerExpression1(y=dHNPowerScheduler_L0_1.GasKW) annotation (Placement(transformation(extent={{-84,-18},{-64,2}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

  function plotResult

  algorithm
    TransiEnt.Basics.Functions.plotResult("TestMeritOrderModel_f_RE_Conventionals_Demand.m");
    createPlot(id=1, position={0, 0, 1574, 942}, y={"meritOrderModel.Demand", "meritOrderModel.renewablesOffer", "meritOrderModel.hardCoalOffer",
   "meritOrderModel.gasOffer"}, range={0.0, 32000000.0, -500.0, 3500.0}, grid=true, filename="TestMeritOrderModel_f_RE_Conventionals_Demand.mat", legends={"", "", "", "Gas offer"}, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}});
   createPlot(id=1, position={0, 0, 1574, 468}, y={"meritOrderModel.PowerPrice"}, range={0.0, 370.0, -5.0, 50.0}, grid=true, legends={"Resulting power price"}, subPlot=2, colors={{244,125,35}});

  end plotResult;

  Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_11_1(CharLine=Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(), Damping_Weekend=0.9) annotation (Placement(transformation(extent={{-78,-74},{-72,-68}})));
equation

  connect(holdBlock.u,spotPriceElectricity_Phelix_3600s_2012_2. y1)
    annotation (Line(
      points={{-50.4,-60},{-60,-60},{-60,-59},{-67.7,-59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHNPowerScheduler_L0_1.spotPrice,holdBlock. y) annotation (Line(
      points={{-41.5,-76.65},{-42,-76.65},{-42,-60},{-45.8,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1,dhnControl. T_ambient)
    annotation (Line(
      points={{-80.35,-83.5},{-73,-83.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(windproduction_HH_900s_2012_1.y1, meritOrderModel.renewablesOffer) annotation (Line(points={{-67,58},{-20,58},{-20,7.2},{-12,7.2}}, color={0,0,127}));
  connect(electricityDemandHH_900s_010120120_010120130_1.value, meritOrderModel.Demand) annotation (Line(
      points={{-68,-34},{0,-34},{0,-12},{0.2,-12}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(meritOrderModel.hardCoalOffer, powerExpression.y) annotation (Line(
      points={{-12,1.8},{-38,1.8},{-38,26},{-65,26}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(meritOrderModel.gasOffer, powerExpression1.y) annotation (Line(
      points={{-12,-4.8},{-38,-4.8},{-38,-8},{-63,-8}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(dhnControl.Q_flow_i[1], dHNPowerScheduler_L0_1.Q_flow_Target_WT) annotation (Line(points={{-57.4,-79.73},{-51.7,-79.73},{-51.7,-78.75},{-46.45,-78.75}}, color={0,0,127}));
  connect(dhnControl.Q_flow_i[2], dHNPowerScheduler_L0_1.Q_flow_Target_WW) annotation (Line(points={{-57.4,-79.73},{-51.7,-79.73},{-51.7,-82.25},{-46.45,-82.25}}, color={0,0,127}));
  connect(dhnControl.Q_dot_DH_Targ, heatingLoadCharline_11_1.Q_flow) annotation (Line(points={{-66.4,-76.35},{-66.4,-71},{-71.7,-71}}, color={0,0,127}));
  connect(heatingLoadCharline_11_1.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.y1) annotation (Line(points={{-78.3,-70.7},{-80.35,-70.7},{-80.35,-83.5}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Plot: </p>
<p>meritOrderModelStep2_1.PowerPrice</p>
<p>- scaledWindProduction.y</p>
<p>- scaled Demand.y</p>
<p><br>- spotPrice... . y1</p>
<p><br>All offers still have to be properly dimensioned. This example is so far just for proof of concept.</p>
</html>"));
end TestMeritOrderModel_f_RE_Conventionals_Demand;
