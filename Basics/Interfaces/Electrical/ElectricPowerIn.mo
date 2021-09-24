within TransiEnt.Basics.Interfaces.Electrical;
connector ElectricPowerIn=Modelica.Blocks.Interfaces.RealInput (final quantity= "Power", final unit="W", displayUnit="W")
  "Input for power in W"
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
    Polygon(
          fillColor={0,127,127},
          lineColor={0,127,127},
          fillPattern=FillPattern.Solid,
          points={{-104.0,104.0},{104.0,0.0},{-104.0,-104.0}})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Interface for Electrical Power Input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: electric power in [W]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This connector should only be used for electric powers (type consistency).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Ricardo Peniche (peniche@tuhh.de), Aug 2015</p>
</html>"));
