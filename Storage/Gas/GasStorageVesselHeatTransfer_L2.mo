within TransiEnt.Storage.Gas;
model GasStorageVesselHeatTransfer_L2 "Gas storage vessel including heat transfer to the environment"

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

  import SI = Modelica.SIunits;
  import Modelica.Constants.pi;

  extends TransiEnt.Basics.Icons.StorageGenericGas;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  parameter Boolean includeWall=true "false for neglecting the wall for heat transfer" annotation(Dialog(group="Heat Transfer"));

  parameter SI.Thickness thickness_wall=0.05 "Wall thickness"                         annotation(Dialog(group="Geometry", enable=includeWall));
  parameter SI.Temperature T_wall_start=283.15 "Start values of wall temperature" annotation(Dialog(group="Initialization", enable=includeWall));
  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  parameter SI.CoefficientOfHeatTransfer alpha_nom_outer = 3 "Constant heat transfer coefficient"               annotation(Dialog(group="Heat Transfer"));
  parameter Integer initOption=0 "Type of initialization" annotation (Dialog(group="Initialization"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));

  parameter String suppressChattering="True" "Enable to suppress possible chattering in wall" annotation (Dialog(group="Numerical Efficiency"), choices(choice="False" "False (faster if no chattering occurs)",
                                                                                            choice="True" "True (faster if chattering occurs)"));

  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  SI.Temperature T_surrounding=simCenter.T_amb_const "Temperature of the surroundings" annotation(Dialog(group="Heat Transfer"));

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeHeat heat;
    TransiEnt.Basics.Records.CostsStorage costs;
  end Summary;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  replaceable model MaterialWall =
    TILMedia.SolidTypes.TILMedia_Steel
    constrainedby TILMedia.SolidTypes.BaseSolid "Material surrounding the storage" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions", enable=includeWall));

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-10,39},{10,59}}), iconTransformation(extent={{-10,39},{10,59}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,-63},{10,-43}}), iconTransformation(extent={{-10,-73},{10,-53}})));
  TransiEnt.Basics.Interfaces.General.PressureOut p_gas annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0}), iconTransformation(extent={{-40,-10},{-60,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  replaceable TransiEnt.Storage.Gas.GasStorage_constXi_L2 storage(calculateCost=calculateCost)
                                                                  constrainedby TransiEnt.Storage.Gas.Base.PartialGasStorage_L2(medium=medium, final includeHeatTransfer=true) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,0})));
protected
  TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2 heatTransferOuter(alpha_nom=alpha_nom_outer, A_heat=pi*cylindricalWall.diameter_o*cylindricalWall.length+pi/2*cylindricalWall.diameter_o^2)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-56,0})));
  Modelica.Blocks.Sources.RealExpression T_amb(y=T_surrounding)       annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 cylindricalWall(
    redeclare model Material = MaterialWall,
    T_start(displayUnit="degC") = T_wall_start*ones(cylindricalWall.N_ax),
    stateLocation=stateLocation,
    N_ax=1,
    diameter_o=storage.diameter + thickness_wall,
    diameter_i=storage.diameter,
    length=storage.height,
    initOption=initOption,
    suppressChattering=suppressChattering) annotation (Placement(transformation(
        extent={{-15,5},{15,-5}},
        rotation=270,
        origin={-32,-18})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 topBottomWall(
    thickness_wall=thickness_wall,
    length=storage.diameter,
    redeclare model Material = MaterialWall,
    width=pi/2*storage.diameter,
    T_start=T_wall_start*ones(cylindricalWall.N_ax),
    N_ax=1,
    initOption=initOption,
    stateLocation=stateLocation) annotation (Placement(transformation(extent={{-22,-26},{-2,-36}})));

public
  inner Summary summary(
    gasPortIn(
      mediumModel=medium,
      xi=storage.summary.gasPortIn.xi,
      x=storage.summary.gasPortIn.x,
      m_flow=storage.summary.gasPortIn.m_flow,
      T=storage.summary.gasPortIn.T,
      p=storage.summary.gasPortIn.p,
      h=storage.summary.gasPortIn.h,
      rho=storage.summary.gasPortIn.rho),
    gasPortOut(
      mediumModel=medium,
      xi=storage.summary.gasPortOut.xi,
      x=storage.summary.gasPortOut.x,
      m_flow=storage.summary.gasPortOut.m_flow,
      T=storage.summary.gasPortOut.T,
      p=storage.summary.gasPortOut.p,
      h=storage.summary.gasPortOut.h,
      rho=storage.summary.gasPortOut.rho),
    gasBulk(
      mediumModel=medium,
      xi=storage.summary.gasBulk.xi,
      x=storage.summary.gasBulk.x,
      mass=storage.summary.gasBulk.mass,
      T=storage.summary.gasBulk.T,
      p=storage.summary.gasBulk.p,
      h=storage.summary.gasBulk.h,
      rho=storage.summary.gasBulk.rho),
    heat(
      Q_flow=-heatTransferOuter.heat.Q_flow,
      T=heatTransferOuter.heat.T),
    costs(
      costs=storage.summary.costs.costs,
      investCosts=storage.summary.costs.investCosts,
      investCostsStartGas=storage.summary.costs.investCostsStartGas,
      demandCosts=storage.summary.costs.demandCosts,
      oMCosts=storage.summary.costs.oMCosts,
      otherCosts=storage.summary.costs.otherCosts,
      revenues=storage.summary.costs.revenues)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  if includeWall then
    connect(topBottomWall.innerPhase[1], storage.heat) annotation (Line(
        points={{-12,-26},{-12,0},{-4,0}},
        color={167,25,48},
        thickness=0.5));
    connect(cylindricalWall.innerPhase[1], storage.heat) annotation (Line(
        points={{-27,-18},{-12,-18},{-12,0},{-4,0}},
        color={167,25,48},
        thickness=0.5));
    connect(topBottomWall.outerPhase[1], heatTransferOuter.heat) annotation (Line(
        points={{-12,-36},{-12,-42},{-46,-42},{-46,0}},
        color={167,25,48},
        thickness=0.5));
    connect(cylindricalWall.outerPhase[1], heatTransferOuter.heat) annotation (Line(
        points={{-37,-18},{-46,-18},{-46,-1.33227e-15}},
        color={167,25,48},
        thickness=0.5));
  else
    connect(storage.heat, heatTransferOuter.heat) annotation (Line(
        points={{-4,0},{-46,0},{-46,-1.33227e-015}},
        color={167,25,48},
        thickness=0.5));
  end if;
  connect(gasPortIn, storage.gasPortIn) annotation (Line(
      points={{0,49},{0,49},{0,4.9}},
      color={255,255,0},
      thickness=0.75));
  connect(storage.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-6.3},{0,-53}},
      color={255,255,0},
      thickness=0.5));
  connect(storage.p_gas, p_gas) annotation (Line(points={{5,0},{100,0}}, color={0,0,127}));
  connect(T_amb.y, heatTransferOuter.T_outer) annotation (Line(points={{-79,0},{-66,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an gas storage vessel for real gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model uses the models GasStorage_constXi_L2 or GasStorage_varXi_L2 and can be used for real gases with constant or variable compositions. A heat transfer to the ambient is considered using a wall model (ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 from ClaRa, it can be neglected if wished so) and an outer heat transfer model.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient inside and outside of the storage (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: Real gas output</p>
<p>gasPortOut: Real gas input</p>
<p>p_gas: signal output of the gas pressure</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Oct 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (changes due to ClaRa changes: exchanged wall model, added wall model for top and bottom)</p>
</html>"),
Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),             Icon(graphics={Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L2")},                                                                           coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end GasStorageVesselHeatTransfer_L2;
