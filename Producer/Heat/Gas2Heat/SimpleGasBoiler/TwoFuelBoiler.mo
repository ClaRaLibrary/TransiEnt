within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler;
model TwoFuelBoiler "Abstract model for boilers using two different fuel types"

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
  //            Class hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //            Outer components
  // _____________________________________________

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  Basics.Interfaces.Thermal.FluidPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{-111,-7},{-91,13}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{94,-10},{114,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set_B1 "Setpoint for thermal heat of boiler 1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,102}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-58,98})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set_B2 "Setpoint for thermal heat of boiler 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={53,102}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,98})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable SimpleBoiler boiler1 constrainedby TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.Base.PartialBoiler(final useGasPort=false) "First boiler model" annotation (choicesAllMatching=true, Placement(transformation(extent={{-61,-23},{-10,23}})));
  replaceable SimpleBoiler boiler2 constrainedby TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.Base.PartialBoiler(final useGasPort=false) "Second boiler model" annotation (choicesAllMatching=true, Placement(transformation(extent={{27,-23},{78,23}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(boiler2.Q_flow_set, Q_flow_set_B2) annotation (Line(points={{52.5,23},{52.5,62},{53,62},{53,102}}, color={0,0,127}));
  connect(boiler1.Q_flow_set, Q_flow_set_B1) annotation (Line(points={{-35.5,23},{-35.5,59},{-36,59},{-36,102}}, color={0,0,127}));
  connect(boiler1.inlet, inlet) annotation (Line(
      points={{-60.49,0},{-101,0},{-101,3}},
      color={175,0,0},
      thickness=0.5));
  connect(boiler1.outlet, boiler2.inlet) annotation (Line(
      points={{-10,0},{-10,0},{27.51,0}},
      color={175,0,0},
      thickness=0.5));
  connect(boiler2.outlet, outlet) annotation (Line(
      points={{78,0},{91,0},{104,0}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-66,28},{-12,-24}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{18,26},{72,-26}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-86,0},{-86,0},{-54,0},{-42,16},{-28,-12},{-18,0},{4,0}},color={162,29,33}),
        Line(points={{-2,0},{-2,0},{30,0},{42,16},{56,-12},{66,0},{88,0}},     color={162,29,33})}),
                                  Diagram(graphics,
                                          coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a gas boiler using TransiEnt interfaces and TransiEnt.Statistics. Gas Consumption is computed using a constant efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>inlet: FluidPortIn</p>
<p>outlet: FluidPortOut</p>
<p>Q_flow_set_B1: setpoint of thermal heat for boiler 1 (input for heat flow rate in W)</p>
<p>Q_flow_set_B2: setpoint of thermal heat flow rate for boiler 2 (input for heat flow rate in W)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end TwoFuelBoiler;
