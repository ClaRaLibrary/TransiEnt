within TransiEnt.Basics.Media.Gases;
record VLE_VDIWA_NG7_H2_SRK_var "var{CH4,C2H6,C3H8,C4H10,N2,CO2,H2} VDIWA SRK"

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

  //this model works with TILMedia 1.2.1
  extends TILMedia.VLEFluidTypes.BaseVLEFluid(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=7,
    final vleFluidNames={"VDIWA2006.Methane(EOS=SRK,REF=STP)","VDIWA2006.Ethane","VDIWA2006.Propane","VDIWA2006.Butane","VDIWA2006.Nitrogen","VDIWA2006.Carbon Dioxide","VDIWA2006.Hydrogen"},
    final mixingRatio_propertyCalculation={0.722090178,0.139591715,0.069014479,0.019245659,0.026650142,0.023407827,0.0});
end VLE_VDIWA_NG7_H2_SRK_var;
