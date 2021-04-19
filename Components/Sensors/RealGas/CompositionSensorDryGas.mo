within TransiEnt.Components.Sensors.RealGas;
model CompositionSensorDryGas "One Port VLE Composition Sensor"

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

  extends TransiEnt.Components.Sensors.RealGas.Base.RealGas_SensorBase;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer compositionDefinedBy=1 "Output gives mass or mole fraction"  annotation(Dialog(group="Fundamental Definitions"),choices(choice = 1 "mass", choice = 2 "mole", __Dymola_radioButtons=true));
  parameter Integer indexWater=3 "Index number of the water in the fluid" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer flowDefinition=1 "Defines which flow direction is considered" annotation(Dialog(group="Fundamental Definitions"),choices(choice = 1 "both", choice = 2 "both, noEvent", choice = 3 "in -> out", choice = 4 "out -> in"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput fractionDry[medium.nc](
    final quantity=if compositionDefinedBy == 1 then "MassFraction" else "MoleFraction",
    final unit=if compositionDefinedBy == 1 then "kg/kg" else "mol/mol") "Fraction (mass or mole) of the dry gas in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
           0), iconTransformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluid(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=if flowDefinition == 1 then actualStream(gasPortIn.h_outflow) elseif flowDefinition == 2 then noEvent(actualStream(gasPortIn.h_outflow)) elseif flowDefinition == 3 then inStream(gasPortIn.h_outflow) else inStream(gasPortOut.h_outflow),
    xi=if flowDefinition == 1 then actualStream(gasPortIn.xi_outflow) elseif flowDefinition == 2 then noEvent(actualStream(gasPortIn.xi_outflow)) elseif flowDefinition == 3 then inStream(gasPortIn.xi_outflow) else inStream(gasPortOut.xi_outflow),
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
if compositionDefinedBy == 1 then
  fractionDry[1:medium.nc-1] = {fluid.xi[i]/(1-fluid.xi[indexWater]) for i in 1:medium.nc-1};
  fractionDry[medium.nc] = (1-sum(fluid.xi[i] for i in 1:medium.nc-1))/(1-fluid.xi[indexWater]);
else
  fractionDry[1:medium.nc-1] = {fluid.x[i]/(1-fluid.x[indexWater]) for i in 1:medium.nc-1};
  fractionDry[medium.nc] = (1-sum(fluid.x[i] for i in 1:medium.nc-1))/(1-fluid.x[indexWater]);
end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

 annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                     graphics={
       Polygon(
         points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
         lineColor={27,36,42},
         smooth=Smooth.Bezier,
         lineThickness=0.5),
       Text(
         extent={{-100,40},{100,0}},
         lineColor={27,36,42},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
          textString=""),
       Line(
         points={{80,0},{100,0}},
         color={27,36,42},
         smooth=Smooth.None),
       Text(
         extent={{-100,24},{100,-16}},
         lineColor={27,36,42},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
         textString="%name"),
       Line(
         points={{0,-40},{0,-100}},
         color={27,36,42},
         thickness=0.5,
         smooth=Smooth.None),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if fraction[end] > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" fraction[end] ", realString(fraction[end]*100, 1,2)+" %%")),
       Line(
         points={{-98,-100},{96,-100}},
         color={255,255,0},
         thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Composition sensor in dry gas for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Can only be used for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>GasPortIn, GasPortOut and RealOutput for the nc fraction of the medium. Mass or mole fractions can be displayed.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in check model &quot;TestRealGasSensors&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Lisa Andresen (andresen@tuhh.de) in Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adapted by Carsten Bode (c.bode@tuhh.de) in Nov 2016</span></p>
</html>"));
end CompositionSensorDryGas;
