within TransiEnt.Basics.Media.Gases;
record VLE_VDIWA_NG7_H2_SRK_var "var{CH4,C2H6,C3H8,C4H10,N2,CO2,H2} VDIWA SRK"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  extends TILMedia.VLEFluidTypes.BaseVLEFluid(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=7,
    final vleFluidNames={"VDIWA2006.Methane(EOS=SRK,REF=STP)","VDIWA2006.Ethane","VDIWA2006.Propane","VDIWA2006.Butane","VDIWA2006.Nitrogen","VDIWA2006.Carbon Dioxide","VDIWA2006.Hydrogen"},
    final mixingRatio_propertyCalculation={0.722090178,0.139591715,0.069014479,0.019245659,0.026650142,0.023407827,0.0});
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains the mixing ratio of the Vapor-Liquid Equilibrium NG7_H2_SRK</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p><span style=\"color: #008000;\">(no remarks)</span></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end VLE_VDIWA_NG7_H2_SRK_var;
