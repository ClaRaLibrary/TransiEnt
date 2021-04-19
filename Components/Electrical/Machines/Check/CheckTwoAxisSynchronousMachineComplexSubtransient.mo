within TransiEnt.Components.Electrical.Machines.Check;
model CheckTwoAxisSynchronousMachineComplexSubtransient "Test for TwoAxisSynchronousMachineComplex"
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
    annotation (Placement(transformation(extent={{20,-84},{40,-64}})));
  inner TransiEnt.SimCenter simCenter(T_grid=11.1 + 2*4.93)
    annotation (Placement(transformation(extent={{50,-84},{70,-64}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load(
    useInputConnectorP=true,
    f_n=50,
    v_n=110000,
    variability(kpf=40e6),
    useCosPhi=true,
    cosphi_set=0.8)
                annotation (Placement(transformation(extent={{-6,34},{14,54}})));
  Modelica.Blocks.Sources.Step step_P(
    startTime=20,
    offset=450e6,
    height=100e6) annotation (Placement(transformation(extent={{72,46},{52,66}})));
  Modelica.Blocks.Continuous.FirstOrder actuator1(
    T=0.2,
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-34,156},{-14,176}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-134,138},{-114,158}})));
  Modelica.Blocks.Sources.RealExpression globalFrequency_reference(y=simCenter.f_n) annotation (Placement(transformation(extent={{-168,150},{-148,170}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary1 annotation (Placement(transformation(
        extent={{9,-9},{-9,9}},
        rotation=0,
        origin={67,103})));
  Modelica.Blocks.Continuous.FirstOrder turbine1(
    T=1.5,
    k=-480e6,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-6,158},{14,178}})));
  Modelica.Blocks.Continuous.FirstOrder actuator2(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-66,106},{-86,126}})));
  Modelica.Blocks.Continuous.FirstOrder turbine2(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-104,106},{-124,126}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary2(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-155,63})));
  TransiEnt.Components.Electrical.Machines.TwoAxisSynchronousMachineComplexSubtransient twoAxisSynchronousMachineComplexSubtransient2(v_n=380e3) annotation (Placement(transformation(extent={{-110,52},{-90,72}})));
  TransiEnt.Components.Electrical.Machines.TwoAxisSynchronousMachineComplexSubtransient twoAxisSynchronousMachineComplexSubtransient1(IsSlack=true) annotation (Placement(transformation(extent={{8,90},{-12,110}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia2(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-136,52},{-116,72}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia1(P_n(displayUnit="MW") = 2000000000, J=1200e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2)
                                                                                                                                                               annotation (Placement(transformation(extent={{22,92},{42,112}})));
  Modelica.Blocks.Sources.RealExpression slackPowert0(y=P_slack_start)                                          annotation (Placement(transformation(extent={{-42,126},{-22,146}})));
  Modelica.Blocks.Math.Add add1 annotation (Placement(transformation(extent={{32,122},{52,142}})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-154,90})));
  Modelica.Blocks.Sources.Constant const_P_G2(k=-20e6) annotation (Placement(transformation(extent={{-186,104},{-176,114}})));
  Modelica.Blocks.Continuous.FirstOrder actuator3(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-74,22},{-94,42}})));
  Modelica.Blocks.Continuous.FirstOrder turbine3(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-110,22},{-130,42}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary3(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-159,-17})));
  TransiEnt.Components.Electrical.Machines.TwoAxisSynchronousMachineComplexSubtransient twoAxisSynchronousMachineComplexSubtransient3(v_n=380e3) annotation (Placement(transformation(extent={{-112,-28},{-92,-8}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia3(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-140,-26},{-120,-6}})));
  Modelica.Blocks.Math.Add add3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-158,14})));
  Modelica.Blocks.Sources.Constant const_P_G3(k=10e6) annotation (Placement(transformation(extent={{-190,28},{-180,38}})));
  Modelica.Blocks.Continuous.FirstOrder actuator4(
    k=1,
    T=0.3,
    initType=Modelica.Blocks.Types.Init.InitialState) annotation (Placement(transformation(extent={{-70,-58},{-90,-38}})));
  Modelica.Blocks.Continuous.FirstOrder turbine4(     T=2.5, k=-320e6,
    initType=Modelica.Blocks.Types.Init.InitialState)        annotation (Placement(transformation(extent={{-106,-58},{-126,-38}})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalBoundary4(tau_is(start=63662))
                                                                       annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-157,-99})));
  TransiEnt.Components.Electrical.Machines.TwoAxisSynchronousMachineComplexSubtransient twoAxisSynchronousMachineComplexSubtransient4(v_n=380e3, R_a=0) annotation (Placement(transformation(extent={{-106,-108},{-86,-88}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia4(
    alpha(start=-300),
    P_n(displayUnit="MW") = 800000000,
    J=800e6*(simCenter.T_grid)/(100*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-136,-108},{-116,-88}})));
  Modelica.Blocks.Math.Add add4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-154,-58})));
  Modelica.Blocks.Sources.Constant const_P_G4(k=10e6) annotation (Placement(transformation(extent={{-186,-44},{-176,-34}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine2(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)                                                             annotation (Placement(transformation(extent={{-86,52},{-66,72}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine3(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)
           annotation (Placement(transformation(extent={{-86,-28},{-66,-8}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine4(
    l=100,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    ChooseVoltageLevel=3)
           annotation (Placement(transformation(extent={{-78,-108},{-58,-88}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex4(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-50,-108},{-30,-88}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower4(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-52,-62},{-32,-42}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex3(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower3(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-54,8},{-34,28}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex       transformerComplex2(U_P(displayUnit="kV") = 380000, U_S(displayUnit="kV") = 110000) annotation (Placement(transformation(extent={{-54,52},{-34,72}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower2(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-52,74},{-32,94}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.VoltageRegulatorExcitationStabilization voltageRegulatorExcitationStabilization1 annotation (Placement(transformation(extent={{-48,108},{-28,128}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.VoltageRegulatorExcitationStabilization voltageRegulatorExcitationStabilization2(v_n=380e3) annotation (Placement(transformation(extent={{-94,82},{-114,102}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.VoltageRegulatorExcitationStabilization voltageRegulatorExcitationStabilization3(v_n=380e3) annotation (Placement(transformation(extent={{-96,0},{-116,20}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.VoltageRegulatorExcitationStabilization voltageRegulatorExcitationStabilization4(v_n=380e3) annotation (Placement(transformation(extent={{-88,-78},{-108,-58}})));
  TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency annotation (Placement(transformation(extent={{-154,126},{-134,146}})));
// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "CheckTwoAxisSynchronousMachineComplexsubtransient.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"twoAxisSynchronousMachineComplexSubtransient1.e_d_subtrans", "twoAxisSynchronousMachineComplexSubtransient1.e_q_subtrans"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"twoAxisSynchronousMachineComplexSubtransient1.i_d", "twoAxisSynchronousMachineComplexSubtransient1.i_q"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=2, position={0, 0, 791, 733}, y={"twoAxisSynchronousMachineComplexSubtransient1.epp.f"}, grid=true, colors={{28,108,200}}, filename=resultFile);
createPlot(id=2, position={0, 0, 791, 364}, y={"twoAxisSynchronousMachineComplexSubtransient3.epp.P", "twoAxisSynchronousMachineComplexSubtransient3.epp.Q"},  grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

// _____________________________________________
//
//               Equations
// _____________________________________________


initial equation

  P_slack_start=twoAxisSynchronousMachineComplexSubtransient1.P_mech;



equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(step_P.y, load.P_el_set) annotation (Line(points={{51,56},{4,56},{4,55.6}}, color={0,0,127}));
  connect(actuator1.u, feedback.y) annotation (Line(points={{-36,166},{-42,166},{-42,148},{-115,148}}, color={0,0,127}));
  connect(globalFrequency_reference.y, feedback.u1) annotation (Line(points={{-147,160},{-138,160},{-138,148},{-132,148}},
                                                                                                     color={0,0,127}));
  connect(actuator1.y, turbine1.u) annotation (Line(points={{-13,166},{-10,166},{-10,168},{-8,168}}, color={0,0,127}));
  connect(actuator2.y, turbine2.u) annotation (Line(points={{-87,116},{-102,116}}, color={0,0,127}));
  connect(actuator2.u, feedback.y) annotation (Line(points={{-64,116},{-62,116},{-62,148},{-115,148}}, color={0,0,127}));
  connect(twoAxisSynchronousMachineComplexSubtransient1.mpp, constantInertia1.mpp_a) annotation (Line(points={{8,100},{14,100},{14,100},{18,100},{18,102},{22,102}},     color={95,95,95}));
  connect(constantInertia1.mpp_b, mechanicalBoundary1.mpp) annotation (Line(points={{42,102},{48,102},{48,103},{58,103}},                 color={95,95,95}));
  connect(twoAxisSynchronousMachineComplexSubtransient2.mpp, constantInertia2.mpp_b) annotation (Line(points={{-110,62},{-116,62},{-116,62}},       color={95,95,95}));
  connect(constantInertia2.mpp_a, mechanicalBoundary2.mpp) annotation (Line(points={{-136,62},{-136,63},{-146,63}}, color={95,95,95}));
  connect(add1.u1, turbine1.y) annotation (Line(points={{30,138},{22,138},{22,168},{15,168}}, color={0,0,127}));
  connect(mechanicalBoundary1.P_mech_set, add1.y) annotation (Line(points={{67,113.62},{67,132.81},{53,132.81},{53,132}}, color={0,0,127}));
  connect(add2.u1,turbine2. y) annotation (Line(points={{-148,102},{-148,116},{-125,116}},                                  color={0,0,127}));
  connect(mechanicalBoundary2.P_mech_set,add2. y) annotation (Line(points={{-155,73.62},{-154,73.62},{-154,79}}, color={0,0,127}));
  connect(const_P_G2.y, add2.u2) annotation (Line(points={{-175.5,109},{-160.75,109},{-160.75,102},{-160,102}}, color={0,0,127}));
  connect(actuator3.y, turbine3.u) annotation (Line(points={{-95,32},{-108,32}}, color={0,0,127}));
  connect(twoAxisSynchronousMachineComplexSubtransient3.mpp, constantInertia3.mpp_b) annotation (Line(points={{-112,-18},{-120,-18},{-120,-16}},       color={95,95,95}));
  connect(constantInertia3.mpp_a,mechanicalBoundary3. mpp) annotation (Line(points={{-140,-16},{-140,-17},{-150,-17}}, color={95,95,95}));
  connect(add3.u1,turbine3. y) annotation (Line(points={{-152,26},{-142,26},{-142,32},{-131,32}}, color={0,0,127}));
  connect(mechanicalBoundary3.P_mech_set,add3. y) annotation (Line(points={{-159,-6.38},{-158,-6.38},{-158,3}}, color={0,0,127}));
  connect(const_P_G3.y, add3.u2) annotation (Line(points={{-179.5,33},{-178.75,33},{-178.75,26},{-164,26}}, color={0,0,127}));
  connect(actuator3.u, feedback.y) annotation (Line(points={{-72,32},{-62,32},{-62,148},{-115,148}}, color={0,0,127}));
  connect(actuator4.y, turbine4.u) annotation (Line(points={{-91,-48},{-104,-48}}, color={0,0,127}));
  connect(twoAxisSynchronousMachineComplexSubtransient4.mpp, constantInertia4.mpp_b) annotation (Line(points={{-106,-98},{-116,-98},{-116,-98}},       color={95,95,95}));
  connect(constantInertia4.mpp_a,mechanicalBoundary4. mpp) annotation (Line(points={{-136,-98},{-136,-99},{-148,-99}}, color={95,95,95}));
  connect(add4.u1,turbine4. y) annotation (Line(points={{-148,-46},{-148,-48},{-127,-48}},        color={0,0,127}));
  connect(mechanicalBoundary4.P_mech_set,add4. y) annotation (Line(points={{-157,-88.38},{-154,-88.38},{-154,-69}},
                                                                                                                color={0,0,127}));
  connect(const_P_G4.y, add4.u2) annotation (Line(points={{-175.5,-39},{-162.75,-39},{-162.75,-46},{-160,-46}}, color={0,0,127}));
  connect(actuator4.u, feedback.y) annotation (Line(points={{-68,-48},{-62,-48},{-62,148},{-115,148}},                   color={0,0,127}));
  connect(twoAxisSynchronousMachineComplexSubtransient1.epp, load.epp) annotation (Line(
      points={{-12.1,99.9},{-12,99.9},{-12,100},{-18,100},{-28,100},{-28,44},{-5.8,44}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex2.epp_n, load.epp) annotation (Line(
      points={{-34,62},{-28,62},{-28,44},{-5.8,44}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine2.epp_p, twoAxisSynchronousMachineComplexSubtransient2.epp) annotation (Line(
      points={{-86,62},{-88,62},{-88,61.9},{-89.9,61.9}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine2.epp_n, transformerComplex2.epp_p) annotation (Line(
      points={{-66,62},{-54,62}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower2.epp, transmissionLine2.epp_n) annotation (Line(
      points={{-52,84},{-52,84},{-58,84},{-58,62},{-66,62}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine3.epp_p, twoAxisSynchronousMachineComplexSubtransient3.epp) annotation (Line(
      points={{-86,-18},{-88,-18},{-88,-18.1},{-91.9,-18.1}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex3.epp_n, load.epp) annotation (Line(
      points={{-34,-18},{-28,-18},{-28,44},{-5.8,44}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower3.epp,transformerComplex3. epp_p) annotation (Line(
      points={{-54,18},{-54,16},{-58,16},{-58,-16},{-54,-16},{-54,-18}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine3.epp_n,transformerComplex3. epp_p) annotation (Line(
      points={{-66,-18},{-54,-18}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine4.epp_p, twoAxisSynchronousMachineComplexSubtransient4.epp) annotation (Line(
      points={{-78,-98},{-82,-98},{-82,-98.1},{-85.9,-98.1}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex4.epp_p,transmissionLine4. epp_n) annotation (Line(
      points={{-50,-98},{-58,-98}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower4.epp, transmissionLine4.epp_n) annotation (Line(
      points={{-52,-52},{-52,-98},{-58,-98}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerComplex4.epp_n, load.epp) annotation (Line(
      points={{-30,-98},{-30,-98},{-28,-98},{-28,-30},{-28,-30},{-28,44},{-5.8,44}},
      color={28,108,200},
      thickness=0.5));
  connect(voltageRegulatorExcitationStabilization1.y, twoAxisSynchronousMachineComplexSubtransient1.E_input) annotation (Line(points={{-27.4,118},{-1.7,118},{-1.7,109.9}}, color={0,0,127}));
  connect(voltageRegulatorExcitationStabilization1.epp1, load.epp) annotation (Line(
      points={{-48,118},{-56,118},{-56,100},{-28,100},{-28,64},{-28,64},{-28,44},{-5.8,44}},
      color={28,108,200},
      thickness=0.5));
  connect(twoAxisSynchronousMachineComplexSubtransient2.E_input, voltageRegulatorExcitationStabilization2.y) annotation (Line(points={{-100.3,71.9},{-126,71.9},{-126,92},{-114.6,92}}, color={0,0,127}));
  connect(voltageRegulatorExcitationStabilization2.epp1, twoAxisSynchronousMachineComplexSubtransient2.epp) annotation (Line(
      points={{-94,92},{-90,92},{-90,61.9},{-89.9,61.9}},
      color={28,108,200},
      thickness=0.5));
  connect(voltageRegulatorExcitationStabilization3.epp1,transmissionLine3. epp_p) annotation (Line(
      points={{-96,10},{-90,10},{-90,-18},{-86,-18}},
      color={28,108,200},
      thickness=0.5));
  connect(voltageRegulatorExcitationStabilization3.y, twoAxisSynchronousMachineComplexSubtransient3.E_input) annotation (Line(points={{-116.6,10},{-130,10},{-130,-8.1},{-102.3,-8.1}}, color={0,0,127}));
  connect(voltageRegulatorExcitationStabilization4.y, twoAxisSynchronousMachineComplexSubtransient4.E_input) annotation (Line(points={{-108.6,-68},{-118,-68},{-118,-88.1},{-96.3,-88.1}}, color={0,0,127}));
  connect(voltageRegulatorExcitationStabilization4.epp1, twoAxisSynchronousMachineComplexSubtransient4.epp) annotation (Line(
      points={{-88,-68},{-80,-68},{-80,-98.1},{-85.9,-98.1}},
      color={28,108,200},
      thickness=0.5));
  connect(feedback.u2, globalFrequency.f) annotation (Line(points={{-124,140},{-124,136},{-133.6,136}}, color={0,0,127}));
  connect(globalFrequency.epp, twoAxisSynchronousMachineComplexSubtransient2.epp) annotation (Line(
      points={{-154,136},{-154,134},{-90,134},{-90,61.9},{-89.9,61.9}},
      color={28,108,200},
      thickness=0.5));
  connect(slackPowert0.y, add1.u2) annotation (Line(points={{-21,136},{3.5,136},{3.5,126},{30,126}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{100,180}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-200,-120},{100,180}}), Polygon(
          points={{-104,-6},{-128,-18},{-74,-60},{-50,-52},{24,114},{4,124},{-56,-66},{-98,-32},{-104,-6}},
          smooth=Smooth.Bezier,
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{100,180}}), graphics={
        Text(
          extent={{-26,22},{32,6}},
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="All variables must be initialized.
Please use dummy loads if a 
bus is not initialized.")}),
    experiment(StopTime=70),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for TwoAxisSynchronousMachineSubtransient</p>
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
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end CheckTwoAxisSynchronousMachineComplexSubtransient;
