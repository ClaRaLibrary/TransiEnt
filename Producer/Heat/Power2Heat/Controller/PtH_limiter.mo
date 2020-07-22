within TransiEnt.Producer.Heat.Power2Heat.Controller;
model PtH_limiter "Dispatcher for Power to Heat units"
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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_PtH "Heat flow rate output set value" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-104}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set_demand "Set value of demanded heat flow rate"  annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,114}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_RE_curtail "Electric power input" annotation (Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

 parameter Modelica.SIunits.HeatFlowRate  Q_flow_PtH_max=650e6 "maximum heating capacity of the PtH device";
 parameter Modelica.SIunits.HeatFlowRate Q_flow_BP_min=0 "minimum heat flow of CHP-plant's back pressure mode"; //in development

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
 Integer OpMode;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

     if P_RE_curtail>=Q_flow_set_demand then //if RE curtailed is larger or equal to the heat demand
        if Q_flow_set_demand<Q_flow_BP_min then //if site's heat demand is bellow the minimum backpressure heat limit
           Q_flow_set_PtH=0; //don't produce anything with the ptH unit
           OpMode=0;
         else
         Q_flow_set_PtH=Q_flow_set_demand;
         OpMode=1;
        end if;
     else //if RE curtailed is smaller than the heat demand
       if P_RE_curtail>=Q_flow_PtH_max then
         Q_flow_set_PtH=Q_flow_PtH_max;   //limit the PtH output
         OpMode=3;
       else
         if Q_flow_set_demand<Q_flow_BP_min then //if site's heat demand is bellow the minimum backpressure heat limit
           Q_flow_set_PtH=0; //don't produce anything with the ptH unit
           OpMode=0;
         else
           Q_flow_set_PtH=P_RE_curtail;
           OpMode=4;
         end if;
       end if;
     end if;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">This component calculates the set point of the heat production of a Power to Heat unit.</span></p>
<p><span style=\"font-family: Arial,sans-serif;\">It takes as inputs the set value of the heat production site where the PtH unit is installed and the excess RE available.</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Validation not required.</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Inputs: RE_curtail, Q_flow_set_demand</span></p>
<p><span style=\"font-family: Arial,sans-serif;\">Outputs: Q_flow_set_PtH</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">(no elements)</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">6. Governing Equations</span></b></p>
<p><img src=\"modelica://TransiEnt/Images/PtHLimiter.jpg\"/></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>This component can be used if the available otherwise curtailed renewable energy production is known in advance. Besides, the heat production profile to be convered by the heat production site should also be known.</p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">8. Validation</span></b></p>
<p>See test model: TransiEnt.Producer.Heat.Power2Heat.Check.TestPtH_limiter</p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">none</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Ricardo Peniche 2016</span></p>
</html>"));
end PtH_limiter;
