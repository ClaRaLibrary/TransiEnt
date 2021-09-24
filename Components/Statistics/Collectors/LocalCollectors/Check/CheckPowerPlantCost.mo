within TransiEnt.Components.Statistics.Collectors.LocalCollectors.Check;
model CheckPowerPlantCost


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




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
      P_el_is=-100e3*time/31622400,
      Q_flow_fuel_is=120e3*time/31622400,
      produces_Q_flow=false)    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));

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
  annotation (experiment(StopTime=3.16224e+007), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the cost model of the different power plants</p>
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
end CheckPowerPlantCost;
