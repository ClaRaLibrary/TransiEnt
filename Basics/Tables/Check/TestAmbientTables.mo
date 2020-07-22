within TransiEnt.Basics.Tables.Check;
model TestAmbientTables "Model for testing ambient tables"
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
  inner Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Ambient.GHI_Hamburg_3600s_2012_TMY gHI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-40,36},{-20,56}})));
  Ambient.DNI_Hamburg_3600s_2012_TMY dNI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-58,6},{-38,26}})));
  Ambient.DHI_Hamburg_3600s_2012_TMY dHI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-86,-30},{-66,-10}})));
  Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012
    wind_Hamburg_Fuhlsbuettel_3600s_2012_1
    annotation (Placement(transformation(extent={{14,38},{34,58}})));
  Ambient.Wind_Hamburg_3600s_TMY wind_Hamburg_3600s_TMY
    annotation (Placement(transformation(extent={{14,4},{34,24}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for ambient tables</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p><b><span style=\"color: #008000;\">10. Version Histor</span></b>y</p>
</html>"));
end TestAmbientTables;
