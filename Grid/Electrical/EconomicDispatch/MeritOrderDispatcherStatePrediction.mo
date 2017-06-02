within TransiEnt.Grid.Electrical.EconomicDispatch;
model MeritOrderDispatcherStatePrediction "Forward-looking control (for plant status z as well as load), min, max and gradient constraints"

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

  extends Modelica.Blocks.Interfaces.DiscreteBlock(samplePeriod=60,startTime=60);
  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //             Outer Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout= simCenter.generationPark.nDispPlants "Number of plants";
  parameter Integer ntime=20 "Number of future points in time to be considered";

  parameter Modelica.SIunits.Power P_init[nout]=zeros(nout);
  parameter Modelica.SIunits.Power P_max[nout]=simCenter.generationPark.P_max;
  parameter Modelica.SIunits.Power P_min[nout]=simCenter.generationPark.P_min;
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var[nout]=simCenter.generationPark.C_var;
  parameter Real P_grad_max_star[nout]=simCenter.generationPark.P_grad_max_star "Specific Power gradient in 1/s";

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  final Modelica.SIunits.Power P_min_R[nout]=P_min+abs(P_R_neg) "Increased Minimum Power due to reservation of negative control power (ability to decrease output)";
  final Modelica.SIunits.Power P_max_R[nout]=P_max-abs(P_R_pos) "Reduced Maximum Power due to reservation of positive control power (ability to increase output)";

  Modelica.Blocks.Interfaces.RealInput u[ntime] "Load Prediction" annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nout](start=P_init, fixed=true) annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput z[nout,ntime] "Plant status (true=on) for each time step" annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=270,
        origin={0,-114}),                                                                                                   iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=270,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput P_R_pos[nout] "Upwards reserve constraint, reduces maximum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-48,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-48,120})));
  Modelica.Blocks.Interfaces.RealInput P_R_neg[nout] "Downwards reserve constraint, increases minimum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,120})));

  Modelica.SIunits.Power P_load[ntime];
  Real[nout] C_varsorted;
  Integer[nout] merit_order;
  Modelica.SIunits.Power P_0[nout] "Current operating point";
  Modelica.SIunits.Power P_rcbl_max[nout,ntime] "Max reachable operating point";
  Modelica.SIunits.Power P_rcbl_min[nout,ntime] "Min reachable operating point";
  Modelica.SIunits.Power P_rcbl_max_back[nout] "Max operating point to reach next timestep operating point";
  Modelica.SIunits.Power P_rcbl_min_back[nout] "Min operating point to reach next timestep operating point";
  Modelica.SIunits.Power P_mustrun_residual "Mustrun power of plants that are more expensive than me";
  Modelica.SIunits.Power P_set_total = sum(y);

  TransiEnt.Basics.Units.MonetaryUnit C_var_total(start=0, fixed=true) "Total cost estimation (specific production cost multiplied by set points";

algorithm
  (C_varsorted, merit_order):= Modelica.Math.Vectors.sort(C_var);

  when {initial()} then
   P_0 := P_init;
   P_load:=u;

   for j in 1:ntime loop
      for i in 1:nout loop
        if z[i,j] then
          P_rcbl_max[i,j] := P_0[i];
          P_rcbl_min[i,j] := P_0[i];
          P_rcbl_max_back[i] := P_0[i];
          P_rcbl_min_back[i] := P_0[i];
        else
          P_rcbl_max[i,j] := 0;
          P_rcbl_min[i,j] := 0;
        end if;
      end for;
   end for;

  end when;

  // preallocate

  when {sampleTrigger} then

    for i in 1:nout loop
      if z[i,1] then
        y[i] := P_min_R[i];
      else
        y[i] := 0;
      end if;
    end for;

    P_0 := pre(y);
    P_load := u;

    // calculate reachable Area from current operating point
    for j in 1:ntime loop
      for i in 1:nout loop
        if z[i,j] then
          P_rcbl_max[i,j] := min(P_max_R[i], P_0[i] +  P_grad_max_star[i]*P_max[i] * samplePeriod * j);
          P_rcbl_min[i,j] := max(P_min_R[i], P_0[i] -  P_grad_max_star[i]*P_max[i] * samplePeriod * j);
        else
          P_rcbl_max[i,j] :=0;
          P_rcbl_min[i,j] :=0;
        end if;
      end for;
    end for;

    // assign load to plants for last time step
    for i in 1:nout loop

      P_mustrun_residual := 0;

      // if load is not yet balanced
      if P_load[ntime] >= 0 and z[merit_order[i],ntime] then

         // find sum of must run capacity from plants that are more expensive than merit_order[i]
         for k in 1:nout loop
           if  z[k,ntime] and C_var[k] > C_var[merit_order[i]] then
             P_mustrun_residual :=P_mustrun_residual + P_rcbl_min[k,ntime];
           end if;
         end for;

         // assign residual to next cheapest plant
         y[merit_order[i]] := max( min( P_rcbl_max[merit_order[i],ntime], P_load[ntime]-P_mustrun_residual),  P_rcbl_min[merit_order[i],ntime]);
         // calculate new residual
         P_load[ntime] := P_load[ntime] - y[merit_order[i]];

      end if;

    end for;

    // go back in time starting at t_end-1
    for j in 1:ntime-1 loop

      // find reachable area between two steps
      for i in 1:nout loop
        P_rcbl_max_back[i] := min(P_max_R[i], y[i] +  P_grad_max_star[i]*P_max[i] * samplePeriod);
        P_rcbl_min_back[i] := max(P_min_R[i], y[i] -  P_grad_max_star[i]*P_max[i] * samplePeriod);
      end for;

      for i in 1:nout loop
        if z[i,ntime-j] then
          y[i] := P_min_R[i];
        else
          y[i] := 0;
        end if;
      end for;

      for i in 1:nout loop

        P_mustrun_residual := 0;

        // if load is not yet balanced
        if P_load[ntime-j] >= 0 and z[merit_order[i],ntime-j] then

          // find sum of must run capacity from plants that are more expensive than merit_order[i]
           for k in 1:nout loop
             if  z[k,ntime-j] and C_var[k] > C_var[merit_order[i]] then
               P_mustrun_residual := P_mustrun_residual + max(P_rcbl_min[k,ntime-j],P_rcbl_min_back[k]);
             end if;
           end for;

          // assign residual to next cheapest plant
          y[merit_order[i]] := max(  [ min( [ P_rcbl_max[merit_order[i],ntime-j],  P_rcbl_max_back[merit_order[i]],  P_load[ntime-j]-P_mustrun_residual]),
                                       P_rcbl_min_back[merit_order[i]],
                                       P_rcbl_min[merit_order[i],ntime-j]]);
          // calculate new residual
          P_load[ntime-j] := P_load[ntime-j] - y[merit_order[i]];

        end if;

      end for;

    end for;

  end when;

equation
  der(C_var_total) = y*C_var;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p>This model extends the functionality of the basic MeritOrderDispatcher by taking into account a prediction for the (boolean) operating state. </p>
<p>This is needed because if a unit is commited it has to produce a minimum amount of power (P_min). If the prediction indicates that a unit will be started in the near future the other units production is reduced and thereby a smooth load following is possible (see <a href=\"TransiEnt.Grid.Electrical.EconomicDispatch.Check.TestMeritOrderDispatcherStatePrediction\">TestMeritOrderDispatcherStatePrediction</a> for an example). </p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-12,-62},{10,-110}},
          lineColor={255,0,255},
          textString="z[i,j]"),
        Text(
          extent={{-108,150},{-50,90}},
          lineColor={0,0,127},
          textString="+"),
        Text(
          extent={{52,154},{110,94}},
          lineColor={0,0,127},
          textString="-")}));
end MeritOrderDispatcherStatePrediction;
