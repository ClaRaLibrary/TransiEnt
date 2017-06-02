within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Check;
model CheckStratifiedHotWaterStorage_L3_Unloading "Validation of one dimensional hot water storage with CHP loading scenario"
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
  import TransiEnt;

  extends TransiEnt.Basics.Icons.Checkmodel;

  import SI = Modelica.SIunits;

//_____________________________________________________________________________
//   Parameter
//_____________________________________________________________________________
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1;

   // Heights of temperature sensors
   constant SI.Length T1_height = 1.728 - 0.136 "sensor name at TUHH site: TIRC2.13";
   constant SI.Length T2_height = 1.080 - 0.136 + 0.1 "sensor name at TUHH site: TIR2.15";
   constant SI.Length T3_height= 0.754 - 0.136 "sensor name at TUHH site: TIR2.15.1";
   constant SI.Length T4_height = 0.429 - 0.136 "sensor name at TUHH site: TIR2.15.2";

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{25.508423920558,25.6766655346797,25.8449071488014,26.013148762923,26.1813903770447,26.3496319911663,26.517873605288,26.6861152194096,26.8543568335313,27.022598447653,27.1908400617746,27.3590816758963,27.5273232900179,27.6955649041396,27.8638065182612,28.0320481323829,28.2002897465046,28.3685313606262,28.5367729747479,28.7050145888695,28.8732562029912,29.0414978171128,29.2097394312345,29.3779810453562,29.5462226594778,29.7144642735995,29.8827058877211,30.0509475018428,30.2191891159645,30.3874307300861,30.5556723442078,30.7239139583294,30.8921555724511,31.3359040147934,31.8803989801273,32.4248939454611,32.969388910795,33.5138838761289,34.0583788414628,34.6028738067967,35.1473687721306,35.6918637374645,36.2363587027984,36.7808536681323,37.3253486334662,37.8698435988001,38.414338564134,38.9588335294679,39.5033284948018,40.0478234601357,40.5923184254696,41.1368133908034,41.6813083561373,42.2258033214712,42.7702982868051,43.3485600435299,44.1263303515859,44.9041006596419,45.6818709676979,46.4596412757539,47.23741158381,48.015181891866,48.792952199922,49.570722507978,50.348492816034,51.12626312409,51.9040334321461,52.6818037402021,53.4595740482581,54.2373443563141,55.0151146643701,55.7928849724261,56.5706552804821,57.3484255885382,58.1261958965942,58.9039662046502,59.6817365127062,60.4595068207622,61.2372771288183,62.0150474368743,62.7928177449303,63.5705880529863,64.3483583610423,65.1261286690983,65.9038989771543,66.6816692852104,67.4594395932664,68.2372099013224,69.0149802093784,69.7927505174344,70.5705208254905,71.3482911335465,72.1260614416025,72.9038317496585,73.6816020577145,74.4593723657705,75.2371426738266,76.0149129818826,76.7926832899386,77.5704535979946};
  //_____________________________________________________________________________
  //Components/Models
  //_____________________________________________________________________________
  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow FluidFromHeatingGrid(
    m_flow_const=0,
    m_flow_nom=0,
    variable_m_flow=true,
    variable_T=false,
    T_const=300)  annotation (Placement(transformation(extent={{46,-64},{26,-44}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant(
    m_flow_nom=0,
    T_const=360,
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=0)       annotation (Placement(transformation(extent={{-68,-46},{-48,-26}})));

  StratifiedHotWaterStorage_L3 hotWaterStorage(
    N_cv=100,
    tau_buoyancy=1,
    h=1.886,
    h_primaryHeatSourceWaterIn=1.85,
    h_primaryHeatSourceWaterOut=0.618,
    h_gridSideWaterIn=0.01,
    h_gridSideWaterOut=1.85,
    U_wall=0.0217572/sqrt(4*3.14*hotWaterStorage.V*hotWaterStorage.h),
    U_top=0.212089/hotWaterStorage.V*hotWaterStorage.h,
    U_bottom=0.212089/hotWaterStorage.V*hotWaterStorage.h,
    T_start=Tstart,
    rho=1e3,
    V=1,
    k=0.5574,
    T_max_ref=353.15,
    T_min_ref=298.15)
              annotation (Placement(transformation(extent={{-38,-68},{0,-30}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature      prescribedTemperature(T(displayUnit="K") = 295)
                                                                                    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-19,-19})));

//_____________________________________________________________________________
//    Equations
//_____________________________________________________________________________

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi heat_toGrid(
    p_const(displayUnit="bar") = 100000,
    variable_T=false,
    T_const=363) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={34,-28})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow Fluid_toCHP(
    showData=true,
    variable_T=false,
    m_flow_const=0,
    m_flow_nom=0,
    T_const=293) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp m_flow_return(
    height=0.01,
    duration=14160,
    offset=0.01,
    startTime=0) annotation (Placement(transformation(extent={{82,-42},{62,-22}})));
  Modelica.Blocks.Sources.RealExpression T_1(y=hotWaterStorage.controlVolume[1].T - 273.15) annotation (Placement(transformation(extent={{-88,38},{-68,58}})));
  Modelica.Blocks.Sources.RealExpression T_20(y=hotWaterStorage.controlVolume[20].T - 273.15) annotation (Placement(transformation(extent={{-48,38},{-28,58}})));
  Modelica.Blocks.Sources.RealExpression T_40(y=hotWaterStorage.controlVolume[40].T - 273.15) annotation (Placement(transformation(extent={{-10,38},{10,58}})));
  Modelica.Blocks.Sources.RealExpression T_60(y=hotWaterStorage.controlVolume[60].T - 273.15) annotation (Placement(transformation(extent={{-88,12},{-68,32}})));
  Modelica.Blocks.Sources.RealExpression T_80(y=hotWaterStorage.controlVolume[80].T - 273.15) annotation (Placement(transformation(extent={{-48,14},{-28,34}})));
  Modelica.Blocks.Sources.RealExpression T_100(y=hotWaterStorage.controlVolume[100].T - 273.15) annotation (Placement(transformation(extent={{-8,14},{12,34}})));
equation
//_____________________________________________________________________________
//    Connections
//_____________________________________________________________________________

  connect(hotWaterStorage.waterPortIn_primaryHeatSource, HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-38,-41.4},{-42,-41.4},{-42,-42},{-48,-42},{-48,-36}},
      color={175,0,0},
      thickness=0.5));
  connect(FluidFromHeatingGrid.steam_a, hotWaterStorage.waterPortIn_Grid) annotation (Line(
      points={{26,-54},{-0.38,-54},{-0.38,-54.7}},
      color={0,131,169},
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_Grid, heat_toGrid.steam_a) annotation (Line(
      points={{-0.38,-42.16},{12,-42.16},{12,-28},{24,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(Fluid_toCHP.steam_a, hotWaterStorage.waterPortOut_primaryHeatSource) annotation (Line(
      points={{-60,-70},{-54,-70},{-54,-68},{-52,-68},{-52,-50.9},{-38,-50.9}},
      color={0,131,169},
      thickness=0.5));
  connect(FluidFromHeatingGrid.m_flow, m_flow_return.y) annotation (Line(points={{48,-48},{54,-48},{54,-32},{61,-32}}, color={0,0,127}));
  connect(prescribedTemperature.port, hotWaterStorage.heatPortAmbient) annotation (Line(points={{-19,-26},{-19,-26},{-19,-32.85}}, color={191,0,0}));
public
function plotResult

  constant String resultFileName = "CheckStratifiedHotWaterStorage_L3_Unloading.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1616, 851}, y={"HeatFromPowerPlant.eye.T", "T_1.y", "T_20.y", "T_40.y", "T_60.y", "T_80.y",
  "T_100.y", "FluidFromHeatingGrid.eye.T", "hotWaterStorage.T_mean"}, range={0.0, 14500.0, 30.0, 90.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33},
  {244,125,35}, {102,44,145}, {215,215,215}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
  LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
  LinePattern.Dash}, thicknesses={0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 281}, y={"hotWaterStorage.SOC"}, range={0.0, 14500.0, 0.18, 0.21}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 280}, y={"hotWaterStorage.Q_flow_load", "hotWaterStorage.Q_flow_unload",
  "hotWaterStorage.Q_flow_loss2amb"}, range={0.0, 14500.0, -50.0, 250.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Documentation(info="<html>
  <p></p>
  </html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{26,72},{92,16}},
          lineColor={28,108,200},
          textString="Look at:
FluidFromHeatingGrid.m_flow

FluidFromHeatingGrid.T

T_1.y
T_20.y
T_40.y
T_60.y
T_80.y
T_100.y

hotWaterStorage.SOC")}),
    experiment(
      StopTime=14160,
      Tolerance=1e-009,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end CheckStratifiedHotWaterStorage_L3_Unloading;
