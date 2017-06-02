within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller;
model OC_SC_Controller

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

  extends TransiEnt.Basics.Icons.Controller;
  import TransiEnt;

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);

  Real SC = SC_R;
  Real OC = OC_R;
  Modelica.SIunits.MoleFraction X_ch4;
  Modelica.SIunits.MoleFraction X_h2o = SC*X_ch4;
  Modelica.SIunits.MoleFraction X_o2 = OC*X_ch4;
  Modelica.SIunits.MoleFraction X_n2 = X_o2*(0.795/0.205);
  Modelica.SIunits.MassFraction Xi_ch4 = X_ch4*NG.M_i[1]/(X_ch4*NG.M_i[1]+X_o2*NG.M_i[2]+X_h2o*NG.M_i[4]+X_n2*NG.M_i[7]);
  Modelica.SIunits.MassFraction Xi_o2 = X_o2*NG.M_i[2]/(X_ch4*NG.M_i[1]+X_o2*NG.M_i[2]+X_h2o*NG.M_i[4]+X_n2*NG.M_i[7]);
  Modelica.SIunits.MassFraction Xi_h2o = X_h2o*NG.M_i[4]/(X_ch4*NG.M_i[1]+X_o2*NG.M_i[2]+X_h2o*NG.M_i[4]+X_n2*NG.M_i[7]);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput OC_R annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,52}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-80,-32})));
  Modelica.Blocks.Interfaces.RealInput SC_R annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-80,48})));
  Modelica.Blocks.Interfaces.RealOutput Xi_Reformer[6] = {Xi_ch4,Xi_o2,0,Xi_h2o,0.00001,0} annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={106,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={102,4})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

 TILMedia.Gas_pT NG(
    p=1e5,
    T=25+273,
    xi= {0.1,0.1,0.1,0.1,0.1,0.1},
    gasType=Syngas)
    annotation (extent=[-20,20; 0,40], Placement(transformation(extent={{62,-12},
            {82,8}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   X_ch4+X_h2o+X_o2+X_n2= 1;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for mole fractions of CH4, O2 and H2O.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end OC_SC_Controller;
