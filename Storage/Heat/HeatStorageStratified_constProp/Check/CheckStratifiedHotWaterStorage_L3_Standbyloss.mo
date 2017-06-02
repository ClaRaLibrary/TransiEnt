within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Check;
model CheckStratifiedHotWaterStorage_L3_Standbyloss "Validation of one dimensional hot water storage with CHP loading scenario"
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

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{34.0344636284461,34.7330186647855,35.4315737011249,36.1301287374643,36.8286837738037,37.5272388101431,38.2257938464825,38.9243488828219,39.6229039191613,40.3214589555007,41.0200139918401,41.7185690281795,42.4171240645189,43.1156791008582,43.8142341371976,44.512789173537,45.2113442098764,45.9098992462158,46.6084542825552,47.3070093188946,48.005564355234,48.7041193915734,49.4026744279128,50.1012294642522,50.7997845005916,51.498339536931,52.1968945732704,52.8954496096097,53.5940046459491,54.2925596822885,54.9911147186279,55.6896697549673,56.3882247913067,57.3361895902392,58.3753578143053,59.4145260383713,60.4536942624374,61.4928624865035,62.5320307105696,63.5711989346356,64.6103671587017,65.6495353827678,66.6887036068339,67.7278718308999,68.767040054966,69.8062082790321,70.8453765030982,71.8845447271642,72.9237129512303,73.9628811752964,75.0020493993625,76.0412176234286,77.0803858474946,78.1195540715607,79.1587222956268,80.0513683956731,80.0782995285257,80.1052306613783,80.1321617942309,80.1590929270835,80.1860240599361,80.2129551927887,80.2398863256413,80.2668174584939,80.2937485913465,80.3206797241991,80.3476108570516,80.3745419899042,80.4014731227568,80.4284042556095,80.455335388462,80.4822665213146,80.5091976541672,80.5361287870198,80.5630599198724,80.589991052725,80.6169221855776,80.6438533184302,80.6707844512828,80.6977155841354,80.724646716988,80.7515778498406,80.7785089826932,80.8054401155458,80.8323712483984,80.859302381251,80.8862335141036,80.9131646469562,80.9400957798088,80.9670269126614,80.993958045514,81.0208891783665,81.0478203112191,81.0747514440718,81.1016825769243,81.1286137097769,81.1555448426295,81.1824759754821,81.2094071083347,81.2363382411873};
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

  connect(hotWaterStorage.waterPortIn_primaryHeatSource, HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-32,-31.4},{-36,-31.4},{-36,-32},{-42,-32},{-42,-26}},
      color={175,0,0},
      thickness=0.5));
  connect(heat_toCHP.steam_a, hotWaterStorage.waterPortOut_primaryHeatSource) annotation (Line(
      points={{-48,-58},{-42,-58},{-42,-48},{-32,-48},{-32,-40.9}},
      color={0,131,169},
      thickness=0.5));
  connect(FluidFromHeatingGrid.steam_a, hotWaterStorage.waterPortIn_Grid) annotation (Line(
      points={{54,-44},{5.62,-44},{5.62,-44.7}},
      color={0,131,169},
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_Grid, FluidToHeatingGrid.steam_a) annotation (Line(
      points={{5.62,-32.16},{54,-32.16},{54,-16}},
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
  <p></p>
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
end CheckStratifiedHotWaterStorage_L3_Standbyloss;
