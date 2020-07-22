within TransiEnt.Components.Electrical.Grid.Check;
model TestPiModelQS "Model for testing a quasi stationary PiModel"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

     extends TransiEnt.Basics.Icons.Checkmodel;

  Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    f_boundary=50,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{-72,-10},{-92,10}})));
  Basics.Adapters.EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{-50,-10},{-30,10}})));

  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Electrical.Grid.PiModelQS PiModel(CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1) annotation (Placement(transformation(rotation=0, extent={{-6,-10},{14,10}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load1(R_ref=1e3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={44,0})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground
    annotation (Placement(transformation(extent={{58,-54},{78,-34}})));

equation
  connect(Adapter.epp, Grid.epp) annotation (Line(points={{-50,0},{-60,0},{-60,0},{-72,0}},
                               color={0,127,0}));
  connect(Adapter.voltageP, PiModel.pin_p1)
    annotation (Line(points={{-30,0},{-30,0},{-6,0}}, color={85,170,255}));
  connect(Load1.pin_n,Ground. pin) annotation (Line(points={{54,0},{68,0},{68,-26},{68,-34}},
                                   color={85,170,255}));
  connect(PiModel.pin_p2, Load1.pin_p)
    annotation (Line(points={{14.2,0},{24,0},{34,0}},
                                                    color={85,170,255}));
public
function plotResult

  constant String resultFileName = "TestPiModelQS.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"PiModel.pin_p1.v.re"}, range={0.0, 1.0, 200.0, 260.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 241}, y={"Load1.pin_p.v.re"}, range={0.0, 1.0, 200.0, 260.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 241}, y={"PiModel.pin_p1.i.re"}, range={0.0, 1.0, 0.2, 0.26}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-14,88},{82,40}},
          lineColor={28,108,200},
          textString="Expected Result: 
Voltage drop over Load 1 >> Voltage drop over line
Current approximately 0.23A")}),     Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for transmission line Pi-Modell with ohmic load</span></p>
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
end TestPiModelQS;
