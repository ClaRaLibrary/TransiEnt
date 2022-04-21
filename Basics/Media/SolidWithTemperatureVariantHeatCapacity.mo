within TransiEnt.Basics.Media;
model SolidWithTemperatureVariantHeatCapacity



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
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.Density d = solid.d "Density";

  constant SI.SpecificHeatCapacity cp_nominal=solid.cp_nominal
    "Specific heat capacity at standard reference point";

  constant SI.ThermalConductivity lambda_nominal=solid.lambda_nominal
    "Thermal conductivity at standard reference point";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input SI.Temperature T "Temperature" annotation(Dialog);


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    replaceable model SolidType = TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity constrainedby TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity
                                   "type record of the solid"
    annotation(choicesAllMatching=true);


protected
  SolidType solid(final T=T);



  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
   SI.SpecificHeatCapacity cp "Heat capacity";
   SI.ThermalConductivity lambda "Thermal conductivity";


   ClaRa.Basics.Units.EnergyMassSpecific specificInternalEnergy;
   ClaRa.Basics.Units.EntropyMassSpecific specificEntropy;

equation


  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  cp = solid.cp;
  lambda = solid.lambda;

  specificInternalEnergy = solid.specificInternalEnergy;
  specificEntropy = solid.specificEntropy;



  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used as base model, which is extended from the temperature variant solid model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Michael von der Heyde (heyde@tuhh.de), March 2021, for the FES research project</p>
</html>"), Icon(graphics={         Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Text(
          extent={{-100,-100},{100,-140}},
          textColor={0,134,134},
          textString="%name"),
        Text(
          extent={{-80,80},{80,-80}},
          textColor={0,134,134},
          textString="S")}));
end SolidWithTemperatureVariantHeatCapacity;
