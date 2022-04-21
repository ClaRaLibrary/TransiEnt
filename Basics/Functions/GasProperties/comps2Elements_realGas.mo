within TransiEnt.Basics.Functions.GasProperties;
function comps2Elements_realGas "Universal function to calculate the molar flow rates of a medium's elements (C H O N S) out the components"



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

  input TILMedia.VLEFluidTypes.BaseVLEFluid realGasType annotation(choicesAllMatching=true);
//   input Real lambda;
  input Modelica.Units.SI.MassFraction[:] xi_in;
  input Modelica.Units.SI.MassFlowRate m_flow;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  parameter Integer nc = realGasType.nc_propertyCalculation "Number of components in fuel gas";
  parameter String[nc] realGasCompNames=TransiEnt.Basics.Functions.GasProperties.shortenCompName(realGasType.vleFluidNames) "Component names in fuel gas";
  parameter TransiEnt.Basics.Records.GasProperties.StoichiometricCoefficientsCombustion compStoichiometry;
  constant Modelica.Units.SI.MolarMass[nc] M_iC=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_realGas(realGasType, nc) "Molar masses of the gas components";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.MolarFlowRate[nc] n_flow_components "Molar flowrate of components";
  Modelica.Units.SI.MassFraction[nc] xi;
  Integer foundComp "Component find indexer";

public
  output Modelica.Units.SI.MolarFlowRate[5] n_flow_elements "Molar flowrate of elements";

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
  for i in 1:size(realGasCompNames,1) loop
    foundComp :=0;
    for j in 1:size(compStoichiometry.names, 1) loop
      if Strings.isEqual(compStoichiometry.names[j],realGasCompNames[i], caseSensitive = false) then
        foundComp :=foundComp + 1;
        for k in 1:size(compStoichiometry.stoich,2) loop
          n_flow_elements[k] := n_flow_elements[k] + n_flow_components[i] * compStoichiometry.stoich[j,k];
        end for;
      end if;
      assert(j < size(compStoichiometry.names, 1) or foundComp == 1, "The gas component " + realGasCompNames[i] + " is not listed in the stoichiometric record. Complete record or select another gasType.", level = AssertionLevel.warning);
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
end comps2Elements_realGas;
