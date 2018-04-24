within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Check;
model CheckStratifiedHotWaterStorage_L4_Unloading "Validation of one dimensional hot water storage with CHP loading scenario"
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

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{77.5704536,76.79268329,76.01491298,75.23714267,74.45937237,73.68160206,72.90383175,72.12606144,71.34829113,70.57052083,69.79275052,69.01498021,68.2372099,67.45943959,66.68166929,65.90389898,65.12612867,64.34835836,63.57058805,62.79281774,62.01504744,61.23727713,60.45950682,59.68173651,58.9039662,58.1261959,57.34842559,56.57065528,55.79288497,55.01511466,54.23734436,53.45957405,52.68180374,51.90403343,51.12626312,50.34849282,49.57072251,48.7929522,48.01518189,47.23741158,46.45964128,45.68187097,44.90410066,44.12633035,43.34856004,42.77029829,42.22580332,41.68130836,41.13681339,40.59231843,40.04782346,39.50332849,38.95883353,38.41433856,37.8698436,37.32534863,36.78085367,36.2363587,35.69186374,35.14736877,34.60287381,34.05837884,33.51388388,32.96938891,32.42489395,31.88039898,31.33590401,30.89215557,30.72391396,30.55567234,30.38743073,30.21918912,30.0509475,29.88270589,29.71446427,29.54622266,29.37798105,29.20973943,29.04149782,28.8732562,28.70501459,28.53677297,28.36853136,28.20028975,28.03204813,27.86380652,27.6955649,27.52732329,27.35908168,27.19084006,27.02259845,26.85435683,26.68611522,26.51787361,26.34963199,26.18139038,26.01314876,25.84490715,25.67666553,25.50842392};
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

  TransiEnt.Storage.Heat.HeatStorageStratified_constProp.StratifiedHotWaterStorage_L4 hotWaterStorage(
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
    T_min_ref=298.15) annotation (Placement(transformation(extent={{-38,-68},{0,-30}})));

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
end CheckStratifiedHotWaterStorage_L4_Unloading;
