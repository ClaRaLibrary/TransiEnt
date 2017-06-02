within TransiEnt.Storage.Electrical.Base;
model Battery "Typical characteristic of battery storage"

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

  extends GenericElectricStorage(storageModel(
      eta_unload(y=1/batterySystemEfficiency.eta),
      loadingEfficiency(y=batterySystemEfficiency.eta),
      P_max_load(y=batteryPowerLimit.P_max_load_star*storageModel.params.P_max_load),
      P_max_unload_neg(y=-batteryPowerLimit.P_max_unload_star*storageModel.params.P_max_unload)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  BatterySystemEfficiency batterySystemEfficiency(
    P_el_n=StorageModelParams.P_max_unload,
    eta_max=1,
    eta_min=0.4) annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));
  BatteryPowerLimit batteryPowerLimit annotation (Placement(transformation(extent={{-36,72},{-16,92}})));
  Modelica.Blocks.Sources.RealExpression SOC(y=storageModel.SOC) annotation (Placement(transformation(extent={{-68,72},{-44,92}})));

  // _____________________________________________
  //
  //                 Equations
  // _____________________________________________
equation
  connect(batterySystemEfficiency.P_is, P_set) annotation (Line(points={{-40,-22},{-62,-22},{-62,36},{-104,36}}, color={0,0,127}));
  connect(SOC.y, batteryPowerLimit.SOC) annotation (Line(points={{-42.8,82},{-36.4,82}}, color={0,0,127}));
  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-72,16},{56,-54}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,-54},{56,16},{68,32},{68,-40},{56,-54}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={177,177,177},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,16},{56,30},{68,46},{68,32},{56,16}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={57,57,57},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,16},{56,30}},
          lineColor={95,95,95},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-72,30},{-40,46},{68,46},{56,30},{-72,30}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,36},{32,42},{46,42},{36,36},{20,36}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,143,7},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,36},{-34,42},{-20,42},{-30,36},{-46,36}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,143,7},
          fillPattern=FillPattern.Solid)}), Diagram(graphics={
        Line(
          points={{-16,-22},{-12,-22},{-4,-22},{-4,-4},{-24,-4},{-24,2}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash),
        Line(
          points={{-20,22},{8,22},{8,0},{-6,0},{-26,0},{-26,-4}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash,
          origin={10,64},
          rotation=360),
        Line(
          points={{-20,22},{4,22},{4,10},{-4,10},{-32,10},{-32,6}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash,
          origin={10,56},
          rotation=360)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Typical&nbsp;characteristic&nbsp;of&nbsp;battery&nbsp;storage.</p>
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
end Battery;
