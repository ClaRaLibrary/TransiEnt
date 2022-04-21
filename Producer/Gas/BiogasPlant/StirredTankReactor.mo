within TransiEnt.Producer.Gas.BiogasPlant;
model StirredTankReactor "Model of a stirred tank reactor"



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

  extends TransiEnt.Basics.Icons.Model;
  extends TransiEnt.Basics.Icons.FixedBedReactor_L2;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var biogas "Medium of inflow gas and offGas in the pressure swing adsorber";
  final parameter Real M[biogas.nc]=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_realGas(biogas, biogas.nc) "Molar Masses of Biogas components";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Time t_res=20*24*3600 "Residence time of fluid in Reactor";
  parameter Modelica.Units.SI.Temperature T_target=310.15 "Temperature that is supposed to be present inside Reactor";

  parameter Modelica.Units.SI.Temperature T_in_min=278.15 "minimal Temperature of inflowing substrate to avoid freezing";
  parameter Boolean usePowerPort=true "True if power port shall be used";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.Temperature T_reac "Temperature inside Reactor";
  Modelica.Units.SI.Temperature T_in=if T_in_min > ambientTemperature then T_in_min else ambientTemperature "Temperature of inflowing substrate";
  Modelica.Units.SI.MassConcentration TSS "Concentration of dry matter in Substrate in kg/m³";
  Modelica.Units.SI.MassConcentration TSS_in "Concentration of dry matter in influent Substrate in kg/m³";
  Modelica.Units.SI.Pressure p "Pressure inside reactor";
  Modelica.Units.SI.Power P_el "Electric power of the reacotr";

  Modelica.Units.SI.VolumeFlowRate V_flow_in "Volume flow rate of inflowing Substrate";
  Modelica.Units.SI.MassFlowRate m_flow_in "Mass flow rate of inflowing Substrate";
  Modelica.Units.SI.VolumeFlowRate V_flow_out "Volume flow rate of outflowing Substrate";
  Modelica.Units.SI.MassFlowRate m_flow_out "Mass flow rate of outflowing Substrate";
  Modelica.Units.SI.VolumeFlowRate V_flow_gas "Volume flow rate of produced Gas";
  Modelica.Units.SI.MassFlowRate m_flow_gas "Mass flow rate of produced Gas";

  Modelica.Units.SI.Enthalpy H "Enthalpy of liquid and gas inside reactor";
  Modelica.Units.SI.HeatFlowRate derH=der(H) "Derivative of Enthalpy of liquid and gas inside reactor";
  Modelica.Units.SI.HeatFlowRate Q_flow_K;
  Modelica.Units.SI.HeatFlowRate Q_flow_EX;
  Modelica.Units.SI.HeatFlowRate Q_flow_L;
  Modelica.Units.SI.HeatFlowRate Q_flow_R "Heatflows due to convection, heat-exchange and reaction ";

  Modelica.Units.SI.MassFraction xi[biogas.nc - 1] "Mass composition of biogas";
  Modelica.Units.SI.MoleFraction x[biogas.nc - 1] "Molar composition of biogas";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________


  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=biogas) "RealOutput for the biogas mass flow rate" annotation (Placement(transformation(extent={{64,72},{80,88}})));

  TransiEnt.Basics.Interfaces.General.TemperatureIn ambientTemperature "RealInput for ambient temperature" annotation (Placement(transformation(extent={{116,-22},{84,10}}), iconTransformation(extent={{102,-8},{84,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner replaceable MaterialValues.SuspensionProperties_pT fluidProperties(
    p=p,
    T=T_reac,
    TSS=TSS,
    fluid=simCenter.fluid1,
    gamma=stirrer.gamma,
    eta_fixed=0.1,
    useFixedViscosity=false) "Modell " annotation (Placement(transformation(extent={{-30,68},{-10,88}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  MaterialValues.SuspensionProperties_pT fluidPropertiesIn(
    p=p,
    T=T_reac,
    fluid=simCenter.fluid1,
    gamma=stirrer.gamma,
    TSS=TSS_in,
    eta_fixed=0.1,
    useFixedViscosity=false) annotation (Placement(transformation(extent={{-30,34},{-10,54}})));
  inner replaceable Base.GeometryCSTR geometryCSTR(
    D_i=9.9,
    Height_tankWall=12.6,
    Height_tankCenter=13,
    Height_fluid=12,
    impellerRatio=1/3,
    d(displayUnit="m") = 0.1016,
    relativeImpellerHeight=1/5,
    D_o=10.2,
    d_i(displayUnit="mm") = 0.1016 - 2*0.003048) annotation (Placement(transformation(extent={{-82,48},{-62,68}})));

  TransiEnt.Components.Heat.PumpVLE_L1_simple pump(
    presetVariableType="m_flow",
    m_flow_fixed=20,
    m_flowInput=true,
    medium=simCenter.fluid1) annotation (Placement(transformation(extent={{-18,-88},{2,-68}})));

  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple heatPipe(
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    redeclare model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4,
    Delta_p_nom=1e4,
    N_cv=8,
    N_tubes=1,
    N_passes=8,
    length=10,
    initOption=208,
    diameter_i(displayUnit="mm") = geometryCSTR.d_i) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={50,-78})));

  HeatTransfer.ForcedConvection.HeatTransferInsideReactor_tubeBundle_array heatTransfer_tubeBundle(
    Re=stirrer.Re,
    D=geometryCSTR.D_i,
    d=geometryCSTR.d,
    C2=stirrer.C2) annotation (Placement(transformation(extent={{4,-36},{24,-16}})));

  Base.Control_m_flow control_m_flow(
    k_P=2,
    k_D=1000,
    k_I=1e-6,
    m_flow_min=5e-3,
    m_flow_max=10) annotation (Placement(transformation(extent={{-44,-64},{-24,-44}})));

  replaceable HeatTransfer.HeatTransferThroughCylinderWall heatTransferThroughCylinderWall(
    Re=stirrer.Re,
    xi=gas.xi,
    C1=stirrer.C1,
    thickness_topCover=0.3) annotation (Placement(transformation(extent={{24,-10},{48,10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 pipeWall(
    N_ax=heatPipe.N_cv,
    length=heatPipe.length,
    diameter_o=geometryCSTR.d,
    N_tubes=heatPipe.N_tubes,
    suppressChattering="True",
    stateLocation=2,
    diameter_i=geometryCSTR.d_i,
    redeclare model Material = MaterialValues.Materials.StainlessSteel,
    initOption=213) annotation (Placement(transformation(extent={{36,-60},{64,-50}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterIn(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{-92,-86},{-76,-70}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterOut(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{82,-86},{98,-70}})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-100,-10},{-80,10}})));
  replaceable Base.ADM1.ADM1_CSTR adm1(
    operationMode="mesophilic",
    T=T_reac,
    t_res=t_res,
    rho=fluidProperties.rho,
    ComponentInput=false,
    p_atm=p,
    An=20,
    S_su_in=0.24,
    S_aa_in=0.0011,
    S_fa_in=0.0010,
    S_va_in=0.1680,
    S_bu_in=0.390,
    S_pro_in=0.7454,
    S_ac_in=2.3467,
    S_h2_in=0,
    S_ch4_in=0,
    S_IC_in=32.3,
    S_IN_in=18.571429,
    S_I_in=8.49,
    X_c_in=0,
    X_ch_in=59.0555,
    X_pr_in=13.11,
    X_li_in=5.693,
    X_su_in=0.0855,
    X_aa_in=0.0637,
    X_fa_in=0.0670,
    X_c4_in=0.0280,
    X_pro_in=0.0135,
    X_ac_in=0.09,
    X_h2_in=0.043,
    X_I_in=40.2759,
    Cat=80,
    useBSM2=true,
    PetersenMatrix(redeclare Base.ADM1.Records.ADM1_parameters_manure_bulkowska Parameters)) annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{26,28},{46,48}})));

  Modelica.Blocks.Interfaces.RealOutput Concentrations[24] annotation (Placement(transformation(extent={{100,28},{120,48}})));
  replaceable Base.PitchedBladeImpeller stirrer(
    d=geometryCSTR.d_r,
    D=geometryCSTR.D_i,
    n=0.2,
    h=geometryCSTR.height_r,
    useBaffles=false,
    rho=fluidProperties.rho,
    eta=fluidProperties.eta,
    Z=2,
    alpha=0.78539816339745) annotation (Placement(transformation(extent={{-56,48},{-36,68}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power Power if usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-66,10},{-46,30}})));
  Modelica.Blocks.Sources.RealExpression P_el_set(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{-96,28},{-76,48}})));

  Modelica.Blocks.Sources.RealExpression targetTemperature(y=T_target) annotation (Placement(transformation(extent={{-84,-70},{-64,-50}})));

  Modelica.Blocks.Sources.RealExpression reactionTemperature(y=T_reac) annotation (Placement(transformation(extent={{-84,-36},{-64,-16}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature sludgeTemperature annotation (Placement(transformation(extent={{-30,-36},{-10,-16}})));

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gas(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    deactivateTwoPhaseRegion=true,
    vleFluidType=biogas,
    computeTransportProperties=true,
    p=p,
    T=T_reac,
    xi=biogas.xi_default) annotation (Placement(transformation(extent={{30,68},{50,88}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  T_reac = 293.15;
  //  TSS = 10;

equation
  x = {adm1.p_ch4,adm1.p_co2,adm1.p_h2o}/adm1.p "Molar composition is calculated by dividing partial pressure of component through total pressure";
  xi = TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x, M) "Conversion of Molar Composition to Mass Composition";
  TSS = adm1.VS + TSS_in - adm1.VS_in "volatile solids concentration in reactor plus ash that has the same concentration as in inflow";
  TSS_in = adm1.VS_in/0.8 "Volatile solids concentration makes up 80% of Total solids concentration";
  p = gasPortOut.p;

  V_flow_in = geometryCSTR.V_fluid/t_res;
  m_flow_in = V_flow_in*fluidProperties.rho;
  m_flow_out = V_flow_out*fluidProperties.rho;
  m_flow_gas = V_flow_gas*gas.d;
  V_flow_gas = adm1.q_gas_out;

  //Mass Balance
  m_flow_in = m_flow_out + m_flow_gas "closed Mass Balance: All Mass entering leaves either as liquid or as gas";

  //Energy Balance
  H = (geometryCSTR.V_fluid*fluidProperties.rho*fluidProperties.cp + geometryCSTR.V_gas*gas.d*gas.cp)*T_reac "Enthalpy inside reactor consists of Enthalpy contained within liquid phase and Enthalpy contained within gas phase";
  der(H) = Q_flow_K + Q_flow_EX + Q_flow_L + Q_flow_R + stirrer.P "instationary Enthalpy change due to mass exchange, heat exchange with the heating coil, heat losses via reactor walls, Reaction Energy and stirring Power";
  Q_flow_EX = -heatTransfer_tubeBundle.heat_fluid.Q_flow;
  Q_flow_L = heatTransferThroughCylinderWall.Q_flow_loss;
  Q_flow_K = m_flow_in*fluidPropertiesIn.cp*T_in - m_flow_out*fluidProperties.cp*T_reac - m_flow_gas*gas.cp*T_reac;
  Q_flow_R = adm1.Q_flow_R;

  //Power Port
  P_el = -stirrer.P;

  //Gas Port
  gasPortOut.m_flow = -m_flow_gas;
  gasPortOut.xi_outflow = xi;
  gasPortOut.h_outflow = gas.h;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(sludgeTemperature.port, heatTransfer_tubeBundle.heat_fluid) annotation (Line(points={{-10,-26},{5.2,-26}}, color={191,0,0}));
  connect(reactionTemperature.y, sludgeTemperature.T) annotation (Line(points={{-63,-26},{-32,-26}}, color={0,0,127}));
  connect(control_m_flow.T_reac, sludgeTemperature.T) annotation (Line(points={{-46,-48},{-52,-48},{-52,-26},{-32,-26}}, color={0,0,127}));
  connect(targetTemperature.y, control_m_flow.T_reac_target) annotation (Line(points={{-63,-60},{-46,-60}}, color={0,0,127}));
  connect(heatTransferThroughCylinderWall.InsideTemperature, sludgeTemperature.T) annotation (Line(points={{21.8182,0},{-52,0},{-52,-26},{-32,-26}}, color={0,0,127}));
  connect(pipeWall.innerPhase, heatPipe.heat) annotation (Line(
      points={{50,-60},{50,-74}},
      color={167,25,48},
      thickness=0.5));
  connect(heatTransfer_tubeBundle.heat_solid, pipeWall.outerPhase) annotation (Line(points={{22,-26},{50,-26},{50,-50}}, color={191,0,0}));
  connect(WaterIn, WaterIn) annotation (Line(
      points={{-84,-78},{-84,-78}},
      color={175,0,0},
      thickness=0.5));
  connect(heatTransferThroughCylinderWall.AmbientTemperature, ambientTemperature) annotation (Line(points={{50.1818,0},{72,0},{72,-6},{100,-6}}, color={0,0,127}));
  connect(WaterIn, pump.fluidPortIn) annotation (Line(
      points={{-84,-78},{-18,-78}},
      color={175,0,0},
      thickness=0.5));
  connect(adm1.Components, Concentrations) annotation (Line(points={{47,38},{110,38}}, color={0,0,127}));
  connect(P_el_set.y, Power.P_el_set) annotation (Line(points={{-75,38},{-62,38},{-62,32}}, color={0,0,127}));
  connect(epp, Power.epp) annotation (Line(
      points={{-90,0},{-90,20},{-66,20}},
      color={0,135,135},
      thickness=0.5));
  connect(control_m_flow.m_flow, pump.m_flow_in) annotation (Line(points={{-23,-54},{-16,-54},{-16,-67}}, color={0,0,127}));
  connect(pump.fluidPortOut, heatPipe.inlet) annotation (Line(
      points={{2,-78},{36,-78}},
      color={175,0,0},
      thickness=0.5));
  connect(heatPipe.outlet, WaterOut) annotation (Line(
      points={{64,-78},{90,-78}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (
    Placement(transformation(extent={{100,38},{120,58}})),
    Line(points={{-17,30},{10,30},{10,9},{40,9}}, color={0,0,127}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model of a stirred tank reactor. It produces a biogas massflow due to fermentation of organic materials.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortIn - vle fluid</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortOut - vle fluid</span></p>
<p>gasPortOut - real gas</p>
<p>epp - electric power port </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>It is important to check if the parameters of the record and inflow parameters of the adm1 model fit to each other so that only bsm2 parameters  or bulkowska parameters are used.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model was validated as part of a master thesis. The adm1 model used in this reactor and the heat components have been validated separately. For further information see master thesis of Philip Jahneke (Nov 2018), Hamburg. This model was tested in the chedk model Check_StirredTankReactor.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model Created by Philip Jahneke in Nov 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</span></p>
</html>"));
end StirredTankReactor;
