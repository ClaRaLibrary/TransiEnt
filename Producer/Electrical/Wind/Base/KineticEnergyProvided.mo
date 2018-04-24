within TransiEnt.Producer.Electrical.Wind.Base;
model KineticEnergyProvided
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Block;
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Real wind_param;

  Modelica.Blocks.Continuous.Integrator limIntegrator
    annotation (Placement(transformation(extent={{62,-10},{82,12}})));
  Modelica.Blocks.Interfaces.RealInput P_is annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-108,60})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-64,54},{-52,66}})));
  Modelica.Blocks.Sources.RealExpression P_noInertia(y=-wind_param*Rotor_cp*
        v_wind^3)
    annotation (Placement(transformation(extent={{-108,74},{-80,92}})));
  Modelica.Blocks.Interfaces.RealInput activate annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=180,
        origin={104,60})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{82,70},{62,90}})));
Modelica.Blocks.Logical.Switch measure_E_kin
    annotation (Placement(transformation(extent={{-22,42},{-2,62}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-74,16},{-54,36}})));
  Modelica.Blocks.Interfaces.RealInput v_wind annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=180,
        origin={104,-60})));
  Modelica.Blocks.Interfaces.RealInput Rotor_cp annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-108,-60})));
  Modelica.Blocks.Interfaces.RealOutput E_kin_Inertia annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={108,0})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(greaterThreshold.u, activate)
    annotation (Line(points={{84,80},{94,80},{94,60},{104,60}},
                                                color={0,0,127}));
  connect(P_noInertia.y, multiSum.u[1]) annotation (Line(points={{-78.6,83},{
          -74,83},{-74,62.1},{-64,62.1}}, color={0,0,127}));
  connect(P_is, multiSum.u[2])
    annotation (Line(points={{-108,60},{-64,60},{-64,57.9}}, color={0,0,127}));
  connect(multiSum.y, measure_E_kin.u1)
    annotation (Line(points={{-50.98,60},{-24,60}}, color={0,0,127}));
  connect(const.y, measure_E_kin.u3) annotation (Line(points={{-53,26},{-42,26},
          {-42,44},{-24,44}}, color={0,0,127}));
  connect(greaterThreshold.y, measure_E_kin.u2) annotation (Line(points={{61,80},
          {-36,80},{-36,52},{-24,52}}, color={255,0,255}));
  connect(measure_E_kin.y, limIntegrator.u) annotation (Line(points={{-1,52},{
          10,52},{10,50},{38,50},{38,1},{60,1}}, color={0,0,127}));
  connect(limIntegrator.y, E_kin_Inertia)
    annotation (Line(points={{83,1},{108,1},{108,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end KineticEnergyProvided;
