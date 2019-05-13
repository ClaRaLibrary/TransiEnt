within TransiEnt.Basics.Functions.GasProperties;
function getIdealGasNCV_xi "Adaptive function for net calorific value calculation for ideal gases, input xi"

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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Function;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter SI.SpecificEnthalpy[idealGasType.nc] NCV_vec=getIdealGasNCVVector(idealGasType);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  input TILMedia.GasTypes.BaseGas idealGasType "Ideal gas type" annotation(choicesAllMatching=true);
  input SI.MassFraction[:] xi_in "Mass fractions";
  input SI.SpecificEnthalpy NCVIn "Set this to a specific value for a constant NCV or to zero for NCV-calculation";
  output SI.SpecificEnthalpy NCVOut "Returned NCV";

protected
  SI.MassFraction[idealGasType.nc] xi=cat(1,xi_in,{1-sum(xi_in)}) "Mass weighted composition of components per kg fuel";

algorithm
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //If NCVIn has a value except 0 (no variable NCV calculation) set NCVout = NCVin
  if NCVIn <> 0 then
    NCVOut:=NCVIn;
  else
    //Search for component in NCVComponentValues and add it to total NCV = sum(xi_i * NCV_i)
    NCVOut:=sum(xi*NCV_vec);
  end if;

protected
  function getIdealGasNCVVector
    import X = Modelica.Utilities.Strings;
    import S = Modelica.Utilities.Streams;
    input  TILMedia.GasTypes.BaseGas idealGasType "Real gas type" annotation(choicesAllMatching=true);
    output SI.SpecificEnthalpy[idealGasType.nc] NCV_vec "Vector containing gross calorific values of specified medium components";
  protected
   parameter Integer nc = idealGasType.nc_propertyCalculation "Number of components in fuel";
   parameter String[nc] components=shortenCompName(                                         idealGasType.gasNames) "Shortens the components names (eg. Refprop.Methane -> Methane)";
   parameter TransiEnt.Basics.Records.GasProperties.NetCalorificValues compValues "Record with components NCV values in MJ per kg";
   Integer foundComp "Component find indexer";
  algorithm
    for i in 1:nc loop
      foundComp :=0;
      for j in 1:size(compValues.components, 1) loop
        if X.isEqual(components[i], compValues.components[j], caseSensitive = false) then
          foundComp :=foundComp + 1;
          NCV_vec[i]:=compValues.compValues[j];
        end if;
        assert(j < size(compValues.components, 1) or foundComp == 1, "The gas component " + components[i] + " is not listed in the NCV record. Complete record or select another gas type.", level = AssertionLevel.warning);
      end for;
    end for;

  end getIdealGasNCVVector;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to calculate the net calorific value (NCV), also known as lower heating value (LHV) of a fuel gas mixture based on mass fractions and respective mass weighted calorific values from a record.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in the gas which don&apos;t have a corresponding entry in the NCV values record, they will just be ignored, giving a faulty calorific value. The function will throw a warning.</p>
<p>NCVIn was added to give the possibility to define a constant calorific value. If this value is set to 0, the NCV will be calculated by the composition of the medium.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Basics.Functions.GasProperties.Check.TestNCVCalculation&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"));
end getIdealGasNCV_xi;
