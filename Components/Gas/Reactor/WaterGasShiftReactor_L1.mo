within TransiEnt.Components.Gas.Reactor;
model WaterGasShiftReactor_L1 "Performs ideal water gas shift reaction with given conversion"

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

  extends Base.PartialFixedBedReactorRealGas_L1(
    redeclare final Basics.Media.Gases.VLE_VDIWA_SG6_var medium,
    pressureLoss=3.5e5,
    final N_reac=1,
    final Delta_H={-41150});
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_CO2=0.04401 "Molar mass of CO2";
  constant SI.MolarMass M_H2O=0.01802 "Molar mass of H2O";
  constant SI.MolarMass M_H2=0.00202 "Molar mass of H2";
  constant SI.MolarMass M_CO=0.02801 "Molar mass of CO";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real conversion=0.97 "Conversion rate of CO" annotation(Dialog(group="Fundamental Definitions")); //Twigg, M. V., & Twigg, M. V. (Eds.). (1989). Catalyst handbook. London: Wolfe. pages 285 and 342

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

  gasPortOut.xi_outflow[1]=inStream(gasPortIn.xi_outflow[1]); //CH4
  gasPortOut.xi_outflow[2]=inStream(gasPortIn.xi_outflow[2])+conversion*inStream(gasPortIn.xi_outflow[5])*M_CO2/M_CO; //CO2
  gasPortOut.xi_outflow[3]=max(0,inStream(gasPortIn.xi_outflow[3])-conversion*inStream(gasPortIn.xi_outflow[5])*M_H2O/M_CO); //H2O //max insures that gasPortOut.xi_outflow[3] is never negative (would be possible for insufficient steam supply)
  gasPortOut.xi_outflow[4]=inStream(gasPortIn.xi_outflow[4])+conversion*inStream(gasPortIn.xi_outflow[5])*M_H2/M_CO; //H2
  gasPortOut.xi_outflow[5]=(1-conversion)*inStream(gasPortIn.xi_outflow[5]); //CO

  Q_reac=conversion*inStream(gasPortIn.xi_outflow[5])*gasPortIn.m_flow/M_CO*Delta_H[1];

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          textString="WGS")}),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a simple adiabatic water gas shift reactor with no volume in which CO reacts with steam to CO2 and H2. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The CO conversion rate, i.e. the share of the CO that reacts, is given by a constant parameter. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>The model is only valid if the share of CO, that reacts, is not constant. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Stationary mass and energy balances considering the heat of reactions are used. The outlet composition is calculated depending on the incoming composition and the CO conversion rate. </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The model only works in design flow direction and it has to be ensured manually that enough steam is in the incoming stream. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end WaterGasShiftReactor_L1;
