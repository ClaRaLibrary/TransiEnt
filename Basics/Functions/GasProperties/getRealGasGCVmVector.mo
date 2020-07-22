within TransiEnt.Basics.Functions.GasProperties;
function getRealGasGCVmVector "Function to get molar gross calorific value vactor for real gases"

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

  extends TransiEnt.Basics.Icons.Function;
  import X = Modelica.Utilities.Strings;
  import S = Modelica.Utilities.Streams;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

   //parameter Integer nc = realGasType.nc_propertyCalculation "Number of components in fuel";
protected
   parameter String[nc] components=shortenCompName(                                         realGasType.vleFluidNames) "Shortens the components names (eg. Refprop.Methane -> Methane)";
   parameter TransiEnt.Basics.Records.GasProperties.MolarGrossCalorificValues compValues "Record with components GCV values in kJ per mol";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  input TILMedia.VLEFluidTypes.BaseVLEFluid realGasType "Real gas type" annotation(choicesAllMatching=true);
  input Integer nc;
  output Real[nc] GCVm_vec "Vector containing gross calorific values of specified medium components";
protected
  Integer foundComp "Component find indexer";

algorithm
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

    for i in 1:nc loop
      foundComp :=0;
      for j in 1:size(compValues.components, 1) loop
        if X.isEqual(components[i], compValues.components[j], caseSensitive = false) then
          foundComp :=foundComp + 1;
          GCVm_vec[i]:=compValues.compValues[j];
        end if;
        assert(j < size(compValues.components, 1) or foundComp == 1, "The gas component " + components[i] + " is not listed in the GCV record. Complete record or select another gas type.", level = AssertionLevel.warning);
      end for;
    end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to get the vector the molar gross calorific values (GCVm), also known as higher heating values (HHVm), of a given fuel gas mixture from a record.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in the gas which don&apos;t have a corresponding entry in the GCVm values record, they will just be ignored, giving a faulty calorific value. The function will throw a warning.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"));
end getRealGasGCVmVector;
