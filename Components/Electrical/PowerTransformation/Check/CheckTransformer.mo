within TransiEnt.Components.Electrical.PowerTransformation.Check;
model CheckTransformer "Example how to use the power transformer model"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=12e3) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-49,0})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  TransiEnt.Components.Electrical.PowerTransformation.Transformer transformer(
    UseRatio=false,
    U_S=400,
    U_P=12e3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-16,0})));
  TransiEnt.Components.Electrical.Grid.PiModel Cable(CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1, l=100) annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Load(
    useInputConnectorQ=false,
    cosphi_boundary=0.7,
    P_el_set_const=100e3,
    useInputConnectorP=true) annotation (Placement(transformation(extent={{38,10},{58,-10}})));
  Modelica.Blocks.Sources.Step step(
    height=20e3,
    offset=100e3,
    startTime(displayUnit="s") = 100) annotation (Placement(transformation(extent={{12,-48},{32,-28}})));
equation
  connect(Cable.epp_n, Load.epp) annotation (Line(points={{24,0},{38,0},{38,0}},       color={0,127,0}));
  connect(step.y, Load.P_el_set) annotation (Line(points={{33,-38},{42,-38},{42,-12}}, color={0,0,127}));
  connect(transformer.epp_n, Cable.epp_p) annotation (Line(points={{-6,0},{4,0}}, color={0,127,0}));
  connect(Grid.epp, transformer.epp_p) annotation (Line(points={{-41,0},{-26,0},{-26,0}},            color={0,127,0}));
public
function plotResult

  constant String resultFileName = "CheckTransformer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"transformer.epp_p.P", "Cable.epp_p.P"}, range={0.0, 100.0, 2700000.0, 3400000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"transformer.epp_p.v", "transformer.epp_n.v"}, range={0.0, 100.0, 0.0, 14000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for Transformer</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4.Interfaces</span></b></p>
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
end CheckTransformer;
