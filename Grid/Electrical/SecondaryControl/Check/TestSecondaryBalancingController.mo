within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestSecondaryBalancingController "Example how to calculate the demand of primary balancing power"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController SecondaryBalancingController(
    is_singleton=false,
    K_r=1e9/0.2,
    T_r=150,
    beta=0.5) annotation (Placement(transformation(extent={{6,-38},{42,-2}})));
  Modelica.Blocks.Sources.Step delta_f(
    offset=0,
    startTime=10,
    height=-0.2) annotation (Placement(transformation(extent={{-44,-30},{-24,-10}})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) annotation (Placement(transformation(extent={{-28,4},{-8,24}})));
  Modelica.Blocks.Sources.RealExpression
                               P_tie_is(y=if time < 10 then 0 else if time < 20 then -1e9 else 1e9)
                 annotation (Placement(transformation(extent={{-28,40},{-8,60}})));
equation
  connect(delta_f.y, SecondaryBalancingController.u) annotation (Line(points={{-23,-20},{-11.5,-20},{2.4,-20}}, color={0,0,127}));
  connect(P_tie_set.y, SecondaryBalancingController.P_tie_set) annotation (Line(points={{-7,14},{2,14},{8,14},{8,-3.62},{7.8,-3.62}},          color={0,0,127}));
  connect(P_tie_is.y, SecondaryBalancingController.P_tie_is) annotation (Line(points={{-7,50},{16.44,50},{16.44,-3.62}},color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestSecondaryBalancingController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1616, 851}, y={"delta_f.y"}, range={0.0, 20.0, -0.25, 0.050000000000000044}, grid=true, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 281}, y={"P_tie_is.y"}, range={0.0, 20.0, -1500000000.0, 1500000000.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 280}, y={"SecondaryBalancingController.y"}, range={0.0, 20.0, -2000000000.0, 500000000.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          textString="Edit Here",
          extent={{-80,-72},{2,-88}},
          lineColor={28,108,200})}),
    experiment(StopTime=30, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for SecondaryBalancingController</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity</span></b> </p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If frequency drops and tieline power is negative the disturbance is outside of the local grid and thus secondary balancing is not activated. If the disturbance is within the controlled grid (frequency devaition and tieline power have the same presign) control is activated.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestSecondaryBalancingController;
