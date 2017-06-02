within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model TrailerHighCapacity "Cost model for high capacity hydrogen trailers"
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
    size1=1 "Number of trailers",
    C_inv_size=700000*size1 "651854 EUR + cost for rolling platform, NT 2, Zerhusen, Jan (2013): Impact of High Capacity CGH2 Trailers. Key Assumptions, Methodology and Results",
    factor_OM=0.017 "1.7% Stiller, Christoph; Schmidt, Patrick; Michalski, Jan; Wurster, Reinhold; Albrecht, Uwe; Bnger, Ulrich; Altmann, Matthias (2010): Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein. Ludwig-Blkow-Systemtechnik GmbH.",
    lifeTime=20 "Stiller, Christoph; Schmidt, Patrick; Michalski, Jan; Wurster, Reinhold; Albrecht, Uwe; Bnger, Ulrich; Altmann, Matthias (2010): Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein. Ludwig-Blkow-Systemtechnik GmbH.");
end TrailerHighCapacity;
