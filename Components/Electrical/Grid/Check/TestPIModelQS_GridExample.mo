within TransiEnt.Components.Electrical.Grid.Check;
model TestPIModelQS_GridExample
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

  Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    f_boundary=50,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{-80,40},{-100,60}})));
  Basics.Adapters.EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{-76,40},{-56,60}})));

  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Electrical.Grid.PIModelQS Cable1(l=41, param=Characteristics.LV_K4()) annotation (Placement(transformation(rotation=0, extent={{-48,40},{-28,60}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load1(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={24,50})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground1
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  TransiEnt.Components.Electrical.Grid.PIModelQS Cable16(param=Characteristics.LV_K4(), l=24) annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-14,34})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable17(l=86, param=Characteristics.LV_K13()) annotation (Placement(transformation(rotation=0, extent={{12,8},{32,28}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load2(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={52,18})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground2
    annotation (Placement(transformation(extent={{64,-2},{84,18}})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable23(param=Characteristics.LV_K4(), l=191) annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-14,-6})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load3(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={26,-6})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground3
    annotation (Placement(transformation(extent={{38,-26},{58,-6}})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable29(l=66, param=Characteristics.LV_K13()) annotation (Placement(transformation(rotation=0, extent={{18,-40},{38,-20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load4(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={66,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground4
    annotation (Placement(transformation(extent={{78,-50},{98,-30}})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable30(param=Characteristics.LV_K4(), l=65) annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-14,-38})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable43(param=Characteristics.LV_K4(), l=287) annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-14,-74})));
  TransiEnt.Components.Electrical.Grid.PIModelQS Cable32(l=89, param=Characteristics.LV_K14()) annotation (Placement(transformation(rotation=0, extent={{12,-66},{32,-46}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load5(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={52,-56})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground5
    annotation (Placement(transformation(extent={{62,-76},{82,-56}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load6(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={22,-84})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground6
    annotation (Placement(transformation(extent={{32,-104},{52,-84}})));
equation
  connect(Adapter.voltageP, Cable1.pin_p1)
    annotation (Line(points={{-56,50},{-56,50},{-48,50}}, color={85,170,255}));
  connect(Grid.epp, Adapter.epp) annotation (Line(points={{-79.9,49.9},{-76,49.9},{-76,50}},
                                    color={0,127,0}));
  connect(Cable1.pin_p2, Load1.pin_p)
    annotation (Line(points={{-27.8,50},{-27.8,50},{14,50}},
                                                        color={85,170,255}));
  connect(Load1.pin_n, Ground1.pin)
    annotation (Line(points={{34,50},{50,50}}, color={85,170,255}));
  connect(Load2.pin_n, Ground2.pin)
    annotation (Line(points={{62,18},{64,18},{64,18},{66,18},{66,18},{74,18}},
                                               color={85,170,255}));
  connect(Cable17.pin_p2, Load2.pin_p)
    annotation (Line(points={{32.2,18},{32.2,18},{42,18}},
                                                       color={85,170,255}));
  connect(Load3.pin_n, Ground3.pin)
    annotation (Line(points={{36,-6},{48,-6}},         color={85,170,255}));
  connect(Cable16.pin_p2, Cable17.pin_p1) annotation (Line(points={{-14,23.8},{-14,23.8},{-14,18},{12,18}},
                               color={85,170,255}));
  connect(Cable23.pin_p2, Load3.pin_p) annotation (Line(points={{-14,-16.2},{-14,-16},{-14,-22},{8,-22},{8,-6},{16,-6}},
                                color={85,170,255}));
  connect(Cable29.pin_p1, Load3.pin_p) annotation (Line(points={{18,-30},{8,-30},{8,-6},{16,-6}},
                           color={85,170,255}));
  connect(Cable29.pin_p2, Load4.pin_p)
    annotation (Line(points={{38.2,-30},{38.2,-30},{56,-30}},
                                                          color={85,170,255}));
  connect(Load4.pin_n, Ground4.pin)
    annotation (Line(points={{76,-30},{82,-30},{88,-30}}, color={85,170,255}));
  connect(Cable16.pin_p1, Load1.pin_p)
    annotation (Line(points={{-14,44},{-14,50},{14,50}},color={85,170,255}));
  connect(Cable23.pin_p1, Cable16.pin_p2)
    annotation (Line(points={{-14,4},{-14,23.8}},       color={85,170,255}));
  connect(Cable23.pin_p2, Cable30.pin_p1)
    annotation (Line(points={{-14,-16.2},{-14,-20},{-14,-22},{-14,-28}},
                                                   color={85,170,255}));
  connect(Cable30.pin_p2, Cable43.pin_p1) annotation (Line(points={{-14,-48.2},{-14,-48.2},{-14,-64}},
                               color={85,170,255}));
  connect(Cable30.pin_p2, Cable32.pin_p1)
    annotation (Line(points={{-14,-48.2},{-14,-56},{12,-56}},
                                                          color={85,170,255}));
  connect(Load5.pin_n, Ground5.pin)
    annotation (Line(points={{62,-56},{68,-56},{72,-56}}, color={85,170,255}));
  connect(Cable32.pin_p2, Load5.pin_p)
    annotation (Line(points={{32.2,-56},{42,-56}},        color={85,170,255}));
  connect(Load6.pin_n, Ground6.pin)
    annotation (Line(points={{32,-84},{38,-84},{42,-84}}, color={85,170,255}));
  connect(Cable43.pin_p2, Load6.pin_p)
    annotation (Line(points={{-14,-84.2},{2,-84},{12,-84}},
                                                          color={85,170,255}));
public
function plotResult

  constant String resultFileName = "TestPIModelQS_GridExample.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"Load1.pin_p.v.re", "Load6.pin_p.v.re"}, range={0.0, 1.0, 229.92000000000002, 229.99}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-10,106},{86,58}},
          lineColor={28,108,200},
          textString="Expected Result: 
Voltage at load 6 slightly smaller than at load 1 
due to voltage drop along cables")}),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test for distribution grid with various cables and loads</span></p>
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
</html>"));
end TestPIModelQS_GridExample;
