within TransiEnt.UsersGuide;
package CodingConventions "Coding Conventions for the TransiEnt Library"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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






 extends ModelicaReference.Icons.Information;


annotation (preferredView="info",Documentation(info="<html>
<p><b><span style=\"font-size: 17pt; color: #4b8a49;\">Coding Conventions for the TransiEnt Library </span></b></p>
<p><b><span style=\"font-size: 12pt; color: #4b8a49;\">Model Design Principles </span></b></p>
<p>The following model design principles are adopted from the <a href=\"ClaRa.UsersGuide.GettingStarted\">ClaRa Library</a>. </p>
<p>When setting up the model of a complex physical system, the first question to be answered is what physical fidelity is needed to cope with the given simulation task. The answer to this question refers to the level of detail necessary for each component. The next step is to define the general physical effects to be considered for solving the given task. Finally, the level of physical insight into the considered physical aspects must be chosen. In what follows it will be explained how these three stages guide the model design of the TransiEnt library. For illustration the concept will be applied to the well-known example of a fluid flow in a pipe. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Levels of Detail </span></b></p>
<p>The TransiEnt library is intended to contain models at different levels of detail. It is mainly based on two criteria: </p>
<p>Purpose of model. In which simulation context will the model be used? What questions and physical effects shall be analyzed with the model? </p>
<p>Applicability of model. What are the main assumptions the model is based on? Are there some structural limitations? </p>
<p>The model design of the TransiEnt Library has been inspired by these ideas. Moreover it aims to provide a well-balanced combination of readability, modelling flexibility and avoidance of code duplication. Consequently, each component in the TransiEnt library is represented by a family of freely exchangeable models. Every component family is grouped into four levels of detail: </p>
<ul>
<li>L1: Models are based on characteristic lines and / or transfer functions, e.g. <a href=\"TransiEnt.Storage.Base.GenericStorage\">GenericStorage</a>. This results in an idealized model, which shows physical behavior. The model definition may be derived either from analytic solutions to the underlying physics or from phenomenological considerations. Applicability is limited to the validity of the simplification process. Non-physical behavior may occur otherwise. </li>
<li>L2: Models are based on balance equations, e.g. <a href=\"TransiEnt.Storage.Heat.HotWaterStorage_L2\">HotWaterStorage_L2</a>. These equations are spatially averaged over the component (lumped volume). The models show a correct physical behavior unless the assumptions for the averaging process are violated. </li>
<li>L3: Models are by construction subdivided into a fixed number of spatial zones. The spatial localization of these zones is not necessarily fixed and can vary dynamically. For each zone a set of balance equations is used and the model properties (e.g. media data) are averaged zone-wise. The models show a correct physical behavior unless the assumptions for the zonal subdivision and the averaging process over zones are violated. </li>
<li>L4: Models can be subdivided into an arbitrary number of spatial zones (control volumes) by the user. They thus provide a true spatial resolution. For each zone a set of balance equations is used which is averaged over that zone, e.g. <a href=\"TransiEnt.Components.Gas.Reactor.Methanator_L4\">Methanator_L4</a> or <a href=\"TransiEnt.Storage.Heat.HeatStorage_Stratified.StratifiedHotWaterStorage_L4\">StratifiedHotWaterStorage_L4</a>. The model shows a correct physical behavior unless the assumptions for the choice of grid and the averaging process over the control volumes are violated. </li>
</ul>
<p>These levels of detail adapted cannot be applied directly to purely electrical models. Hence, the following levels of detail are defined especially for purely electrical models: </p>
<ul>
<li>L1E: Models are based on characteristic lines, gains or efficiencies. Example: Triac model as a switch </li>
<li>L2E: Models are based on (dynamic) transfer functions or differential equations. Example: generator model without excitation circuit </li>
<li>L3E: Models are based on electrical networks in quasi-stationary form. Example: Pi model for a transmission line </li>
<li>L4E: Models are based on a combination of (dynamic) transfer functions or differential equations and electrical networks in quasi-stationary form. Example: generator model with excitation circuit </li>
</ul>
<p>L1E-L4E: This results in an idealized model, which shows physical behavior. The model definition may be derived either from analytic solutions to the underlying physics or from phenomenological considerations. Applicability is limited to the validity of the simplification process. Non-physical behavior may occur otherwise. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Physical effects to be considered </span></b></p>
<p>Once the decision for a specific detail group of models is made, the set of required physical effects to be covered by a model may still differ according to the simulation goal. For instance, in a pipe model it might be necessary to resolve the spatial flow properties but unnecessary to analyze sound waves in detail. This is reflected in the complexity of the basic physical equations underlying the model. </p>
<p>Notice that, although the TransiEnt library is designed for dynamic simulations, it is still possible to include models, where parts of the basic physical equations correspond to the stationary behavior of a component. Such models are often favorable with respect to computation time and stability. Their use is appropriate whenever certain aspects of the component dynamics can be neglected compared to the system dynamics under consideration. In the pipe example above this would be manifested by the fact that if only fluid flow properties (temperature profile, flow velocities, etc.) are of interest, sound wave propagation can be neglected, as long as the flow velocity is much less than the speed of sound. Consequently a stationary momentum balance for the fluid would be sufficient in this case. </p>
<p>In order to cope with these different needs, the TransiEnt library provides component models at the same level of detail but covering different physical effects. They are distinguished by different self-explaining names. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Level of Insight </span></b></p>
<p>By now, the fundamental equations of a model are defined by setting its level of detail and the physical effects of consideration. However, these equations declare which physical effects are considered, but not how they are considered. For instance, the pressure loss in a pipe may be modelled using constant nominal values or via correlations taking the flow regime and the fluid states into account. These physical effects are therefore modelled in replaceable models that complete the fundamental equations using predefined interfaces, e.g. the friction term in the momentum balance. By separating the governing model definition from the underlying sub-models, the flexibility of the model is enhanced without losing readability. </p>
<p><b><span style=\"font-size: 12pt; color: #4b8a49;\">Naming</span></b></p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Naming of Models </span></b></p>
<p>During development process we suggest to use the following naming scheme: </p>
<p><span style=\"font-family: Courier New;\">MyModel_Lx </span></p>
<p><span style=\"font-family: Courier New;\">MyModel</span> should be short but distinct enough that it is possible to distinguish other similar classes from each other. <span style=\"font-family: Courier New;\">Lx</span> should be replaced by the according level of detail. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Classes and Instances </span></b></p>
<p>Class and instance names are written in upper and lower case letters, e.g., <span style=\"font-family: Courier New;\">ElectricCurrent</span>. An underscore is only used at the end of a name to characterize a lower or upper index, e.g., <span style=\"font-family: Courier New;\">pin_a</span>. </p>
<p>Class names start always with an upper case letter. </p>
<p>Instance names, i.e., names of component instances and of variables (with the exception of constants), start usually with a lower case letter with only a few exceptions if this is common sense (such as <span style=\"font-family: Courier New;\">T</span> for a temperature variable). </p>
<h4><span style=\"color: #4b8a49\">Connectors </span></h4>
<p>The connectors of a model should be named corresponding to their function and the medium. </p>
<ul>
<li><span style=\"font-family: Courier New;\">epp</span> for electrical power ports </li>
<li><span style=\"font-family: Courier New;\">mpp</span> for mechanical ports </li>
<li><span style=\"font-family: Courier New;\">heat</span> for heat ports, if there are several, use for example heat_exhaustGas </li>
<li><span style=\"font-family: Courier New;\">gasPortIn</span> and <span style=\"font-family: Courier New;\">gasPortOut</span> for gas ports </li>
<li><span style=\"font-family: Courier New;\">waterPortIn</span> and <span style=\"font-family: Courier New;\">waterPortOut</span> for water fluid ports </li>
</ul>
<p>Real inputs and outputs (<a href=\"Modelica.Blocks.Interfaces.RealInput\">Modelica.Blocks.Interfaces.RealInput</a>/<a href=\"Modelica.Blocks.Interfaces.RealOutput\">RealOutput</a>) should be defined more precisely using the <span style=\"font-family: Courier New;\">quantity</span>, <span style=\"font-family: Courier New;\">unit</span> and <span style=\"font-family: Courier New;\">displayUnit</span>, e.g. </p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New;\">final quantity=&quot;Pressure&quot;, </span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New;\">final unit=&quot;Pa&quot;, </span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New;\">displayUnit=&quot;bar&quot;</span>. </p>
<p>The <span style=\"font-family: Courier New;\">final quantity</span> should be chosen fitting to the SI units used for the variable in <a href=\"Modelica.SIunits\">Modelica.SIunits</a>. </p>
<h4><span style=\"color: #4b8a49\">Fluid models </span></h4>
<p>For fluid models use the same name like for the corresponding port, just without the word port, e.g. <span style=\"font-family: Courier New;\">waterIn</span>, <span style=\"font-family: Courier New;\">gasOut</span>. </p>
<h4><span style=\"color: #4b8a49\">Constants, Parameters and Variables </span></h4>
<p>Constant names, i.e., names of variables declared with the <span style=\"font-family: Courier New;\">constant</span> prefix, follow the usual naming conventions (= upper and lower case letters) and start usually with an upper case letter, e.g., <span style=\"font-family: Courier New;\">UniformGravity</span>, <span style=\"font-family: Courier New;\">SteadyState</span>. </p>
<p>Constants, parameters and variables should be named after the following convention. </p>
<ul>
<li><span style=\"font-family: Courier New;\">T</span> for temperatures in K </li>
<li><span style=\"font-family: Courier New;\">p</span> for pressures in Pa </li>
<li><span style=\"font-family: Courier New;\">m</span> for masses in kg </li>
<li><span style=\"font-family: Courier New;\">P</span> for powers in W </li>
<li><span style=\"font-family: Courier New;\">Q</span> for heats in J </li>
<li><span style=\"font-family: Courier New;\">W</span> for works in J </li>
<li><span style=\"font-family: Courier New;\">H</span> for enthalpies in J</li>
<li><span style=\"font-family: Courier New;\">omega</span> for angular velocities in rad/s</li>
</ul>
<p>Indices should follow this convention: </p>
<ul>
<li><span style=\"font-family: Courier New;\">der_</span>* for time derivatives like <span style=\"font-family: Courier New;\">der_T = der(T) </span></li>
<li><span style=\"font-family: Courier New;\">Delta_</span>* for differences </li>
<li>*<span style=\"font-family: Courier New;\">_flow</span> for a flow variable like <span style=\"font-family: Courier New;\">Q_flow</span> and <span style=\"font-family: Courier New;\">m_flow</span> </li>
<li>*<span style=\"font-family: Courier New;\">_el</span> for electric variables </li>
<li>*<span style=\"font-family: Courier New;\">_start</span> for initial values </li>
<li>*<span style=\"font-family: Courier New;\">_nom</span> for nominal values of fluid properties, e.g. pressure, temperature </li>
<li>*<span style=\"font-family: Courier New;\">_n</span> for nominal values of other properties </li>
<li>*<span style=\"font-family: Courier New;\">_max</span> or *<span style=\"font-family: Courier New;\">_min</span> for maximal or minimal values </li>
<li>*<span style=\"font-family: Courier New;\">_grad</span> for gradients </li>
<li>*<span style=\"font-family: Courier New;\">_set</span> for set values </li>
</ul>
<p>Several of these indices can be combined using underscores, e.g. <span style=\"font-family: Courier New;\">P_el_grad_max</span>, while the order should be the same as in the list above. </p>
<p>Suggestions for the extension of these lists can be proposed to the TransiEnt Library Consortium. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Parameter Dialogs </span></b></p>
<p>Every constant, parameter and variable should have a declarative comment. This comment should start with an upper-case letter. </p>
<p>Parameters should be arranged in tabs and groups using one of the following categories </p>
<ul>
<li>Fundamental Definitions: e.g. media definitions </li>
<li>Geometry </li>
<li>Nominal Values </li>
<li>Heat Transfer </li>
<li>Mass Transfer </li>
<li>Part Load Definition </li>
<li>Time Response Definition </li>
<li>Control Definition </li>
<li>Statistics </li>
<li>Initialization </li>
<li>Numerical Stability </li>
</ul>
<p>Suggestions for the extension of this list with more general categories can be proposed to the TransiEnt Library Consortium. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Source Code Layout </span></b></p>
<p>The source code should have the following main blocks: </p>
<ul>
<li>Imports and Class Hierarchy </li>
<li>Constants and Hidden Parameters </li>
<li>Visible Parameters </li>
<li>Outer Models </li>
<li>Interfaces </li>
<li>Instances of other classes </li>
<li>Variable Declarations </li>
<li>Private Functions (only for plotResult protected function) </li>
<li>Characteristic equations </li>
<li>Connect Statements </li>
</ul>
<p>An example can be found in <a href=\"TransiEnt.UsersGuide.CodingConventions.Examples.TemplateModel\">TransiEnt.UsersGuide.CodingConventions.Examples.TemplateModel</a>. </p>
<p>If, for example, a model does not have any constants and hidden parameters, the corresponding comment block should be deleted. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Documentation </span></b></p>
<p>The documentation should include the following sections to make the assumptions of the model clear for the user. </p>
<ol>
<li>Purpose of model </li>
<li>Level of detail, physical effects considered, and physical insight </li>
<li>Limits of validity </li>
<li>Interfaces </li>
<li>Nomenclature </li>
<li>Governing Equations </li>
<li>Remarks for Usage </li>
<li>Validation </li>
<li>References </li>
<li>Version History </li>
</ol>
<p>Model created by Max Mustermann (mustermann@mustermail.com), Apr 2014 </p>
<p>Model modified by Maxime Musterfrau (musterfrau@mustermail.com), Feb 2018 </p>
<p>In the version history, the creator and the modifiers should be listed, including email addresses and the month and year. For major changes, a short description of the modifications in the model should be added. </p>
<p>The reference style should be the IEEE style, e.g.: </p>
<p>[1] L. Andresen, P. Dubucq, R. Peniche, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Status of the TransiEnt Library: Transient simulation of coupled energy networks with high share of renewable energy,&rdquo; in <i>Proceedings of the 11th International Modelica Conference</i>, 2015, pp. 695&ndash;705. </p>
<p>An example can be found in <a href=\"TransiEnt.UsersGuide.CodingConventions.Examples.TemplateModel\">TransiEnt.UsersGuide.CodingConventions.Examples.TemplateModel</a>. </p>
<p><b><span style=\"font-size: 12pt; color: #4b8a49;\">Miscellaneous </span></b></p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Icons for Base Classes </span></b></p>
<p>Icons for base classes should be saved into <a href=\"TransiEnt.Basics.Icons\">TransiEnt.Basics.Icons</a>. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Equations </span></b></p>
<p>Equations should always be written in the equation section except for direct assignment of one variable to another which can be written directly in the variable declaration. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Protected </span></b></p>
<p>The code word <span style=\"font-family: Courier New;\">protected</span> should only be used for minor components to avoid setting variables to protected which the user might want to see. If faster simulations are wanted, the user can set all components to protected on the top level and write a summary of the most important variables manually. </p>
<p><b><span style=\"font-size: 10pt; color: #4b8a49;\">Integrators </span></b></p>
<p>Integrators for check variables (which are not actually used in the model but might be useful to see for the user) should be able to be turned on or off because unnecessary integrators slow down the simulations. The default should be off.</p>
</html>"));
end CodingConventions;
