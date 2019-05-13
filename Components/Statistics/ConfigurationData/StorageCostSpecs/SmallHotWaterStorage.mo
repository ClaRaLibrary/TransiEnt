within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model SmallHotWaterStorage "small hot water storage cost specification record"
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
  // "Speicher fr die Energiewende" (Fraunhofer UMSICHT, 2013) and "Optimization of a distributed cogeneration system with solar district heating" (Buoro et al., 2014)
  //
  // the specific investment costs all are scored to the energy capacity due to unknown relation
  // the operating costs alle are scored to the fix costs due to unknown relation
  // the investmentcosts are stated with a value between 0.5 and 7 EUR/kWh. (Fraunhofer UMSICHT, 2013)
  // investment costs of 3.3 EUR/kWh are assumed in for a stortage size of 3000-4000 m^3 (Buoro et al., 2014)
  // the operating costs chould be compared with others, because its a thump calculation

  // life cycle time: 40 years
  // investment Costs "Cspec_inv_E" are scaled for life cycle time of twenty years (3.5 EUR/kWh for fourty years)

  extends TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs(
    Cspec_fixOM=0 "specific fix annual OM cost in EUR/(kW*a)",
    Cspec_OM_W_el=0 "specific variable cost per stored energy in EUR/kWh",
    Cspec_inv_der_E=0 "specific invest cost per maximum unload power in EUR/kW",
    Cspec_inv_E(
      min=0.5/3.6e6,
      max=7/3.6e6) = 1750/3.6e9 "Specific invest cost per energy capacity in EUR/MWh",
    lifeTime=simCenter.Duration);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>small hot water storage cost specification record</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Fraunhofer UMSICHT, &quot;Speicher fuer die Energiewende&quot;, 2013</p>
<p>[2] D. Buoro, P. Pinamonti, M. Reini, &quot;Optimization&nbsp;of&nbsp;a&nbsp;distributed&nbsp;cogeneration&nbsp;system&nbsp;with&nbsp;solar&nbsp;district&nbsp;heating&quot;, 2014</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end SmallHotWaterStorage;
