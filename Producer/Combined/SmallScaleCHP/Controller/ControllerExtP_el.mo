within TransiEnt.Producer.Combined.SmallScaleCHP.Controller;
model ControllerExtP_el "CHP Controller that sets plant to a given electric power"

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

  // _____________________________________________
  //
  //           Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartialCHPController;
  extends TransiEnt.Basics.Icons.Controller;

  import TransiEnt;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter Modelica.SIunits.Power P_const=nDevices*Specification.P_el_max "Constant Power";
  parameter Boolean use_P_in=true "Use external controller";
  parameter Integer nDevices=1 "number of Devices";

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
  Boolean offCondition(start=true);
  Boolean onCondition;
  // _____________________________________________
  //
  //                    Complex Components
  // _____________________________________________
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=Specification.P_el_min, uMax=
        nDevices*Specification.P_el_max)
    annotation (Placement(transformation(extent={{-4,0},{16,20}})));

  // _____________________________________________
  //
  //                    Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealInput P_el_set_external if use_P_in annotation (Placement(transformation(extent={{-112,-3},
            {-86,23}})));

  Modelica.Blocks.Interfaces.RealOutput t_running "total hours of operation of CHP"
    annotation (Placement(transformation(extent={{13,-13},{-13,13}},
        rotation=90,
        origin={-39,-99})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_meas_out "Produced heatflow rate"
    annotation (Placement(transformation(extent={{13,-13},{-13,13}},
        rotation=90,
        origin={-13,-99}), iconTransformation(
        extent={{13,-13},{-13,13}},
        rotation=90,
        origin={-10,-99})));
  Modelica.Blocks.Interfaces.RealOutput P_el_meas_out "Produced electric power"
    annotation (Placement(transformation(extent={{13,-13},{-13,13}},
        rotation=90,
        origin={19,-99})));
equation
  onCondition = P_el_set > Specification.P_el_min and (time-stopTime >= t_OnOff);
 offCondition = P_el_set<Specification.P_el_min+1 or T_return > T_return_max;

  if pre(switch) == false and pre(onCondition) then
    switch = true;
  elseif pre(switch) and pre(offCondition) then
    switch = false;
  else
    switch = pre(switch);
  end if;

  if not use_P_in then
    limiter.u = P_const;
  end if;

  connect(P_el_meas, P_el_meas_out);
  connect(Q_flow_meas, Q_flow_meas_out);

  connect(P_el_set_external, limiter.u) annotation (Line(
      points={{-99,10},{-6,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_set, limiter.y) annotation (Line(
      points={{80,10},{17,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow_meas_out, Q_flow_meas_out) annotation (Line(
      points={{-13,-99},{-13,-99}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timer.y, t_running) annotation (Line(
      points={{33,-10},{-39,-10},{-39,-99}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for external electrical power control of CHP.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
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
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end ControllerExtP_el;
