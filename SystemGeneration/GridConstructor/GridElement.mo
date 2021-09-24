within TransiEnt.SystemGeneration.GridConstructor;
model GridElement

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialGridCell;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Boolean parameter for activating/deactivating Building 2

  parameter Boolean second_Consumer=true "Activate/Deactivate Building 2";

  // Boolean parameter for deactivation of gas pipe in case that the inlet and outlet gas connector of the Basic_Grid_Element is still activated
  // Used for speeding up simulation by deactivating unnecessary gas pipes from the model
  parameter Integer gas_pipe=0 "Activate/Deactivate gas pipe independent from gas connectors";
  parameter Integer activate_consumer_pipes=0 "Activate/Deactivate gas pipe independent from gas connectors";

  // Integer used to deactivate / activate pipes depending on the connection scheme
  parameter Integer dhn_main_pipe=0 "Activate/Deactivate if no DHN is used at Consumer";
  parameter Integer dhn_consumer_1=0 "Activate/Deactivate if no DHN is used at Consumer";
  parameter Integer dhn_consumer_2=0 "Activate/Deactivate if no DHN is used at Consumer";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // Replaceable table models with load profile data for both buildings
public
  replaceable model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_Table_combined constrainedby TransiEnt.Basics.Tables.Combined.CombinedTables.Base.Demand_combined "Load profile data Building 1" annotation (choicesAllMatching=true, Placement(transformation(extent={{-8,12},{12,32}})));

  replaceable model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_Table_combined constrainedby TransiEnt.Basics.Tables.Combined.CombinedTables.Base.Demand_combined "Load profile data Building 2" annotation (choicesAllMatching=true, Placement(transformation(extent={{-8,12},{12,32}})));

  // Conditional table model of Building 2 can be deactivated by boolean parameter second_Consumer
protected
  Demand_Consumer_1 Demand_1 annotation (Placement(transformation(
        extent={{-14.5,-11.5},{14.5,11.5}},
        rotation=0,
        origin={-25.5,179.5})));
  Demand_Consumer_2 Demand_2 if second_Consumer annotation (Placement(transformation(
        extent={{13,-12},{-13,12}},
        rotation=180,
        origin={-23,-180})));

  // Replaceable Systems models with technology models for both buildings

public
  replaceable model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies constrainedby TransiEnt.SystemGeneration.GridConstructor.Base.PartialTechnologies
                                                                                                                                                                     "Technologies Building 1" annotation (choicesAllMatching=true, Placement(transformation(extent={{-8,12},{12,32}})));

  replaceable model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies constrainedby TransiEnt.SystemGeneration.GridConstructor.Base.PartialTechnologies
                                                                                                                                                                     "Technologies Building 2" annotation (choicesAllMatching=true, Placement(transformation(extent={{-8,12},{12,32}})));

  // Conditional Systems model of Building 2 can be deactivated by boolean parameter second_Consumer
  Systems_Consumer_1 Systems_1 annotation (Placement(transformation(extent={{-40,126},{-8,150}})));
  Systems_Consumer_2 Systems_2 if second_Consumer annotation (Placement(transformation(
        extent={{-16,-11},{16,11}},
        rotation=180,
        origin={-24,-141})));

  //Conditional cable model is deactivated together with inlet and outlet electric connector of Basic_Grid_Element throught boolean parameter el_in of base class BaseClassCell
  TransiEnt.Components.Electrical.Grid.Line_RL cable(simpleModel=true) if el_in annotation (Placement(transformation(extent={{-114,-70},{-94,-50}})));

  // Conditional gas pipe model is deactivated together with inlet and outlet gas connector of Basic_Grid_Element throught boolean parameter gas_in of base class BaseClassCell
  // Conditional gas pipe model is deactivation by boolean parameter gas_pipe if the inlet and outlet gas connector of the Basic_Grid_Element is still activated.
  //
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth gas_Pipe(
    frictionAtOutlet=false,
    frictionAtInlet=true,
    N_cv=1) if gas_in and gas_pipe > 0 annotation (Placement(transformation(extent={{-116,54},{-86,66}})));

  // Conditional dhn pipe model is deactivated depending on the connection scheme
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 main_dhn_pipe if dhn_main_pipe >= 1 annotation (Placement(transformation(extent={{-114,-8},{-94,12}})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 house_pipe_Consumer_1 if dhn_consumer_1 > 0 and dhn_main_pipe >= 1 and activate_consumer_pipes > 0 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-24,42})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 house_pipe_Consumer_2 if dhn_consumer_2 > 0 and dhn_main_pipe >= 1 and activate_consumer_pipes > 0 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-24,-38})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature T_ground if dhn_consumer_2 > 0 and dhn_main_pipe >= 1 annotation (Placement(transformation(extent={{-180,160},{-160,180}})));

equation
  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  // If gas pipe model is deactivated by boolean parameter gas_pipe i.e. inlet and outlet connector is still activated,
  // inlet and outlet connector are connected directly
  if gas_pipe == 0 then
    connect(gasPortIn, gasPortOut);
  end if;
  // Connections of the dhn pipes depending on user input
  if dhn_main_pipe == 0 then
    connect(waterPortIn_supply, waterPortOut_supply);
    connect(waterPortIn_return, waterPortOut_return);
  end if;

  if activate_consumer_pipes == 0 and dhn_consumer_1 == 1 then
    connect(main_dhn_pipe.waterPortOut_supply, Systems_1.waterPortIn) annotation (Line(
        points={{-94,6},{-48,6},{-48,8},{-27.2,8},{-27.2,126.24}},
        color={175,0,0},
        thickness=0.5));
    connect(main_dhn_pipe.waterPortIn_return, Systems_1.waterPortOut) annotation (Line(
        points={{-93.8,-2},{-60,-2},{-60,0},{-20.8,0},{-20.8,126.24}},
        color={175,0,0},
        thickness=0.5));
  end if;

  if activate_consumer_pipes == 0 and dhn_consumer_2 == 1 then
    connect(main_dhn_pipe.waterPortIn_return, Systems_2.waterPortOut) annotation (Line(
        points={{-93.8,-2},{-70,-2},{-70,-22},{-27.2,-22},{-27.2,-130.22}},
        color={175,0,0},
        thickness=0.5));
    connect(main_dhn_pipe.waterPortOut_supply, Systems_2.waterPortIn) annotation (Line(
        points={{-94,6},{-20.8,6},{-20.8,-130.22}},
        color={175,0,0},
        thickness=0.5));
  end if;

  // Regular connections
  connect(house_pipe_Consumer_1.waterPortOut_supply, Systems_1.waterPortIn) annotation (Line(
      points={{-28,52},{-28,126.24},{-27.2,126.24}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_1.waterPortIn_return, Systems_1.waterPortOut) annotation (Line(
      points={{-20,52.2},{-22,52.2},{-22,126.24},{-20.8,126.24}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_1.waterPortIn_supply, main_dhn_pipe.waterPortOut_supply) annotation (Line(
      points={{-28,32},{-28,6},{-94,6}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_1.waterPortOut_return, main_dhn_pipe.waterPortIn_return) annotation (Line(
      points={{-20,32},{-20,-2},{-93.8,-2}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_2.waterPortIn_supply, main_dhn_pipe.waterPortOut_supply) annotation (Line(
      points={{-20,-28},{-20,6},{-94,6}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_2.waterPortOut_return, main_dhn_pipe.waterPortIn_return) annotation (Line(
      points={{-28,-28},{-28,-2},{-93.8,-2}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_2.waterPortOut_supply, Systems_2.waterPortIn) annotation (Line(
      points={{-20,-48},{-20,-64},{-20,-130.22},{-20.8,-130.22}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_2.waterPortIn_return, Systems_2.waterPortOut) annotation (Line(
      points={{-28,-48.2},{-28,-64},{-28,-130.22},{-27.2,-130.22}},
      color={175,0,0},
      thickness=0.5));
  connect(gasPortIn, gas_Pipe.gasPortIn) annotation (Line(
      points={{-180,60},{-116,60}},
      color={255,255,0},
      thickness=1.5));

  connect(gasPortOut, gasPortOut) annotation (Line(
      points={{120,60},{120,60}},
      color={255,255,0},
      thickness=1.5));

  connect(cable.epp_n, epp_n) annotation (Line(
      points={{-94,-59.8},{14,-59.8},{14,-60},{120,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(Systems_1.epp, cable.epp_n) annotation (Line(
      points={{-36.8,126.24},{-38,126.24},{-38,38},{-40,38},{-40,-59.8},{-94,-59.8}},
      color={0,127,0},
      thickness=0.5));

  connect(Systems_2.epp, cable.epp_n) annotation (Line(
      points={{-11.2,-130.22},{-10,-130.22},{-10,-59.8},{-94,-59.8}},
      color={0,127,0},
      thickness=0.5));
  connect(Systems_2.epp, epp_n) annotation (Line(
      points={{-11.2,-130.22},{-10,-130.22},{-10,-60},{120,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(Systems_1.epp, epp_n) annotation (Line(
      points={{-36.8,126.24},{-40,126.24},{-40,-60},{120,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(gas_Pipe.gasPortOut, gasPortOut) annotation (Line(
      points={{-86,60},{120,60}},
      color={255,255,0},
      thickness=1.5));
  connect(gas_Pipe.gasPortOut, Systems_1.gasIn_grid) annotation (Line(
      points={{-86,60},{-12,60},{-12,126.48},{-11.2,126.48}},
      color={255,255,0},
      thickness=1.5));
  connect(Systems_2.gasIn_grid, gas_Pipe.gasPortOut) annotation (Line(
      points={{-36.8,-130.44},{-36.8,60},{-86,60}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortOut, Systems_1.gasIn_grid) annotation (Line(
      points={{120,60},{-12,60},{-12,126.48},{-11.2,126.48}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortOut, Systems_2.gasIn_grid) annotation (Line(
      points={{120,60},{-34,60},{-34,-130.44},{-36.8,-130.44}},
      color={255,255,0},
      thickness=1.5));
  connect(waterPortIn_supply, main_dhn_pipe.waterPortIn_supply) annotation (Line(
      points={{-180,20},{-148,20},{-148,6},{-114,6}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortOut_return, main_dhn_pipe.waterPortOut_return) annotation (Line(
      points={{-180,-20},{-148,-20},{-148,-2},{-114,-2}},
      color={175,0,0},
      thickness=0.5));
  connect(main_dhn_pipe.waterPortOut_supply, waterPortOut_supply) annotation (Line(
      points={{-94,6},{12,6},{12,18},{120,18}},
      color={175,0,0},
      thickness=0.5));
  connect(main_dhn_pipe.waterPortIn_return, waterPortIn_return) annotation (Line(
      points={{-93.8,-2},{12,-2},{12,-20},{120,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(main_dhn_pipe.waterPortOut_supply, house_pipe_Consumer_1.waterPortIn_supply) annotation (Line(
      points={{-94,6},{-28,6},{-28,32}},
      color={175,0,0},
      thickness=0.5));
  connect(main_dhn_pipe.waterPortOut_supply, house_pipe_Consumer_2.waterPortIn_supply) annotation (Line(
      points={{-94,6},{-20,6},{-20,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_2.waterPortOut_return, main_dhn_pipe.waterPortIn_return) annotation (Line(
      points={{-28,-28},{-28,-2},{-93.8,-2}},
      color={175,0,0},
      thickness=0.5));
  connect(house_pipe_Consumer_1.waterPortOut_return, main_dhn_pipe.waterPortIn_return) annotation (Line(
      points={{-20,32},{-20,-2},{-93.8,-2}},
      color={175,0,0},
      thickness=0.5));
  connect(T_ground.port, main_dhn_pipe.heat_supply);
  connect(T_ground.port, main_dhn_pipe.heat_return);
  connect(T_ground.port, house_pipe_Consumer_1.heat_supply);
  connect(T_ground.port, house_pipe_Consumer_1.heat_return);
  connect(T_ground.port, house_pipe_Consumer_2.heat_supply);
  connect(T_ground.port, house_pipe_Consumer_2.heat_return);
  connect(Demand_1.demand.electricPowerDemand, Systems_1.el_Demand) annotation (Line(points={{-25.5,167.54},{-25.5,158},{-33.92,158},{-33.92,149.04}}, color={0,0,127}));
  connect(Demand_1.demand.heatingPowerDemand, Systems_1.q_Demand) annotation (Line(points={{-25.5,167.54},{-25.5,158},{-24,158},{-24,149.28}}, color={0,0,127}));
  connect(Demand_1.demand.hotWaterPowerDemand, Systems_1.q_Demand_water) annotation (Line(points={{-25.5,167.54},{-25.5,158},{-14.4,158},{-14.4,149.28}}, color={0,0,127}));
  connect(Demand_2.demand.electricPowerDemand, Systems_2.el_Demand) annotation (Line(points={{-23,-167.52},{-23,-158},{-14.08,-158},{-14.08,-151.12}}, color={0,0,127}));
  connect(Demand_2.demand.heatingPowerDemand, Systems_2.q_Demand) annotation (Line(points={{-23,-167.52},{-23,-159.76},{-24,-159.76},{-24,-151.34}}, color={0,0,127}));
  connect(Demand_2.demand.hotWaterPowerDemand, Systems_2.q_Demand_water) annotation (Line(points={{-23,-167.52},{-23,-158},{-33.6,-158},{-33.6,-151.34}}, color={0,0,127}));
  connect(T_ground.T, simCenter.T_ground_var);

  connect(epp_p, cable.epp_p) annotation (Line(
      points={{-180,-60},{-148,-60},{-148,-59.8},{-114,-59.8}},
      color={0,127,0},
      thickness=0.5));
  connect(cable.epp_n, epp_n) annotation (Line(
      points={{-94,-59.8},{14,-59.8},{14,-60},{120,-60}},
      color={0,127,0},
      thickness=0.5));
  annotation (
    Placement(transformation(extent={{-112,18},{-86,26}})),
    Icon(coordinateSystem(extent={{-180,-200},{120,200}}), graphics={
        Rectangle(
          extent={{-158,98},{98,-98}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-62,36},{0,92}}, lineColor={28,108,200}),
        Ellipse(extent={{-62,-96},{0,-40}}, lineColor={28,108,200}),
        Line(points={{-160,0},{100,0}}, color={28,108,200}),
        Line(points={{-32,36},{-32,2},{-32,0},{-32,-40}}, color={28,108,200}),
        Text(
          extent={{-174,-113},{126,-153}},
          lineColor={0,134,134},
          textString="%name")}),
    Diagram(coordinateSystem(extent={{-180,-200},{120,200}}), graphics={
        Rectangle(extent={{-52,116},{4,198}}, lineColor={28,108,200}),
        Rectangle(extent={{-52,-198},{4,-120}}, lineColor={28,108,200}),
        Text(
          extent={{8,-164},{40,-150}},
          lineColor={28,108,200},
          textString="Building 2"),
        Text(
          extent={{8,148},{40,162}},
          lineColor={28,108,200},
          textString="Building 1")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Represents a single element of a street segment with up to two consumers opposite to each other. Not to be used outside of the GridConstructor. </p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow for IntegraNet I, 2017</span></p>
</html>"));
end GridElement;
