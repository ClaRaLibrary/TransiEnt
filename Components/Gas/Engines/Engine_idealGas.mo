within TransiEnt.Components.Gas.Engines;
model Engine_idealGas "Motorblock for ideal gas combustion and choosable mechanical and thermal behavior"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Components.Gas.Engines.Base.PartialEngine_idealGas;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  parameter SI.SpecificEnthalpy NCV_const=40e6 "set to zero for composition dependent NCV calculation";
  parameter Real lambda=Specification.lambda;

  parameter SI.PressureDifference Delta_p_nom=1e5 "Nominal pressure drop in heat flow model";
  parameter SI.MassFlowRate m_flow_nom=heatFlowModel.simCenter.m_flow_nom "Nominal mass flow rate in heat flow model";

  //Initialization
  parameter Modelica.SIunits.Temperature T_init=293.15 "|Initialization||Initial temperature of medium in heat exchangers in heat flow model";
  parameter Modelica.SIunits.Pressure p_init=6e5 "|Initialization||Initial pressure of medium in heat exchangers in heat flow model";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.SpecificEnthalpy NCV=TransiEnt.Basics.Functions.GasProperties.getIdealGasNCV_xi(
      FuelMedium,
      inStream(gasPortIn.xi_outflow),
      NCV_const);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model CombustionModel = TransiEnt.Components.Gas.Combustion.FullConversion_idealGas constrainedby TransiEnt.Components.Gas.Combustion.Basics.CombustionBaseClass_idealGas "choose model for combustion" annotation (choicesAllMatching);
  replaceable model MechanicModel = TransiEnt.Components.Gas.Engines.Mechanics.StaticEngineMechanics constrainedby TransiEnt.Components.Gas.Engines.Mechanics.BasicEngineMechanics "choose model for mechanical behaviour" annotation (choicesAllMatching);
  replaceable model HeatFlowModel = TransiEnt.Components.Gas.Engines.HeatFlow.StaticHeatFlow constrainedby TransiEnt.Components.Gas.Engines.HeatFlow.BasicHeatFlow "choose model for heat provision" annotation (choicesAllMatching);

  CombustionModel combustionModel(final lambda=lambda) annotation (Placement(transformation(extent={{-36,24},{-6,56}})));
  MechanicModel mechanicModel                                          annotation (Placement(transformation(extent={{-36,-16},{-6,16}})));
  HeatFlowModel heatFlowModel(
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    T_init=T_init,
    p_init=p_init) annotation (Placement(transformation(extent={{-36,-62},{-6,-34}})));

equation
  if switch then
    //Energy flow rates
    Q_flow_fuel = P_el_set/mechanicModel.eta_el;
  else
    Q_flow_fuel = 0;
  end if;

  // Calculate massflowrate in FuelPort
  gasPortIn.m_flow = Q_flow_fuel/NCV;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(mechanicModel.P_el_set, P_el_set) annotation (Line(
      points={{-35.7,0},{-108,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mechanicModel.switch, switch) annotation (Line(
      points={{-35.7,-8},{-58,-8},{-58,-50},{-108,-50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mechanicModel.mpp, mpp) annotation (Line(
      points={{-5.85,-0.08},{84,-0.08},{84,0},{100,0}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(heatFlowModel.switch, switch) annotation (Line(
      points={{-36,-51.5},{-58,-51.5},{-58,-50},{-108,-50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(P_el_set, heatFlowModel.P_el_set) annotation (Line(
      points={{-108,0},{-80,0},{-80,-42.75},{-36,-42.75}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(heatFlowModel.TemperaturesOut, mechanicModel.TemperaturesIn) annotation (Line(
      points={{-15.2857,-34},{-15.45,-34},{-15.45,-15.84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasPortIn, combustionModel.gasPortIn) annotation (Line(
      points={{-100,40},{-66,40},{-36,40}},
      color={255,213,170},
      thickness=0.5));
  connect(mechanicModel.efficienciesOut, heatFlowModel.efficiencies) annotation (Line(points={{-27.15,-16.16},{-27.15,-24.06},{-27.1429,-24.06},{-27.1429,-34}}, color={0,0,127}));
  connect(combustionModel.gasPortOut, gasPortOut) annotation (Line(
      points={{-6,40},{0,40},{0,90},{-100,90}},
      color={255,213,170},
      thickness=0.5));
  connect(waterPortIn, heatFlowModel.waterPortIn) annotation (Line(
      points={{10,-100},{10,-58.5},{-6,-58.5}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortOut, heatFlowModel.waterPortOut) annotation (Line(
      points={{90,-100},{88,-100},{88,-37.5},{-6,-37.5}},
      color={175,0,0},
      thickness=0.5));
  annotation (
    defaultComponentName="engine",
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This engine model combines replaceable models for thermal, mechanical and chemical behaviour. There are different stages of modeling depth to be chosen in the parameter dialogue.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>As this is a composition of other models, the level of detail may differ with the chosen replaceable models.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>See replaceable models.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>fuelPort - connector to gas grid</p>
<p>exhaustPort - connector to the exhaust system (or environment)</p>
<p>waterOut / waterIn - supply and return ports for heating system</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Only the fuel mass flow rate is calculated directly in this model, giving</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-bYVjkrCt.png\" alt=\"m_flow=P/(eta_el*H_i)\"/></p>
<p>where the lower heating value is calculated by a function.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>For validation see the replaceable models.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2014</p>
<p>Edited by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end Engine_idealGas;
