within TransiEnt.Producer.Electrical.Wind.Base;
model RoughnessFilter "Filter to approximate wind speed at hub height dependent on height of wind measurement."
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                 Parameters
  // _____________________________________________

  parameter Real height_data = 120 "height where wind velocity was measured"  annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real height_hub = 120 "height of hub of wind turbine" annotation (Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
  parameter Characteristics.RoughnessCharacteristics.OwnValue Roughness "Roughness factor of ground for calculation of Wind velocity in different heights";
  parameter Boolean use_v_wind_input = true "False, outer simCenter.ambientConditions will be used";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

protected
  TransiEnt.Basics.Interfaces.Ambient.VelocityIn v_wind_internal;

public
  TransiEnt.Basics.Interfaces.Ambient.VelocityIn v_wind_m if
                                                 use_v_wind_input "measured wind velocity" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-100,-12},{-78,10}})));

public
  TransiEnt.Basics.Interfaces.Ambient.VelocityOut v_wind_hub if
                                                 use_v_wind_input "wind velocity at hub height" annotation (Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-12},{122,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if height_data == height_hub then

  //Calculation of wind velocity in hub height via roughness length
     v_wind_hub =v_wind_m;
   else
     v_wind_hub =v_wind_m*Modelica.Math.log(height_hub/Roughness.RoughnessLength)/Modelica.Math.log(height_data/Roughness.RoughnessLength);
  end if;

  // parameter dependent wind v_wind source:
  connect(v_wind_internal, v_wind_m);
   if not use_v_wind_input then
     v_wind_internal = simCenter.ambientConditions.wind.value;
   end if;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model to approximate wind speed at hub height dependent on height of wind measurement.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>v_wind_m: input for velocity of wind in m/s</p>
<p>v_wind_hub: output for velocity of wind in m/s</p>
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
<p>(no remarks)</p>
</html>"));
end RoughnessFilter;
