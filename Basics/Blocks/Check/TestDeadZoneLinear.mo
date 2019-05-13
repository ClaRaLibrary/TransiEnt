within TransiEnt.Basics.Blocks.Check;
model TestDeadZoneLinear "Model for testing the DeadZoneLinear model"
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
  Modelica.Blocks.Sources.Ramp ramp(
    height=2,
    offset=-1,
    duration=1,
    startTime=1) annotation (Placement(transformation(extent={{-94,6},{-66,34}})));
  DeadZoneLinear deadZoneLinear(
    uMax=0.2,
    uMin=-0.2,
    deadZoneAtInit=true) annotation (Placement(transformation(extent={{-20,4},{10,34}})));
  DeadZoneLinear deadZoneLinearSmooth(
    typeTransition=2,
    uMaxSmooth=0.3,
    uMax=0.1,
    deadZoneAtInit=true) annotation (Placement(transformation(extent={{-20,-50},{10,-20}})));
equation
  connect(ramp.y, deadZoneLinear.u) annotation (Line(points={{-64.6,20},{-23,20},{-23,19}}, color={0,0,127}));
  connect(ramp.y, deadZoneLinearSmooth.u) annotation (Line(points={{-64.6,20},{-44,20},{-44,-35},{-23,-35}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          experiment(StopTime=3),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for DeadZoneLinaer</p>
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
end TestDeadZoneLinear;
