within TransiEnt.Components.Electrical.Grid.Check;
model TestPiModel "Model for testing PiModel"
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

  Boundaries.Electrical.ApparentPower.ApparentPower Load(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    cosphi_boundary=0.7,
    P_el_set_const=100e3) annotation (Placement(transformation(extent={{44,10},{64,-10}})));
  PiModel Cable(CableType=Characteristics.LVCabletypes.K1,                                      l=100) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    f_boundary=50,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{-36,10},{-56,-10}})));
equation
  connect(Grid.epp, Cable.epp_p) annotation (Line(points={{-36,0},{-20,0},{-20,0},{-10,0}},       color={0,127,0}));
  connect(Cable.epp_n, Load.epp) annotation (Line(points={{10,0},{44,0},{44,0}},       color={0,127,0}));
public
function plotResult

  constant String resultFileName = "TestPiModel.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"Cable.epp_p.P", "Cable.epp_n.P"}, range={0.0, 1.0, -120000.0, 120000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 364}, y={"Cable.epp_p.f", "Cable.epp_n.f"}, range={0.0, 1.0, 44.0, 56.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PiModel using a source with a constant frequency and voltage together with a load</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestPiModel;
