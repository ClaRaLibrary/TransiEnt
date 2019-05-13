within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Pool;
model mainExplicitFridgePool
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

  extends TransiEnt.Basics.Icons.Example;
  parameter TransiEnt.Basics.Types.Poolsize N=100;

protected
  ExplicitFridgePool pool(N=N) annotation (Placement(transformation(extent={{-16,-16},{20,18}})));

public
  SI.Power P_el_n = pool.P_el_n;
  SI.Power P_el = pool.P_el;
  SI.Power P_el_star = pool.P_el_star;
  SI.Power P_pot_pos = pool.P_pot_pos;
  SI.Power P_pot_neg = pool.P_pot_neg;
  Real COP = pool.COPmn;
  Real SOC = pool.SOC;
  SI.Energy E_stor = pool.E_stor;
  SI.Time t_pos_max = pool.t_pos_max;
  SI.Time t_neg_max = pool.t_neg_max;
  SI.Temperature T_amb = 273.15+pool.simCenter.ambientConditions.temperature.value;

  TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base.ExplicitFridgeParameters[pool.N] poolparams=pool.poolparams;

  annotation (experiment(StopTime=18000, Interval=60), __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
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
</html>"));
end mainExplicitFridgePool;
