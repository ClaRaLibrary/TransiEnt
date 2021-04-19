within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model TestElectrolyzerAndCavern "Model for testing a hydrogen cavern"
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

  Modelica.Blocks.Sources.RealExpression P_set_WW(y=-350e6)                         annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-9,27})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(y=-100e6) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={2,27})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer ElectricGrid(useInputConnectorP=false, P_el=1000e6) annotation (Placement(transformation(extent={{14,16},{34,36}})));
  inner SimCenter           simCenter(                                                              k_H2_fraction=0.6)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics           modelStatistics annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{34,-36},{62,-10}})));
  Components.Visualization.PQDiagram_Display pQDiagram_Display(PQCharacteristics=Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WWGuD()) annotation (Placement(transformation(extent={{44,-62},{64,-42}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.H2CofiringCHP CHP_Plant_two_fuels(
    PQCharacteristics=Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WWGuD(),
    useConstantSigma=true,
    sigma=0.95,
    quantity=1,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas,
    P_grad_max_star=0.08,
    P_el_n=470e6,
    typeOfCO2AllocationMethod=1,
    p_nom=12e5,
    m_flow_nom=200,
    h_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        12e5,
        130 + 273.15,
        simCenter.fluid1.xi_default),
    useEfficiencyForInit=false,
    useConstantEfficiencies=false,
    Q_flow_init=100e6)             annotation (Placement(transformation(extent={{-14,-14},{6,6}})));

  ElectrolyzerAndCavern                                             electrolyzerAndCavern(P_nom_ely=18*40e6,
    integrateMassFlowOut=false,
    integrateMassFlowIn=false)                                                                               annotation (Placement(transformation(extent={{-50,-22},{-30,-2}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_fuel_GuD(y=CHP_Plant_two_fuels.Q_flow_input_basefuel)
                                                                                               annotation (Placement(transformation(
        extent={{9,-5},{-9,5}},
        rotation=0,
        origin={-33,29})));
  Modelica.Blocks.Sources.Sine P_set_PtG(
    freqHz=1/(3600*24),
    amplitude=(20*40e6)/2,
    offset=20*40e6/2 + 1e8)
                      annotation (Placement(transformation(extent={{-84,12},{-64,32}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(T_const(displayUnit="degC") = 338.15, m_flow_const=1000) annotation (Placement(transformation(
        extent={{-7,-9},{7,9}},
        rotation=180,
        origin={47,-8})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{96,-3},{132,18}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    m_flow_nom=577.967,
    Delta_p=0,
    p_const(displayUnit="bar") = 1600000,
    T_const(displayUnit="degC")) annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={51,18})));
equation
  connect(infoBoxLargeCHP.eye, CHP_Plant_two_fuels.eye) annotation (Line(points={{35.4,-20.8727},{32,-20.8727},{32,-14},{24,-14},{24,-13},{7,-13},{7,-13.0909}},
                                                                                                                                                             color={28,108,200}));
  connect(ElectricGrid.epp, CHP_Plant_two_fuels.epp) annotation (Line(
      points={{14.2,26},{10,26},{10,0.181818},{5.5,0.181818}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP_Plant_two_fuels.P_set, P_set_WW.y) annotation (Line(points={{-10.1,5.27273},{-10.1,12.6},{-9,12.6},{-9,17.1}},
                                                                                                                         color={0,0,127}));
  connect(CHP_Plant_two_fuels.Q_flow_set, Q_flow_set.y) annotation (Line(points={{-0.3,5.27273},{-0.3,11.6},{2,11.6},{2,17.1}},
                                                                                                                            color={0,0,127}));
  connect(pQDiagram_Display.eyeIn, CHP_Plant_two_fuels.eye) annotation (Line(points={{41.2,-52},{24,-52},{24,-13.0909},{7,-13.0909}},
                                                                                                                            color={28,108,200}));
  connect(Q_flow_fuel_GuD.y,electrolyzerAndCavern. Q_flow_fuel_GuD) annotation (Line(points={{-42.9,29},{-42.9,14.5},{-34.6,14.5},{-34.6,-0.8}}, color={0,0,127}));
  connect(electrolyzerAndCavern.P_set_ely,P_set_PtG. y) annotation (Line(
      points={{-46.2,-1},{-54,-1},{-54,22},{-63,22}},
      color={0,135,135},
      thickness=0.5));
  connect(source.eye,quadruple. eye) annotation (Line(points={{40,-0.8},{40,7.5},{96,7.5}},                  color={190,190,190}));
  connect(CHP_Plant_two_fuels.inlet, source.steam_a) annotation (Line(
      points={{6.2,-8},{40,-8}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP_Plant_two_fuels.outlet, sink.steam_a) annotation (Line(
      points={{6.2,-5.45455},{36,-5.45455},{36,18},{44,18}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzerAndCavern.h2Available, CHP_Plant_two_fuels.h2Available) annotation (Line(points={{-30.6,-3.8},{-29.3,-3.8},{-29.3,-4.90909},{-13.4,-4.90909}}, color={255,0,255}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=604800),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for ElectrolyzerAndCavern</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
end TestElectrolyzerAndCavern;
