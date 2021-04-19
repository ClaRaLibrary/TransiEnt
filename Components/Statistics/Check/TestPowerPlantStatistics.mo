within TransiEnt.Components.Statistics.Check;
model TestPowerPlantStatistics "Example of statistics of electric power plants"

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

  extends Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant conventionalTarget(k=-500e6)
    annotation (Placement(transformation(extent={{-86,-48},{-66,-28}})));
  Producer.Electrical.Conventional.Components.SecondOrderPlant conventional(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BrownCoal) annotation (Placement(transformation(extent={{-16,-34},{44,24}})));
  Producer.Electrical.Conventional.Components.SimplePowerPlant cogen(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal) annotation (Placement(transformation(extent={{-22,-134},{38,-76}})));
  Modelica.Blocks.Sources.Constant cogenTarget(k=-300e6)
    annotation (Placement(transformation(extent={{-80,-104},{-60,-84}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1(useInputConnector=false, f_set_const=50.01) annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
equation
  connect(conventionalTarget.y, conventional.P_el_set) annotation (Line(
      points={{-65,-38},{-32,-38},{-32,60},{6,60},{6,20},{9.5,20},{9.5,23.71}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(constantFrequency_L1_1.epp, conventional.epp) annotation (Line(
      points={{90,-40},{64.95,-40},{64.95,15.3},{41,15.3}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(constantFrequency_L1_1.epp, cogen.epp) annotation (Line(
      points={{90,-40},{90,-79.05},{35,-79.05},{35,-84.7}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(cogenTarget.y, cogen.P_el_set) annotation (Line(points={{-59,-94},{-52,-94},{-52,-86},{-50,-86},{-50,-62},{3.5,-62},{3.5,-76.29}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,100}})),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-160},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end TestPowerPlantStatistics;
