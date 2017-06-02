within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenPipeline "Cost model for hydrogen pipelines"
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
  extends PartialCostSpecs(
    size1=1 "Diameter of the pipeline",
    size2=1 "Length of the pipeline",
    C_inv_size=(133.3+916.7*size1)*size2
                                        "taken from figure 1.4-4 Altmann 2001 Wasserstofferzeugung in offshore Windparks. \"Killer-Kriterien\", grobe Auslegung und Kostenabschtzung",
    factor_OM=0.02 "2%, Altmann 2001 Wasserstofferzeugung in offshore Windparks. \"Killer-Kriterien\", grobe Auslegung und Kostenabschtzung",
    lifeTime=30 "Stiller.2010 Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein");
end HydrogenPipeline;