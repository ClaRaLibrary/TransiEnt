within TransiEnt.Consumer.Gas.Check;
model TestDynamicsGasAdaptiveControl
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter(
    p_amb=101343,
    T_amb=283.15,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_eff_1=2000,
    p_eff_2=1500000,
    p_eff_3=8000000,
    T_ground=273.15)                  annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP gasDemandHFlow(change_of_sign=false, constantfactor=2.710602*12.14348723*3.6e6/7) annotation (Placement(transformation(extent={{96,-4},{76,16}})));
  TransiEnt.Consumer.Gas.GasConsumer_HFlow sink(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=1e2,
    Ti=1) annotation (Placement(transformation(extent={{38,-4},{58,16}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTx source(
    medium=simCenter.gasModel1,
    p_const=simCenter.p_amb_const + simCenter.p_eff_2,
    variable_x=true) annotation (Placement(transformation(extent={{-58,-4},{-38,16}})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow(phi_H2max=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-4,6})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation(stepsize=0.1, period=300) annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
equation
  connect(source.gasPort, maxH2MassFlow.gasPortIn) annotation (Line(
      points={{-38,6},{-38,6},{-14,6}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.fluidPortIn, maxH2MassFlow.gasPortOut) annotation (Line(
      points={{38,6},{6,6}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.H_flow, gasDemandHFlow.y1) annotation (Line(points={{59,6},{75,6}}, color={0,0,127}));
  connect(composition_linearVariation.xi, source.x) annotation (Line(points={{-74,0},{-67,0},{-60,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=600,
      Interval=1,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(inputs=false, events=false));
end TestDynamicsGasAdaptiveControl;
