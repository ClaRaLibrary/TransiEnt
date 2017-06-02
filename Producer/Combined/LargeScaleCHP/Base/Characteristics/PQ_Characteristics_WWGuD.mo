within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record PQ_Characteristics_WWGuD "Combined cycle unit based on 'GuD Wedel', Source: Estimation made with stationary simulations of a power plant simulation program"
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

  extends Generic_PQ_Characteristics(
  final k_Q_flow=1,
  final k_P_el=1,
  PQboundaries=[
  0e6,  470e6,  115e6;
  49e6,  458e6,  104e6;
  220e6,  418e6,  313e6;
  220.1e6,  418e6,  313e6],
  PQ_HeatInput_Matrix=[
0e6, 24.4e6, 48.8e6, 73.3e6, 97.7e6, 122.2e6, 146.6e6, 171.1e6, 195.5e6, 220e6;
52.2e6, 99e6, 112e6, 112e6, 112e6, 196e6, 197e6, 186e6, 168e6, 171e6;
104.4e6, 198e6, 228e6, 223e6, 225e6, 258e6, 260e6, 244e6, 222e6, 225e6;
156.6e6, 298e6, 314e6, 324e6, 333e6, 340e6, 342e6, 322.3e6, 292e6, 296e6;
208.8e6, 397e6, 412e6, 419e6, 431e6, 443e6, 451e6, 424e6, 384e6, 390e6;
261.1e6, 496e6, 509e6, 517e6, 527e6, 539e6, 548e6, 558e6, 506e6, 513e6;
313.3e6, 596e6, 607e6, 617e6, 626e6, 636e6, 647e6, 656e6, 666e6, 676e6;
365.5e6, 695e6, 706e6, 714e6, 726e6, 736e6, 745e6, 754e6, 764e6, 774e6;
417.7e6, 794e6, 804e6, 814e6, 825e6, 833e6, 843e6, 853e6, 862e6, 872e6;
470e6, 894e6, 900e6, 933e6, 935e6, 936e6, 946e6, 956e6, 966e6, 974e6]);

  annotation (Documentation(info="<html>
<p><span style=\"font-size: 8pt;\">All records (PQ diagrams and Heat input matrixes) included in this package are included with the intention of illustrating the modelling concept.</span></p>
<p><span style=\"font-size: 8pt;\">However, users are encouraged to create their own records based on the plants and scenarios that they want to simulate.</span></p>
</html>"));
end PQ_Characteristics_WWGuD;