within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Check;
model CheckStratifiedHotWaterStorage_L3_Loading "Validation of one dimensional hot water storage with CHP loading scenario"
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

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{55.2170166666667,55.3619888888889,55.5069611111111,55.6519333333333,55.7969055555556,55.9418777777778,56.08685,56.2318222222222,56.3767944444444,56.5217666666667,56.6667388888889,56.8117111111111,56.9566833333333,57.1016555555556,57.2466277777778,57.3916,57.5365722222222,57.6815444444444,57.8265166666667,57.9714888888889,58.1164611111111,58.2614333333333,58.4064055555556,58.5513777777778,58.69635,58.8413222222222,58.9862944444444,59.1312666666667,59.2762388888889,59.4212111111111,59.5661833333333,59.7111555555556,59.8561277777778,60.0011,60.0587363636364,60.1163727272727,60.1740090909091,60.2316454545455,60.2892818181818,60.3469181818182,60.4045545454546,60.4621909090909,60.5198272727273,60.5774636363636,60.6351,60.6927363636364,60.7503727272727,60.8080090909091,60.8656454545455,60.9232818181818,60.9809181818182,61.0385545454545,61.0961909090909,61.1538272727273,61.2114636363636,61.2691,61.39913,61.52916,61.65919,61.78922,61.91925,62.04928,62.17931,62.30934,62.43937,62.5694,62.69943,62.82946,62.95949,63.08952,63.21955,63.34958,63.47961,63.60964,63.73967,63.8697,63.99973,64.12976,64.25979,64.38982,64.51985,64.64988,64.77991,64.90994,65.03997,65.17,65.30003,65.43006,65.56009,65.69012,65.82015,65.95018,66.08021,66.21024,66.34027,66.4703,66.60033,66.73036,66.86039,66.99042};
  //_____________________________________________________________________________
  //Components/Models
  //_____________________________________________________________________________
  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow FluidFromHeatingGrid(
    T_const=310,
    m_flow_const=0,
    m_flow_nom=0) annotation (Placement(transformation(extent={{80,-62},{60,-42}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant(
    m_flow_nom=0,
    T_const=360,
    m_flow_const=2,
    variable_T=true,
    variable_m_flow=true) annotation (Placement(transformation(extent={{-56,-44},{-36,-24}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow FluidToHeatingGrid(
    showData=true,
    T_const=330,
    variable_T=false,
    m_flow_const=0,
    m_flow_nom=0) annotation (Placement(transformation(extent={{80,-34},{60,-14}})));

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
    k=0.5574) annotation (Placement(transformation(extent={{-26,-66},{12,-28}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi heat_toCHP(
    p_const(displayUnit="bar") = 100000,
    variable_T=false,
    T_const=293) annotation (Placement(transformation(extent={{-62,-76},{-42,-56}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature      prescribedTemperature(T(displayUnit="K") = 303)
                                                                                    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-7,-15})));

//_____________________________________________________________________________
//    Equations
//_____________________________________________________________________________

  Modelica.Blocks.Sources.CombiTimeTable GeneratorSchedule(table=[0,0.01,328; 1000,0.1,356; 6400,0.16,363; 7000,0.09,355; 14160,0.06,351; 15000,0.06,351]) annotation (Placement(transformation(extent={{-96,-38},{-76,-18}})));
  Modelica.Blocks.Sources.RealExpression T_1(y=hotWaterStorage.controlVolume[1].T - 273.15) annotation (Placement(transformation(extent={{-96,50},{-76,70}})));
  Modelica.Blocks.Sources.RealExpression T_20(y=hotWaterStorage.controlVolume[20].T - 273.15) annotation (Placement(transformation(extent={{-56,50},{-36,70}})));
  Modelica.Blocks.Sources.RealExpression T_40(y=hotWaterStorage.controlVolume[40].T - 273.15) annotation (Placement(transformation(extent={{-18,50},{2,70}})));
  Modelica.Blocks.Sources.RealExpression T_60(y=hotWaterStorage.controlVolume[60].T - 273.15) annotation (Placement(transformation(extent={{-96,24},{-76,44}})));
  Modelica.Blocks.Sources.RealExpression T_80(y=hotWaterStorage.controlVolume[80].T - 273.15) annotation (Placement(transformation(extent={{-56,26},{-36,46}})));
  Modelica.Blocks.Sources.RealExpression T_100(y=hotWaterStorage.controlVolume[100].T - 273.15) annotation (Placement(transformation(extent={{-16,26},{4,46}})));
equation
//_____________________________________________________________________________
//    Connections
//_____________________________________________________________________________

  connect(hotWaterStorage.waterPortIn_primaryHeatSource, HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-26,-39.4},{-30,-39.4},{-30,-40},{-36,-40},{-36,-34}},
      color={175,0,0},
      thickness=0.5));
  connect(heat_toCHP.steam_a, hotWaterStorage.waterPortOut_primaryHeatSource) annotation (Line(
      points={{-42,-66},{-36,-66},{-36,-56},{-26,-56},{-26,-48.9}},
      color={0,131,169},
      thickness=0.5));
  connect(FluidFromHeatingGrid.steam_a, hotWaterStorage.waterPortIn_Grid) annotation (Line(
      points={{60,-52},{11.62,-52},{11.62,-52.7}},
      color={0,131,169},
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_Grid, FluidToHeatingGrid.steam_a) annotation (Line(
      points={{11.62,-40.16},{60,-40.16},{60,-24}},
      color={175,0,0},
      thickness=0.5));
  connect(GeneratorSchedule.y[1], HeatFromPowerPlant.m_flow) annotation (Line(points={{-75,-28},{-70,-28},{-58,-28}}, color={0,0,127}));
  connect(GeneratorSchedule.y[2], HeatFromPowerPlant.T) annotation (Line(points={{-75,-28},{-72,-28},{-72,-34},{-58,-34}}, color={0,0,127}));
  connect(hotWaterStorage.heatPortAmbient, prescribedTemperature.port) annotation (Line(points={{-7,-30.85},{-7,-26.425},{-7,-26.425},{-7,-22}}, color={191,0,0}));
public
function plotResult

  constant String resultFileName = "CheckStratifiedHotWaterStorage_L3_Loading.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1616, 851}, y={"HeatFromPowerPlant.m_flow"}, range={0.0, 14500.0, 0.0, 0.2}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 293}, y={"HeatFromPowerPlant.eye.T", "T_1.y", "T_20.y", "T_40.y", "T_60.y", "T_80.y",
"T_100.y", "FluidFromHeatingGrid.eye.T", "hotWaterStorage.T_mean"}, range={0.0, 14500.0, 30.0, 100.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33},
{244,125,35}, {102,44,145}, {215,215,215}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
LinePattern.Dash}, thicknesses={0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 167}, y={"hotWaterStorage.SOC"}, range={0.0, 14500.0, 0.0, 0.6000000000000001}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 251}, y={"hotWaterStorage.Q_flow_load", "hotWaterStorage.Q_flow_unload",
"hotWaterStorage.Q_flow_loss2amb"}, range={0.0, 14500.0, -5000.0, 15000.0}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Documentation(info="<html>
  <p></p>
  </html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{30,72},{86,18}},
          lineColor={28,108,200},
          textString="Look at:
HeatFromPowerPlant.m_flow

HeatFromPowerPlant.T

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
end CheckStratifiedHotWaterStorage_L3_Loading;
