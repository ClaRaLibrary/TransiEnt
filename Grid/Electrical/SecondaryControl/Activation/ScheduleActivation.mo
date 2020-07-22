within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
model ScheduleActivation "Activation of Secondary Control set by the external scheduler"
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

  extends TransiEnt.Grid.Electrical.SecondaryControl.Activation.PartialActivationType;

  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  parameter SI.Time samplePeriod=0 "These parameters will not be used, only here for backwards compatibility";
  parameter SI.Time startTime=0 "These parameters will not be used, only here for backwards compatibility";


  Modelica.Blocks.Nonlinear.VariableLimiter limiter(strict=true)
                                                    annotation (
    Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression maxLimit(y=P_SB_max) annotation (
    Placement(transformation(extent={{-90,6},{-60,26}})));
  Modelica.Blocks.Sources.RealExpression minLimit(y=-P_SB_max) annotation (
    Placement(transformation(extent={{-90,-26},{-60,-6}})));

  Real c_pos[nout];
  Real c_neg[nout];

TransiEnt.Basics.Blocks.VariableSlewRateLimiter slewRateLimiter[nout](
    each useConstantLimits=true,
    maxGrad_const=P_grad_max_star .* P_max,
    minGrad_const=-P_grad_max_star .* P_max,
    each useThresh=simCenter.useThresh,
    each thres=simCenter.thres) annotation (Placement(transformation(extent={{44,-14},{70,12}})));
equation

     for i in 1:nout loop
       c_pos[i]=P_R_pos[i]/P_SB_max;
       c_neg[i]=P_R_neg[i]/P_SB_max;
       slewRateLimiter[i].u =  c[i]*limiter.y;

       c[i] = min(max(u-P_respond, 0),1)*c_pos[i] + min(max(-u-P_respond, 0),1)*c_neg[i];
     end for;

  connect(u, limiter.u) annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(maxLimit.y, limiter.limit1) annotation (Line(points={{-58.5,16},{-52,16},{-52,8},{-42,8}}, color={0,0,127}));
  connect(minLimit.y, limiter.limit2) annotation (Line(points={{-58.5,-16},{-52,-16},{-52,-8},{-42,-8}}, color={0,0,127}));
  connect(slewRateLimiter.y, y) annotation (Line(points={{71.3,-1},{87.65,-1},{87.65,0},{110,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={Text(
          extent={{48,154},{106,94}},
          lineColor={0,0,127},
          textString="-"), Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Activation of Secondary Control without discrete time behaviour that works only if the bandwidths are set by the external scheduler</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>purely technical, only limitiation of control power and slew rate</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in 10/2014</span></p>
</html>"));
end ScheduleActivation;
