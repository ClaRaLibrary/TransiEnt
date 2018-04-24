within TransiEnt.Storage.Gas.Base;
partial model PartialGasStorage_L2 "Partial model of a simple gas storage volume for real gases"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  import Modelica.Constants.pi;

  extends TransiEnt.Basics.Icons.StorageGenericGas;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.Diameter diameter=sqrt(4*V_geo/(pi*height)) "Diameter of storage";
  final parameter SI.Area A_heat=pi/2*diameter^2+pi*diameter*height "Surface area of storage";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  parameter SI.Volume V_geo=1 "geometric inner volume of the storage cylinder" annotation(Dialog(group="Geometry"));
  parameter SI.Height height=3.779*V_geo^(1/3) "Height of storage" annotation(Dialog(group="Geometry")); //based on height to diameter ratio 6.51:1

  parameter Boolean includeHeatTransfer=true "false for neglecting heat transfer" annotation(Dialog(group="Heat Transfer"));
  parameter SI.CoefficientOfHeatTransfer alpha_nom=4 "heat transfer coefficient inside the storage cylinder" annotation(Dialog(group="Heat Transfer"));

  parameter Boolean start_pressure=true "true if a start pressure is defined, false if a start mass is defined" annotation(Dialog(group="Initialization"));
  parameter SI.Mass m_gas_start=1 "stored gas mass at t=0" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_gas_start=1e5 "pressure in storage at t=0" annotation(Dialog(group="Initialization"));
  parameter SI.ThermodynamicTemperature T_gas_start=283.15 "Temperature of gas in storage at t=0" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model HeatTransfer =
    TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2
    constrainedby TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2 "Heat transfer model for inside the storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  replaceable model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                     constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                            "General Storage Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-10,39},{10,59}}), iconTransformation(extent={{-10,39},{10,59}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,-63},{10,-43}}), iconTransformation(extent={{-10,-73},{10,-53}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if
                                                         includeHeatTransfer annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Interfaces.RealOutput p_gas(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar") = gasBulk.p annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph gasBulk(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=h_gas,
    xi=xi_gas,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,18},{10,38}})));
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));
  HeatTransfer heatTransfer(alpha_nom=alpha_nom, A_heat=A_heat) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_gas=gasBulk.T "Gas temperature";
  SI.Mass m_gas "Stored gas mass";

protected
  SI.MassFraction xi_gas[medium.nc-1] "Mass composition of the gas";
  SI.SpecificEnthalpy h_gas "Specific enthalpy of gas in storage";
  SI.HeatFlowRate Q_flow_ht "Heat flow from the gas to the wall";
  Real drhodt "Time derivative of the density (unit kg/(m3s))";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
initial equation
  if start_pressure then
    gasBulk.p = p_gas_start;
  else
    gasBulk.p = TILMedia.VLEFluidFunctions.pressure_dTxi(
      vleFluidType=medium,
      d=m_gas_start/V_geo,
      T=T_gas_start,
      xi=gasBulk.xi);
  end if;

  h_gas=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
    vleFluidType=medium,
    p=gasBulk.p,
    T=T_gas_start,
    xi=gasBulk.xi);

equation
  //der(m_gas)=gasPortIn.m_flow+gasPortOut.m_flow "Conservation of Mass";
  V_geo*drhodt=gasPortIn.m_flow+gasPortOut.m_flow "Conservation of Mass";

  //der(m_gas)*(h_gas-gas.p/gas.d) + m_gas*der(h_gas-gas.p/gas.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy";
  //V_geo*drhodt*(h_gas - gasBulk.p/gasBulk.d) + m_gas*der(h_gas - gasBulk.p/gasBulk.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //creates the same results like the next but one equation for constant composition but different results for variable composition
  //V_geo*drhodt*h_gas - p_gas*V_geo/gasBulk.d*drhodt + m_gas*der(h_gas) - V_geo*der(p_gas) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //definitely wrong, produces wrong p and T curves
  V_geo*drhodt*h_gas - der(p_gas)*V_geo + m_gas*der(h_gas) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //formulation used in ClaRa pipe models

  Q_flow_ht=if includeHeatTransfer then heatTransfer.heat.Q_flow else 0;
  gasBulk.d = m_gas/V_geo;
  gasPortOut.h_outflow=h_gas;
  gasPortOut.xi_outflow=gasBulk.xi;
  gasPortOut.p=gasBulk.p;

  gasPortIn.xi_outflow=xi_gas;
  gasPortIn.h_outflow=h_gas;

  heatTransfer.T_outer=gasBulk.T;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatTransfer.heat, heat) annotation (Line(
      points={{-10,0},{-10,0},{40,0}},
      color={167,25,48},
      thickness=0.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a compressed gas storage for real gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model consists of a volume, in which the gas located. Pressure losses inside the volume and during charging and discharging are neglected. There is no discretisation of the flow field or the heat transfer. The heat transfer is modelled using a replacable heat transfer model, the default model uses a constant heat transfer coefficient.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid for negligible pressure losses and negligible changes of the heat transfer coefficient (other heat transfer models can be used). For high pressures there are errors due to errors in the gas models.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<p>heat: heat port for the heat flow into/out of the storage</p>
<p>p_storage: signal output of the gas pressure</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple mass and energy balances are used.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Wed Oct 07 2015</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (changes due to ClaRa changes: changed parameters)</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialGasStorage_L2;
