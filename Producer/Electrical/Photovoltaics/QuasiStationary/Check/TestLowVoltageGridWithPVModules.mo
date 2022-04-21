within TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.Check;
model TestLowVoltageGridWithPVModules


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Area A_module_1=1 "PV Module surface";
  parameter SI.Efficiency eta_1=0.2 "Total efficiency from radiation to power output";
  parameter SI.Area A_module_2=10 "PV Module surface";
  parameter SI.Efficiency eta_2=0.2 "Total efficiency from radiation to power output";
  parameter SI.Area A_module_3=20 "PV Module surface";
  parameter SI.Efficiency eta_3=0.2 "Total efficiency from radiation to power output";
    // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Adapters.EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{-68,26},{-48,46}})));

  inner TransiEnt.SimCenter simCenter(tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Electrical.Grid.PiModelQS Cable1(l=41, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4)
                                                              annotation (Placement(transformation(rotation=0, extent={{-42,34},{-22,54}})));

  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load1(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={14,50})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground1 annotation (Placement(transformation(extent={{30,30},{50,50}})));

  TransiEnt.Components.Electrical.Grid.PiModelQS Cable16(l=24, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4)
                                                               annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-24,22})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable17(l=86, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K13)
                                                               annotation (Placement(transformation(rotation=0, extent={{2,14},{22,34}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load2(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={50,22})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable23(l=191, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4)
                                                                annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-24,-6})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load3(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={16,4})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground3 annotation (Placement(transformation(extent={{28,-16},{48,4}})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable29(l=66, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K13)
                                                               annotation (Placement(transformation(rotation=0, extent={{4,-30},{24,-10}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load4(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={66,-14})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground4 annotation (Placement(transformation(extent={{70,-34},{90,-14}})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable30(l=65, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4)
                                                               annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-24,-36})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable43(l=287, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4)
                                                                annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-24,-68})));
  TransiEnt.Components.Electrical.Grid.PiModelQS Cable32(l=89, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K14)
                                                               annotation (Placement(transformation(rotation=0, extent={{2,-62},{22,-42}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load5(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={42,-56})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground5 annotation (Placement(transformation(extent={{54,-76},{74,-56}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Resistor Load6(R_ref=50) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={12,-78})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground6 annotation (Placement(transformation(extent={{26,-98},{46,-78}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground Ground7 annotation (Placement(transformation(extent={{56,0},{76,20}})));
  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=
        ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-8,-18},{8,18}},
        rotation=180,
        origin={154,52})));
  TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.PhotovoltaicModuleQS pV_Module_1(A_module=100) annotation (Placement(transformation(
        rotation=180,
        extent={{-10,-10},{10,10}},
        origin={98,32})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(
    redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
    redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature,
    redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind(relativepath="/ambient/Wind_Hamburg_3600s_TMY.txt")) annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.PhotovoltaicModuleQS pV_Module_2(A_module=100) annotation (Placement(transformation(
        rotation=180,
        extent={{-10,-10},{10,10}},
        origin={98,0})));
  TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.PhotovoltaicModuleQS pV_Module_3(A_module=100) annotation (Placement(transformation(
        rotation=180,
        extent={{-10,-10},{10,10}},
        origin={100,-40})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid1(
    Use_input_connector_f=false,
    f_boundary=50,
    v_boundary=230,
    Use_input_connector_v=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-72,8})));
  Modelica.Blocks.Sources.Step Step_20_pu(
    height=230*0.2,
    offset=230,
    startTime=40000)
               annotation (Placement(transformation(extent={{-100,-52},{-80,-32}})));

function plotResult

  constant String resultFileName = "TestLowVoltageGridWithPVModules.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 805, 842}, y={"GlobalSolarRadiation.y"}, range={0.0, 90000.0, -10.0, 50.0}, grid=true, filename=resultFile, colors={{28,108,200}});
createPlot(id=1, position={0, 0, 805, 207}, y={"Grid1.epp.v"}, range={0.0, 90000.0, 220.0, 280.0}, grid=true, subPlot=2, colors={{28,108,200}});
createPlot(id=1, position={0, 0, 805, 206}, y={"Grid1.epp.P"}, range={0.0, 90000.0, -10000.0, -2000.0}, grid=true, subPlot=3, colors={{28,108,200}});
createPlot(id=1, position={0, 0, 805, 207}, y={"Load6.LossPower"}, range={0.0, 90000.0, 1000.0, 1600.0}, grid=true, subPlot=4, colors={{28,108,200}});

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

equation
  connect(Adapter.voltageP, Cable1.pin_p1)
    annotation (Line(points={{-48,36},{-48,44},{-42,44}}, color={85,170,255}));
  connect(Cable1.pin_p2, Load1.pin_p)
    annotation (Line(points={{-21.8,44},{-21.8,50},{4,50}},
                                                        color={85,170,255}));
  connect(Load1.pin_n, Ground1.pin)
    annotation (Line(points={{24,50},{40,50}}, color={85,170,255}));
  connect(Cable17.pin_p2, Load2.pin_p)
    annotation (Line(points={{22.2,24},{22.2,22},{40,22}},
                                                       color={85,170,255}));
  connect(Load3.pin_n, Ground3.pin)
    annotation (Line(points={{26,4},{38,4}},           color={85,170,255}));
  connect(Cable16.pin_p2, Cable17.pin_p1) annotation (Line(points={{-24,11.8},{-2,11.8},{-2,24},{2,24}},
                               color={85,170,255}));
  connect(Cable23.pin_p2, Load3.pin_p) annotation (Line(points={{-24,-16.2},{-2,-16.2},{-2,4},{6,4}},
                           color={85,170,255}));
  connect(Cable29.pin_p1, Load3.pin_p) annotation (Line(points={{4,-20},{-2,-20},{-2,4},{6,4}},
                           color={85,170,255}));
  connect(Cable29.pin_p2, Load4.pin_p)
    annotation (Line(points={{24.2,-20},{40,-20},{40,-14},{56,-14}},
                                                          color={85,170,255}));
  connect(Load4.pin_n, Ground4.pin)
    annotation (Line(points={{76,-14},{80,-14}},          color={85,170,255}));
  connect(Cable16.pin_p1, Load1.pin_p)
    annotation (Line(points={{-24,32},{-24,50},{4,50}}, color={85,170,255}));
  connect(Cable23.pin_p1, Cable16.pin_p2)
    annotation (Line(points={{-24,4},{-24,4},{-24,11.8}},
                                                        color={85,170,255}));
  connect(Cable23.pin_p2, Cable30.pin_p1)
    annotation (Line(points={{-24,-16.2},{-24,-20},{-24,-20},{-24,-24},{-24,-24},
          {-24,-26}},                              color={85,170,255}));
  connect(Cable30.pin_p2, Cable43.pin_p1) annotation (Line(points={{-24,-46.2},
          {-24,-50},{-24,-50},{-24,-52},{-24,-52},{-24,-58}},
                           color={85,170,255}));
  connect(Cable30.pin_p2, Cable32.pin_p1)
    annotation (Line(points={{-24,-46.2},{-8,-52},{2,-52}},
                                                          color={85,170,255},
      smooth=Smooth.Bezier));
  connect(Load5.pin_n, Ground5.pin)
    annotation (Line(points={{52,-56},{64,-56}},          color={85,170,255}));
  connect(Cable32.pin_p2, Load5.pin_p)
    annotation (Line(points={{22.2,-52},{32,-52},{32,-56}},
                                                          color={85,170,255}));
  connect(Load6.pin_n, Ground6.pin)
    annotation (Line(points={{22,-78},{36,-78}},          color={85,170,255}));
  connect(Cable43.pin_p2, Load6.pin_p)
    annotation (Line(points={{-24,-78.2},{-8,-78},{2,-78}},
                                                          color={85,170,255}));
  connect(Load2.pin_n, Ground7.pin)
    annotation (Line(points={{60,22},{66,22},{66,20}}, color={85,170,255}));
  connect(Load2.pin_p, pV_Module_1.currentP) annotation (Line(points={{40,22},
          {40,32},{88,32}},        color={85,170,255}));
  connect(pV_Module_2.currentP, Load4.pin_p) annotation (Line(points={{88,1.33227e-015},
          {88,0},{50,0},{50,-14},{56,-14}},color={85,170,255}));
  connect(pV_Module_3.currentP, Load5.pin_p) annotation (Line(points={{90,-40},{90,-40},{32,-40},{32,-56}},
                                       color={85,170,255}));
  connect(Step_20_pu.y, Grid1.v_set)
    annotation (Line(points={{-79,-42},{-66,-42},{-66,-4}}, color={0,0,127}));
  connect(Grid1.epp, Adapter.epp) annotation (Line(points={{-82,8},{-88,8},{-88,36},{-68,36}},
                              color={0,127,0}));
  connect(pV_Module_2.u, GlobalSolarRadiation.y) annotation (Line(points={{108.4,
          -1.33227e-015},{108.4,0},{128,0},{128,52},{145.2,52}}, color={0,0,127}));
  connect(pV_Module_3.u, GlobalSolarRadiation.y) annotation (Line(points={{110.4,-40},{128,-40},{128,52},{145.2,52}},
                                               color={0,0,127}));
  connect(pV_Module_1.u, GlobalSolarRadiation.y) annotation (Line(points={{108.4,
          32},{128,32},{128,52},{145.2,52}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{160,100}}), graphics={Text(
          extent={{-10,106},{86,58}},
          lineColor={28,108,200},
          textString="Expected Result: 
negative power flow at grid epp")}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test for distribution grid with various cables, loads and ideal current source as PV</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
</html>"),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{160,100}})),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput);
end TestLowVoltageGridWithPVModules;
