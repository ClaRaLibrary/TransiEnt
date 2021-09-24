within TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData;
record KfW55_Roof "Roof of example KfW55 building"


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



  extends Buildings.HeatTransfer.Data.OpaqueConstructions.Generic( material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.065,
        k=0.75,
        d=500,
        c=840),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.04,
        k=0.36,
        d=1.2,
        c=1000),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1,
        k=0.044,
        d=180,
        c=2100),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=0.04,
        d=35,
        c=2100),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0002,
        k=0.22,
        d=130,
        c=1700),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0125,
        k=0.25,
        d=680,
        c=960)}, nLay=6)
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datOpaCon",
  Documentation(info="<html>
<h4><span style=\"color: #008c48\">1. Purpose of model</span></h4>
<p>Record for typical roof of KfW55 building (k=0,14 W/m&sup2;K).</p>
<h4><span style=\"color: #008c48\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008c48\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008c48\">7. Remarks for Usage</span></h4>
<p>This model uses instances of models from the Buildings Library developed by the Lawrence Berkeley National Laboratory. The library can be downloaded at https://simulationresearch.lbl.gov/modelica/download.html. </p>
<h4><span style=\"color: #008c48\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008c48\">9. References</span></h4>
<p>Michael Wetter, Wangda Zuo, Thierry S. Nouidui &amp; Xiufeng Pang (2014) Modelica Buildings library, Journal of Building Performance Simulation, 7:4, 253-270, DOI: 10.1080/19401493.2013.765506 </p>
<p>Kreditanstalt f&uuml;r Wiederaufbau, &bdquo;KfW.de,&ldquo; 2017. [Online]. Available: https://www.kfw.de/inlandsfoerderung/Privatpersonen/Neubau/Das-KfW-Effizienzhaus/. </p>
<h4><span style=\"color: #008c48\">10. Version History</span></h4>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de) September 2017</p>
</html>"));
end KfW55_Roof;
