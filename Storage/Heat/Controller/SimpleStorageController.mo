within TransiEnt.Storage.Heat.Controller;
model SimpleStorageController

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



  extends TransiEnt.Basics.Icons.Controller;

  parameter Real T_set=95;

  Modelica.Blocks.Math.Gain gain(k=k)
                                 annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-39,0})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-80,0})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput u1 annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-80,100})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-80,-100})));
  parameter Real k=100 "Proportional controller gain";
  Modelica.Blocks.Sources.Constant const(k=T_set)
                                              annotation (Placement(transformation(extent={{28,-36},{8,-16}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-6,0})));
equation
  connect(gain.y, feedback.u2) annotation (Line(
      points={{-46.7,1.77636e-015},{-53.35,1.77636e-015},{-53.35,-1.55431e-015},{-72,-1.55431e-015}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u1, feedback.u1) annotation (Line(points={{-80,100},{-80,8}},
                     color={0,0,127}));
  connect(y, feedback.y) annotation (Line(points={{-80,-100},{-80,-9}},
                    color={0,0,127}));
  connect(const.y, feedback1.u2) annotation (Line(points={{7,-26},{-6,-26},{-6,-8}}, color={0,0,127}));
  connect(feedback1.u1, u) annotation (Line(points={{2,0},{52,0},{52,0},{100,0}}, color={0,0,127}));
  connect(feedback1.y, gain.u) annotation (Line(points={{-15,0},{-30.6,0},{-30.6,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SimpleStorageController;
