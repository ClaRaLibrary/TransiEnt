within TransiEnt.Producer.Electrical.Photovoltaics.Base;
block MPPEfficiencyModel "This efficiency model is taken from [4] Beyer, H.G., Heilscher, G., Bofinger, S. (2004): A robust model for the MPP performance 
      of different types of PV-modules applied for the performance check of grid connected 
      systems. In: Proc. Eurosun 2004, Freiburg "

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Blocks.Interfaces.MISO(nin=2);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Real a1=0.01;
  parameter Real a2=-2e-5;
  parameter Real a3=0.02;
  parameter Real alpha=0.45;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  Real G = max(Modelica.Constants.eps, u[1]);
  Real T = u[2];
  // _____________________________________________
  //
  //                    Equations
  // _____________________________________________

algorithm
  y:=(a1+a2*G+a3*log(G))*(1+alpha*(T-25));
annotation (
Icon(coordinateSystem(
    preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={
    Text(
      extent={{-152,24},{138,-16}},
      lineColor={0,0,0},
        textString="eta= f(G,T)")}), Diagram(coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Efficiency model based on MPP performance.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>This&nbsp;efficiency&nbsp;model&nbsp;is&nbsp;taken&nbsp;from&nbsp;[4]&nbsp;Beyer,&nbsp;H.G.,&nbsp;Heilscher,&nbsp;G.,&nbsp;Bofinger,&nbsp;S.&nbsp;(2004):&nbsp;A&nbsp;robust&nbsp;model&nbsp;for&nbsp;the&nbsp;MPP&nbsp;performance&nbsp;of&nbsp;different&nbsp;types&nbsp;of&nbsp;PV-modules&nbsp;applied&nbsp;for&nbsp;the&nbsp;performance&nbsp;check&nbsp;of&nbsp;grid&nbsp;connected&nbsp;systems.&nbsp;In:&nbsp;Proc.&nbsp;Eurosun&nbsp;2004,&nbsp;Freiburg</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end MPPEfficiencyModel;
