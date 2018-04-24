within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record PQ_Characteristics_WW1 "Black coal steam unit based on 'Wedel Block 1 (WW1)', Source: Cerbe2002"
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

  extends Generic_PQ_Characteristics(
  final k_Q_flow=1,
  final k_P_el=1,
  PQboundaries=[
  0,        150.369e6, 59.577e6;
  93.241e6, 132.376e6, 40.807e6;
  215.574e6,108.771e6, 103.241e6;
  220e6,    108.771e6, 103.241e6],
  PQ_HeatInput_Matrix=[
       0.0e6,         0.0e6,        26.9e6,        53.9e6,        80.8e6,       107.8e6,       134.7e6,       161.6e6,       188.6e6,       215.5e6;
       0.0e6,         0.1e6,        37.4e6,        76.0e6,       114.6e6,       153.3e6,       192.0e6,       230.7e6,       269.4e6,       308.0e6;
      18.8e6,        44.7e6,        55.6e6,        76.0e6,       114.6e6,       153.3e6,       192.0e6,       230.7e6,       269.4e6,       308.0e6;
      37.6e6,        91.2e6,       101.4e6,       112.0e6,       123.1e6,       153.3e6,       192.0e6,       230.7e6,       269.4e6,       308.0e6;
      56.4e6,       138.5e6,       147.6e6,       157.4e6,       167.9e6,       178.8e6,       192.0e6,       230.7e6,       269.4e6,       308.0e6;
      75.2e6,       186.3e6,       194.5e6,       203.5e6,       213.0e6,       223.3e6,       234.0e6,       245.2e6,       269.4e6,       308.0e6;
      93.9e6,       235.3e6,       242.5e6,       250.5e6,       259.2e6,       268.5e6,       278.4e6,       289.0e6,       300.1e6,       311.3e6;
     112.7e6,       286.1e6,       292.1e6,       299.0e6,       306.7e6,       315.2e6,       324.1e6,       333.4e6,       343.5e6,       354.0e6;
     131.5e6,       338.3e6,       342.8e6,       348.2e6,       354.5e6,       361.7e6,       369.6e6,       378.2e6,       387.4e6,       397.1e6;
     150.3e6,       388.8e6,       392.0e6,       396.2e6,       401.4e6,       407.5e6,       414.5e6,       422.2e6,       430.3e6,       438.9e6]);

  annotation (Documentation(info="<html>
<p><span style=\"font-size: 8pt;\">All records (PQ diagrams and Heat input matrixes) included in this package are included with the intention of illustrating the modelling concept.</span></p>
<p><span style=\"font-size: 8pt;\">However, users are encouraged to create their own records based on the plants and scenarios that they want to simulate.</span></p>
</html>"));
end PQ_Characteristics_WW1;
