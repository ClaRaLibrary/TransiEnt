within TransiEnt.Producer.Electrical.Controllers;
model CurtailmentController "Ideal curtailment controller (reduces input depending on curtailment schedule)"
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
  extends TransiEnt.Components.Electrical.PowerTransformation.IdealTriac(
                                                                  final isValveMode=false, change_of_sign=true);
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable) annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  outer TransiEnt.ModelStatistics modelStatistics;

equation
    collectElectricPower.powerCollector.P=-u*sign;

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
so that the sum is correct!")}));
end CurtailmentController;
