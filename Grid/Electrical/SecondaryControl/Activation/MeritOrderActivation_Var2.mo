within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
model MeritOrderActivation_Var2 "Merit Order Activation of Secondary Control Var2"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  Modelica.SIunits.Power P_0[nout] "Current operating point";
  Modelica.SIunits.Power P_rcbl_max[nout] "Max reachable operating point";
  Modelica.SIunits.Power P_rcbl_min[nout] "Min reachable operating point";
  Modelica.SIunits.Power P_mustrun_residual "Mustrun power of plants that are more expensive than me";

algorithm
  (C_var_pos_sorted, merit_order_pos):= Modelica.Math.Vectors.sort(C_var_pos);
  (C_var_neg_sorted, merit_order_neg):= Modelica.Math.Vectors.sort(C_var_neg);

  when {initial()} then
   P_0 := zeros(nout);
   P_rcbl_max := zeros(nout);
   P_rcbl_min := zeros(nout);
  end when;

  when {sampleTrigger} then

    y := zeros(nout);
    P_0 := pre(y);
    P_reg := u;

    // calculate reachable Area from current operating point

    for i in 1:nout loop
      P_rcbl_max[i] := min(P_R_pos[i], P_0[i] +  P_grad_max_star[i]*P_max[i] * samplePeriod);
      P_rcbl_min[i] := max(-P_R_neg[i], P_0[i] -  P_grad_max_star[i]*P_max[i] * samplePeriod);
    end for;

    // assign control power to plants
    for i in 1:nout loop
      P_mustrun_residual := 0;
      if P_reg >= P_respond then // for positive control power
        // find sum of must run capacity from plants that are more expensive than merit_order[i]
        for k in 1:nout loop
          if  C_var_pos[k] > C_var_pos[merit_order_pos[i]] then
            P_mustrun_residual := P_mustrun_residual + max(0,P_rcbl_min[k]);
          end if;
        end for;
        // assign residual to next cheapest plant
        y[merit_order_pos[i]] := max( min( P_rcbl_max[merit_order_pos[i]], P_reg - P_mustrun_residual),  P_rcbl_min[merit_order_pos[i]]);
        // calculate new residual
        P_reg := P_reg - y[merit_order_pos[i]];
      elseif P_reg <= -P_respond then //for negative control power
        // find sum of must run capacity from plants that are more expensive than merit_order[i]
        for k in 1:nout loop
          if  C_var_neg[k] > C_var_neg[merit_order_neg[i]] then
            P_mustrun_residual := P_mustrun_residual + min(0,P_rcbl_max[k]);
          end if;
        end for;
        y[merit_order_neg[i]] := min( max( P_rcbl_min[merit_order_neg[i]], P_reg - P_mustrun_residual),  P_rcbl_max[merit_order_neg[i]]);
        // calculate new residual
        P_reg := P_reg - y[merit_order_neg[i]];
      end if;
    end for;

    //calculate participation factors
    for i in 1:nout loop
      if abs(sum(y)) < simCenter.P_el_small then
        c[i]:=0;
      else
        c[i]:=y[i]/sum(y);
      end if;
    end for;
  end when;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+"),
        Text(
          extent={{52,154},{110,94}},
          lineColor={0,0,127},
          textString="-")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Merit Order Activation of Secondary Control Var2, gradient constrained, considers P_mustrun_residual</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2E: Models are based on (dynamic) transfer functions or differential equations.</p>
<p>nonlinear behavior</p>
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
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.SecondaryControl.Check.TestAGC_compareActivation&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in 10/2014</span></p>
</html>"));
end MeritOrderActivation_Var2;
