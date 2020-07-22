within TransiEnt.Producer.Gas.BiogasPlant.MaterialValues;
model SuspensionProperties_pT "Model calculating material properties of anaerobic sludge"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Icons.MaterialProperty;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TransiEnt.Producer.Gas.BiogasPlant.MaterialValues.Records.ManureParticles solids constrainedby TransiEnt.Producer.Gas.BiogasPlant.MaterialValues.Records.BaseSuspendedSolids "replaceable record of sludge particle properties";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid fluid=simCenter.fluid1 "water as solvent";
  parameter Boolean useFixedViscosity=false "enable if Apparent Viscosity of sludg shall be set instead of being calculated from Temperature, Stirring Speed and Solids Content";
  parameter Modelica.SIunits.DynamicViscosity eta_fixed=0.1 "set fixed Apparent Viscosity" annotation (Dialog(enable=useFixedViscosity));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input Modelica.SIunits.Pressure p=101300 "pressure in Suspension" annotation (Dialog(group="Variables"));
  input Modelica.SIunits.Temperature T=293.15 "Temperature of Suspension" annotation (Dialog(group="Variables"));
  input Modelica.SIunits.MassConcentration TSS=10 "Total Solids Concentration in g/l" annotation (Dialog(group="Variables"));
  input Modelica.SIunits.Frequency gamma=2 "Average Shear rate as induced by stirrer" annotation (Dialog(group="Variables"));

  Modelica.SIunits.Density rho "Density of Sludge";
  Modelica.SIunits.SpecificHeatCapacity cp "specific heat capacity of Suspension";
  Modelica.SIunits.ThermalConductivity lambda "Thermal Conductivity of Suspension";
  Modelica.SIunits.DynamicViscosity eta "Dynamic Viscosity of Suspension either variable or as input";
  Modelica.SIunits.DynamicViscosity eta_calc "Calculated Dynamic Viscosity of Suspension";
  Modelica.SIunits.PrandtlNumber Pr=eta*cp/lambda "Prandtl number of Suspension";

  Real W(
    min=0,
    max=1) = 1 - TSS/rho "Water content in Suspension as mass fraction";
  Real TS(
    min=0,
    max=1) = TSS/rho "Mass fraction of Solids in Suspension";
  Real phi(
    min=0,
    max=1) = TSS/solids.rho "Volume fraction of Solids in Suspension";

  Real K "consistency index of manure";
  Real n "flow index of manure";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluid(
    vleFluidType=fluid,
    T=T,
    computeTransportProperties=true,
    p=p) annotation (Placement(transformation(extent={{-16,-20},{16,12}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation
  rho = TSS*(solids.rho - vleFluid.d)/solids.rho + vleFluid.d "sludge density acc. to Wills, B. A., & Napier-Munn, T. (2005) Metallurgical accounting, control and simulation";
  cp = vleFluid.cp*W + solids.cp*(1 - W) "specific heat capacity equation acc to Kim, Y., & Parker, W. (2008) of sludge acc. to Chen, Y. R. (1983). Thermal properties of beef cattle manure.";
  lambda = vleFluid.transp.lambda*rho/vleFluid.d - 5.1e-4*TS "thermal conductivity acc. to Chen, Y. R. (1983). Thermal properties of beef cattle manure.";

  K = 8.722e-10*exp(4830/T + 58.319*TS) "consistency index acc. to Achkari-Begdouri, A., & Goodrich, P. R. (1992). Rheological properties of Moroccan dairy cattle manure.";
  n = 0.6894 + 4.6831e-3*(T - 273) - 4.2813*TS "flow index of manure acc. to Achkari-Begdouri, A., & Goodrich, P. R. (1992). Rheological properties of Moroccan dairy cattle manure.";

  eta_calc = K*gamma^(n - 1) "apparent viscosity calculated from OSTWALD-model";

  if useFixedViscosity then
    eta = eta_fixed;
  else
    eta = eta_calc;
  end if;

  annotation (
    choicesAllMatching=true,
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-152,150},{148,110}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Wills,&nbsp;B.&nbsp;A.,&nbsp;&amp;&nbsp;Napier-Munn,&nbsp;T.&nbsp;(2005)&nbsp;Metallurgical&nbsp;accounting,&nbsp;control&nbsp;and&nbsp;simulation</p>
<p>[2]Kim,&nbsp;Y.,&nbsp;&amp;&nbsp;Parker,&nbsp;W.&nbsp;(2008)&nbsp;of&nbsp;sludge&nbsp;acc.&nbsp;to&nbsp;Chen,&nbsp;Y.&nbsp;R.&nbsp;(1983).&nbsp;Thermal&nbsp;properties&nbsp;of&nbsp;beef&nbsp;cattle&nbsp;manure</p>
<p>[3]Chen,&nbsp;Y.&nbsp;R.&nbsp;(1983).&nbsp;Thermal&nbsp;properties&nbsp;of&nbsp;beef&nbsp;cattle&nbsp;manure</p>
<p>[4]Achkari-Begdouri,&nbsp;A.,&nbsp;&amp;&nbsp;Goodrich,&nbsp;P.&nbsp;R.&nbsp;(1992).&nbsp;Rheological&nbsp;properties&nbsp;of&nbsp;Moroccan&nbsp;dairy&nbsp;cattle&nbsp;manure</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de), May 2020</p>
</html>"));
end SuspensionProperties_pT;
