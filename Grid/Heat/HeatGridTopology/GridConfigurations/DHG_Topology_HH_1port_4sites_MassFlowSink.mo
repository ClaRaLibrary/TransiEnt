within TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations;
model DHG_Topology_HH_1port_4sites_MassFlowSink "Sink, 4 sites"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Grid.Heat.HeatGridTopology.Base.Partial_DHG_Topology_HH_1port_4sites;

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(
    p_const=20e5,
    T_const=120 + 273.15,
    m_flow_nom=15000/1000*3600) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,66})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(fluidPortWest, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{-216,-14},{-95,-14},{-95,56},{22,56}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortCenter, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{14,-84},{22,-84},{22,44},{22,56}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortEast, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{186,-108},{108,-108},{108,56},{22,56}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_pTxi.steam_a, fluidPortWUWSPS) annotation (Line(
      points={{22,56},{22,56},{22,44},{46,44},{46,-46},{70,-46}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Models the heat demand of the district heating grid in Hamburg as mass flow sink with 4 heat ports connected to the outside  (heat producers).</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortWest: inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortEast: inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortCenter: inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortWUWSPS: inlet</span></p>
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
end DHG_Topology_HH_1port_4sites_MassFlowSink;
