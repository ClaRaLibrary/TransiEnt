within TransiEnt.Components.Gas.VolumesValvesFittings.Valves;
model ThreeWayValveRealGas_L1_simple "Three way valve for one phase vle media | no reverse flow | works for zero flow | no pressure dependency |"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




  // modified component of the ClaRa library, version 1.3.0                    //
  // Path: ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple //
  // inlet h_outflow and xi_outflow are set to instreaming values of outlet1   //
  // outlet1.m_flow is set to zero for inlet.m_flow<eps                        //

  extends TransiEnt.Components.Gas.VolumesValvesFittings.Base.ThreeWayValve_base;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  parameter Real eps=1e-10 "Numerical Stability|Mass flow of outlet1 is set to zero for inlet mass flows below this value";

protected
  model Outline
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
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortIn.xi_outflow)),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=noEvent(actualStream(gasPortIn.h_outflow)),
      rho=gasIn.d),
    gasPortOut1(
      mediumModel=medium,
      xi=noEvent(actualStream(gasPortOut1.xi_outflow)),
      x=gasOut1.x,
      m_flow=gasPortOut1.m_flow,
      T=gasOut1.T,
      p=gasPortOut1.p,
      h=noEvent(actualStream(gasPortOut1.h_outflow)),
      rho=gasOut1.d),
    gasPortOut2(
      mediumModel=medium,
      xi=noEvent(actualStream(gasPortOut2.xi_outflow)),
      x=gasOut2.x,
      m_flow=gasPortOut2.m_flow,
      T=gasOut2.T,
      p=gasPortOut2.p,
      h=noEvent(actualStream(gasPortOut2.h_outflow)),
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
  Diagram(graphics,
          coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,80}},
        grid={2,2})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a three way valve for real gas flows. It works also for zero flow. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_L1_simple from ClaRa version 1.3.0. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated and the valve works for zero flow. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid if changes in density and the two-phase region of the fluid can be neglected.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>splitRatio_external: mass fraction in kg/kg</p>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortOut1: outlet for real gas</p>
<p>gasPortOut2: outlet for real gas</p>
<p>eye1</p>
<p>eye2</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The mass flow calculation for outlet 1 (eps is the smallest possible number in Modelica) and the composition calculation at the inlet ensure that there is no division by zero for zero mass flow at the inlet.</p>
<p><br><br><img src=\"modelica://TransiEnt/Images/equations/equation_TWVRealGas.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Sep 20 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (updated to ClaRa 1.3.0)</p>
</html>"),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,80}})));
end ThreeWayValveRealGas_L1_simple;
