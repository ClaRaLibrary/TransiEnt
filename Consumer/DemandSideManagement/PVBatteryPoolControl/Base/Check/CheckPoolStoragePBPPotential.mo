within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base.Check;
model CheckPoolStoragePBPPotential
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
extends TransiEnt.Basics.Icons.Checkmodel;

Modelica.Blocks.Sources.Ramp ramp(
    height=2e3,
    offset=-1e3,
    duration=3600)                annotation (Placement(transformation(extent={{-78,0},{-38,36}})));
Modelica.Blocks.Sources.Constant P_max_unload_star(k=0.9)                annotation (Placement(transformation(extent={{-76,-58},{-36,-22}})));
Modelica.Blocks.Sources.Constant P_max_load_star(k=0.95)                annotation (Placement(transformation(extent={{-16,-94},{24,-58}})));
  inner PoolParameter param(
    nSystems=2,
    P_el_max_bat=1e3,
    P_el_min_bat=100) annotation (Placement(transformation(extent={{-100,62},{-60,98}})));

Base.PoolStoragePBPPotential unit[param.nSystems](index=1:param.nSystems) annotation (Placement(transformation(extent={{50,-3},{82,29}})));
equation
  for i in 1:param.nSystems loop
    connect(ramp.y, unit[i].P_is);
    for j in 1:param.nSystems loop
      connect(unit[i].P_max_load_star[j], P_max_load_star.y) annotation (Line(points={{50.16,9.32},{40,9.32},{40,-76},{26,-76}}, color={0,0,127}));
      connect(P_max_unload_star.y, unit[i].P_max_unload_star[j]) annotation (Line(points={{-34,-40},{-4,-40},{-4,-34},{50.48,-34},{50.48,1.96}}, color={0,0,127}));
    end for;
  end for;

public
function plotResult

  constant String resultFileName = "CheckPoolStoragePBPPotential.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={808, 0, 791, 653}, y={"unit[1].P_is"}, range={0.0, 4000.0, -1500.0, 1500.0}, grid=true, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={808, 0, 791, 323}, y={"unit[1].P_potential_PBP"}, range={0.0, 4000.0, -200.0, 1000.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

equation
  connect(ramp.y, unit[1].P_is) annotation (Line(points={{-36,18},{6,18},{6,19.24},{50.48,19.24}}, color={0,0,127}));
annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=4000, __Dymola_Algorithm="Lsodar"),
  __Dymola_experimentSetupOutput(
    textual=false,
    derivatives=false,
    events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PoolStoragePBPPotential</p>
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
end CheckPoolStoragePBPPotential;
