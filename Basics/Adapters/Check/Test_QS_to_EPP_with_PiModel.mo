within TransiEnt.Basics.Adapters.Check;
model Test_QS_to_EPP_with_PiModel
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
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Consumer(
    cosphi_boundary=0.9,
    P_el_set_const=1e3,
    Q_el_set_const=100,
    useCosPhi=false,
    useInputConnectorP=true,
    useInputConnectorQ=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,16})));
  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Step P_step_20_pu(
    height=100,
    offset=1e3,
    startTime=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,-28})));

  Modelica.Blocks.Sources.Step Q_step_20_pu(
    height=50,
    offset=0,
    startTime=8) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,-30})));

  Components.Electrical.Grid.PIModelQS pIModel(param=TransiEnt.Components.Electrical.Grid.Characteristics.LV_K1()) annotation (Placement(transformation(extent={{-20,8},{0,28}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    f_boundary=50,
    v_boundary=230,
    Use_input_connector_f=false,
    Use_input_connector_v=false) annotation (Placement(transformation(extent={{-66,8},{-86,28}})));
  TransiEnt.Basics.Adapters.QS_to_EPP adapter_QS_to_EPP annotation (Placement(transformation(extent={{10,8},{30,26}})));
  EPP_to_QS ePP_to_QS
    annotation (Placement(transformation(extent={{-52,8},{-32,28}})));
equation
  connect(adapter_QS_to_EPP.currentP, pIModel.pin_p2) annotation (Line(points={{9.975,17},{9.975,18},{0.2,18}},
                                             color={85,170,255}));
  connect(adapter_QS_to_EPP.epp_IN, Consumer.epp) annotation (Line(points={{30.175,17.09},{30.175,16.1},{59.9,16.1}},
                                                   color={0,127,0}));
  connect(Grid.epp, ePP_to_QS.epp) annotation (Line(points={{-65.9,17.9},{-63.95,17.9},{-63.95,18},{-52,18}},
                                            color={0,127,0}));
  connect(ePP_to_QS.voltageP, pIModel.pin_p1)
    annotation (Line(points={{-32,18},{-32,18},{-20,18}},
                                                      color={85,170,255}));
  connect(Q_step_20_pu.y, Consumer.Q_el_set) annotation (Line(points={{83,-30},{90,-30},{94,-30},{94,-6},{76,-6},{76,4}}, color={0,0,127}));
  connect(P_step_20_pu.y, Consumer.P_el_set) annotation (Line(points={{43,-28},{46,-28},{46,-4},{64,-4},{64,4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">1. Purpose of model</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for Adapter from epp pin to quasi stationary</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">2. Level of detail, physical effects considered, and physical insight</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3. Limits of validity </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">4. Interfaces</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">5. Nomenclature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">6. Governing Equations</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">7. Remarks for Usage</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">8. Validation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">9. References</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">10. Version History</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 20.04.2017</span></p>
</html>"));
end Test_QS_to_EPP_with_PiModel;
