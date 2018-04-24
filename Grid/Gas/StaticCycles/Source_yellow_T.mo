within TransiEnt.Grid.Gas.StaticCycles;
model Source_yellow_T "Yellow boundary"

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
  // yellow output: Value m_flow is unknown and provided BY neighbor component, values of p, h and xi are set or computed internally and provided FOR neighbor component.

  import TransiEnt;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used";

  parameter SI.Pressure p=simCenter.p_eff_2+simCenter.p_amb_const "Pressure at the source";
  parameter SI.Temperature T=simCenter.T_ground "Temperature at the source";
  parameter SI.MassFraction xi[medium.nc-1]=medium.xi_default "Mass specific composition at the source";

  final parameter SI.MassFlowRate  m_flow(fixed = false) "Outlet mass flow rate";
  final parameter SI.SpecificEnthalpy h = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
    vleFluidType=medium,
    p=p,
    T=T,
    xi=xi) "Outlet specific enthalpy";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_yellow outlet(
    Medium=medium,
    h=h,
    p=p,
    xi=xi) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={106,0}), iconTransformation(
        extent={{-7,-18},{7,18}},
        rotation=90,
        origin={69,0})));

initial equation
    m_flow= outlet.m_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-60,60},{60,60},{60,-60},{-60,-60},{-60,60}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-52,60},{34,24}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p"),
        Text(
          extent={{-60,92},{60,58}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="SOURCE"),
        Text(
          extent={{-52,18},{36,-18}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%T"),
        Text(
          extent={{-54,-22},{36,-60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi")}),              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Source with yellow output, defining m_flow, T, xi.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end Source_yellow_T;
