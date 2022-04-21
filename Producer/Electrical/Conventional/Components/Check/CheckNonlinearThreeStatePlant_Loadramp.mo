within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckNonlinearThreeStatePlant_Loadramp "Example of the component NonlinearThreeStatePlant"



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  Components.NonlinearThreeStatePlant aSlewRateLimited2StatePBPlant(P_el_n=500e6, P_grad_max_star=0.1/60) annotation (Placement(transformation(extent={{-20,-54},{16,-20}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary(useInputConnector=false, f_set_const=simCenter.f_n) annotation (Placement(transformation(extent={{60,-38},{80,-18}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Thermal.FluidHeatFlow.Examples.Utilities.DoubleRamp doubleRamp(
    offset=-500e6,
    interval=3600,
    height_2=-250e6,
    duration_2=300,
    height_1=+450e6,
    duration_1=1,
    startTime=500)
    annotation (Placement(transformation(extent={{-74,20},{-54,40}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-28,-10},{-16,2}})));
  Modelica.Blocks.Sources.Ramp driveToMinLoad(
    offset=0,
    startTime=8000,
    height=200e6,
    duration=1)
    annotation (Placement(transformation(extent={{-76,-12},{-56,8}})));
  VDI3508Plant vDI3508Plant(
    P_el_n=500e6,
    P_grad_max_star=0.1/60,
    P_min_star=0.2) annotation (Placement(transformation(extent={{6,24},{30,44}})));
equation
  connect(aSlewRateLimited2StatePBPlant.epp, constantPotentialVariableBoundary.epp)
    annotation (Line(
      points={{14.2,-25.1},{36.64,-25.1},{36.64,-28},{60,-28}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(driveToMinLoad.y, multiSum.u[1]) annotation (Line(
      points={{-55,-2},{-40,-2},{-40,-1.9},{-28,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(doubleRamp.y, multiSum.u[2]) annotation (Line(
      points={{-53,30},{-32,30},{-32,-6.1},{-28,-6.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, aSlewRateLimited2StatePBPlant.P_el_set) annotation (Line(
      points={{-14.98,-4},{-14.98,-5},{-4.7,-5},{-4.7,-20.17}},
      color={0,0,127},
      smooth=Smooth.None));
public
function plotResult

  constant String resultFileName = "CheckNonlinearThreeStatePlant_Loadramp.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=2, position={809, 0, 791, 733}, y={"aSlewRateLimited2StatePBPlant.P_el_set", "aSlewRateLimited2StatePBPlant.epp.P"}, range={0.0, 5000.0, -550000000.0, 50000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(multiSum.y, vDI3508Plant.P_el_set) annotation (Line(points={{-14.98,-4},{2,-4},{2,43.9},{18.5,43.9}}, color={0,0,127}));
  connect(vDI3508Plant.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{29,41},{60,41},{60,-28}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -160},{100,100}})),
    experiment(StopTime=5000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-160},{100,100}})),
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
end CheckNonlinearThreeStatePlant_Loadramp;
