within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Check;
model CheckStratifiedHotWaterStorage_L4_Loading "Validation of one dimensional hot water storage with CHP loading scenario"
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

   constant SI.Temperature Tstart[hotWaterStorage.N_cv] = fill(273.15, hotWaterStorage.N_cv) +{66.99042,66.86039,66.73036,66.60033,66.4703,66.34027,66.21024,66.08021,65.95018,65.82015,65.69012,65.56009,65.43006,65.30003,65.17,65.03997,64.90994,64.77991,64.64988,64.51985,64.38982,64.25979,64.12976,63.99973,63.8697,63.73967,63.60964,63.47961,63.34958,63.21955,63.08952,62.95949,62.82946,62.69943,62.5694,62.43937,62.30934,62.17931,62.04928,61.91925,61.78922,61.65919,61.52916,61.39913,61.2691,61.21146364,61.15382727,61.09619091,61.03855455,60.98091818,60.92328182,60.86564545,60.80800909,60.75037273,60.69273636,60.6351,60.57746364,60.51982727,60.46219091,60.40455455,60.34691818,60.28928182,60.23164545,60.17400909,60.11637273,60.05873636,60.0011,59.85612778,59.71115556,59.56618333,59.42121111,59.27623889,59.13126667,58.98629444,58.84132222,58.69635,58.55137778,58.40640556,58.26143333,58.11646111,57.97148889,57.82651667,57.68154444,57.53657222,57.3916,57.24662778,57.10165556,56.95668333,56.81171111,56.66673889,56.52176667,56.37679444,56.23182222,56.08685,55.94187778,55.79690556,55.65193333,55.50696111,55.36198889,55.21701667};
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

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 hotWaterStorage(
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
    V=1,
    k=0.5574,
    N_cv=100,
    rho=1000) annotation (Placement(transformation(extent={{-26,-66},{12,-28}})));

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

  connect(hotWaterStorage.waterPortIn_prod[1], HeatFromPowerPlant.steam_a) annotation (Line(
      points={{-26,-39.4},{-30,-39.4},{-30,-40},{-36,-40},{-36,-34}},
      color={175,0,0},
      thickness=0.5));
  connect(FluidFromHeatingGrid.steam_a, hotWaterStorage.waterPortIn_grid[1]) annotation (Line(
      points={{60,-52},{12,-52},{12,-54.6}},
      color={0,131,169},
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_grid[1], FluidToHeatingGrid.steam_a) annotation (Line(
      points={{12,-39.4},{60,-39.4},{60,-24}},
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
equation
  connect(heat_toCHP.steam_a, hotWaterStorage.waterPortOut_prod[1]) annotation (Line(
      points={{-42,-66},{-35,-66},{-35,-54.6},{-26,-54.6}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for loading HotWaterStorage_constProp_L4</p>
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
end CheckStratifiedHotWaterStorage_L4_Loading;
