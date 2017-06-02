within TransiEnt.Components.Gas.VolumesValvesFittings;
model ThreeWayValveRealGas_L1_simple "Three way valve for one phase vle media | no reverse flow | works for zero flow | no pressure dependency |"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // modified component of the ClaRa library, version 1.0.0                    //
  // Path: ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple //
  // inlet h_outflow and xi_outflow are set to instreaming values of outlet1   //
  // outlet1.m_flow is set to zero for inlet.m_flow<eps                        //

  extends TransiEnt.Components.Gas.VolumesValvesFittings.Base.ThreeWayValve_base;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  parameter Real eps=1e-10 "Numerical Stability|Mass flow of outlet1 is set to zero for inlet mass flows below this value";

protected
  record Outline
    extends TransiEnt.Basics.Icons.Record;
    input Real splitRatio "Split ratio";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut1;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut2;
  end Summary;

public
  Summary summary(
    outline(splitRatio=splitRatio),
    gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut1(
      mediumModel=medium,
      xi=gasOut1.xi,
      x=gasOut1.x,
      m_flow=gasPortOut1.m_flow,
      T=gasOut1.T,
      p=gasPortOut1.p,
      h=gasOut1.h,
      rho=gasOut1.d),
    gasPortOut2(
      mediumModel=medium,
      xi=gasOut2.xi,
      x=gasOut2.x,
      m_flow=gasPortOut2.m_flow,
      T=gasOut2.T,
      p=gasPortOut2.p,
      h=gasOut2.h,
      rho=gasOut2.d)) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

equation
  // Pressure drop in design flow direction
  gasPortOut2.p = gasPortIn.p;

  // Isenthalpic state transformation (no storage and no loss of energy)
  gasPortIn.h_outflow = inStream(gasPortOut1.h_outflow);
  gasPortOut1.h_outflow = inStream(gasPortIn.h_outflow);
  gasPortOut2.h_outflow = inStream(gasPortIn.h_outflow);

  // mass balance (no storage)
  gasPortIn.m_flow + gasPortOut1.m_flow + gasPortOut2.m_flow = 0;
  if noEvent(gasPortIn.m_flow > eps) then
    -gasPortOut1.m_flow = splitRatio*gasPortIn.m_flow;
  else
    gasPortOut1.m_flow = 0;
  end if;

// No chemical reaction taking place:
  gasPortIn.xi_outflow = inStream(gasPortOut1.xi_outflow);
  gasPortOut1.xi_outflow = inStream(gasPortIn.xi_outflow);
  gasPortOut2.xi_outflow = inStream(gasPortIn.xi_outflow);

annotation (defaultComponentName="TWV",
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,80}},
        grid={2,2})),
          Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a three way valve for real gas flows. It works also for zero flow. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_L1_simple from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated and the valve works for zero flow. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Only valid if changes in density and the two-phase region of the fluid can be neglected.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The mass flow calculation for outlet 1 (eps is the smallest possible number in Modelica) and the composition calculation at the inlet ensure that there is no division by zero for zero mass flow at the inlet.</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation_TWVRealGas.png\" alt=\"\"/><br></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Sep 20 2016<br> </p>
</html>"));
end ThreeWayValveRealGas_L1_simple;
