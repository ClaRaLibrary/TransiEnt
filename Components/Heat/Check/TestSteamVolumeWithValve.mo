within TransiEnt.Components.Heat.Check;
model TestSteamVolumeWithValve


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




  extends Basics.Icons.Checkmodel;
  SteamVolumeWithValve_L0 SteamVolumeWithValve(y_start=1, T=900) annotation (Placement(transformation(extent={{12,-28},{48,2}})));
  Modelica.Blocks.Sources.Step Q_flow_set(
    height=0.5,
    offset=0.5,
    startTime=400)  annotation (Placement(transformation(extent={{-16,20},{4,40}})));
  Modelica.Blocks.Sources.Constant
                               Q_flow_set1(k=0.5)
                    annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
equation
  connect(Q_flow_set.y, SteamVolumeWithValve.opening) annotation (Line(points={{5,30},{16,30},{30,30},{30,-0.4}}, color={0,0,127}));
  connect(Q_flow_set1.y, SteamVolumeWithValve.m_flow_steam_in) annotation (Line(points={{-19,-16},{-8,-16},{-8,-13},{11.28,-13}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,100},{12,52}},
          lineColor={0,0,0},
          textString="Look at:
SteamGenerator.Q_flow_set
SteamGenerator.m_flow_set")}),
    experiment(StopTime=8000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the SteamVolumeWithValve_L0 model</p>
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
end TestSteamVolumeWithValve;
