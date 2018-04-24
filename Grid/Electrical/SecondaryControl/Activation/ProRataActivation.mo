within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
model ProRataActivation "ProRata Activation of Secondary Control, bercksichtigt Ansprechempfindlichkeit P_respond, falls diese unterschritten wird gleiche Anteile fr eine ggf. reduzierte Anzahl an Kraftwerken "
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

  extends Modelica.Blocks.Interfaces.DiscreteBlock(samplePeriod=60,startTime=60);
  extends TransiEnt.Grid.Electrical.SecondaryControl.Activation.PartialActivationType(y(start=zeros(nout), fixed=true));

  // _____________________________________________

  final Modelica.SIunits.Power P_R_sum_pos=sum(P_R_pos) "Total positive reserved control power";
  final Modelica.SIunits.Power P_R_sum_neg=sum(P_R_neg) "Total negative reserved control power";
  final Real c_min_pos=min(P_R_pos)/P_R_sum_pos;
  final Real c_min_neg=min(P_R_neg)/P_R_sum_neg;

  Modelica.Blocks.Nonlinear.VariableLimiter limiter annotation (
    Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter[nout](Rising=P_grad_max_star .* P_max, each Td=Td) annotation (
    Placement(transformation(extent={{48,-10},{68,10}})));
  Modelica.Blocks.Sources.RealExpression maxLimit(y=P_R_sum_pos) annotation (
    Placement(transformation(extent={{-90,6},{-60,26}})));
  Modelica.Blocks.Sources.RealExpression minLimit(y=-P_R_sum_neg) annotation (
    Placement(transformation(extent={{-90,-26},{-60,-6}})));

algorithm
  when {sampleTrigger} then

    c := zeros(nout);

    for j in 1:nout loop
      // if control power demand is positive and minimum share ist greater than P_respond
      if c_min_pos*u >= P_respond then
        for i in 1:nout loop
          c[i] := P_R_pos[i]/P_R_sum_pos; // calculate participation factors according to ProRata-Method
        end for;
        break;                            // and exit for loop

      // if control power demand is negative and minimum absolute share ist greater than P_respond
      elseif c_min_neg*u <= -P_respond then
        for i in 1:nout loop
          c[i] := P_R_neg[i]/P_R_sum_neg; // calculate participation factors according to ProRata-Method
        end for;
        break;                            // and exit for loop

      // if minimum absolute share ist not greater than P_respond and absolute control power demand is big enough to set (nout+1-j) plants to value P_respond (or -P_respond)
      elseif abs(u) >= (nout+1 - j)*P_respond then
        for i in 1:(nout+1 - j) loop
          c[i] := 1/(nout+1 - j); // calculate equal participation factors
        end for;
        break;                    // and exit for loop
      end if;
    end for;

    for i in 1:nout loop
      slewRateLimiter[i].u := c[i]*limiter.y;
    end for;

  end when;

equation
  connect(u, limiter.u) annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(slewRateLimiter.y, y) annotation (Line(points={{69,0},{110,0}}, color={0,0,127}));
  connect(maxLimit.y, limiter.limit1) annotation (Line(points={{-58.5,16},{-52,16},{-52,8},{-42,8}}, color={0,0,127}));
  connect(minLimit.y, limiter.limit2) annotation (Line(points={{-58.5,-16},{-52,-16},{-52,-8},{-42,-8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={Text(
          extent={{48,154},{106,94}},
          lineColor={0,0,127},
          textString="-"), Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+")}));
end ProRataActivation;
