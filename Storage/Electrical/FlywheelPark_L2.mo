within TransiEnt.Storage.Electrical;
model FlywheelPark_L2 "a park of flywheels, choose number of units, LA"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Flywheel;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter Integer nFlywheels=2 "Number of Flywheels";
  parameter TransiEnt.Storage.Electrical.Specifications.DetailedFlywheel.GenericFlywheelRecord params "Model to use" annotation (choicesAllMatching);
  parameter Real k=2e6 "Power per Hz deviation (complete Park)";
  parameter Real SOC_Start=0.7 "State of Charge init value";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  TransiEnt.Storage.Electrical.FlywheelStorage_L2 flywheels[nFlywheels](
    each K=k/nFlywheels,
    each params=params,
    each E_start=SOC_Start*params.E_max) annotation (Placement(transformation(extent={{-28,-32},{42,32}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealOutput SOC
    annotation (Placement(transformation(extent={{-90,10},{-110,-10}})));
equation
  for i in 1:nFlywheels loop
    connect(flywheels[i].epp,epp);
  end for;
  connect(flywheels[1].SOC, SOC) annotation (Line(
      points={{-24.5,0},{-100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{40,108},{-38,62}},
          lineColor={0,0,0},
          textString="n")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model for a&nbsp;park&nbsp;of&nbsp;flywheels,&nbsp;choose&nbsp;number&nbsp;of&nbsp;units.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model created by Arne Koeppen (arne.koeppen@tuhh.de), Jul 2014</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model edited by Lisa Andresen (andresen@tuhh.de), Aug 2014</span></p>
</html>"));
end FlywheelPark_L2;
