within TransiEnt.Storage.Gas;
model UndergroundGasStoragePressureLoss_L2 "Model of a simple gas storage volume for constant composition with adiabatic inlet and outlet pipes with pressure losses"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  import SI = Modelica.SIunits;

  extends TransiEnt.Basics.Icons.StorageGenericGasPressureLoss;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  //parameter SI.Area A_heat=storage.A_heat "Inner heat transfer area of the storage" annotation(Dialog(group="Heat Transfer"));

  /*parameter SI.Pressure p_nom= 50e5 "|Nominal Values|Nominal pressure";
  parameter SI.SpecificEnthalpy h_nom= 1e5 "|Nominal Values|Nominal specific enthalpy for single tube";
  parameter SI.MassFlowRate m_flow_nom=1 "|Nominal Values|Nominal mass flow w.r.t. all parallel tubes";
  parameter SI.PressureDifference Delta_p_nom=1e5 "|Nominal Values|Nominal pressure loss w.r.t. all parallel tubes";
  parameter SI.MassFraction xi_nom[medium.nc-1]=medium.xi_default "|Nominal Values|Nominal composition";

  parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "|Initialization|Type of initialisation " annotation(choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialization||True, if homotopy method is used during initialisation";
  parameter SI.SpecificEnthalpy h_pipe_start=800e3 "|Initialization|Initial specific enthalpy for single pipe";
  parameter SI.Pressure p_pipe_start=50e5 "|Initialization|Initial pressure";

  parameter SI.Length length_pipe= 1000 "|Geometry|Length of the pipe";
  parameter SI.Diameter diameter_pipe_i= 0.3 "|Geometry|Inner diameter of the pipe";
  parameter Integer N_pipes= 1 "|Geometry|Number of parallel pipes";*/

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  /*replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "|Fundamental Definitions|Pressure loss within the inlet and outlet tubes"
    annotation(choicesAllMatching);*/

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-10,39},{10,59}}), iconTransformation(extent={{-10,39},{10,59}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,-63},{10,-43}}), iconTransformation(extent={{-10,-73},{10,-53}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatPort_a heatStorage annotation (Placement(transformation(extent={{30,-18},{50,2}}), iconTransformation(extent={{30,-18},{50,2}})));
  Modelica.Blocks.Interfaces.RealOutput p_gas(final quantity="Pressure", final unit = "Pa", displayUnit="bar") annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  replaceable TransiEnt.Storage.Gas.GasStorage_constXi_L2 storage constrainedby TransiEnt.Storage.Gas.Base.PartialGasStorage_L2(medium=medium) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{-10,-10},{10,10}})));
public
  replaceable TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipeIn(
    medium=medium,
    frictionAtInlet=true,
    frictionAtOutlet=false,
    N_cv=1,
    length=1000,
    diameter_i=0.3,
    z_in=-1000,
    z_out=0,
    N_tubes=1) annotation (
    Dialog(group="Fundamental Definitions"),
    choices(choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi "Constant composition", choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi "Variable composition"),
    Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=270,
        origin={18,23})));
public
  replaceable TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipeOut(
    medium=medium,
    frictionAtInlet=true,
    frictionAtOutlet=false,
    length=1000,
    diameter_i=0.3,
    N_tubes=1,
    N_cv=1,
    z_in=-1000,
    z_out=0) annotation (
    Dialog(group="Fundamental Definitions"),
    choices(choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi "Constant composition", choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi "Variable composition"),
    Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={18,-25})));
public
  inner Summary summary(
    gasPortIn(
      mediumModel=medium,
      xi=pipeIn.summary.gasPortIn.xi,
      x=pipeIn.summary.gasPortIn.x,
      m_flow=pipeIn.summary.gasPortIn.m_flow,
      T=pipeIn.summary.gasPortIn.T,
      p=pipeIn.summary.gasPortIn.p,
      h=pipeIn.summary.gasPortIn.h,
      rho=pipeIn.summary.gasPortIn.rho),
    gasPortIntoStorage(
      mediumModel=medium,
      xi=storage.summary.gasPortIn.xi,
      x=storage.summary.gasPortIn.x,
      m_flow=storage.summary.gasPortIn.m_flow,
      T=storage.summary.gasPortIn.T,
      p=storage.summary.gasPortIn.p,
      h=storage.summary.gasPortIn.h,
      rho=storage.summary.gasPortIn.rho),
    gasBulk(
      mediumModel=medium,
      xi=storage.summary.gasBulk.xi,
      x=storage.summary.gasBulk.x,
      mass=storage.summary.gasBulk.mass,
      T=storage.summary.gasBulk.T,
      p=storage.summary.gasBulk.p,
      h=storage.summary.gasBulk.h,
      rho=storage.summary.gasBulk.rho),
    gasPortOutOfStorage(
      mediumModel=medium,
      xi=storage.summary.gasPortOut.xi,
      x=storage.summary.gasPortOut.x,
      m_flow=storage.summary.gasPortOut.m_flow,
      T=storage.summary.gasPortOut.T,
      p=storage.summary.gasPortOut.p,
      h=storage.summary.gasPortOut.h,
      rho=storage.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=medium,
      xi=pipeOut.summary.gasPortOut.xi,
      x=pipeOut.summary.gasPortOut.x,
      m_flow=pipeOut.summary.gasPortOut.m_flow,
      T=pipeOut.summary.gasPortOut.T,
      p=pipeOut.summary.gasPortOut.p,
      h=pipeOut.summary.gasPortOut.h,
      rho=pipeOut.summary.gasPortOut.rho),
    heat(
      Q_flow=storage.heat.Q_flow,
      T=storage.heat.T),
    costs(
      costs=storage.summary.costs.costs,
      investCosts=storage.summary.costs.investCosts,
      investCostsStartGas=storage.summary.costs.investCostsStartGas,
      demandCosts=storage.summary.costs.demandCosts,
      oMCosts=storage.summary.costs.oMCosts,
      otherCosts=storage.summary.costs.otherCosts,
      revenues=storage.summary.costs.revenues)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIntoStorage;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutOfStorage;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeHeat heat;
    TransiEnt.Basics.Records.CostsStorage costs;
  end Summary;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Thermal.HeatPort_a heatPipeIn[pipeIn.N_cv] annotation (Placement(transformation(extent={{30,24},{50,44}}), iconTransformation(extent={{30,24},{50,44}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatPort_a heatPipeOut[pipeOut.N_cv] annotation (Placement(transformation(extent={{30,-58},{50,-38}}), iconTransformation(extent={{30,-58},{50,-38}})));
equation
  connect(p_gas, storage.p_gas) annotation (Line(points={{-50,0},{-5,0}}, color={0,0,127}));
  connect(storage.heat, heatStorage) annotation (Line(points={{4,0},{30,0},{30,-8},{40,-8}}, color={191,0,0}));
  connect(pipeOut.gasPortIn, storage.gasPortOut) annotation (Line(
      points={{18,-11},{18,-8},{0,-8},{0,-6.3}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeOut.gasPortOut, gasPortOut) annotation (Line(
      points={{18,-39},{18,-46},{0,-46},{0,-53}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeIn.gasPortOut, gasPortIn) annotation (Line(
      points={{18,37},{18,44},{0,44},{0,49}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeIn.gasPortIn, storage.gasPortIn) annotation (Line(
      points={{18,9},{18,6},{0,6},{0,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(heatPipeIn, heatPipeIn) annotation (Line(points={{40,34},{44,34},{44,30},{44,34},{40,34}}, color={191,0,0}));
  connect(pipeOut.heat, heatPipeOut) annotation (Line(points={{22,-25},{40,-25},{40,-48}}, color={191,0,0}));
  connect(pipeIn.heat, heatPipeIn) annotation (Line(points={{22,23},{40,23},{40,34}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents an underground compressed gas storage without detailed heat transfer but with heat ports for the heat flows out of/into the pipes/storage.</p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model uses the models GasStorage_constXi_L2 or GasStorage_varXi_L2 and can be used for real gases with constant or variable compositions. The pipes through which the gas is flowing into/out of the storage are modeled using the pipe models PipeFlow_L4_Simple_constXi or PipeFlow_L4_Simple_varXi. </p>
<h4><span style=\"color:#008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models. There are errors at flow reversal (discharge to charge or vice versa) because here two pipes are used where usually only one pipe is used in reality.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: Real gas output</p>
<p>gasPortOut: Real gas input</p>
<p>heat: heat port for the heat flow into/out of the storage</p>
<p>p_storage: signal output of the gas pressure</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>Model taken from Tietze and Stolten [1].</p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>[1] Tietze, Vanessa, and Detlef Stolten. Comparison of hydrogen and methane storage by means of a thermodynamic analysis. International Journal of Hydrogen Energy 40.35 (2015): 11530-11537.</p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Oct 2016<br></p>
</html>"));
end UndergroundGasStoragePressureLoss_L2;