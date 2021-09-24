within TransiEnt.Components.Electrical.Grid;
model IdealPhaseShifter


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Model;
  outer SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________
  parameter Boolean active = simCenter.idealSuperstructLocalGrid "if activated infinite reactive power can be provide to keep voltage on given value";
  parameter Modelica.Units.SI.Voltage v_n=simCenter.v_n "" annotation (Dialog(enable=active));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

equation

  epp.P = 0;

  if active then
    epp.v = v_n;
  else
    epp.Q = 0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-43,-48},{43,48}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=150,
          closure=EllipseClosure.None,
          origin={-61,-20},
          rotation=360),
        Ellipse(
          extent={{-43,-48},{43,48}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=150,
          closure=EllipseClosure.None,
          origin={13,28},
          rotation=180),
        Ellipse(
          extent={{-43,-48},{43,48}},
          lineColor={255,0,0},
          startAngle=30,
          endAngle=150,
          closure=EllipseClosure.None,
          origin={-23,-20},
          rotation=360),
        Ellipse(
          extent={{-43,-48},{43,48}},
          lineColor={255,0,0},
          startAngle=30,
          endAngle=150,
          closure=EllipseClosure.None,
          origin={51,28},
          rotation=180),
        Line(
          points={{-22,8},{6,8}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled})}),
                                Diagram(coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1E- model can be assumed as simple boundary</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
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
<p>Model created by Robert Flesch (flesch@xrg-simulation.de), Feb 2021</p>
</html>"));
end IdealPhaseShifter;
