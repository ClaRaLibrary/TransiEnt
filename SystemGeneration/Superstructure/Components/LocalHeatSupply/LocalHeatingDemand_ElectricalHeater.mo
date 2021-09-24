within TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply;
model LocalHeatingDemand_ElectricalHeater

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

  extends TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.Base.PartialLocalHeatingDemand_P2H;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Units.SI.Temperature T_surrounding=if whichHeatPump == 1 then 273.15 + 9 else T_region;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=308.15) annotation (Placement(transformation(extent={{26,-4},{18,4}})));
  replaceable TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler electricBoiler(
    Q_flow_n=1e99,
    useFluidPorts=false,
    usePowerPort=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(electricBoiler.epp, epp) annotation (Line(
      points={{0,-10.2},{0,-20},{60,-20},{60,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(electricBoiler.heat, fixedTemperature.port) annotation (Line(points={{10.4,3.8},{14,3.8},{14,0},{18,0}},
                                                                                               color={191,0,0}));
  connect(Q_flow_set, electricBoiler.Q_flow_set) annotation (Line(points={{-120,60},{-10.4,60},{-10.4,1}},
                                                                                                    color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of electrical heater to cover local heating demand</p>
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
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end LocalHeatingDemand_ElectricalHeater;
