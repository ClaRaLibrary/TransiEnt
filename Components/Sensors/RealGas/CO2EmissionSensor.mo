within TransiEnt.Components.Sensors.RealGas;
model CO2EmissionSensor "Calculates CO2 emissions from complete combustion of medium"


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
  //          Imports and Class Hierarchy
  // _____________________________________________
//  extends TransiEnt.Basics.Icons.Combustion;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
   outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.Units.SI.MolarFlowRate[5] n_flow_comp_fuel;
  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________
  //   function plotResult
  //   constant String resultFileName = "InsertModelNameHere.mat";
  //   algorithm
  //     TransiEnt.Basics.Functions.plotResult(resultFileName);
  //     createPlot(...); // obtain content by calling function plotSetup() in the commands window
  //     //add ,filename=resultFileName at the end of first createPlot command
  //   end plotResult;
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}), iconTransformation(extent={{-110,-110},{-90,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{90,-110},{110,-90}}), iconTransformation(extent={{90,-110},{110,-90}})));
protected
  TransiEnt.Components.Sensors.RealGas.NCVSensor
                                        vleNCVSensor  annotation (Placement(transformation(extent={{24,-100},{4,-80}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor
                                               compositionSensor annotation (Placement(transformation(extent={{-2,-100},{-22,-80}})));
public
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_cde "CDE mass flow rate" annotation (Placement(transformation(extent={{100,58},{120,78}}),  iconTransformation(extent={{100,58},{120,78}})));
equation
   m_flow_cde=n_flow_comp_fuel[1]*44.0095/1000;
   n_flow_comp_fuel=TransiEnt.Basics.Functions.GasProperties.comps2Elements_realGas(medium,compositionSensor.fraction,gasPortIn.m_flow);

    connect(compositionSensor.gasPortIn,vleNCVSensor. gasPortOut) annotation (Line(
      points={{-2,-100},{4,-100}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.gasPortIn, gasPortOut) annotation (Line(
      points={{24,-100},{100,-100}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortOut, gasPortIn) annotation (Line(
      points={{-22,-100},{-100,-100}},
      color={255,255,0},
      thickness=1.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model calculates the CO2 emission of the input gas. Output and input are identical. This model is only to be used to measure the potential CO2 if combustion of gas took place.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Ideal combustion is considered.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortOut: outlet for real gas</p>
<p>m_flow_cde: mass flow in kg/s</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Components.Sensors.RealGas.Check.TestRealGasSensors&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018</p>
</html>"), Icon(graphics={
        Text(
          extent={{-100,24},{100,-16}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString=""),
        Line(
          points={{0,-40},{0,-100}},
          color={27,36,42},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-98,42},{102,72}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={230,230,230},
          textString="m_flow_CO2"),
        Polygon(
          points={{-18,40},{-18,40},{-60,40},{-84,0},{-60,-40},{-18,-40},{22,-40},{64,-40},{88,0},{64,40},{22,40},{-18,40}},
          lineColor={27,36,42},
          smooth=Smooth.Bezier,
          lineThickness=0.5),
        Line(
          points={{-98,-100},{96,-100}},
          color={255,255,0},
          thickness=0.5)}));
end CO2EmissionSensor;
