within TransiEnt.SystemGeneration.Superstructure.Components.HeatingGridSystems;
model HeatProducerRow

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

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Integer DifferentConnections=1;

  parameter Integer QuantityConnection1=1;
  parameter Integer QuantityConnection2=1;
  parameter Integer QuantityConnection3=1;
  parameter Integer QuantityConnection4=1;
  parameter Integer QuantityConnection5=1;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Heating condenser parameters"));

  // _____________________________________________
  //
  //                Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn(Medium=medium) annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut(Medium=medium) annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_Connection1[QuantityConnection1](each Medium=medium) if DifferentConnections >= 1 annotation (Placement(transformation(extent={{116,-70},{136,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_Connection1[QuantityConnection1](each Medium=medium) if DifferentConnections >= 1 annotation (Placement(transformation(extent={{146,-70},{166,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_Connection2[QuantityConnection2](each Medium=medium) if DifferentConnections >= 2 annotation (Placement(transformation(extent={{46,-70},{66,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_Connection2[QuantityConnection2](each Medium=medium) if DifferentConnections >= 2 annotation (Placement(transformation(extent={{76,-70},{96,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_Connection3[QuantityConnection3](each Medium=medium) if DifferentConnections >= 3 annotation (Placement(transformation(extent={{-24,-70},{-4,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_Connection3[QuantityConnection3](each Medium=medium) if DifferentConnections >= 3 annotation (Placement(transformation(extent={{6,-70},{26,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_Connection4[QuantityConnection4](each Medium=medium) if DifferentConnections >= 4 annotation (Placement(transformation(extent={{-94,-70},{-74,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_Connection4[QuantityConnection4](each Medium=medium) if DifferentConnections >= 4 annotation (Placement(transformation(extent={{-64,-70},{-44,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_Connection5[QuantityConnection5](each Medium=medium) if DifferentConnections >= 5 annotation (Placement(transformation(extent={{-164,-70},{-144,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_Connection5[QuantityConnection5](each Medium=medium) if DifferentConnections >= 5 annotation (Placement(transformation(extent={{-134,-70},{-114,-50}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  if DifferentConnections < 1 then
    connect(WaterPortIn, WaterPortOut);
  elseif DifferentConnections >= 1 and QuantityConnection1 >= 1 then
    connect(WaterPortIn, WaterPortOut_Connection1[1]);
  end if;

  //connect last input port with main output port
  if DifferentConnections == 5 then
    connect(WaterPortOut, WaterPortIn_Connection5[QuantityConnection5]);
  elseif DifferentConnections == 4 then
    connect(WaterPortOut, WaterPortIn_Connection4[QuantityConnection4]);
  elseif DifferentConnections == 3 then
    connect(WaterPortOut, WaterPortIn_Connection3[QuantityConnection3]);
  elseif DifferentConnections == 2 then
    connect(WaterPortOut, WaterPortIn_Connection2[QuantityConnection2]);
  elseif DifferentConnections == 1 then
    connect(WaterPortOut, WaterPortIn_Connection1[QuantityConnection1]);
  end if;

  //connect last input port of each array with first port of next array
  if DifferentConnections >= 2 then
    connect(WaterPortIn_Connection1[QuantityConnection1], WaterPortOut_Connection2[1]);
  end if;
  if DifferentConnections >= 3 then
    connect(WaterPortIn_Connection2[QuantityConnection2], WaterPortOut_Connection3[1]);
  end if;
  if DifferentConnections >= 4 then
    connect(WaterPortIn_Connection3[QuantityConnection3], WaterPortOut_Connection4[1]);
  end if;
  if DifferentConnections >= 5 then
    connect(WaterPortIn_Connection4[QuantityConnection4], WaterPortOut_Connection5[1]);
  end if;

  //connect ports of array to one another
  if DifferentConnections >= 1 and QuantityConnection1 > 1 then
    for i in 1:QuantityConnection1 - 1 loop
      connect(WaterPortIn_Connection1[i], WaterPortOut_Connection1[i + 1]);
    end for;
  elseif DifferentConnections >= 2 and QuantityConnection2 > 1 then
    for i in 1:QuantityConnection2 - 1 loop
      connect(WaterPortIn_Connection2[i], WaterPortOut_Connection2[i + 1]);
    end for;
  elseif DifferentConnections >= 3 and QuantityConnection3 > 1 then
    for i in 1:QuantityConnection3 - 1 loop
      connect(WaterPortIn_Connection3[i], WaterPortOut_Connection3[i + 1]);
    end for;
  elseif DifferentConnections >= 4 and QuantityConnection4 > 1 then
    for i in 1:QuantityConnection4 - 1 loop
      connect(WaterPortIn_Connection4[i], WaterPortOut_Connection4[i + 1]);
    end for;
  elseif DifferentConnections >= 5 and QuantityConnection5 > 1 then
    for i in 1:QuantityConnection5 - 1 loop
      connect(WaterPortIn_Connection5[i], WaterPortOut_Connection5[i + 1]);
    end for;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-60},{180,60}}), graphics={
        Rectangle(
          extent={{-180,60},{180,-60}},
          linecolor={175,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=5),
        Line(
          points={{180,0},{156,0},{156,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{126,-60},{126,-32},{118,-20},{96,-20},{86,-30},{86,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{56,-60},{56,-32},{48,-20},{26,-20},{16,-30},{16,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-16,-60},{-16,-32},{-24,-20},{-46,-20},{-56,-30},{-56,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-86,-60},{-86,-32},{-94,-20},{-116,-20},{-126,-30},{-126,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-180,0},{-156,0},{-156,-60}},
          color={175,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-60},{180,60}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Modelling of various heat producers in a row.</p>
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
end HeatProducerRow;
