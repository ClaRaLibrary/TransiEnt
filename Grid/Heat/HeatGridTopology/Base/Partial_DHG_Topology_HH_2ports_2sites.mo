within TransiEnt.Grid.Heat.HeatGridTopology.Base;
partial model Partial_DHG_Topology_HH_2ports_2sites

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
  //                 Outer Models
  // _____________________________________________

 outer TransiEnt.SimCenter simCenter;
 outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

 parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
 parameter Modelica.SIunits.Length L_grid=800e3 "Grid length for cost calculations"
                                                                                   annotation(choicesAllMatching, Dialog(group="Costs parameters"));
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortWest(Medium=medium) annotation (Placement(transformation(extent={{-226,-24},{-206,-4}}), iconTransformation(extent={{-268,44},{-250,62}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortEast(Medium=medium) annotation (Placement(transformation(extent={{176,-118},{196,-98}}), iconTransformation(extent={{72,-30},{94,-8}})));

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  Modelica.Blocks.Sources.IntegerConstant noCellPerPipe(k=3) annotation (Placement(transformation(extent={{-440,396},{-420,416}})));

  Basics.Interfaces.Thermal.FluidPortOut fluidPortWestReturn(Medium=medium) annotation (Placement(transformation(extent={{-224,-70},{-204,-50}}), iconTransformation(extent={{-266,18},{-248,36}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortEastReturn(Medium=medium) annotation (Placement(transformation(extent={{178,-154},{198,-134}}), iconTransformation(extent={{72,-60},{94,-38}})));
  Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts_DHGrid(redeclare model CostRecordGeneral = Components.Statistics.ConfigurationData.GeneralCostSpecs.DistrictHeatingGrid (size1=L_grid))
                                                                                                                                    annotation (Placement(transformation(extent={{-400,396},{-380,416}})));

equation
    connect(modelStatistics.costsCollector, collectCosts_DHGrid.costsCollector);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-320},{500,420}})),
                                                 Icon(coordinateSystem(extent={{-440,-320},{500,420}},
                              preserveAspectRatio=false),
                                    graphics={
        Text(
          extent={{-444,482},{498,424}},
          lineColor={0,134,134},
          textString="%name"),                Bitmap(extent={{-438,-498},{500,600}},
                      fileName="modelica://TransiEnt/Images/simple_dhn_HH.png")}),
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
</html>"));
end Partial_DHG_Topology_HH_2ports_2sites;
