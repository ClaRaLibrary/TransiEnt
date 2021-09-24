within TransiEnt.Components.Turbogroups.OperatingStates.Check;
model TestThreeStateDynamic_Initatmin "Model for testing three state dynamic with an initial minimum"

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
  TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic threeStateDynamic(
    t_startup=900,
    t_eps=950,
    P_star_init=0.3,
    useThresh=simCenter.useThresh,
    variableSlewRateLimiter(y(fixed=false))) annotation (Placement(transformation(extent={{12,-32},{48,4}})));
  Modelica.Blocks.Sources.Step Step(
    startTime=7.5e4,
    height=-0.8,
    offset=-0.3)     annotation (Placement(transformation(extent={{-34,-24},{-14,-4}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,78},{-70,98}})));
equation
  connect(Step.y, threeStateDynamic.P_set_star) annotation (Line(points={{-13,-14},{12,-14}}, color={0,0,127}));
  connect(threeStateDynamic.P_set_star_lim, threeStateDynamic.P_actual_star) annotation (Line(
      points={{50.16,-14},{74,-14},{74,-52},{30,-52},{30,-32}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-50,80},{38,38}},
          lineColor={0,0,0},
          textString="Look at:
P_set
threeStateDynamic.y
halt.active
startup.active
operating.active")}),
    experiment(StopTime=90000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ThreeStateDynamic model</p>
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
end TestThreeStateDynamic_Initatmin;
