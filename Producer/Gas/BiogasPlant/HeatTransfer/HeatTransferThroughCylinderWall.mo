within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer;
model HeatTransferThroughCylinderWall "heat model for stirred tank reactor"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  import Modelica.Constants.pi;
  extends TransiEnt.Basics.Icons.HeatFlowModel;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Diameter D_i=geometryCSTR.D_i "Inner Diameter of CSTR";
  final parameter Modelica.SIunits.Diameter D_o=geometryCSTR.D_o "Outer Diameter of CSTR";
  final parameter Modelica.SIunits.Height height_fluid=geometryCSTR.Height_fluid "Height of fluid in CSTR";
  final parameter Modelica.SIunits.Height height_cylinder=geometryCSTR.Height_tankWall "Height of tank wall";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Thickness thickness_topCover "Thickness of the top cover";
  replaceable parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var medium "Medium to be used";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer replaceable MaterialValues.SuspensionProperties_pT fluidProperties;
  outer Base.GeometryCSTR geometryCSTR;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_loss "Entire heat flow loss to the environment";
  input Modelica.SIunits.ReynoldsNumber Re "Reynolds number" annotation (Dialog(group="Variables"));
  input Modelica.SIunits.MassFraction xi[medium.nc - 1] "Mass fraction of the medium" annotation (Dialog(group="Variables"));
  input Real C1 "Geometrical Coefficient in Nusselt-Equation" annotation (Dialog(group="Variables"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput InsideTemperature(unit="K") "Temperature inside the reactor" annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput AmbientTemperature(unit="K") "Ambient temperature" annotation (Placement(transformation(extent={{180,-20},{140,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature fluidTemperature annotation (Placement(transformation(extent={{-58,-62},{-38,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature airTemperature annotation (Placement(transformation(extent={{134,-7},{120,7}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wallInContactWithSludge(
    diameter_o=D_o,
    diameter_i=D_i,
    length=height_fluid,
    redeclare model Material = MaterialValues.Materials.SteelReinforcedConcrete,
    T_start={313.15},
    initOption=213) annotation (Placement(transformation(
        extent={{10,-7},{-10,7}},
        rotation=-90,
        origin={14,-52})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature gasTemperature annotation (Placement(transformation(extent={{-68,28},{-48,48}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 WallInContactWithGas(
    diameter_o=D_o,
    diameter_i=D_i,
    length=height_cylinder - height_fluid,
    redeclare model Material = MaterialValues.Materials.SteelReinforcedConcrete,
    T_start={313.15},
    initOption=213) annotation (Placement(transformation(
        extent={{9.99999,7.5},{-10,-7.5}},
        rotation=90,
        origin={16.5,20})));

  Modelica.Thermal.HeatTransfer.Components.ThermalCollector heatLossSidewall(final m=2) "Collects the thermal losses from sidewall  " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-28})));
  HeatTransfer.FreeConvection.FreeConvectionHeatTransfer_Gas_verticalCylinderBarrel HeatTransfer_wallToAir(
    d=D_o,
    Height=height_cylinder,
    redeclare TransiEnt.Basics.Media.Gases.Gas_Air medium,
    useMassFractionDefault=true) annotation (Placement(transformation(extent={{70,-40},{92,-17}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector totalHeatLoss(final m=2) "Collects the thermal losses from top and sidewall" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={106,0})));
  HeatTransfer.FreeConvection.FreeConvectionHeatTransfer_Gas_horizontalDisc HeatTransfer_TopCoverToAir(
    redeclare TransiEnt.Basics.Media.Gases.Gas_Air medium,
    topside=true,
    d=D_o,
    useMassFractionDefault=true) annotation (Placement(transformation(extent={{68,47},{90,69}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 TopCover(
    length=D_o,
    width=pi/4*D_o,
    N_ax=1,
    stateLocation=2,
    thickness_wall=thickness_topCover,
    redeclare model Material = MaterialValues.Materials.SteelReinforcedConcrete,
    T_start(displayUnit="degC") = {313.15},
    initOption=203) annotation (Placement(transformation(
        extent={{-10,5},{10,-5}},
        rotation=90,
        origin={16,58})));
  HeatTransfer.FreeConvection.FreeConvectionHeatTransfer_Gas_horizontalDisc HeatTransfer_gasToTopCover(
    redeclare TransiEnt.Basics.Media.Gases.Gas_Air medium,
    topside=true,
    d=D_o,
    useMassFractionDefault=true) annotation (Placement(transformation(extent={{4,47},{-18,69}})));
  HeatTransfer.FreeConvection.FreeConvectionHeatTransfer_Gas_verticalCylinderBarrel HeatTransfer_gasToWall(
    d=D_o,
    redeclare TransiEnt.Basics.Media.Gases.Gas_Air medium,
    useMassFractionDefault=true,
    Height=height_cylinder - height_fluid) annotation (Placement(transformation(extent={{6,8},{-18,32}})));
  HeatTransfer.ForcedConvection.HeatTransferInsideReactor heatTransferSludgeToWall(
    D=D_i,
    height=height_fluid,
    Re=Re,
    C1=C1) annotation (Placement(transformation(extent={{-28,-62},{-8,-42}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 HeatInsulationTopCover(
    N_ax=1,
    stateLocation=2,
    length=height_cylinder - height_fluid,
    width=pi*D_o,
    thickness_wall=0.1,
    T_start(displayUnit="degC") = {313.15},
    redeclare model Material = MaterialValues.Materials.InsulationOrstechLSP_H_50C,
    initOption=213) annotation (Placement(transformation(
        extent={{-10,5},{10,-5}},
        rotation=90,
        origin={54,58})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector heatLossGas(final m=2) "Collects the thermal losses from sidewall  " annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-34,38})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 HeatInsulationSideWall(
    redeclare model Material = MaterialValues.Materials.InsulationOrstechLSP_H_50C,
    diameter_o=D_o + 0.1,
    diameter_i=D_o,
    length=height_cylinder,
    T_start={313.15},
    initOption=213) annotation (Placement(transformation(
        extent={{8.99998,6.5},{-8.99998,-6.5}},
        rotation=90,
        origin={61.5,-29})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  Q_flow_loss = gasTemperature.port.Q_flow + fluidTemperature.port.Q_flow;

  connect(InsideTemperature, fluidTemperature.T) annotation (Line(points={{-100,0},{-74,0},{-74,-52},{-60,-52}}, color={0,0,127}));
  connect(AmbientTemperature, airTemperature.T) annotation (Line(points={{160,0},{135.4,0}}, color={0,0,127}));
  connect(InsideTemperature, gasTemperature.T) annotation (Line(points={{-100,0},{-74,0},{-74,38},{-70,38}}, color={0,0,127}));
  connect(totalHeatLoss.port_b, airTemperature.port) annotation (Line(points={{116,-6.66134e-16},{128,-6.66134e-16},{128,0},{120,0}}, color={191,0,0}));
  connect(HeatTransfer_gasToTopCover.heat_solid, TopCover.innerPhase[1]) annotation (Line(points={{1.8,58},{11,58}}, color={191,0,0}));
  connect(HeatTransfer_gasToWall.heat_solid, WallInContactWithGas.innerPhase) annotation (Line(points={{3.6,20},{5.95,20},{5.95,20.2},{9.3,20.2}}, color={191,0,0}));
  connect(heatTransferSludgeToWall.heat_fluid, fluidTemperature.port) annotation (Line(points={{-26.8,-52},{-38,-52}}, color={191,0,0}));
  connect(heatTransferSludgeToWall.heat_solid, wallInContactWithSludge.innerPhase) annotation (Line(points={{-10,-52},{4,-52},{4,-52.2},{7.28,-52.2}}, color={191,0,0}));
  connect(HeatTransfer_TopCoverToAir.heat_fluid, totalHeatLoss.port_a[1]) annotation (Line(points={{90,58},{90,0},{95.5,0}}, color={191,0,0}));
  connect(HeatTransfer_wallToAir.heat_fluid, totalHeatLoss.port_a[2]) annotation (Line(points={{92,-28.5},{92,4.44089e-16},{96.5,4.44089e-16}}, color={191,0,0}));
  connect(TopCover.outerPhase, HeatInsulationTopCover.innerPhase) annotation (Line(
      points={{21,58},{49,58}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatInsulationTopCover.outerPhase[1], HeatTransfer_TopCoverToAir.heat_solid) annotation (Line(
      points={{59,58},{70.2,58}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatTransfer_gasToTopCover.heat_fluid, heatLossGas.port_a[1]) annotation (Line(points={{-18,58},{-24,58},{-24,38},{-23.5,38}}, color={191,0,0}));
  connect(HeatTransfer_gasToWall.heat_fluid, heatLossGas.port_a[2]) annotation (Line(points={{-18,20},{-24,20},{-24,38},{-24.5,38}}, color={191,0,0}));
  connect(heatLossGas.port_b, gasTemperature.port) annotation (Line(points={{-44,38},{-48,38}}, color={191,0,0}));
  connect(WallInContactWithGas.outerPhase, heatLossSidewall.port_a[1]) annotation (Line(
      points={{24.1,20},{28,20},{28,-28},{29.5,-28}},
      color={167,25,48},
      thickness=0.5));
  connect(wallInContactWithSludge.outerPhase, heatLossSidewall.port_a[2]) annotation (Line(
      points={{21.0933,-52},{28,-52},{28,-28},{30.5,-28}},
      color={167,25,48},
      thickness=0.5));
  connect(heatLossSidewall.port_b, HeatInsulationSideWall.innerPhase) annotation (Line(points={{50,-28},{52,-28},{52,-28.82},{55.26,-28.82}}, color={191,0,0}));
  connect(HeatInsulationSideWall.outerPhase, HeatTransfer_wallToAir.heat_solid) annotation (Line(
      points={{68.0867,-29},{74,-29},{74,-28.5},{72.2,-28.5}},
      color={167,25,48},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{140,80}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{140,80}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model calculates the heat transfer through the cylinder wall of the tank reactor</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TemperatureInput<span style=\"font-family: Courier New; color: #ff0000;\"> </span>InsideTemperature(unit=&quot;K&quot;)&nbsp;&quot;Temperature&nbsp;inside&nbsp;the&nbsp;reactor&quot;</p>
<p>TemperatureInput &nbsp;AmbientTemperature(unit=&quot;K&quot;)&nbsp;&quot;Ambient&nbsp;temperature&quot;</p>
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
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end HeatTransferThroughCylinderWall;
