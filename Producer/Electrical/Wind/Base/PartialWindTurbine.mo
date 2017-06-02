within TransiEnt.Producer.Electrical.Wind.Base;
partial model PartialWindTurbine "Base class for wind turbine models"

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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Electrical.Base.PartialElectricPowerPlant(
      P_el_n=
            simCenter.generationPark.P_el_n_WindOn,
      typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable,
      typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore,
       replaceable model ProducerCosts =
          TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOnshore
                                                                                              annotation (Dialog(group="Statistics")));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Real height_data = 120 "height where wind velocity was measured"  annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real height_hub = 120 "height of hub of wind turbine" annotation (Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
  parameter Characteristics.RoughnessCharacteristics.OwnValue Roughness "Roughness factor of ground for calculation of Wind velocity in different heights";
  parameter Boolean use_v_wind_input = true "False, outer simCenter.ambientConditions will be used";
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
  Modelica.Blocks.Interfaces.RealInput v_wind_internal;

public
  Modelica.Blocks.Interfaces.RealInput v_wind if use_v_wind_input "current wind velocity" annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}),
                                                    iconTransformation(extent={{-100,50},
            {-78,72}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if height_data == height_hub then

  //Calculation of wind velocity in hub height via roughness length
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

    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{76,-22},{110,10}})),
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
            false, extent={{-100,-100},{100,100}}), graphics),                                                  choicesAllMatching,
              Documentation(info="<html>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
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
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"),      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
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
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
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
