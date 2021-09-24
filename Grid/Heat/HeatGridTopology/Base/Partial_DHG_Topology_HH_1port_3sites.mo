within TransiEnt.Grid.Heat.HeatGridTopology.Base;
partial model Partial_DHG_Topology_HH_1port_3sites


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
  parameter Modelica.Units.SI.Length L_grid=800e3 "Grid length for cost calculations" annotation (choicesAllMatching, Dialog(group="Costs parameters"));
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortWest(Medium=medium) annotation (Placement(transformation(extent={{-226,-24},{-206,-4}}), iconTransformation(extent={{-270,42},{-252,60}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortEast(Medium=medium) annotation (Placement(transformation(extent={{176,-118},{196,-98}}), iconTransformation(extent={{66,-30},{88,-8}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortCenter(Medium=medium) annotation (Placement(transformation(extent={{4,-94},{24,-74}}), iconTransformation(extent={{0,-10},{18,8}})));

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  Modelica.Blocks.Sources.IntegerConstant noCellPerPipe(k=3) annotation (Placement(transformation(extent={{-440,396},{-420,416}})));

  Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts_DHGrid(redeclare model CostRecordGeneral = Components.Statistics.ConfigurationData.GeneralCostSpecs.DistrictHeatingGrid(size1=L_grid),
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false)                                                                                                      annotation (Placement(transformation(extent={{-400,396},{-380,416}})));

equation
    connect(modelStatistics.costsCollector, collectCosts_DHGrid.costsCollector);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-320},{500,420}}),
                                      graphics), Icon(coordinateSystem(extent={{-440,-320},{500,420}},
                              preserveAspectRatio=false),
                                    graphics={Bitmap(extent={{-440,-490},{498,608}},
                      fileName="modelica://TransiEnt/Images/simple_dhn_HH.png"),
        Text(
          extent={{-444,482},{498,424}},
          lineColor={0,134,134},
          textString="%name")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Base model for district heating grid with 3 heat production sides.</span></p>
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
end Partial_DHG_Topology_HH_1port_3sites;
