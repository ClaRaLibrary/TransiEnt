within TransiEnt.Consumer.Gas.Control;
model GCVController "Gas adaptive controller with demanded enthalpy flow rate and gross calorific value as inputs and desired mass flow rate as output"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Controller|Type of controller";
  parameter Real k=1 "Controller|Gain for controller";
  parameter Real Ti=0.1 "Controller|Integrator time constant";
  parameter Real Td=0.1 "Controller|Derivative time constant";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput m_flow_is "Current hydrogen mass flow in kg/s"
                                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,106})));
  Modelica.Blocks.Interfaces.RealInput GCV_is "actual gross calorific value in J/kg" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,104})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_desired "Maximum power considering constraints" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput H_flow_set "Desired thermal power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

  Modelica.Blocks.Continuous.LimPID                                           LimPID(
    k=k,
    Ti=Ti,
    Td=Td,
    controllerType=controllerType,
    yMax=Modelica.Constants.inf,
    xi_start=30,
    yMin=0)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,0})));

  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-28,10},{-8,-10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //             Connect Statements
  // _____________________________________________

  connect(m_flow_is, LimPID.u_m) annotation (Line(points={{40,106},{40,-18},{20,-18},{20,-12}},
                                                                               color={0,0,127}));
  connect(LimPID.y, m_flow_desired) annotation (Line(points={{31,0},{110,0}}, color={0,0,127}));
  connect(H_flow_set, division.u1) annotation (Line(points={{-110,0},{-82,0},{-82,-6},{-30,-6}}, color={0,0,127}));
  connect(division.y, LimPID.u_s) annotation (Line(points={{-7,0},{8,0}}, color={0,0,127}));
  connect(GCV_is, division.u2) annotation (Line(points={{-40,104},{-40,104},{-40,6},{-30,6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model to controll mass flow rate by measured gross calorific value and given enthalpy flow rate input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(ToDo)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(ToDo)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(ToDo)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(ToDo)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(ToDo)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
</html>"));
end GCVController;
