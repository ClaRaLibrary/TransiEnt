within TransiEnt.Producer.Gas.Electrolyzer;
model PEMElectrolyzer_L1 "Proton exchange membrane electrolyzer"

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

  import TransiEnt;
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Electrolyser2;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MassFraction xi_out[medium.nc-1]=zeros(medium.nc-1);
  constant SI.SpecificEnergy NCV_H2[1]=TransiEnt.Basics.Functions.GasProperties.getRealGasNCVVector(medium, medium.nc) "Net calorific value of hydrogen at 25 C and 1 bar";
  constant SI.SpecificEnergy GCV_H2[1]=TransiEnt.Basics.Functions.GasProperties.getRealGasGCVVector(medium, medium.nc) "Gross calorific value of hydrogen at 25 C and 1 bar";
  constant SI.SpecificEnthalpy h0= TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(medium, 1e5, 298.15) "Specific enthalpy at 25 C and 1 bar";
  final parameter EnergyResource typeOfResource=EnergyResource.Consumer "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Medium model" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "true if homotopy method is used during initialization" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_out=283.15 "Hydrogen output temperature" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_max=3*P_el_n "Maximum power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real specificWaterConsumption=10 "Mass of water per mass of hydrogen" annotation(Dialog(group="Fundamental Definitions")); //Stolzenburg, K. et al.: Integration von Wind-Wasserstoff-Systemen in das Energiesystem: Abschlussbericht, 2014

  parameter SI.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficiency refering to the GCV (min = 0, max = 1)" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min=0,max=1)" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer whichInput=1 "use P_el_set or m_flow_H2_set as input" annotation(Dialog(group="Fundamental Definitions"),choices(__Dymola_radioButtons=true, choice=1 "P_el_set", choice=2 "m_flow_H2_set"));

  parameter Boolean integrateH2Flow=false "true if hydrogen mass flow shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Statistics"));
  parameter Real Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free "Specific demand-related cost per cubic meter water" annotation (Dialog(group="Statistics"));
  parameter Boolean useLeakageMassFlow=false "Constant leakage gas mass flow of 'm_flow_small' to avoid zero mass flow"  annotation(Dialog(group="Numerical Stability"));
  parameter SI.MassFlowRate m_flow_small=simCenter.m_flow_small "leakage mass flow if useLeakageMassFlow=true" annotation(Dialog(group="Numerical Stability",enable=useLeakageMassFlow));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

protected
  SI.MassFlowRate m_flow_H2 "H2 mass flow rate out of electrolyzer";
public
  SI.Mass mass_H2(start=0, fixed=true) "produced H2 mass";
protected
  SI.MassFlowRate m_flow_water "water mass flow rate into the electrolyzer";
  SI.Power P_el "Electric power consumed by the electrolyzer";
  SI.Efficiency eta_NCV(min=0,max=1) "Efficiency of the electrolyzer based on NCV";
  SI.Efficiency eta_GCV(min=0,max=1)=charline.eta "Efficiency of the electrolyzer based on GCV";
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Power H_flow_NCV "Produced enthalpy flow based on NCV";
    input SI.Power H_flow_GCV "Produced enthalpy flow based on GCV";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Mass mass_H2O "Consumed water mass";
    input SI.Efficiency eta_NCV "Efficiency based on NCV";
    input SI.Efficiency eta_GCV "Efficiency based on GCV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                      constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                             "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);
public
  replaceable model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics        "Dynamic behavior of electrolyser" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true, Placement(transformation(extent={{-30,-10},{-10,10}})));

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (Dialog(group="Fundamental Definitions"), Placement(transformation(extent={{10,-10},{30,10}})), choicesAllMatching=true);
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if whichInput==1 "Electric power input (set value)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_H2_set if whichInput==2 "Hydrogen mass flow rate input (set value)"  annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort  epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation(choicesAllMatching=true, Dialog(group="Replaceable Components"), Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  Dynamics dynamics(final useHomotopy=useHomotopy, final P_el_n=P_el_n, final eta_n=eta_n) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Charline charline(final P_el_n=P_el_n, final eta_n=eta_n, final eta_scale=eta_scale) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  TILMedia.VLEFluid_pT vleFluidH2(
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true,
    p=gasPortOut.p,
    T=T_out,
    xi=xi_out) annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  Modelica.Blocks.Sources.Constant P_el_set_(k=0) if not whichInput==1;
  Modelica.Blocks.Sources.Constant m_flow_H2_set_(k=0) if not whichInput==2;

  TransiEnt.Producer.Gas.Electrolyzer.Base.GetInputsElectrolyzer getInputs annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,60})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource, integrateElPower=integrateElPower)
                                                                                                                                      annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    redeclare model CostRecordGeneral = CostSpecsGeneral,
    der_E_n=P_el_n,
    E_n=0,
    Cspec_demAndRev_el=Cspec_demAndRev_el,
    Cspec_demAndRev_other=Cspec_demAndRev_other,
    P_el=P_el,
    other_flow=m_flow_water,
    produces_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false,
    calculateCost=calculateCost)
                             annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
public
  inner Summary summary(
    outline(
      P_el=P_el,
      W_el=collectCosts.W_el_demand,
      H_flow_NCV=gasPortOut.m_flow*NCV_H2[1],
      H_flow_GCV=gasPortOut.m_flow*GCV_H2[1],
      mass_H2=mass_H2,
      mass_H2O=specificWaterConsumption*mass_H2,
      eta_NCV=eta_NCV,
      eta_GCV=eta_GCV),
    gasPortOut(
      mediumModel=medium,
      xi=vleFluidH2.xi,
      x=vleFluidH2.x,
      m_flow=-gasPortOut.m_flow,
      T=vleFluidH2.T,
      p=gasPortOut.p,
      h=vleFluidH2.h,
      rho=vleFluidH2.d),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));

  replaceable TransiEnt.Components.Boundaries.Electrical.Power powerBoundary constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.Power powerBoundary "PowerBoundary for ActivePowerPort"),choice( redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")), Dialog(group="Replaceable Components"), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,40})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) annotation (Placement(transformation(extent={{-72,52},{-52,72}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //ElectricPowerPort
  //epp.P = P_el;
  //GasPortOut
  gasPortOut.xi_outflow=xi_out;
  gasPortOut.h_outflow=vleFluidH2.h;
  if useLeakageMassFlow then
    gasPortOut.m_flow = -m_flow_H2-m_flow_small;
  else
    gasPortOut.m_flow=-m_flow_H2;
  end if;

  if whichInput==1 then
    P_el=getInputs.P_el_set;
  else
    m_flow_H2=getInputs.m_flow_H2_set;
  end if;

  if integrateH2Flow then
    der(mass_H2)=m_flow_H2;
  else
    mass_H2=0;
  end if;
  m_flow_water=specificWaterConsumption*m_flow_H2;
  eta_NCV=eta_GCV*NCV_H2[1]/GCV_H2[1];

  //Dynamics
  dynamics.H_flow_H2 = m_flow_H2 * (GCV_H2[1] + (vleFluidH2.h - h0));
  dynamics.P_el=P_el;
  dynamics.eta=eta_GCV;

  //Charline
  charline.P_el=P_el;

  //Collectors
  collectElectricPower.powerCollector.P=epp.P;

  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(P_el_set_.y, getInputs.P_el_set);
  connect(m_flow_H2_set_.y, getInputs.m_flow_H2_set);
  connect(P_el_set, getInputs.P_el_set) annotation (Line(points={{-40,120},{-40,80},{-4,80},{-4,72}}, color={0,0,127}));
  connect(getInputs.m_flow_H2_set, m_flow_H2_set) annotation (Line(points={{4,72},{4,80},{40,80},{40,120}}, color={0,0,127}));
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-38,40},{-60,40},{-60,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, powerBoundary.P_el_set) annotation (Line(points={{-51,62},{-34,62},{-34,52}}, color={0,0,127}));
  annotation(defaultComponentName="electrolyzer",
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for an electrolyzer with a replaceable efficiency curve and replaceable dynamic behavior. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiency curve, the dynamic behaviour and the wanted input (electric power or hydrogen mass flow) can be chosen. The water consumption is calculated using a constant factor. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electric power port, type can be chosen </p>
<p>gasPortOut: hydrogen outlet </p>
<p>P_el_set: input for electric power </p>
<p>m_flow_H2_set: input for hydrogen mass flow </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The hydrogen mass flow or the electric power is calculated depending on the given input and chosen efficiency curve and dynamic behavior. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Via parameter &apos;useLeakageMassFlow&apos; a small mass flow of &apos;m_flow_small&apos; is always flowing out of gas port (to avoid Zero-Mass-Flow problems)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in the check models &quot;TransiEnt.Producer.Gas.Electrolyzer.Check.TestPEMElectrolyzer_L1_Charline&quot; and &quot;TransiEnt.Producer.Gas.Electrolyzer.Check.TestPEMElectrolyzer_L1_Dynamics&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in March 2017</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Nov 2018: added useLeakageMassFlow</span></p>
</html>"));
end PEMElectrolyzer_L1;
