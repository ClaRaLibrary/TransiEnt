within TransiEnt.Components.Gas.HeatExchanger;
model HEXOneRealGasOuterTIdeal_L1 "Ideal heat exchanger for one real gas with heat port and fixed end temperature"

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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Heat_Exchanger;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the heat exchanger" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter SI.PressureDifference Delta_p=0 "Pressure loss in the medium" annotation(Dialog(group="Fundamental Definitions"));

  parameter String hEXMode="HeatingAndCooling" "Define if heating, cooling or both should be possible" annotation(choices(choice="HeatingAndCooling" "Heating and cooling", choice="HeatingOnly" "Heating only", choice="CoolingOnly" "Cooling only"),Dialog(group="Heat Transfer"));
  parameter Boolean use_T_fluidOutConst=true "true if constant T_fluidOut should be used" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_fluidOutConst=293.15 "Fixed constant temperature of the medium at its outlet" annotation (Dialog(group="Heat Transfer"));
  parameter SI.HeatFlowRate Q_flow_max=1e99 "Maximum heat flow rate" annotation (Dialog(group="Heat Transfer"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_fluidOutVar_set if not use_T_fluidOutConst annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,40})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=gasPortOut.h_outflow,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=inStream(gasPortIn.h_outflow),
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  Modelica.Blocks.Sources.Constant const(k=T_fluidOutConst) if use_T_fluidOutConst
                                         annotation (Placement(transformation(extent={{100,60},{80,80}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_fluidOut_ annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,40})));
public
  inner Summary summary(
    gasPortIn(
      mediumModel=medium,
      xi=inStream(gasPortIn.xi_outflow),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=inStream(gasPortIn.h_outflow),
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasPortOut.xi_outflow,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasPortOut.h_outflow,
      rho=gasOut.d),
    heat(Q_flow=heat.Q_flow, T=heat.T)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeHeat heat;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //mass balances
  gasPortIn.m_flow + gasPortOut.m_flow = 0;

  //pressure
  gasPortIn.p = gasPortOut.p + Delta_p;

  //energy balances
  gasOut.T = smooth(1,if (hEXMode=="HeatingOnly" and gasIn.T > T_fluidOut_) or (hEXMode=="CoolingOnly" and gasIn.T < T_fluidOut_) then gasIn.T else T_fluidOut_);
  heat.Q_flow = smooth(1,if (hEXMode=="HeatingOnly" and gasIn.T > T_fluidOut_) or (hEXMode=="CoolingOnly" and gasIn.T < T_fluidOut_) then 0 else min(max(-(gasPortIn.m_flow*inStream(gasPortIn.h_outflow) + gasPortOut.m_flow*gasPortOut.h_outflow),-Q_flow_max),Q_flow_max));
  //reverse flow
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);

  //compositions
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);
  //reverse flow
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_fluidOut_,T_fluidOutVar_set)  annotation (Line(points={{50,40},{100,40}}, color={0,0,127}));
  connect(T_fluidOut_,const. y) annotation (Line(points={{50,40},{70,40},{70,70},{79,70}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-26,14},{104,-16}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString="fixed T")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a simple model of a heat exchanger with one real gas and a heat port. The outlet temperature is given by a parameter or by an input. The calculated heat flow to reach that temperature can be limited by choosing heating or cooling only behavior.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The detailed heat transfer is not modeled, only an end temperature for the medium is given by a parameter (at outlet of the medium). There are no heat losses and no changes in composition of the medium. A constant limit for the transferable heat flow rate can be set and, if desired, heat transfer can be limited to only heating or only cooling. The model only works in the design flow direction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases and if the heat transfer is close to ideal conditions. Also, it has to be checked that the temperatures at the inlet and outlet are physically plausible (see 7.).</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the medium</p>
<p>gasPortOut: Outlet of the medium</p>
<p>heat: Heat port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids1.png\"/>: Heat flow transfered from the medium to the heat port</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy balance:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXOneFluidOuterT.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The plausability of the temperatures at inlet and outlet of the gas and the temperature of the heat port has to be checked. They have to fit to the chosen type of heat exchanger (e.g. concurrent or countercurrent). </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) in Sep 2019 (included variable outlet temperature and limited cooling or heating behavior)</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) in Mar 2020 (added maximum heat flow rate)</p>
</html>"));
end HEXOneRealGasOuterTIdeal_L1;
