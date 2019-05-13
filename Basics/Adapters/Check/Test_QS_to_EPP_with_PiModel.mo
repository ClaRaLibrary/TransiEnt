within TransiEnt.Basics.Adapters.Check;
model Test_QS_to_EPP_with_PiModel "Model for testing an adapter from quasi stationary to epp pin"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  Components.Electrical.Grid.PiModelQS pIModel(CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1)
                                               annotation (Placement(transformation(extent={{-20,8},{0,28}})));
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
  connect(adapter_QS_to_EPP.epp_IN, Consumer.epp) annotation (Line(points={{30.175,17.09},{30.175,16},{60,16}},
                                                   color={0,127,0}));
  connect(Grid.epp, ePP_to_QS.epp) annotation (Line(points={{-66,18},{-63.95,18},{-63.95,18},{-52,18}},
                                            color={0,127,0}));
  connect(ePP_to_QS.voltageP, pIModel.pin_p1)
    annotation (Line(points={{-32,18},{-32,18},{-20,18}},
                                                      color={85,170,255}));
  connect(Q_step_20_pu.y, Consumer.Q_el_set) annotation (Line(points={{83,-30},{90,-30},{94,-30},{94,-6},{76,-6},{76,4}}, color={0,0,127}));
  connect(P_step_20_pu.y, Consumer.P_el_set) annotation (Line(points={{43,-28},{46,-28},{46,-4},{64,-4},{64,4}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                Icon(graphics,
                                     coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for an adapter from quasi stationary pin to epp (electric power port)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 20.04.2017</span></p>
</html>"));
end Test_QS_to_EPP_with_PiModel;
