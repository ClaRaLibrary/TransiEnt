within TransiEnt.Basics.Interfaces.Electrical;
connector ElectricPowerOut=Modelica.Blocks.Interfaces.RealOutput (final quantity= "Power", final unit="W", displayUnit="W")
  "Output for power in W"
  annotation (Icon(graphics={             Polygon(
          points={{-104,104},{-104,-104},{104,0},{-104,104}},
          lineColor={0,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Interface for Electrical Power Output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no physical modeling)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: electric power in [W]</p>
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
