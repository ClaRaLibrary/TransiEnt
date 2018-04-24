within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenPipeStorage "Hydrogen buried pipe storage (1300...6800 m3 geo, <100 bar)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
//Source: Buenger U, Michalski J, Crotogino F, Kruck O. Large-scale underground storage of hydrogen for the grid integration of renewable energy and other applications. In: Ball M, Basile A, Veziroǧlu TN, editors. Compend. Hydrog. Energy, Oxford: Woodhead Publishing; 2016, p. 133–163. doi:http://dx.doi.org/10.1016/B978-1-78242-364-5.00007-5.
//page 138: 2...7 MPa
  extends PartialCostSpecs(
    size1=6800 "Geometric volume in m3",
    C_inv_size=size1*12e6/6800 "Scaled by given value in Buenger et al. 2016",
    factor_OM=0.02 "2%, Stolzenburg 2014, cavern",
    lifeTime=50 "Buenger et al. 2016, buried pipe");
end HydrogenPipeStorage;
