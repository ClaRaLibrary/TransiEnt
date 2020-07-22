within TransiEnt.Components.Electrical.Grid.Check;
model TestPiModelQS_SimpleGrid "Model for testing a quasi stationary PiModel in a simple grid"
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

  Boundaries.Electrical.ApparentPower.ApparentPower Grid(
    useInputConnectorP=false,
    P_el_set_const=-100e3,
    useInputConnectorQ=false,
    cosphi_boundary=0.7) annotation (Placement(transformation(extent={{-70,10},{-90,-10}})));
  Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid1(
    Use_input_connector_f=false,
    f_boundary=50,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{52,10},{72,-10}})));
  Basics.Adapters.EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{38,-10},{18,10}})));
  Basics.Adapters.QS_to_EPP Adapter1 annotation (Placement(transformation(rotation=0, extent={{-38,-10},{-58,10}})));
  PiModelQS pIModel_QS(l=1e3, CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1)
                              annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
equation
  connect(Adapter1.epp_IN, Grid.epp) annotation (Line(points={{-58.175,0.1},{-70,0.1},{-70,0}},       color={0,127,0}));
  connect(Adapter1.currentP, pIModel_QS.pin_p1) annotation (Line(points={{-37.975,0},{-18,0},{-18,0}}, color={85,170,255}));
  connect(Adapter.voltageP, pIModel_QS.pin_p2) annotation (Line(points={{18,0},{2.2,0},{2.2,0}}, color={85,170,255}));
  connect(Adapter.epp, Grid1.epp) annotation (Line(points={{38,0},{52,0},{52,0}},       color={0,127,0}));
public
function plotResult

  constant String resultFileName = "TestPIModelQS_SimpleGrid.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"pIModel_QS.pin_p2.v.re", "pIModel_QS.pin_p1.v.re"}, range={0.0, 1.0, -50.0, 250.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 364}, y={"Grid.epp.P", "Grid1.epp.P"}, range={0.0, 1.0, -300000.0, 50000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for a quasistationary PiModel in a simple grid</span></p>
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
</html>"));
end TestPiModelQS_SimpleGrid;
