within TransiEnt.Consumer.Electrical;
model DynamicExponentialElectricConsumerComplex "Electric consumer with dynamic (differential equation) behavior"


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

 extends TransiEnt.Basics.Icons.ElectricalConsumer;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real Tp=60 "recovery time constant for active power";
  parameter Real Tq=30 "recovery time constant for reactive power";
  parameter Real alpha_s=0.38 "steady state load exponent_active power";
  parameter Real alpha_t=2.26 "transient load exponent_active power";
  parameter Real beta_s=2 "steady state load exponent_reactive power";
  parameter Real beta_t=2.5 "transient load exponent_reactive power";
  parameter Real kpf=0 "frequency dependency of active power";
  parameter Real kqf=0 "frequency dependency of reactive power";
  //take kpf and kqf out of TransiEnt.Consumer.Electrical.Characteristics
  parameter Modelica.Units.SI.Voltage v_n=simCenter.v_n "nominal voltage";
  parameter Modelica.Units.SI.Frequency f_n=simCenter.f_n "nominal frequency";
  parameter Modelica.Units.SI.ReactivePower Q_n=50e6 "initial reactive power which is nominal reactive power";
  parameter Modelica.Units.SI.ActivePower P_n=100e6 "initial active power which is nominal active power";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp "connect this epp with secondary" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 Real Z_p( start= 1);
 Real Z_q( start=1);
 SI.Voltage v_cp(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Angle delta_cp(start=-0.08726646259971647) annotation (Dialog(group="Initialization", showStartAttribute=true));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  der(Z_p) = 0;
  der(Z_q) = 0;

equation

  delta_cp=epp.delta;
  v_cp = epp.v;
  epp.P =P_n * Z_p *((v_cp/v_n)^alpha_t)* (1 + kpf*( epp.f -f_n)/f_n);
  epp.Q = Q_n * Z_q* ((v_cp/v_n)^beta_t)* (1 + kqf*( epp.f -f_n)/f_n);
  Tp*(der(Z_p))= ((v_cp/v_n)^alpha_s) - Z_p*( (v_cp/v_n)^alpha_t); //dynamic load model
  Tq*(der(Z_q))= ((v_cp/v_n)^beta_s) - Z_q*( (v_cp/v_n)^beta_t);

  annotation (defaultComponentName="load", Diagram(graphics,
                                                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                       graphics={
        Line(points={{-34,14},{-14,14},{-14,-14},{-8,-12},{-2,-10},{4,-8},{14,-4},{24,-2},{38,0},{50,0}}, color={28,108,200}),
    Polygon(
      points={{60,-30},{38,-38},{38,-22},{60,-30}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-44,-30},{38,-30}},
                                  color={192,192,192}),
    Line(points={{-34,-42},{-34,34}},
                                  color={192,192,192}),
    Polygon(
      points={{-34,56},{-42,34},{-26,34},{-34,56}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Dynamic Load model for voltage stability analysis</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">simple exponential model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L2E - Models are based on (dynamic) transfer functions or differential equations. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Complex power port epp</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">by default, no frequency dependency</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Thierry Van Cutsem, Costas Vournas: Voltage Stability of Electric Power Systems, Springer, 2008 </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Zahra Nadia Faili (zahra.faili@nithh.de) in July 2019</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Jan-Peter Heckel (jan.heckel@tuhh.de) and added to TransiEnt Library in December 2019</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Frequency dependency added in March 2021</span></p>
</html>"));
end DynamicExponentialElectricConsumerComplex;
