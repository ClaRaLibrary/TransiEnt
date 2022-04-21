within TransiEnt.Consumer.Electrical.Base;
model LinearStatic



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





  import TransiEnt;
  extends TransiEnt.Basics.Icons.LinearBlock;

  replaceable parameter TransiEnt.Consumer.Electrical.Characteristics.Constant data constrainedby TransiEnt.Consumer.Electrical.Characteristics.PartialConsumerData annotation (choicesAllMatching=true);
  outer TransiEnt.SimCenter simCenter;

  TransiEnt.Basics.Interfaces.General.FrequencyIn f "Input for frequency" annotation (Placement(transformation(
          extent={{-120,30},{-80,70}}), iconTransformation(extent={{-100,44},{-68,
            76}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut deltaPstar "Output for electric power difference" annotation (Placement(
        transformation(extent={{66,24},{114,72}}),  iconTransformation(extent={{94,52},
            {114,72}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut deltaQstar "Output for heat flow rate difference" annotation (Placement(
        transformation(extent={{100,-70},{142,-28}}), iconTransformation(extent={{92,-60},
            {112,-40}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-108,-74},{-68,-34}}), iconTransformation(extent={{-100,-66},
            {-68,-34}})));
  Modelica.Blocks.Sources.Constant f_n(k=simCenter.f_n) annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-69,34})));
  Modelica.Blocks.Math.Feedback multiProduct1 annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-56,50})));
  Modelica.Blocks.Math.Gain dedim_f(k=1/simCenter.f_n) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-38,50})));
  Modelica.Blocks.Math.Gain kpf(k=data.kpf/100)
                                            annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={4,50})));
  Modelica.Blocks.Math.MultiSum ActiveSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={74,50})));
  Modelica.Blocks.Math.Gain kqf(k=data.kqf/100)
                                            annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={6,24})));
  Modelica.Blocks.Math.MultiSum ActiveSum1(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={82,-48})));
  Modelica.Blocks.Sources.Constant v_n(k=simCenter.v_n) annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-71,-66})));
  Modelica.Blocks.Math.Feedback multiProduct3 annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-58,-50})));
  Modelica.Blocks.Math.Gain dedim_v(k=1/simCenter.v_n) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-40,-50})));
  Modelica.Blocks.Math.Gain kpu(k=data.kpu/100)
                                            annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={2,-50})));
  Modelica.Blocks.Math.Gain kqu(k=data.kqu/100)
                                            annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={4,-76})));
equation
  connect(f, multiProduct1.u1) annotation (Line(
      points={{-100,50},{-60.8,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(f_n.y, multiProduct1.u2) annotation (Line(
      points={{-63.5,34},{-56,34},{-56,45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dedim_f.u, multiProduct1.y) annotation (Line(
      points={{-45.2,50},{-50.6,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kpf.u, dedim_f.y) annotation (Line(
      points={{-3.2,50},{-31.4,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ActiveSum.y, deltaPstar) annotation (Line(
      points={{81.02,50},{102,50},{102,48},{90,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kpf.y, ActiveSum.u[1]) annotation (Line(
      points={{10.6,50},{40,50},{40,52.1},{68,52.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kqf.u, dedim_f.y) annotation (Line(
      points={{-1.2,24},{-8,24},{-8,50},{-31.4,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ActiveSum1.y, deltaQstar) annotation (Line(
      points={{89.02,-48},{106,-48},{106,-49},{121,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kqf.y, ActiveSum1.u[1]) annotation (Line(
      points={{12.6,24},{28,24},{28,-45.9},{76,-45.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiProduct3.u1, u) annotation (Line(
      points={{-62.8,-50},{-76,-50},{-76,-54},{-88,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiProduct3.u2, v_n.y) annotation (Line(
      points={{-58,-54.8},{-64,-54.8},{-64,-66},{-65.5,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiProduct3.y, dedim_v.u) annotation (Line(
      points={{-52.6,-50},{-47.2,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dedim_v.y, kpu.u) annotation (Line(
      points={{-33.4,-50},{-5.2,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kqu.u, dedim_v.y) annotation (Line(
      points={{-3.2,-76},{-18,-76},{-18,-50},{-33.4,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kpu.y, ActiveSum.u[2]) annotation (Line(
      points={{8.6,-50},{38,-50},{38,47.9},{68,47.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kqu.y, ActiveSum1.u[2]) annotation (Line(
      points={{10.6,-76},{44,-76},{44,-50.1},{76,-50.1}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-26,58},{-10,52}},
          lineColor={0,0,255},
          textString="delta f *")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Linear static model to calculate delta_P_star and Delta_Q_star.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f: input for frequency in [Hz]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">deltaPstar: output for electric power difference in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">deltaQstar: output for heat flow rate difference in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">u: RealInput</span></p>
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
end LinearStatic;
