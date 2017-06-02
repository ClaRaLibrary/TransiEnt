within TransiEnt.Basics.Media.Gases;
record VLE_VDIWA_NG7_SG_var "var{CH4,C2H6,C3H8,C4H10,N2,CO2,H2O,CO,H2} VDIWA"

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

  extends TILMedia.VLEFluidTypes.BaseVLEFluid(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=9,
    final vleFluidNames={"VDIWA2006.Methane(REF=STP)","VDIWA2006.Ethane","VDIWA2006.Propane","VDIWA2006.Butane","VDIWA2006.Nitrogen","VDIWA2006.Carbon Dioxide","VDIWA2006.Water","VDIWA2006.Carbon Monoxide","VDIWA2006.Hydrogen"},
    final mixingRatio_propertyCalculation={0.7243,0.139,0.068,0.0185,0.0268,0.0234,0.0,0.0,0.0});
end VLE_VDIWA_NG7_SG_var;
