within TransiEnt.Consumer.Electrical.Base;
block ExponentialStatic

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

  import Modelica.Fluid.Utilities.regPow;
  extends TransiEnt.Basics.Icons.ExponentialBlock;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real f_n=simCenter.f_n "Nominal frequency";
  parameter Real v_n=simCenter.v_n "Nominal voltage";
  replaceable parameter TransiEnt.Consumer.Electrical.Characteristics.Constant data constrainedby TransiEnt.Consumer.Electrical.Characteristics.PartialConsumerData "Load characteristic" annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput f annotation (Placement(transformation(
          extent={{-122,30},{-82,70}}), iconTransformation(extent={{-100,44},{-68,
            76}})));
  Modelica.Blocks.Interfaces.RealOutput Delta_P_star annotation (Placement(
        transformation(extent={{96,32},{124,60}}),  iconTransformation(extent={{92,-62},{112,-42}})));
  Modelica.Blocks.Interfaces.RealOutput Delta_Q_star annotation (Placement(
        transformation(extent={{96,-68},{120,-44}}),  iconTransformation(extent={{92,50},{112,70}})));
  Modelica.Blocks.Interfaces.RealInput v annotation (Placement(transformation(
          extent={{-108,-72},{-68,-32}}), iconTransformation(extent={{-100,-64},{-68,-32}})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Delta_P_star = regPow(v/v_n,data.kpu) * (1 + data.kpf*( f -f_n)/f_n) - 1;
  Delta_Q_star = regPow(v/v_n,data.kqu) * (1 + data.kqf*( f -f_n)/f_n) - 1;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Exponential static model to calculate the frequency and voltage dependency of consumer electric load based on reference [1].</p>
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
<p>[1] IEEE Task Force on Load Representation for Dynamic Performance: Load representation for dynamic performance analysis (of power systems). In: <i>IEEE Transactions on Power Systems</i> Bd. 8 (1993), Nr.&nbsp;2, S.&nbsp;472&ndash;482</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end ExponentialStatic;
