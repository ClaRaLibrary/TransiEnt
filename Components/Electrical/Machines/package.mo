within TransiEnt.Components.Electrical;
package Machines "Eletric Machines (asynchronous and synchronous generators and motors)"


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




                  extends TransiEnt.Basics.Icons.Package;
























annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
        Polygon(
          origin={14.835,58},
          fillPattern=FillPattern.Solid,
          points={{-70,-90},{-60,-90},{-26.835,-66},{9.165,-66},{35.165,-90},{
              49.165,-90},{49.165,-100},{-70,-100},{-70,-90}}),
        Rectangle(
          origin={113,26},
          fillColor={128,128,128},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-68,-36},{-51,36}}),
        Rectangle(
          origin={-4.0825,26},
          fillColor={0,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-50.0825,-36},{50.0825,36}},
          lineColor={0,0,0}),
        Rectangle(
          origin={-134.165,26},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{60,-10},{80,10}})}),Documentation(info="<html>

<p> This documnentation wants to give a short overview which machine model can be used for different applications. </p>
<p> When using the ActivePowerPort, the synchron generator is represented by the ActicePowerGenerator. For special applicants where net and rotation frequencies are decoupled, use the VariableSpeedActivePowerGenerator.  </p>
<p> When using the ApparentPowerPort, Use the LinearSynchronousMachine. </p>
<p> The ComplexPowerPort is the most advanced power port in the TransiEnt Library. Firstly, with this power port it is necessary to have exactly one reference. This is done by the slack versions (IsSlack=true) of the machines. </p>
<p> The LinearSynchronous is the simplest model. It only models frequency andactive power dynamics. The voltage is fixed. Reactive power can be distributed freeely. </p>
<p> The models SynchronousMachineComplex and TwoAxisSynchronousMachineComplex machine are stationary model which should only be used for small disturbances. The SynchronousMachineComplex can only describe cylindrical rotor machines. </p>
<p> These and the following models need a voltage controller which generates the exciation voltage as input. </p>
<p> The transient and subtransient versions of the machines are the most advanced models for dynamic simulations. The considered time domains are given in the model documentations of the models. </p>
<p> The Models for the ComplexPowerPort can operate with more than one rotation frequency for considering angle stability and power oscilations</p>
<p> Please set the voltage angle reference to the polar wheel voltage of the slack generator (simCenter.use_reference_polar_wheel=true) when using more than one frequency. By Default the voltage at the slack genertor's ports is the voltage angle reference. </p>
<p> Motor models should be used as motors in general, although they allow mechanical power in both directions. </p>
<p> Short description by Jan-Peter Heckel (jan.heckel@tuhh.de), Apr 2018</p>
<p> Description competet in Nov 2018</p>
</html>"));
end Machines;
