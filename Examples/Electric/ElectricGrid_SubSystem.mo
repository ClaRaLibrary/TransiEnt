within TransiEnt.Examples.Electric;
model ElectricGrid_SubSystem "Example for sector coupling in TransiEnt library"


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
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Power P_el_n_PV=simCenter.generationPark.P_el_n_PV "Installed nominal power of PV plants";
  parameter Modelica.Units.SI.Power P_el_n_WindOn=simCenter.generationPark.P_el_n_WindOn "Installed nominal power of wind plants";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_scheduledProducers annotation (Placement(transformation(extent={{70,110},{90,130}}), iconTransformation(extent={{70,110},{90,130}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_electricityDemand annotation (Placement(transformation(extent={{-70,110},{-50,130}}), iconTransformation(extent={{-70,110},{-50,130}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_UCTE annotation (Placement(transformation(extent={{110,-11},{130,9}}), iconTransformation(extent={{110,-10},{130,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn solarRadiation "Electric power setpoint" annotation (Placement(transformation(extent={{-134,30},{-114,50}}), iconTransformation(extent={{-124,36},{-114,46}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn windPower "Electric power setpoint" annotation (Placement(transformation(extent={{-134,-50},{-114,-30}}), iconTransformation(extent={{-124,-44},{-114,-34}})));


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant windProduction(P_el_n=P_el_n_WindOn) annotation (Placement(transformation(extent={{-78,-92},{-38,-50}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant pVPlant(P_el_n=P_el_n_PV) annotation (Placement(transformation(extent={{-78,-10},{-38,32}})));
  TransiEnt.Components.Electrical.Grid.Line line annotation (Placement(transformation(extent={{38,-19},{78,21}})));


equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(windProduction.epp, line.epp_1) annotation (Line(
      points={{-40,-56.3},{0,-56.3},{0,0.8},{38.2,0.8}},
      color={0,135,135},
      thickness=0.5));
  connect(line.epp_1, epp_electricityDemand) annotation (Line(
      points={{38.2,0.8},{0,0.8},{0,88},{-60,88},{-60,120}},
      color={0,135,135},
      thickness=0.5));
  connect(line.epp_1, epp_scheduledProducers) annotation (Line(
      points={{38.2,0.8},{0,0.8},{0,88},{80,88},{80,120}},
      color={0,135,135},
      thickness=0.5));
  connect(line.epp_2, epp_UCTE) annotation (Line(
      points={{77.8,1},{77.8,-1},{120,-1}},
      color={0,135,135},
      thickness=0.5));
  connect(pVPlant.epp, line.epp_1) annotation (Line(
      points={{-40,25.7},{0,25.7},{0,0.8},{38.2,0.8}},
      color={0,135,135},
      thickness=0.5));
  connect(solarRadiation, pVPlant.P_el_set) annotation (Line(points={{-124,40},{-124,40},{-61,40},{-61,31.79}}, color={0,0,127}));
  connect(windPower, windProduction.P_el_set) annotation (Line(points={{-124,-40},{-124,-40},{-61,-40},{-61,-50.21}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1,
        extent={{-120,-120},{120,120}}), graphics={
        Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,-92},{140,-120}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Electric Grid"),
        Ellipse(
          extent={{-68,72},{76,-66}},
          lineColor={0,135,135},
          lineThickness=1)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}},
        initialScale=0.1), graphics={Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-32,-92},{140,-120}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Electric Grid")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small electric subsystem with CHP. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp_scheduledProducers: active power port</p>
<p>epp_electricityDemand: active power port</p>
<p>epp_UCTE: active power port</p>
<p>solarRadiation: input for electric power setpoint in [W]</p>
<p>windPower: input for electric power setpoint in [W]</p>
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
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
<p>Revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017</p>
</html>"));
end ElectricGrid_SubSystem;
