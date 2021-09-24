within TransiEnt.Components.Boundaries.Electrical.Check;
model TestLoadFlowCalculation "Example to Test a more complex grid with load flow (quasi-stationary)"

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
//             Variable Declarations
// _____________________________________________

// _____________________________________________
//
//           Instances of other Classes
// _____________________________________________

  inner TransiEnt.SimCenter simCenter(v_n(displayUnit="kV") = 110000)
                                                annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-12,-34},{8,-14}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary SupplyGrid annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={84,80})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced SS_D(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1500,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,40})));

  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex Transformer110_10(
    U_P(displayUnit="kV") = 110000,
    U_S(displayUnit="kV") = 10000,
    X_S=0,
    R_P=0,
    R_S=0,
    X_P=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={76,52})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex replacedLoad(
    Q_el_set=200,
    P_el_set_const(displayUnit="MW") = 22290000,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={76,-28})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced SS_E(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=3200,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,36})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced SS_A(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1500,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,36})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced D_E(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=2600,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,148})));

  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex ONS4Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,116})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex ONS4Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    P_el_set_const(displayUnit="MW") = 500000,
    v_n(displayUnit="kV") = 400) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={94,116})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex ONS1Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-102,96})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex ONS1Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    P_el_set_const(displayUnit="MW") = 300000,
    v_n(displayUnit="kV") = 400) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-130,96})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced A_G(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1580,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-42,126})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced E_G(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1470,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-42,190})));

  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex SVK3(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 3000000)
                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,160})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex ONS3Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={56,194})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex ONS3Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n(displayUnit="V") = 400,
    P_el_set_const(displayUnit="MW") = 350000,
    delta_load_start=0)                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={112,194})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced E_F(
    l=520,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,240})));

  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex SVK2Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={52,288})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex SVK2Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 400,
    P_el_set_const(displayUnit="MW") = 350000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={104,288})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced A_B(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1500,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-96,148})));

  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex SVK1Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-128,182})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex SVK1Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    P_el_set_const(displayUnit="MW") = 300000,
    v_n(displayUnit="kV") = 400) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-166,182})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced B_C(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1250,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-96,210})));

  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex ONS2Transformer(
    X_S=0,
    R_P=0,
    R_S=0,
    U_P(displayUnit="kV") = 10000,
    U_S(displayUnit="kV") = 400,
    X_P=13.3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-120,288})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex ONS2Load(
    Q_el_set=200,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 400,
    P_el_set_const(displayUnit="MW") = 200000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-164,288})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced F_C(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=3000,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,288})));

  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex C_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=0) "Used for initialization"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,260})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex D_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=0) "Used for initialization" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={76,142})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex A_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=0) "Used for initialization" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-36,88})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex B_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=0) "Used for initialization" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,182})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced B_C1(
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4,
    l=1250,
    ChooseVoltageLevel=2)                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-96,238})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex C_init1(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=0) "Used for initialization"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,210})));

// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "TestLoadFlowCalculation.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
// createPlot(id=1, position={809, 0, 791, 733}, y={"slackMachine.epp.P", "load.epp.P"}, range={0.0, 100.0, 2700000.0, 3400000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
// createPlot(id=1, position={809, 0, 791, 364}, y={"slackMachine.epp.v", "load.epp.v"}, range={0.0, 100.0, 0.0, 14000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 733}, y={"starresNetz.epp.P","SVK1Trafo.epp_n.P"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 364}, y={"SVK3.epp.delta", "ONS1Last.epp.delta"},  grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  Consumer.Electrical.ExponentialElectricConsumerComplex E_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=-0.017453292519943) "Used for initialization" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,224})));
  Consumer.Electrical.ExponentialElectricConsumerComplex F_init(
    cosphi_set=0.9,
    v_n(displayUnit="kV") = 10000,
    P_el_set_const(displayUnit="MW") = 0,
    useCosPhi=false,
    Q_el_set=0,
    delta_load_start=-0.017453292519943) "Used for initialization" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={52,320})));
equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(Transformer110_10.epp_p, SupplyGrid.epp) annotation (Line(
      points={{76,62},{76,70},{84,70}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS4Transformer.epp_n, ONS4Load.epp) annotation (Line(
      points={{76,116},{84.2,116}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS1Transformer.epp_n, ONS1Load.epp) annotation (Line(
      points={{-112,96},{-120.2,96}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS3Transformer.epp_n, ONS3Load.epp) annotation (Line(
      points={{66,194},{102.2,194}},
      color={28,108,200},
      thickness=0.5));
  connect(SVK2Transformer.epp_n, SVK2Load.epp) annotation (Line(
      points={{62,288},{94.2,288}},
      color={28,108,200},
      thickness=0.5));
  connect(SVK1Transformer.epp_n, SVK1Load.epp) annotation (Line(
      points={{-138,182},{-156.2,182}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS2Transformer.epp_n, ONS2Load.epp) annotation (Line(
      points={{-130,288},{-154.2,288}},
      color={28,108,200},
      thickness=0.5));
  connect(SS_A.epp_n, Transformer110_10.epp_n) annotation (Line(
      points={{-70,26},{-70,26},{-70,16},{-70,16},{-70,4},{74,4},{74,42},{76,42}},
      color={28,108,200},
      thickness=0.5));
  connect(replacedLoad.epp, Transformer110_10.epp_n) annotation (Line(
      points={{76,-18.2},{76,4},{74,4},{74,42},{76,42}},
      color={28,108,200},
      thickness=0.5));
  connect(SS_D.epp_n, Transformer110_10.epp_n) annotation (Line(
      points={{30,30},{30,4},{74,4},{74,42},{76,42}},
      color={28,108,200},
      thickness=0.5));
  connect(SS_E.epp_n, Transformer110_10.epp_n) annotation (Line(
      points={{-10,26},{-10,4},{74,4},{74,42},{76,42}},
      color={28,108,200},
      thickness=0.5));
  connect(D_init.epp, ONS4Transformer.epp_p) annotation (Line(
      points={{66.2,142},{42,142},{42,116},{56,116}},
      color={28,108,200},
      thickness=0.5));
  connect(D_E.epp_n, ONS4Transformer.epp_p) annotation (Line(
      points={{30,138},{30,116},{56,116}},
      color={28,108,200},
      thickness=0.5));
  connect(SS_D.epp_p, ONS4Transformer.epp_p) annotation (Line(
      points={{30,50},{30,116},{56,116}},
      color={28,108,200},
      thickness=0.5));
  connect(E_G.epp_p, E_F.epp_n) annotation (Line(
      points={{-42,200},{-10,200},{-10,226},{30,226},{30,230}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS3Transformer.epp_p, E_F.epp_n) annotation (Line(
      points={{46,194},{38,194},{38,224},{28,224},{28,226},{30,226},{30,230}},
      color={28,108,200},
      thickness=0.5));
  connect(D_E.epp_p, E_F.epp_n) annotation (Line(
      points={{30,158},{32,158},{32,224},{28,224},{28,226},{30,226},{30,230}},
      color={28,108,200},
      thickness=0.5));
  connect(F_C.epp_n, SVK2Transformer.epp_p) annotation (Line(
      points={{-10,288},{16,288},{16,288},{42,288}},
      color={28,108,200},
      thickness=0.5));
  connect(E_F.epp_p, SVK2Transformer.epp_p) annotation (Line(
      points={{30,250},{30,288},{42,288}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS2Transformer.epp_p, F_C.epp_p) annotation (Line(
      points={{-110,288},{-30,288}},
      color={28,108,200},
      thickness=0.5));
  connect(C_init.epp, F_C.epp_p) annotation (Line(
      points={{-77.8,260},{-96,260},{-96,288},{-30,288}},
      color={28,108,200},
      thickness=0.5));
  connect(SVK1Transformer.epp_p, B_init.epp) annotation (Line(
      points={{-118,182},{-81.8,182}},
      color={28,108,200},
      thickness=0.5));
  connect(A_B.epp_p, B_init.epp) annotation (Line(
      points={{-96,158},{-96,182},{-81.8,182}},
      color={28,108,200},
      thickness=0.5));
  connect(B_C.epp_n, B_init.epp) annotation (Line(
      points={{-96,200},{-96,182},{-81.8,182}},
      color={28,108,200},
      thickness=0.5));
  connect(SS_E.epp_p, E_F.epp_n) annotation (Line(
      points={{-10,46},{-10,226},{30,226},{30,230}},
      color={28,108,200},
      thickness=0.5));
  connect(A_G.epp_p, E_G.epp_n) annotation (Line(
      points={{-42,136},{-42,180}},
      color={28,108,200},
      thickness=0.5));
  connect(SVK3.epp, E_G.epp_n) annotation (Line(
      points={{-31.8,160},{-42,160},{-42,180}},
      color={28,108,200},
      thickness=0.5));
  connect(A_B.epp_n, SS_A.epp_p) annotation (Line(
      points={{-96,138},{-96,138},{-96,118},{-70,118},{-70,46},{-70,46}},
      color={28,108,200},
      thickness=0.5));
  connect(A_G.epp_n, SS_A.epp_p) annotation (Line(
      points={{-42,116},{-56,116},{-56,96},{-70,96},{-70,46}},
      color={28,108,200},
      thickness=0.5));
  connect(ONS1Transformer.epp_p, SS_A.epp_p) annotation (Line(
      points={{-92,96},{-70,96},{-70,46}},
      color={28,108,200},
      thickness=0.5));
  connect(A_init.epp, SS_A.epp_p) annotation (Line(
      points={{-45.8,88},{-70,88},{-70,46}},
      color={28,108,200},
      thickness=0.5));
  connect(B_C1.epp_p, F_C.epp_p) annotation (Line(
      points={{-96,248},{-96,288},{-30,288}},
      color={28,108,200},
      thickness=0.5));
  connect(B_C1.epp_n, B_C.epp_p) annotation (Line(
      points={{-96,228},{-96,220}},
      color={28,108,200},
      thickness=0.5));
  connect(C_init1.epp, B_C.epp_p) annotation (Line(
      points={{-73.8,210},{-84,210},{-84,224},{-96,224},{-96,220}},
      color={28,108,200},
      thickness=0.5));

  connect(E_init.epp, E_F.epp_n) annotation (Line(
      points={{70.2,224},{28,224},{28,226},{30,226},{30,230}},
      color={28,108,200},
      thickness=0.5));
  connect(F_init.epp, SVK2Transformer.epp_p) annotation (Line(
      points={{42.2,320},{30,320},{30,288},{42,288}},
      color={28,108,200},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-40},{160,340}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-220,-40},{162,340}}),  Polygon(
          points={{-146,98},{-150,76},{-68,14},{-60,14},{46,264},{26,270},{-64,22},{-66,22},{-146,98}},
          smooth=Smooth.Bezier,
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-40},{160,340}}), graphics={
        Text(
          extent={{-66,330},{6,300}},
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Use PiModelComplex_advanced"),
        Text(
          extent={{-74,240},{-4,220}},
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="All variables must be initialized.
Please use dummy loads if a 
bus is not initialized.")}),          Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test for a more complex grid with a load flow</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018</span></p>
</html>"),
    experiment,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestLoadFlowCalculation;
