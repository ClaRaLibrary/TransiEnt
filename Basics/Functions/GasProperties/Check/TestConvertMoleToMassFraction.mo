within TransiEnt.Basics.Functions.GasProperties.Check;
model TestConvertMoleToMassFraction "Tester for convertMoleToMassFraction"
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
    extends TransiEnt.Basics.Icons.Checkmodel;

    parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var medium;

    parameter Modelica.SIunits.MolarMass M[medium.nc] = TransiEnt.Basics.Functions.GasProperties.getMolarMasses_fromRecord(medium.vleFluidNames);

    parameter Modelica.SIunits.MoleFraction x1[medium.nc-1] = {1,0,0};
    parameter Modelica.SIunits.MoleFraction x2[medium.nc-1] = {0.5,0.5,0};
    parameter Modelica.SIunits.MoleFraction x3[medium.nc-1] = {0.5,0,0.5};
    parameter Modelica.SIunits.MoleFraction x4[medium.nc-1] = {0,0,0};

  parameter Modelica.SIunits.MassFraction xi1[medium.nc-1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x1, M);
                                                                                                        //should return {1,0,0}
  parameter Modelica.SIunits.MassFraction xi2[medium.nc-1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x2, M);
                                                                                                        //should return {4/15, 11/15, 0}
  parameter Modelica.SIunits.MassFraction xi3[medium.nc-1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x3, M);
                                                                                                        //should return {}
  parameter Modelica.SIunits.MassFraction xi4[medium.nc-1]=TransiEnt.Basics.Functions.GasProperties.convertMoleToMassFraction(x4, M);
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
