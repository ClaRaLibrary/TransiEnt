within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler;
model Gasboiler_dynamic_L1 "Full modulating or staged gasboiler, signal based dynamic model with splitted ideal combustion and ideal heat-transfer"


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
  extends TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Base.PartialGasboiler;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter Integer dimension=2 "Boiler dimension" annotation (Dialog(tab="General", group="Specification"), choices(
    choice=1 "Small (Appartment/OFH): 10 to 200 kW",
    choice=2 "Medium (MFH): 100 to 800 kW",
    choice=3 "Large (DH): 600 to 5000 kW"));
  parameter Boolean modulating = true "Modulating operation, staged power production if false (select stages then!)" annotation (Dialog(tab="General", group="Specification", enable = holdTemperature));
  parameter Integer stages = 1 "Number of burner stages for non-modulating operation" annotation (Dialog(tab="General", group="Specification", enable = (not modulating) and holdTemperature),choices(choice=1 "1: Two-position controlled",
                                                                                                  choice=2 "2: Three-position controlled"));
  parameter Real stagePercentage = 0.3 "Power percentage at burner stage 2" annotation (Dialog(tab="General", group="Specification", enable = stages==2));
  parameter SI.TemperatureDifference T_supply_tol = 3 "Acceptable absolute tolerance of supply temperature for controlling (consider dynamics of boiler!)" annotation (Dialog(tab="General", group="Specification", enable = (not modulating) and holdTemperature));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________
  Integer stageSwitch(start=0);

  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________
protected
  Utilities.BoilerHeatDynamics boilerHeatDynamics(damping=if dimension == 1 then 25 else if dimension == 2 then 50 else 120) annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-42})));
  Components.Heat.HEX_ideal hex(Delta_p=Delta_p_nom) annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));

equation
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________
  if holdTemperature then
    Q_flow_set_internal =
    if modulating then waterPortIn.m_flow*cp_water*(T_supply_set_internal - temperatureWaterIn.T)
    else
      if stageSwitch == 1 then stagePercentage*Q_flow_n
      elseif stageSwitch == 2 then Q_flow_n
      else 0;
  end if;
  if modulating then
    stageSwitch = 0;
  else
    if stages == 1 then
      if pre(stageSwitch) == 0 and hex.fluidOut.T < T_supply_set_internal - T_supply_tol then
        stageSwitch = 2;
      elseif pre(stageSwitch) == 2 and hex.fluidOut.T > T_supply_set_internal + T_supply_tol then
        stageSwitch = 0;
      else
        stageSwitch = pre(stageSwitch);
      end if;
    else
      if pre(stageSwitch) == 0 and hex.fluidOut.T < T_supply_set_internal - T_supply_tol then
        stageSwitch = 2;
      elseif pre(stageSwitch) == 2 and hex.fluidOut.T > T_supply_set_internal + 0.5 * T_supply_tol then
        stageSwitch = 1;
      elseif pre(stageSwitch) == 1 and hex.fluidOut.T > T_supply_set_internal + T_supply_tol then
        stageSwitch = 0;
      elseif pre(stageSwitch) == 1 and hex.fluidOut.T < T_supply_set_internal - 0.5 * T_supply_tol then
        stageSwitch = 2;
      else
        stageSwitch = pre(stageSwitch);
      end if;
    end if;
  end if;

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(boilerHeatDynamics.out, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-17.4,-20},{0,-20},{0,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, hex.heatport) annotation (Line(
      points={{0,-52},{0,-62.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(limiter.y, duty2EfficiencyCharline.Q_flow_set) annotation (Line(
      points={{-17.4,90},{9.6,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, boilerHeatDynamics.set) annotation (Line(
      points={{-17.4,90},{0,90},{0,20},{-60,20},{-60,-20},{-42.6,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(waterPortIn, hex.waterPortIn) annotation (Line(
      points={{-40,-120},{-40,-120},{-40,-72},{-10,-72}},
      color={175,0,0},
      thickness=0.5));
  connect(hex.waterPortOut, waterPortOut) annotation (Line(
      points={{10,-72},{24,-72},{40,-72},{40,-120}},
      color={175,0,0},
      thickness=0.5));
  annotation (defaultComponentName="gasBoiler",
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>Simple dynamic gas boiler model with splitted heat generation and emission (CO2) calculation </p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b> </p>
<p>By default, a given heat duty <i>Q</i><sub>flow,set</sub> is set (limited) to the boilers characteristica (<i>Q</i><sub>flow,n</sub>, <i>Q</i><sub>flow,min</sub>) and then set to a static ideal heat exchanger. For the given heat carrier supply temperature the required heat carrier mass flow is calulated. For the operational mode the supply temperature can also be left variable.</p>
<p>In hold-temperature-mode the boiler needs no heat flow set-input and will heat the carrier to the given temperature within its limits of power. The <i>Q</i><sub>flow,set</sub>-value is therefore calculated within the model. In this mode, the boiler can also operate with staged power (on/off or full/part/off), where the power percentage at the part-stage can be given.</p>
<p>The boiler&apos;s dynamic is modelled signal based with a first order delay which is variable with the power change step size so that smaller duty changes can be served faster.</p>
<p>From the part load of the boiler and the return flow temperature, the boiler efficiency and fuel heat input is calculated with characteristical lines.</p>
<p><br><img src=\"modelica://TransiEnt/Images/BoilerCharLinePartLoad.png\"/> <img src=\"modelica://TransiEnt/Images/BoilerCharLineReturnTemp.png\"/></p>
<p>Depending on the users preference (set by the parameter <i>referenceNCV</i>), efficiencies and power calculations in this model are based on either the net or the gross calorific value (NCV or GCV, respectively). With a function for dynamic HV calculation the required fuel mass flow as an output-value is generated.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>A constant air ratio to be chosen is asumed.</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b> </p>
<p>Q_flow_set_internal - heat duty input (only in default mode) </p>
<p>T_supply_set_internal - temperature input in K</p>
<p>gasPortIn/Out - port for fuelgas at the inlet and exhaustgas at the outlet </p>
<p>waterPortIn/Out - ports for the heat carrier (water) </p>
<p>m_flow_fuel_req - output of required fuel mass flow rate </p>
<p>m_flow_HC - output of heat carrier mass flow rate </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b> </p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no elements) </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b> </p>
<p>(no validation or testing necessary) </p>
<p><b><span style=\"color: #008000;\">9. References</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b> </p>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) July 2015 </p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"),
Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end Gasboiler_dynamic_L1;
