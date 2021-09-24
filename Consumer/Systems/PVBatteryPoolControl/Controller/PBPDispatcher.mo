within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Controller;
model PBPDispatcher "Assigns bandwiths to primary balancing providers"

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.DiscreteBlock;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout "Number of outputs (=units in PBP pool)";
  parameter SI.Power P_min_setpoint=0 "Minimum possible setpoint per unit (increment)";

  // _____________________________________________
  //
  //               Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_el_PBP_offer[nout](each final quantity="Power", each final unit="W", each displayUnit="W") "PBP Offer of individual systems" annotation (Placement(transformation(extent={{-120,-30},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_PBP_setpoints[nout](each final quantity="Power", each final unit="W", each displayUnit="W", each start=0, each fixed=true) "Individual setpoints for PBP bandwidth of units in pool" annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Interfaces.RealInput P_el_pbp_set(final quantity="Power", final unit="W", displayUnit="W") annotation (Placement(transformation(extent={{-120,50},{-80,90}})));

  Modelica.Blocks.Interfaces.IntegerInput communicationTrigger(start=0, fixed=true) "Integer value changes if communication intervall has past" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-106})));

  // _____________________________________________
  //
  //               Variables
  // _____________________________________________

  Integer[nout] merit_order(start=1:nout, fixed=true) "Preferred order of PBP allocation";
  SI.Power P_missing "Not yet assigned PBP power (recalculated in every iteration)";

algorithm

  when {initial(), change(communicationTrigger)} then

    (, merit_order):= Modelica.Math.Vectors.sort(P_el_PBP_offer, false);  // Pro-Rata method: Largest offer is preferred

    // Starting point: Missing power is the pool setpoint value
    P_missing := P_el_pbp_set;

    // Loop over all units
    for i in 1:nout loop

      if P_missing > 0 then

        // Assign maximum possible value (min() call) to first unit in merit order list (here, largest potential in pool), but
        // make sure that the setpoint is not smaller than the minimum setpoint (max() call)
        P_el_PBP_setpoints[merit_order[i]] :=min(max(P_missing, P_min_setpoint), P_el_PBP_offer[merit_order[i]]);

        // Calculate missing power for the rest of the pool
        P_missing :=P_missing - P_el_PBP_setpoints[merit_order[i]];
      else
        // Set all units to setpoint zero which are not needed
        P_el_PBP_setpoints[merit_order[i]]:=0;
      end if;
    end for;

    if P_missing > 0 then
      Modelica.Utilities.Streams.print(">> Warning: PBP Dispatcher could not assign total pool setpoint. Primary balancing might be endangered!");
    end if;
  end when;

    annotation (
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
          extent={{-144,151},{156,111}},
          lineColor={0,134,134},
          textString="%name")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple primary balancing power (PBP) pool dispatcher. Input is the PBP setpoint of the pool. Output is the individual setpoint for each unit in the pool (may be zero for units which are not needed).</p>
<p>The assignment uses the Pro-rata method i.e. the merit order list is sorted by the amount of PBP potential. Units with large offers are favoured over units with small offers.</p>
<p>The assignment is recalculated every time the communication trigger changes its value. For now no distinction between the two triggers is implemented but this could be used to e.g. stochastically change setpoint of individuals in pool within a trading period.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Purley technical component not physical effects considered.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The dispatcher does not know what the potential is within the communication intervall. This means that only in the distinct instance where the algorithm is running, it would produce a warning message in case the pool demand cant be met (see: TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckPBPDispatcher)</p>
<p>In other words, the plant is responsible to provide the balancing power reserve starting from the point of time when the controller changes its setpoint and keep it for the entire communication intervall. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>P_el_PBP_set: PBP setpoint of the entire pool.</p>
<p>P_el_PBP_setpoint: Vector of individual setpoints for units in the pool</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckPBPDispatcher&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 27.03.2017</span></p>
</html>"));
end PBPDispatcher;
