within TransiEnt.Components.Heat.ThermalInsulation.Check;
model TestThermalInsulation

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



  inner TransiEnt.SimCenter
                        simCenter(redeclare TILMedia.GasTypes.MoistAirMixture airModel)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  ThermalInsulation_dynamic_1way_1layer insulation_1(
    final N_cv=2,
    N_iso=3,
    final length=10,
    final circumference=Modelica.Constants.pi,
    thickness=0.1,
    redeclare model medium = TransiEnt.Basics.Media.Solids.MineralWool)
                   annotation (Placement(transformation(extent={{-20,38},{0,54}})));
  ThermalInsulation_static_1way_1layer insulation_2(
    final N_cv=2,
    final length=10,
    final circumference=Modelica.Constants.pi,
    thickness=0.1,
    redeclare model medium = TransiEnt.Basics.Media.Solids.MineralWool)
                   annotation (Placement(transformation(extent={{-20,-6},{0,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=873.15)
                                                                          annotation (Placement(transformation(extent={{66,-24},{46,-4}})));
  ThermalInsulation_dynamic_3ways_2layer insulation_3(
    final N_cv=2,
    N_iso=3,
    final length=10,
    final circumference=Modelica.Constants.pi,
    thickness_top_L1=0.05,
    thickness_top_L2=0.05,
    thickness_sides_L1=0.05,
    thickness_sides_L2=0.05,
    thickness_bottom_L1=0.05,
    thickness_bottom_L2=0.05,
    redeclare model medium_top_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_top_L2 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_sides_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_sides_L2 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_bottom_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_bottom_L2 = TransiEnt.Basics.Media.Solids.MineralWool)
                                                          annotation (Placement(transformation(extent={{-20,-42},{0,-26}})));
  ThermalInsulation_static_3ways_2layer insulation_4(
    final N_cv=2,
    final length=10,
    final circumference=Modelica.Constants.pi,
    thickness_top_L1=0.05,
    thickness_top_L2=0.05,
    thickness_sides_L1=0.05,
    thickness_sides_L2=0.05,
    thickness_bottom_L1=0.05,
    thickness_bottom_L2=0.05,
    redeclare model medium_top_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_top_L2 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_sides_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_sides_L2 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_bottom_L1 = TransiEnt.Basics.Media.Solids.MineralWool,
    redeclare model medium_bottom_L2 = TransiEnt.Basics.Media.Solids.MineralWool)
                                                     annotation (Placement(transformation(extent={{-20,-76},{0,-60}})));


equation
    for i in 1:2 loop
    connect(insulation_1.heat[i], fixedTemperature.port) annotation (Line(
        points={{0,46},{24,46},{24,-14},{46,-14}},
        color={167,25,48},
        thickness=0.5));
    connect(fixedTemperature.port, insulation_2.heat[i]) annotation (Line(points={{46,-14},{24,-14},{24,2},{0,2}}, color={191,0,0}));
    connect(fixedTemperature.port, insulation_3.heat[i]) annotation (Line(points={{46,-14},{24,-14},{24,-34},{0,-34}}, color={191,0,0}));
    connect(fixedTemperature.port, insulation_4.heat[i]) annotation (Line(points={{46,-14},{24,-14},{24,-68},{0,-68}},       color={191,0,0}));

    end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-92,98},{-2,50}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Comparison of thermal insulation models for pipe with d=1m
and l=10m. The thermal insulation is made of mineral wool with 10cm thickness.

Look at insulation_x.summary.Q_flow_loss to
compare the heat flux through the insulation models
at equal temperature boundaries.")}),
    experiment(
      StopTime=120,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check Insulation models.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
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
<p>Model created by Michael von der Heyde (heyde@tuhh.de), Apr 2021</p>
</html>"));
end TestThermalInsulation;
