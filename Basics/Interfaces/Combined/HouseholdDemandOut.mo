within TransiEnt.Basics.Interfaces.Combined;
expandable connector HouseholdDemandOut "Connector for electricity, heating and domestic hot water demand"

  Electrical.ElectricPowerOut electricPowerDemand annotation (Placement(transformation(extent={{-24,20},{16,58}})));
  Thermal.HeatFlowRateOut heatingPowerDemand annotation (Placement(transformation(extent={{-24,-20},{16,20}})));
  Thermal.HeatFlowRateOut hotWaterPowerDemand annotation (Placement(transformation(extent={{-24,-60},{16,-20}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                          Polygon(
          points={{-98,100},{-98,-108},{110,-4},{-98,100}},
          lineColor={102,44,145},
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Connector&nbsp;for&nbsp;electricity,&nbsp;heating&nbsp;and&nbsp;domestic&nbsp;hot&nbsp;water&nbsp;demand</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</p>
</html>"));
end HouseholdDemandOut;
