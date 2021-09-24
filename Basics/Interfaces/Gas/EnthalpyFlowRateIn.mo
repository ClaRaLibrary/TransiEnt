within TransiEnt.Basics.Interfaces.Gas;
connector EnthalpyFlowRateIn=Modelica.Blocks.Interfaces.RealInput(final quantity= "EnthalpyFlowRate", final unit="W", displayUnit="W")
  "Input for enthalpy flow rate in W"
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Extends the MSL RealInput Connector by defining the quantity, unit and display unit. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: enthalpy flow rate in [W]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This connector should only be used for enthalpy flow rates (type consistency).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tu-harburg.de), Apr 2014</p>
</html>"), Icon(graphics={Polygon(
          points={{-104,104},{-104,-104},{104,0},{-104,104}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash)}));
