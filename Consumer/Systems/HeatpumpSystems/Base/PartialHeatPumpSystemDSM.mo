within TransiEnt.Consumer.Systems.HeatpumpSystems.Base;
partial model PartialHeatPumpSystemDSM "Partial model of a controlled heat pump"


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
  //                 Outer Models
  // _____________________________________________

extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Base.PartialHeatPumpSystemModel(
                                                                                  redeclare HeatPumpSystemPropertiesMatrix params(A=A));

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real[params.nPar] A "Input matrix with Heat Pump Properties";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    Modelica.Blocks.Interfaces.BooleanInput isLoadShedding annotation (Placement(transformation(extent={{-112,-10},{-94,8}})));
  annotation (defaultComponentName="HeatPumpSystem", Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),  Polygon(
          origin={24,14},
          lineColor={78,138,73},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}}),
        Text(
          extent={{-150,-103},{150,-143}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-40,44},{40,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-50,12},{-46,12},{-32,12},{-40,0},{-32,-10},{-50,-10},{-40,0},{-50,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,52},{18,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-36},{20,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,14},{54,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-6},{40,14},{50,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,26},{-22,-20},{26,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-18},{-18,-10},{-6,8},{-4,10},{4,16},{14,20},{22,20}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of a controlled heat pump model useable for large pool simulations in demand side management scenarios.</span></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">isLoadShedding - boolean signal</span></p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) 2014</p>
</html>"));
end PartialHeatPumpSystemDSM;
