within TransiEnt.Components.Electrical.Grid;
model SeparableLine "Transmission line with constant loss of active power from connection epp_1 to epp_2 and option to separate two grids"



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

  extends Base.PartialLine;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Real loss_in_percent=0;

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________
  SI.ActivePower P_abs_loss = epp_1.P + epp_2.P;
  SI.Frequency f_grid(stateSelect=StateSelect.default) = epp_1.f;
  SI.Frequency delta_f_grid(displayUnit="mHz") = (f_grid - simCenter.f_n);
   outer TransiEnt.SimCenter simCenter;
  Modelica.Blocks.Interfaces.BooleanInput isConnected annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

 if isConnected then
 epp_1.f = epp_2.f;
 epp_1.P + epp_2.P * (1+loss_in_percent/100) = 0;     // loss is always from generation side to consumer side:
 else
 epp_1.f = simCenter.f_n;
 epp_2.P = 0;     // loss is always from generation side to consumer side:
 end if;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(
          extent={{-66,90},{22,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,134,134},
          textString="%eta %%"),
        Polygon(
          points={{0,-38},{10,-38},{10,88},{24,88},{-2,114},{-28,88},{-16,88},{-16,-38},{0,-38}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-24,42},
          rotation=-90,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-62,32},{-10,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,20},{26,32}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,14},{14,-14}},
          lineColor={255,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=90,
          origin={26,18},
          rotation=90,
          pattern=LinePattern.None),
        Polygon(
          points={{-12,-24},{-6,-22},{-6,6},{4,6},{-12,22},{-28,6},{-18,6},{-18,-22},{-12,-24}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={22,-4},
          rotation=180,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-2,2},{2,-2}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          origin={26,18},
          rotation=90,
          pattern=LinePattern.None)}),
                                Diagram(graphics,
                                        coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple line model using Transient electrical interfaces with constant power loss specified in percent.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1 (defined in the CodingConventions) - only active power and frequency.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp_1: electric power port</p>
<p>epp_2: electric power port</p>
<p>isConnected: BooleanInput</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Components.Electrical.Grid.Check.TestSeparableLine&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SeparableLine;
