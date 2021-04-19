within TransiEnt.Producer.Heat.SolarThermal.Control;
model ControllerPumpSolarCollectorDeltaT "Pump control for solarthermal collector by delta T"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Temperature T_solar_out_set=75+273.15 "Set value for the outlet temperature" annotation(Dialog(group="Controller"));
  parameter SI.TemperatureDifference delta_T_on=5 "The pump is turned on when temperature difference exceeds this value" annotation(Dialog(group="Controller"));
  parameter SI.TemperatureDifference delta_T_off=2 "The pump is turned off when temperature difference falls below this value" annotation(Dialog(group="Controller"));
  parameter SI.Time t_min_on=600 "Minimum on time" annotation(Dialog(group="Controller"));
  parameter SI.Time t_min_off=600 "Minimum off time" annotation(Dialog(group="Controller"));
  parameter SI.MassFlowRate y_small=1e-6 "Small value of y for when the pump is off"     annotation(Dialog(group="Controller"));
  parameter SI.Time Tau_out=0 "Outlet time constant" annotation(Dialog(group="Controller"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_solar_out annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_solar_in annotation (Placement(transformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.RealExpression OFF(y=y_small) annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=delta_T_off, uHigh=delta_T_on) annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Modelica.Blocks.Math.Add difference(k2=-1) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(init_state=2,
    t_min_on=t_min_on,
    t_min_off=t_min_off)                          annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  TransiEnt.Basics.Blocks.FirstOrder myFirstOrder(Tau=Tau_out, y_start=y_small) annotation (Placement(transformation(extent={{66,-10},{86,10}})));
  Modelica.Blocks.Sources.RealExpression T_solar_out_set_(y=T_solar_out_set) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,80})));
  replaceable TransiEnt.Basics.Blocks.LimPID PID(
    sign=-1,
    y_start=y_small,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    initOption=501,
    y_max=100,
    y_min=1e-6,
    k=1e6) annotation (Dialog(group="Controller"), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,40})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(difference.y, hysteresis.u) annotation (Line(points={{-45,0},{-38,0}}, color={0,0,127}));
  connect(T_solar_out, difference.u1) annotation (Line(points={{-100,40},{-76,40},{-76,6},{-68,6}}, color={0,0,127}));
  connect(T_solar_in, difference.u2) annotation (Line(points={{-100,-40},{-76,-40},{-76,-6},{-68,-6}}, color={0,0,127}));
  connect(switch.u2, onOffRelais.y) annotation (Line(points={{28,0},{15,0}}, color={255,0,255}));
  connect(hysteresis.y, onOffRelais.u) annotation (Line(points={{-15,0},{-6.4,0}},  color={255,0,255}));
  if Tau_out>0 then
  else
  end if;

  connect(myFirstOrder.y, y) annotation (Line(points={{87,0},{110,0}}, color={0,0,127}));
  connect(switch.y, myFirstOrder.u) annotation (Line(points={{51,0},{64,0}}, color={0,0,127}));
  connect(OFF.y, switch.u3) annotation (Line(points={{11,-30},{20,-30},{20,-8},{28,-8}}, color={0,0,127}));
  connect(T_solar_out_set_.y, PID.u_s) annotation (Line(points={{20,69},{20,52}}, color={0,0,127}));
  connect(PID.y, switch.u1) annotation (Line(points={{20,29},{20,8},{28,8}}, color={0,0,127}));
  connect(PID.u_m, T_solar_out) annotation (Line(points={{8,39.9},{-18,39.9},{-18,40},{-100,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller model to control the pump for a solar thermal collector by the temperature difference of inlet and outlet temperatures.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>A hysteresis with the temperature difference models real controller behavior. The onOffRelais avoids having too many switching events. The first order block smoothens the output.</p>
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
<p>Tested in TransiEnt.Producer.Heat.SolarThermal.Check.TestCollectorFluidCycle_constProp2.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Fenja Frerichs, Jul 2017</p>
<p>Model modified (first order added, moved PID controller, applied coding conventions) by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end ControllerPumpSolarCollectorDeltaT;
