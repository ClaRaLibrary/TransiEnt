within TransiEnt.Basics.Icons;
partial model ElectricSubModel "Icon for electric sub models"


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





  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Line(origin={1,52}, points={{-61.0,-45.0},{-61.0,-10.0},{-26.0,-10.0}}),
        Rectangle(origin={20.3125,84.857}, extent={{-45.3125,-57.8571},{4.6875,
              -27.8571}}),
        Line(origin={7,52}, points={{18.0,-10.0},{53.0,-10.0},{53.0,-45.0}}),
        Line(origin={9,56},  points={{31.0,-49.0},{71.0,-49.0}}),
        Line(origin={8,50},  points={{32.0,-58.0},{72.0,-58.0}}),
        Line(origin={6.2593,50}, points={{53.7407,-58.0},{53.7407,-93.0},{-66.2593,
              -93.0},{-66.2593,-58.0}}),
        Line(origin={-3,47}, points={{-72.0,-55.0},{-42.0,-55.0}}),
        Line(origin={-2,57},points={{-83.0,-50.0},{-33.0,-50.0}})}),
                                            Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model created for using the icon</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"color: #008000;\">(no remarks)</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end ElectricSubModel;
