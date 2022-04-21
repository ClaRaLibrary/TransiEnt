within TransiEnt.Basics.Icons;
partial model MethanationThreeStages



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  extends TransiEnt.Basics.Icons.Model
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));

  annotation (Icon(graphics={
        Line(
          points={{-86,44},{-58,44}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-58,48}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{-46,-40},{-44,-40},{-24,-40},{-24,44},{0,44}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{60,-40},{88,-40}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-66,36},{-66,-32},{-32,-32},{-32,36},{-66,36}}, color={28,108,200}),
        Line(points={{-14,36},{-14,-32},{20,-32},{20,36},{-14,36}}, color={28,108,200}),
        Line(points={{40,36},{40,-32},{74,-32},{74,36},{40,36}}, color={28,108,200}),
        Line(points={{-66,36},{-64,40},{-58,44},{-40,44},{-34,40},{-32,36}}, color={28,108,200}),
        Line(points={{-14,36},{-12,40},{-6,44},{12,44},{18,40},{20,36}}, color={28,108,200}),
        Line(points={{40,36},{42,40},{48,44},{66,44},{72,40},{74,36}}, color={28,108,200}),
        Line(
          points={{-17,-4},{-15,0},{-9,4},{9,4},{15,0},{17,-4}},
          color={28,108,200},
          origin={-49,-36},
          rotation=180),
        Line(
          points={{-17,-4},{-15,0},{-9,4},{9,4},{15,0},{17,-4}},
          color={28,108,200},
          origin={3,-36},
          rotation=180),
        Line(
          points={{-17,-4},{-15,0},{-9,4},{9,4},{15,0},{17,-4}},
          color={28,108,200},
          origin={57,-36},
          rotation=180),
        Line(points={{-66,36},{-32,-32},{-66,-32},{-32,36}}, color={28,108,200}),
        Line(points={{-14,36},{20,-32},{-14,-32},{20,36}}, color={28,108,200}),
        Line(points={{40,36},{74,-32},{40,-32},{74,36}}, color={28,108,200}),
        Line(
          points={{8,-40},{10,-40},{30,-40},{30,44},{54,44}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled})}));
end MethanationThreeStages;
