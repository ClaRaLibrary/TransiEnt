within TransiEnt.Storage.Gas;
model UndergroundGasStorageHeatTransfer_L2 "Model of a simple gas storage volume for constant composition with heat transfer to the cavern walls"

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

  extends TransiEnt.Basics.Icons.StorageGenericGas;

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

  parameter SI.Thickness thickness_material=2 "Thickness of the surrounding material which takes part in the heat transfer"
                                                                                                    annotation(Dialog(group="Heat Transfer"));
  parameter SI.Mass mass=thinWall_L2.solid.d*A_heat*thickness_material "Mass of the surrounding material which takes part in the heat transfer" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_material=317.15 "Temperature of the surrounding" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_material_start=317.15 "Initial temperature of the material" annotation(Dialog(group="Initialization"));
  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
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
  replaceable TransiEnt.Storage.Gas.GasStorage_constXi_L2 storage constrainedby TransiEnt.Storage.Gas.Base.PartialGasStorage_L2(medium=medium) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=T_material)
                                                                                    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L2 thinWall_L2(
    redeclare model Material = TransiEnt.Basics.Media.Solids.Salt,
    A_heat=A_heat,
    thickness_wall=thickness_material,
    mass=mass,
    T_start(displayUnit="degC") = T_material_start,
    stateLocation=stateLocation) annotation (Placement(transformation(
        extent={{-10,5},{10,-5}},
        rotation=90,
        origin={30,1})));

public
  inner Summary summary(
    gasPortIn(
      mediumModel=storage.summary.gasPortIn.mediumModel,
      xi=storage.summary.gasPortIn.xi,
      x=storage.summary.gasPortIn.x,
      m_flow=storage.summary.gasPortIn.m_flow,
      T=storage.summary.gasPortIn.T,
      p=storage.summary.gasPortIn.p,
      h=storage.summary.gasPortIn.h,
      rho=storage.summary.gasPortIn.rho),
    gasPortOut(
      mediumModel=storage.summary.gasPortOut.mediumModel,
      xi=storage.summary.gasPortOut.xi,
      x=storage.summary.gasPortOut.x,
      m_flow=storage.summary.gasPortOut.m_flow,
      T=storage.summary.gasPortOut.T,
      p=storage.summary.gasPortOut.p,
      h=storage.summary.gasPortOut.h,
      rho=storage.summary.gasPortOut.rho),
    gasBulk(
      mediumModel=storage.summary.gasBulk.mediumModel,
      xi=storage.summary.gasBulk.xi,
      x=storage.summary.gasBulk.x,
      mass=storage.summary.gasBulk.mass,
      T=storage.summary.gasBulk.T,
      p=storage.summary.gasBulk.p,
      h=storage.summary.gasBulk.h,
      rho=storage.summary.gasBulk.rho),
    heatStorage(
      Q_flow=storage.heat.Q_flow,
      T=storage.heat.T),
    heatMaterial(
      Q_flow=thinWall_L2.outerPhase.Q_flow,
      T=thinWall_L2.outerPhase.T),
    costs(
      costs=storage.summary.costs.costs,
      investCosts=storage.summary.costs.investCosts,
      investCostsStartGas=storage.summary.costs.investCostsStartGas,
      demandCosts=storage.summary.costs.demandCosts,
      oMCosts=storage.summary.costs.oMCosts,
      otherCosts=storage.summary.costs.otherCosts,
      revenues=storage.summary.costs.revenues)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeHeat heatStorage;
    TransiEnt.Basics.Records.FlangeHeat heatMaterial;
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

  connect(p_gas, storage.p_gas) annotation (Line(points={{-50,0},{-5,0}}, color={0,0,127}));
  connect(thinWall_L2.outerPhase, fixedTemperature.port) annotation (Line(
      points={{35,1},{34.5,1},{34.5,0},{50,0}},
      color={167,25,48},
      thickness=0.5));
  connect(storage.heat, thinWall_L2.innerPhase) annotation (Line(points={{4,0},{24,0},{24,1},{25,1}}, color={191,0,0}));
  connect(gasPortIn, storage.gasPortIn) annotation (Line(
      points={{0,49},{0,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(storage.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-6.3},{0,-53}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an underground compressed gas storage without pressure losses.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model uses the models GasStorage_constXi_L2 or GasStorage_varXi_L2 and can be used for real gases with constant or variable compositions. A heat transfer to the surrounding material, e.g. salt, is considered with a replaceable heat transfer model. The heat conductance within that material is assumed to happen only within a specific thickness measured from the surface of the gas storage. The heat conductance is modeled using a thin wall model, see model ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L2 and outside of that thickness, the temperature is assumed to be constant, see Tietze and Stolten [1].</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models.</p>
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
<p>Heat transfer model taken from Tietze and Stolten [1].</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Tietze, Vanessa, and Detlef Stolten. Comparison of hydrogen and methane storage by means of a thermodynamic analysis. International Journal of Hydrogen Energy 40.35 (2015): 11530-11537.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Oct 2016</p>
<p><br>Revised by Lisa Andresen (andresen@tuhh.de) Dec 2016</p>
</html>"));
end UndergroundGasStorageHeatTransfer_L2;
