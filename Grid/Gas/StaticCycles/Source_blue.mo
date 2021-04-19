within TransiEnt.Grid.Gas.StaticCycles;
model Source_blue "Blue boundary"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  // blue output: Value of p is unknown and provided BY neighbor component, values of m_flow, h and xi are set or computed internally and provided FOR neighbor component.

  import TransiEnt;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "General|Medium to be used";

  parameter SI.MassFlowRate m_flow "Mass flow rate at source";
  parameter SI.MassFraction xi[medium.nc-1]=zeros(medium.nc-1) "Mass specific composition at source";
  parameter Modelica.SIunits.Temperature T=simCenter.T_ground "Temperature at source";

  final parameter SI.SpecificEnthalpy h(fixed=false) "Specific enthalpy at source";

  final parameter SI.Pressure p(fixed = false) "Pressure at source";

  TransiEnt.Grid.Gas.StaticCycles.Base.FluidSignal_blue outlet(
    Medium=medium,
    m_flow=m_flow,
    xi=xi,
    h=h) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-94,0}), iconTransformation(
        extent={{-6,-14},{6,14}},
        rotation=90,
        origin={66,0})));

initial equation

    p = outlet.p;
    h = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
    vleFluidType=medium,
    p=p,
    T=T,
    xi=xi);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-60,60},{60,60},{60,-60},{-60,-60},{-60,60}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,54},{54,22}},
          lineColor={170,213,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow"),
        Text(
          extent={{-50,20},{50,-18}},
          lineColor={170,213,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h"),
        Text(
          extent={{54,44},{-56,108}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="SOURCE")}),           Diagram(graphics,
                                                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Source with blue output, defining m_flow, T, xi.</p>
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
end Source_blue;
