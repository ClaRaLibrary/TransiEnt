within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ControlGasPressure


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Pressure p_min;
  parameter Modelica.Units.SI.Pressure p_min_backin;
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID "Type of controller" annotation (Dialog(group="General Design of Controller"));

  //----------------------------------------
  //Time Resononse of the Controller -------

  parameter Real k=1 "Gain of Proportional block" annotation (Dialog(group="Time Response of the Controller"));
  parameter Modelica.Units.SI.Time Tau_i(min=Modelica.Constants.small) = 0.5 "1/Ti is gain of integrator block" annotation (Dialog(enable=controllerType == Modelica.Blocks.Types.SimpleController.PI or controllerType == Modelica.Blocks.Types.SimpleController.PID, group="Time Response of the Controller"));
  parameter Modelica.Units.SI.Time Tau_d(min=0) = 0.1 "Gain of derivative block" annotation (Dialog(enable=controllerType == Modelica.Blocks.Types.SimpleController.PD or controllerType == Modelica.Blocks.Types.SimpleController.PID, group="Time Response of the Controller"));

  parameter Integer n_gasPortOut_split=1 annotation (Dialog(group="GasPortSplitter"));
  parameter Real splitRatio[max(1, n_gasPortOut_split)]={0.1} annotation (Dialog(group="GasPortSplitter"));
  final parameter Real splitRatio_internal[max(1, n_gasPortOut_split)](fixed=false);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput p_gas[n_gasPortOut_split] annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Modelica.Blocks.Logical.Hysteresis hysteresis[n_gasPortOut_split](each uLow=p_min, each uHigh=p_min_backin) annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  TransiEnt.Basics.Blocks.LimPID PID[n_gasPortOut_split](
    each controllerType=controllerType,
    y_max=splitRatio_internal,
    each y_min=0,
    each k=k,
    each Tau_i=Tau_i,
    each Tau_d=Tau_d) annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  Modelica.Blocks.Logical.Switch switch2[n_gasPortOut_split] annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=p_min) annotation (Placement(transformation(extent={{-84,-78},{-64,-58}})));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(extent={{34,-38},{54,-18}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=n_gasPortOut_split) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={26,-46})));
  Modelica.Blocks.Routing.Replicator replicator(nout=n_gasPortOut_split) annotation (Placement(transformation(extent={{-56,-73},{-46,-63}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=1) annotation (Placement(transformation(extent={{2,-32},{22,-12}})));

initial equation
  for i in 1:max(1, n_gasPortOut_split) loop
    splitRatio_internal[i] = max(0, splitRatio[i]);
  end for;

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p_gas, hysteresis.u) annotation (Line(points={{-120,-80},{-90,-80},{-90,-30},{-82,-30}}, color={0,0,127}));
  connect(hysteresis.y, switch2.u2) annotation (Line(points={{-59,-30},{-44,-30},{-44,-60},{-38,-60}}, color={255,0,255}));
  connect(switch2.y, PID.u_s) annotation (Line(points={{-15,-60},{-8,-60}}, color={0,0,127}));
  connect(p_gas, PID.u_m) annotation (Line(points={{-120,-80},{4.1,-80},{4.1,-72}}, color={0,0,127}));
  connect(switch2.u1, p_gas) annotation (Line(points={{-38,-52},{-90,-52},{-90,-80},{-120,-80}}, color={0,0,127}));
  connect(multiSum.y, add.u2) annotation (Line(points={{26,-38.98},{26,-34},{32,-34}}, color={0,0,127}));
  connect(PID.y, multiSum.u) annotation (Line(points={{15,-60},{26,-60},{26,-52}}, color={0,0,127}));
  connect(replicator.y, switch2.u3) annotation (Line(points={{-45.5,-68},{-38,-68}}, color={0,0,127}));
  connect(realExpression.y, replicator.u) annotation (Line(points={{-63,-68},{-57,-68}}, color={0,0,127}));
  connect(realExpression1.y, add.u1) annotation (Line(points={{23,-22},{32,-22}}, color={0,0,127}));
  connect(add.y, y) annotation (Line(points={{55,-28},{76,-28},{76,0},{110,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for automatic shut-down of arbitrary plant if gas pressure drops below <span style=\"font-family: Courier New;\">p_min</span> and return to service if pressure rises again above <span style=\"font-family: Courier New;\">p_min_backin.</span></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end ControlGasPressure;
