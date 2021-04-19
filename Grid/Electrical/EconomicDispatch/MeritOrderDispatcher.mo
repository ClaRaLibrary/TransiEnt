within TransiEnt.Grid.Electrical.EconomicDispatch;
model MeritOrderDispatcher "Forward-looking control, min, max and gradient constraints"

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

  parameter Integer nout= simCenter.generationPark.nMODPlants "Number of plants";
  parameter Integer ntime=20 "Number of future points in time to be considered";

  parameter Modelica.SIunits.Power P_init[nout]=zeros(nout);
  parameter Real P_grad_max_star[nout]=simCenter.generationPark.P_grad_max_star_MOD "Specific Power gradient in 1/s";
  parameter Modelica.SIunits.Power P_min_const[nout]=simCenter.generationPark.P_min_MOD;
  parameter Modelica.SIunits.Power P_max_const[nout]=P_n;
  parameter Boolean useVarLimits = false annotation(Evaluate=true, choices(__Dymola_checkBox=true),Dialog(tab="Time varying operating boundaries"));
  parameter Integer nVarLimits=1 annotation(Dialog(enable= useVarLimits, tab="Time varying operating boundaries"));
  parameter Integer iVarLimits[nVarLimits]=1:nVarLimits annotation(Dialog(enable= useVarLimits, tab="Time varying operating boundaries"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var[nout]=simCenter.generationPark.C_var_MOD;

  parameter SI.Power P_n[nout]=simCenter.generationPark.P_max_MOD;

  // _____________________________________________
  //
  //                 Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u[ntime] "Load Prediction" annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nout](start=P_init, fixed=true) annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput z[nout] "Plant status (true=on)" annotation (Placement(transformation(extent={{20,-20},{-20,20}},        rotation=270,
        origin={0,-120}),                                                                                                   iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=270,
        origin={0,-120})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_pos[nout] "Upwards reserve constraint, reduces maximum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_neg[nout] "Downwards reserve constraint, increases minimum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120})));

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________


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
  Modelica.SIunits.Power P_max_total;
  Modelica.SIunits.Power P_min_total;
  Modelica.SIunits.Power P_init_total=sum(P_init);

  Modelica.SIunits.Power P_max[nout](start=P_max_const, fixed=true);
  Modelica.SIunits.Power P_min[nout](start=P_min_const, fixed=true);
  Modelica.SIunits.Power P_max_var[nVarLimits]=P_max[iVarLimits] annotation(Dialog(enable= useVarLimits, tab="Time varying operating boundaries"));
  Modelica.SIunits.Power P_min_var[nVarLimits]=P_min[iVarLimits] annotation(Dialog(enable= useVarLimits, tab="Time varying operating boundaries"));
  Modelica.SIunits.Power P_min_var_total=sum(P_min_var);
  Modelica.SIunits.Power P_max_var_total=sum(P_max_var);
  Modelica.SIunits.Power P_rcbl_max_back_total;
  Modelica.SIunits.Power P_rcbl_min_back_total;

  TransiEnt.Basics.Units.MonetaryUnit C_var_total(start=0, fixed=true) "Total cost estimation (specific production cost multiplied by set points";

algorithm
  (C_varsorted, merit_order):= Modelica.Math.Vectors.sort(C_var);

  // -------------------------------
  //       Initialization
  // -------------------------------
  when {initial()} then
   P_0 := P_init;
   P_load:=u;

   for j in 1:ntime loop
      for i in 1:nout loop
        if z[i] then
          assert(P_0[i]<=P_max_const[i], "Error in MeritOrderDispatcher at init: Plant " + String(i) + " has inital power above maximum power limit");
          assert(P_0[i]>=P_min_const[i], "Error in MeritOrderDispatcher at init: Plant " + String(i) + " has inital power below minimum power limit");
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

  when {sampleTrigger} then

  // -----------------------------------
  //  Preallocation for sample trigger
  // -----------------------------------

    // start with constant values
    for i in 1:nout loop
      P_max[i] :=P_max_const[i]- abs(P_R_pos[i]);
      P_min[i] :=P_min_const[i]+ abs(P_R_neg[i]);
    end for;
    // replace with variable limit units (chps)
    for i in 1:nVarLimits loop
      P_max[iVarLimits[i]] :=P_max_var[i] -  abs(P_R_pos[i]);
      P_min[iVarLimits[i]] :=P_min_var[i]+ abs(P_R_neg[i]);
    end for;
    // Initialize output vector
    for i in 1:nout loop
      if z[i] then
        y[i] := P_min[i];
      else
        y[i] := 0;
      end if;
    end for;

    P_0 := pre(y);
    P_load := u;

  // -----------------------------------
  //  Forward reachable region
  // -----------------------------------

    for j in 1:ntime loop
      for i in 1:nout loop
        if z[i] then
          P_rcbl_max[i,j] :=min(P_max[i], P_0[i] + P_grad_max_star[i]*P_n[i]*samplePeriod*j);
          P_rcbl_min[i,j] :=max(P_min[i], P_0[i] - P_grad_max_star[i]*P_n[i]*samplePeriod*j);
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
      if P_load[ntime] >= 0 and z[merit_order[i]] then

         // find sum of must run capacity from plants that are more expensive than me (merit_order[i])
         for k in 1:nout loop
           if  k <> merit_order[i] and z[k] and C_var[k] >= C_var[merit_order[i]] then
             P_mustrun_residual :=P_mustrun_residual + P_rcbl_min[k,ntime];
           end if;
         end for;

         // assign as much as possible to this plant, since all that come later are more expensive (but less than Pload-Pmustrun
         y[merit_order[i]] := max( min( P_rcbl_max[merit_order[i],ntime], P_load[ntime]-P_mustrun_residual),  P_rcbl_min[merit_order[i],ntime]);
         // calculate new residual
         P_load[ntime] := P_load[ntime] - y[merit_order[i]];

      end if;

    end for;
    // now y contains the "optimized" setpoints for the last prediction step (prediction horizon).

    // -----------------------------------
    //  Backwards reachable region
    // -----------------------------------

       for j in 1:ntime-1 loop

         // find reachable area between two steps
         for i in 1:nout loop
           P_rcbl_max_back[i] :=min(P_max[i], y[i] + P_grad_max_star[i]*P_n[i]*samplePeriod);
           P_rcbl_min_back[i] :=max(P_min[i], y[i] - P_grad_max_star[i]*P_n[i]*samplePeriod);
         end for;

         // -----------------------------------
         //  Assignment of setpoints
         // -----------------------------------

         // reinitialize to minimum setpoint
         for i in 1:nout loop
           if z[i] then
             y[i] := P_min[i];
           else
             y[i] := 0;
           end if;
         end for;

         for i in 1:nout loop

           P_mustrun_residual := 0;

           // if load is not yet balanced
           if P_load[ntime-j] >= 0 and z[merit_order[i]] then

             // find sum of must run capacity from plants that are more expensive than merit_order[i]
              for k in 1:nout loop
                if  k<>merit_order[i] and z[k] and C_var[k] >= C_var[merit_order[i]] then
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

    P_max_total :=sum(P_rcbl_max[:, 1]);
    P_min_total :=sum(P_rcbl_min[:, 1]);
    P_rcbl_min_back_total := sum(P_rcbl_min_back);
    P_rcbl_max_back_total := sum(P_rcbl_max_back);

  end when;

equation
  der(C_var_total) = abs(y)*C_var;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model takes in parameters of a power generation park where every unit is specified by variable generating costs (C_var), a maximum and minimum power output (P_max, P_min) and a maximum gradient (P_grad_max_star)</p>
<p>When input load is positive it assigns the generation capacity in merit order constrained by the maximum and minimum power output and the maximum gradient</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>u[ntime]: RealInput</p>
<p>y[nout]: RealOutput</p>
<p>z[nout]: BooleanInput</p>
<p>P_R_pos[nout]: input for electric power in [W] &quot;Upwards reserve constraint, reduces maximum production (values are supposed to be positive)&quot;</p>
<p>P_R_neg[nout]: input for electric power in [W] &quot;Downwards reserve constraint, increases minimum production (values are supposed to be positive)&quot;</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.EconomicDispatch.Check.TestMeritOrderDispatcher&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-12,-56},{10,-104}},
          lineColor={255,0,255},
          textString="z[i]"),
        Text(
          extent={{-98,148},{-40,88}},
          lineColor={0,0,127},
          textString="+"),
        Text(
          extent={{42,152},{100,92}},
          lineColor={0,0,127},
          textString="-")}));
end MeritOrderDispatcher;
