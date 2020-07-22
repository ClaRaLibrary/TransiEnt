within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckSimplePowerPlant "Example of the component SimplePowerPlant"

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

  TransiEnt.Consumer.Electrical.LinearElectricConsumer LinearConsumer(kpf=0.5) annotation (Placement(transformation(extent={{64,-78},{84,-58}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Step P_el_set(
    height=1.6e7,
    offset=-1.6e9,
    startTime=3600)
              annotation (Placement(transformation(extent={{-76,-56},{-56,-36}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Components.SimplePowerPlant Generator(P_el_n=1.6e9, fixedStartValue_w=true) annotation (Placement(transformation(extent={{-22,-102},{20,-58}})));
  Modelica.Blocks.Sources.Step P_load_step(
    height=1.6e7,
    offset=1.6e9,
    startTime=7200) annotation (Placement(transformation(extent={{10,-34},{30,-14}})));
equation

  connect(Generator.epp, LinearConsumer.epp) annotation (Line(
      points={{17.9,-64.6},{36,-64.6},{36,-68},{64.2,-68}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_set.y, Generator.P_el_set) annotation (Line(points={{-55,-46},{-28,-46},{-4.15,-46},{-4.15,-58.22}}, color={0,0,127}));
  connect(P_load_step.y, LinearConsumer.P_el_set) annotation (Line(points={{31,-24},{74,-24},{74,-56.4}},     color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckSimplePowerPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={809, 0, 791, 733}, y={"LinearConsumer.epp.f"}, range={0.0, 15000.0, 49.800000000000004, 50.050000000000004}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"Generator.epp.P", "Generator.P_el_set"}, range={0.0, 15000.0, -1620000000.0, -1580000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"LinearConsumer.epp.P", "P_load_step.y"}, range={0.0, 15000.0, 1595000000.0, 1620000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}), graphics={Text(
          extent={{2,4},{86,96}},
          lineColor={0,0,0},
          textString="Look at:
LinearConsumer.epp.f

Generator.P_el_set
Generator.epp.P

P_load_step.y
LinearConsumer.epp.P")}),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CheckSimplePowerPlant;
