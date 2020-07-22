within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection;
model FreeConvectionHeatTransfer_Gas_horizontalDisc "heat transfer due to natural convection for a horizontal disc"


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

  extends FreeConvectionHeatTransfer_Gas(L=d/4, A=Modelica.Constants.pi*d^2/4);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Diameter d;

  parameter Boolean topside=true "true if heat transfer happens on the upper side and upward flow is not obstructed";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Boolean warmSurface=if dT > 0 then true else false "is true if surface is warmer then fluid";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  Nu = TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection.NusseltFreeConvection_horizontalSurface(
      abs(Ra),
      Pr,
      topside,
      warmSurface);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model contains the equation for calculating the nusselt number of a horizontal disc. It extends from FreeConvectionHeatTransfer_Gas.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
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
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end FreeConvectionHeatTransfer_Gas_horizontalDisc;