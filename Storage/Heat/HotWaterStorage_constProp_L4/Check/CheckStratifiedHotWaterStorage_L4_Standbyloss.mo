within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Check;
model CheckStratifiedHotWaterStorage_L4_Standbyloss "Validation of one dimensional hot water storage with CHP loading scenario"
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

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{81.23633824,81.20940711,81.18247598,81.15554484,81.12861371,81.10168258,81.07475144,81.04782031,81.02088918,80.99395805,80.96702691,80.94009578,80.91316465,80.88623351,80.85930238,80.83237125,80.80544012,80.77850898,80.75157785,80.72464672,80.69771558,80.67078445,80.64385332,80.61692219,80.58999105,80.56305992,80.53612879,80.50919765,80.48226652,80.45533539,80.42840426,80.40147312,80.37454199,80.34761086,80.32067972,80.29374859,80.26681746,80.23988633,80.21295519,80.18602406,80.15909293,80.13216179,80.10523066,80.07829953,80.0513684,79.1587223,78.11955407,77.08038585,76.04121762,75.0020494,73.96288118,72.92371295,71.88454473,70.8453765,69.80620828,68.76704005,67.72787183,66.68870361,65.64953538,64.61036716,63.57119893,62.53203071,61.49286249,60.45369426,59.41452604,58.37535781,57.33618959,56.38822479,55.68966975,54.99111472,54.29255968,53.59400465,52.89544961,52.19689457,51.49833954,50.7997845,50.10122946,49.40267443,48.70411939,48.00556436,47.30700932,46.60845428,45.90989925,45.21134421,44.51278917,43.81423414,43.1156791,42.41712406,41.71856903,41.02001399,40.32145896,39.62290392,38.92434888,38.22579385,37.52723881,36.82868377,36.13012874,35.4315737,34.73301866,34.03446363};
  //_____________________________________________________________________________
  //Components/Models
  //_____________________________________________________________________________
  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow FluidFromHeatingGrid(
    T_const=310,
    m_flow_const=0,
    m_flow_nom=0) annotation (Placement(transformation(extent={{74,-54},{54,-34}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow HeatFromPowerPlant(
    m_flow_nom=0,
    T_const=360,
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=0)       annotation (Placement(transformation(extent={{-62,-36},{-42,-16}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow FluidToHeatingGrid(
    showData=true,
    T_const=330,
    variable_T=false,
    m_flow_const=0,
    m_flow_nom=0) annotation (Placement(transformation(extent={{74,-26},{54,-6}})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 hotWaterStorage(
    N_cv=100,
    tau_buoyancy=1,
    h=1.886,
    h_prodIn={1.85},
    h_prodOut={0.618},
    h_gridIn={0.01},
    h_gridOut={1.85},
    U_wall=0.0217572/sqrt(4*3.14*hotWaterStorage.V*hotWaterStorage.h),
    U_top=0.212089/hotWaterStorage.V*hotWaterStorage.h,
    U_bottom=0.212089/hotWaterStorage.V*hotWaterStorage.h,
    T_start=Tstart,
    rho=1e3,
    V=1,
    k=0.5574) annotation (Placement(transformation(extent={{-32,-58},{6,-20}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi heat_toCHP(
    p_const(displayUnit="bar") = 100000,
    variable_T=false,
    T_const=293) annotation (Placement(transformation(extent={{-68,-68},{-48,-48}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_amb(T=300.15) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-13,-3})));

//_____________________________________________________________________________
//    Equations
//_____________________________________________________________________________

  Modelica.Blocks.Sources.RealExpression T_1(y=hotWaterStorage.controlVolume[1].T - 273.15) annotation (Placement(transformation(extent={{-94,46},{-74,66}})));
  Modelica.Blocks.Sources.RealExpression T_20(y=hotWaterStorage.controlVolume[20].T - 273.15) annotation (Placement(transformation(extent={{-54,46},{-34,66}})));
  Modelica.Blocks.Sources.RealExpression T_40(y=hotWaterStorage.controlVolume[40].T - 273.15) annotation (Placement(transformation(extent={{-16,46},{4,66}})));
  Modelica.Blocks.Sources.RealExpression T_60(y=hotWaterStorage.controlVolume[60].T - 273.15) annotation (Placement(transformation(extent={{-94,20},{-74,40}})));
  Modelica.Blocks.Sources.RealExpression T_80(y=hotWaterStorage.controlVolume[80].T - 273.15) annotation (Placement(transformation(extent={{-54,22},{-34,42}})));
  Modelica.Blocks.Sources.RealExpression T_100(y=hotWaterStorage.controlVolume[100].T - 273.15) annotation (Placement(transformation(extent={{-14,22},{6,42}})));
equation
//_____________________________________________________________________________
//    Connections
//_____________________________________________________________________________

  connect(hotWaterStorage.waterPortIn_prod[1], HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-32,-31.4},{-36,-31.4},{-36,-32},{-42,-32},{-42,-26}},
      color={175,0,0},
      thickness=0.5));
  connect(heat_toCHP.steam_a, hotWaterStorage.waterPortOut_prod[1]) annotation (Line(
      points={{-48,-58},{-42,-58},{-42,-48},{-32,-48},{-32,-46.6}},
      color={0,131,169},
      thickness=0.5));
  connect(FluidFromHeatingGrid.steam_a, hotWaterStorage.waterPortIn_grid[1]) annotation (Line(
      points={{54,-44},{6,-44},{6,-46.6}},
      color={0,131,169},
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_grid[1], FluidToHeatingGrid.steam_a) annotation (Line(
      points={{6,-31.4},{54,-31.4},{54,-16}},
      color={175,0,0},
      thickness=0.5));
  connect(T_amb.port, hotWaterStorage.heatPortAmbient) annotation (Line(points={{-13,-10},{-13,-10},{-13,-22.85}}, color={191,0,0}));
public
function plotResult

  constant String resultFileName = "CheckStratifiedHotWaterStorage_L3_Standbyloss.mat";

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
<p><b><span style=\"color: #008000;\">1. Purpose of mode</span></b>l</p>
<p>Tester for HotWaterStorage_constProp_L4 with standby loss</p>
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
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{30,80},{86,26}},
          lineColor={28,108,200},
          textString="Look at:
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
end CheckStratifiedHotWaterStorage_L4_Standbyloss;
