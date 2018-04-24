within TransiEnt;
package UsersGuide "User's Guide"
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

  extends Modelica.Icons.Information;


annotation (Documentation(info="<html>
<h4>Overview</h4>
<p>The layout of the library was chosen carefully in the purpose of reuse-ability by applicants as well as expand-ability by model developers. The <a href=\"TransiEnt.Basics\">Basics</a> package contains supporting classes like functions, units, blocks, media records, data tables, icons, and interfaces. Single components, e.g. electrical machines, pumps, and pipes, are structured within the <a href=\"TransiEnt.Components\">Components</a> package. These first two packages are meant to be used and modified by advanced users and developers only, whereas the remaining packages are meant for users that want to build up energy systems in order to examine different scenarios. </p>
<p>These packages are named after the four participating groups in the energy supply system: producer, consumer, grid, and storage. Within the <a href=\"TransiEnt.Producer\">Producer</a> package there are small and large, conventional and renewable plants converting primary energy into electric work, heat or both. The <a href=\"TransiEnt.Consumer\">Consumer</a> package comprises models of electric power and thermal power loads for households, commercial buildings, industry as well as for bigger areas like city districts or whole cities. The package <a href=\"TransiEnt.Grid\">Grid</a> is composed of electric, heat, and gas distribution elements. Within the <a href=\"TransiEnt.Storage\">Storage</a> package there are different power-to-power (e.g. pumped hydro storage), heat-to-heat (e.g. sensible water storage tanks), gas-to-gas (e.g. caverns), as well as power-to-heat and power-to-gas converters. The last package <a href=\"TransiEnt.Examples\">Examples</a> contains examples for the different system models in general and for the examined system of the city of Hamburg. These examples allow the users to understand the usage of components and the scope of application of the library.</p>
<h5>Test models</h5>
<p>Most models in the TransiEnt Library have an associated test model with minimum boundary conditions that enable a simulation of the model. These are named after the tested component and are located in a package named Check, e.g. <a href=\"TransiEnt.Components.Electrical.Machines.ActivePowerGenerator\">ActivePowerGenerator</a> and <a href=\"TransiEnt.Components.Electrical.Machines.Check.CheckActivePowerGenerator\">Check/CheckActivePowerGenerator</a>. Some of these testers include a nested function with the name <a href=\"TransiEnt.Components.Electrical.Machines.Check.CheckVariableSpeedActivePowerGenerator.plotResult\">plotResult()</a> which can be execute after the simulation and plot striking results illustrating the level of detail and behavior of the component.</p>
<h4>Connectors</h4>
<p>The <a href=\"Modelica\">Modelica standard library</a> defines the most important elementary connectors in various domains. However, the TransiEnt library defines two alternative connectors: one for fluids and one for electric terminals. The fluid interface <a href=\"TransiEnt.Basics.Interfaces.Thermal.FluidPort\">fluidPort</a> is taken from the <a href=\"ClaRa\">ClaRa</a> library - since most basic components (e.g. pipes for the heating grids) are used and extended from there. The medium model in the connector is an extension of the <a href=\"TILMedia\">TILMedia</a> class <a href=\"TILMedia.VLEFluidTypes.BaseVLEFluid\">BaseVLEFluid</a>. For real fluid behavior this type of medium class is favored. For ideal gas behavior (e.g. assumed for exhaust gas), the <a href=\"TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPort\">IdealGasEnthPort</a> and <a href=\"TransiEnt.Basics.Interfaces.Gas.IdealGasTempPort\">IdealGasTempPort</a> can be used which contain medium models based on the TILMedia <a href=\"TILMedia.GasTypes.BaseGas\">BaseGas</a> definition.</p>
<p>The mainly used electric interface <a href=\"TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort\">ActivePowerPort</a> has two variables: active power and frequency. Most of the electric models in the coupled energy system models use this interface, since it is sufficient for surveys that do not consider voltage stability, load flow calculations or non-symmetrical three phase systems. Alternatively the <a href=\"TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort\">ApparentPowerPort</a> can be used which adds voltage and reactive power. </p>
<p>The TransiEnt Library provides adapters which allow the user to connect models from the Modelica Standard Library to system models within TransiEnt, e.g. in <a href=\"TransiEnt.Basics.Adapters.Check.TestEPP_to_QS\">TestEPP_to_QS</a> the connection of <a href=\"Modelica.Electrical.QuasiStationary\">MSL.Quasistationary</a> components is illustrated.</p>
<h4>Conventions</h4>
<h5>Sign conventions</h5>
<p>The sign conventions in the TransiEnt Library follow the consumer side convention: In consumers the flow variables are positive and in producers the flow variables are negative. If setpoints are passed to the models, they are supposed to have the same sign as the flow variable in the connector. For example a power plant model gets negative setpoints and has a negative power flow in its connector. Storage models get positive values for loading (increase of the state of charge). These conventions are illustrated in the picture below.</p>
<p align=\"center\"><img src=\"modelica://TransiEnt/Images/signConvention.JPG.png\"/></p>
<h5>Level of detail</h5>
<p>The TransiEnt library is intended to contain models at different levels of detail. It is mainly based on two criteria:</p>
<p>1. Purpose of model. In which simulation context will the model be used? What questions and physical effects shall be analyzed with the model?</p>
<p>2. Applicability of model. What are the main assumptions the model is based on? Are there some structural limitations?</p>
<p>Some models are named in a way that show the level of detail with respect to a spatial discretization. The following suffixes are used</p>
<ul>
<li>L1: Models are based on characteristic lines and / or transfer functions, e.g. <a href=\"TransiEnt.Storage.Base.GenericStorage\">GenericStorage</a>. This results in an idealized model, which shows physical behavior. The model definition may be derived either from analytic solutions to the underlying physics or from phenomenological considerations. Applicability is limited to the validity of the simplification process. Non-physical behavior may occur otherwise.</li>
<li>L2: Models are based on balance equations. These equations are spatially averaged over the component (lumped volume), e.g. <a href=\"TransiEnt.Storage.Heat.HotWaterStorage_L2\">HotWaterStorage_L2</a>. The models show a correct physical behavior unless the assumptions for the averaging process are violated.</li>
<li>L3: Models are by construction subdivided into a fixed number of spatial zones. The spatial localization of these zones is not necessarily fixed and can vary dynamically. For each zone a set of balance equations is used and the model properties (e.g. media data) are averaged zone-wise, e.g. <a href=\"TransiEnt.Storage.Heat.HeatStorageStratified_constProp.StratifiedHotWaterStorage_L3\">StratifiedHotWaterStorage_L3</a>. The models show a correct physical behavior unless the assumptions for the zonal subdivision and the averaging process over zones are violated.</li>
<li>L4: Models can be subdivided into an arbitrary number of spatial zones (control volumes) by the user. They thus provide a true spatial resolution. For each zone a set of balance equations is used which is averaged over that zone, e.g. <a href=\"TransiEnt.Producer.Gas.Methanator.Methanator_L4\">Methanator_L4</a>. The model shows a correct physical behavior unless the assumptions for the choice of grid and the averaging process over the control volumes are violated.</li>
</ul>
</html>"));
end UsersGuide;
