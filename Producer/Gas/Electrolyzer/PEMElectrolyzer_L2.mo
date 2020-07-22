within TransiEnt.Producer.Gas.Electrolyzer;
model PEMElectrolyzer_L2 "PEMElectrolyzer_L2 Proton exchange membrane electrolyzer with selectable physics submodels"

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

 extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzer(P_el_n=Specification.P_el_n,P_el_max=Specification.P_el_max,T_out=Specification.T_out);

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  inner parameter SI.Temperature T_std=298.15 "STD temperature";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  //Temperature parameters
public
  inner parameter SI.Temperature T_amb=23 + 273.15 "K, ambient temperature" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_op_start=T_std "initial operating temperature of PEM Electrolyzer" annotation (Dialog(group="Initialization"));
  //parameter SI.Temperature T_op_n=273.15 + 60 "nominal operating temperature of PEM Electrolyzer";

  //Electrolyzer system specific parameters
protected
  inner parameter Integer n_cells=Specification.n_cells "Number of electrolysis cells in series";
  inner parameter Real alpha_an=Specification.alpha_an "Charge transfer coefficient for anode";
  inner parameter SI.Energy E_exc=Specification.E_exc "Activation energy for anode reaction";
  inner parameter SI.ChemicalPotential E_pro=Specification.E_pro "Temperature independent parameter for activation energy in proton transport";
  inner parameter SI.CurrentDensity i_dens_0_an_std=Specification.i_dens_0_an_std "Exchange current density at electrodes at T_std";
  inner parameter SI.Thickness t_mem=Specification.t_mem "PE membrane thickness";
  inner parameter SI.Conductivity mem_conductivity_ref=Specification.mem_conductivity_ref "Membrane conductivity value at T_std";
  inner parameter SI.Area PEM_area=Specification.PEM_area "Active surface area of electrolyzer cell electrodes";
  inner parameter SI.Current i_el_n=Specification.i_el_n "Nominal current of electrolyzer";
  inner parameter SI.ThermalResistance R_th=Specification.R_th "Thermal resistance of stack";
  inner parameter SI.HeatCapacity C_th=Specification.C_th "Lumped thermal capacitance of stack";
  parameter Real specificWaterConsumption=Specification.specificWaterConsumption "Mass of water per mass of hydrogen";
  inner parameter SI.Power P_el_pump=Specification.P_el_pump "pump el power consumption";
  inner parameter SI.Efficiency eta_pumpmotor=Specification.eta_pumpmotor "pump's motor electric efficiency";
  inner parameter SI.VolumeFlowRate V_flow_water=Specification.V_flow_water "water flow rate in cooling loop";
  inner parameter SI.PressureDifference Delta_p_pump=Specification.Delta_p_pump "total pump head";
  inner parameter SI.Temperature T_op_max=Specification.T_op_max "Max operating temp";
  inner parameter SI.Temperature T_cool_set=Specification.T_cool_set "Cooling trigger point";
  inner parameter SI.HeatFlowRate Q_flow_cool_max=Specification.Q_flow_cool_max "Maximum cooling power";

  //Model Configuration Parameters
public
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Medium model" annotation (Dialog(group="Fundamental Definitions"));
  inner parameter Integer whichInput=1 "Use current, current density, electric power, or mass_flow_H2 as input" annotation (Dialog(group="Fundamental Definitions"), choices(
      __Dymola_radioButtons=true,
      choice=1 "Current",
      choice=2 "Current Density",
      choice=3 "Electric Power",
      choice=4 "mass_flow_H2"));
  inner parameter Boolean userSetTemp=false "Use T_input as input" annotation (Dialog(group="Fundamental Definitions"), choices(
      __Dymola_radioButtons=true,
      choice=true "yes",
      choice=false "no"));
  parameter Real eta_inv_n=0.956 "nominal efficiency of the inverter" annotation (Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

public
  SI.Mass mass_H2(start=0, fixed=true) "Produced H2 mass";

  //Temperature modeling
  //The following must all be calculated in the Temperature model or else provided externally.
  inner SI.Temperature T_op "Operating stack temperature";

  //Power and energy, efficiency
  SI.Power P_el "Electric power consumed by the electrolyzer";
  SI.Efficiency eta_cond "Variable for modeling the effiiciency loss of the electrolyseur due to the needed power for the dryer and the water conditioning";
  SI.EnthalpyFlowRate H_flow_H2_GCV "H2 enthalpy flow rate out of electrolyzer, gross calorific value";
  SI.EnthalpyFlowRate H_flow_H2_NCV "H2 enthalpy flow rate out of electrolyzer, net calorific value";
  SI.Efficiency eta_NCV(min=0, max=1) "Efficiency of the electrolyzer based on NCV" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Efficiency eta_GCV(min=0, max=1) "Efficiency of the electrolyzer based on GCV" annotation (Dialog(group="Initialization", showStartAttribute=true));
  //Current
  inner SI.Current i_el_stack "Current across the electrolyzer stack";
  inner SI.CurrentDensity i_dens_a "Operating current density at anode";

  //Voltage and Overpotential Variables
  //The following must all be calculated in the Voltage model.
  inner SI.Voltage V_el_stack "PEM stack voltage" annotation (Dialog(group="Fundamental Definitions"));
  inner SI.Voltage V_cell "PEM cell voltage considering all included physical phenomena";
  inner SI.Voltage V_tn "or U_tn, Thermoneutral voltage (voltage at which reaction can occur without releasing any heat)";

  //Pressure modeling
  //The following must all be calculated in the Pressure model
  inner SI.Pressure gasPortPressure "pressure of hydrogen connected to gasPortOut";
  inner SI.Pressure pp_H2O "Pa, vapour pressure of water vapour, must always be converted to atm";
  inner SI.Pressure pp_H2 "Pa, partial pressure of H2, must always be converted to atm";
  inner SI.Pressure pp_O2 "Pa, partial pressure of O2, must always be converted to atm";
  inner SI.Pressure p_cat "Pressure at cathode (H2)";
  inner SI.Pressure p_an "Pressure at anode (O2)";
  //   inner SI.Pressure  p_sat "water saturation pressure";

  //Mass Transport modeling
  //The following must all be calculated in the Mass Flow model, or provided externally (m_flow_H2).
  inner SI.MassFlowRate m_flow_H2 "H2 mass flow rate out of electrolyzer";
  inner SI.MolarFlowRate n_flow_H2O "Molar consummation rate of water";
  inner SI.MolarFlowRate n_flow_H2 "Molar production rate of Hydrogen gas";
  inner SI.MolarFlowRate n_flow_O2 "Molar production rate of Oxygen gas";

  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Voltage V_cell "PEME cell voltage";
    input SI.Voltage V_stack "PEME stack voltage";
    input SI.Current i_stack "PEME current consumption";
    input SI.Temperature T_op "ambient temperature of electrolyzer operation";
    input SI.HeatFlowRate der_Q_cool "heat to coolant system";
    input SI.HeatFlowRate der_Q_loss "heat loss in PEM stack";
    input SI.HeatFlowRate W_pemwe "heat generated in PEM stack";
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Power H_flow_NCV "Produced enthalpy flow based on NCV";
    input SI.Power H_flow_GCV "Produced enthalpy flow based on GCV";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Mass mass_H2O "Consumed water mass";
    input SI.Efficiency eta_NCV "Efficiency based on NCV";
    input SI.Efficiency eta_GCV "Efficiency based on GCV";
    /*
    input SI.HeatFlowRate W_pump_BHP;
    input SI.HeatFlowRate W_pump_elec;
    input SI.HeatFlowRate W_pump_WHP;
    input SI.HeatFlowRate W_pump;
    input SI.HeatFlowRate W_lost;
    */
    /*
    input SI.Voltage V_ohmic "test ohmic OP";
    input SI.Voltage V_activation "test electrode OP";
    input SI.Voltage V_rev "rev cell voltage";
    input SI.Voltage V_nernst "nernst voltage";
    input Real R_mem "Membrane resistance";
    input Real mem_conductivity "mem_conductivity";
    input Real i_a "current density on anode";
    input Real i_0a "exchange current density on anode";
    */
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


  replaceable model electrolyzerVoltage = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.V_cell1
                                                                                                      constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.PartialV_cell
                                                                                                                                                                                      "Dynamic voltage behaviour of electrolyzer" annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-10},{-10,10}})));
  replaceable model electrolyzerTemperature = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Temperature.Temperature1
                                                                                                                   constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Temperature.PartialTemperature
                                                                                                                                                                                                        "Temperature model" annotation (
    Dialog(group="Fundamental Definitions"),
    Placement(transformation(extent={{10,-10},{30,10}})),
    choicesAllMatching=true);

  replaceable model electrolyzerPressures = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Pressures.Pressures1
                                                                                                             constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Pressures.PartialPressures
                                                                                                                                                                                                  "Pressure model" annotation (
    Dialog(group="Fundamental Definitions"),
    Placement(transformation(extent={{50,-10},{10,10}})),
    choicesAllMatching=true);

  replaceable model electrolyzerMassFlow = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow.MassFlow0thOrderDynamics
                                                                                               constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow.PartialMassFlow
                                                                                                                                                                                  "Mass flow model" annotation (
    Dialog(group="Fundamental Definitions"),
    Placement(transformation(extent={{90,-10},{50,10}})),
    choicesAllMatching=true);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Gas.Electrolyzer.Base.Specifications.AREVAGiner46kW Specification constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Specifications.BaseElectrolyzerL2Specification "Record containing technical data of electrolyzer system" annotation (
    Placement(transformation(extent={{-58,-98},{-38,-78}})),
    Dialog(tab="General", group="Specification"),
    choices(choicesAllMatching=true));

  electrolyzerVoltage voltage annotation (Placement(transformation(extent={{20,12},{34,26}})));

  electrolyzerTemperature temperature annotation (Placement(transformation(extent={{20,-12},{34,2}})));

  electrolyzerPressures pressure annotation (Placement(transformation(extent={{58,12},{44,26}})));

  electrolyzerMassFlow massFlow annotation (Placement(transformation(extent={{58,-12},{44,2}})));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput i_el_stack_set(displayUnit="A", final unit="A") if
                   whichInput==1 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={34,120})));

  Modelica.Blocks.Interfaces.RealInput i_dens_set(displayUnit="A/m2", final unit="A/m2") if
                          whichInput==2 annotation (Placement(transformation(
        extent={{-40,-20},{0,20}},
        rotation=270,
        origin={10,100})));

  Modelica.Blocks.Interfaces.RealInput P_el_set(
    final quantity="Power",
    displayUnit="W",
    final unit="W") if whichInput==3 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-38,120})));

  Modelica.Blocks.Interfaces.RealInput m_flow_H2_set(
    final quantity="MassFlowRate",
    displayUnit="kg/s",
    final unit="kg/s") if whichInput==4 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={58,120})));

  Modelica.Blocks.Interfaces.RealInput T_input(
    final quantity="Temperature",
    displayUnit="K",
    final unit="K") if userSetTemp annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-14,120})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));


protected
  Modelica.Blocks.Sources.Constant i_el_stack_set_(k=0) if not whichInput==1;
  Modelica.Blocks.Sources.Constant i_dens_set_(k=0) if not whichInput==2;
  Modelica.Blocks.Sources.Constant P_el_set_(k=0) if not whichInput==3;
  Modelica.Blocks.Sources.Constant m_flow_H2_set_(k=0) if not whichInput==4;

  Modelica.Blocks.Sources.Constant T_input_(k=0) if not userSetTemp;

  TransiEnt.Producer.Gas.Electrolyzer.Base.GetInputsElectrolyzerL2 getInputs annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,58})));

public
  inner Summary summary(
    outline(
      V_cell=V_cell,
      V_stack=V_el_stack,
      i_stack=i_el_stack,
      T_op=T_op,
      der_Q_cool=temperature.Q_flow_cooling,
      der_Q_loss=temperature.Q_flow_convective,
      W_pemwe=temperature.Q_flow_H2Oelectrolysis,
      P_el=P_el,
      W_el=collectCosts.W_el_demand,
      mass_H2=mass_H2,
      mass_H2O=specificWaterConsumption*mass_H2,
      eta_NCV=eta_NCV,
      eta_GCV=eta_GCV,
      H_flow_NCV=gasPortOut.m_flow*NCV_H2[end],
      H_flow_GCV=gasPortOut.m_flow*GCV_H2[end]),
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
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-34,-98},{-14,-78}})));

  /* //additional outline variables
      W_pump_BHP=temperature.W_pump_BHP,
      W_lost=temperature.W_lost,
      W_pump_elec=temperature.W_pump_elec,
      W_pump_WHP=temperature.W_pump_WHP,
      W_pump=temperature.W_pump,

      i_a=i_dens_a,
      i_0a=voltage.i_dens_0a,
      mem_conductivity=voltage.mem_conductivity,
      R_mem=voltage.R_mem,
      V_ohmic=voltage.V_ohmic,
      V_activation=voltage.V_activation,

      V_rev=voltage.V_rev,
      V_nernst=voltage.V_nernst
*/




  TransiEnt.Basics.Interfaces.General.TemperatureOut temperatureOut annotation (Placement(transformation(extent={{-66,-42},{-46,-22}})));
  Modelica.Blocks.Sources.RealExpression T_op_out(y=T_op) annotation (Placement(transformation(extent={{-100,-42},{-80,-22}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut excessHeatFlowOut annotation (Placement(transformation(extent={{-66,-64},{-46,-44}})));
  Modelica.Blocks.Sources.RealExpression Q_Flow_Cooling(y=temperature.Q_flow_cooling) "excess waste heat generated by electrolyzer system, actively cooled by default" annotation (Placement(transformation(extent={{-100,-64},{-80,-44}})));

  Modelica.Blocks.Tables.CombiTable1Ds EfficiencyCurve_Inverter(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=false,
    columns={2,2},
    table=[0.05,0.892;0.10,0.936;0.20,0.958;0.25,0.962;0.3,0.965;0.5,0.967;0.75,0.965;1,0.962])          annotation (Placement(transformation(extent={{-10,6},{10,26}})));

initial equation
  if userSetTemp == false then
    T_op = T_op_start;
  end if;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //GasPortOut
  gasPortOut.xi_outflow = xi_out;
  gasPortOut.h_outflow = vleFluidH2.h;
  gasPortOut.m_flow = -m_flow_H2;

  gasPortPressure = gasPortOut.p;
  Q_flow=-(temperature.Q_flow_cooling);

  if whichInput == 1 then
    //set current
    i_el_stack = getInputs.i_el_stack_set;
  elseif whichInput == 2 then
    //set current density
    i_dens_a = getInputs.i_dens_set;
  elseif whichInput == 3 then
    //set electric power
    P_el = getInputs.P_el_set;
  elseif whichInput == 4 then
    //set mass flow
    m_flow_H2 = getInputs.m_flow_H2_set;
  end if;

  if userSetTemp then
    T_op = getInputs.T_input;
  end if;

  if integrateH2Flow then
    der(mass_H2) = m_flow_H2;
  else
    mass_H2 = 0;
  end if;

  m_flow_H2O = specificWaterConsumption*m_flow_H2;




  //Power
  V_el_stack = V_cell*n_cells;
  i_el_stack = i_dens_a*PEM_area;
  P_el = (V_el_stack)*i_el_stack;
  EfficiencyCurve_Inverter.u=(P_el/(P_el_max));


  //Efficiency
  if P_el>0 then
  eta_cond=1-min((0.03*(P_el_n/P_el)),1);
  else
    eta_cond=1;
  end if;

  H_flow_H2_GCV = (m_flow_H2*(GCV_H2[end] + (vleFluidH2.h - h0)))*eta_cond*EfficiencyCurve_Inverter.y[1]/0.956 *eta_inv_n;
  H_flow_H2_NCV = (m_flow_H2*(NCV_H2[end] + (vleFluidH2.h - h0)))*eta_cond*EfficiencyCurve_Inverter.y[1]/0.956 *eta_inv_n;

  if P_el > 0 then
    eta_GCV = H_flow_H2_GCV/P_el;
    eta_NCV = H_flow_H2_NCV/P_el;
  else
    eta_GCV = 1;
    eta_NCV = eta_GCV;
  end if;

  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(i_el_stack_set_.y, getInputs.i_el_stack_set);
  connect(i_dens_set_.y, getInputs.i_dens_set);
  connect(P_el_set_.y, getInputs.P_el_set);
  connect(m_flow_H2_set_.y, getInputs.m_flow_H2_set);

  connect(T_input_.y, getInputs.T_input);

  connect(i_el_stack_set, getInputs.i_el_stack_set) annotation (Line(points={{34,120},{34,80},{4,80},{4,70},{3.6,70}}, color={0,0,127}));
  connect(i_dens_set, getInputs.i_dens_set) annotation (Line(points={{10,120},{10,82},{2,82},{2,70},{1,70}}, color={0,0,127}));
  connect(P_el_set, getInputs.P_el_set) annotation (Line(points={{-38,120},{-38,80},{-4,80},{-4,70}}, color={0,0,127}));
  connect(m_flow_H2_set, getInputs.m_flow_H2_set) annotation (Line(points={{58,120},{58,76},{6,76},{6,70},{6.6,70}}, color={0,0,127}));

  connect(T_input, getInputs.T_input) annotation (Line(points={{-14,120},{-14,82},{-1.4,82},{-1.4,70}}, color={0,0,127}));

  connect(temperatureOut, T_op_out.y) annotation (Line(points={{-56,-32},{-79,-32}},color={0,0,127}));
  connect(excessHeatFlowOut, Q_Flow_Cooling.y) annotation (Line(
      points={{-56,-54},{-79,-54}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation(defaultComponentName="electrolyzer",
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model electrolyzer uses modular physics classes and a Specification record to describe a real-life electrolyzer system. The default model uses physical relationships taken from (Espinosa-L&oacute;pez et al, 2018).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The user can select or create a model with system specific parameters. The desired input (electric power, current, current density or hydrogen mass flow) can be varied. Physics submodels can be replaced as desired, with essential definitions annotated. The water consumption, hydrogen output, and net- and gross-calorific energy conversion efficiency can be calculated. The user has the option of controlling pressure through gasPortOut and/or temperature through T_input as well.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electric power port, type can be chosen </p>
<p>gasPortOut: hydrogen outlet </p>
<p>i_dens_set: input for electric current density</p>
<p>i_el_stack_set: input for electric current</p>
<p>P_el_set: input for electric power </p>
<p>m_flow_H2_set: input for hydrogen mass flow </p>
<p>T_input: input for temperature</p>
<p>excessHeatFlowOut: Heat flow rate out port, equal to the cooling power used to regulate temperature at max temp.</p>
<p>temperatureOut: temperatureOut interface equal to operating temperature</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Selectable physics equations allow for different governing equations to be used, and consist of equations from (Espinosa-L&oacute;pez et al, 2018) by default.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against (Espinosa-L&oacute;pez et al, 2018) published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. Renewable Energy, 119, pp. 160-173, 2018. doi: 10.1016/J.RENENE.2017.11.081. </p>
<p>[2] efficiency curve of the inverter taken from the data sheet of SMA &quot;Technische Wirkungsgrade und Derating&quot; URL: https://files.sma.de/dl/1348/WirkungDerat-TI-de-46.pdf page 71, 26.11.2019</p>
<p>[3] J. Webster and C. Bode, &ldquo;Implementation of a Non-Discretized Multiphysics PEM Electrolyzer Model in Modelica,&rdquo; in Proceedings of the 13th International Modelica Conference, Regensburg, Germany, March 4&ndash;6, 2019, no. 157, pp. 833&ndash;840, DOI: 10.3384/ecp19157833.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by John Webster (jcwebste@edu.uwaterloo.ca) in October 2018</p>
<p>Model adjusted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in dec 2019</p>
</html>"));
end PEMElectrolyzer_L2;
