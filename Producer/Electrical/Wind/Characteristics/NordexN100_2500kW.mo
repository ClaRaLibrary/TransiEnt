within TransiEnt.Producer.Electrical.Wind.Characteristics;
record NordexN100_2500kW "Nordex model N100 2500kW"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=2.5e6,
    PowerCurve=[
    0,0;
    3,0;
3.5,34000;
4.0,88000;
4.5,155000;
5.0,237000;
5.5,333000;
6.0,448000;
6.5,582000;
7.0,738000;
7.5,919000;
8.0,1123000;
8.5,1351000;
9.0,1604000;
9.5,1845000;
10.0,2043000;
10.5,2200000;
11.0,2321000;
11.5,2409000;
12.0,2467000;
12.5,2495000;
13.0,2500000;
14.0,2500000;
15.0,2500000;
16.0,2500000;
17.0,2500000;
18.0,2500000;
19.0,2500000;
25.0,2500000;
25.001, 0;
50, 0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Nordex model N100 with 2500kW</p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Technical Data taken from the official data sheet published by Nordex SE, URL: http://www.nordex-online.com/fileadmin/MEDIA/Gamma/Nordex_Gamma_N100_de.pdf</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end NordexN100_2500kW;
