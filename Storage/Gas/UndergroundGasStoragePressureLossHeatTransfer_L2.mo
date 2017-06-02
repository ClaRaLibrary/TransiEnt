within TransiEnt.Storage.Gas;
model UndergroundGasStoragePressureLossHeatTransfer_L2 "Model of a simple gas storage volume for constant composition with adiabatic inlet and outlet pipes with pressure losses and heat transfer to the cavern walls"

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

  parameter SI.Area A_heat=storage.A_heat "Inner heat transfer area" annotation(Dialog(group="Heat Transfer"));

  /*parameter SI.Pressure p_nom= 50e5 "|Nominal Values|Nominal pressure";
  parameter SI.SpecificEnthalpy h_nom= 1e5 "|Nominal Values|Nominal specific enthalpy for single tube";
  parameter SI.MassFlowRate m_flow_nom=1 "|Nominal Values|Nominal mass flow w.r.t. all parallel tubes";
  parameter SI.PressureDifference Delta_p_nom=1e5 "|Nominal Values|Nominal pressure loss w.r.t. all parallel tubes";
  parameter SI.MassFraction xi_nom[medium.nc-1]=medium.xi_default "|Nominal Values|Nominal composition";

  parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "|Initialization|Type of initialisation " annotation(choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialization|True, if homotopy method is used during initialisation";
  parameter SI.SpecificEnthalpy h_pipe_start=800e3 "|Initialization|Initial specific enthalpy for single pipe";
  parameter SI.Pressure p_pipe_start=50e5 "|Initialization|Initial pressure";

  parameter SI.Length length_pipe= 1000 "|Geometry|Length of the pipe";
  parameter SI.Diameter diameter_pipe_i= 0.3 "|Geometry|Inner diameter of the pipe";
  parameter Integer N_pipes= 1 "|Geometry|Number of parallel pipes";*/

  parameter SI.Thickness thickness_material=2 "Thickness of the surrounding material which takes part in the heat transfer"
                                                                                                    annotation(Dialog(group="Heat Transfer"));
  parameter SI.Mass mass=thinWall_L2.solid.d*A_heat*thickness_material "Mass of the surrounding material which takes part in the heat transfer" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_material=317.15 "Initial temperature of the material" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_material_start=317.15 "Initial temperature of the material" annotation(Dialog(group="Initialization"));
  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  /*replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss within the inlet and outlet tubes" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);*/
  replaceable model Material =
    TransiEnt.Basics.Media.Solids.Salt
    constrainedby TILMedia.SolidTypes.BaseSolid "Material surrounding the storage" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-10,39},{10,59}}), iconTransformation(extent={{-10,39},{10,59}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,-63},{10,-43}}), iconTransformation(extent={{-10,-73},{10,-53}})));
  Modelica.Blocks.Interfaces.RealOutput p_gas(final quantity="Pressure", final unit = "Pa", displayUnit="bar") annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
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
    N_cv=1,
    length=1000,
    diameter_i=0.3,
    z_in=-1000,
    z_out=0,
    N_tubes=1) annotation (
    Dialog(group="Fundamental Definitions"),
    choices(choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi "Constant composition", choice=TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi "Variable composition"),
    Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={18,-25})));

protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureOut[pipeOut.N_cv](each T=simCenter.T_ground)
                                                                                       annotation (Placement(transformation(extent={{74,-41},{54,-21}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureIn[pipeIn.N_cv](each T=T_material) annotation (Placement(transformation(extent={{74,21},{54,41}})));
public
  replaceable TransiEnt.Storage.Gas.GasStorage_constXi_L2 storage constrainedby TransiEnt.Storage.Gas.Base.PartialGasStorage_L2(medium=medium) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=T_material)
                                                                                    annotation (Placement(transformation(extent={{74,-10},{54,10}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L2 thinWall_L2(
    A_heat=A_heat,
    thickness_wall=thickness_material,
    mass=mass,
    T_start(displayUnit="degC") = T_material_start,
    stateLocation=stateLocation,
    redeclare model Material = Material)
                                 annotation (Placement(transformation(
        extent={{-10,5},{10,-5}},
        rotation=90,
        origin={34,1})));

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
    heatStorage(
      Q_flow=storage.heat.Q_flow,
      T=storage.heat.T),
    heatMaterial(
      Q_flow=thinWall_L2.outerPhase.Q_flow,
      T=thinWall_L2.outerPhase.T),
    heatPipeIn(
      N_cv=1,
      Q_flow=pipeIn.heat.Q_flow,
      T=pipeIn.heat.T),
    heatPipeOut(
      N_cv=1,
      Q_flow=pipeOut.heat.Q_flow,
      T=pipeOut.heat.T),
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
    TransiEnt.Basics.Records.FlangeHeat heatStorage;
    TransiEnt.Basics.Records.FlangeHeat heatMaterial;
    TransiEnt.Basics.Records.FlangeHeat_L4 heatPipeIn;
    TransiEnt.Basics.Records.FlangeHeat_L4 heatPipeOut;
    TransiEnt.Basics.Records.CostsStorage costs;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(pipeIn.gasPortOut, gasPortIn) annotation (Line(
      points={{18,37},{18,44},{0,44},{0,49}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeOut.gasPortOut, gasPortOut) annotation (Line(
      points={{18,-39},{18,-46},{0,-46},{0,-53}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeOut.heat, fixedTemperatureOut.port) annotation (Line(
      points={{22,-25},{22,-24},{26,-24},{40,-24},{40,-31},{54,-31}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeIn.heat, fixedTemperatureIn.port) annotation (Line(
      points={{22,23},{22,24},{40,24},{40,26},{40,31},{54,31}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall_L2.outerPhase,fixedTemperature. port) annotation (Line(
      points={{39,1},{38.5,1},{38.5,0},{54,0}},
      color={167,25,48},
      thickness=0.5));
  connect(storage.heat, thinWall_L2.innerPhase) annotation (Line(points={{4,0},{28,0},{28,1},{29,1}}, color={191,0,0}));
  connect(pipeIn.gasPortIn, storage.gasPortIn) annotation (Line(
      points={{18,9},{18,6},{0,6},{0,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(pipeOut.gasPortIn, storage.gasPortOut) annotation (Line(
      points={{18,-11},{18,-8},{0,-8},{0,-6.3}},
      color={255,255,0},
      thickness=1.5));
  connect(p_gas, storage.p_gas) annotation (Line(points={{-50,0},{-5,0}},        color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents an underground compressed gas storage.</p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model combines the models UndergroundGasStorageHeatTransfer_L2 and UndergroundGasStoragePressureLoss_L2. So it considers pressure losses in the pipes and heat transfer to the storage walls. The documentation is given in those two models.</p>
<p>For the heat transfer the following constant ground temperatures are assumed: For the storage and the incoming pipe T_material, and for the outcoming pipe simCenter.T_ground.</p>
<h4><span style=\"color:#008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: Real gas output</p>
<p>gasPortOut: Real gas input</p>
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
end UndergroundGasStoragePressureLossHeatTransfer_L2;
