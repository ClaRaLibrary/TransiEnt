within TransiEnt.Consumer.Gas;
model GasDemandProfiler "Gas demand profile (H_flow or m_flow) composed of heat gas demand and base gas demand"



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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Model;
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid realGasModel=simCenter.gasModel1 "|General|Real gas model to be used (for calorific value calculation)";
  parameter Modelica.Units.SI.MassFraction[realGasModel.nc - 1] xi_in=realGasModel.xi_default "|General|Mass fractions of gas mixture (for calorific value calculation)";
  parameter Boolean mFlowOut=false "|General|Set to true to get gas mass flow instead of enthalpy flow rate as output";
  parameter Boolean variableBaseDemand=false "|General|Set to true for variable base gas demand";
  parameter Real f_gasDemand=1 "|General|Scaling factor for resulting gas demand";

  //Heat gas demand
  parameter Modelica.Units.SI.Heat Q_a=0.56*23e9*3.6e6 "|Gas heat demand|Annual heat demand";
  parameter Modelica.Units.SI.Efficiency eta_fuel=0.98 "|Gas heat demand|Average efficiency of combustion";
  parameter Modelica.Units.SI.SpecificEnthalpy NCV_in=46.84e6 "|Gas heat demand|Net calorific value of medium (set to zero for calculation by function)";
  final parameter Modelica.Units.SI.SpecificEnthalpy NCV=TransiEnt.Basics.Functions.GasProperties.getRealGasNCV_xi(
      realGasType=realGasModel,
      xi_in=xi_in,
      NCVIn=NCV_in) "|Gas heat demand|Net calorific value";
  parameter Modelica.Units.SI.SpecificEnthalpy GCV_in=51.77e6 "|Gas heat demand|Gross calorific value of medium (set to zero for calculation by function)";
  final parameter Modelica.Units.SI.SpecificEnthalpy GCV=TransiEnt.Basics.Functions.GasProperties.getRealGasGCV_xi(
      realGasType=realGasModel,
      xi_in=xi_in,
      GCVIn=GCV_in) "|Gas heat demand|Gross calorific value";

  parameter Real gasDemand_base_a=1.838698E+16 "|Gas base demand|Annual gas base demand in J (or kg if mFlowOut=true)";

  //Heat gas charline
  replaceable parameter TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH HeatCharLine constrainedby TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemand "|Heat demand charline||Choose City's Characteristic Line" annotation (choicesAllMatching);
  parameter Modelica.Units.SI.Heat Q_a_heatCharline=1.41806E+16 "|Heat demand charline||Integrated annual heat demand of heat charline (from weeklyHeatProfile.Q_flow)";
  parameter Real Damping_Weekend=0.95 "|Heat demand charline||Damping ratio for heat load at weekends (between 0 and 1)";
  parameter TransiEnt.Basics.Types.TypeOfWeekday BeginWeekday=2 "|Heat demand charline||Weekday on which simulation begins";
  parameter Real TransitionDuration=5 "|Heat demand charline||";
  parameter Modelica.Units.SI.Time t_start_week=6*86400 "|Heat demand charline||Time between simulation start and first monday (e.g. first day is a sunday)";
  parameter Modelica.Units.SI.Time t_hp_end=12441600 "|Heat demand charline||End of heating period in Hamburg in 2012 according to http://ecowetter.de/ort/heizgradtage/hamburg/2012.html";
  parameter Modelica.Units.SI.Time t_hp_start=22982400 "|Heat demand charline||Start of heating period in Hamburg in 2012 according to http://ecowetter.de/ort/heizgradtage/hamburg/2012.html";

  //Base gas profile
  parameter Real gasDemand_base_profile=baseGasDemand.offset*365*24*3600 "|Base gas demand||Integrated annual heat demand of the profile";
  parameter Real offset=1 "|Base gas demand||Offset of output signal";
  parameter Real amplitude=0.2 "|Base gas demand||Amplitude of sine wave";
  parameter Modelica.Units.SI.Frequency freqHz=1/86400 "|Base gas demand||Frequency of sine wave";
  parameter Modelica.Units.SI.Angle phase=0 "|Base gas demand||Phase of sine wave";
  parameter Modelica.Units.SI.Time startTime=0 "|Base gas demand||Output = offset for time < startTime";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real gasDemand_tot "Integrated gas demand in defined output";
  Real gasDemand_base "Integrated base gas demand in defined output";
  Real gasDemand_heat "Integrated heat gas demand in defined output";

protected
  Modelica.Units.SI.Heat Q_heatCharline;
  Modelica.Units.SI.Heat Q_heat;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  Modelica.Blocks.Interfaces.RealOutput gasDemandFlow annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  TransiEnt.Basics.Interfaces.General.TemperatureCelsiusIn T_amb annotation (Placement(transformation(extent={{-124,-20},{-84,20}}), iconTransformation(extent={{-124,-20},{-84,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
public
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(
    CharLine=HeatCharLine,
    Damping_Weekend=Damping_Weekend,
    BeginWeekday=BeginWeekday,
    TransitionDuration=TransitionDuration,
    final SummerDayTypicalHeatLoadCharLine=false,
    final offsetOn=false,
    final weekendOn=false) annotation (Placement(transformation(extent={{-74,14},{-56,33}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.WeeklyHeatProfile weeklyHeatProfile(
    t_start_week=t_start_week,
    t_hp_end=t_hp_end,
    t_hp_start=t_hp_start) annotation (Placement(transformation(extent={{-50,16},{-32,32}})));
protected
  Modelica.Blocks.Math.Gain gainGasDem(k=f_gasDemand)
                                                    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={84,0})));
  Modelica.Blocks.Math.Gain invNCV(k=1/NCV)      annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={6,62})));
  Modelica.Blocks.Math.Gain invEta(k=1/eta_fuel)
                                             annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-6,24})));
  Modelica.Blocks.Sources.Sine baseGasDemand(
    amplitude=amplitude,
    f=freqHz,
    phase=phase,
    offset=offset,
    startTime=startTime) annotation (Placement(transformation(extent={{-46,-58},{-30,-42}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{60,-6},{72,6}})));
  Modelica.Blocks.Logical.Switch MorHflow annotation (Placement(transformation(extent={{26,32},{46,52}})));
  Modelica.Blocks.Logical.Switch switchBaseDemand annotation (Placement(transformation(extent={{24,-20},{44,-40}})));
  Modelica.Blocks.Sources.BooleanExpression Mflow(y=mFlowOut)
                                                       annotation (Placement(transformation(extent={{-6,32},{14,52}})));
  Modelica.Blocks.Sources.BooleanExpression baseDemand(y=variableBaseDemand)
                                                            annotation (Placement(transformation(extent={{-48,-38},{-30,-22}})));
  Modelica.Blocks.Sources.Constant const(k=gasDemand_base_a/365/24/3600)
                                              annotation (Placement(transformation(extent={{-48,-16},{-32,0}})));

  Modelica.Blocks.Math.Gain GCVtoNCV(k=GCV/NCV) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={11,24})));
  Modelica.Blocks.Math.Gain HeatDemand(k=Q_a/Q_a_heatCharline)
                                                          annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-20,24})));

  Modelica.Blocks.Math.Gain BaseGasDemand(k=gasDemand_base_a/gasDemand_base_profile)
                                                             annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-16,-50})));
equation
  der(Q_heatCharline)=weeklyHeatProfile.Q_flow;
  der(Q_heat)=HeatDemand.y;

  der(gasDemand_tot)=gasDemandFlow;
  der(gasDemand_base)=switchBaseDemand.y;
  der(gasDemand_heat)=MorHflow.y;

  connect(heatingLoadCharline.Q_flow, weeklyHeatProfile.Q_flow_raw) annotation (Line(
      points={{-55.1,23.5},{-55.1,24},{-51.8,24}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(gainGasDem.y, gasDemandFlow) annotation (Line(points={{90.6,-8.88178e-016},{89.3,-8.88178e-016},{89.3,0},{106,0}}, color={0,0,127}));
  connect(gasDemandFlow, gasDemandFlow) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(add.y, gainGasDem.u) annotation (Line(points={{72.6,0},{76.8,0}},        color={0,0,127}));
  connect(Mflow.y, MorHflow.u2) annotation (Line(points={{15,42},{15,42},{24,42}},color={255,0,255}));
  connect(invEta.y, invNCV.u) annotation (Line(points={{-1.6,24},{2,24},{2,34},{-12,34},{-12,62},{-1.2,62}},       color={0,0,127}));
  connect(MorHflow.y, add.u1) annotation (Line(points={{47,42},{50,42},{50,16},{50,3.6},{58.8,3.6}},
                                                                                               color={0,0,127}));
  connect(switchBaseDemand.u2, baseDemand.y) annotation (Line(points={{22,-30},{22,-30},{-29.1,-30}},
                                                                                                  color={255,0,255}));
  connect(switchBaseDemand.y, add.u2) annotation (Line(points={{45,-30},{50,-30},{50,-3.6},{58.8,-3.6}},
                                                                                                   color={0,0,127}));
  connect(invEta.y, GCVtoNCV.u) annotation (Line(points={{-1.6,24},{5,24}}, color={0,0,127}));
  connect(weeklyHeatProfile.Q_flow, HeatDemand.u) annotation (Line(points={{-30.2,24},{-24.8,24}}, color={0,0,127}));
  connect(HeatDemand.y, invEta.u) annotation (Line(points={{-15.6,24},{-10.8,24}}, color={0,0,127}));
  connect(T_amb, heatingLoadCharline.T_amb) annotation (Line(points={{-104,0},{-74.9,0},{-74.9,24.45}}, color={0,0,127}));
  connect(GCVtoNCV.y, MorHflow.u3) annotation (Line(points={{16.5,24},{20,24},{20,34},{24,34}}, color={0,0,127}));
  connect(invNCV.y, MorHflow.u1) annotation (Line(points={{12.6,62},{18,62},{18,50},{24,50}}, color={0,0,127}));
  connect(const.y, switchBaseDemand.u3) annotation (Line(points={{-31.2,-8},{-2,-8},{-2,-22},{22,-22}}, color={0,0,127}));
  connect(baseGasDemand.y, BaseGasDemand.u) annotation (Line(points={{-29.2,-50},{-20.8,-50}},             color={0,0,127}));
  connect(BaseGasDemand.y, switchBaseDemand.u1) annotation (Line(points={{-11.6,-50},{-4,-50},{4,-50},{4,-38},{22,-38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-76,56},{-76,-56},{72,-56}},
          color={0,0,0}),
        Line(
          points={{-72,8}},
          pattern=LinePattern.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{-74,28},{-66,36},{-62,16},{-52,18},{-40,-12},{-30,-2},{-22,-24},{-6,-16},{0,-24},{4,-10},{20,-22},{32,-12},{40,-26},{44,-6},{50,20},{52,18},{60,14},{62,16},{68,26}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-70,-42},{68,-42}},
          color={255,200,0},
          thickness=0.5),
        Line(
          points={{-2,-30},{-2,-40}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-8,-35},{4,-35}},
          color={0,0,0},
          thickness=0.5)}),                                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Gas demand profiler with base load and heat gas demand.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasDemandFlow: RealOutput</p>
<p>T_amb: output for ambient temperature in [ &deg;C]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] http://ecowetter.de/ort/heizgradtage/hamburg/2012.html</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Jan 2017</p>
</html>"));
end GasDemandProfiler;
