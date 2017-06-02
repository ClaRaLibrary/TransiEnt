within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
model ScheduleActivation "Activation of Secondary Control without discrete time behaviour that works only if the bandwidths are set by the external scheduler"
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

  extends TransiEnt.Grid.Electrical.SecondaryControl.Activation.PartialActivationType;

  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  parameter SI.Time samplePeriod=0 "These parameters will not be used, only here for backwards compatibility";
  parameter SI.Time startTime=0 "These parameters will not be used, only here for backwards compatibility";

  final Modelica.SIunits.Power P_R_sum_pos=sum(P_R_pos) "Total positive reserved control power";
  final Modelica.SIunits.Power P_R_sum_neg=sum(P_R_neg) "Total negative reserved control power";
  final Real c_min_pos=min(P_R_pos)/P_R_sum_pos;
  final Real c_min_neg=min(P_R_neg)/P_R_sum_neg;

  Modelica.Blocks.Nonlinear.VariableLimiter limiter(strict=true)
                                                    annotation (
    Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression maxLimit(y=P_R_sum_pos) annotation (
    Placement(transformation(extent={{-90,6},{-60,26}})));
  Modelica.Blocks.Sources.RealExpression minLimit(y=-P_R_sum_neg) annotation (
    Placement(transformation(extent={{-90,-26},{-60,-6}})));

  Real c_pos[nout];
  Real c_neg[nout];

  ClaRa.Components.Utilities.Blocks.VariableGradientLimiter slewRateLimiter[nout](
    each constantLimits=true,
    maxGrad_const=P_grad_max_star .* P_max,
    minGrad_const=-P_grad_max_star .* P_max,
    each useThresh=simCenter.useThresh,
    each thres=simCenter.thres,
    each Nd=1/simCenter.Td) annotation (Placement(transformation(extent={{44,-14},{70,12}})));
equation

     for i in 1:nout loop
       c_pos[i]=P_R_pos[i]/P_R_sum_pos;
       c_neg[i]=P_R_neg[i]/P_R_sum_neg;
       slewRateLimiter[i].u =  c[i]*limiter.y;

       c[i] = min(max(u-P_respond, 0),1)*c_pos[i] + min(max(-u-P_respond, 0),1)*c_neg[i];
     end for;

  connect(u, limiter.u) annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(maxLimit.y, limiter.limit1) annotation (Line(points={{-58.5,16},{-52,16},{-52,8},{-42,8}}, color={0,0,127}));
  connect(minLimit.y, limiter.limit2) annotation (Line(points={{-58.5,-16},{-52,-16},{-52,-8},{-42,-8}}, color={0,0,127}));
  connect(slewRateLimiter.y, y) annotation (Line(points={{71.3,-1},{87.65,-1},{87.65,0},{110,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={Text(
          extent={{48,154},{106,94}},
          lineColor={0,0,127},
          textString="-"), Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+")}));
end ScheduleActivation;
