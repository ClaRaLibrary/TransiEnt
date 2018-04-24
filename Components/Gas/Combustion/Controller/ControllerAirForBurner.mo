within TransiEnt.Components.Gas.Combustion.Controller;
model ControllerAirForBurner "Controller to control the mass flow of the air source for the burner"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_CH4=0.01604 "Molar mass of methane";
  constant SI.MolarMass M_C2H6=0.03007 "Molar mass of ethane";
  constant SI.MolarMass M_C3H8=0.04410 "Molar mass of propane";
  constant SI.MolarMass M_C4H10=0.05812 "Molar mass of butane";
  constant SI.MolarMass M_O2=0.03200 "Molar mass of oxygen";
  constant SI.MolarMass M_CO=0.02801 "Molar mass of carbonmonoxide";
  constant SI.MolarMass M_H2=0.00202 "Molar mass of hydrogen";

  constant SI.MassFraction xi_O2_air=0.233 "Mass fraction of oxygen in air (that consists only of n2 and o2)";

  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_O2_var vle_ng7_sg_o2 "Medium to be used";
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real lambda=1.1 "Excess air ratio" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput massComposition[vle_ng7_sg_o2.nc](
    final quantity="MassFraction",
    final unit="kg/kg") "Mass composition of the fuel in vle_ng7_sg_o2"                             annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealInput m_flow_fuel(
    final quantity="MassFlowRate",
    final unit="kg/s") "Fuel mass flow rate" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100}),                                                                                                    iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_air_source(
    final quantity="MassFlowRate",
    final unit="kg/s") "Air mass flow rate for given lambda, negative because it is an input for a mass flow source"
                                                                                                    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow_o2_stoch "Oxygen mass flow rate for stochiometric combustion";
  SI.MassFlowRate m_flow_air_stoch "Air mass flow rate for stochiometric combustion";
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow_o2_stoch = -M_O2*m_flow_fuel*(1/2*massComposition[8]/M_CO+1/2*massComposition[10]/M_H2+2*massComposition[1]/M_CH4+7/2*massComposition[2]/M_C2H6+5*massComposition[3]/M_C3H8+13/2*massComposition[4]/M_C4H10);
  m_flow_air_stoch = m_flow_o2_stoch/xi_O2_air;
  m_flow_air_source = m_flow_air_stoch*lambda;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the air mass flow for given fuel mass flow rate and composition as well as air excess ratio. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The composition and mass flow rate of the fuel are measured and the necessary air is calculated. For the mass fraction of oxygen in air, 0.233 is assumed. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>The validity is limited because the composition is measured ideally and continuously which is not possible in reality. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>m_flow_fuel: input for the fuel mass flow rate </p>
<p>massComposition: input for the mass fractions of the fuel </p>
<p>m_flow_air_source: output for the air mass flow rate (negative sign) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The minimum oxygen mass flow for a stochiometric complete combustion is calculated according to the reactions of the components CO, H2, CH4, C2H6, C3H8, C4H10. The hyperstochiometric air mass flow is calculated by dividing the minimum oxygen mass flow by the mass fraction of oxygen in air and multiplying it with the excess air ratio.</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end ControllerAirForBurner;
