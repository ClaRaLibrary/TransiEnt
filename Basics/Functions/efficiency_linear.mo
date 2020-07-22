within TransiEnt.Basics.Functions;
function efficiency_linear "Approximizes efficiency between two defined points linearly"
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

  extends efficiency_base;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

// parameter Real m=(eta_nominal[1] -eta_nominal[2]) /(P_nominal[1] - P_nominal[2]) "slope between two points";
// parameter Real b= eta_nominal[1] - P_nominal[1]*m "konstant Coefficient";
// parameter Real Efficiency_min=eta_nominal[1];
// parameter Real Efficiency_max= eta_nominal[2];
protected
parameter Real m=(Efficiency_Mat[1,2]-Efficiency_Mat[2,2]) /(Efficiency_Mat[1,1] - Efficiency_Mat[2,2]) "slope between two points";
parameter Real b= Efficiency_Mat[1,2] - Efficiency_Mat[1,1]*m "konstant Coefficient";
parameter Real Efficiency_min=Efficiency_Mat[1,2];
parameter Real Efficiency_max= Efficiency_Mat[2,2];
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
input Real Efficiency_Mat[:,2];
//  input SI.Power P_nominal[:]={P_max,P_min} "Power output for three operating points";
//  input Real eta_nominal[:] = {eta_P_max,eta_P_min} "Efficiencies for three operating points";
//input Real[2] P={P_max,P_min} "It is usually the power vector with min and max power of the device in [W], it can be otherwise the backflow temperature for some devices"
//input Real[2] eta_P = {eta_P_max,eta_P_min} "Efficiency vector with min and max efficiency of the device" annotation(Dialog);
//  input Real P_max=18000;
//  input Real eta_P_max( min=0.01,max=1.12)=0.925;
//  input Real P_min=10;
//  input Real eta_P_min(min=0.01,max=1.12)=0.934;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
eta:=m*x + b;

// assert(eta_P[1]<=1.12,  "eta_P[1] invalid (>1.12)");
// assert(eta_P[1]>0.01, "eta_P[1] invalid (<0.01)");
// assert(eta_P[2]<=1.12,  "eta_P[2] invalid (>1.12)");
// assert(eta_P[2]>0.01, "eta_P[2] invalid (<0.01)");
assert(Efficiency_Mat[1,2]<=1.12,  "Efficiency_Mat[1,2] invalid (>1.12)");
assert(Efficiency_Mat[1,2]>0.01, "Efficiency_Mat[1,2] invalid (<0.01)");
assert(Efficiency_Mat[2,2]<=1.12,  "Efficiency_Mat[2,2] invalid (>1.12)");
assert(Efficiency_Mat[2,2]>0.01, "Efficiency_Mat[2,2] invalid (<0.01)");

                                                                                              annotation(Dialog,
              Documentation(info="<html>
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
