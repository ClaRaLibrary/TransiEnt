within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
partial model PartialActivationType "Partial Model for different types of Secondary Control Activation"


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

  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //             Outer Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout=simCenter.generationPark.nDispPlants "Number of plants";
  parameter Modelica.Units.SI.Power P_max[nout]=simCenter.generationPark.P_max;
  parameter Real P_grad_max_star[nout]=simCenter.generationPark.P_grad_max_star "Specific Power gradient in 1/s";
  parameter Modelica.Units.SI.Power P_respond=simCenter.P_el_small "Minimum absolute set value for response of one power plant (Ansprechempfindlichkeit)";
  parameter Modelica.Units.SI.Time Td(min=Modelica.Constants.small) = 1 "Derivative time constant of slew rate limiter";
  parameter Modelica.Units.SI.Power P_SB_max=57e6 "Maximum power reserve";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_pos[nout] "Reserved positive control power (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_neg[nout] "Reserved negative control power (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nout] annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput c[nout] "participation factors" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
        Text(
          extent={{48,154},{106,94}},
          lineColor={0,0,127},
          textString="-"),
        Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial Model/BaseClass for different types of Secondary Control Activation without technical or physical insight. Only input and outputs are defined.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_R_pos[nout]: Inputs for reserved positive control power (values are supposed to be positive)</p>
<p>P_R_neg[nout]: Inputs for reserved negative control power (values are supposed to be positive)</p>
<p>u: Control input from controller</p>
<p>y[nout]: Outputs for power plant models</p>
<p>c[nout]: Outputs for participation factors</p>
<p>nout: Number of considered power plants</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in 10/2014</span></p>
</html>"));
end PartialActivationType;
