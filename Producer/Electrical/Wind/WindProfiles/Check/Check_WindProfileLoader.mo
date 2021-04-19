within TransiEnt.Producer.Electrical.Wind.WindProfiles.Check;
model Check_WindProfileLoader
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
  WindProfileLoader windProfileLoader(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2013_LK_E66_HH,
    P_el_n=360e6) annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power WindGenerator annotation (choicesAllMatching=true, Placement(transformation(extent={{-23,14},{-3,34}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{-24,-24},{-4,-4}})));
  WindProfileLoader windProfileLoader1(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2011_TenneT_Offshore_900s,
    P_el_n=360e6) annotation (Placement(transformation(extent={{-92,-86},{-72,-66}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power WindGenerator1 annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-65,-40})));
equation
  connect(windProfileLoader.y1, WindGenerator.P_el_set)
    annotation (Line(points={{-59,56},{-19,56},{-19,36}}, color={0,0,127}));
  connect(ElectricGrid.epp, WindGenerator.epp) annotation (Line(
      points={{-24,-14},{-44,-14},{-44,24},{-23,24}},
      color={0,135,135},
      thickness=0.5));
  connect(windProfileLoader1.y1, WindGenerator1.P_el_set)
    annotation (Line(points={{-71,-76},{-59,-76},{-59,-52}}, color={0,0,127}));
  connect(WindGenerator1.epp, WindGenerator.epp) annotation (Line(
      points={{-55,-40},{-44,-40},{-44,24},{-23,24}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "Check_WindProfileLoader.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 681}, y={"WindGenerator.epp.P", "WindGenerator1.epp.P"}, range={0.0, 30000.0, -400000000.0, -100000000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the WindProfileLoader model</p>
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
end Check_WindProfileLoader;
