within TransiEnt.Basics.Media;
model RealGasNCV_xi "Model for net calorific value calculation for real gases, input xi"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends TransiEnt.Basics.Icons.Model;
  extends TransiEnt.Basics.Media.Base.RealGas_MediaBaseNCV;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.SpecificEnthalpy NCV "Net calorific value";


equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //If NCVIn has a value except 0 (no variable NCV calculation) set NCV = NCVin
  if NCVIn <> 0.0 then
    NCV= NCVIn;
  else
    //Search for component in NCVComponentValues and add it to total NCV = sum(xi_i * NCV_i) and from (MJ/kg) to (J/kg) NCV
    NCV=sum(xi*NCV_vec);
  end if;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to calculate the mass specific net calorific value (NCV), also known as lower heating value (LHV) of a fuel gas mixture based on mass fractions and repective mass weighted calorific values from a record.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>xi_in is the mass fraction</p>
<p>NCV is the net calorific value</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in the gas which don&apos;t have a corresponding entry in the NCV values record, they will just be ignored, giving a faulty calorific value. The function will throw a warning.</p>
<p>NCVIn was added to give the possibility to define a constant calorific value. If this value is set to 0, the NCV will be calculated by the composition of the medium.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"), Icon(graphics={Text(
          extent={{-40,50},{44,-48}},
          lineColor={0,0,0},
          textString="Hi")}));
end RealGasNCV_xi;
