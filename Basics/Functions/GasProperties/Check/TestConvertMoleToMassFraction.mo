within TransiEnt.Basics.Functions.GasProperties.Check;
model TestConvertMoleToMassFraction "Tester for convertMoleToMassFraction"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//



    extends TransiEnt.Basics.Icons.Checkmodel;

    parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var medium;

  parameter Modelica.Units.SI.MolarMass M[medium.nc]=TransiEnt.Basics.Functions.GasProperties.getMolarMasses_fromRecord(medium.vleFluidNames);

  parameter Modelica.Units.SI.MoleFraction x1[medium.nc - 1]={1,0,0};
  parameter Modelica.Units.SI.MoleFraction x2[medium.nc - 1]={0.5,0.5,0};
  parameter Modelica.Units.SI.MoleFraction x3[medium.nc - 1]={0.5,0,0.5};
  parameter Modelica.Units.SI.MoleFraction x4[medium.nc - 1]={0,0,0};

  parameter Modelica.Units.SI.MassFraction xi1[medium.nc - 1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x1, M);
                                                                                                        //should return {1,0,0}
  parameter Modelica.Units.SI.MassFraction xi2[medium.nc - 1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x2, M);
                                                                                                        //should return {4/15, 11/15, 0}
  parameter Modelica.Units.SI.MassFraction xi3[medium.nc - 1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x3, M);
                                                                                                        //should return {}
  parameter Modelica.Units.SI.MassFraction xi4[medium.nc - 1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x4, M);
                                                                                                        //should return {0,0,0}
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for converting mole to mass fraction</p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Jahneke (philipp.koziol@tuhh.de), Jul 2018</p>
</html>"));
end TestConvertMoleToMassFraction;
