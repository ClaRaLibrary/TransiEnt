within TransiEnt.Producer.Heat.Base;
partial model PartialHeatPumpCharlineFluidPorts "Partial heat pump model that produces a given heat flow via fluid ports with a charline"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Heat.Base.PartialHeatPumpCharline;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumWater=simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_drop=heatFlowBoundary.simCenter.p_nom[2] -
      heatFlowBoundary.simCenter.p_nom[1] annotation (Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=mediumWater) annotation (Placement(transformation(extent={{-50,-110},{-30,-90}}), iconTransformation(extent={{-50,-110},{-30,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=mediumWater) annotation (Placement(transformation(extent={{30,-110},{50,-90}}), iconTransformation(extent={{30,-110},{50,-90}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    use_Q_flow_in=true,
    Medium=mediumWater,
    change_sign=false) constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_in_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_out_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  heatFlowBoundary.Q_flow_prescribed=Q_flow;

  DeltaT=T_out_sensor.T-T_source_internal;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(waterPortIn, heatFlowBoundary.fluidPortIn) annotation (Line(
      points={{-40,-100},{-40,-10},{-6,-10}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(heatFlowBoundary.fluidPortOut, waterPortOut) annotation (Line(
      points={{6,-10},{40,-10},{40,-100}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(waterPortOut, T_out_sensor.port) annotation (Line(
      points={{40,-100},{40,-40},{30,-40}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(waterPortIn, T_in_sensor.port) annotation (Line(
      points={{-40,-100},{-40,-40}},
      color={175,0,0},
      thickness=0.5));
annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for simple heat pump models that produce a given heat flow via fluid ports and use a charline.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Changing ambient temperature can be considered as well as varying COP depending on the temperature difference between waterPortOut and source. Different heat flow boundaries, in which the heat flow is transfered to the water, can be chosen.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<p>waterPortIn: inlet port for heating water</p>
<p>waterPortOut: outlet port for heating water</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Temperature difference for charline = waterPortOut temperature - source temperature</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Feb 2018</p>
</html>"));
end PartialHeatPumpCharlineFluidPorts;
