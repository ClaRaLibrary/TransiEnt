within TransiEnt.Producer.Electrical.Controllers.Check;
model TestPrimaryBalancingController "Example how to calculate the demand of primary balancing power"
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
  inner TransiEnt.SimCenter simCenter(
    n_consumers=1,
    P_consumer={300e9},
    T_grid=7.5) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics                    modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  PrimaryBalancingController PBC(
    use_SlewRateLimiter=true,    integratePowerNeg=false, integratePowerPos=false)
                                 annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.TimeTable DiscontiniousTestSchedule(table=[0,50; 3600,50; 43000,50.2; 53000,50.2; 100000,49.8; 110000,49.8])
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  Modelica.Blocks.Continuous.FirstOrder f_grid(
    k=1,
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=50) annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant f_n(k=simCenter.f_n)   annotation (Placement(transformation(extent={{-42,-44},{-22,-24}})));
equation
  connect(DiscontiniousTestSchedule.y,f_grid. u) annotation (Line(points={{-51,0},{-47.5,0},{-44,0}}, color={0,0,127}));
  connect(feedback.y, PBC.delta_f) annotation (Line(points={{9,0},{19,0},{19,0}},   color={0,0,127}));
  connect(f_grid.y, feedback.u1) annotation (Line(points={{-21,0},{-8,0},{-8,0}}, color={0,0,127}));
  connect(f_n.y, feedback.u2) annotation (Line(points={{-21,-34},{-16,-34},{-16,-32},{0,-32},{0,-8}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestPrimaryBalancingController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"PBC.delta_f"}, range={0.0, 120000.0, -0.25, 0.25}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"PBC.P_PBP_set"}, range={0.0, 120000.0, -4000000000.0, 4000000000.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=120000),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for primary balancing controller</p>
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
end TestPrimaryBalancingController;
