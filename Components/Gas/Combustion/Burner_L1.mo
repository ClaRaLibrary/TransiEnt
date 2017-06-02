within TransiEnt.Components.Gas.Combustion;
model Burner_L1 "Simple model of a burner with vle_ng7_sg gas"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.SpecificEnergy LHV_comp[medium.nc] = {50010,47480,46350,45720,0,0,0,10110,0,119952}*1e3 "Lower heating values of all components of vle_ng7_sg_o2"; //from Joos, F. Technische Verbrennung, 1. Auflage, 2006 S.899 (C4H10 als n-C4H10)
  constant SI.MolarMass M_comp[medium.nc] = {0.01604,0.03007,0.04401,0.05812,0.02801,0.04401,0.01802,0.02801,0.03200,0.00202} "Molar masses of all components of vle_ng7_sg_o2";

  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_O2_var medium "Medium in the burner";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.PressureDifference Delta_p=0 "Constant pressure loss" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_heat=1625 "Temperature of heat flow out of heat" annotation(Dialog(group="Heat Transfer"));

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
  TransiEnt.Basics.Interfaces.Thermal.HeatPort_b heat annotation (Placement(transformation(extent={{-10,88},{10,108}}), iconTransformation(extent={{-10,88},{10,108}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation(Placement(transformation(extent={{-90,-12},{-70,8}})));
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation(Placement(transformation(extent={{70,-12},{90,8}})));
public
  inner Summary summary(outline(
    Q_flow = heat.Q_flow,
    T_heat = heat.T,
    Delta_p = Delta_p),
    gasPortIn(mediumModel = medium,
          xi = gasIn.xi,
          x = gasIn.x,
          m_flow = gasPortIn.m_flow,
          T = gasIn.T,
          p = gasPortIn.p,
          h = gasIn.h,
          rho = gasIn.d),
    gasPortOut(mediumModel=medium,
          xi = gasOut.xi,
          x = gasOut.x,
          m_flow = -gasPortOut.m_flow,
          T = gasOut.T,
          p = gasPortOut.p,
          h = gasOut.h,
          rho = gasOut.d))   annotation (Placement(transformation(extent={{-100,-114},{-80,-94}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.SpecificEnergy LHV_total "Lower heating value of gas mixture";
  SI.MassFraction gasPortIn_xi_in10 "Instream mass fraction of the 10th component at gasPortIn";

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input SI.HeatFlowRate Q_flow "Heat flow rate";
    input SI.Temperature T_heat "Temperature of the heat port";
    input SI.PressureDifference Delta_p "Pressure loss";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  LHV_total = inStream(gasPortIn.xi_outflow)*LHV_comp[1:medium.nc-1]+gasPortIn_xi_in10*LHV_comp[medium.nc];

  gasPortIn_xi_in10=1-sum(inStream(gasPortIn.xi_outflow));

  gasPortOut.xi_outflow[1:4] = zeros(4); //CH4,C2H6,C3H8,C4H10
  gasPortOut.xi_outflow[5] = inStream(gasPortIn.xi_outflow[5]); //N2
  gasPortOut.xi_outflow[6] = inStream(gasPortIn.xi_outflow[6]) + M_comp[6]*(1*inStream(gasPortIn.xi_outflow[1])/M_comp[1] + 2*inStream(gasPortIn.xi_outflow[2])/M_comp[2] + 3*inStream(gasPortIn.xi_outflow[3])/M_comp[3] + 4*inStream(gasPortIn.xi_outflow[4])/M_comp[4] + 1*inStream(gasPortIn.xi_outflow[8])/M_comp[8]); //CO2
  gasPortOut.xi_outflow[7] = inStream(gasPortIn.xi_outflow[7]) + M_comp[7]*(2*inStream(gasPortIn.xi_outflow[1])/M_comp[1] + 3*inStream(gasPortIn.xi_outflow[2])/M_comp[2] + 4*inStream(gasPortIn.xi_outflow[3])/M_comp[3] + 5*inStream(gasPortIn.xi_outflow[4])/M_comp[4] + 1*gasPortIn_xi_in10/M_comp[10]); //H2O
  gasPortOut.xi_outflow[8] = 0; //CO
  gasPortOut.xi_outflow[9] = max(0,inStream(gasPortIn.xi_outflow[9]) - M_comp[9]*(2*inStream(gasPortIn.xi_outflow[1])/M_comp[1] + 7/2*inStream(gasPortIn.xi_outflow[2])/M_comp[2] + 5*inStream(gasPortIn.xi_outflow[3])/M_comp[3] + 13/2*inStream(gasPortIn.xi_outflow[4])/M_comp[4] + 1/2*inStream(gasPortIn.xi_outflow[8])/M_comp[8] + 1/2*gasPortIn_xi_in10/M_comp[10])); //O2

  gasPortOut.h_outflow = LHV_total + inStream(gasPortIn.h_outflow) + heat.Q_flow/gasPortIn.m_flow; //Q_flow<0
  heat.T=T_heat;

  gasPortIn.p=gasPortOut.p+Delta_p;
  gasPortIn.m_flow+gasPortOut.m_flow=0; //no mass storage

  //reverse flow
  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow=inStream(gasPortOut.xi_outflow);
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-66,-4},{-36,-64}},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-36,-28},{-38,-12},{-40,-6},{-42,0},{-42,6},{-42,14},{-40,20},{-42,28},{-44,34},{-50,40},{-50,28},{-52,18},{-54,8},{-56,2},{-58,-4},{-60,-10},{-62,-16},{-36,-28}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,-14},{-40,-58}},
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,-32},{-42,-22},{-42,-16},{-42,-10},{-44,-4},{-44,4},{-44,10},{-44,20},{-44,26},{-48,32},{-48,22},{-48,16},{-50,8},{-52,0},{-56,-10},{-58,-18},{-60,-24},{-40,-32}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-58,-26},{-44,-52}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,-38},{-44,-30},{-46,-20},{-46,-12},{-46,-2},{-48,4},{-50,-4},{-52,-10},{-54,-18},{-56,-26},{-58,-36},{-44,-38}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-12,-14},{18,-74}},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{18,-38},{16,-22},{14,-16},{12,-10},{12,-4},{12,4},{14,10},{12,18},{10,24},{4,30},{4,18},{2,8},{0,-2},{-2,-8},{-4,-14},{-6,-20},{-8,-26},{18,-38}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-8,-24},{14,-68}},
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{14,-42},{12,-32},{12,-26},{12,-20},{10,-14},{10,-6},{10,0},{10,10},{10,16},{6,22},{6,12},{6,6},{4,-2},{2,-10},{-2,-20},{-4,-28},{-6,-34},{14,-42}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-4,-36},{10,-62}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{10,-48},{10,-40},{8,-30},{8,-22},{8,-12},{6,-6},{4,-14},{2,-20},{0,-28},{-2,-36},{-4,-46},{10,-48}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,6},{-8,-54}},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-8,-18},{-10,-2},{-12,4},{-14,10},{-14,16},{-14,24},{-12,30},{-14,38},{-16,44},{-22,50},{-22,38},{-24,28},{-26,18},{-28,12},{-30,6},{-32,0},{-34,-6},{-8,-18}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,-4},{-12,-48}},
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-12,-22},{-14,-12},{-14,-6},{-14,0},{-16,6},{-16,14},{-16,20},{-16,30},{-16,36},{-20,42},{-20,32},{-20,26},{-22,18},{-24,10},{-28,0},{-30,-8},{-32,-14},{-12,-22}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-30,-16},{-16,-42}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-16,-28},{-16,-20},{-18,-10},{-18,-2},{-18,8},{-20,14},{-22,6},{-24,0},{-26,-8},{-28,-16},{-30,-26},{-16,-28}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{16,-8},{46,-68}},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{46,-32},{44,-16},{42,-10},{40,-4},{40,2},{40,10},{42,16},{40,24},{38,30},{32,36},{32,24},{30,14},{28,4},{26,-2},{24,-8},{22,-14},{20,-20},{46,-32}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-18},{42,-62}},
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{42,-36},{40,-26},{40,-20},{40,-14},{38,-8},{38,0},{38,6},{38,16},{38,22},{34,28},{34,18},{34,12},{32,4},{30,-4},{26,-14},{24,-22},{22,-28},{42,-36}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{24,-30},{38,-56}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{38,-42},{38,-34},{36,-24},{36,-16},{36,-6},{34,0},{32,-8},{30,-14},{28,-22},{26,-30},{24,-40},{38,-42}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{44,8},{74,-52}},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{74,-18},{72,-2},{70,4},{68,10},{68,16},{68,24},{70,30},{68,38},{66,44},{60,50},{60,38},{58,28},{56,18},{54,12},{52,6},{50,0},{48,-6},{74,-18}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{48,-4},{70,-48}},
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{70,-22},{68,-12},{68,-6},{68,0},{66,6},{66,14},{66,20},{66,30},{66,36},{62,42},{62,32},{62,26},{60,18},{58,10},{54,0},{52,-8},{50,-14},{70,-22}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{52,-16},{66,-42}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{66,-28},{66,-20},{64,-10},{64,-2},{64,8},{62,14},{60,6},{58,0},{56,-8},{54,-16},{52,-26},{66,-28}},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
          Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a simple model of a combustion chamber. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The combustion is assumed to be ideal so all the combustable components of the entering gas mixture are combusted 100%. Also a heat transfer is considered, a desired heat flow can be taken out of the system. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>This model is only valid if the share of uncombusted components is negligible. Also, it has to be ensured that there is enough oxygen for a complete combustion and the model only works with the real gas medium NG7_SG_O2. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet of the mixture of fuel and air/oxygen </p>
<p>gasPortOut: outlet of the exhaust gas </p>
<p>heat: heat port </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_Burner1.png\" alt=\"\"/>: Mass fraction, molar mass, lower heating value, heat flow out of the combustion chamber, specific enthalpy, mass flow </p>

<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The outflowing mass fractions are determined using the stochiometry of the combustion reactions:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_Burner2.png\" alt=\"\"/></p>
The lower heating value of the mixture is calculated using the LHV of the components and with this and the outflowing heat flow, the outflowing specific enthalpy is calculated:
<p><img src=\"modelica://TransiEnt/Images/equations/equation_Burner3.png\" alt=\"\"/></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>It has to be ensured that there is enough oxygen for a complete combustion. Also, the outlet temperature has to be below the limit of the TILMedia fluid models. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end Burner_L1;
