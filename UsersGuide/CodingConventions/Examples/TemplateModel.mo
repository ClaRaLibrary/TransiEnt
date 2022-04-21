within TransiEnt.UsersGuide.CodingConventions.Examples;
partial model TemplateModel "Template for models with structure of code and documentation"



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
  //import SI = Modelica.SIunits;
  import Const = Modelica.Constants;

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

  // comment: place all instances with prefixes "constant parameter",
  // "final parameter" an "parameter" public and protected

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // comment: place all inner or outer global setup models here
  outer TransiEnt.SimCenter simCenter;

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // comment: place all instances of models of type "connector" here


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // comment: place all instances of models of type "model" here

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // comment: place all instances of type "Type" without prefixes "parameter"
  // or "constant" here

  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________

  //   protected
  //   function plotResult
  //   constant String resultFileName = "InsertModelNameHere.mat";
  //   algorithm
  //     TransiEnt.Basics.Functions.plotResult(resultFileName);
  //     createPlot(...); // obtain content by calling function plotSetup() in the commands window
  //     //add ,filename=resultFileName at the end of first createPlot command
  //   end plotResult;

  // only for plotResult protected function

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description) </p>
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
<p>[1] L. Andresen, P. Dubucq, R. Peniche, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Status of the TransiEnt Library: Transient simulation of coupled energy networks with high share of renewable energy,&rdquo; in <i>Proceedings of the 11th International Modelica Conference</i>, 2015, pp. 695&ndash;705.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Max Mustermann (mustermann@mustermail.com), Apr 2014</p>
</html>"));
end TemplateModel;
