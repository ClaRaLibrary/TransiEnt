within TransiEnt.Components.Sensors.Check;
model TestFrequencyStandardDeviation

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
  FrequencyStandardDeviation frequencyStandardDeviation annotation (Placement(transformation(extent={{-16,6},{4,26}})));
  Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1 annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Basics.Tables.GenericDataTable f_1year_60s(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt",
    use_absolute_path=false,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments) annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Constant expected(k=0.021561) annotation (Placement(transformation(extent={{-54,42},{-34,62}})));
  Modelica.Blocks.Sources.RealExpression error_in_percent(y=(frequencyStandardDeviation.y - expected.k)/expected.k*100) annotation (Placement(transformation(extent={{-34,-74},{16,-32}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation

  connect(frequencyStandardDeviation.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-6,6.2},{-6,0},{44,0}},
      color={0,135,135},
      thickness=0.5));
  connect(f_1year_60s.y1, constantFrequency_L1_1.f_set) annotation (Line(points={{31,50},{48.6,50},{48.6,12}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3.15367e+007,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the FrequencyStandardDeviation model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestFrequencyStandardDeviation;
