within TransiEnt.Storage.Gas.Base;
partial model PartialGasStorage_L2 "Partial model of a simple gas storage volume for real gases"



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

  extends TransiEnt.Storage.Gas.Base.PartialGasStorage(includeHeatTransfer=true);
  import Modelica.Constants.pi;

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

  parameter SI.Height height=3.779*V_geo^(1/3) "Height of storage" annotation(Dialog(group="Geometry")); //based on height to diameter ratio 6.51:1

  parameter Boolean start_pressure=true "true if a start pressure is defined, false if a start mass is defined" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_gas_start=1e5 "pressure in storage at t=0" annotation(Dialog(group="Initialization"));
  parameter SI.ThermodynamicTemperature T_gas_start=283.15 "Temperature of gas in storage at t=0" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  replaceable model HeatTransfer =
    TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2
    constrainedby TransiEnt.Storage.Gas.Base.HeatTransferOuterTemperature_L2 "Heat transfer model for inside the storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasBulk(
    vleFluidType=medium,
    computeSurfaceTension=false,
    p=gasPortIn.p,
    h=h_gas,
    xi=xi_gas,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortIn.p,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,18},{10,38}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortOut.p,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));
public
  HeatTransfer heatTransfer(final A_heat=A_heat) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________


protected
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
    gasBulk.p = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.pressure_dTxi(
      vleFluidType=medium,
      d=m_gas_start/V_geo,
      T=T_gas_start,
      xi=gasBulk.xi);
  end if;

  gasBulk.T=T_gas_start;

equation
  p_gas = gasBulk.p;
  //der(m_gas)=gasPortIn.m_flow+gasPortOut.m_flow "Conservation of Mass";
  V_geo*drhodt=gasPortIn.m_flow+gasPortOut.m_flow "Conservation of Mass";

  //der(m_gas*(h_gas-p_gas/gasBulk.d)) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy";
  //der(m_gas)*(h_gas-p_gas/gasBulk.d) + m_gas*der(h_gas-p_gas/gasBulk.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy";
  //V_geo*drhodt*(h_gas - gasBulk.p/gasBulk.d) + m_gas*der(h_gas - gasBulk.p/gasBulk.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //creates the same results like the next but one equation for constant composition but different results for variable composition
  //V_geo*drhodt*h_gas - p_gas*V_geo*drhodt/gasBulk.d + m_gas*der(h_gas) - m_gas*der(p_gas/gasBulk.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //definitely wrong, produces wrong p and T curves
  //der(m_gas)*h_gas - p_gas*der(m_gas)/gasBulk.d + m_gas*der(h_gas) - m_gas*der(p_gas/gasBulk.d) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //definitely wrong, produces wrong p and T curves
  //der(m_gas)*h_gas - p_gas*der(m_gas)/(m_gas/V_geo) + m_gas*der(h_gas) - m_gas*der(p_gas/(m_gas/V_geo)) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //definitely wrong, produces wrong p and T curves
  V_geo*drhodt*h_gas - der(p_gas)*V_geo + m_gas*der(h_gas) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //formulation used in ClaRa pipe models
  //der(m_gas)*h_gas - der(p_gas)*V_geo + m_gas*der(h_gas) = gasPortIn.m_flow*actualStream(gasPortIn.h_outflow) + gasPortOut.m_flow*actualStream(gasPortOut.h_outflow) + Q_flow_ht "Conservation of Energy"; //formulation used in ClaRa pipe models
  //der(h_gas)=0;

  Q_flow_ht=if includeHeatTransfer then heatTransfer.heat.Q_flow else 0;
  gasBulk.d = m_gas/V_geo;
  gasPortOut.h_outflow=h_gas;
  gasPortOut.xi_outflow=gasBulk.xi;
  gasPortOut.p=gasBulk.p;

  gasPortIn.xi_outflow=xi_gas;
  gasPortIn.h_outflow=h_gas;

  heatTransfer.T_outer=gasBulk.T;

  H_flow_in_NCV=gasPortIn.m_flow*sum(NCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_NCV=gasPortOut.m_flow*sum(NCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));
  H_gas_NCV=m_gas*sum(NCV*cat(1,gasBulk.xi,{1-sum(gasBulk.xi)}));

  H_flow_in_GCV=gasPortIn.m_flow*sum(GCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_GCV=gasPortOut.m_flow*sum(GCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));
  H_gas_GCV=m_gas*sum(GCV*cat(1,gasBulk.xi,{1-sum(gasBulk.xi)}));

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
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={                                                       Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L2")},
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialGasStorage_L2;
