within TransiEnt.Producer.Electrical.Wind.Characteristics;
record VestasV164_8000kW "Vestas model V164 8MW"

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




  //Record containing the data of the Vestas Windturbine model V164 with 8MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=8e6,
    PowerCurve=[
    0,0;
2.7,0;
2.738928384,13.34895314;
3.287776413,38.96272065;
3.836624441,143.2227877;
4.385472469,330.0614694;
4.934320498,566.7094741;
5.483168526,863.6529751;
5.982121279,1171.892033;
6.406231119,1477.631313;
6.780445684,1781.93294;
7.129712611,2099.590931;
7.454031901,2423.396042;
7.753403553,2740.989569;
8.095866579,3067.814171;
8.582219515,3722.517592;
9.075628348,4409.475112;
9.524685826,5086.282389;
9.729810847,5417.371611;
9.973743304,5773.182607;
10.1770013,5990.628516;
10.39820387,6331.2393;
10.68762531,6703.43022;
10.94191969,7042.913627;
11.35761646,7401.179677;
11.85018866,7685.259706;
12.3922803,7875.108584;
12.93457316,7970.846235;
13.47702188,8000;
25,8000;
25.01,0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the data of the Vestas Windturbine model V164 with 8MW</p>
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
<p>[1] Vestas Offshore http://www.mhivestasoffshore.com/innovations/</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end VestasV164_8000kW;
