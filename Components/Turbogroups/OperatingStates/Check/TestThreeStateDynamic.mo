within TransiEnt.Components.Turbogroups.OperatingStates.Check;
model TestThreeStateDynamic "Model for testing the three state dynamic"

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
  TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic threeStateDynamic(
    t_startup=0,
    t_eps=950,
    useThresh=true,
    smoothShutDown=true)
                    annotation (Placement(transformation(extent={{14,-26},{50,10}})));
  Modelica.Blocks.Sources.Trapezoid Trapezoid(
    amplitude=-1,
    rising=900,
    falling=900,
    period=86400,
    width=60000) annotation (Placement(transformation(extent={{-62,-46},{-42,-26}})));
  Modelica.Blocks.Sources.Step Step(
    height=0.8,
    offset=0.2,
    startTime=7.5e4) annotation (Placement(transformation(extent={{-64,-2},{-44,18}})));
  Modelica.Blocks.Math.Product P_set annotation (Placement(transformation(extent={{-28,-24},{-8,-4}})));
equation
  connect(Trapezoid.y, P_set.u2) annotation (Line(points={{-41,-36},{-36,-36},{-36,-20},{-30,-20}}, color={0,0,127}));
  connect(Step.y, P_set.u1) annotation (Line(points={{-43,8},{-36,8},{-36,-8},{-30,-8}}, color={0,0,127}));
  connect(P_set.y, threeStateDynamic.P_set_star) annotation (Line(points={{-7,-14},{4,-14},{4,-8},{14,-8}}, color={0,0,127}));
  connect(threeStateDynamic.P_set_star_lim, threeStateDynamic.P_actual_star) annotation (Line(
      points={{52.16,-8},{72,-8},{72,-50},{32,-50},{32,-26}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-50,80},{38,38}},
          lineColor={0,0,0},
          textString="Look at:
P_set
threeStateDynamic.y
halt.active
startup.active
operating.active")}),
    experiment(StopTime=90000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ThreeStateDynamic model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
end TestThreeStateDynamic;
