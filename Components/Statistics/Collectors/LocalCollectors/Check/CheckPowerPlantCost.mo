within TransiEnt.Components.Statistics.Collectors.LocalCollectors.Check;
model CheckPowerPlantCost

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

  extends Basics.Icons.Checkmodel;
  PlantModel plant;
  inner ModelStatistics modelStatistics;
  inner SimCenter simCenter(Duration=1, lifeTime_GT=1, InterestRate=0.05)
                            annotation (Placement(transformation(extent={{-84,66},{-64,86}})));

  final parameter TransiEnt.Basics.Units.MonetaryUnit C_invest_expected=100e3*0.5;
  final parameter TransiEnt.Basics.Units.MonetaryUnit C_fuel_expected=120e-3/2*8784*25;
  final parameter TransiEnt.Basics.Units.MonetaryUnit C_OM_var_expected=100e-3/2*8784*5;
  final parameter TransiEnt.Basics.Units.MonetaryUnit C_OM_fix_expected=0.0025*100e3;
  final parameter TransiEnt.Basics.Units.MonetaryUnit C_CO2_expexted=120e-3/2*8784*202*6e-3;
  final parameter TransiEnt.Basics.Units.MonetaryUnit C_total_expected=C_invest_expected*(1 + 0.05) + C_fuel_expected + C_OM_var_expected + C_OM_fix_expected + C_CO2_expexted;

  model PlantModel

  outer ModelStatistics modelStatistics;

  PowerPlantCost powerPlantCost(
      redeclare model PowerPlantCostModel = ConfigurationData.PowerProducerCostSpecs.GasTurbine,
      P_n=100e3,
      P_el_is=100e3*time/31622400,
      Q_flow_fuel_is=120e3*time/31622400)
                                annotation (Placement(transformation(extent={{-10,-6},{10,14}})));

  equation
  connect(modelStatistics.costsCollector, powerPlantCost.costsCollector);

  end PlantModel;

function plotResult

  constant String resultFileName = "CheckPowerPlantCost.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 1616, 851}, y={"plant.powerPlantCost.C", "plant.powerPlantCost.C_fuel", "plant.powerPlantCost.C_CO2_Certificates",
 "plant.powerPlantCost.C_inv", "C_invest_expected", "C_fuel_expected",
"C_total_expected", "C_CO2_expexted"}, range={0.0, 32000000.0, -5000.0, 75000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33},
{244,125,35}, {102,44,145}},filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (experiment(StopTime=3.16224e+007));
end CheckPowerPlantCost;
