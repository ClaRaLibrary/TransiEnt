within TransiEnt.Consumer.Heat.SpaceHeating.Base;
record ThermodynamicProperties
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
  extends TransiEnt.Basics.Icons.Record;

  parameter Real q_i(unit="W/(m2)", min=0)=5 "internal heat sources in W/m"  annotation(Dialog(group="General Asumptions"));
  parameter Real n_min = 0.7 "minimum needed air change rate"  annotation(Dialog(group="General Asumptions"));
  parameter Modelica.SIunits.Density rho_air= 1.2041 "Density of air 20C and 1bar"  annotation(Dialog(group="General Asumptions"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp_air=1.005e3 "specific heat capacity of air"   annotation(Dialog(group="General Asumptions"));

  parameter Real cp_ext(unit="J/(m3.K)",min=0)=50*3600 "Heat storage capacity of external walls"  annotation(Dialog(group="Heat transfer and storage"));
  parameter Real cp_int(unit="J/(m3.K)",min=0)=8*3600 "Heat storage capacity of internal walls" annotation(Dialog(group="Heat transfer and storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_ext=0.4 "Heat transfer coefficient of external walls" annotation(Dialog(group="Heat transfer and storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_roof=0.2 "Heat transfer coefficient of roof" annotation(Dialog(group="Heat transfer and storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  alpha_roomWall = 8 "coefficient of heat transfer from the the air in the room to the walls (typical values 6-8W/mK) for static air"
                                                                                                    annotation(Dialog(group="Heat transfer and storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  alpha_wallAmbiance = 15 "coefficient of heat transfer from the wall to the environement" annotation(Dialog(group="Heat transfer and storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  alpha_groundsurface = 10 "coefficient of heat transfer from the surface of the ground to the room (can be 10W/mK)"
                                                                                                    annotation(Dialog(group="Heat transfer and storage"));

end ThermodynamicProperties;
