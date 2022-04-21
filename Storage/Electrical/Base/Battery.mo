within TransiEnt.Storage.Electrical.Base;
model Battery "Typical characteristic of battery storage"



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

  extends GenericElectricStorage(storageModel(
      eta_unload(y=1/(eta_unload)),
      loadingEfficiency(y=eta_load),
      P_max_load(y=batteryPowerLimit.P_max_load_star*storageModel.params.P_max_load),
      P_max_unload_neg(y=-batteryPowerLimit.P_max_unload_star*storageModel.params.P_max_unload)));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  BatterySystemEfficiency batterySystemEfficiency(
    P_el_n=StorageModelParams.P_max_unload,
    eta_max=1,
    eta_min=0.4,
    a=StorageModelParams.a,
    b=StorageModelParams.b,
    c=StorageModelParams.c,
    d=StorageModelParams.d)
                 annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));
  BatteryPowerLimit batteryPowerLimit(P_max_load_over_SOC(table=StorageModelParams.P_max_load_over_SOC), P_max_unload_over_SOC(table=StorageModelParams.P_max_unload_over_SOC))
                                      annotation (Placement(transformation(extent={{-36,72},{-16,92}})));
  Modelica.Blocks.Sources.RealExpression SOC(y=max(0, storageModel.SOC))
                                                                 annotation (Placement(transformation(extent={{-68,72},{-44,92}})));
  Modelica.Units.SI.Efficiency eta_unload;
  Modelica.Units.SI.Efficiency eta_load;
  parameter Integer efficiencyCalculation=1 "choose if constant efficiency or load depending efficiency is used" annotation(Dialog(group="Parameters"),choices(__Dymola_radioButtons=true, choice=1 "Load depending efficiency", choice=2 "Constant efficiency"));


  // _____________________________________________
  //
  //                 Equations
  // _____________________________________________
equation
  if efficiencyCalculation==1 then
    eta_load=batterySystemEfficiency.eta;
    eta_unload=batterySystemEfficiency.eta;
  else
    eta_load=StorageModelParams.eta_load;
    eta_unload=StorageModelParams.eta_unload;
  end if;



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
<p>Typical characteristic of battery storage.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>P_set: input for electric power in [W]</p>
<p>epp: choice of power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Choose via parameter &apos;efficiencyCalculation&apos; if constant efficiency is used (eta_load and eta_unload from StorageModelParams) or if load depending system efficiency is calculation (via parameters a,b,c,d from StorageModelParams).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Feb 2020: added Boolean to choose efficiency calculation method</span></p>
</html>"));
end Battery;
