within TransiEnt.Components.Heat;
model HEX_ideal "Ideal static heat exchanger model"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  extends TransiEnt.Basics.Icons.Heat_Exchanger;


  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid water=simCenter.fluid1 "Heat carrier"
                   annotation (Dialog(group="Medium Definitions"));
  parameter Modelica.SIunits.PressureDifference Delta_p=1e4 "Constant Pressure loss (positive value means loss)";

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Modelica.SIunits.TemperatureDifference dT "Temperature difference of heating carrier";
  Modelica.SIunits.SpecificEnthalpy h_inflow=inStream(waterPortIn.h_outflow);
  Modelica.SIunits.EnthalpyFlowRate dH_flow_carrier "Enthalpy change of heat carrier";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=water) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=water) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport annotation (Placement(transformation(extent={{-10,88},{10,108}}), iconTransformation(extent={{-10,88},{10,108}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  TILMedia.VLEFluid_ph fluidIn(
    p=waterPortIn.p,
    h=inStream(waterPortIn.h_outflow),
    xi=inStream(waterPortIn.xi_outflow),
    vleFluidType=water)
    annotation (Placement(transformation(extent={{-84,8},{-64,-12}})));
  TILMedia.VLEFluid_ph fluidOut(
    p=waterPortIn.p,
    h=waterPortOut.h_outflow,
    xi=waterPortOut.xi_outflow,
    vleFluidType=water)
    annotation (Placement(transformation(extent={{66,8},{86,-12}})));

equation
  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  //Mass balance
  waterPortIn.m_flow + waterPortOut.m_flow = 0;
  inStream(waterPortIn.xi_outflow) = waterPortOut.xi_outflow;
  inStream(waterPortOut.xi_outflow) = waterPortIn.xi_outflow;

  //Impulse balance
  waterPortIn.p = waterPortOut.p+Delta_p;

  //Energy balance
  heatport.Q_flow + waterPortIn.m_flow*inStream(waterPortIn.h_outflow) + waterPortOut.m_flow*waterPortOut.h_outflow = 0;
  heatport.Q_flow + waterPortOut.m_flow*inStream(waterPortOut.h_outflow) + waterPortIn.m_flow*waterPortIn.h_outflow = 0;
  heatport.T = 273.15 "Dummy! No heat capacity!";

  dH_flow_carrier = waterPortIn.m_flow*(waterPortOut.h_outflow - inStream(waterPortIn.h_outflow));
  dT = fluidOut.T - fluidIn.T;

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________


  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{110,102},{110,102}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>Simple and static heat exchanger model with ideal heat transfer. </p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b> </p>
<p>A given heat <i>Q</i><sub>flow,in</sub> is ideally transferred to a medium (water) flow. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.) </p>
<p>Only applicable for heat transfer from heatport to medium. </p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b> </p>
<p>waterPortIn/Out - ports for heat carrier (water) </p>
<p>heatport - heat inpout port </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b> </p>
<p>(no elements) </p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b> </p>
<p>The heat is balanced by a static equation: </p>
<p><i>Q</i><sub>flow,in</sub> + <i>m</i><sub>flow</sub>(<i>h</i><sub>water,in</sub> - <i>h</i><sub>water,out</sub>) = 0. </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b> </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b> </p>
<p>Tested in check model &quot;TestHEX_ideal&quot;</p>
<p><b><span style=\"color: #008000;\">9. References</span></b> </p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b> </p>
<p>Created by Paul Kernstock (paul.kernstock@tuhh.de), Jun 2015 </p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Jul 2015 </p>
</html>"));
end HEX_ideal;
