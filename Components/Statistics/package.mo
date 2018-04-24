within TransiEnt.Components;
package Statistics "Package for statistics related models, like costs and emissions"
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
  extends TransiEnt.Basics.Icons.StatisticsPackage;

















  annotation (Documentation(info="<html>
<h4>Economics Package Description</h4>
<p>This package was created to allow a rough consideration of the system economics directly in the TransiEnt.EE library, to avoid post-processing work. This leads to some restrictions regarding the applicability of the results calculated with the models in this package.</p>
<p><u>Important note: For the calculation of the electricy generation costs, only the results obtained with annual calculations apply. All results obtained by calculating smaller time ranges are invalid by definition.</u></p>
<p><br>In the models within the package &QUOT;<b>ProducerCostSpecifications</b>&QUOT;, the parameters required to calculate the economic indicators are defined. These parameters are actually defined by calling the central definition in &QUOT;<b>simCenter.Cost</b>&QUOT;. The parameters are: </p>
<ul>
<li><pre>Specific investment costs in [EUR/kWe] </pre></li>
<li><pre>Specific fixed Operation &AMP; Maintenance costin EUR/kWe</pre></li>
<li><pre>Specific variable costs in EUR / MWhe</pre></li>
<li><pre>Specific fuel cost in EUR/MWhth</pre></li>
<li><pre>Specific CO2-cost in EUR/t</pre></li>
<li><code>Specific emissions in</code> g/kWhe</li>
<li>Efficency factor (unitless)</li>
</ul>
<p><br>The model &QUOT;SimpleEconomicsModel&QUOT; uses a the replaceable models defined in the &QUOT;ProducerCostSpecs&QUOT;-Package. The equations within this model are:</p>
<ul>
<li> Annuity Calculation</li>
<li> Time dependent annuity payment (dummy variable)</li>
<li>  Calculation of produced Energy</li>
<li> Calculation of time dependent incurred fuel costs</li>
<li> Calculation of O&AMP;M costs</li>
<li> Calculation of Variable Costs</li>
<li> Calculation of Costs for CO2-Emission</li>
<li> Calculation of total costs</li>
<li> Calculation of the electricity generation costs (for the moment called: LEC - levelized cost of electricity) in EUR/MWh</li>
</ul>
<p><br><h4>Version: </h4></p>
<ul>
<li>2014.11.18: Fistr draft. Conception and implementation by R. Peniche and O. Sch&uuml;lting</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics));
end Statistics;
