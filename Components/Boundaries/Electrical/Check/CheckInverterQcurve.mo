within TransiEnt.Components.Boundaries.Electrical.Check;
model CheckInverterQcurve
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.InverterQcurve inverter_Qcurve(redeclare ComplexPowerAdvanced.Characteristics.Qcurve_380kV_a qcurve_generic) annotation (Placement(transformation(extent={{-68,28},{-48,48}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackBoundary(v_gen=380e3) annotation (Placement(transformation(extent={{80,28},{100,48}})));
  Modelica.Blocks.Sources.Constant const(k=-500e6) annotation (Placement(transformation(extent={{-88,58},{-68,78}})));
  inner TransiEnt.SimCenter simCenter(v_n=380e3) annotation (Placement(transformation(extent={{-66,-92},{-46,-72}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine(
    ChooseVoltageLevel=3,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2,
    l(displayUnit="km") = 5000) annotation (Placement(transformation(extent={{2,28},{22,48}})));

 // _____________________________________________
 //
 //           Functions
 // _____________________________________________

public
    function plotResult

    constant String resultFileName = "CheckInverterQcurve.mat";

    output String resultFile;

    algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots();
    createPlot(id=1, position={0, 0, 791, 733}, y={"inverter_Qcurve.epp.P","inverter_Qcurve.epp.Q"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

    end plotResult;

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(const.y, inverter_Qcurve.P_el_set) annotation (Line(points={{-67,68},{-62,68},{-62,48},{-58,48}}, color={0,0,127}));
  connect(transmissionLine.epp_p, inverter_Qcurve.epp) annotation (Line(
      points={{2,38},{-47.8,38}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine.epp_n, slackBoundary.epp) annotation (Line(
      points={{22,38},{80,38}},
      color={28,108,200},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check model for InverterQcurve</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(checkmodel)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jan-Peter Heckel (jan.heckel@tuhh.de), Feb 2019</p>
</html>"));
end CheckInverterQcurve;
