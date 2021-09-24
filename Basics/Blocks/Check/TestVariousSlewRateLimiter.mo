within TransiEnt.Basics.Blocks.Check;
model TestVariousSlewRateLimiter "Model for testing the VariousSlewRateLimiter model"

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



  extends Icons.Checkmodel;
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=5,
    offset=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-84,-14},{-56,14}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=1,
    duration=2.5,
    offset=0,
    startTime=12.5)
    annotation (Placement(transformation(extent={{-84,-70},{-56,-42}})));
  Modelica.Blocks.Math.Add ramp2
    annotation (Placement(transformation(extent={{-10,-14},{18,14}})));
  VariableSlewRateLimiter slewRateLimiter(maxGrad_const=0.1, Td=0.001,
    y_start=1)                                                         annotation (Placement(transformation(extent={{38,51},{76,89}})));
  ClaRa.Components.Utilities.Blocks.VariableGradientLimiter
    variableGradientLimiter(
    constantLimits=true,
    maxGrad_const=0.1,
    minGrad_const=-variableGradientLimiter.maxGrad_const)
    annotation (Placement(transformation(extent={{48,-66},{68,-46}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter1(Rising=0.1)
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
equation
  connect(ramp.y, ramp2.u1) annotation (Line(
      points={{-54.6,0},{-38,0},{-38,8.4},{-12.8,8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, ramp2.u2) annotation (Line(
      points={{-54.6,-56},{-40,-56},{-40,-8.4},{-12.8,-8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, slewRateLimiter.u) annotation (Line(
      points={{19.4,0},{26,0},{26,70},{34.2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(slewRateLimiter1.u, slewRateLimiter.u) annotation (Line(points={{46,0},
          {36,0},{26,0},{26,70},{34.2,70}}, color={0,0,127}));
  connect(variableGradientLimiter.u, slewRateLimiter.u) annotation (Line(points=
         {{46,-56},{26,-56},{26,70},{34.2,70}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           experiment(StopTime=15),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for VariousSlewRateLimiter</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestVariousSlewRateLimiter;
