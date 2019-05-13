within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CollectHeatingPower "collect heating power and energy, choose type of resource"

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

  import TransiEnt;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  constant Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  //parameter Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Boolean integrateHeatFlow=simCenter.integrateHeatFlow "true if heat flows shall be integrated";
  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=EnergyResource.Generic "Select the kind of resource" annotation (choices(
      choice=TransiEnt.Basics.Types.TypeOfResource.Consumer "Consumer",
      choice=TransiEnt.Basics.Types.TypeOfResource.Conventional "Conventional",
      choice=TransiEnt.Basics.Types.TypeOfResource.Cogeneration "Cogeneration",
      choice=TransiEnt.Basics.Types.TypeOfResource.Renewable "Renewable",
      choice=TransiEnt.Basics.Types.TypeOfResource.Generic "Generic"), Dialog(enable=is_setter));
  //One could add "Losses"!?

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.HeatFlowCollector heatFlowCollector annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Energy E(start=0,fixed=true, stateSelect=StateSelect.never)
                                                                annotation (Dialog(group="Initialization", showStartAttribute=true));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if integrateHeatFlow then
    der(E)=heatFlowCollector.Q_flow;
  else
    E=0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),             Polygon(
          visible=not is_setter,
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          origin={3,-37},
          rotation=180),
        Ellipse(
          visible=not is_setter,
          extent={{-34,80},{32,16}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,69},{-14,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{14,69},{4,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-16,51},{-26,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{12,29},{2,39}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{26,51},{16,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,33},{-14,23}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{4,53},{-6,43}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,98},{100,132}},
          lineColor={62,62,62},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          textString="%name"),            Polygon(
          points={{-10,70},{-10,-8},{-46,-8},{4,-76},{46,-8},{12,-8},{12,70},{8,70},{-10,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-14,68},{-14,-10},{-50,-10},{0,-78},{42,-10},{8,-10},{8,68},{4,68},{-14,68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>model for collecting heating power and energy</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CollectHeatingPower;
