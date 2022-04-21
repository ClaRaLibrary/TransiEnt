within TransiEnt.Components.Heat.ElectricAirHeater.Check;
model TestElectricAirHeater


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
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

  ElectricAirHeater_L4                                electricHeater(
    redeclare model HeatTransferExternal = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.MineralWool, thickness=0.25),
    N_cv=3,
    m_flow_nom=12.5,
    timeConstant_air=60,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    T_nom=273.15 + 600,
    Delta_p_nom=500,
    T_start=fill(273.15 + 270, electricHeater.N_cv)) annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
    boundaryGas_Txim_flow(medium=simCenter.airModel,
    xi_const=simCenter.airModel.xi_default,
    T_const=273.15 + 200,
    variable_m_flow=false,
    m_flow_const(displayUnit="t/h") = 12.5)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(medium=
        simCenter.airModel, T_const=273.15 + 4.17,
    xi_const=simCenter.airModel.xi_default)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  inner TransiEnt.SimCenter
                        simCenter(T_amb=273.15 + 4.17)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=5.4e6,
    width=50,
    period=1200,
    nperiod=1,
    offset=0,
    startTime=60)  annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(electricHeater.outlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{20,0},{40,0}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryGas_Txim_flow.gas_a, electricHeater.inlet) annotation (Line(
      points={{-20,0},{0,0}},
      color={118,106,98},
      thickness=0.5));
  connect(electricHeater.epp, ElectricGrid.epp) annotation (Line(
      points={{10,-10},{10,-50},{20,-50}},
      color={0,135,135},
      thickness=0.5));
  connect(pulse.y, electricHeater.P_el_set) annotation (Line(points={{1,30},{10,30},{10,10.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,100},{4,52}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Check the outlet air temperature, 
as well as heat and pressure losses
in the summary")}),
    experiment(
      StopTime=1500,
      Tolerance=1e-05,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check electric heater model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
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
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de), Apr 2021</p>
</html>"));
end TestElectricAirHeater;
