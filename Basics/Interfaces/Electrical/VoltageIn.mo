within TransiEnt.Basics.Interfaces.Electrical;
connector VoltageIn=Modelica.Blocks.Interfaces.RealInput (final quantity= "Voltage", final unit="V", displayUnit="V")
  "Input for voltage in V"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Polygon(
          fillColor={0,127,127},
          lineColor={0,127,127},
          fillPattern=FillPattern.Solid,
          points={{-104.0,104.0},{104.0,0.0},{-104.0,-104.0}})}), Diagram(graphics,
                                                                          coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Interface for voltage input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: voltage in [V]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This connector should only be used for voltages (type consistency).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Westphal (j.westphal@tuhh.de), August 2018</p>
</html>"));
