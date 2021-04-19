within TransiEnt.Components.Gas.Engines.HeatFlow;
model SimpleHeatFlow

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Components.Gas.Engines.HeatFlow.BasicHeatFlow;

  Modelica.Blocks.Sources.RealExpression HeatFlow(y=Q_flow_out) annotation (Placement(transformation(extent={{22,-16},{42,4}})));
  Boundaries.Heat.Heatflow_L1 heatflow_L1_1(change_sign=true) annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=90,
        origin={101,7})));
equation

  if switch then
    // Calculating heat flow from electric power an the efficencies
   Q_flow_out= P_el_set*(eta_h-eta_el)/eta_el;
  else
     Q_flow_out=0;
  end if;

    // not used Heat flow rates defined in base class
  Q_flow_engine =0 "Usable heat flow from engine cooling cycle";
  Q_flow_exhaust=0 "Usable heat flow from exhaust";
  Q_flow_loss=0 "Total heat flow losses to the environment";
  Q_flow_loss_room=0 "Heat flow losses to the room";
  Q_flow_loss_exhaust=0 "Heat flow loss due to exhaust losses";
  Q_flow_engine_tot=0 "Total heat flow from engine";

    // not used temperatures defined in base class
  TemperaturesOut[1]=293.15;
  TemperaturesOut[2]=293.15;

  connect(heatflow_L1_1.fluidPortOut, waterPortOut) annotation (Line(
      points={{120,18.4},{130,18.4},{130,18},{146,18},{146,130},{230,130}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_1.fluidPortIn, waterPortIn) annotation (Line(
      points={{120,-4.4},{146,-4.4},{146,-110},{230,-110}},
      color={175,0,0},
      thickness=0.5));
  connect(HeatFlow.y, heatflow_L1_1.Q_flow_prescribed) annotation (Line(points={{43,-6},{80,-6},{80,-4.4},{85.8,-4.4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{220,160}})));
end SimpleHeatFlow;
