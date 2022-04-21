within TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine;
record CharLineInductionMachine_ieet "induction machine in the Insitut of Electrical Power and Energy Technology"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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





extends TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine.CharLineInductionMachine_empty(CL_ays=[0,0.138899007; 0.130434783,0.175670732; 0.282608696,0.245471147; 0.456521739,0.405260087; 0.565217391,0.482618552; 0.652173913,0.669788572; 0.869565217,0.817960817; 1,0.999999999; 1.304347826,0.903007727; 2.173913043,0.8]);
//Real measurement data, not from literature
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end CharLineInductionMachine_ieet;
