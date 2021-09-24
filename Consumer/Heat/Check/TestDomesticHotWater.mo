within TransiEnt.Consumer.Heat.Check;
model TestDomesticHotWater


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



  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.RealExpression demand(y=3e3) annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  inner TransiEnt.SimCenter simCenter(
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind,
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature),
    integrateHeatFlow=true)                                                                         annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  DomesticHotWater domesticHotWater annotation (Placement(transformation(extent={{-30,-28},{-10,-8}})));
  DomesticHotWater domesticHotWater1(NSH=1) annotation (Placement(transformation(extent={{16,-28},{36,-8}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(extent={{-58,-54},{-78,-34}})));
equation
  connect(demand.y, domesticHotWater.demand) annotation (Line(points={{-37,20},{-20,20},{-20,-7.2}}, color={0,0,127}));
  connect(demand.y, domesticHotWater1.demand) annotation (Line(points={{-37,20},{26,20},{26,-7.2}}, color={0,0,127}));
  connect(ElectricGrid.epp, domesticHotWater1.epp) annotation (Line(
      points={{-58,-44},{0,-44},{0,-18.1},{15.9,-18.1}},
      color={0,127,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                                 Text(
          extent={{-20,116},{38,58}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- ElectricGrid.epp.P"),                                                          Text(
          extent={{-100,10},{-28,-48}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Without NSH in the Systems model",
          fontSize=8),                                                           Text(
          extent={{40,22},{100,-60}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="With NSH in the Systems model")}),
    experiment(
      StartTime=3456000,
      StopTime=5184000,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for DomesticHotWater</p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model created by Philipp Huismann (huismann@gwi-essen.de) August 2021</p>
</html>"));
end TestDomesticHotWater;
