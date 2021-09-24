within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorFieldEN12975 "Tester for a solar collector field using fluid boundaries and controller"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends TransiEnt.Basics.Icons.Checkmodel;
  import Const = Modelica.Constants;
  import      Modelica.Units.SI;

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
                                       annotation (Placement(transformation(extent={{-86,78},{-66,98}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    variable_p=false,
    variable_T=false,
    variable_xi=false,
    p_const=100000,
    showData=false,
    T_const=315)    annotation (Placement(transformation(extent={{96,-32},{76,-12}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    T_const=293.15,
    m_flow_const=0.5,
    variable_T=true)                                                                               annotation (Placement(transformation(extent={{-64,-32},{-44,-12}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_in(unitOption=2)
                                               annotation (Placement(transformation(extent={{-38,-4},{-18,16}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_out(unitOption=2)
                                                annotation (Placement(transformation(extent={{54,-2},{74,18}})));
  SolarCollectorField_L1 solarCollectorField(
    useHomotopy=true,
    area=2.33,
    eta_0=0.793,
    a1=3.95,
    a2=0.0122,
    c_eff=6400,
    a=128,
    b=8329,
    redeclare model Skymodel = Base.Skymodel_isotropicDiffuse,
    kind=1,
    constant_iam_dir=1,
    constant_iam_diff=1,
    constant_iam_ground=1,
    n_serial=5,
    n_parallel=7) annotation (Placement(transformation(extent={{-12,-35},{54,-9}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-86,58},{-66,78}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=20 + 273.15)                  annotation (Placement(transformation(extent={{-92,-32},{-72,-12}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(solarCollectorField.waterOut, sink.steam_a) annotation (Line(
      points={{53.1316,-22},{53.1316,-22},{76,-22}},
      color={175,0,0},
      thickness=0.5));
  connect(solarCollectorField.waterIn, source.steam_a) annotation (Line(
      points={{-11.1316,-22},{-11.1316,-22},{-44,-22}},
      color={175,0,0},
      thickness=0.5));
  connect(sink.steam_a, T_out.port) annotation (Line(
      points={{76,-22},{64,-22},{64,-2}},
      color={0,131,169},
      thickness=0.5));
  connect(source.steam_a, T_in.port) annotation (Line(
      points={{-44,-22},{-28,-22},{-28,-4}},
      color={0,131,169},
      thickness=0.5));
  connect(source.T, realExpression.y) annotation (Line(points={{-66,-22},{-71,-22}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for CollectorFieldEN12975</p>
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
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Note that the inlet temperature should never fall below 0 &deg;C. A possible controller for this case can be looked at under TransiEnt.Producer.Heat.SolarThermal.Controller.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Apr 2014</p>
</html>"), Diagram(graphics={Text(
          extent={{102,80},{-46,88}},
          textColor={28,108,200},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- solarCollectorField.T_out")},
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput);
end TestCollectorFieldEN12975;
