within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model TestElectrolyzerAndCavern
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

function plotResult

  constant String resultFileName = "TestElectrolyzerAndCavern.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 788, 420}, y={"electrolyzerAndCavern.collectCosts_PtG_Ely.P_ely", "electrolyzerAndCavern.P_set_ely"}, range={0.0, 650000.0, 0.0, 1000000000.0}, grid=true, filename="TestElectrolyzerAndCavern.mat", legends={"Power into Electrolyzer", "Available RE power"}, colors={{238,46,47}, {0,140,72}});
  createPlot(id=2, position={802, 0, 786, 420}, y={"CHP_Plant_two_fuels.collectCosts.der(m_CO2)"}, range={0.0, 650000.0, 15.0, 40.0}, grid=true, filename="TestElectrolyzerAndCavern.mat", legends={"CO2 Massflow"}, colors={{0,0,0}});
  createPlot(id=2, position={802, 0, 786, 207}, y={"CHP_Plant_two_fuels.collectCosts.m_CO2"}, range={0.0, 650000.0, -0.005, 0.02}, grid=true, legends={"CO2 emissions"}, subPlot=2, colors={{0,0,0}});
  createPlot(id=3, position={0, 457, 788, 419}, y={"electrolyzerAndCavern.Level"}, range={0.0, 7.0, 0.3695, 0.376}, grid=true, filename="TestElectrolyzerAndCavern.mat", legends={"Cavern Level (p.u.)"}, colors={{217,67,180}});
  createPlot(id=4, position={802, 457, 786, 419}, y={"CHP_Plant_two_fuels.collectCosts.der(C_fuel)"}, range={0.0, 650000.0, 1.0, 5.0}, grid=true, filename="TestElectrolyzerAndCavern.mat", legends={"Fuel costs (flow)"}, colors={{244,125,35}});
  createPlot(id=4, position={802, 457, 786, 207}, y={"CHP_Plant_two_fuels.collectCosts.C_fuel"}, range={0.0, 650000.0, -500000.0, 2000000.0}, grid=true, legends={"Fuel costs (cummulative)"}, subPlot=2, colors={{244,125,35}});

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  TransiEnt.Producer.Gas.Electrolyzer.Systems.ElectrolyzerAndCavern electrolyzerAndCavern(P_nom_ely=18*40e6) annotation (Placement(transformation(extent={{-48,-22},{-28,-2}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_fuel_GuD(y=CHP_Plant_two_fuels.Q_flow_input_basefuel)
                                                                                               annotation (Placement(transformation(
        extent={{9,-5},{-9,5}},
        rotation=0,
        origin={-31,29})));
  Modelica.Blocks.Sources.RealExpression P_set_WW(y=-350e6)                         annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-9,27})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(y=-100e6) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={2,27})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer ElectricGrid(useInputConnectorP=false, P_el=1000e6) annotation (Placement(transformation(extent={{14,16},{34,36}})));
  Modelica.Blocks.Sources.RealExpression m_flow_return3(y=Q_flow_set.y/(TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        12e5,
        130 + 273.15,
        simCenter.fluid1.xi_default) - TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        12e5,
        45 + 273.15,
        simCenter.fluid1.xi_default)))                                                        annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={5,-47})));
  Modelica.Blocks.Sources.RealExpression T_return5(y=45)                                    annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={16,-47})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow3(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={9,-32})));
  inner SimCenter           simCenter(                                                              k_H2_fraction=0.6)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics           modelStatistics annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{34,-36},{62,-10}})));
  Components.Boundaries.FluidFlow.BoundaryVLE_pTxi massflowSink(boundaryConditions(p_const=12e5, T_const=120 + 273.15)) annotation (Placement(transformation(extent={{38,-12},{30,0}})));
  Components.Visualization.PQDiagram_Display pQDiagram_Display(PQCharacteristics=Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WWGuD()) annotation (Placement(transformation(extent={{44,-62},{64,-42}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.H2CofiringCHP CHP_Plant_two_fuels(
    PQCharacteristics=Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WWGuD(),
    useConstantSigma=true,
    sigma=0.95,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas,
    P_grad_max_star=0.08,
    P_el_n=470e6,
    typeOfCO2AllocationMethod=1,
    p_nom=12e5,
    m_flow_nom=200,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        12e5,
        130 + 273.15,
        simCenter.fluid1.xi_default),
    useEfficiencyForInit=false,
    useConstantEfficiencies=false) annotation (Placement(transformation(extent={{-14,-14},{6,6}})));

  Modelica.Blocks.Sources.Sine P_set_PtG(
    freqHz=1/(3600*24),
    amplitude=(20*40e6)/2,
    offset=20*40e6/2 + 1e8)
                      annotation (Placement(transformation(extent={{-82,12},{-62,32}})));
equation
  connect(Q_flow_fuel_GuD.y, electrolyzerAndCavern.Q_flow_fuel_GuD) annotation (Line(points={{-40.9,29},{-40.9,14.5},{-32.6,14.5},{-32.6,-0.8}}, color={0,0,127}));
  connect(m_flow_return3.y,massflow_Tm_flow3. m_flow) annotation (Line(points={{5,-41.5},{5,-39.75},{7.2,-39.75},{7.2,-36.8}},           color={0,0,127}));
  connect(T_return5.y,massflow_Tm_flow3. T) annotation (Line(points={{16,-41.5},{12,-41.5},{12,-36.8},{9,-36.8}},        color={0,0,127}));
  connect(electrolyzerAndCavern.h2Available, CHP_Plant_two_fuels.h2Available) annotation (Line(points={{-28.6,-3.8},{-22,-3.8},{-22,-4.90909},{-13.4,-4.90909}},
                                                                                                                                                   color={255,0,255}));
  connect(infoBoxLargeCHP.eye, CHP_Plant_two_fuels.eye) annotation (Line(points={{35.4,-20.8727},{32,-20.8727},{32,-14},{24,-14},{24,-13},{7,-13},{7,-13.0909}},
                                                                                                                                                             color={28,108,200}));
  connect(ElectricGrid.epp, CHP_Plant_two_fuels.epp) annotation (Line(
      points={{14.2,26},{10,26},{10,0.181818},{5.5,0.181818}},
      color={0,135,135},
      thickness=0.5));
  connect(massflow_Tm_flow3.fluidPortOut, CHP_Plant_two_fuels.inlet) annotation (Line(
      points={{9.06,-28.08},{10,-28.08},{10,-8},{6.2,-8}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP_Plant_two_fuels.P_set, P_set_WW.y) annotation (Line(points={{-10.1,5.27273},{-10.1,12.6},{-9,12.6},{-9,17.1}},
                                                                                                                         color={0,0,127}));
  connect(CHP_Plant_two_fuels.Q_flow_set, Q_flow_set.y) annotation (Line(points={{-0.3,5.27273},{-0.3,11.6},{2,11.6},{2,17.1}},
                                                                                                                            color={0,0,127}));
  connect(pQDiagram_Display.eyeIn, CHP_Plant_two_fuels.eye) annotation (Line(points={{41.2,-52},{24,-52},{24,-13.0909},{7,-13.0909}},
                                                                                                                            color={28,108,200}));
  connect(electrolyzerAndCavern.P_set_ely, P_set_PtG.y) annotation (Line(
      points={{-44.2,-1},{-52,-1},{-52,22},{-61,22}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP_Plant_two_fuels.outlet, massflowSink.fluidPortIn) annotation (Line(
      points={{6.2,-5.45455},{28,-5.45455},{28,-6.12},{30.08,-6.12}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=604800));
end TestElectrolyzerAndCavern;
