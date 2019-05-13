within TransiEnt.Basics.Functions.GasProperties;
function getMolarMasses_realGas "Function to calculate the molar masses of a VLE medium's components with TILMedia"

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

  // _____________________________________________
  //
  //               Inputs / Outputs
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Function;

  input TILMedia.VLEFluidTypes.BaseVLEFluid realGasType annotation(choicesAllMatching=true);
  input Integer nc;
  output Modelica.SIunits.MolarMass[nc] M_i "Molar masses of the gas components";

algorithm
  assert(not realGasType.fixedMixingRatio, "The gas type record has fixed mixing ratio set. TILMedia does therefore not compute molar masses of the fractions!", AssertionLevel.warning);
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //get molar masses of fuels's components
  for i in 0:nc-1 loop
     M_i[i+1] :=TILMedia.VLEFluidFunctions.molarMass_n(realGasType, i);
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function get the molar masses of the components of the given TILMedia VLEFluidType.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2015</p>
</html>"));
end getMolarMasses_realGas;
