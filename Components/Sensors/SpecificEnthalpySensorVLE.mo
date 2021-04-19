within TransiEnt.Components.Sensors;
model SpecificEnthalpySensorVLE

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


   // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

    extends ClaRa.Components.Sensors.vleSensorBase;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer flowDefinition=1 "Defines which flow direction is considered" annotation(Dialog(group="Fundamental Definitions"),choices(choice = 1 "both", choice = 2 "both, noEvent", choice = 3 "in -> out", choice = 4 "out -> in"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.SpecificEnthalpyOut h "Specific enthalpy" annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                                                                                               rotation=0), iconTransformation(extent={{100,-10},{120,10}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluid(
    p=inlet.p,
    h=if flowDefinition == 1 then actualStream(inlet.h_outflow) elseif flowDefinition == 2 then noEvent(actualStream(inlet.h_outflow)) elseif flowDefinition == 3 then inStream(inlet.h_outflow) else inStream(outlet.h_outflow),
    xi=if flowDefinition == 1 then actualStream(inlet.xi_outflow) elseif flowDefinition == 2 then noEvent(actualStream(inlet.xi_outflow)) elseif flowDefinition == 3 then inStream(inlet.xi_outflow) else inStream(outlet.xi_outflow),
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  h=fluid.h;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Text(
         extent={{-100,24},{100,-16}},
         lineColor={27,36,42},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
         textString="%name"),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if h > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" h ", realString(h/1e3, 1,1)+" kJ/kg")),
        Line(
          points={{-98,-100},{96,-100}},
          color={0,131,169},
          smooth=Smooth.None,
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">specific enthalpy sensor extended from ClaRa libraryand modified for use as specific enthalpy sensor</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>port: FluidPortIn</p>
<p>port:FluidPortOut</p>
<p>h: RealOutput for specific enthalpy in J/kg</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan Westphal (j.westphal@tuhh.de), Jun 2019</span></p>
</html>"));
end SpecificEnthalpySensorVLE;
