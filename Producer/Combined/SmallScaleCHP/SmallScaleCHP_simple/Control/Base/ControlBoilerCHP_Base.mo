within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.Base;
partial model ControlBoilerCHP_Base


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

  extends TransiEnt.Basics.Icons.Controller;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Boolean control_SoC=true "Choose controlled variable, 'true'=SoC, 'false'=Storage temperature" annotation (Dialog(group="Controller parameters"),
                                                                                                                                                choices(choice=true "SoC as controlled variable", choice=false "Storage temperature as controlled variable"));

  parameter Real Q_n_CHP=4000 "Nominal heat output of the CHP" annotation (Dialog(group="Nominal values"));
  parameter Real Q_n_Boiler=6000 "Nominal heat output of boiler" annotation (Dialog(group="Nominal values"));

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T if control_SoC==false annotation (Placement(transformation(extent={{-116,6},{-88,34}}), iconTransformation(extent={{-118,-20},{-78,20}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_CHP annotation (Placement(transformation(extent={{96,36},{120,60}}), iconTransformation(extent={{92,-14},{118,12}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_boiler annotation (Placement(transformation(extent={{96,-64},{122,-38}}), iconTransformation(extent={{92,-90},{118,-64}})));

  Modelica.Blocks.Interfaces.RealInput SoC if control_SoC annotation (Placement(transformation(extent={{-116,-34},{-88,-6}}), iconTransformation(extent={{-118,-20},{-78,20}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=864000,
      Interval=1800,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller base model for the operation of a CHP unit and a boiler.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput SoC</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_CHP</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_boiler</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Yousef Omran, Fraunhofer UMSICHT, 2017</p>
<p>Model revised by Anne Hagemeier, Fraunhofer UMSICHT, 2018</p>
<p>Modified by Emil Dierkes, Fraunhofer UMSICHT, 2021 (changed CHP signal from boolean output to HeatFlowRateOut)</p>
</html>"));
end ControlBoilerCHP_Base;
