within TransiEnt.Basics.Functions.GasProperties;
function comps2Elements_idealGas "Universal function to calculate the molar flow rates of a medium's elements out the components"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Function;
  import Modelica.Utilities.Strings;

  // _____________________________________________
  //
  //               Inputs / Outputs
  // _____________________________________________

  input TILMedia.GasTypes.BaseGas gasType annotation(choicesAllMatching=true);
//   input Real lambda;
  input Modelica.SIunits.MassFraction[:] xi_in;
  input Modelica.SIunits.MassFlowRate m_flow;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  parameter Integer nc = gasType.nc_propertyCalculation "Number of components in fuel gas";
  parameter String[nc] gasCompNames=TransiEnt.Basics.Functions.GasProperties.shortenCompName(gasType.gasNames) "Component names in fuel gas";
  parameter TransiEnt.Basics.Records.GasProperties.StoichiometricCoefficientsCombustion compStoichiometry;
  constant Modelica.SIunits.MolarMass[nc] M_iC=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_idealGas(gasType, nc) "Molar masses of the gas components";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.MolarFlowRate[nc] n_flow_components "Molar flowrate of components";
  Modelica.SIunits.MassFraction[nc] xi;
  Integer foundComp "Component find indexer";

public
  output Modelica.SIunits.MolarFlowRate[5] n_flow_elements "Molar flowrate of elements";

algorithm
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //Calculate full size massfraction vector (all nc components)
  if nc > 1 then
    for i in 1:size(xi_in,1) loop
      xi[i] := xi_in[i];
    end for;
      xi[end] := 1 - sum(xi_in);
  else
    xi[1] := 1;
  end if;

  //Calculate moleflowrates
  for i in 1:nc loop
    n_flow_components[i] := xi[i] * m_flow / M_iC[i];
  end for;

  //Calculate flowrate of elements
  for i in 1:size(gasCompNames,1) loop
    foundComp :=0;
    for j in 1:size(compStoichiometry.names, 1) loop
      if Strings.isEqual(compStoichiometry.names[j],gasCompNames[i], caseSensitive = false) then
        foundComp :=foundComp + 1;
        for k in 1:size(compStoichiometry.stoich,2) loop
          n_flow_elements[k] := n_flow_elements[k] + n_flow_components[i] * compStoichiometry.stoich[j,k];
        end for;
      end if;
      assert(j < size(compStoichiometry.names, 1) or foundComp == 1, "The gas component " + gasCompNames[i] + " is not listed in the stoichiometric record. Complete record or select another gasType.", level = AssertionLevel.warning);
    end for;
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function is used to convert a molar flow rate of gas components into a molar flowrate of the elements the components consist of.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in the gas which don&apos;t have a corresponding entry in the stoichiometric coefficients record ,they will just be ignored, giving a faulty heating value. The function will throw a warning.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tu-harburg.de), Mar 2015</p>
<p>Edited by Paul Kernstock (paul.kernstock@tuhh.de), Aug 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end comps2Elements_idealGas;
