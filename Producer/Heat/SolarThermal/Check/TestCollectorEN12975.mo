within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorEN12975
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))
                                       annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    variable_p=false,
    variable_T=false,
    variable_xi=false,
    p_const=100000,
    showData=false,
    T_const=315) annotation (Placement(transformation(extent={{66,4},{46,24}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    m_flow_const=0.003,
    T_const=simCenter.T_amb_const,
    variable_T=true)    annotation (Placement(transformation(extent={{-66,4},{-46,24}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_in(unitOption=2)
                                               annotation (Placement(transformation(extent={{-36,14},{-16,34}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_out(unitOption=2)
                                                annotation (Placement(transformation(extent={{16,14},{36,34}})));

  SolarCollector_L1 solarCollector(
    area=2.33,
    eta_0=0.793,
    a1=4.04,
    a2=0.0182,
    c_eff=5000,
    redeclare model Skymodel = Base.Skymodel_isotropicDiffuse,
    G_min=150,
    useHomotopy=true,
    kind=1,
    slope=SI.Conversions.from_deg(40),
    constant_iam_diff=1,
    Q_flow_n=100e3,
    longitude_local=0.17453292519943,
    surfaceAzimuthAngle=0.17453292519943) annotation (Placement(transformation(extent={{-8,4},{12,24}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=simCenter.T_amb_var + 273.15) annotation (Placement(transformation(extent={{-94,4},{-74,24}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(source.steam_a, solarCollector.waterPortIn) annotation (Line(
      points={{-46,14},{-6,14}},
      color={0,131,169},
      thickness=0.5));
  connect(sink.steam_a, solarCollector.waterPortOut) annotation (Line(
      points={{46,14},{32,14},{10,14}},
      color={0,131,169},
      thickness=0.5));
  connect(T_in.port, solarCollector.waterPortIn) annotation (Line(
      points={{-26,14},{-26,14},{-6,14}},
      color={0,131,169},
      thickness=0.5));
  connect(T_out.port, solarCollector.waterPortOut) annotation (Line(
      points={{26,14},{26,14},{10,14}},
      color={0,131,169},
      thickness=0.5));
  connect(source.steam_a, T_in.port) annotation (Line(
      points={{-46,14},{-46,14},{-26,14}},
      color={0,131,169},
      thickness=0.5));
  connect(sink.steam_a, T_out.port) annotation (Line(
      points={{46,14},{40,14},{26,14}},
      color={0,131,169},
      thickness=0.5));
  connect(source.T, realExpression.y) annotation (Line(points={{-68,14},{-73,14}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test Modell for CollectorEN12975 Modell</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Max Mustermann (max.mustermann@mustermail.com) on Thu Apr 24 2014</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{120,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end TestCollectorEN12975;
