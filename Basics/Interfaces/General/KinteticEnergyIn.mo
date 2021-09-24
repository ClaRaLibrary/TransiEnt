within TransiEnt.Basics.Interfaces.General;
connector KinteticEnergyIn=Modelica.Blocks.Interfaces.RealInput(final quantity= "KineticEnergy", final unit="J", displayUnit="J")
  "Input for kinetic energy in J"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Polygon(
      lineColor={0,0,127},
      fillColor={0,0,127},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}), Diagram(graphics,
                                                                      coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Extends the MSL RealInput Connector by defining the quantity, unit and display unit.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: kinetic energy in [J]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This connector should only be used for kinetic energies (type consistency).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Westphal (j.westphal@tuhh.de), August 2018</p>
</html>"));
