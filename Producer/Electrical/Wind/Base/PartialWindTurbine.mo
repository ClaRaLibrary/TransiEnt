within TransiEnt.Producer.Electrical.Wind.Base;
partial model PartialWindTurbine "Base class for wind turbine models"

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

  extends TransiEnt.Producer.Electrical.Base.PartialElectricPowerPlant(
      P_el_n=
            simCenter.generationPark.P_el_n_WindOn,
      typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable,
      typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore,
       replaceable model ProducerCosts =
          TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOnshore
                                                                                              annotation (Dialog(group="Statistics")),
    collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Real height_data = 120 "height where wind velocity was measured"  annotation (Dialog(tab="Wind speed calculation"));
  parameter Real height_hub = 120 "height of hub of wind turbine" annotation (Dialog(tab="Wind speed calculation"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
  parameter Characteristics.RoughnessCharacteristics.OwnValue Roughness=TransiEnt.Producer.Electrical.Wind.Characteristics.RoughnessCharacteristics.OwnValue() "Roughness factor of ground for calculation of Wind velocity in different heights" annotation (__Dymola_choicesAllMatching=true,Dialog(tab="Wind speed calculation"));
  parameter Boolean use_v_wind_input = true "False, outer simCenter.ambientConditions will be used" annotation(Dialog(tab="Wind speed calculation"));
  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable "Type of energy resource for global model statistics" annotation (
    Dialog(group="Statistics"),
    HideResult=true,
    Placement(transformation(extent=100)));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.ActivePower P_el_is = -epp.P;

  Real v_windHub;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

protected
 TransiEnt.Basics.Interfaces.Ambient.VelocityIn v_wind_internal "Velocity of wind for internal usage";

public
  TransiEnt.Basics.Interfaces.Ambient.VelocityIn v_wind if  use_v_wind_input "current wind velocity" annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}),
                                                    iconTransformation(extent={{-100,50},
            {-78,72}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //Calculation of wind velocity in hub height via roughness length
  if height_data == height_hub then
     v_windHub = v_wind;
   else
     v_windHub = v_wind*Modelica.Math.log(height_hub/Roughness.RoughnessLength)/Modelica.Math.log(height_data/Roughness.RoughnessLength);
  end if;

  // parameter dependent wind v_wind source:
   connect(v_wind_internal, v_wind);
   if not use_v_wind_input then
     v_wind_internal = simCenter.ambientConditions.wind.value;
   end if;

  // _____________________________________________

    annotation (
              Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Ellipse(
          extent={{-49,60},{48,-37}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{-9,-59},{9,-65}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-1,14},{1,14},{4,20},{1,62},{-1,58},{-1,14}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,9},{2,-59}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder),
        Polygon(
          points={{-2,12},{-8,6},{-38,-12},{-42,-12},{-4,12},{-2,12}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{2,12},{8,6},{38,-12},{40,-12},{40,-10},{4,12},{2,12}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-3,14},{3,8}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-96,86},{-74,68}},
          lineColor={64,64,64},
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          textString="v_Wind")}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>v_wind: input for current wind velocity in [m/s]</p>
<p>epp: electric power port (choice of power port)</p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PartialWindTurbine;
