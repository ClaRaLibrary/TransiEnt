within TransiEnt.Grid.Electrical.UnitCommitment;
model SimplifiedUnitCommitment "Very simple unit commitment model"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.DiscreteBlock;
  extends Modelica.Blocks.Interfaces.DiscreteBlock(samplePeriod=60,startTime=60);

  // _____________________________________________
  //
  //          Outer models
  // _____________________________________________

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout=simCenter.generationPark.nMODPlants "Number of plants";
  parameter Real C_var[nout]=simCenter.generationPark.C_var_MOD;
  parameter Modelica.SIunits.Power P_min[nout]=simCenter.generationPark.P_min_MOD;
  parameter Modelica.SIunits.Power P_max[nout]=simCenter.generationPark.P_max_MOD;
  parameter Modelica.SIunits.Power P_init[nout]=P_min;
  parameter Boolean[nout] unit_mustrun = fill(false, nout) "Can be used to prevent plants to shut down (e.g. chp plants)";

  // _____________________________________________
  //
  //               Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_loadpred "Load prediction" annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput z[nout] "Boolean operating state of individual units (unit commitment)" annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_pos[nout] "Upwards reserve constraint, reduces maximum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-38,108}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_R_neg[nout] "Downwards reserve constraint, increases minimum production (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={42,108}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120})));
  // _____________________________________________
  //
  //               Variables
  // _____________________________________________

  Integer[nout] merit_order "Preferred order of generator dispatch";
  SI.Power P_missing "Not yet covered electric load";
  SI.Power P_thisUnit "Power assigned to this unit";
  Real[nout] C_varsorted;

  Modelica.SIunits.Power P_max_eff[nout]=P_max - P_R_pos "Effective maximum load considering upwards control reserve";
  Modelica.SIunits.Power P_min_eff[nout]=P_min + P_R_pos "Effective minimum load considering downwards control reserve";

algorithm
  (C_varsorted, merit_order):= Modelica.Math.Vectors.sort(C_var,ascending=false);

  when {initial()} then
     P_missing := P_loadpred - sum(P_init);
     for i in 1:nout loop
      z[i] := P_init[i] >= P_min[i];
     end for;
  end when;

  when {sampleTrigger} then

    // Starting point: Missing power is the pool setpoint value
    P_missing := P_loadpred + sum(P_R_pos);

    // remove minimum power from units which are must run (by parameter of by reserve duty)
    for i in 1:nout loop
      if unit_mustrun[i] or P_R_pos[i] > 0 or P_R_neg[i] > 0 then
        P_missing := P_missing - P_min_eff[i];
      end if;
    end for;

    // Loop over all units
    for i in 1:nout loop

      P_thisUnit :=0;

      if P_missing > 0 then
        // Assign maximum possible value (min() call) to first unit in merit order list (here, largest potential in pool), but
        // make sure that the setpoint is not smaller than the minimum setpoint (max() call)
        P_thisUnit:=min(max(P_missing, P_min_eff[merit_order[i]]), P_max_eff[merit_order[i]]);
      else
        P_thisUnit:=0;
      end if;

      // Calculate missing power for the rest of the pool
      P_missing :=P_missing - P_thisUnit;

      // True, if this unit got a setpoint > 0 or isblocked
      z[merit_order[i]] := P_thisUnit > 0 or unit_mustrun[merit_order[i]] or abs(P_R_pos[merit_order[i]]) > 0 or abs(P_R_neg[merit_order[i]]) > 0;
    end for;

    if P_missing > 0 then
      Modelica.Utilities.Streams.print(">> Warning: Predicted load could not be covered by generation park in SimplifiedUnitCommitment");
    end if;
  end when;

    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})),
      Diagram(graphics,
              coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-50,34},{62,-30}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,48},{-26,34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,48},{10,34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,48},{46,34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,-30},{46,-44}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-30},{10,-44}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-30},{-26,-44}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,-97},{152,-137}},
          lineColor={0,134,134},
          textString="%name")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple heuristic model for a unit commitment of generators. Based on the load prediction (or actual load if no prediction is available) and the minimum and maximum power boundaries of the available generators the algorithm in this model commits or decommits the generators. Commitment means the generator is operating.</p>
<p>Since no maximum gradients are taken into account a safety factor is introduced which allows to commit more generators to be on the safe side (simple gain on the load prediction).</p>
<p>Furthermore, generators can be marked as must-run, if they are absolutely needed e.g. for control power or coupled heat generation.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>See 1.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>There is no check at all that the produced unit commitment is able to cover the actual demand</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Input: Load (prediction)</p>
<p>Output: Boolean for each generator (true = generator should be in operating mode)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(No remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(No remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>See 1.) and tester</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(No remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(No references)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 06.04.2017</span></p>
</html>"));
end SimplifiedUnitCommitment;
