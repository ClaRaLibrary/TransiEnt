within TransiEnt.Grid.Gas.Controller;
model MaxH2MassFlow_phi "Model for calculation of maximum admissible mass flow rate of hydrogen from specified volumetric percentage at STP"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends TransiEnt.Basics.Icons.Sensor;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used";
  parameter Modelica.Units.SI.VolumeFraction phi_H2max=simCenter.phi_H2max "Maximum admissible volume fraction of H2 in NGH2 at STP";
  //parameter Modelica.SIunits.MassFlowRate m_flow_H2_max_start = 2.115;

protected
  constant SI.Pressure p_stp = 1.01325e5 "Standard pressure";
  constant SI.Temperature T_stp = 273.15 "Standard temperature";
  constant SI.Density rho_H2_stp = 0.08989 "Density of hydrogen at STP";

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________
  //protected
public
 SI.MassFraction xi_H2inNG "Mass fraction of H2 in NG";
 SI.VolumeFlowRate V_flow_NG_stp "Volume flow rate of NG at STP";
 SI.VolumeFlowRate V_flow_H2_NG_stp "Volume flow rate of H2 in NG at STP";
 SI.VolumeFlowRate V_flow_H2_PtG_max_stp "Maximum admissible PtG volume flow rate at STP";
 SI.MassFlowRate m_flow_NG "Mass flow of NG";
 SI.VolumeFraction phi_H2_stp "Volume fraction of H2 in NG at STP";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
public
  output TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_H2_max "Maximum admissible hydrogen production rate" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,90})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Input port for natural gas" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "output port for natural gas" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //       Instances of other Classes
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleGasNG_STP(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    T=T_stp,
    p=p_stp,
    xi=inStream(gasPortIn.xi_outflow),
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-70,-8},{-50,12}})));

//initial equation
//   m_flow_H2_max = m_flow_H2_max_start;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // calculate maximum admissible mass flow rate
  xi_H2inNG =(1.0 - sum(vleGasNG_STP.xi));
  V_flow_NG_stp =m_flow_NG/vleGasNG_STP.d;
  V_flow_H2_NG_stp = xi_H2inNG * m_flow_NG / rho_H2_stp;
  V_flow_H2_PtG_max_stp = (phi_H2max * V_flow_NG_stp - V_flow_H2_NG_stp)/(1-phi_H2max);
  m_flow_H2_max = V_flow_H2_PtG_max_stp * rho_H2_stp;

  // just for display purpose
  m_flow_NG = gasPortIn.m_flow;
  phi_H2_stp = V_flow_H2_NG_stp / V_flow_NG_stp;

  // isenthalpic
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  gasPortOut.h_outflow = inStream(gasPortIn.h_outflow);
  // no chemical reaction
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);
  // mass conservation
  gasPortIn.m_flow + gasPortOut.m_flow = 0;
  // no pressure loss
  gasPortIn.p = gasPortOut.p;

  annotation (defaultComponentName="maxH2MassFlow",Diagram(graphics,
                                                           coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{18,76},{218,106}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow_H2_max > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" m_flow_H2_max ", realString(m_flow_H2_max, 1,3)+" kg/s"))}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for determination of permitted maximum additional hydrogen mass flow in analyzed natural gas flow.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">Two inputs: gas inlet and gas outlet</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">One output: signal output of maximum permitted hydrogen mass flow</span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<ul>
<li><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-EHZf7HLO.png\" alt=\"phi\"/><span style=\"font-family: MS Shell Dlg 2;\">: volume fraction</span></li>
<li><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-EWsxBkvF.png\" alt=\"xi\"/><span style=\"font-family: MS Shell Dlg 2;\">: weight fraction</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">STP: standard temperature and pressure (Tstp=273.15 K, pstp=1.01325 bar)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">NG: gas mixture before feedin</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">NGH2: gas mixture after feedin</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">H2inNG: hydrogen in gas mixture before feedin</span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Isenthalpic, no chemical reactions, no pressure losses, conservation of mass.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mass balances for feedin point:</span></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-CEHWt51z.png\" alt=\"m_flow_NGH2max=m_flow_H2max+m_flow_NG\"/></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-UYdR4hJi.png\" alt=\"xi_H2max*m_flow_NGH2max=m_flow_H2max+xi_H2*m_flow_NG\"/></p>
<p>The same for volume balances plus the relation between mass and volume:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-sTh1HUqk.png\" alt=\"V_flow_stp=m_flow/rho_stp\"/></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gives the stated relations.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Hydrogen has to be the last entry of medium column vector.</span></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.Gas.Check.GasDemandVarH2_varGCV_controlMFlow&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Christopher Helbig, Dec 2014</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model edited and revised by by Lisa Andresen (andresen@tuhh.de), Jul 2016</span></p>
</html>"));
end MaxH2MassFlow_phi;
