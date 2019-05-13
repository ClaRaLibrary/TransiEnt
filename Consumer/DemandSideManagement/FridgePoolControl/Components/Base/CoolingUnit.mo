within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base;
model CoolingUnit "Simple cooling unit model"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Power P_el_n = 80 "Nominal electric power";
  parameter Real COP = 2 "Expected value of coefficient of performance";

  SI.Power P(start=P_el_n);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
  Modelica.Blocks.Interfaces.BooleanInput q annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,102})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{88,-13},{110,10}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
   if q then
    COP*P_el_n=port_a.Q_flow;
    P=P_el_n;
   else
    port_a.Q_flow=0;
    P=0;
   end if;

   epp.P=P;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-42,40},{38,-48}},
          lineColor={0,0,0}),
        Polygon(
          points={{-52,8},{-48,8},{-34,8},{-42,-4},{-34,-14},{-52,-14},{-42,-4},{-52,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,48},{16,32}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-40},{18,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,10},{52,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,-10},{38,10},{48,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,22},{-24,-24},{24,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-22},{-20,-14},{-8,4},{-6,6},{2,12},{12,16},{20,16}},
          color={0,0,255},
          smooth=Smooth.None)}),    Diagram(graphics,
                                            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a simple cooling unit with a single heat port (e.g. fridge). Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">port_a - Heat Port</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">q - turn on/off signal</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp - Electric Power Port</span></p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end CoolingUnit;
