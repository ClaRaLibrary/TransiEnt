within TransiEnt.Components.Electrical.PowerTransformation.Check;
model CheckSimpleTransformer "Example how to use the power transformer model"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=12e3) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-43,0})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  SimpleTransformer transformer(
    eta=1,
    UseRatio=false,
    U_S=400,
    U_P=12e3)
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,0})));
  TransiEnt.Components.Electrical.Grid.PiModel Cable(CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1, l=100) annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Load(
    useInputConnectorQ=false,
    cosphi_boundary=0.7,
    P_el_set_const=100e3,
    useInputConnectorP=true) annotation (Placement(transformation(extent={{44,10},{64,-10}})));
  Modelica.Blocks.Sources.Step step(
    height=20e3,
    offset=100e3,
    startTime(displayUnit="s") = 100) annotation (Placement(transformation(extent={{18,-48},{38,-28}})));
equation
  connect(Cable.epp_n, Load.epp) annotation (Line(points={{30,0},{43.9,0},{43.9,0.1}}, color={0,127,0}));
  connect(step.y, Load.P_el_set) annotation (Line(points={{39,-38},{48,-38},{48,-12}}, color={0,0,127}));
  connect(transformer.epp_n, Cable.epp_p) annotation (Line(points={{0,0},{10,0}}, color={0,127,0}));
  connect(Grid.epp, transformer.epp_p) annotation (Line(points={{-34.92,-0.08},{-20,-0.08},{-20,0}}, color={0,127,0}));
public
function plotResult

  constant String resultFileName = "CheckSimpleTransformer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"transformer.epp_p.P", "Cable.epp_p.P"}, range={0.0, 100.0, 100000.0, 125000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"transformer.epp_p.v", "Cable.epp_p.v"}, range={0.0, 100.0, 0.0, 14000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"transformer.eta"}, range={0.0, 100.0, 0.8500000000000001, 1.1500000000000001}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end CheckSimpleTransformer;
