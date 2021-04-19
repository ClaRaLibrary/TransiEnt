within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckBlackCoal_Schedule
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
  BlackCoal blackCoal(
    isPrimaryControlActive=false,
    P_el_n=506e6,
    eta_total=0.432,
    P_init_set=0,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    t_startup=2700,
    Turbine(T_plant=500, redeclare TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic operationStatus),
    P_grad_max_star=0.04/60) annotation (Placement(transformation(extent={{-14,-38},{6,-18}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,0; 0,-253e6; 10800,-253e6;
        10800,-506e6; 14400,-506e6; 14400,-379.5e6; 18000,-379.5e6; 18000,-253e6;
        21600,-253e6; 21600,-379.5e6; 25200,-379.5e6; 25200,-506e6; 28800,-506e6;
        28800,-187.22e6; 36000,-187.22e6; 36000,-506e6; 39600,-506e6; 39600,-253e6;
        43200,-253e6; 43200,-151.8e6; 50400,-151.8e6; 50400,-253e6; 54000,-253e6])
    annotation (Placement(transformation(extent={{-58,18},{-38,38}})));
equation
  connect(blackCoal.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{5,-21},{40,-21},{40,-22}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, blackCoal.P_el_set) annotation (Line(points={{-37,28},{-22,
          28},{-5.5,28},{-5.5,-18.1}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckBlackCoal_Schedule.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"blackCoal.P_el_set", "blackCoal.epp.P"}, range={0.0, 56000.0, -550000000.0, 50000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-30,94},{80,32}},
          lineColor={28,108,200},
          textString="compare with:
https://www.vgb.org/vgbmultimedia/333_Abschlussbericht-p-5968.pdf
(reference [1] in documentation of this model)
page 220, figure 19.3


Look at:
P_el_set
blackCoal.epp.P")}), experiment(StopTime=55000),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for black coal power plants</p>
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
<p>[1] C. Ziems, S. Meinke, J. Nocke, H. Weber, E. Hassel, &quot;<span style=\"font-family: sans-serif;\">Kraftwerksbetrieb bei Einspeisung von Windparks und Photovoltaikanlagen&quot;, Rostock, 2012</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CheckBlackCoal_Schedule;
