within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1;
package ADM1_Units


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
      Polygon(
        points={{-36,26},{-30,32},{8,-30},{0,-30},{-36,26}},
        lineColor={64,64,64},
        smooth=Smooth.None,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-56,6},{-56,16},{-6,66},{-6,56},{-56,6}},
        lineColor={64,64,64},
        smooth=Smooth.None,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-64,88},{-56,-30}},
        lineColor={64,64,64},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{32,36},{68,-18}},
        lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{22,46},{78,-28}},
        lineColor={64,64,64},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{78,12},{78,-36},{74,-50},{68,-58},{58,-62},{28,-62},{28,-54},{
            56,-54},{64,-50},{68,-44},{70,-36},{70,-16},{74,-10},{78,4},{78,12}},
        lineColor={64,64,64},
        smooth=Smooth.Bezier,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{32,36},{68,-18}},
        lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end ADM1_Units;
