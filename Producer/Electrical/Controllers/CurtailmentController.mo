within TransiEnt.Producer.Electrical.Controllers;
model CurtailmentController "Ideal curtailment controller (reduces input depending on curtailment schedule)"
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
  extends TransiEnt.Components.Electrical.PowerTransformation.IdealTriac(
                                                                  final isValveMode=false, change_of_sign=true);
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable) annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
    collectElectricPower.powerCollector.P=-u*sign;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

    connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable], collectElectricPower.powerCollector);

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{0,50},{0,-64}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.None}), Text(
          extent={{-64,78},{66,-84}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString="RE Generators put their 
generation in statistics
This block reduces the 
value depending on curtailment
so that the sum is correct!")}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>RE Generators put their generation in statistics. This block reduces the value depending on curtailment so that the sum is correct.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp_in: active power port</p>
<p>epp_out: active power port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end CurtailmentController;
