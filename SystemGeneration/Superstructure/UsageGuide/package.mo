within TransiEnt.SystemGeneration.Superstructure;
package UsageGuide "Usage guide for superstructures"

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




  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p><b>Overview</b> </p>
<p>The superstructure construct is designed to introduce capabilities into the TransiEnt Library, such as power and gas grid analysis, load balancing, controller design, and resilience against failures.</p>
<p>Therefore, the <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.Superstructure\">superstructure component</a> provides a representation of a certain region in terms of consumption and production of power and gas. This representation is comprised of multiple elements that connect with the central electric and gas ports and either consume or generate gas or electrical power. Superstructures are to be used as arrays enclosed in <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.Superstructures_PortfolioMask\">superstructure portfolio masks</a> for maximum utilization (see below).</p>
<p>Each superstructure simulation scenario requires alongside the superstructure array:</p>
<ul>
<li>Controller </li>
<li>Electric grid model</li>
<li>Gas grid model </li>
</ul>
<p>These are designed to be exchangeable, depending on the user&apos;s application case. An example can be found <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Scenarios.Example_Scenario\">here</a>.</p>
<p>A particular focus in the developement has been laid onto the possibility of parameter sweeps and parametrization from outside of Dymola. There are three different ways to create superstructure arrays and simulate different parameterizations:</p>
<ol>
<li>Manually through the parameter interface</li>
<li>Through Dymola interface: Python, XRG Score,...</li>
<li>With external data sources loaded in record <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.ExternalDataImport\">ExternalDataImport </a>(.mat matrices,...) </li>
</ol>
<h4><span style=\"color: #000000\">Portofolios of technology definition</span></h4>
<p>The single elements of each superstructure (local demand, power plants,...) are meant to be redefinable for each user&apos;s indivdual purpose. Therefore technology portfolios are introduced. A new portfolio is encouraged for each application case and allows an individual composition and definition of technologies. </p>
<p>For example: </p>
<ul>
<li>a more detailed renewable energy producer model with more parameters</li>
<li>an extended amount of electrical storages avaliable</li>
<li>a simpler local heat demand model</li>
</ul>
<p><br>A new portfolio can simply be created by copying the <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example\">example portfolio</a> and then adjusting the elements inside. </p>
<h4><span style=\"color: #000000\">Superstructure elements/Technology components</span></h4>
<p>In general, each type instance of an element in the superstructure represents the sum of all capacities of this type in the region, e.g. avaliable accumulated power of CCGT powerplants . Some technologies allow multiple types in parallel, e.g. electrical storages: lithium ion and lead acid batteries. At least one power plant type needs to be present in each region, more types may be defined in parallel. </p>
<p>Following technologies are optional and may be included:</p>
<ul>
<li>Electrical Storages: zero, one or more types</li>
<li>Power to Gas Plants: zero, one or more types</li>
<li>Gas Storage: zero or one type</li>
<li>CO2 System: zero or one type, Storage and direct air capture if powerplants have CCS or methanation is used</li>
<li>Heating Grid: zero or one type, in developement and currently disabled</li>
</ul>
<p>Timetables are included for:</p>
<ul>
<li>Local demand of electric power, heat and gas</li>
<li>Local Renewable Producers: Wind Onshore, Wind Offshore, Photovoltaics, Biomass Plants, Biogas feed-in </li>
</ul>
<p><br>All of these elements are defined in the portfolio and can be adjusted to fit the user&apos;s application. Alongside them, an enumeration of their possible types has to be defined and maintained to allow manual selection in the user interface. Each portfolio also includes records for each element to store parameters. These records are designed to be adjustable manually or by externally. The number of component types will always be a structural parameter. </p>
<h4><span style=\"color: #000000\">Ports for electrical and gas grids</span></h4>
<p>The boundary conditions of each superstructure are the epp and gas ports. They represent grid nodes and should be connected to an electrical and a gas grid model. </p>
<h4>Control</h4>
<p>Inputs and outputs of the superstructure can be used for central or decentral control of the power grid using a controller like <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.Controller.ElectricalPowerController_outer\">this</a>. </p>
<h4>Failures</h4>
<p>Failures in a powerplant or another component in the region at a certain time may be simulated using the failure tables. This Feature is still in developement and currently disabled </p>
</html>"));
end UsageGuide;
