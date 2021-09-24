within TransiEnt.Producer.Heat.Power2Heat;
package ElectricBoiler 


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//



    extends TransiEnt.Basics.Icons.Package;

annotation (Icon(graphics={
        Ellipse(
          extent={{-38,-26},{44,-68}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-38,76},{44,-50}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-38,98},{44,56}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{4,-24},{4,-78}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{4,24},{24,16},{-14,2},{22,-12},{4,-16},{4,-26}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134})}));
end ElectricBoiler;
