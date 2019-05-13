within TransiEnt.Producer.Combined.SmallScaleCHP.Controller;
model ControllerElectricityLed

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Controller;

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartialCHPController;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real k=1;
  parameter Integer nDevices = 1 "Number of CHP Units";
  parameter Modelica.SIunits.Power P_start(
    min=Specification.P_el_min,
    max=nDevices*Specification.P_el_max)=Specification.P_el_max "Initial total output power";
    parameter Real SOC_ShutdownThreshold=0.8 "SOC at which charge power correction is turned off";
  parameter Real SOC_TurnOnThreshold=0.1 "SOC at which charge power correction is turned on";
  parameter Real SOC_Target=0.7 "SOC to reach and hold if possible";
  parameter Real SOC_Priority=0.3 "Ratio of P_max used to reach target";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
 Boolean offCondition;
 Boolean onCondition;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealInput SOC_In "Reads the SOC of storages" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-26,100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Modelica.Blocks.Continuous.LimPID PID(
    yMax=nDevices*Specification.P_el_max,
    k=k,
    y_start=P_start,
    yMin=Specification.P_el_min,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Td(displayUnit="s") = 0.1,
    wd=1,
    Ti(displayUnit="s") = 1) annotation (Placement(transformation(extent={{-10,0},
            {10,20}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // assert((time-stopTime)<t_OnOff,"Your CHP is switching too frequently. If you want to suppress this message, change controller t_OnOff to zero or better change your settings.");
  onCondition=SOC_In<SOC_TurnOnThreshold and (time-stopTime)>t_OnOff;
  offCondition=(P_el_set<Specification.P_el_min+1) and
  SOC_In>SOC_ShutdownThreshold or
  T_return>T_return_max;
  if (pre(switch)==false and pre(onCondition)) then
      switch=true;
  elseif pre(switch)==true and pre(offCondition) then  // or T_return>T_turnOff) then
    switch=false;
  else
    switch=pre(switch);
  end if;
    //P_el_set = max(Specification.P_el_min,Specification.P_el_max*(simCenter.f_n-controlBus.f_grid)*k);
    PID.u_m=controlBus.f_grid;//*SOC_In/SOC_Target;
    PID.u_s=simCenter.f_n;
    P_el_set=max(Specification.P_el_min,PID.y+(1-SOC_In/SOC_Target)*SOC_Priority*Specification.P_el_max*nDevices);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for electricity-led control of CHP.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">SOC_In -&nbsp;Reads&nbsp;the&nbsp;SOC&nbsp;of&nbsp;electric storages</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">switch</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set - Electric Power setpoint</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_return - Heating Water Return Temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_supply - Heating Water Supply Temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_meas - Measured Electric Power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_meas - Measured Heat Flow</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_pump_set - Electric Pump Power setpoint</span></p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end ControllerElectricityLed;
