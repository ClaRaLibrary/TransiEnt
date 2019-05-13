within TransiEnt.Components.Boundaries.Gas.Check;
model CheckGasflow_L1 "Model for testing the Gasflow_L1 model"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // ____________________________________________

  inner TransiEnt.SimCenter simCenter(redeclare Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  BoundaryRealGas_phxi                                 massFlowSink(
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=100000,
    variable_p=false,
    h_const=400e3,
    medium=simCenter.gasModel1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={36,22})));
  BoundaryRealGas_hxim_flow                                 massFlowSource(
    m_flow_const=0.1,
    m_flow_nom=0,
    p_nom=1000,
    variable_m_flow=false,
    variable_h=false,
    h_const=400e3,
    medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-58,12},{-38,32}})));
  Gasflow_L1                                       constantHeatflow_L1_1(p_drop=
       0, H_flow_const=5e3)
    annotation (Placement(transformation(extent={{-16,22},{4,42}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(massFlowSource.gasPort, constantHeatflow_L1_1.gasIn) annotation (Line(
      points={{-38,22},{-11,22}},
      color={255,255,0},
      thickness=1.5));
  connect(constantHeatflow_L1_1.gasOut, massFlowSink.gasPort) annotation (Line(
      points={{-1,22},{26,22}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the Gasflow_L1 model</p>
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
end CheckGasflow_L1;
