within TransiEnt.Components.Electrical.PowerTransformation.Components;
model PiModelTransformerComplexComponent


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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







  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________


  extends TransiEnt.Components.Electrical.Grid.Base.PartialTwoPortAdmittanceComplex(
                                                                          Y_11=1/(2*j_comp*X_h)+1/(2*R_Fe)+1/(j_comp*X_sigma+R_Cu), Y_12=-1/(j_comp*X_sigma+R_Cu));

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

protected
constant Complex j_comp(re=0,im=1) annotation(Dialog(enable=false));

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

public
  parameter Modelica.Units.SI.Reactance X_h=80e3;
  parameter Modelica.Units.SI.Resistance R_Cu=2;
  parameter Modelica.Units.SI.Reactance X_sigma=35;
  parameter Modelica.Units.SI.Resistance R_Fe=400e3;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-92,0},{-58,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
                             Ellipse(
          extent={{-24,36},{50,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-58,36},{16,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-82,14},{-72,0}},
          lineColor={0,128,0},
          textString="1"),
        Text(
          extent={{68,14},{78,0}},
          lineColor={0,128,0},
          textString="2")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">pi model of Transformer without voltage ratio for use with SimpleTransformerComplex</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-Stationary transformer model of two port with concentrated elements. Active- and reactive power (losses) are regarded. Electrical Pi-network.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasi-stationary model, model of transformer with concentrated elements, limited by the wavelength of the 50 Hz oscillation </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two ComplexPowerPort for each terminal of the two port model</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boolean input for switching</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>U is uses for voltages</p>
<p>P is used for active powers</p>
<p>S is used for apparent powers</p>
<p>I is used for electric currents</p>
<p>Q is used for reactive powers</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two-Port Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use as partial model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2019</span></p>
</html>"));
end PiModelTransformerComplexComponent;
