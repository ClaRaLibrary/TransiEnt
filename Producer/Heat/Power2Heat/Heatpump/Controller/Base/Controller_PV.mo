within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base;
partial model Controller_PV



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






 // _____________________________________________
 //
 //          Imports and Class Hierarchy
 // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Boolean control_SoC=false "Choose controlled variable, 'true'=SoC, 'false'=Storage temperature" annotation (Dialog(group="Configuration"),choices(checkBox=true));
  parameter Boolean CalculatePHeater=false "If true, electrical heater power output is calculated for bivalent heat pump operation" annotation (Dialog(group="Configuration"),
                                                                                                                                                                        choices(checkBox=true));
  parameter Boolean Modulating=false "true: modulating heat pump operation, false: static operation with P_n" annotation(choices(checkBox=true), Dialog(group="Configuration"));
  parameter Boolean MinTimes=true "If true, minimum operation and shutoff times are considered" annotation (Dialog(group="Configuration"),choices(checkBox=true));

  parameter Modelica.Units.SI.Power Q_flow_n=5000 "Nominal heating power of Heatpump" annotation (Dialog(group="Heatpump"));
  parameter SI.TemperatureDifference Delta_T_db=2 "Deadband of hysteresis control" annotation (Dialog(group="Control parameters"));

  parameter SI.Time t_min_on=3600 "Minimum on time" annotation (Dialog(group="Control parameters"));
  parameter SI.Time t_min_off=600 "Minimum off time" annotation (Dialog(group="Control parameters"));
  parameter Basics.Types.OnOffRelaisStatus init_state=TransiEnt.Basics.Types.on_ready "State of relais at initialization" annotation (Dialog(group="Control parameters"));

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater" annotation (Dialog(group="Heatpump", enable=CalculatePHeater));

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T if control_SoC==false annotation (Placement(transformation(extent={{-116,6},{-88,34}}), iconTransformation(extent={{-114,20},{-74,60}})));

 Basics.Interfaces.Thermal.HeatFlowRateOut               Q_flow_set_HP annotation (Placement(transformation(extent={{96,-12},{120,12}}), iconTransformation(extent={{92,-14},{118,12}})));

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_set_electricHeater if CalculatePHeater annotation (Placement(transformation(extent={{96,-82},{122,-56}}), iconTransformation(extent={{92,-90},{118,-64}})));

 Modelica.Blocks.Interfaces.RealInput SoC if control_SoC annotation (Placement(transformation(extent={{-116,-34},{-88,-6}}), iconTransformation(extent={{-114,-88},{-74,-48}})));

  Basics.Interfaces.General.TemperatureIn T_set  annotation (Placement(transformation(extent={{-116,32},{-88,60}}), iconTransformation(extent={{-112,-34},{-72,6}})));

  Basics.Interfaces.Electrical.ElectricPowerIn PV_excess  annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-82,100}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-90,104})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=864000,
      Interval=1800,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model of controller for heat pumps that use excess PV power</p>
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
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), June 2018</p>
</html>"));
end Controller_PV;
