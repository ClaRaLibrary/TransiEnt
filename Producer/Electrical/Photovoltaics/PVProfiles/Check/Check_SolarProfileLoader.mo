within TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.Check;
model Check_SolarProfileLoader "Model for testing the SolarProfileLoader model"

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



 extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power SolarGenerationPark annotation (choicesAllMatching=true, Placement(transformation(extent={{-19,-2},{-39,18}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{22,-2},{42,18}})));
  SolarProfileLoader solarProfileLoader(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2011_Gesamt_900s,
    P_el_n=1e6) annotation (Placement(transformation(extent={{-72,36},{-52,56}})));
equation
  connect(ElectricGrid.epp, SolarGenerationPark.epp) annotation (Line(
      points={{22,8},{22,8},{-19,8}},
      color={0,135,135},
      thickness=0.5));
  connect(solarProfileLoader.y1, SolarGenerationPark.P_el_set) annotation (Line(points={{-51,46},{-23,46},{-23,20}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "Check_SolarProfileLoader.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=3, position={809, 0, 791, 695}, y={"SolarGenerationPark.P_el_set", "SolarGenerationPark.epp.P"}, range={0.0, 2000000.0, -300000.0, 20000.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}}, range2={0.46, 0.92},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3.154e+007, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the SolarProfileLoader model</p>
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
end Check_SolarProfileLoader;
