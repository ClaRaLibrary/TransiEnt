within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Pool;
model ExplicitFridgePool
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

  // Parameters:

  parameter TransiEnt.Basics.Types.Poolsize N=TransiEnt.Basics.Types.N20;
  parameter Integer nPar=9 "Number of varied parameters for matrix based pool simulations";

  parameter Boolean isExternalControl = false;
  parameter SI.Period samplePeriodPoolControl=3600 "Communication intervall between pool controller and heatpumpsystem unit";

  final parameter Real[N,nPar] A=Modelica_LinearSystems2.Internal.Streams.readMatrixInternal(
      Components.Base.getFileName(N),
      "A",
      N,
      nPar);

  final parameter TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base.ExplicitFridgeParameters[N] poolparams=Components.Base.ExplicitFridgeParameters(
      Tamb=A[:, 1] + fill(273.15, N),
      Tset=A[:, 2] + fill(273.15, N),
      cp=A[:, 3],
      m=A[:, 4],
      k=A[:, 5],
      DTdb=A[:, 6],
      COP=A[:, 7],
      T0=A[:, 8] + fill(273.15, N),
      x0=A[:, 9]);

  replaceable Components.ExplicitFridge[N] fridge(final params=poolparams, each T_amb=273.15 + simCenter.ambientConditions.temperature.value) constrainedby Components.ExplicitFridge(params=poolparams) annotation (Placement(transformation(extent={{-18,-20},{22,22}})),choicesAllMatching=true);

  // ==============================================================================================================================
  // Pool results and variables

  SI.Power P_el_n = sum(fridge.params.P_el_n);
  SI.Power P_el = sum(fridge.P_el);
  SI.Power P_el_star = P_el/P_el_n;
  SI.Power P_pot_pos = P_el;
  SI.Power P_pot_neg = P_el_n-P_el;
  Real SOC = sum(fridge.SOC)/N;
  Real COPmn = sum(fridge.COP_eff)/N;
  SI.Energy E_stor = sum(fridge.E_stor_total);
  SI.Time t_pos_max = min(fridge.t_pos_max);
  SI.Time t_neg_max = min(fridge.t_neg_max);

  inner TransiEnt.SimCenter simCenter(tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-50,100},{-70,80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),  Polygon(
          origin={24,14},
          lineColor={78,138,73},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}}),
        Rectangle(
          extent={{-40,44},{40,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-50,12},{-46,12},{-32,12},{-40,0},{-32,-10},{-50,-10},{-40,0},{-50,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,52},{18,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-36},{20,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,14},{54,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-6},{40,14},{50,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,26},{-22,-20},{26,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-18},{-18,-10},{-6,8},{-4,10},{4,16},{14,20},{22,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-150,-103},{150,-143}},
          lineColor={0,134,134},
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end ExplicitFridgePool;
