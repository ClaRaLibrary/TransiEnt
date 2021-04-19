within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Check;
model TestPEM "Example of a fuel cell in a domestic application that follows load such that power grid consumption is minimized"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Thermal.FluidHeatFlow.Examples.Utilities.DoubleRamp Load(
    startTime=5,
    interval=5,
    duration_1=5,
    duration_2=5,
    offset=1000,
    height_1=200,
    height_2=-400)
                 annotation (Placement(transformation(extent={{-14,78},{6,98}})));
  PEM FC(
    T_nom=75 + 273,
    A_cell=0.0625,
    i_0=0.08,
    i_L=6e4,
    Ri=6e-5,
    cp=850,
    ka=0.3,
    i_Loss=0.2,
    no_Cells=20,
    usePowerPort=true,
    T_stack(start=80 + 273),
    v_n=0.733,
    is_Shutdown(start=true),
    redeclare Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(
      useInputConnectorP=true,
      useInputConnectorQ=false,
      useCosPhi=true,
      cosphi_boundary=1) "PQ-Boundary for ApparentPowerPort",
    redeclare Basics.Interfaces.Electrical.ApparentPowerPort epp) annotation (Placement(transformation(extent={{-20,-50},{22,-8}})));
  Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{80,60},{100,80}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformer PowerConverter(
    UseRatio=false,
    U_S=0.733,
    eta=1,
    U_P=230)
           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,24})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower LocalDemand(
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{24,60},{4,80}})));
  TransiEnt.Components.Sensors.ElectricReactivePower LocalGridSensor(change_of_sign=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={46,70})));
TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Controller.PowerController PowerController(k=1000) annotation (Placement(transformation(rotation=0, extent={{-34,18},{-54,38}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow AirSource(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=2.55e-7,
    xi_const={0.01,0.7},
    T_const=25 + 273,
    medium=FC.Air)    annotation (Placement(transformation(
        extent={{6.5,-9},{-6.5,9}},
        rotation=180,
        origin={-45.5,-49})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi AirSink(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=200 + 273.15,
    medium=FC.Air)        annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={59,-42})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SyngasSink(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=200 + 273.15,
    medium=FC.Syngas) annotation (Placement(transformation(
        extent={{-6,-9},{6,9}},
        rotation=180,
        origin={52,-7})));
TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Controller.LambdaController LambdaHController(
    T=0.01,
    m_flow_rampup=0.00025,
    k=0.002) annotation (Placement(transformation(extent={{26,-92},{6,-72}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SyngasSource(
    variable_T=false,
    m_flow_const=5.1e-2,
    variable_m_flow=true,
    variable_xi=false,
    xi_const={0.11,0.04,0.13,0.25,0.04,0.12},
    T_const=80 + 273.15,
    medium=FC.Syngas) annotation (Placement(transformation(extent={{-54,-19},{-38,-3}})));
equation
  connect(Load.y, LocalDemand.P_el_set) annotation (Line(
      points={{7,88},{20,88},{20,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LocalGridSensor.epp_OUT, ElectricGrid.epp) annotation (Line(
      points={{55.4,70},{72,70},{72,70},{80,70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(LocalDemand.epp, LocalGridSensor.epp_IN) annotation (Line(
      points={{24,70},{42,70},{42,70},{36.8,70}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(FC.lambda_H,LambdaHController. u1) annotation (Line(
      points={{22,-45.8},{26,-45.8},{26,-48},{34,-48},{34,-76},{26,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SyngasSource.m_flow, LambdaHController.y) annotation (Line(
      points={{-54,-6.2},{-56,-6.2},{-56,-6},{-62,-6},{-62,-82},{5.2,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FC.feedh, SyngasSource.gas_a) annotation (Line(
      points={{-20,-16.4},{-28.79,-16.4},{-28.79,-11},{-38,-11}},
      color={255,170,85},
      thickness=0.5));
  connect(FC.feeda, AirSource.gas_a) annotation (Line(
      points={{-20,-41.6},{-31.58,-41.6},{-31.58,-49},{-39,-49}},
      color={255,170,85},
      thickness=0.5));
  connect(FC.drainh, SyngasSink.gas_a) annotation (Line(
      points={{22,-16.4},{32,-16.4},{32,-7},{46,-7}},
      color={255,170,85},
      thickness=0.5));
  connect(FC.draina, AirSink.gas_a) annotation (Line(
      points={{22,-41.6},{30.79,-41.6},{30.79,-42},{52,-42}},
      color={255,170,85},
      thickness=0.5));
  connect(PowerController.deltaP, LocalGridSensor.P) annotation (Line(points={{-35,34},{-35,34},{-28,34},{-28,50},{42.2,50},{42.2,62.2}}, color={0,0,127}));
  connect(PowerController.V_cell, FC.V_stack) annotation (Line(points={{-35,22.6},{-35,22},{-28,22},{-28,8},{76,8},{76,-29},{22,-29}},
                                                                                                    color={0,0,127}));
  connect(PowerController.y, FC.I_load) annotation (Line(points={{-55,28},{-70,28},{-70,-30.26},{-16.22,-30.26}},          color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestPEM.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 681}, y={"LocalDemand.epp.P"}, range={0.0, 40.0, 600.0, 1400.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 166}, y={"PowerConverter.epp_p.P"}, range={0.0, 40.0, -1500.0, 500.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 167}, y={"PowerController.i_max", "PowerController.i_min", "PowerController.y"}, range={0.0, 40.0, -20000.0, 60000.0}, grid=true, subPlot=3, colors={{28,108,200}, {0,140,72}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 166}, y={"LambdaHController.Lambda_H_target", "FC.lambda_H"}, range={0.0, 40.0, 1.0, 2.0}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(PowerConverter.epp_p, LocalGridSensor.epp_IN) annotation (Line(
      points={{0,34},{0,40},{32,40},{32,70},{36.8,70}},
      color={0,127,0},
      thickness=0.5));
  connect(PowerConverter.epp_n, FC.epp) annotation (Line(
      points={{0,14},{0,-16.82},{1,-16.82}},
      color={0,127,0},
      thickness=0.5));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=40),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the PEM model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestPEM;
