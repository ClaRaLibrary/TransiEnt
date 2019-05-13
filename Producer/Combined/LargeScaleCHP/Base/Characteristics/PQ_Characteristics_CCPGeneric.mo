within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record PQ_Characteristics_CCPGeneric "Scaleable combined cycle plant based on 'GuD Wedel', Source: Ebsilon Professional Model"
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

  //best overall efficiency at P=0.602177 and Q_flow=0.888000: eta_total=0.834370, eta_el=0.493634, eta_th=0.340736
  //efficiency at maximum P=0.8894 and maximum Q_flow=1:       eta_total=0.731152, eta_el=0.479038, eta_th=0.252114
  //efficiency at minimum P=0.6660 and maximum Q_flow=1:       eta_total=0.789512, eta_el=0.463647, eta_th=0.325865
  //best electric efficiency at P=0.2447 and minimum Q_flow=0: eta_total=0.601609, eta_el=0.601609, eta_th=0.000000

  extends Generic_PQ_Characteristics(
  PQboundaries=[
         0,    1.0000,    0.2447;
    0.2226,    0.9745,    0.2213;
    0.9995,    0.8894,    0.6660;
    1.0000,    0.8894,    0.6660],
  PQ_HeatInput_Matrix=[
    0,0.110909090909091,0.221818181818182,0.333181818181818,0.444090909090909,0.555454545454545,0.666363636363636,0.777727272727273,0.888636363636364,1;
    0.111063829787234,0.834370/eta_total_best*[0.21063829787234,0.238297872340426,0.238297872340426,0.238297872340426,0.417021276595745,0.419148936170213,0.395744680851064,0.357446808510638,0.363829787234043];
    0.222127659574468,0.834370/eta_total_best*[0.421276595744681,0.485106382978723,0.474468085106383,0.478723404255319,0.548936170212766,0.553191489361702,0.519148936170213,0.472340425531915,0.478723404255319];
    0.333191489361702,0.834370/eta_total_best*[0.634042553191489,0.668085106382979,0.68936170212766,0.708510638297872,0.723404255319149,0.727659574468085,0.685744680851064,0.621276595744681,0.629787234042553];
    0.444255319148936,0.834370/eta_total_best*[0.84468085106383,0.876595744680851,0.891489361702128,0.917021276595745,0.942553191489362,0.959574468085106,0.902127659574468,0.817021276595745,0.829787234042553];
    0.555531914893617,0.834370/eta_total_best*[1.05531914893617,1.08297872340426,1.1,1.12127659574468,1.1468085106383,1.16595744680851,1.18723404255319,1.07659574468085,1.09148936170213];
    0.666595744680851,0.834370/eta_total_best*[1.26808510638298,1.29148936170213,1.31276595744681,1.33191489361702,1.3531914893617,1.37659574468085,1.39574468085106,1.41702127659574,1.43829787234043];
    0.777659574468085,0.834370/eta_total_best*[1.47872340425532,1.50212765957447,1.51914893617021,1.54468085106383,1.56595744680851,1.58510638297872,1.60425531914894,1.62553191489362,1.6468085106383];
    0.888723404255319,0.834370/eta_total_best*[1.68936170212766,1.71063829787234,1.73191489361702,1.75531914893617,1.77234042553191,1.7936170212766,1.81489361702128,1.83404255319149,1.85531914893617];
    1,0.834370/eta_total_best*[1.90212765957447,1.91489361702128,1.98510638297872,1.98936170212766,1.99148936170213,2.01276595744681,2.03404255319149,2.05531914893617,2.07234042553192]],
  eta_total_best=0.834370);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for generic PQ characteristics of a scaleable combined cycle plant based on &apos;GuD Wedel&apos;</p>
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
<p>These characteristics are based on an Ebsilon model.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PQ_Characteristics_CCPGeneric;
