within TransiEnt.Components.Boundaries.Gas;
model IdealGasCompositionByWtFractions "Boundary for ideal gas composition by mass fractions for variable number of elements"

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
  extends TransiEnt.Basics.Icons.TableIcon;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter TILMedia.GasTypes.BaseGas medium=simCenter.gasModel2;
  parameter SI.MassFraction[medium.nc - 1] xi_in "mass fraction vector of size(nc-1)";

  // _____________________________________________
  //
  //        Variable Declarations
  // _____________________________________________
  SI.MassFraction sumXi "control sum of set mass fractions";

  // _____________________________________________
  //
  //               Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealOutput xi[medium.nc - 1] = xi_in "composition of gas to be set"
                                   annotation (Placement(transformation(extent=
            {{100,0},{120,20}}), iconTransformation(extent={{80,-20},{120,20}})));

  // _____________________________________________
  //
  //        Characteristic Equations
  // _____________________________________________

algorithm
  for i in 1:1:size(xi_in, 1) loop
    sumXi := sumXi + xi_in[i];
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Define mass fractions of ideal gas composition.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>xi: RealOutput of mass fractions</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Apr 2014</p>
</html>"));
end IdealGasCompositionByWtFractions;