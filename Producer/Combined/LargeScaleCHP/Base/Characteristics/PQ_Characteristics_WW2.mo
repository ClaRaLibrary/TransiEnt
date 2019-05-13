within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record PQ_Characteristics_WW2 "Black coal steam unit based on 'Wedel Block 2 (WW2)', Source: Cerbe2002"
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

  extends Generic_PQ_Characteristics(
  final k_Q_flow=1,
  final k_P_el=1,
  PQboundaries=[
0, 137.106e6, 54.309e6;
75e6, 122.465e6, 37.899e6;
160e6, 105.872e6, 76.055e6;
165e6, 105.872e6, 76.055e6],
  PQ_HeatInput_Matrix=[
       0.0e6,         0.0e6,        20.0e6,        40.0e6,        60.0e6,        80.0e6,       100.0e6,       120.0e6,       140.0e6,       160.0e6;
       0.0e6,         0.1e6,        27.4e6,        56.1e6,        84.8e6,       113.5e6,       142.2e6,       170.9e6,       199.6e6,       228.4e6;
      17.1e6,        40.7e6,        48.7e6,        57.0e6,        84.8e6,       113.5e6,       142.2e6,       170.9e6,       199.6e6,       228.4e6;
      34.3e6,        82.9e6,        90.6e6,        98.4e6,       106.5e6,       114.8e6,       142.2e6,       170.9e6,       199.6e6,       228.4e6;
      51.4e6,       126.0e6,       132.9e6,       140.2e6,       147.9e6,       155.8e6,       163.9e6,       172.3e6,       199.6e6,       228.4e6;
      68.5e6,       169.4e6,       175.7e6,       182.4e6,       189.4e6,       196.8e6,       204.5e6,       212.5e6,       220.8e6,       229.2e6;
      85.7e6,       213.5e6,       219.1e6,       225.2e6,       231.6e6,       238.4e6,       245.5e6,       253.0e6,       260.8e6,       268.9e6;
     102.8e6,       259.1e6,       264.0e6,       269.3e6,       275.1e6,       281.2e6,       287.8e6,       294.7e6,       301.9e6,       309.5e6;
     120.0e6,       306.1e6,       310.1e6,       314.6e6,       319.6e6,       325.1e6,       330.8e6,       336.8e6,       343.3e6,       350.1e6;
     137.1e6,       353.2e6,       356.1e6,       359.7e6,       363.7e6,       368.2e6,       373.2e6,       378.6e6,       384.5e6,       390.7e6]);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for generic PQ characteristics of a black coal steam unit based on &apos;Wedel Block 2 (WW2)&apos;</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>All records (PQ diagrams and Heat input matrixes) included in this package are included with the intention of illustrating the modelling concept.</p>
<p>However, users are encouraged to create their own records based on the plants and scenarios that they want to simulate.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] CERBE, A. &quot;Prozessnahe Einsatzoptimierung mit BoFiT unter Ber&uuml;cksichtigung der Netzrestriktionen.&quot; Hamburg: Hamburgische Electricit&auml;ts-Werke AG, 2002 </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PQ_Characteristics_WW2;
