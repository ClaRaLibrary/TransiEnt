within TransiEnt.Basics.Tables.ElectricGrid;
model SpotPriceElectricity_Phelix_3600s_2012 "Spotprice electricity - Day ahead market - Germany 2012"
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
  extends GenericDataTable(      relativepath="electricity/ElectricityPricesSpotMarket_3600s_2012.txt",
      datasource=DataPrivacy.isPublic)
    annotation (Placement(transformation(extent={{-18,-16},{16,16}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SpotPriceElectricity_Phelix_3600s_2012;
