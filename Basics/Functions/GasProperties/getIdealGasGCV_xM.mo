within TransiEnt.Basics.Functions.GasProperties;
function getIdealGasGCV_xM "Adaptive function for gross calorific value calculation from molar GCVs, input x and M"
  // LA: has to be adapted according to the realGas function, but adaptions in models where the function is used are also necessary!



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

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter Real[idealGasType.nc] GCVm_vec=getIdealGasGCVmVector(idealGasType);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  input TILMedia.GasTypes.BaseGas idealGasType "Ideal gas type" annotation(choicesAllMatching=true);
  input SI.MoleFraction[:] x_in "Mole fractions";
  input SI.MolarMass M_in "Molar mass";
  input SI.SpecificEnthalpy GCVIn "Set this to a specific value for a constant GCV or to zero for GCV calculation";
  output SI.SpecificEnthalpy GCVOut "Returned GCV";

protected
  SI.MoleFraction[idealGasType.nc] x=cat(1,x_in,{1-sum(x_in)}) "Molar composition of component";

algorithm
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //If GCVin has a value except 0 (no variable LHV calculation) set GCVout = GCVin
  if GCVIn <> 0 then
    GCVOut:=GCVIn;
  else
    //Search for component in GCVComponentValues and add it to total GCV weighted by molefraction
    GCVOut:=sum(x*GCVm_vec);
  end if;

protected
  function getIdealGasGCVmVector
    import X = Modelica.Utilities.Strings;
    import S = Modelica.Utilities.Streams;
    input  TILMedia.GasTypes.BaseGas idealGasType "Real gas type" annotation(choicesAllMatching=true);
    output Real[idealGasType.nc] GCVm_vec "Vector containing gross calorific values of specified medium components";
  protected
   parameter Integer nc = idealGasType.nc_propertyCalculation "Number of components in fuel";
    parameter String[nc] components=TransiEnt.Basics.Functions.GasProperties.shortenCompName(idealGasType.gasNames) "Shortens the components names (eg. Refprop.Methane -> Methane)";
    parameter TransiEnt.Basics.Records.GasProperties.MolarGrossCalorificValues compValues "Record with components GCV values in MJ per kg";
   Integer foundComp "Component find indexer";
  algorithm
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

  end getIdealGasGCVmVector;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to calculate the gross calorific value (GCV), also known as higher heating value (HHV) of a fuel gas mixture based on the mole fractions and molar mass and respective molar calorific values from a record.</p>
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
<p>GCVIn was added to give the possibility to define a constant calorific value. If this value is set to 0, the GCV will be calculated by the composition of the defined medium.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Basics.Functions.GasProperties.Check.TestGCVCalculation&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"));
end getIdealGasGCV_xM;
