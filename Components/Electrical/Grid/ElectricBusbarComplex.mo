within TransiEnt.Components.Electrical.Grid;
model ElectricBusbarComplex "Bus model which makes the automatic creation of grids easier"


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

  //extends TransiEnt.Basics.Icons.Sensor;

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Integer port=2 "Number of Ports";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P(start=0) "Active Power";
  TransiEnt.Basics.Interfaces.Electrical.ReactivePowerOut Q(start=0) "Reactive Power";
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_[port] annotation (Placement(transformation(extent={{56,26},{76,46}}), iconTransformation(extent={{20,-10},{40,10}})));

  TransiEnt.Basics.Interfaces.Electrical.FrequencyOut F=epp_[1].f;
  TransiEnt.Basics.Interfaces.Electrical.VoltageOut V=epp_[1].v;

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  Modelica.Units.SI.Angle delta=epp_[1].delta;

  Real P_[port];
  Modelica.Units.SI.ReactivePower Q_[port];

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  for i in 1:port - 1 loop
    epp_[i].f = epp_[i + 1].f;
    epp_[i].v = epp_[i + 1].v;
    epp_[i].delta = epp_[i + 1].delta;
    Connections.branch(epp_[i].f, epp_[i + 1].f);
  end for;

  sum(epp_[1:port].P) = 0;
  sum(epp_[1:port].Q) = 0;

  for i in 1:port loop
    P_[i] = if epp_[i].P > 0 then epp_[i].P else 0;
    Q_[i] = if epp_[i].Q > 0 then epp_[i].Q else 0;
  end for;

  P = sum(P_[1:port]);
  Q = sum(Q_[1:port]);

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,20},{100,-20}},
          lineColor={0,134,134},
          textString="%name",
          origin={-30,1},
          rotation=90), Rectangle(
          extent={{-12,100},{12,-100}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for busbar in TransiEnt with ComplexPowerPort</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">It is possible to specify the number of ComplexPowerPorts</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">makes automatic grid construction easier</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Check Model TransiEnt.Components.Electrical.Grid.Check.CheckElectricBusbarComplex</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Markus Dressel (markus.dressel@tuhh.de) in March 2020</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model moved to TransiEnt Library by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2020</span></p>
</html>"));
end ElectricBusbarComplex;
