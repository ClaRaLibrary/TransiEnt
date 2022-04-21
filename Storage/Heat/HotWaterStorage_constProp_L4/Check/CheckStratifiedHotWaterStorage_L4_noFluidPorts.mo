within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Check;
model CheckStratifiedHotWaterStorage_L4_noFluidPorts "Validation of one dimensional hot water storage with CHP loading scenario"


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





  import TransiEnt;
  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  extends TransiEnt.Basics.Icons.Checkmodel;

  import Modelica.Units.SI;
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 hotWaterStorage_constProp_L4_4_1(useFluidPorts=false, V=1) annotation (Placement(transformation(extent={{-28,-36},{30,14}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(T(displayUnit="K") = 303) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={1,49})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[hotWaterStorage_constProp_L4_4_1.N_cv] prescribedTemperature1(Q_flow={0,0,0,0,-1000}) annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=-90,
        origin={57,37})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(prescribedTemperature.port, hotWaterStorage_constProp_L4_4_1.heatPortAmbient) annotation (Line(points={{1,42},{1,10.25}},                   color={191,0,0}));
  connect(prescribedTemperature1.port, hotWaterStorage_constProp_L4_4_1.port) annotation (Line(points={{57,30},{56,30},{56,4.75},{27.68,4.75}}, color={191,0,0}));

  annotation (
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for loading HotWaterStorage_constProp_L4_noFLuids</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=14160,
      Tolerance=1e-009,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end CheckStratifiedHotWaterStorage_L4_noFluidPorts;
