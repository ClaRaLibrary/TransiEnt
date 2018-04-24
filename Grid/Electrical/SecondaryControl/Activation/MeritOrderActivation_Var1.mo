within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
model MeritOrderActivation_Var1 "Merit Order Activation of Secondary Control Var1, end-of-pipe gradient constrained"
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
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real C_var_pos[nout]=simCenter.generationPark.C_var "Energy price for positive control power";
  parameter Real C_var_neg[nout]=simCenter.generationPark.C_var "Energy price for negative control power";

  Modelica.SIunits.Power P_reg;
  Real[nout] C_var_pos_sorted;
  Real[nout] C_var_neg_sorted;
  Integer[nout] merit_order_pos;
  Integer[nout] merit_order_neg;

  Modelica.SIunits.Power y_unlimited[nout]; //output before gradient restriction

  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter[nout](Rising=P_grad_max_star .* P_max, each Td=Td) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression y_unlim[nout](y=y_unlimited) annotation (Placement(transformation(extent={{-20,-10},{10,10}})));

algorithm
  (C_var_pos_sorted, merit_order_pos):= Modelica.Math.Vectors.sort(C_var_pos);
  (C_var_neg_sorted, merit_order_neg):= Modelica.Math.Vectors.sort(C_var_neg);

  when {sampleTrigger} then

    y_unlimited := zeros(nout);
    P_reg := u;

    // assign control power to plants
    for i in 1:nout loop
      if P_reg >= P_respond then // for positive control power
        // assign residual to next cheapest plant
        y_unlimited[merit_order_pos[i]] := max( min( P_R_pos[merit_order_pos[i]], P_reg), 0);
        // calculate new residual
        P_reg := P_reg - y_unlimited[merit_order_pos[i]];
      elseif P_reg <= -P_respond then //for negative control power
        y_unlimited[merit_order_neg[i]] := min( max( -P_R_neg[merit_order_neg[i]], P_reg), 0);
        // calculate new residual
        P_reg := P_reg - y_unlimited[merit_order_neg[i]];
      end if;
    end for;

    //calculate participation factors
    for i in 1:nout loop
      if abs(sum(y_unlimited)) < simCenter.P_el_small then
        c[i]:=0;
      else
        c[i]:=y_unlimited[i]/sum(y_unlimited);
      end if;
    end for;

  end when;

equation
  connect(slewRateLimiter.y, y) annotation (Line(points={{61,0},{110,0}},         color={0,0,127}));
  connect(y_unlim.y, slewRateLimiter.u) annotation (Line(points={{11.5,0},{38,0},{38,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+"),
        Text(
          extent={{52,154},{110,94}},
          lineColor={0,0,127},
          textString="-")}));
end MeritOrderActivation_Var1;
