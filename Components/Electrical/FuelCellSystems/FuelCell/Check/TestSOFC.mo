within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Check;
model TestSOFC "Dieser Test nhert sich nun endlich einer komplett simulierbaren Version"
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Thermal.FluidHeatFlow.Examples.Utilities.DoubleRamp Load(
    interval=5,
    offset=1000,
    startTime=100,
    height_1=-200,
    duration_1=20,
    height_2=+400,
    duration_2=20) annotation (Placement(transformation(extent={{-14,80},{6,100}})));
  SOFC FC(
    T_nom=75 + 273,
    no_Cells=10,
    A_cell=0.0625,
    cp=850,
    ka=0.3,
    T_start=25 + 273)
            annotation (Placement(transformation(extent={{-44,-48},{-2,-6}})));
 TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformer PowerConverter(
    UseRatio=false,
    U_S=0.733,
    eta=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-22,24})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower LocalDemand(
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{24,62},{4,82}})));
  TransiEnt.Components.Sensors.ElectricReactivePower GridMeter annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={52,90})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceAir(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=2.55e-7,
    xi_const={0.01,0.7},
    T_const=25 + 273,
    medium=FC.Air)    annotation (Placement(transformation(
        extent={{6.5,-9},{-6.5,9}},
        rotation=180,
        origin={-73.5,-45})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SinkAir(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=200 + 273.15,
    medium=FC.Air)        annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={23,-46})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SinkSyngas(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=200 + 273.15,
    medium=FC.Syngas)     annotation (Placement(transformation(
        extent={{-6,-9},{6,9}},
        rotation=180,
        origin={16,-5})));
TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Controller.LambdaController lambdaHController(
    T=0.01,
    m_flow_rampup=0.00025,
    k=0.002) annotation (Placement(transformation(extent={{2,-92},{-18,-72}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceSyngas(
    variable_T=false,
    m_flow_const=5.1e-2,
    variable_m_flow=true,
    variable_xi=false,
    xi_const={0.11,0.04,0.13,0.25,0.04,0.12},
    T_const=80 + 273.15,
    medium=FC.Syngas)                annotation (Placement(transformation(extent={{-78,-22},{-62,-6}})));
  Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{80,78},{100,98}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
Controller.PowerController                                                          PowerController(k=100)
                                                                                                    annotation (Placement(transformation(rotation=0, extent={{-42,22},{-62,42}})));
equation
  connect(Load.y, LocalDemand.P_el_set) annotation (Line(
      points={{7,90},{20,90},{20,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SourceAir.gas_a, FC.feeda) annotation (Line(
      points={{-67,-45},{-55.5,-45},{-55.5,-38.55},{-43.16,-38.55}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SinkSyngas.gas_a, FC.drainh) annotation (Line(
      points={{10,-5},{8,-5},{8,-12.93},{-2,-12.93}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SinkAir.gas_a, FC.draina) annotation (Line(
      points={{16,-46},{6,-46},{6,-34.35},{-2.42,-34.35}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(LocalDemand.epp, GridMeter.epp_IN) annotation (Line(
      points={{24.1,71.9},{26,71.9},{26,90},{42.8,90}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(FC.lambda_H, lambdaHController.u1) annotation (Line(
      points={{-16.28,-50.1},{2,-50.1},{2,-48},{10,-48},{10,-76},{2,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SourceSyngas.gas_a, FC.feedh) annotation (Line(
      points={{-62,-14},{-52,-14},{-52,-12.51},{-43.58,-12.51}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SourceSyngas.m_flow, lambdaHController.y) annotation (Line(
      points={{-78,-9.2},{-80,-9.2},{-80,-8},{-86,-8},{-86,-82},{-18.8,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ElectricGrid.epp, GridMeter.epp_OUT) annotation (Line(points={{79.9,87.9},{70.95,87.9},{70.95,90},{61.4,90}}, color={0,127,0}));
  connect(PowerController.V_cell, FC.V_stack) annotation (Line(points={{-43,26.6},{-43,18},{-68,18},{-68,6},{24,6},{24,-26.16},{-1.58,-26.16}},
                                                                                                    color={0,0,127}));
  connect(PowerController.y, FC.I_load) annotation (Line(points={{-63,32},{-63,32},{-78,32},{-78,-28.26},{-40.22,-28.26}}, color={0,0,127}));
  connect(GridMeter.P, PowerController.deltaP) annotation (Line(points={{48.2,82.2},{48.2,64},{48,64},{48,46},{-36,46},{-36,38},{-43,38}}, color={0,0,127}));
  connect(FC.epp, PowerConverter.epp_n) annotation (Line(points={{-23,-14.82},{-23,6},{-22,6},{-22,14}}, color={0,127,0}));
  connect(PowerConverter.epp_p, GridMeter.epp_IN) annotation (Line(points={{-22,34},{-22,48},{36,48},{36,90},{42.8,90}}, color={0,127,0}));
public
function plotResult

  constant String resultFileName = "TestSOFC.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 681}, y={"LocalDemand.epp.P", "PowerConverter.epp_n.P"}, range={0.0, 200.0, -1000.0, 2000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 166}, y={"PowerController.i_max", "PowerController.i_min", "PowerController.y"}, range={0.0, 200.0, 0.0, 200.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 167}, y={"FC.T_start", "FC.T_stack", "FC.T_nom"}, range={0.0, 200.0, 20.0, 80.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 166}, y={"FC.Q_heater"}, range={0.0, 200.0, -2000.0, 4000.0}, grid=true, subPlot=4, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{34,36},{92,-98}},
          lineColor={28,108,200},
          textString="Look at:
LocalDemand.epp.P
PowerConverter.epp_sec.P

PowerController.i_max
PowerController.y
PowerController.i_min

FC.T_start
FC.T_stack
FC.T_nom

FC.Q_heater

")}),
    experiment(StopTime=200),
    __Dymola_experimentSetupOutput);
end TestSOFC;