within TransiEnt.Producer.Combined.SmallScaleCHP.Base;
partial model PartialCHPController "Partial CHP controller model"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Controller;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //         Constants and Parameters
  // _____________________________________________
  parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification Specification annotation (choicesAllMatching);
  parameter SI.Time t_OnOff=1800 "Minimum time between switching";
  parameter Boolean useGridTemperatures = false "Whether or not to use target grid temperatures";
  parameter SI.Temperature T_supply_const=363.15 "Target temperature of CHP" annotation (Dialog(enable=not useGridTemperatures));
  parameter SI.Temperature T_return_max=Specification.T_return_max "Maximum allowed return temperature";

  // _____________________________________________
  //
  //               Variables
  // _____________________________________________
  Real sigma "Heat fraction";
  SI.Time runningTime(start=0) "Total time running";
  SI.Time startTime(start=0) "Time since last start";
  SI.Time stopTime(start=-2*t_OnOff) "Time since last stop" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Integer startCounter(start=0) "Counter to start on/off cycles";
  SI.TemperatureDifference dT "Target temperature difference";
  SI.Pressure dp "Measured pressure difference in CHP";
  SI.Temp_C T_supply_target "Target supply temperature";
  Real runningtime = if switch then 1 else 0;

  // _____________________________________________
  //
  //          Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Combined.SmallScaleCHP.Base.ControlBus controlBus(Specification=Specification) annotation (Placement(transformation(extent={{90,30},{110,50}})));

protected
  Modelica.Blocks.Interfaces.BooleanInput switch(start=false) annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set(start=(Specification.P_el_max + Specification.P_el_min)/2) "Electric power input set value" annotation (Placement(transformation(extent={{70,0},{90,20}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_return "Return temperature output" annotation (Placement(transformation(extent={{90,40},{70,60}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_supply "Supply temperature output" annotation (Placement(transformation(extent={{90,20},{70,40}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_meas  annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_meas annotation (Placement(transformation(extent={{90,-70},{70,-50}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_pump_set(start=0.01*Specification.P_el_min) annotation (Placement(transformation(extent={{70,75},{90,95}})));
public
  Modelica.Blocks.Logical.Timer timer annotation (Placement(transformation(extent={{54,-20},{34,0}})));

initial algorithm
  // _____________________________________________
  //
  //          Equations
  // _____________________________________________
  stopTime:=-2*t_OnOff;

equation
  controlBus.P_el_set = P_el_set;
  controlBus.T_return = T_return;
  controlBus.T_supply = T_supply;
  controlBus.switch = switch;
  controlBus.P_el_meas = P_el_meas;
  controlBus.Q_flow_meas = Q_flow_meas;
  controlBus.P_el_pump_set = P_el_pump_set;
  controlBus.dp = dp;

//Use self defined supply temperatures or take them from heating curve
  if (useGridTemperatures) then
    T_supply_target = simCenter.heatingCurve.T_supply;
  else
    T_supply_target = T_supply_const;
  end if;
   dT=T_supply_target-T_return;
   //dT=(T_supply_target+273.15)-simCenter.heatingCurve.T_return;

//Set pump power such that the supply temperature conforms with T_supply_target
//Reasonable low power as minimum. About 1% of nominal value.
  P_el_pump_set=max(min(0.1*Specification.P_el_min,dp*(Q_flow_meas)/(1000*4200*max(dT,1))),0.0001*Specification.P_el_min); //
//PID_Pump.u_s=T_supply_target;

    //\dot{Q}=\dot{m}*c_p*\Delta T
    //\dot{m}=P_{Pump}*\rho/\Delta p

//   der(E_el) = P_el_meas;
//   der(Q) = Q_flow_meas;

  //avoid division by zero
  sigma = noEvent(if P_el_meas>0 then Q_flow_meas/P_el_meas else 0);

algorithm
  //Count starts
  when (edge(switch)) then
    startCounter := startCounter + 1;
    startTime := time;
  end when;
  //Record every time the CHP turns off
  when (change(switch)) and pre(switch)==true then
    stopTime := time;
  end when;
  //Gives a statistic of the CHP overall running time
   when (change(switch)) then
     runningTime := runningTime + (time - startTime);
   end when;

equation
  connect(timer.u, switch) annotation (Line(
      points={{56,-10},{80,-10}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a partial model for a CHP Controller. It can be used for any CHP model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">switch</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set - Electric Power setpoint</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_return - Heating Water Return Temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_supply - Heating Water Supply Temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_meas - Measured Electric Power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_meas - Measured Heat Flow</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_pump_set - Electric Pump Power setpoint</span></p>
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
<p>Model created by Max Mustermann (mustermann@mustermail.de), Apr 2014</p>
</html>"));
end PartialCHPController;
