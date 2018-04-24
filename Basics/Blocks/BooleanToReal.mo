within TransiEnt.Basics.Blocks;
block BooleanToReal "Convert Boolean to Real signal (no event)"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Blocks.Interfaces.partialBooleanSI;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Real realTrue=1.0 "Output signal for true Boolean input";
  parameter Real realFalse=0.0 "Output signal for false Boolean input";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  y = if noEvent(u) then realTrue else realFalse;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block computes the output y as Real equivalent of the Boolean input u: </p>
<p>y = if u then realTrue else realFalse</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<p><b><span style=\"color: #008000;\">3. Limits of validity</span></b> </p>
<p>(Description) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Max Mustermann (mustermann@mustermail.com), Apr 2014 : short description of modification</p>
</html>"),
         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-86,92},{-6,10}},
          lineColor={255,0,255},
          textString="B"),
        Polygon(
          points={{-12,-46},{-32,-26},{-32,-36},{-64,-36},{-64,-56},{-32,-56},
              {-32,-66},{-12,-46}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127}),
        Text(
          extent={{8,-4},{92,-94}},
          textString="R",
          lineColor={0,0,127})}));
end BooleanToReal;