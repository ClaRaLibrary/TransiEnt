within TransiEnt.Storage.Gas;
model UndergroundGasStorageIdealHTInPipes_L2 "Model of a simple gas storage volume with ideal heat transfer in the pipes"



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

  import TransiEnt;
  import      Modelica.Units.SI;
  import Modelica.Constants.pi;

  extends TransiEnt.Basics.Icons.StorageGenericGasPressureLoss;
  extends TransiEnt.Storage.Gas.Base.MatchClassGasStorage;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter SI.Temperature T_pipeIn_end=storage.T_surrounding - 3 "Fixed temperature of the medium at pipeIn's outlet" annotation (Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_pipeOut_end=simCenter.T_ground + 3 "Fixed temperature of the medium at pipeOut's outlet" annotation (Dialog(group="Heat Transfer"));

  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-10,39},{10,59}}), iconTransformation(extent={{-10,39},{10,59}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,-63},{10,-43}}), iconTransformation(extent={{-10,-73},{10,-53}})));
  TransiEnt.Basics.Interfaces.General.PressureOut p_gas annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureOut(T=T_pipeIn_end) annotation (Placement(transformation(extent={{44,-38},{24,-18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureIn(T=T_pipeOut_end) annotation (Placement(transformation(extent={{44,16},{24,36}})));
public
  replaceable TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage constrainedby TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEX_pipeIn(final medium=medium, final T_fluidOutConst=T_pipeIn_end) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,26})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEX_pipeOut(final medium=medium, final T_fluidOutConst=T_pipeOut_end) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-28})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p_gas, storage.p_gas) annotation (Line(points={{-50,0},{-5,0}}, color={0,0,127}));
  connect(gasPortIn, hEX_pipeIn.gasPortIn) annotation (Line(
      points={{0,49},{0,36}},
      color={255,255,0},
      thickness=1.5));
  connect(storage.gasPortIn, hEX_pipeIn.gasPortOut) annotation (Line(
      points={{0,4.9},{0,16}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperatureIn.port, hEX_pipeIn.heat) annotation (Line(points={{24,26},{10,26}}, color={191,0,0}));
  connect(hEX_pipeOut.gasPortIn, storage.gasPortOut) annotation (Line(
      points={{0,-18},{0,-6.3}},
      color={255,255,0},
      thickness=1.5));
  connect(hEX_pipeOut.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-38},{0,-53}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperatureOut.port, hEX_pipeOut.heat) annotation (Line(points={{24,-28},{18,-28},{18,-28},{10,-28}}, color={191,0,0}));
  annotation (
    Dialog(group="Numerical Efficiency"),
    choices(
      choice=1 "Inner location of states",
      choice=2 "Central location of states",
      choice=3 "Outer location of states"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L2"), Text(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          origin={74,0},
          rotation=-90,
          textString="idealHT
InPipes")},                  coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an underground compressed gas storage<b><span style=\"color: #008000;\"> </span></b>with pipes with ideal heat transfer.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and good heat transfer in the pipes.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: Real gas output</p>
<p>gasPortOut: Real gas input</p>
<p>p_storage: signal output of the gas pressure</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Sep 2019</p>
</html>"));
end UndergroundGasStorageIdealHTInPipes_L2;
