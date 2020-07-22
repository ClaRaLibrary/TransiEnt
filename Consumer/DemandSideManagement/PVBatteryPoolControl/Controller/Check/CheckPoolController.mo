within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check;
model CheckPoolController "Tester for PoolController"
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

model Unit "Unit model just for this tester"
  extends TransiEnt.Basics.Icons.Model;
  Base.PoolControlBus bus annotation (Placement(transformation(extent={{-14,-14},{16,16}})));
  Modelica.Blocks.Interfaces.RealInput value[param.nSystems];
    outer Base.PoolParameter param;
  parameter Integer index;

equation
  for i in 1:param.nSystems loop
    if i==index then
      value[i] =  500e3*index*(0.5+0.5*cos(2*3.14*time/86400*index/4));
    else
      value[i]=0;
    end if;
  end for;
    connect(bus.P_potential_pbp, value);
end Unit;

  inner Base.PoolParameter param(nSystems=3, P_el_pbp_total=1e6) annotation (Placement(transformation(extent={{-30,42},{0,72}})));
  Unit unit[param.nSystems](index=1:param.nSystems) annotation (Placement(transformation(extent={{-58,-16},{-28,14}})));
  PoolController ctrl annotation (Placement(transformation(extent={{28,-16},{58,14}})));

  Base.PoolControlBusSumUp poolControlBusSumUp annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
equation
  connect(poolControlBusSumUp.poolControlBus_in, unit.bus) annotation (Line(
      points={{-14,0},{-42.85,0},{-42.85,-0.85}},
      color={255,204,51},
      thickness=0.5));
  connect(poolControlBusSumUp.poolControlBus_out, ctrl.poolControlBus) annotation (Line(
      points={{6,0},{28,0},{28,-1}},
      color={255,204,51},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "CheckPoolController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1616, 851}, y={"poolControlBusSumUp.poolControlBus_out.P_potential_pbp[1]", "poolControlBusSumUp.poolControlBus_out.P_potential_pbp[2]",
 "poolControlBusSumUp.poolControlBus_out.P_potential_pbp[3]"}, range={0.0, 14.5, -500000.0, 2000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 281}, y={"param.P_el_pbp_total", "ctrl.P_PBP_set_sum"}, range={0.0, 14.5, 0.0, 1200.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, range2={0, 1e6},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 280}, y={"ctrl.poolControlBus.P_el_set_pbp[1]", "ctrl.poolControlBus.P_el_set_pbp[2]",
"ctrl.poolControlBus.P_el_set_pbp[3]"}, range={0.0, 14.5, -200000.0, 1200000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

    annotation (experiment(StopTime=7200, __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end plotResult;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PoolController</p>
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
end CheckPoolController;
