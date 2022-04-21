within TransiEnt.Producer.Electrical.Controllers.Check;
model TestPrimaryBalancingPowerDemand2012 "Example how to calculate the demand of primary balancing power"


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




  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter(
    n_consumers=1,
    P_consumer={300e9},
    T_grid=7.5) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics                    modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant f_n(k=simCenter.f_n)
    annotation (Placement(transformation(extent={{-52,23},{-32,43}})));
  PrimaryBalancingController PrimaryBalancingController60(plantType=TransiEnt.Basics.Types.ControlPlantType.Provided) annotation (Placement(transformation(extent={{28,-29},{56,-3}})));
  Modelica.Blocks.Math.Feedback feedback60
    annotation (Placement(transformation(extent={{-26,-6},{-6,-26}})));
  TransiEnt.Basics.Tables.GenericDataTable fmeasured60(
    change_of_sign=false,
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="/electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt") annotation (Placement(transformation(extent={{-68,-26},{-48,-6}})));
equation
  connect(feedback60.y, PrimaryBalancingController60.delta_f) annotation (Line(
      points={{-7,-16},{26.6,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(f_n.y, feedback60.u2) annotation (Line(
      points={{-31,33},{-31,32.5},{-16,32.5},{-16,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fmeasured60.y1, feedback60.u1) annotation (Line(
      points={{-47,-16},{-24,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for primary balancing controller based on power demand of 2012</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
end TestPrimaryBalancingPowerDemand2012;
