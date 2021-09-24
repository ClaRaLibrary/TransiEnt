within TransiEnt.Components.Turbogroups.Base;
type GradientLimitingChoices = enumeration(
    NoLimiter "No gradient limiter is applied",
    GradLimInCntrl "The gradient is limited by slew rate limiter in controls (prev. default)",
    GradLimInFirstOrder "Gradient is limited in first order blocks - more efficient than option GradLimInCntrl") "Different option to limit the gradient in turbugroups" annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Provide different choices, how to limit the gradeint in a power plant</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight, defining nothing but the interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Robert Flesch (flesch@xrg-simulation.de), Feb 2021</p>
</html>"));
