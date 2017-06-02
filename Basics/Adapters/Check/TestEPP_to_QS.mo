within TransiEnt.Basics.Adapters.Check;
model TestEPP_to_QS
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
   extends TransiEnt.Basics.Icons.Checkmodel;
  Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    f_boundary=50,
    v_boundary=230,
    Use_input_connector_v=true,
    Use_input_connector_f=true) annotation (Placement(transformation(extent={{-34,-44},{-54,-24}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Resistor(R_ref=53)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={38,-44})));
  EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{-10,-44},{10,-24}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Inductor Inductance(L=0.386)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={62,-44})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{52,-82},{72,-62}})));
  Modelica.Blocks.Sources.Step Voltage_step_10_pu(
    height=23,
    offset=230,
    startTime=50) annotation (Placement(transformation(extent={{-76,-4},{-56,16}})));
  Modelica.Blocks.Sources.Step Frequency_step_5_pu(
    height=2.5,
    offset=50,
    startTime=100) annotation (Placement(transformation(extent={{-6,-10},{-26,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(Adapter.epp, Grid.epp) annotation (Line(points={{-10,-34},{-10,-34.1},{-33.9,-34.1}},
                       color={0,127,0}));
  connect(Adapter.voltageP, Resistor.pin_p) annotation (Line(points={{10,-34},{10,-34},{38,-34}},
                                      color={85,170,255}));
  connect(Resistor.pin_p, Inductance.pin_p) annotation (Line(points={{38,-34},{50,-34},{62,-34}},
                              color={85,170,255}));
  connect(Resistor.pin_n, Inductance.pin_n) annotation (Line(points={{38,-54},{38,-62},{62,-62},{62,-54}},
                                       color={85,170,255}));
  connect(Resistor.pin_n, ground.pin) annotation (Line(points={{38,-54},{38,-62},{62,-62}},
                          color={85,170,255}));
  connect(Voltage_step_10_pu.y, Grid.v_set) annotation (Line(points={{-55,6},{-50,6},{-50,4},{-50,-22}},    color={0,0,127}));
  connect(Frequency_step_5_pu.y, Grid.f_set) annotation (Line(points={{-27,0},{-38.6,0},{-38.6,-22}},   color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{20,58},{78,48}},
          lineColor={28,108,200},
          textString="Look at:
Grid.epp.f

Grid.epp.v

Grid.epp.P
Grid.epp.Q")}),                 Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for Adapter from epp pin to quasi stationary</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 20.04.2017</span></p>
</html>"),
    experiment(StopTime=150),
    __Dymola_experimentSetupOutput);
end TestEPP_to_QS;
