within TransiEnt.Basics.Functions;
function efficiency_linear "Approximizes efficiency between two defined points linearly"
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

  extends efficiency_base;
input Real[2] P={P_max,P_min} "It is usually the power vector with min and max power of the device in [W], it can be otherwise the backflow temperature for some devices"
                                                                                              annotation(Dialog);
input Real[2] eta_P = {eta_P_max,eta_P_min} "Efficiency vector with min and max efficiency of the device" annotation(Dialog);
 input Real P_max=18000;
 input Real eta_P_max( min=0.01,max=1.12)=0.925;
 input Real P_min=10;
 input Real eta_P_min(min=0.01,max=1.12)=0.934;

protected
parameter Real m=(eta_P[1] -eta_P[2]) /(P[1] - P[2]) "slope between two points";
parameter Real b= eta_P[1] - P[1]*m "konstant Coefficient";
parameter Real Efficiency_min=eta_P[1];
parameter Real Efficiency_max= eta_P[2];

algorithm
eta:=m*x + b;

assert(eta_P[1]<=1.12,  "eta_P[1] invalid (>1.12)");
assert(eta_P[1]>0.01, "eta_P[1] invalid (<0.01)");
assert(eta_P[2]<=1.12,  "eta_P[2] invalid (>1.12)");
assert(eta_P[2]>0.01, "eta_P[2] invalid (<0.01)");

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Gives back linear approximation of efficiency defined by two points.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end efficiency_linear;
