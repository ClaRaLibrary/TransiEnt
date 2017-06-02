within TransiEnt.Components.Gas.Reactor;
model Prereformer_L1 "Ideally transforms ethane, propane and butane with water into carbon monoxide and methane"

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

  extends Base.PartialFixedBedReactorRealGas_L1(
    redeclare final Basics.Media.Gases.VLE_VDIWA_NG7_SG_var medium,
    pressureLoss=2e5,
    final N_reac=3,
    final Delta_H={3.713e3, 16.687e3, 31.420e3});
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_comp[medium.nc-1] = {0.01604,0.03007,0.0441,0.05812,0.02801,0.04401,0.01802,0.02801} "Molar masses of components of vle_ng7_sg";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  gasPortOut.xi_outflow[1]=inStream(gasPortIn.xi_outflow[1])+M_comp[1]*(5/3*inStream(gasPortIn.xi_outflow[2])/M_comp[2]+7/3*inStream(gasPortIn.xi_outflow[3])/M_comp[3]+3*inStream(gasPortIn.xi_outflow[4])/M_comp[4]); //CH4
  gasPortOut.xi_outflow[2:4]=zeros(3); //C2H6,C3H8,C4H10
  gasPortOut.xi_outflow[5]=inStream(gasPortIn.xi_outflow[5]); //N2
  gasPortOut.xi_outflow[6]=inStream(gasPortIn.xi_outflow[6]); //CO2
  gasPortOut.xi_outflow[7]=max(0,inStream(gasPortIn.xi_outflow[7])-M_comp[7]*(1/3*inStream(gasPortIn.xi_outflow[2])/M_comp[2]+2/3*inStream(gasPortIn.xi_outflow[3])/M_comp[3]+1*inStream(gasPortIn.xi_outflow[4])/M_comp[4])); //H2O
  gasPortOut.xi_outflow[8]=inStream(gasPortIn.xi_outflow[8])+M_comp[8]*(1/3*inStream(gasPortIn.xi_outflow[2])/M_comp[2]+2/3*inStream(gasPortIn.xi_outflow[3])/M_comp[3]+1*inStream(gasPortIn.xi_outflow[4])/M_comp[4]); //CO

  Q_reac=sum(inStream(gasPortIn.xi_outflow[2:4]).*gasPortIn.m_flow./M_comp[2:4].*Delta_H[1:3]);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          textString="PreRe")}),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a simple adiabatic prereformer with no volume which decomposes the hydrocarbons C2H6, C3H8 and C4H10 with steam into CH4 and CO. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The higher hydrocarbons are decomposed completely, there are no reaction rates or equilibrium reactions. A constant pressure loss is assumed. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>The model is only valid if the remaining hydrocarbons are negligible. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Stationary mass and energy balances considering the heat of reactions are used. The outlet composition is calculated depending on the incoming composition. </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The model only works in design flow direction and it has to be ensured manually that enough steam is in the incoming stream. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end Prereformer_L1;