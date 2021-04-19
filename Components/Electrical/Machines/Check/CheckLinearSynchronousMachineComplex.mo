within TransiEnt.Components.Electrical.Machines.Check;
model CheckLinearSynchronousMachineComplex "Test for LinearSynchronousMachineComplex"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
//             Parameters
// _____________________________________________


final parameter Modelica.SIunits.ActivePower P_slack_start( fixed=false);

// _____________________________________________
//
//             Variable Declarations
// _____________________________________________




// _____________________________________________
//
//           Instances of other Classes
// _____________________________________________


  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{6,-72},{26,-52}})));
  inner TransiEnt.SimCenter simCenter(T_grid=11.1 + 2*4.93)
    annotation (Placement(transformation(extent={{36,-72},{56,-52}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load(
    useInputConnectorP=true,
    useCosPhi=false,
    f_n=50,
    v_n=110000,
    variability(kpf=40e6))
                annotation (Placement(transformation(extent={{14,50},{34,70}})));
  Modelica.Blocks.Sources.Step step_P(
    height=100e6,
    startTime=20,
    offset=550e6) annotation (Placement(transformation(extent={{66,66},{46,86}})));
  Modelica.Blocks.Continuous.FirstOrder actuator1(
    T=0.2,
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-36,132},{-16,152}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-134,138},{-114,158}})));
  Modelica.Blocks.Sources.RealExpression globalFrequency_reference(y=simCenter.f_n) annotation (Placement(transformation(extent={{-164,138},{-144,158}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary1 annotation (Placement(transformation(
        extent={{9,-9},{-9,9}},
        rotation=0,
        origin={67,103})));
  Modelica.Blocks.Continuous.FirstOrder turbine1(
    T=1.5,
    k=-480e6,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-6,132},{14,152}})));
  Modelica.Blocks.Continuous.FirstOrder actuator2(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-70,96},{-90,116}})));
  Modelica.Blocks.Continuous.FirstOrder turbine2(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-106,96},{-126,116}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary2(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-181,63})));
  TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex linearSynchronousMachineComplex2(
    P_el_n(displayUnit="MW") = 800000000,
    S_n=800e6,
    v_n=380e3) annotation (Placement(transformation(extent={{-140,52},{-120,72}})));
  TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex       linearSynchronousMachineComplex1(P_el_n(displayUnit="MW") = 1200000000, S_n=1200e6,
    IsSlack=true,
    eta=0.99)                                                                                                                                                        annotation (Placement(transformation(extent={{0,86},{-20,106}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia2(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-166,52},{-146,72}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia1(P_n(displayUnit="MW") = 2000000000, J=1200e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2)
                                                                                                                                                               annotation (Placement(transformation(extent={{8,86},{28,106}})));
  Modelica.Blocks.Sources.RealExpression slackPowert0(y=P_slack_start)                             annotation (Placement(transformation(extent={{-20,108},{0,128}})));
  Modelica.Blocks.Math.Add add1 annotation (Placement(transformation(extent={{30,114},{50,134}})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-166,92})));
  Modelica.Blocks.Sources.Constant const_P_G2(k=-20e6) annotation (Placement(transformation(extent={{-194,104},{-184,114}})));
  Modelica.Blocks.Continuous.FirstOrder actuator3(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-74,26},{-94,46}})));
  Modelica.Blocks.Continuous.FirstOrder turbine3(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-112,26},{-132,46}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary3(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-159,-13})));
  TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex linearSynchronousMachineComplex3(
    P_el_n(displayUnit="MW") = 800000000,
    S_n=800e6,
    v_n=380e3) annotation (Placement(transformation(extent={{-116,-12},{-96,8}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia3(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-144,-12},{-124,8}})));
  Modelica.Blocks.Math.Add add3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-158,14})));
  Modelica.Blocks.Sources.Constant const_P_G3(k=20e6) annotation (Placement(transformation(extent={{-196,32},{-186,42}})));
  Modelica.Blocks.Continuous.FirstOrder actuator4(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-70,-52},{-90,-32}})));
  Modelica.Blocks.Continuous.FirstOrder turbine4(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-106,-52},{-126,-32}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary4(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-155,-85})));
  TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex linearSynchronousMachineComplex4(
    P_el_n(displayUnit="MW") = 800000000,
    S_n=800e6,
    v_n=380e3) annotation (Placement(transformation(extent={{-110,-94},{-90,-74}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia4(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-134,-94},{-114,-74}})));
  Modelica.Blocks.Math.Add add4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-154,-58})));
  Modelica.Blocks.Sources.Constant const_P_G4(k=20e6) annotation (Placement(transformation(extent={{-186,-44},{-176,-34}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine2(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)                                                             annotation (Placement(transformation(extent={{-116,52},{-96,72}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine3(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)
           annotation (Placement(transformation(extent={{-82,-12},{-62,8}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine4(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)
           annotation (Placement(transformation(extent={{-74,-94},{-54,-74}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex4(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-48,-94},{-28,-74}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower4(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-52,-62},{-32,-42}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex3(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-52,-12},{-32,8}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower3(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-56,20},{-36,40}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex2(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-58,52},{-38,72}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower2(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-88,72},{-68,92}})));
     TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency annotation (Placement(transformation(extent={{-158,116},{-138,136}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort dummyExcitationSystem_ComplexPowerPort annotation (Placement(transformation(extent={{-156,70},{-136,90}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort dummyExcitationSystem_ComplexPowerPort1 annotation (Placement(transformation(extent={{-84,8},{-104,28}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort dummyExcitationSystem_ComplexPowerPort2 annotation (Placement(transformation(extent={{-78,-72},{-98,-52}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort dummyExcitationSystem_ComplexPowerPort3 annotation (Placement(transformation(extent={{-58,90},{-38,110}})));



// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "CheckLinearSynchronousMachineComplex.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
// createPlot(id=1, position={809, 0, 791, 733}, y={"slackMachine.epp.P", "load.epp.P"}, range={0.0, 100.0, 2700000.0, 3400000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
// createPlot(id=1, position={809, 0, 791, 364}, y={"slackMachine.epp.v", "load.epp.v"}, range={0.0, 100.0, 0.0, 14000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 733}, y={"linearSynchronousMachineComplex1.epp.f"}, grid=true, colors={{28,108,200}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 364}, y={"linearSynchronousMachineComplex3.epp.P", "linearSynchronousMachineComplex3.epp.Q"},  grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;


// _____________________________________________
//
//               Equations
// _____________________________________________


initial equation

  P_slack_start=linearSynchronousMachineComplex1.P_mech;

equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________



  connect(step_P.y, load.P_el_set) annotation (Line(points={{45,76},{24,76},{24,71.6}}, color={0,0,127}));
  connect(actuator1.u, feedback.y) annotation (Line(points={{-38,142},{-42,142},{-42,148},{-115,148}}, color={0,0,127}));
  connect(globalFrequency_reference.y, feedback.u1) annotation (Line(points={{-143,148},{-132,148}}, color={0,0,127}));
  connect(actuator1.y, turbine1.u) annotation (Line(points={{-15,142},{-8,142}}, color={0,0,127}));
  connect(actuator2.y, turbine2.u) annotation (Line(points={{-91,106},{-104,106}}, color={0,0,127}));
  connect(actuator2.u, feedback.y) annotation (Line(points={{-68,106},{-62,106},{-62,148},{-115,148}}, color={0,0,127}));
  connect(linearSynchronousMachineComplex1.mpp, constantInertia1.mpp_a) annotation (Line(points={{0,96},{4,96},{4,96},{8,96}},       color={95,95,95}));
  connect(constantInertia1.mpp_b, mechanicalBoundary1.mpp) annotation (Line(points={{28,96},{30,96},{30,103},{58,103}}, color={95,95,95}));
  connect(linearSynchronousMachineComplex2.mpp, constantInertia2.mpp_b) annotation (Line(points={{-140,62},{-146,62},{-146,62}},       color={95,95,95}));
  connect(constantInertia2.mpp_a, mechanicalBoundary2.mpp) annotation (Line(points={{-166,62},{-166,63},{-172,63}}, color={95,95,95}));
  connect(add1.u1, turbine1.y) annotation (Line(points={{28,130},{22,130},{22,142},{15,142}}, color={0,0,127}));
  connect(mechanicalBoundary1.P_mech_set, add1.y) annotation (Line(points={{67,113.62},{67,132.81},{51,132.81},{51,124}}, color={0,0,127}));
  connect(add2.u1,turbine2. y) annotation (Line(points={{-160,104},{-160,104},{-160,106},{-127,106}},                       color={0,0,127}));
  connect(mechanicalBoundary2.P_mech_set,add2. y) annotation (Line(points={{-181,73.62},{-166,73.62},{-166,81}}, color={0,0,127}));
  connect(const_P_G2.y, add2.u2) annotation (Line(points={{-183.5,109},{-178,109},{-178,108},{-172,108},{-172,104},{-172,104}}, color={0,0,127}));
  connect(actuator3.y, turbine3.u) annotation (Line(points={{-95,36},{-110,36}}, color={0,0,127}));
  connect(linearSynchronousMachineComplex3.mpp, constantInertia3.mpp_b) annotation (Line(points={{-116,-2},{-124,-2},{-124,-2}},       color={95,95,95}));
  connect(constantInertia3.mpp_a,mechanicalBoundary3. mpp) annotation (Line(points={{-144,-2},{-144,-13},{-150,-13}},  color={95,95,95}));
  connect(add3.u1,turbine3. y) annotation (Line(points={{-152,26},{-142,26},{-142,36},{-133,36}}, color={0,0,127}));
  connect(mechanicalBoundary3.P_mech_set,add3. y) annotation (Line(points={{-159,-2.38},{-158,-2.38},{-158,3}}, color={0,0,127}));
  connect(const_P_G3.y, add3.u2) annotation (Line(points={{-185.5,37},{-178.75,37},{-178.75,26},{-164,26}}, color={0,0,127}));
  connect(actuator3.u, feedback.y) annotation (Line(points={{-72,36},{-68,36},{-68,30},{-62,30},{-62,148},{-115,148}},                     color={0,0,127}));
  connect(actuator4.y, turbine4.u) annotation (Line(points={{-91,-42},{-104,-42}}, color={0,0,127}));
  connect(linearSynchronousMachineComplex4.mpp, constantInertia4.mpp_b) annotation (Line(points={{-110,-84},{-114,-84},{-114,-84}},       color={95,95,95}));
  connect(constantInertia4.mpp_a,mechanicalBoundary4. mpp) annotation (Line(points={{-134,-84},{-134,-85},{-146,-85}}, color={95,95,95}));
  connect(add4.u1,turbine4. y) annotation (Line(points={{-148,-46},{-148,-46},{-148,-42},{-127,-42}},
                                                                                                  color={0,0,127}));
  connect(mechanicalBoundary4.P_mech_set,add4. y) annotation (Line(points={{-155,-74.38},{-154,-74.38},{-154,-69}},
                                                                                                                color={0,0,127}));
  connect(const_P_G4.y, add4.u2) annotation (Line(points={{-175.5,-39},{-162.75,-39},{-162.75,-46},{-160,-46}}, color={0,0,127}));
  connect(actuator4.u, feedback.y) annotation (Line(points={{-68,-42},{-62,-42},{-62,30},{-62,30},{-62,148},{-115,148}}, color={0,0,127}));
  connect(linearSynchronousMachineComplex1.epp, load.epp) annotation (Line(
      points={{-20.1,95.9},{-20.1,96},{-36,96},{-36,62},{14.2,62},{14.2,60}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex2.epp_n, load.epp) annotation (Line(
      points={{-38,62},{14.2,62},{14.2,60}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine2.epp_p, linearSynchronousMachineComplex2.epp) annotation (Line(
      points={{-116,62},{-118,62},{-118,62},{-118,62},{-118,61.9},{-119.9,61.9}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine2.epp_n, transformerComplex2.epp_p) annotation (Line(
      points={{-96,62},{-58,62}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower2.epp, transmissionLine2.epp_n) annotation (Line(
      points={{-88,82},{-88,74.95},{-96,74.95},{-96,62}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine3.epp_p, linearSynchronousMachineComplex3.epp) annotation (Line(
      points={{-82,-2},{-88,-2},{-88,-2.1},{-95.9,-2.1}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex3.epp_n, load.epp) annotation (Line(
      points={{-32,-2},{-10,-2},{-10,62},{14.2,62},{14.2,60}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower3.epp,transformerComplex3. epp_p) annotation (Line(
      points={{-56,30},{-56,14},{-56,14},{-56,-2},{-52,-2},{-52,-2}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine3.epp_n,transformerComplex3. epp_p) annotation (Line(
      points={{-62,-2},{-52,-2}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine4.epp_p, linearSynchronousMachineComplex4.epp) annotation (Line(
      points={{-74,-84},{-82,-84},{-82,-84.1},{-89.9,-84.1}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex4.epp_p,transmissionLine4. epp_n) annotation (Line(
      points={{-48,-84},{-54,-84}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower4.epp, transmissionLine4.epp_n) annotation (Line(
      points={{-52,-52},{-52,-84},{-54,-84}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex4.epp_n, load.epp) annotation (Line(
      points={{-28,-84},{-28,-84},{-10,-84},{-10,-84},{-10,-84},{-10,62},{14.2,62},{14.2,60}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency.f, feedback.u2) annotation (Line(points={{-137.6,126},{-130,126},{-130,140},{-124,140}}, color={0,0,127}));
  connect(globalFrequency.epp, transmissionLine2.epp_p) annotation (Line(
      points={{-158,126},{-170,126},{-170,112},{-132,112},{-132,80},{-118,80},{-118,62},{-116,62}},
      color={28,108,200},
      thickness=0.5));
  connect(dummyExcitationSystem_ComplexPowerPort.y, linearSynchronousMachineComplex2.E_input) annotation (Line(points={{-135.4,80},{-134,80},{-134,71.9},{-130.3,71.9}}, color={0,0,127}));
  connect(dummyExcitationSystem_ComplexPowerPort.epp1, transmissionLine2.epp_p) annotation (Line(
      points={{-156,80},{-156,112},{-132,112},{-132,80},{-118,80},{-118,62},{-116,62}},
      color={28,108,200},
      thickness=0.5));
  connect(dummyExcitationSystem_ComplexPowerPort1.y, linearSynchronousMachineComplex3.E_input) annotation (Line(points={{-104.6,18},{-106,18},{-106,7.9},{-106.3,7.9}}, color={0,0,127}));
  connect(dummyExcitationSystem_ComplexPowerPort1.epp1, linearSynchronousMachineComplex3.epp) annotation (Line(
      points={{-84,18},{-82,18},{-82,-2.1},{-95.9,-2.1}},
      color={28,108,200},
      thickness=0.5));
  connect(dummyExcitationSystem_ComplexPowerPort2.y, linearSynchronousMachineComplex4.E_input) annotation (Line(points={{-98.6,-62},{-100,-62},{-100,-74.1},{-100.3,-74.1}}, color={0,0,127}));
  connect(dummyExcitationSystem_ComplexPowerPort2.epp1, linearSynchronousMachineComplex4.epp) annotation (Line(
      points={{-78,-62},{-80,-62},{-80,-84},{-82,-84},{-82,-84.1},{-89.9,-84.1}},
      color={28,108,200},
      thickness=0.5));
  connect(dummyExcitationSystem_ComplexPowerPort3.epp1, load.epp) annotation (Line(
      points={{-58,100},{-64,100},{-64,78},{-36,78},{-36,62},{14.2,62},{14.2,60}},
      color={28,108,200},
      thickness=0.5));
  connect(dummyExcitationSystem_ComplexPowerPort3.y, linearSynchronousMachineComplex1.E_input) annotation (Line(points={{-37.4,100},{-22,100},{-22,110},{-10,110},{-10,105.9},{-9.7,105.9}}, color={0,0,127}));
  connect(slackPowert0.y, add1.u2) annotation (Line(points={{1,118},{28,118}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{100,160}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-200,-100},{100,160}}), Polygon(
          points={{-104,-4},{-128,-16},{-74,-58},{-50,-50},{24,116},{4,126},{-56,-64},{-98,-30},{-104,-4}},
          smooth=Smooth.Bezier,
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{100,160}}), graphics={
        Text(
          extent={{-8,-30},{50,-46}},
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="All variables must be initialized.
Please use dummy loads if a 
bus is not initialized.")}),
    experiment(StopTime=70),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for LinearSynchronousMachineComplex</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in Apr 2018</span></p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end CheckLinearSynchronousMachineComplex;
