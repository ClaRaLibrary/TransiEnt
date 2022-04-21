within TransiEnt.Consumer.Heat;
model DomesticHotWater "Modell to pass a domestic hot water heat demand profile and convert it to a electrical demand if NightStorageHeating is used. Mostly used in Systems of GridConstrucor"


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
  extends Basics.Icons.Model;
  import Modelica.Units.SI;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer NSH=0 "1- if NightStorageHeating is used.";
  parameter Real cosphi_boundary=1;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput demand annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));

  Modelica.Blocks.Interfaces.RealOutput electrical_dhw_demand annotation (Placement(transformation(
        extent={{-21,-21},{21,21}},
        rotation=270,
        origin={1,-111})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Electric_Consumer_dhw(useInputConnectorQ=false, cosphi_boundary=cosphi_boundary) if  NSH==1 annotation (Placement(transformation(extent={{-8,-8},{8,8}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if  NSH==1 annotation (Placement(transformation(extent={{-44,-106},{-24,-86}}), iconTransformation(extent={{-118,-16},{-84,14}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  if NSH == 1 then
    electrical_dhw_demand = demand;
  else
    electrical_dhw_demand = 0;
  end if;

  connect(Electric_Consumer_dhw.P_el_set, demand) annotation (Line(points={{-4.8,9.6},{-4.8,76},{0,76},{0,108}}, color={0,0,127}));
  connect(Electric_Consumer_dhw.epp, epp) annotation (Line(
      points={{-8,0},{-34,0},{-34,-96}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-44,-78},{-34,56}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,50},{34,42}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,44},{32,36}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,32},{32,-12}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-16},{32,-30}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-34},{32,-44}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-48},{32,-58}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Represents a model to convert a domestic hot water demand to electrical demand if a night storage heating device is present. Only used in Systems of GridConstructors.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de), 2020</span></p>
</html>"));
end DomesticHotWater;
