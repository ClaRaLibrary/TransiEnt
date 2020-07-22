within TransiEnt.Components.Statistics.Collectors.LocalCollectors.Check;
model CheckStorageCost

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

  extends Basics.Icons.Checkmodel;
  PlantModel plant(storageCost(P_n=1e6, Delta_E_n=1e6*3600))
                   annotation(Placement(transformation(extent={{-40,-18},{2,24}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-20,62},{0,82}})));

  inner SimCenter simCenter(Duration=1,InterestRate=0.05)
                            annotation (Placement(transformation(extent={{-68,60},{-48,80}})));

  model PlantModel

  outer ModelStatistics modelStatistics;

    final parameter TransiEnt.Basics.Units.MonetaryUnit C_invest_expected=1e3*150 + 1e3*600;
    final parameter TransiEnt.Basics.Units.MonetaryUnit C_fuel_expected=0;
    final parameter TransiEnt.Basics.Units.MonetaryUnit C_OM_fix_expected=C_invest_expected*0.01;
    final parameter TransiEnt.Basics.Units.MonetaryUnit C_CO2=0;
    final parameter TransiEnt.Basics.Units.MonetaryUnit C_total_expected=C_invest_expected*(1 + 0.05) + C_fuel_expected + C_OM_fix_expected + C_CO2;

  StorageCost storageCost(
      redeclare model StorageCostModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.LithiumIonBattery(lifeTime=1)) annotation(Placement(transformation(extent={{-36,-4},{-16,16}})));

  equation
  connect(modelStatistics.costsCollector, storageCost.costsCollector);

  end PlantModel;

public
function plotResult

  constant String resultFileName = "CheckStorageCost.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1616, 851}, y={"plant.storageCost.dynamic_C_OM", "plant.C_OM_fix_expected"}, range={0.0, 32000000.0, -1.0, 8.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFileName);
createPlot(id=1, position={0, 0, 1616, 423}, y={"plant.C_total_expected", "plant.storageCost.C", "plant.storageCost.C_inv",
"plant.C_invest_expected"}, range={0.0, 32000000.0, -100000.0, 900000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Dot},filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (experiment(StopTime=3.16224e+007), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the general storage cost model</p>
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
end CheckStorageCost;
