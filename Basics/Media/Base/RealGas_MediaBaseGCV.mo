within TransiEnt.Basics.Media.Base;
model RealGas_MediaBaseGCV

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

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  replaceable parameter TILMedia.VLEFluidTypes.BaseVLEFluid realGasType
   constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Real gas type" annotation(choicesAllMatching=true);
  parameter SI.SpecificEnthalpy GCVIn=0.0 "Set this to a specific value for a constant GCV or to zero for GCV calculation";
  final parameter SI.SpecificEnthalpy[realGasType.nc] GCV_vec=Functions.GasProperties.getRealGasGCVVector(                 realGasType, realGasType.nc);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 input SI.MassFraction[realGasType.nc-1] xi_in "Mass fractions" annotation(Dialog);


protected
  SI.MassFraction[realGasType.nc] xi=cat(1,xi_in,{1-sum(xi_in)}) "Mass weighted composition of components per kg fuel";
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to calculate the mass specific gross calorific value (GCV), also known as higher heating value (HHV) of a fuel gas mixture based on mass fractions and repective mass weighted calorific values from a record.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>xi_in is the mass fraction</p>
<p>GCV is the gross calorific value</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in the gas which don&apos;t have a corresponding entry in the GCV values record, they will just be ignored, giving a faulty calorific value. The function will throw a warning.</p>
<p>GCVIn was added to give the possibility to define a constant calorific value. If this value is set to 0, the GCV will be calculated by the composition of the medium.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Westphal (j.westphal@tuhh.de), June 2019, based on a model of Lisa Andresen</p>
</html>"));
end RealGas_MediaBaseGCV;
